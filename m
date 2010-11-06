Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44208 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0KFOuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:50:01 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so2253925ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:50:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/18] rt2x00: Remove rt2x00lib_toggle_rx
Date: Sat, 6 Nov 2010 15:48:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061548.06660.IvDoorn@gmail.com> <201011061548.24450.IvDoorn@gmail.com>
In-Reply-To: <201011061548.24450.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061548.43949.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

As part of the queue refactoring, the rt2x00lib_toggle_rx
can be removed and replaced with the call directly to
the set_device_state callback function.

We can remove the STATE_RADIO_RX_ON_LINK and
STATE_RADIO_RX_OFF_LINK, as it was only used for
special behavior inside rt2x00lib rather then the
drivers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |    5 +----
 drivers/net/wireless/rt2x00/rt2500pci.c    |    5 +----
 drivers/net/wireless/rt2x00/rt2500usb.c    |    5 +----
 drivers/net/wireless/rt2x00/rt2800pci.c    |    5 +----
 drivers/net/wireless/rt2x00/rt2800usb.c    |    5 +----
 drivers/net/wireless/rt2x00/rt2x00config.c |    6 ++++--
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   23 ++++-------------------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    1 -
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00reg.h    |    2 --
 drivers/net/wireless/rt2x00/rt61pci.c      |    5 +----
 drivers/net/wireless/rt2x00/rt73usb.c      |    5 +----
 12 files changed, 17 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index bc1ae1e..9ec6691 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -885,8 +885,7 @@ static void rt2400pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
 	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF) ||
-			   (state == STATE_RADIO_RX_OFF_LINK));
+			   (state == STATE_RADIO_RX_OFF));
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 }
 
@@ -989,9 +988,7 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2400pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
-	case STATE_RADIO_RX_ON_LINK:
 	case STATE_RADIO_RX_OFF:
-	case STATE_RADIO_RX_OFF_LINK:
 		rt2400pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5475415..3e7f203 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1040,8 +1040,7 @@ static void rt2500pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
 	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF) ||
-			   (state == STATE_RADIO_RX_OFF_LINK));
+			   (state == STATE_RADIO_RX_OFF));
 	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 }
 
@@ -1144,9 +1143,7 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
-	case STATE_RADIO_RX_ON_LINK:
 	case STATE_RADIO_RX_OFF:
-	case STATE_RADIO_RX_OFF_LINK:
 		rt2500pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 10e51f2..8152fec 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -938,8 +938,7 @@ static void rt2500usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF) ||
-			   (state == STATE_RADIO_RX_OFF_LINK));
+			   (state == STATE_RADIO_RX_OFF));
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
 }
 
@@ -1019,9 +1018,7 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
-	case STATE_RADIO_RX_ON_LINK:
 	case STATE_RADIO_RX_OFF:
-	case STATE_RADIO_RX_OFF_LINK:
 		rt2500usb_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 1db0c3b..5f3a018 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -328,8 +328,7 @@ static void rt2800pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX,
-			   (state == STATE_RADIO_RX_ON) ||
-			   (state == STATE_RADIO_RX_ON_LINK));
+			   (state == STATE_RADIO_RX_ON));
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 }
 
@@ -477,9 +476,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
 		break;
 	case STATE_RADIO_RX_ON:
-	case STATE_RADIO_RX_ON_LINK:
 	case STATE_RADIO_RX_OFF:
-	case STATE_RADIO_RX_OFF_LINK:
 		rt2800pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 67a9942..f933371 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -114,8 +114,7 @@ static void rt2800usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX,
-			   (state == STATE_RADIO_RX_ON) ||
-			   (state == STATE_RADIO_RX_ON_LINK));
+			   (state == STATE_RADIO_RX_ON));
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 }
 
@@ -216,9 +215,7 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800usb_set_state(rt2x00dev, STATE_SLEEP);
 		break;
 	case STATE_RADIO_RX_ON:
