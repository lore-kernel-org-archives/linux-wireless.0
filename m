Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34503 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbYICKOh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 06:14:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Move Analog switching into phy code
Date: Wed, 3 Sep 2008 12:12:20 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200809031212.21143.mb@bu3sch.de> (sfid-20080903_121443_656382_D4CC1FC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves the Analog switching code into the PHY files.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/phy_a.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_a.c	2008-09-02 12:39:53.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_a.c	2008-09-03 11:53:47.000000000 +0200
@@ -629,12 +629,13 @@ const struct b43_phy_operations b43_phyo
 	.phy_read		= b43_aphy_op_read,
 	.phy_write		= b43_aphy_op_write,
 	.radio_read		= b43_aphy_op_radio_read,
 	.radio_write		= b43_aphy_op_radio_write,
 	.supports_hwpctl	= b43_aphy_op_supports_hwpctl,
 	.software_rfkill	= b43_aphy_op_software_rfkill,
+	.switch_analog		= b43_phyop_switch_analog_generic,
 	.switch_channel		= b43_aphy_op_switch_channel,
 	.get_default_chan	= b43_aphy_op_get_default_chan,
 	.set_rx_antenna		= b43_aphy_op_set_rx_antenna,
 	.recalc_txpower		= b43_aphy_op_recalc_txpower,
 	.adjust_txpower		= b43_aphy_op_adjust_txpower,
 	.pwork_15sec		= b43_aphy_op_pwork_15sec,
Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2008-09-02 02:37:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2008-09-03 11:52:50.000000000 +0200
@@ -371,6 +371,11 @@ int b43_phy_shm_tssi_read(struct b43_wld
 		    & B43_HF_CCKBOOST)
 			average = (average >= 13) ? (average - 13) : 0;
 	}
 
 	return average;
 }
+
+void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
+{
+	b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
+}
Index: wireless-testing/drivers/net/wireless/b43/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h	2008-09-02 02:37:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h	2008-09-03 11:51:53.000000000 +0200
@@ -105,12 +105,14 @@ enum b43_txpwr_result {
  * 			If NULL, hwpctl is assumed to be never supported.
  * @software_rfkill:	Turn the radio ON or OFF.
  * 			Possible state values are
  * 			RFKILL_STATE_SOFT_BLOCKED or
  * 			RFKILL_STATE_UNBLOCKED
  * 			Must not be NULL.
+ * @switch_analog:	Turn the Analog on/off.
+ * 			Must not be NULL.
  * @switch_channel:	Switch the radio to another channel.
  * 			Must not be NULL.
  * @get_default_chan:	Just returns the default channel number.
  * 			Must not be NULL.
  * @set_rx_antenna:	Set the antenna used for RX.
  * 			Can be NULL, if not supported.
@@ -155,12 +157,13 @@ struct b43_phy_operations {
 	u16 (*radio_read)(struct b43_wldev *dev, u16 reg);
 	void (*radio_write)(struct b43_wldev *dev, u16 reg, u16 value);
 
 	/* Radio */
 	bool (*supports_hwpctl)(struct b43_wldev *dev);
 	void (*software_rfkill)(struct b43_wldev *dev, enum rfkill_state state);
+	void (*switch_analog)(struct b43_wldev *dev, bool on);
 	int (*switch_channel)(struct b43_wldev *dev, unsigned int new_channel);
 	unsigned int (*get_default_chan)(struct b43_wldev *dev);
 	void (*set_rx_antenna)(struct b43_wldev *dev, int antenna);
 	int (*interf_mitigation)(struct b43_wldev *dev,
 				 enum b43_interference_mitigation new_mode);
 
@@ -394,8 +397,17 @@ void b43_phy_txpower_adjust_work(struct 
  * @shm_offset:		The SHM address to read the values from.
  *
  * Returns the average of the 4 TSSI values, or a negative error code.
  */
 int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset);
 
+/**
+ * b43_phy_switch_analog_generic - Generic PHY operation for switching the Analog.
+ *
+ * It does the switching based on the PHY0 core register.
+ * Do _not_ call this directly. Only use it as a switch_analog callback
+ * for struct b43_phy_operations.
+ */
+void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
+
 
 #endif /* LINUX_B43_PHY_COMMON_H_ */
Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2008-09-02 12:40:51.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2008-09-03 11:54:09.000000000 +0200
@@ -3268,12 +3268,13 @@ const struct b43_phy_operations b43_phyo
 	.phy_read		= b43_gphy_op_read,
 	.phy_write		= b43_gphy_op_write,
 	.radio_read		= b43_gphy_op_radio_read,
 	.radio_write		= b43_gphy_op_radio_write,
 	.supports_hwpctl	= b43_gphy_op_supports_hwpctl,
 	.software_rfkill	= b43_gphy_op_software_rfkill,
+	.switch_analog		= b43_phyop_switch_analog_generic,
 	.switch_channel		= b43_gphy_op_switch_channel,
 	.get_default_chan	= b43_gphy_op_get_default_chan,
 	.set_rx_antenna		= b43_gphy_op_set_rx_antenna,
 	.interf_mitigation	= b43_gphy_op_interf_mitigation,
 	.recalc_txpower		= b43_gphy_op_recalc_txpower,
 	.adjust_txpower		= b43_gphy_op_adjust_txpower,
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2008-09-02 02:37:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2008-09-03 11:54:30.000000000 +0200
@@ -143,12 +143,13 @@ const struct b43_phy_operations b43_phyo
 	.init			= b43_lpphy_op_init,
 	.phy_read		= b43_lpphy_op_read,
 	.phy_write		= b43_lpphy_op_write,
 	.radio_read		= b43_lpphy_op_radio_read,
 	.radio_write		= b43_lpphy_op_radio_write,
 	.software_rfkill	= b43_lpphy_op_software_rfkill,
+	.switch_analog		= b43_phyop_switch_analog_generic,
 	.switch_channel		= b43_lpphy_op_switch_channel,
 	.get_default_chan	= b43_lpphy_op_get_default_chan,
 	.set_rx_antenna		= b43_lpphy_op_set_rx_antenna,
 	.recalc_txpower		= b43_lpphy_op_recalc_txpower,
 	.adjust_txpower		= b43_lpphy_op_adjust_txpower,
 };
Index: wireless-testing/drivers/net/wireless/b43/phy_n.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_n.c	2008-09-02 02:37:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_n.c	2008-09-03 11:55:35.000000000 +0200
@@ -580,12 +580,18 @@ static void b43_nphy_op_radio_write(stru
 
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 					enum rfkill_state state)
 {//TODO
 }
 
+static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
+{
+	b43_phy_write(dev, B43_NPHY_AFECTL_OVER,
+		      on ? 0 : 0x7FFF);
+}
+
 static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 				      unsigned int new_channel)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
 			return -EINVAL;
