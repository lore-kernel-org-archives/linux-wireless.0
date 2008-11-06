Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYKFOSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:18:13 -0500
Subject: [PATCH/RFT] b43legacy: implement short slot and basic rate handling
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 15:18:11 +0100
Message-Id: <1225981091.3619.227.camel@johannes.berg> (sfid-20081106_151817_986388_8F036508)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: b43legacy: implement short slot and basic rate handling

This implements proper short slot handling and adds code to
program the hardware for the correct response rates derived
from the basic rate set for the current BSS.

(port from b43)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Needs testing, I'm not 100% sure about those shm offsets.

 drivers/net/wireless/b43legacy/b43legacy.h |    5 +
 drivers/net/wireless/b43legacy/main.c      |  111 +++++++++++++++++++++++++----
 2 files changed, 103 insertions(+), 13 deletions(-)

--- everything.orig/drivers/net/wireless/b43legacy/b43legacy.h	2008-10-10 23:27:44.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/b43legacy.h	2008-11-06 15:17:45.000000000 +0100
@@ -145,6 +145,10 @@
 #define B43legacy_SHM_SH_PRMAXTIME	0x0074 /* Probe Response max time */
 #define B43legacy_SHM_SH_PRPHYCTL	0x0188 /* Probe Resp PHY TX control */
 /* SHM_SHARED rate tables */
+#define B43legacy_SHM_SH_OFDMDIRECT	0x0480 /* Pointer to OFDM direct map */
+#define B43legacy_SHM_SH_OFDMBASIC	0x04A0 /* Pointer to OFDM basic rate map */
+#define B43legacy_SHM_SH_CCKDIRECT	0x04C0 /* Pointer to CCK direct map */
+#define B43legacy_SHM_SH_CCKBASIC	0x04E0 /* Pointer to CCK basic rate map */
 /* SHM_SHARED microcode soft registers */
 #define B43legacy_SHM_SH_UCODEREV	0x0000 /* Microcode revision */
 #define B43legacy_SHM_SH_UCODEPATCH	0x0002 /* Microcode patchlevel */
@@ -663,7 +667,6 @@ struct b43legacy_wldev {
 	bool bad_frames_preempt;/* Use "Bad Frames Preemption". */
 	bool dfq_valid;		/* Directed frame queue valid (IBSS PS mode, ATIM). */
 	bool short_preamble;	/* TRUE if using short preamble. */
-	bool short_slot;	/* TRUE if using short slot timing. */
 	bool radio_hw_enable;	/* State of radio hardware enable bit. */
 
 	/* PHY/Radio device. */
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-11-01 11:07:46.000000000 +0100
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-11-06 15:07:43.000000000 +0100
@@ -576,13 +576,11 @@ static void b43legacy_set_slot_time(stru
 static void b43legacy_short_slot_timing_enable(struct b43legacy_wldev *dev)
 {
 	b43legacy_set_slot_time(dev, 9);
-	dev->short_slot = 1;
 }
 
 static void b43legacy_short_slot_timing_disable(struct b43legacy_wldev *dev)
 {
 	b43legacy_set_slot_time(dev, 20);
-	dev->short_slot = 0;
 }
 
 /* Enable a Generic IRQ. "mask" is the mask of which IRQs to enable.
@@ -2608,16 +2606,6 @@ static int b43legacy_op_dev_config(struc
 	if (conf->channel->hw_value != phy->channel)
 		b43legacy_radio_selectchannel(dev, conf->channel->hw_value, 0);
 
-	/* Enable/Disable ShortSlot timing. */
-	if ((!!(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME))
-	     != dev->short_slot) {
-		B43legacy_WARN_ON(phy->type != B43legacy_PHYTYPE_G);
-		if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)
-			b43legacy_short_slot_timing_enable(dev);
-		else
-			b43legacy_short_slot_timing_disable(dev);
-	}
-
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
 	/* Adjust the desired TX power level. */
@@ -2662,6 +2650,104 @@ out_unlock_mutex:
 	return err;
 }
 
+static void b43legacy_update_basic_rates(struct b43legacy_wldev *dev, u64 brates)
+{
+	struct ieee80211_supported_band *sband =
+		dev->wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	struct ieee80211_rate *rate;
+	int i;
+	u16 basic, direct, offset, basic_offset, rateptr;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		rate = &sband->bitrates[i];
+
+		if (b43legacy_is_cck_rate(rate->hw_value)) {
+			direct = B43legacy_SHM_SH_CCKDIRECT;
+			basic = B43legacy_SHM_SH_CCKBASIC;
+			offset = b43legacy_plcp_get_ratecode_cck(rate->hw_value);
+			offset &= 0xF;
+		} else {
+			direct = B43legacy_SHM_SH_OFDMDIRECT;
+			basic = B43legacy_SHM_SH_OFDMBASIC;
+			offset = b43legacy_plcp_get_ratecode_ofdm(rate->hw_value);
+			offset &= 0xF;
+		}
+
+		rate = ieee80211_get_response_rate(sband, brates, rate->bitrate);
+
+		if (b43legacy_is_cck_rate(rate->hw_value)) {
+			basic_offset = b43legacy_plcp_get_ratecode_cck(rate->hw_value);
+			basic_offset &= 0xF;
+		} else {
+			basic_offset = b43legacy_plcp_get_ratecode_ofdm(rate->hw_value);
+			basic_offset &= 0xF;
+		}
+
+		/*
+		 * Get the pointer that we need to point to
+		 * from the direct map
+		 */
+		rateptr = b43legacy_shm_read16(dev, B43legacy_SHM_SHARED,
+					       direct + 2 * basic_offset);
+		/* and write it to the basic map */
+		b43legacy_shm_write16(dev, B43legacy_SHM_SHARED,
+				      basic + 2 * offset, rateptr);
+	}
+}
+
+static void b43legacy_op_bss_info_changed(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_bss_conf *conf,
+				    u32 changed)
+{
+	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
+	struct b43legacy_wldev *dev;
+	struct b43legacy_phy *phy;
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
+	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
+		goto out_unlock_mutex;
+	}
+	savedirqs = b43legacy_interrupt_disable(dev, B43legacy_IRQ_ALL);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	b43legacy_synchronize_irq(dev);
+
+	b43legacy_mac_suspend(dev);
+
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		b43legacy_update_basic_rates(dev, conf->basic_rates);
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (conf->use_short_slot)
+			b43legacy_short_slot_timing_enable(dev);
+		else
+			b43legacy_short_slot_timing_disable(dev);
+	}
+
+	b43legacy_mac_enable(dev);
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	b43legacy_interrupt_enable(dev, savedirqs);
+	/* XXX: why? */
+	mmiowb();
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+ out_unlock_mutex:
+	mutex_unlock(&wl->mutex);
+
+	return;
+}
+
 static void b43legacy_op_configure_filter(struct ieee80211_hw *hw,
 					  unsigned int changed,
 					  unsigned int *fflags,
@@ -3370,6 +3456,7 @@ static const struct ieee80211_ops b43leg
 	.add_interface		= b43legacy_op_add_interface,
 	.remove_interface	= b43legacy_op_remove_interface,
 	.config			= b43legacy_op_dev_config,
+	.bss_info_changed	= b43legacy_op_bss_info_changed,
 	.config_interface	= b43legacy_op_config_interface,
 	.configure_filter	= b43legacy_op_configure_filter,
 	.get_stats		= b43legacy_op_get_stats,


