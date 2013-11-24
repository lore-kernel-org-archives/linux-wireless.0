Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51099 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3KXUHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:02 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so2982702wgg.28
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:01 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/29] iwlwifi: mvm: implement rate_update hook in rs
Date: Sun, 24 Nov 2013 22:06:26 +0200
Message-Id: <1385323606-3603-9-git-send-email-egrumbach@gmail.com> (sfid-20131124_210810_007047_A0286F93)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Re-initialize rs when we get a rate_update hook called which
happens when remote STA changes bandwidth or sends a VHT opmode
notification.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    3 ++-
 drivers/net/wireless/iwlwifi/mvm/rs.c       |   30 +++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/rs.h       |    2 +-
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 74bc2c8..0cc9c1e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1149,7 +1149,8 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		ret = iwl_mvm_update_sta(mvm, vif, sta);
 		if (ret == 0)
 			iwl_mvm_rs_rate_init(mvm, sta,
-					     mvmvif->phy_ctxt->channel->band);
+					     mvmvif->phy_ctxt->channel->band,
+					     true);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		/* enable beacon filtering */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index e49bf44..a85938c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2126,7 +2126,8 @@ out:
 static void rs_initialize_lq(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta,
 			     struct iwl_lq_sta *lq_sta,
-			     enum ieee80211_band band)
+			     enum ieee80211_band band,
+			     bool init)
 {
 	struct iwl_scale_tbl_info *tbl;
 	int rate_idx;
@@ -2168,7 +2169,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, NULL, lq_sta, rate);
 	/* TODO restore station should remember the lq cmd */
-	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, true);
+	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, init);
 }
 
 static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
@@ -2273,7 +2274,7 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
  * Called after adding a new station to initialize rate scaling
  */
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  enum ieee80211_band band)
+			  enum ieee80211_band band, bool init)
 {
 	int i, j;
 	struct ieee80211_hw *hw = mvm->hw;
@@ -2286,6 +2287,8 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	sta_priv = (struct iwl_mvm_sta *)sta->drv_priv;
 	lq_sta = &sta_priv->lq_sta;
+	memset(lq_sta, 0, sizeof(*lq_sta));
+
 	sband = hw->wiphy->bands[band];
 
 	lq_sta->lq.sta_id = sta_priv->sta_id;
@@ -2371,7 +2374,25 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lq_sta->dbg_fixed_rate = 0;
 #endif
 
-	rs_initialize_lq(mvm, sta, lq_sta, band);
+	rs_initialize_lq(mvm, sta, lq_sta, band, init);
+}
+
+static void rs_rate_update(void *mvm_r,
+			   struct ieee80211_supported_band *sband,
+			   struct cfg80211_chan_def *chandef,
+			   struct ieee80211_sta *sta, void *priv_sta,
+			   u32 changed)
+{
+	u8 tid;
+	struct iwl_op_mode *op_mode  =
+			(struct iwl_op_mode *)mvm_r;
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	/* Stop any ongoing aggregations as rs starts off assuming no agg */
+	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++)
+		ieee80211_stop_tx_ba_session(sta, tid);
+
+	iwl_mvm_rs_rate_init(mvm, sta, sband->band, false);
 }
 
 static void rs_fill_link_cmd(struct iwl_mvm *mvm,
@@ -2808,6 +2829,7 @@ static struct rate_control_ops rs_mvm_ops = {
 	.free = rs_free,
 	.alloc_sta = rs_alloc_sta,
 	.free_sta = rs_free_sta,
+	.rate_update = rs_rate_update,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = rs_add_debugfs,
 	.remove_sta_debugfs = rs_remove_debugfs,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 5d5344f..8d5dc78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -353,7 +353,7 @@ static inline u8 num_of_ant(u8 mask)
 
 /* Initialize station's rate scaling information after adding station */
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  enum ieee80211_band band);
+			  enum ieee80211_band band, bool init);
 
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
-- 
1.7.9.5