-	case STATE_RADIO_RX_ON_LINK:
 	case STATE_RADIO_RX_OFF:
-	case STATE_RADIO_RX_OFF_LINK:
 		rt2800usb_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index fca8f22..a238e90 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -146,7 +146,8 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * else the changes will be ignored by the device.
 	 */
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF_LINK);
+		rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+						      STATE_RADIO_RX_OFF);
 
 	/*
 	 * Write new antenna setup to device and reset the link tuner.
@@ -160,7 +161,8 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	memcpy(active, &config, sizeof(config));
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
+		rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+						      STATE_RADIO_RX_ON);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 942b4af..b98de35 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -68,7 +68,8 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_ON);
+	rt2x00link_start_tuner(rt2x00dev);
 
 	/*
 	 * Start watchdog monitoring.
@@ -102,7 +103,8 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable RX.
 	 */
-	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+	rt2x00link_stop_tuner(rt2x00dev);
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_OFF);
 
 	/*
 	 * Disable radio.
@@ -113,23 +115,6 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00leds_led_radio(rt2x00dev, false);
 }
 
-void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state)
-{
-	/*
-	 * When we are disabling the RX, we should also stop the link tuner.
-	 */
-	if (state == STATE_RADIO_RX_OFF)
-		rt2x00link_stop_tuner(rt2x00dev);
-
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
-
-	/*
-	 * When we are enabling the RX, we should also start the link tuner.
-	 */
-	if (state == STATE_RADIO_RX_ON)
-		rt2x00link_start_tuner(rt2x00dev);
-}
-
 static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 					  struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 9835402..2cf68f8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -69,7 +69,6 @@ static inline int rt2x00_get_rate_mcs(const u16 mcs_value)
  */
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev);
-void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, enum dev_state state);
 
 /*
  * Initialization handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 36ddee8..829bf4b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -352,7 +352,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	 * if for any reason the link tuner must be reset, this will be
 	 * handled by rt2x00lib_config().
 	 */
-	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF_LINK);
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_OFF);
 
 	/*
 	 * When we've just turned on the radio, we want to reprogram
@@ -370,7 +370,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	rt2x00lib_config_antenna(rt2x00dev, rt2x00dev->default_ant);
 
 	/* Turn RX back on */
-	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
+	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_ON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index cef9462..ed71be9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -85,8 +85,6 @@ enum dev_state {
 	STATE_RADIO_OFF,
 	STATE_RADIO_RX_ON,
 	STATE_RADIO_RX_OFF,
-	STATE_RADIO_RX_ON_LINK,
-	STATE_RADIO_RX_OFF_LINK,
 	STATE_RADIO_IRQ_ON,
 	STATE_RADIO_IRQ_OFF,
 	STATE_RADIO_IRQ_ON_ISR,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f01bff7..6b09b01 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1623,8 +1623,7 @@ static void rt61pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF) ||
-			   (state == STATE_RADIO_RX_OFF_LINK));
+			   (state == STATE_RADIO_RX_OFF));
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
@@ -1745,9 +1744,7 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt61pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
-	case STATE_RADIO_RX_ON_LINK:
 	case STATE_RADIO_RX_OFF:
-	case STATE_RADIO_RX_OFF_LINK:
 		rt61pci_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 29602b5..6f04552 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1331,8 +1331,7 @@ static void rt73usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF) ||
-			   (state == STATE_RADIO_RX_OFF_LINK));
+			   (state == STATE_RADIO_RX_OFF));
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
@@ -1403,9 +1402,7 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt73usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
-	case STATE_RADIO_RX_ON_LINK:
 	case STATE_RADIO_RX_OFF:
-	case STATE_RADIO_RX_OFF_LINK:
 		rt73usb_toggle_rx(rt2x00dev, state);
 		break;
 	case STATE_RADIO_IRQ_ON:
-- 
1.7.2.3

