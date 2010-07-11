Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38439 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab0GKKcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:04 -0400
Received: by ewy23 with SMTP id 23so640225ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:02 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/17] rt2x00: Convert rt2x00 to use threaded interrupts
Date: Sun, 11 Jul 2010 12:26:48 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111225.47409.IvDoorn@gmail.com> <201007111226.13314.IvDoorn@gmail.com>
In-Reply-To: <201007111226.13314.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111226.49015.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Use threaded interrupts for all rt2x00 PCI devices.

This has several generic advantages:
- Reduce the time we spend in hard irq context
- Use non-atmic mac80211 functions for rx/tx

Furthermore implementing broad- and multicast buffering will be
much easier in process context while maintaining low latency and
updating the beacon just before transmission (pre tbtt interrupt)
can also be done in process context.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   54 ++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2500pci.c |   55 +++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   50 ++++++++++++++++++------
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +
 drivers/net/wireless/rt2x00/rt2x00.h    |   11 +++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   23 ++++++++++-
 drivers/net/wireless/rt2x00/rt2x00pci.c |    6 ++-
 drivers/net/wireless/rt2x00/rt2x00reg.h |    2 +
 drivers/net/wireless/rt2x00/rt61pci.c   |   64 +++++++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +
 11 files changed, 201 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 25e9dcf..116244b 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -879,7 +879,8 @@ static void rt2400pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 static void rt2400pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_OFF);
+	int mask = (state == STATE_RADIO_IRQ_OFF) ||
+		   (state == STATE_RADIO_IRQ_OFF_ISR);
 	u32 reg;
 
 	/*
@@ -980,7 +981,9 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2400pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
+	case STATE_RADIO_IRQ_OFF_ISR:
 		rt2400pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
@@ -1235,23 +1238,10 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt2400pci_interrupt_thread(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg;
-
-	/*
-	 * Get the interrupt sources & saved to local variable.
-	 * Write register value back to clear pending interrupts.
-	 */
-	rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
-	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
-
-	if (!reg)
-		return IRQ_NONE;
-
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return IRQ_HANDLED;
+	u32 reg = rt2x00dev->irqvalue[0];
 
 	/*
 	 * Handle interrupts, walk through all bits
@@ -1289,9 +1279,40 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
 		rt2400pci_txdone(rt2x00dev, QID_AC_BK);
 
+	/* Enable interrupts again. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_ON_ISR);
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
+{
+	struct rt2x00_dev *rt2x00dev = dev_instance;
+	u32 reg;
+
+	/*
+	 * Get the interrupt sources & saved to local variable.
+	 * Write register value back to clear pending interrupts.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
+	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
+
+	if (!reg)
+		return IRQ_NONE;
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return IRQ_HANDLED;
+
+	/* Store irqvalues for use in the interrupt thread. */
+	rt2x00dev->irqvalue[0] = reg;
+
+	/* Disable interrupts, will be enabled again in the interrupt thread. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_OFF_ISR);
+
+	return IRQ_WAKE_THREAD;
+}
+
 /*
  * Device probe functions.
  */
@@ -1581,6 +1602,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.irq_handler		= rt2400pci_interrupt,
+	.irq_handler_thread	= rt2400pci_interrupt_thread,
 	.probe_hw		= rt2400pci_probe_hw,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index faa804c..5e80948 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1033,7 +1033,8 @@ static void rt2500pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_OFF);
+	int mask = (state == STATE_RADIO_IRQ_OFF) ||
+		   (state == STATE_RADIO_IRQ_OFF_ISR);
 	u32 reg;
 
 	/*
@@ -1134,7 +1135,9 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
+	case STATE_RADIO_IRQ_OFF_ISR:
 		rt2500pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
@@ -1367,23 +1370,10 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt2500pci_interrupt_thread(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg;
-
-	/*
-	 * Get the interrupt sources & saved to local variable.
-	 * Write register value back to clear pending interrupts.
-	 */
-	rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
-	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
-
-	if (!reg)
-		return IRQ_NONE;
-
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return IRQ_HANDLED;
+	u32 reg = rt2x00dev->irqvalue[0];
 
 	/*
 	 * Handle interrupts, walk through all bits
@@ -1421,9 +1411,41 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
 		rt2500pci_txdone(rt2x00dev, QID_AC_BK);
 
+	/* Enable interrupts again. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_ON_ISR);
+
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
+{
+	struct rt2x00_dev *rt2x00dev = dev_instance;
+	u32 reg;
+
+	/*
+	 * Get the interrupt sources & saved to local variable.
+	 * Write register value back to clear pending interrupts.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
+	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
+
+	if (!reg)
+		return IRQ_NONE;
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return IRQ_HANDLED;
+
+	/* Store irqvalues for use in the interrupt thread. */
+	rt2x00dev->irqvalue[0] = reg;
+
+	/* Disable interrupts, will be enabled again in the interrupt thread. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_OFF_ISR);
+
+	return IRQ_WAKE_THREAD;
+}
+
 /*
  * Device probe functions.
  */
