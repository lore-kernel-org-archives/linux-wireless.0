Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbbCLNEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:04:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/49] iwlwifi: mvm: fix compilation with IWLWIFI_DEBUGFS not set
Date: Thu, 12 Mar 2015 15:03:46 +0200
Message-Id: <1426165474-25586-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140445_438001_2DB44B18)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commits below broke compilation when
CONFIG_IWLWIFI_DEBUGFS is not set.
FIx that.

Fixes: ddf89ab10a93 ("iwlwifi: mvm: allow to force the Rx chains from debugfs")
Fixes: 9d761fd8a583 ("iwlwifi: mvm: add trigger for firmware dump upon missed beacons")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 1 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         | 2 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c    | 2 ++
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 7faad90..5f37eab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -627,7 +627,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 
 	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
-	mvmvif->mvm = mvm;
 
 	if (!mvmvif->dbgfs_dir) {
 		IWL_ERR(mvm, "Failed to create debugfs directory under %s\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5a5d5c8..2042554 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1346,6 +1346,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
+	mvmvif->mvm = mvm;
+
 	/*
 	 * make sure D0i3 exit is completed, otherwise a target access
 	 * during tx queue configuration could be done when still in
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f4ecd1b..e10172d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -356,6 +356,7 @@ struct iwl_mvm_vif_bf_data {
  *	average signal of beacons retrieved from the firmware
  */
 struct iwl_mvm_vif {
+	struct iwl_mvm *mvm;
 	u16 id;
 	u16 color;
 	u8 ap_sta_id;
@@ -418,7 +419,6 @@ struct iwl_mvm_vif {
 #endif
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	struct iwl_mvm *mvm;
 	struct dentry *dbgfs_dir;
 	struct dentry *dbgfs_slink;
 	struct iwl_dbgfs_pm dbgfs_pm;
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 1bd10ed..192b74b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -175,8 +175,10 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
 	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
 					 PHY_RX_CHAIN_MIMO_CNT_POS);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (unlikely(mvm->dbgfs_rx_phyinfo))
 		cmd->rxchain_info = cpu_to_le32(mvm->dbgfs_rx_phyinfo);
+#endif
 
 	cmd->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 }
-- 
1.9.1