@@ -611,11 +617,12 @@ const struct b43_phy_operations b43_phyo
 	.init			= b43_nphy_op_init,
 	.phy_read		= b43_nphy_op_read,
 	.phy_write		= b43_nphy_op_write,
 	.radio_read		= b43_nphy_op_radio_read,
 	.radio_write		= b43_nphy_op_radio_write,
 	.software_rfkill	= b43_nphy_op_software_rfkill,
+	.switch_analog		= b43_nphy_op_switch_analog,
 	.switch_channel		= b43_nphy_op_switch_channel,
 	.get_default_chan	= b43_nphy_op_get_default_chan,
 	.recalc_txpower		= b43_nphy_op_recalc_txpower,
 	.adjust_txpower		= b43_nphy_op_adjust_txpower,
 };
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-09-02 12:13:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-09-03 11:58:23.000000000 +0200
@@ -1049,29 +1049,12 @@ void b43_power_saving_ctl_bits(struct b4
 				break;
 			udelay(10);
 		}
 	}
 }
 
-/* Turn the Analog ON/OFF */
-static void b43_switch_analog(struct b43_wldev *dev, int on)
-{
-	switch (dev->phy.type) {
-	case B43_PHYTYPE_A:
-	case B43_PHYTYPE_G:
-		b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
-		break;
-	case B43_PHYTYPE_N:
-		b43_phy_write(dev, B43_NPHY_AFECTL_OVER,
-			      on ? 0 : 0x7FFF);
-		break;
-	default:
-		B43_WARN_ON(1);
-	}
-}
-
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 {
 	u32 tmslow;
 	u32 macctl;
 
 	flags |= B43_TMSLOW_PHYCLKEN;
@@ -1093,13 +1076,13 @@ void b43_wireless_core_reset(struct b43_
 
 	/* Turn Analog ON, but only if we already know the PHY-type.
 	 * This protects against very early setup where we don't know the
 	 * PHY-type, yet. wireless_core_reset will be called once again later,
 	 * when we know the PHY-type. */
 	if (dev->phy.ops)
-		b43_switch_analog(dev, 1);
+		dev->phy.ops->switch_analog(dev, 1);
 
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
 	macctl &= ~B43_MACCTL_GMODE;
 	if (flags & B43_TMSLOW_GMODE)
 		macctl |= B43_MACCTL_GMODE;
 	macctl |= B43_MACCTL_IHR_ENABLED;
@@ -3949,13 +3932,13 @@ static void b43_wireless_core_exit(struc
 		b43_leds_exit(dev);
 		b43_rng_exit(dev->wl);
 	}
 	b43_dma_free(dev);
 	b43_pio_free(dev);
 	b43_chip_exit(dev);
-	b43_switch_analog(dev, 0);
+	dev->phy.ops->switch_analog(dev, 0);
 	if (dev->wl->current_beacon) {
 		dev_kfree_skb_any(dev->wl->current_beacon);
 		dev->wl->current_beacon = NULL;
 	}
 
 	ssb_device_disable(dev->dev, 0);
@@ -4434,13 +4417,13 @@ static int b43_wireless_core_attach(stru
 
 	/* Now set some default "current_dev" */
 	if (!wl->current_dev)
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43_chip_reset);
 
-	b43_switch_analog(dev, 0);
+	dev->phy.ops->switch_analog(dev, 0);
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(bus);
 
 out:
 	return err;
 
