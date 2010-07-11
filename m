Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41261 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0GKKcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:06 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so426224eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:06 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/17] rt2x00: Use pretbtt irq for fetching beacons on rt2800pci
Date: Sun, 11 Jul 2010 12:28:23 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111227.27070.IvDoorn@gmail.com> <201007111227.58927.IvDoorn@gmail.com>
In-Reply-To: <201007111227.58927.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111228.24393.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Updating the beacon on pre tbtt instead of beacondone allows much lower
latency in regard to TIM updates. Hence, use the pre tbtt interrupt for
updating the beacon in rt2800pci (older devices don't provide a pre tbtt
interrupt).

Also, add a new driver flag to indicate if a driver has pre tbtt support
or not and implement the according behavior in rt2x00lib.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    8 +++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |   16 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |   28 +++++++++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   26 ++++++++++++++++++++++----
 5 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index edd3734..dc93e14 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -719,14 +719,20 @@
 #define TBTT_TIMER			0x1124
 
 /*
- * INT_TIMER_CFG:
+ * INT_TIMER_CFG: timer configuration
+ * PRE_TBTT_TIMER: leadtime to tbtt for pretbtt interrupt in units of 1/16 TU
+ * GP_TIMER: period of general purpose timer in units of 1/16 TU
  */
 #define INT_TIMER_CFG			0x1128
+#define INT_TIMER_CFG_PRE_TBTT_TIMER	FIELD32(0x0000ffff)
+#define INT_TIMER_CFG_GP_TIMER		FIELD32(0xffff0000)
 
 /*
  * INT_TIMER_EN: GP-timer and pre-tbtt Int enable
  */
 #define INT_TIMER_EN			0x112c
+#define INT_TIMER_EN_PRE_TBTT_TIMER	FIELD32(0x00000001)
+#define INT_TIMER_EN_GP_TIMER		FIELD32(0x00000002)
 
 /*
  * CH_IDLE_STA: channel idle time
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index afad3e1..5572732 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -807,6 +807,15 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE,
 				   (conf->sync == TSF_SYNC_BEACON));
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+		/*
+		 * Enable pre tbtt interrupt for beaconing modes
+		 */
+		rt2800_register_read(rt2x00dev, INT_TIMER_EN, &reg);
+		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER,
+				   (conf->sync == TSF_SYNC_BEACON));
+		rt2800_register_write(rt2x00dev, INT_TIMER_EN, reg);
+
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
@@ -1732,6 +1741,13 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, TX_STA_CNT1, &reg);
 	rt2800_register_read(rt2x00dev, TX_STA_CNT2, &reg);
 
+	/*
+	 * Setup leadtime for pre tbtt interrupt to 6ms
+	 */
+	rt2800_register_read(rt2x00dev, INT_TIMER_CFG, &reg);
+	rt2x00_set_field32(&reg, INT_TIMER_CFG_PRE_TBTT_TIMER, 6 << 4);
+	rt2800_register_write(rt2x00dev, INT_TIMER_CFG, reg);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_init_registers);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f21b77c..c0c38f9 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -938,20 +938,32 @@ static irqreturn_t rt2800pci_interrupt_thread(int irq, void *dev_instance)
 	u32 reg = rt2x00dev->irqvalue[0];
 
 	/*
-	 * 1 - Rx ring done interrupt.
+	 * 1 - Pre TBTT interrupt.
+	 */
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
+		rt2x00lib_pretbtt(rt2x00dev);
+
+	/*
+	 * 2 - Beacondone interrupt.
+	 */
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
+		rt2x00lib_beacondone(rt2x00dev);
+
+	/*
+	 * 3 - Rx ring done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE))
 		rt2x00pci_rxdone(rt2x00dev);
 
+	/*
+	 * 4 - Tx done interrupt.
+	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
 		rt2800pci_txdone(rt2x00dev);
 
 	/*
-	 * Current beacon was sent out, fetch the next one
+	 * 5 - Auto wakeup interrupt.
 	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
-		rt2x00lib_beacondone(rt2x00dev);
-
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
 		rt2800pci_wakeup(rt2x00dev);
 
@@ -1052,6 +1064,12 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL, &rt2x00dev->flags);
 
 	/*
+	 * This device has a pre tbtt interrupt and thus fetches
+	 * a new beacon directly prior to transmission.
+	 */
+	__set_bit(DRIVER_SUPPORT_PRE_TBTT_INTERRUPT, &rt2x00dev->flags);
+
+	/*
 	 * This device requires firmware.
 	 */
 	if (!rt2x00_is_soc(rt2x00dev))
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0fa2141..9dd0d17 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -658,6 +658,7 @@ enum rt2x00_flags {
 	CONFIG_SUPPORT_HW_CRYPTO,
 	DRIVER_SUPPORT_CONTROL_FILTERS,
 	DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL,
+	DRIVER_SUPPORT_PRE_TBTT_INTERRUPT,
 	DRIVER_SUPPORT_LINK_TUNING,
 	DRIVER_SUPPORT_WATCHDOG,
 
@@ -1071,6 +1072,7 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
  * Interrupt context handlers.
  */
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
 void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index ae0adff..f59b9f7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -200,8 +200,8 @@ static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 	}
 }
 
-static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
-				      struct ieee80211_vif *vif)
+static void rt2x00lib_beaconupdate_iter(void *data, u8 *mac,
+					struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = data;
 
@@ -223,15 +223,33 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
 					    rt2x00lib_bc_buffer_iter,
 					    rt2x00dev);
+	/*
+	 * Devices with pre tbtt interrupt don't need to update the beacon
+	 * here as they will fetch the next beacon directly prior to
+	 * transmission.
+	 */
+	if (test_bit(DRIVER_SUPPORT_PRE_TBTT_INTERRUPT, &rt2x00dev->flags))
+		return;
 
 	/* fetch next beacon */
 	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_beacondone_iter,
+					    rt2x00lib_beaconupdate_iter,
 					    rt2x00dev);
-
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
+void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev)
+{
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	/* fetch next beacon */
+	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
+					    rt2x00lib_beaconupdate_iter,
+					    rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_pretbtt);
+
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
-- 
1.7.1.1

