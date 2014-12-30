Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaL3OUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:24 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/33] iwlwifi: mvm: use iwl_mvm_sta_from_mac80211() consistently
Date: Tue, 30 Dec 2014 16:19:02 +0200
Message-Id: <1419949148-24046-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154348_835536_2708EA22)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A number of places (still) use a direct operation, use
iwl_mvm_sta_from_mac80211() consistently. In one place
also move it into the variable initializer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c          |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c          | 13 +++++--------
 drivers/net/wireless/iwlwifi/mvm/sta.c         | 12 ++++++------
 6 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 4b5849e..14e8fd6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -793,7 +793,7 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 			  struct ieee80211_sta *ap_sta)
 {
 	int ret;
-	struct iwl_mvm_sta *mvm_ap_sta = (struct iwl_mvm_sta *)ap_sta->drv_priv;
+	struct iwl_mvm_sta *mvm_ap_sta = iwl_mvm_sta_from_mac80211(ap_sta);
 
 	/* TODO: wowlan_config_cmd->wowlan_ba_teardown_tids */
 
@@ -1657,7 +1657,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	if (IS_ERR_OR_NULL(ap_sta))
 		goto out_free;
 
-	mvm_ap_sta = (struct iwl_mvm_sta *)ap_sta->drv_priv;
+	mvm_ap_sta = iwl_mvm_sta_from_mac80211(ap_sta);
 	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
 		u16 seq = status.qos_seq_ctr[i];
 		/* firmware stores last-used value, we store next value */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 9aa2311..8dc3ca9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -268,7 +268,7 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[ap_sta_id],
 						lockdep_is_held(&mvm->mutex));
 		if (!IS_ERR_OR_NULL(sta)) {
-			struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+			struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
 			pos += scnprintf(buf+pos, bufsz-pos,
 					 "ap_sta_id %d - reduced Tx power %d\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 084689b..c4552b5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2137,7 +2137,7 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 				       struct ieee80211_sta *sta)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
 	/*
 	 * This is called before mac80211 does RCU synchronisation,
@@ -3152,7 +3152,7 @@ static int iwl_mvm_set_tim(struct ieee80211_hw *hw,
 			   bool set)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
 	if (!mvm_sta || !mvm_sta->vif) {
 		IWL_ERR(mvm, "Station is not associated to a vif\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 17f58ca..6bb6546 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1146,7 +1146,7 @@ void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq)
 
 	if (mvm->d0i3_offloading && qos_seq) {
 		/* update qos seq numbers if offloading was enabled */
-		mvm_ap_sta = (struct iwl_mvm_sta *)sta->drv_priv;
+		mvm_ap_sta = iwl_mvm_sta_from_mac80211(sta);
 		for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
 			u16 seq = le16_to_cpu(qos_seq[i]);
 			/* firmware stores last-used one, we store next one */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 999efc3..568829d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1946,7 +1946,7 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 			   struct iwl_lq_sta *lq_sta,
 			   struct iwl_scale_tbl_info *tbl)
 {
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct ieee80211_vif *vif = mvm_sta->vif;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	enum ieee80211_band band;
@@ -2055,7 +2055,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	u16 high_low;
 	s32 sr;
 	u8 prev_agg = lq_sta->is_agg;
-	struct iwl_mvm_sta *sta_priv = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
 	struct rs_rate *rate;
 
@@ -2541,7 +2541,7 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
 			  gfp_t gfp)
 {
-	struct iwl_mvm_sta *sta_priv = (struct iwl_mvm_sta *)sta->drv_priv;
+	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)mvm_rate;
 	struct iwl_mvm *mvm  = IWL_OP_MODE_GET_MVM(op_mode);
 	struct iwl_lq_sta *lq_sta = &sta_priv->lq_sta;
@@ -2694,14 +2694,11 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	struct ieee80211_hw *hw = mvm->hw;
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
-	struct iwl_mvm_sta *sta_priv;
-	struct iwl_lq_sta *lq_sta;
+	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_lq_sta *lq_sta = &sta_priv->lq_sta;
 	struct ieee80211_supported_band *sband;
 	unsigned long supp; /* must be unsigned long for for_each_set_bit */
 
-	sta_priv = (struct iwl_mvm_sta *)sta->drv_priv;
-	lq_sta = &sta_priv->lq_sta;
-
 	/* clear all non-persistent lq data */
 	memset(lq_sta, 0, offsetof(typeof(*lq_sta), pers));
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 9eaa96e..ad32798 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -99,7 +99,7 @@ static int iwl_mvm_find_free_sta_id(struct iwl_mvm *mvm,
 int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			   bool update)
 {
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd add_sta_cmd = {
 		.sta_id = mvm_sta->sta_id,
 		.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color),
@@ -259,7 +259,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	int i, ret, sta_id;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -481,7 +481,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		   struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -774,7 +774,7 @@ int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       int tid, u16 ssn, bool start)
 {
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd cmd = {};
 	int ret;
 	u32 status;
@@ -834,7 +834,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			      int tid, u8 queue, bool start)
 {
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_add_sta_cmd cmd = {};
 	int ret;
 	u32 status;
@@ -1147,7 +1147,7 @@ static u8 iwl_mvm_get_key_sta_id(struct ieee80211_vif *vif,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (sta) {
-		struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+		struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
 		return mvm_sta->sta_id;
 	}
-- 
1.9.1

