Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYDXAPN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 10/16] iwlwifi: rate sacaling fixes
Date: Wed, 23 Apr 2008 17:15:02 -0700
Message-Id: <1208996108-15326-11-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021608_135572_093D8611)
In-Reply-To: <1208996108-15326-10-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

1. Fixing support for tx in antenna C
2. Enable stay_in_column expiration after 2 seconds

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   25 +++++++++++++------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 0c132b9..4f45093 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1356,9 +1356,9 @@ static inline u8 iwl4965_hw_get_rate(__le32 rate_n_flags)
 {
 	return le32_to_cpu(rate_n_flags) & 0xFF;
 }
-static inline u16 iwl4965_hw_get_rate_n_flags(__le32 rate_n_flags)
+static inline u32 iwl4965_hw_get_rate_n_flags(__le32 rate_n_flags)
 {
-	return le32_to_cpu(rate_n_flags) & 0xFFFF;
+	return le32_to_cpu(rate_n_flags) & 0x1FFFF;
 }
 static inline __le32 iwl4965_hw_set_rate_n_flags(u8 rate, u16 flags)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 469c143..5129d57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -620,17 +620,21 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 }
 
 /* FIXME:RS: in 4965 we don't use greenfield at all */
-static inline u8 rs_use_green(struct iwl_priv *priv,
-			      struct ieee80211_conf *conf)
+/* FIXME:RS: don't use greenfield for now in TX */
+/* #ifdef CONFIG_IWL4965_HT */
+#if 0
+static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
 {
-#ifdef CONFIG_IWL4965_HT
 	return ((conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
 		priv->current_ht_config.is_green_field &&
 		!priv->current_ht_config.non_GF_STA_present);
+}
 #else
+static inline u8 rs_use_green(struct iwl_priv *priv, struct ieee80211_conf *conf)
+{
 	return 0;
-#endif	/* CONFIG_IWL4965_HT */
 }
+#endif	/* CONFIG_IWL4965_HT */
 
 /**
  * rs_get_supported_rates - get the available rates
@@ -1058,7 +1062,7 @@ static void rs_set_expected_tpt_table(struct iwl4965_lq_sta *lq_sta,
 static s32 rs_get_best_rate(struct iwl_priv *priv,
 			    struct iwl4965_lq_sta *lq_sta,
 			    struct iwl4965_scale_tbl_info *tbl,	/* "search" */
-			    u16 rate_mask, s8 index, s8 rate)
+			    u16 rate_mask, s8 index)
 {
 	/* "active" values */
 	struct iwl4965_scale_tbl_info *active_tbl =
@@ -1071,6 +1075,7 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 
 	s32 new_rate, high, low, start_hi;
 	u16 high_low;
+	s8 rate = index;
 
 	new_rate = high = low = start_hi = IWL_RATE_INVALID;
 
@@ -1197,7 +1202,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 
 	rs_set_expected_tpt_table(lq_sta, tbl);
 
-	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
+	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
 
 	IWL_DEBUG_RATE("LQ: MIMO2 best rate %d mask %X\n", rate, rate_mask);
 
@@ -1270,7 +1275,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 		tbl->is_SGI = 0; /*11n spec: no SGI in SISO+Greenfield*/
 
 	rs_set_expected_tpt_table(lq_sta, tbl);
-	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index, index);
+	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
 
 	IWL_DEBUG_RATE("LQ: get best rate %d mask %X\n", rate, rate_mask);
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
@@ -1284,7 +1289,6 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	return 0;
 #else
 	return -1;
-
 #endif	/*CONFIG_IWL4965_HT */
 }
 
@@ -1311,7 +1315,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	for (; ;) {
 		switch (tbl->action) {
 		case IWL_LEGACY_SWITCH_ANTENNA:
-			IWL_DEBUG_RATE("LQ Legacy toggle Antenna\n");
+			IWL_DEBUG_RATE("LQ: Legacy toggle Antenna\n");
 
 			lq_sta->action_counter++;
 
@@ -1580,9 +1584,6 @@ static void rs_stay_in_table(struct iwl4965_lq_sta *lq_sta)
 				       (unsigned long)(lq_sta->flush_timer +
 					IWL_RATE_SCALE_FLUSH_INTVL));
 
-		/* For now, disable the elapsed time criterion */
-		flush_interval_passed = 0;
-
 		/*
 		 * Check if we should allow search for new modulation mode.
 		 * If many frames have failed or succeeded, or we've used
-- 
1.5.3.4

