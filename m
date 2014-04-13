Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36478 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaDMTUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:20 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so4538702wib.5
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:19 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/47] iwlwifi: mvm: add debugfs file for fixed reduced tx power
Date: Sun, 13 Apr 2014 22:19:21 +0300
Message-Id: <1397416802-32403-6-git-send-email-egrumbach@gmail.com> (sfid-20140413_212229_970604_3223CE9C)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Allow fixing the tx power reduction through debugfs
file.

The change doesn't take affect immediately, but
will be considered the next time tpc is evaluated.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 14 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/rs.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index fd090bc..50fd460 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1863,6 +1863,15 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 	int weak, strong;
 	int weak_tpt = IWL_INVALID_VALUE, strong_tpt = IWL_INVALID_VALUE;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (lq_sta->dbg_fixed_txp_reduction <= TPC_MAX_REDUCTION) {
+		IWL_DEBUG_RATE(mvm, "fixed tpc: %d",
+			       lq_sta->dbg_fixed_txp_reduction);
+		lq_sta->lq.reduced_tpc = lq_sta->dbg_fixed_txp_reduction;
+		return cur != lq_sta->dbg_fixed_txp_reduction;
+	}
+#endif
+
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(vif->chanctx_conf);
 	if (WARN_ON(!chanctx_conf))
@@ -2613,6 +2622,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lq_sta->is_agg = 0;
 #ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->dbg_fixed_rate = 0;
+	lq_sta->dbg_fixed_txp_reduction = TPC_INVALID;
 #endif
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_mvm_reset_frame_stats(mvm, &mvm->drv_rx_stats);
@@ -3076,6 +3086,9 @@ static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
 		debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
 				  &lq_sta->tx_agg_tid_en);
+	lq_sta->rs_sta_dbgfs_reduced_txp_file =
+		debugfs_create_u8("reduced_tpc", S_IRUSR | S_IWUSR, dir,
+				  &lq_sta->dbg_fixed_txp_reduction);
 }
 
 static void rs_remove_debugfs(void *mvm, void *mvm_sta)
@@ -3084,6 +3097,7 @@ static void rs_remove_debugfs(void *mvm, void *mvm_sta)
 	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
 	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
+	debugfs_remove(lq_sta->rs_sta_dbgfs_reduced_txp_file);
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index d8b0345..fcc056d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -336,7 +336,9 @@ struct iwl_lq_sta {
 	struct dentry *rs_sta_dbgfs_scale_table_file;
 	struct dentry *rs_sta_dbgfs_stats_table_file;
 	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
+	struct dentry *rs_sta_dbgfs_reduced_txp_file;
 	u32 dbg_fixed_rate;
+	u8 dbg_fixed_txp_reduction;
 #endif
 	struct iwl_mvm *drv;
 
-- 
1.8.3.2

