Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYJ3KNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:13:36 -0400
Subject: [PATCH] b43: implement short slot and basic rate handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 20:02:12 +0100
Message-Id: <1225306932.5439.32.camel@johannes.berg> (sfid-20081030_111342_954118_CEF08BFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements proper short slot handling and adds code to
program the hardware for the correct response rates derived
from the basic rate set for the current BSS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This needs to be ported to b43legacy.

 drivers/net/wireless/b43/b43.h  |    1 
 drivers/net/wireless/b43/main.c |  111 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 99 insertions(+), 13 deletions(-)

--- everything.orig/drivers/net/wireless/b43/b43.h	2008-10-29 19:16:26.000000000 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2008-10-29 19:17:13.000000000 +0100
@@ -718,7 +718,6 @@ struct b43_wldev {
 
 	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" (default off) */
 	bool dfq_valid;		/* Directed frame queue valid (IBSS PS mode, ATIM) */
-	bool short_slot;	/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
 	bool suspend_in_progress;	/* TRUE, if we are in a suspend/resume cycle */
 
--- everything.orig/drivers/net/wireless/b43/main.c	2008-10-29 19:16:26.000000000 +0100
+++ everything/drivers/net/wireless/b43/main.c	2008-10-29 19:18:54.000000000 +0100
@@ -703,13 +703,11 @@ static void b43_set_slot_time(struct b43
 static void b43_short_slot_timing_enable(struct b43_wldev *dev)
 {
 	b43_set_slot_time(dev, 9);
-	dev->short_slot = 1;
 }
 
 static void b43_short_slot_timing_disable(struct b43_wldev *dev)
 {
 	b43_set_slot_time(dev, 20);
-	dev->short_slot = 0;
 }
 
 /* Enable a Generic IRQ. "mask" is the mask of which IRQs to enable.
@@ -3361,16 +3359,6 @@ static int b43_op_config(struct ieee8021
 	if (conf->channel->hw_value != phy->channel)
 		b43_switch_channel(dev, conf->channel->hw_value);
 
-	/* Enable/Disable ShortSlot timing. */
-	if ((!!(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)) !=
-	    dev->short_slot) {
-		B43_WARN_ON(phy->type != B43_PHYTYPE_G);
-		if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)
-			b43_short_slot_timing_enable(dev);
-		else
-			b43_short_slot_timing_disable(dev);
-	}
-
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
 	/* Adjust the desired TX power level. */
@@ -3421,6 +3409,104 @@ static int b43_op_config(struct ieee8021
 	return err;
 }
 
+static void b43_update_basic_rates(struct b43_wldev *dev, u64 brates)
+{
+	struct ieee80211_supported_band *sband =
+		dev->wl->hw->wiphy->bands[b43_current_band(dev->wl)];
+	struct ieee80211_rate *rate;
+	int i;
+	u16 basic, direct, offset, basic_offset, rateptr;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		rate = &sband->bitrates[i];
+
+		if (b43_is_cck_rate(rate->hw_value)) {
+			direct = B43_SHM_SH_CCKDIRECT;
+			basic = B43_SHM_SH_CCKBASIC;
+			offset = b43_plcp_get_ratecode_cck(rate->hw_value);
+			offset &= 0xF;
+		} else {
+			direct = B43_SHM_SH_OFDMDIRECT;
+			basic = B43_SHM_SH_OFDMBASIC;
+			offset = b43_plcp_get_ratecode_ofdm(rate->hw_value);
+			offset &= 0xF;
+		}
+
+		rate = ieee80211_get_response_rate(sband, brates, rate->bitrate);
+
+		if (b43_is_cck_rate(rate->hw_value)) {
+			basic_offset = b43_plcp_get_ratecode_cck(rate->hw_value);
+			basic_offset &= 0xF;
+		} else {
+			basic_offset = b43_plcp_get_ratecode_ofdm(rate->hw_value);
+			basic_offset &= 0xF;
+		}
+
+		/*
+		 * Get the pointer that we need to point to
+		 * from the direct map
+		 */
+		rateptr = b43_shm_read16(dev, B43_SHM_SHARED,
+					 direct + 2 * basic_offset);
+		/* and write it to the basic map */
+		b43_shm_write16(dev, B43_SHM_SHARED, basic + 2 * offset,
+				rateptr);
+	}
+}
+
+static void b43_op_bss_info_changed(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_bss_conf *conf,
+				    u32 changed)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev;
+	struct b43_phy *phy;
+	unsigned long flags;
+	u32 savedirqs;
+
+	mutex_lock(&wl->mutex);
+
+	dev = wl->current_dev;
+	phy = &dev->phy;
+
+	/* Disable IRQs while reconfiguring the device.
+	 * This makes it possible to drop the spinlock throughout
+	 * the reconfiguration process. */
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	if (b43_status(dev) < B43_STAT_STARTED) {
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
+		goto out_unlock_mutex;
+	}
+	savedirqs = b43_interrupt_disable(dev, B43_IRQ_ALL);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	b43_synchronize_irq(dev);
+
+	b43_mac_suspend(dev);
+
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		b43_update_basic_rates(dev, conf->basic_rates);
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (conf->use_short_slot)
+			b43_short_slot_timing_enable(dev);
+		else
+			b43_short_slot_timing_disable(dev);
+	}
+
+	b43_mac_enable(dev);
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	b43_interrupt_enable(dev, savedirqs);
+	/* XXX: why? */
+	mmiowb();
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+ out_unlock_mutex:
+	mutex_unlock(&wl->mutex);
+
+	return;
+}
+
 static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
@@ -4211,6 +4297,7 @@ static const struct ieee80211_ops b43_hw
 	.add_interface		= b43_op_add_interface,
 	.remove_interface	= b43_op_remove_interface,
 	.config			= b43_op_config,
+	.bss_info_changed	= b43_op_bss_info_changed,
 	.config_interface	= b43_op_config_interface,
 	.configure_filter	= b43_op_configure_filter,
 	.set_key		= b43_op_set_key,


