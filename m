Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41348 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbYLRVWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:22:18 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Fix some MAC locking
Date: Thu, 18 Dec 2008 22:13:39 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200812182213.39260.mb@bu3sch.de> (sfid-20081218_222221_923664_5CBF9CF5)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some locking w.r.t. the lower MAC (firmware).
It also removes a lot of ancient IRQ-locking that's not needed anymore.
We simply suspend the MAC. That's easier and causes less trouble.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

-- 

Stuff for the next feature release.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-11-05 23:02:57.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-18 21:43:50.000000000 +0100
@@ -3321,41 +3321,30 @@ static int b43_op_config(struct ieee8021
 	struct b43_wldev *dev;
 	struct b43_phy *phy;
 	struct ieee80211_conf *conf = &hw->conf;
 	unsigned long flags;
 	int antenna;
 	int err = 0;
-	u32 savedirqs;
 
 	mutex_lock(&wl->mutex);
 
 	/* Switch the band (if necessary). This might change the active core. */
 	err = b43_switch_band(wl, conf->channel);
 	if (err)
 		goto out_unlock_mutex;
 	dev = wl->current_dev;
 	phy = &dev->phy;
 
+	b43_mac_suspend(dev);
+
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		b43_set_retry_limits(dev, conf->short_frame_max_tx_count,
 					  conf->long_frame_max_tx_count);
 	changed &= ~IEEE80211_CONF_CHANGE_RETRY_LIMITS;
 	if (!changed)
-		goto out_unlock_mutex;
-
-	/* Disable IRQs while reconfiguring the device.
-	 * This makes it possible to drop the spinlock throughout
-	 * the reconfiguration process. */
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_STARTED) {
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
-		goto out_unlock_mutex;
-	}
-	savedirqs = b43_interrupt_disable(dev, B43_IRQ_ALL);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	b43_synchronize_irq(dev);
+		goto out_mac_enable;
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
 	if (conf->channel->hw_value != phy->channel)
 		b43_switch_channel(dev, conf->channel->hw_value);
 
@@ -3396,17 +3385,15 @@ static int b43_op_config(struct ieee8021
 		} else {
 			b43_software_rfkill(dev, RFKILL_STATE_SOFT_BLOCKED);
 			b43info(dev->wl, "Radio turned off by software\n");
 		}
 	}
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_interrupt_enable(dev, savedirqs);
-	mmiowb();
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-      out_unlock_mutex:
+out_mac_enable:
+	b43_mac_enable(dev);
+out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 
 	return err;
 }
 
 static void b43_update_basic_rates(struct b43_wldev *dev, u64 brates)
@@ -3458,33 +3445,18 @@ static void b43_op_bss_info_changed(stru
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_bss_conf *conf,
 				    u32 changed)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
-	struct b43_phy *phy;
-	unsigned long flags;
-	u32 savedirqs;
 
 	mutex_lock(&wl->mutex);
 
 	dev = wl->current_dev;
-	phy = &dev->phy;
-
-	/* Disable IRQs while reconfiguring the device.
-	 * This makes it possible to drop the spinlock throughout
-	 * the reconfiguration process. */
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_STARTED) {
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
+	if (!dev || b43_status(dev) < B43_STAT_STARTED)
 		goto out_unlock_mutex;
-	}
-	savedirqs = b43_interrupt_disable(dev, B43_IRQ_ALL);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	b43_synchronize_irq(dev);
-
 	b43_mac_suspend(dev);
 
 	if (changed & BSS_CHANGED_BASIC_RATES)
 		b43_update_basic_rates(dev, conf->basic_rates);
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -3492,19 +3464,13 @@ static void b43_op_bss_info_changed(stru
 			b43_short_slot_timing_enable(dev);
 		else
 			b43_short_slot_timing_disable(dev);
 	}
 
 	b43_mac_enable(dev);
-
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_interrupt_enable(dev, savedirqs);
-	/* XXX: why? */
-	mmiowb();
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
- out_unlock_mutex:
+out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 
 	return;
 }
 
 static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2008-09-26 22:51:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2008-12-18 21:49:12.000000000 +0100