@@ -1874,6 +1896,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.irq_handler		= rt2500pci_interrupt,
+	.irq_handler_thread	= rt2500pci_interrupt_thread,
 	.probe_hw		= rt2500pci_probe_hw,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 009323e..242d595 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1004,7 +1004,9 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
+	case STATE_RADIO_IRQ_OFF_ISR:
 		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index a9eca99..f21b77c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -422,7 +422,8 @@ static void rt2800pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_ON);
+	int mask = (state == STATE_RADIO_IRQ_ON) ||
+		   (state == STATE_RADIO_IRQ_ON_ISR);
 	u32 reg;
 
 	/*
@@ -631,7 +632,9 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
+	case STATE_RADIO_IRQ_OFF_ISR:
 		rt2800pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
@@ -929,20 +932,10 @@ static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
-static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt2800pci_interrupt_thread(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg;
-
-	/* Read status and ACK all interrupts */
-	rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-	rt2800_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
-
-	if (!reg)
-		return IRQ_NONE;
-
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return IRQ_HANDLED;
+	u32 reg = rt2x00dev->irqvalue[0];
 
 	/*
 	 * 1 - Rx ring done interrupt.
@@ -962,9 +955,39 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
 		rt2800pci_wakeup(rt2x00dev);
 
+	/* Enable interrupts again. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_ON_ISR);
+
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
+{
+	struct rt2x00_dev *rt2x00dev = dev_instance;
+	u32 reg;
+
+	/* Read status and ACK all interrupts */
+	rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+	rt2800_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+
+	if (!reg)
+		return IRQ_NONE;
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return IRQ_HANDLED;
+
+	/* Store irqvalue for use in the interrupt thread. */
+	rt2x00dev->irqvalue[0] = reg;
+
+	/* Disable interrupts, will be enabled again in the interrupt thread. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_OFF_ISR);
+
+
+	return IRQ_WAKE_THREAD;
+}
+
 /*
  * Device probe functions.
  */
@@ -1049,6 +1072,7 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.irq_handler		= rt2800pci_interrupt,
+	.irq_handler_thread	= rt2800pci_interrupt_thread,
 	.probe_hw		= rt2800pci_probe_hw,
 	.get_firmware_name	= rt2800pci_get_firmware_name,
 	.check_firmware		= rt2800pci_check_firmware,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5aa7563..df78e28 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -406,7 +406,9 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800usb_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
+	case STATE_RADIO_IRQ_OFF_ISR:
 		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 97b6261..0fa2141 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -515,6 +515,11 @@ struct rt2x00lib_ops {
 	irq_handler_t irq_handler;
 
 	/*
+	 * Threaded Interrupt handlers.
+	 */
+	irq_handler_t irq_handler_thread;
+
+	/*
 	 * Device init handlers.
 	 */
 	int (*probe_hw) (struct rt2x00_dev *rt2x00dev);
@@ -871,6 +876,12 @@ struct rt2x00_dev {
 	const struct firmware *fw;
 
 	/*
+	 * Interrupt values, stored between interrupt service routine
+	 * and interrupt thread routine.
+	 */
+	u32 irqvalue[2];
+
+	/*
 	 * Driver specific data.
 	 */
 	void *priv;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0906e14..d3ebb41 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -340,9 +340,17 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * send the status report back.
 	 */
 	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211))
-		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
+		/*
+		 * Only PCI and SOC devices process the tx status in process
+		 * context. Hence use ieee80211_tx_status for PCI and SOC
+		 * devices and stick to ieee80211_tx_status_irqsafe for USB.
+		 */
+		if (rt2x00_is_usb(rt2x00dev))
+			ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
+		else
+			ieee80211_tx_status(rt2x00dev->hw, entry->skb);
 	else
