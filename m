Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62545 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaBCU66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:58 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so4064482eae.9
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:57 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/62] iwlwifi: mvm: allow to force reduced tx power from debugfs
Date: Mon,  3 Feb 2014 22:57:33 +0200
Message-Id: <1391461088-8082-27-git-send-email-egrumbach@gmail.com> (sfid-20140203_220009_380528_4F1417A1)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will be useful during tests done on the physical layer.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c     |    6 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |   40 +++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |    1 +
 drivers/net/wireless/iwlwifi/mvm/sta.h         |    3 ++
 4 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index ed20f4e..9649a43 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -489,8 +489,7 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
-				       bool enable)
+int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable)
 {
 	struct iwl_bt_coex_cmd *bt_cmd;
 	/* Send ASYNC since this can be sent from an atomic context */
@@ -508,7 +507,8 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 		return 0;
 
 	/* nothing to do */
-	if (mvmsta->bt_reduced_txpower == enable)
+	if (mvmsta->bt_reduced_txpower_dbg ||
+	    mvmsta->bt_reduced_txpower == enable)
 		return 0;
 
 	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_ATOMIC);
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 19ecade..9194709 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -249,9 +249,10 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 			struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
 
 			pos += scnprintf(buf+pos, bufsz-pos,
-					 "ap_sta_id %d - reduced Tx power %d\n",
+					 "ap_sta_id %d - reduced Tx power %d force %d\n",
 					 ap_sta_id,
-					 mvm_sta->bt_reduced_txpower);
+					 mvm_sta->bt_reduced_txpower,
+					 mvm_sta->bt_reduced_txpower_dbg);
 		}
 	}
 
@@ -269,6 +270,36 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_reduced_txp_write(struct ieee80211_vif *vif,
+					   char *buf, size_t count,
+					   loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	struct iwl_mvm_sta *mvmsta;
+	bool reduced_tx_power;
+	int ret;
+
+	if (mvmvif->ap_sta_id >= ARRAY_SIZE(mvm->fw_id_to_mac_id))
+		return -ENOTCONN;
+
+	if (strtobool(buf, &reduced_tx_power) != 0)
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+
+	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, mvmvif->ap_sta_id);
+	mvmsta->bt_reduced_txpower_dbg = false;
+	ret = iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
+					  reduced_tx_power);
+	if (!ret)
+		mvmsta->bt_reduced_txpower_dbg = true;
+
+	mutex_unlock(&mvm->mutex);
+
+	return ret ? : count;
+}
+
 static void iwl_dbgfs_update_bf(struct ieee80211_vif *vif,
 				enum iwl_dbgfs_bf_mask param, int value)
 {
@@ -509,6 +540,7 @@ MVM_DEBUGFS_READ_FILE_OPS(mac_params);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
+MVM_DEBUGFS_WRITE_FILE_OPS(reduced_txp, 10);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -539,8 +571,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		MVM_DEBUGFS_ADD_FILE_VIF(pm_params, mvmvif->dbgfs_dir, S_IWUSR |
 					 S_IRUSR);
 
-	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir,
-				 S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(reduced_txp, mvmvif->dbgfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 43f13ab..80052d9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -888,6 +888,7 @@ u16 iwl_mvm_bt_coex_agg_time_limit(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta);
+int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable);
 
 enum iwl_bt_kill_msk {
 	BT_KILL_MSK_DEFAULT,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 64f9a1b..5ecabdd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -284,6 +284,8 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
  * @tid_disable_agg: bitmap: if bit(tid) is set, the fw won't send ampdus for
  *	tid.
  * @max_agg_bufsize: the maximal size of the AGG buffer for this station
+ * @bt_reduced_txpower_dbg: debug mode in which %bt_reduced_txpower is forced
+ *	by debugfs.
  * @bt_reduced_txpower: is reduced tx power enabled for this station
  * @next_status_eosp: the next reclaimed packet is a PS-Poll response and
  *	we need to signal the EOSP
@@ -304,6 +306,7 @@ struct iwl_mvm_sta {
 	u32 mac_id_n_color;
 	u16 tid_disable_agg;
 	u8 max_agg_bufsize;
+	bool bt_reduced_txpower_dbg;
 	bool bt_reduced_txpower;
 	bool next_status_eosp;
 	spinlock_t lock;
-- 
1.7.9.5