@@ -3044,12 +3044,14 @@ static void b43_gphy_op_adjust_txpower(s
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	int rfatt, bbatt;
 	u8 tx_control;
 
+	b43_mac_suspend(dev);
+
 	spin_lock_irq(&dev->wl->irq_lock);
 
 	/* Calculate the new attenuation values. */
 	bbatt = gphy->bbatt.att;
 	bbatt += gphy->bbatt_delta;
 	rfatt = gphy->rfatt.att;
@@ -3100,12 +3102,14 @@ static void b43_gphy_op_adjust_txpower(s
 	b43_phy_lock(dev);
 	b43_radio_lock(dev);
 	b43_set_txpower_g(dev, &gphy->bbatt, &gphy->rfatt,
 			  gphy->tx_control);
 	b43_radio_unlock(dev);
 	b43_phy_unlock(dev);
+
+	b43_mac_enable(dev);
 }
 
 static enum b43_txpwr_result b43_gphy_op_recalc_txpower(struct b43_wldev *dev,
 							bool ignore_tssi)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -3212,30 +3216,30 @@ no_adjustment_needed:
 
 static void b43_gphy_op_pwork_15sec(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 
+	b43_mac_suspend(dev);
 	//TODO: update_aci_moving_average
 	if (gphy->aci_enable && gphy->aci_wlan_automatic) {
-		b43_mac_suspend(dev);
 		if (!gphy->aci_enable && 1 /*TODO: not scanning? */ ) {
 			if (0 /*TODO: bunch of conditions */ ) {
 				phy->ops->interf_mitigation(dev,
 					B43_INTERFMODE_MANUALWLAN);
 			}
 		} else if (0 /*TODO*/) {
 			   if (/*(aci_average > 1000) &&*/ !b43_gphy_aci_scan(dev))
 				phy->ops->interf_mitigation(dev, B43_INTERFMODE_NONE);
 		}
-		b43_mac_enable(dev);
 	} else if (gphy->interfmode == B43_INTERFMODE_NONWLAN &&
 		   phy->rev == 1) {
 		//TODO: implement rev1 workaround
 	}
 	b43_lo_g_maintanance_work(dev);
+	b43_mac_enable(dev);
 }
 
 static void b43_gphy_op_pwork_60sec(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2008-10-11 16:13:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2008-12-18 21:52:28.000000000 +0100
@@ -175,19 +175,33 @@ void b43_phy_unlock(struct b43_wldev *de
 	B43_WARN_ON(dev->dev->id.revision < 3);
 
 	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, 0);
 }
 
+static inline void assert_mac_suspended(struct b43_wldev *dev)
+{
+	if (!B43_DEBUG)
+		return;
+	if ((b43_status(dev) >= B43_STAT_INITIALIZED) &&
+	    (dev->mac_suspended <= 0)) {
+		b43dbg(dev->wl, "PHY/RADIO register access with "
+		       "enabled MAC.\n");
+		dump_stack();
+	}
+}
+
 u16 b43_radio_read(struct b43_wldev *dev, u16 reg)
 {
+	assert_mac_suspended(dev);
 	return dev->phy.ops->radio_read(dev, reg);
 }
 
 void b43_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
+	assert_mac_suspended(dev);
 	dev->phy.ops->radio_write(dev, reg, value);
 }
 
 void b43_radio_mask(struct b43_wldev *dev, u16 offset, u16 mask)
 {
 	b43_radio_write16(dev, offset,
@@ -205,17 +219,19 @@ void b43_radio_maskset(struct b43_wldev 
 	b43_radio_write16(dev, offset,
 			  (b43_radio_read16(dev, offset) & mask) | set);
 }
 
 u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
 {
+	assert_mac_suspended(dev);
 	return dev->phy.ops->phy_read(dev, reg);
 }
 
 void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
+	assert_mac_suspended(dev);
 	dev->phy.ops->phy_write(dev, reg, value);
 }
 
 void b43_phy_mask(struct b43_wldev *dev, u16 offset, u16 mask)
 {
 	b43_phy_write(dev, offset,

-- 
Greetings, Michael.
