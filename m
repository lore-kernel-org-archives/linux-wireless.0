Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52444 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab1DIVKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 17:10:25 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 3/3] ath5k: fix slot time handling
Date: Sat,  9 Apr 2011 23:10:21 +0200
Message-Id: <1302383421-1418-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302383421-1418-2-git-send-email-nbd@openwrt.org>
References: <1302383421-1418-1-git-send-email-nbd@openwrt.org>
 <1302383421-1418-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the slot time based on the mac80211 short slot vs long slot setting
instead of just forcing long slot for all CCK-enabled channels.
This slightly improves 802.11g mode performance in in my tests.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    9 +++++++++
 drivers/net/wireless/ath/ath5k/pcu.c          |    4 ++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index a49aeac..4bb381c 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1057,6 +1057,7 @@ struct ath5k_hw {
 	u8			ah_coverage_class;
 	bool			ah_ack_bitrate_high;
 	u8			ah_bwmode;
+	bool			ah_short_slot;
 
 	/* Antenna Control */
 	u32			ah_ant_ctl[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 9be29b7..807bd64 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -282,6 +282,15 @@ ath5k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changes & BSS_CHANGED_BEACON_INT)
 		sc->bintval = bss_conf->beacon_int;
 
+	if (changes & BSS_CHANGED_ERP_SLOT) {
+		int slot_time;
+
+		ah->ah_short_slot = bss_conf->use_short_slot;
+		slot_time = ath5k_hw_get_default_slottime(ah) +
+			    3 * ah->ah_coverage_class;
+		ath5k_hw_set_ifs_intervals(ah, slot_time);
+	}
+
 	if (changes & BSS_CHANGED_ASSOC) {
 		avf->assoc = bss_conf->assoc;
 		if (bss_conf->assoc)
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index e342e47..71b60b7 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -151,9 +151,9 @@ unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 		slot_time = AR5K_INIT_SLOT_TIME_QUARTER_RATE;
 		break;
 	case AR5K_BWMODE_DEFAULT:
-		slot_time = AR5K_INIT_SLOT_TIME_DEFAULT;
 	default:
-		if (channel->hw_value & CHANNEL_CCK)
+		slot_time = AR5K_INIT_SLOT_TIME_DEFAULT;
+		if ((channel->hw_value & CHANNEL_CCK) && !ah->ah_short_slot)
 			slot_time = AR5K_INIT_SLOT_TIME_B;
 		break;
 	}
-- 
1.7.3.2

