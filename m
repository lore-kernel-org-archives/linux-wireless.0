Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40748 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbcEJU3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:26 +0300
Message-Id: <1462910797-20303-30-git-send-email-luca@coelho.fi> (sfid-20160510_222939_624087_D4CFF74D)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 30/41] iwlwifi: mvm: use helpers to get iwl_mvm_sta
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Getting the mvm station out of station id requires dereferencing
the station id to get ieee80211_sta, then checking for pointer
validity and only then extract mvm station out.
Given that there are helpers to do it - use them instead of
duplicating the code whenever we need only mvm station.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          | 8 ++------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 9 +++------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         | 6 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         | 7 +------
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c          | 8 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          | 7 +++----
 6 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index e3561bb..4fdc3da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1804,7 +1804,6 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	struct iwl_wowlan_status *fw_status;
 	int i;
 	bool keep;
-	struct ieee80211_sta *ap_sta;
 	struct iwl_mvm_sta *mvm_ap_sta;
 
 	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
@@ -1823,13 +1822,10 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	status.wake_packet = fw_status->wake_packet;
 
 	/* still at hard-coded place 0 for D3 image */
-	ap_sta = rcu_dereference_protected(
-			mvm->fw_id_to_mac_id[0],
-			lockdep_is_held(&mvm->mutex));
-	if (IS_ERR_OR_NULL(ap_sta))
+	mvm_ap_sta = iwl_mvm_sta_from_staid_protected(mvm, 0);
+	if (!mvm_ap_sta)
 		goto out_free;
 
-	mvm_ap_sta = iwl_mvm_sta_from_mac80211(ap_sta);
 	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
 		u16 seq = status.qos_seq_ctr[i];
 		/* firmware stores last-used value, we store next value */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index fb96bc0..b232717 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -281,13 +281,10 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 
 	if (vif->type == NL80211_IFTYPE_STATION &&
 	    ap_sta_id != IWL_MVM_STATION_COUNT) {
-		struct ieee80211_sta *sta;
-
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[ap_sta_id],
-						lockdep_is_held(&mvm->mutex));
-		if (!IS_ERR_OR_NULL(sta)) {
-			struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+		struct iwl_mvm_sta *mvm_sta;
 
+		mvm_sta = iwl_mvm_sta_from_staid_protected(mvm, ap_sta_id);
+		if (mvm_sta) {
 			pos += scnprintf(buf+pos, bufsz-pos,
 					 "ap_sta_id %d - reduced Tx power %d\n",
 					 ap_sta_id,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 2ba1369..6f91c5b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1210,7 +1210,6 @@ static bool iwl_mvm_disallow_offloading(struct iwl_mvm *mvm,
 					struct iwl_d0i3_iter_data *iter_data)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct ieee80211_sta *ap_sta;
 	struct iwl_mvm_sta *mvmsta;
 	u32 available_tids = 0;
 	u8 tid;
@@ -1219,11 +1218,10 @@ static bool iwl_mvm_disallow_offloading(struct iwl_mvm *mvm,
 		    mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
 		return false;
 
-	ap_sta = rcu_dereference(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id]);
-	if (IS_ERR_OR_NULL(ap_sta))
+	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, mvmvif->ap_sta_id);
+	if (!mvmsta)
 		return false;
 
-	mvmsta = iwl_mvm_sta_from_mac80211(ap_sta);
 	spin_lock_bh(&mvmsta->lock);
 	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
 		struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e7f1da5..855684a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1756,17 +1756,12 @@ static struct iwl_mvm_sta *iwl_mvm_get_key_sta(struct iwl_mvm *mvm,
 	    mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 		u8 sta_id = mvmvif->ap_sta_id;
 
-		sta = rcu_dereference_check(mvm->fw_id_to_mac_id[sta_id],
-					    lockdep_is_held(&mvm->mutex));
 		/*
 		 * It is possible that the 'sta' parameter is NULL,
 		 * for example when a GTK is removed - the sta_id will then
 		 * be the AP ID, and no station was passed by mac80211.
 		 */
-		if (IS_ERR_OR_NULL(sta))
-			return NULL;
-
-		return iwl_mvm_sta_from_mac80211(sta);
+		return iwl_mvm_sta_from_staid_protected(mvm, sta_id);
 	}
 
 	return NULL;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index eb3f460..58fc7b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -359,16 +359,14 @@ static void iwl_mvm_tt_smps_iterator(void *_data, u8 *mac,
 
 static void iwl_mvm_tt_tx_protection(struct iwl_mvm *mvm, bool enable)
 {
-	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
 	int i, err;
 
 	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
-						lockdep_is_held(&mvm->mutex));
-		if (IS_ERR_OR_NULL(sta))
+		mvmsta = iwl_mvm_sta_from_staid_protected(mvm, i);
+		if (!mvmsta)
 			continue;
-		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
 		if (enable == mvmsta->tt_tx_protection)
 			continue;
 		err = iwl_mvm_tx_protection(mvm, mvmsta, enable);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 3b64568..ff615b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1464,7 +1464,7 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int sta_id = IWL_MVM_TX_RES_GET_RA(tx_resp->ra_tid);
 	int tid = IWL_MVM_TX_RES_GET_TID(tx_resp->ra_tid);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
 
 	if (WARN_ON_ONCE(SEQ_TO_QUEUE(sequence) < mvm->first_agg_queue))
 		return;
@@ -1476,10 +1476,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 
 	rcu_read_lock();
 
-	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, sta_id);
 
-	if (!WARN_ON_ONCE(IS_ERR_OR_NULL(sta))) {
-		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	if (!WARN_ON_ONCE(!mvmsta)) {
 		mvmsta->tid_data[tid].rate_n_flags =
 			le32_to_cpu(tx_resp->initial_rate);
 		mvmsta->tid_data[tid].tx_time =
-- 
2.8.1