-		dev_kfree_skb_irq(entry->skb);
+		dev_kfree_skb_any(entry->skb);
 
 	/*
 	 * Make this entry available for reuse.
@@ -489,7 +497,16 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
 	memcpy(IEEE80211_SKB_RXCB(entry->skb), rx_status, sizeof(*rx_status));
-	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb);
+
+	/*
+	 * Currently only PCI and SOC devices handle rx interrupts in process
+	 * context. Hence, use ieee80211_rx_irqsafe for USB and ieee80211_rx_ni
+	 * for PCI and SOC devices.
+	 */
+	if (rt2x00_is_usb(rt2x00dev))
+		ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb);
+	else
+		ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
 
 	/*
 	 * Replace the skb with the freshly allocated one.
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index fc9da83..19b262e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -153,8 +153,10 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Register interrupt handler.
 	 */
-	status = request_irq(rt2x00dev->irq, rt2x00dev->ops->lib->irq_handler,
-			     IRQF_SHARED, rt2x00dev->name, rt2x00dev);
+	status = request_threaded_irq(rt2x00dev->irq,
+				      rt2x00dev->ops->lib->irq_handler,
+				      rt2x00dev->ops->lib->irq_handler_thread,
+				      IRQF_SHARED, rt2x00dev->name, rt2x00dev);
 	if (status) {
 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
 		      rt2x00dev->irq, status);
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index b9fe948..055501c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -88,6 +88,8 @@ enum dev_state {
 	STATE_RADIO_RX_OFF_LINK,
 	STATE_RADIO_IRQ_ON,
 	STATE_RADIO_IRQ_OFF,
+	STATE_RADIO_IRQ_ON_ISR,
+	STATE_RADIO_IRQ_OFF_ISR,
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fe7bce7..049433f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1622,7 +1622,8 @@ static void rt61pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
-	int mask = (state == STATE_RADIO_IRQ_OFF);
+	int mask = (state == STATE_RADIO_IRQ_OFF) ||
+		   (state == STATE_RADIO_IRQ_OFF_ISR);
 	u32 reg;
 
 	/*
@@ -1739,7 +1740,9 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt61pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
+	case STATE_RADIO_IRQ_OFF_ISR:
 		rt61pci_toggle_irq(rt2x00dev, state);
 		break;
 	case STATE_DEEP_SLEEP:
@@ -2147,27 +2150,11 @@ static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
-static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
+static irqreturn_t rt61pci_interrupt_thread(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg_mcu;
-	u32 reg;
-
-	/*
-	 * Get the interrupt sources & saved to local variable.
-	 * Write register value back to clear pending interrupts.
-	 */
-	rt2x00pci_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg_mcu);
-	rt2x00pci_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg_mcu);
-
-	rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
-
-	if (!reg && !reg_mcu)
-		return IRQ_NONE;
-
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return IRQ_HANDLED;
+	u32 reg = rt2x00dev->irqvalue[0];
+	u32 reg_mcu = rt2x00dev->irqvalue[1];
 
 	/*
 	 * Handle interrupts, walk through all bits
@@ -2206,9 +2193,45 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
 		rt2x00lib_beacondone(rt2x00dev);
 
+	/* Enable interrupts again. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_ON_ISR);
 	return IRQ_HANDLED;
 }
 
+
+static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
+{
+	struct rt2x00_dev *rt2x00dev = dev_instance;
+	u32 reg_mcu;
+	u32 reg;
+
+	/*
+	 * Get the interrupt sources & saved to local variable.
+	 * Write register value back to clear pending interrupts.
+	 */
+	rt2x00pci_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg_mcu);
+	rt2x00pci_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg_mcu);
+
+	rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+
+	if (!reg && !reg_mcu)
+		return IRQ_NONE;
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return IRQ_HANDLED;
+
+	/* Store irqvalues for use in the interrupt thread. */
+	rt2x00dev->irqvalue[0] = reg;
+	rt2x00dev->irqvalue[1] = reg_mcu;
+
+	/* Disable interrupts, will be enabled again in the interrupt thread. */
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+					      STATE_RADIO_IRQ_OFF_ISR);
+	return IRQ_WAKE_THREAD;
+}
+
 /*
  * Device probe functions.
  */
@@ -2795,6 +2818,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.irq_handler		= rt61pci_interrupt,
+	.irq_handler_thread	= rt61pci_interrupt_thread,
 	.probe_hw		= rt61pci_probe_hw,
 	.get_firmware_name	= rt61pci_get_firmware_name,
 	.check_firmware		= rt61pci_check_firmware,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index cad07b6..aa9de18 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1400,7 +1400,9 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt73usb_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
+	case STATE_RADIO_IRQ_OFF_ISR:
 		/* No support, but no error either */
 		break;
 	case STATE_DEEP_SLEEP:
-- 
1.7.1.1

