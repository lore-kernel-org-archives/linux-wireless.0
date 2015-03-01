Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbCATcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/31] iwlwifi: mvm: allow to force the Rx chains from debugfs
Date: Sun,  1 Mar 2015 21:31:34 +0200
Message-Id: <1425238304-498-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203419_126260_147A0812)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful to debug weird antenna problems.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 54 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  1 +
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c    |  2 +
 3 files changed, 57 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 5fe1459..7faad90 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -545,6 +545,57 @@ static ssize_t iwl_dbgfs_uapsd_misbehaving_write(struct ieee80211_vif *vif,
 	return ret ? count : -EINVAL;
 }
 
+static ssize_t iwl_dbgfs_rx_phyinfo_write(struct ieee80211_vif *vif, char *buf,
+					  size_t count, loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct iwl_mvm_phy_ctxt *phy_ctxt;
+	u16 value;
+	int ret;
+
+	ret = kstrtou16(buf, 0, &value);
+	if (ret)
+		return ret;
+
+	mutex_lock(&mvm->mutex);
+	rcu_read_lock();
+
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	/* make sure the channel context is assigned */
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		mutex_unlock(&mvm->mutex);
+		return -EINVAL;
+	}
+
+	phy_ctxt = &mvm->phy_ctxts[*(u16 *)chanctx_conf->drv_priv];
+	rcu_read_unlock();
+
+	mvm->dbgfs_rx_phyinfo = value;
+
+	ret = iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &chanctx_conf->min_def,
+				       chanctx_conf->rx_chains_static,
+				       chanctx_conf->rx_chains_dynamic);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
+static ssize_t iwl_dbgfs_rx_phyinfo_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ieee80211_vif *vif = file->private_data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	char buf[8];
+
+	snprintf(buf, sizeof(buf), "0x%04x\n", mvmvif->mvm->dbgfs_rx_phyinfo);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, sizeof(buf));
+}
+
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -560,6 +611,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(uapsd_misbehaving, 20);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(rx_phyinfo, 10);
 
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
@@ -595,6 +647,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 				 S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE_VIF(uapsd_misbehaving, mvmvif->dbgfs_dir,
 				 S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE_VIF(rx_phyinfo, mvmvif->dbgfs_dir,
+				 S_IRUSR | S_IWUSR);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvmvif == mvm->bf_allowed_vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f78a006..885d096 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -681,6 +681,7 @@ struct iwl_mvm {
 
 	struct iwl_mvm_frame_stats drv_rx_stats;
 	spinlock_t drv_stats_lock;
+	u16 dbgfs_rx_phyinfo;
 #endif
 
 	struct iwl_mvm_phy_ctxt phy_ctxts[NUM_PHY_CTX];
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 5b43616..1bd10ed 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -175,6 +175,8 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
 	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
 					 PHY_RX_CHAIN_MIMO_CNT_POS);
+	if (unlikely(mvm->dbgfs_rx_phyinfo))
+		cmd->rxchain_info = cpu_to_le32(mvm->dbgfs_rx_phyinfo);
 
 	cmd->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 }
-- 
1.9.1

