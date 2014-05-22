Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:48465 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaEVHYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:18 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so2963223wes.7
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/11] iwlwifi: mvm: remove debugfs hook for reduced tx power
Date: Thu, 22 May 2014 10:23:53 +0300
Message-Id: <1400743435-702-9-git-send-email-egrumbach@gmail.com> (sfid-20140522_092729_313862_0020FAD0)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This was not used is unlikely to be used, just kill it.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  6 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 42 ++------------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  1 -
 drivers/net/wireless/iwlwifi/mvm/sta.h         |  3 --
 4 files changed, 5 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index e35f5a0..c8c3b38 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -715,7 +715,8 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable)
+static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
+				       bool enable)
 {
 	struct iwl_bt_coex_cmd *bt_cmd;
 	/* Send ASYNC since this can be sent from an atomic context */
@@ -733,8 +734,7 @@ int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable)
 		return 0;
 
 	/* nothing to do */
-	if (mvmsta->bt_reduced_txpower_dbg ||
-	    mvmsta->bt_reduced_txpower == enable)
+	if (mvmsta->bt_reduced_txpower == enable)
 		return 0;
 
 	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_ATOMIC);
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 21793c8..44b19e6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -262,10 +262,9 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 			struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
 
 			pos += scnprintf(buf+pos, bufsz-pos,
-					 "ap_sta_id %d - reduced Tx power %d force %d\n",
+					 "ap_sta_id %d - reduced Tx power %d\n",
 					 ap_sta_id,
-					 mvm_sta->bt_reduced_txpower,
-					 mvm_sta->bt_reduced_txpower_dbg);
+					 mvm_sta->bt_reduced_txpower);
 		}
 	}
 
@@ -283,41 +282,6 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_reduced_txp_write(struct ieee80211_vif *vif,
-					   char *buf, size_t count,
-					   loff_t *ppos)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	struct iwl_mvm_sta *mvmsta;
-	bool reduced_tx_power;
-	int ret;
-
-	if (mvmvif->ap_sta_id >= ARRAY_SIZE(mvm->fw_id_to_mac_id))
-		return -ENOTCONN;
-
-	if (strtobool(buf, &reduced_tx_power) != 0)
-		return -EINVAL;
-
-	mutex_lock(&mvm->mutex);
-
-	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, mvmvif->ap_sta_id);
-	if (IS_ERR_OR_NULL(mvmsta)) {
-		mutex_unlock(&mvm->mutex);
-		return -ENOTCONN;
-	}
-
-	mvmsta->bt_reduced_txpower_dbg = false;
-	ret = iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
-					  reduced_tx_power);
-	if (!ret)
-		mvmsta->bt_reduced_txpower_dbg = true;
-
-	mutex_unlock(&mvm->mutex);
-
-	return ret ? : count;
-}
-
 static void iwl_dbgfs_update_bf(struct ieee80211_vif *vif,
 				enum iwl_dbgfs_bf_mask param, int value)
 {
@@ -558,7 +522,6 @@ MVM_DEBUGFS_READ_FILE_OPS(mac_params);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
-MVM_DEBUGFS_WRITE_FILE_OPS(reduced_txp, 10);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -590,7 +553,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 					 S_IRUSR);
 
 	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE_VIF(reduced_txp, mvmvif->dbgfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index da8dc14..20884b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -967,7 +967,6 @@ bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 				    enum ieee80211_band band);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac);
-int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable);
 
 enum iwl_bt_kill_msk {
 	BT_KILL_MSK_DEFAULT,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index e5e3071..d98e8a2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -287,8 +287,6 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
  * @tid_disable_agg: bitmap: if bit(tid) is set, the fw won't send ampdus for
  *	tid.
  * @max_agg_bufsize: the maximal size of the AGG buffer for this station
- * @bt_reduced_txpower_dbg: debug mode in which %bt_reduced_txpower is forced
- *	by debugfs.
  * @bt_reduced_txpower: is reduced tx power enabled for this station
  * @next_status_eosp: the next reclaimed packet is a PS-Poll response and
  *	we need to signal the EOSP
@@ -309,7 +307,6 @@ struct iwl_mvm_sta {
 	u32 mac_id_n_color;
 	u16 tid_disable_agg;
 	u8 max_agg_bufsize;
-	bool bt_reduced_txpower_dbg;
 	bool bt_reduced_txpower;
 	bool next_status_eosp;
 	spinlock_t lock;
-- 
1.8.3.2

