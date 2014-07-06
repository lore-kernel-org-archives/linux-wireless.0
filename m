Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39475 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaGFJgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:52 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so14480319wib.7
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:51 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/40] iwlwifi: mvm: rs: don't save debugfs files
Date: Sun,  6 Jul 2014 12:35:55 +0300
Message-Id: <1404639376-3792-19-git-send-email-egrumbach@gmail.com> (sfid-20140706_115953_301445_8BEC35F8)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

These file are removed recursively anyway, so there's no
point saving them just to redundantly remove them later.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 31 ++++++++++---------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  5 -----
 2 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 67bd8d7..c70e959 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3185,31 +3185,20 @@ static const struct file_operations rs_sta_dbgfs_drv_tx_stats_ops = {
 static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
 {
 	struct iwl_lq_sta *lq_sta = mvm_sta;
-	lq_sta->pers.rs_sta_dbgfs_scale_table_file =
-		debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
-				    lq_sta, &rs_sta_dbgfs_scale_table_ops);
-	lq_sta->pers.rs_sta_dbgfs_stats_table_file =
-		debugfs_create_file("rate_stats_table", S_IRUSR, dir,
-				    lq_sta, &rs_sta_dbgfs_stats_table_ops);
-	lq_sta->pers.rs_sta_dbgfs_drv_tx_stats_file =
-		debugfs_create_file("drv_tx_stats", S_IRUSR | S_IWUSR, dir,
-				    lq_sta, &rs_sta_dbgfs_drv_tx_stats_ops);
-	lq_sta->pers.rs_sta_dbgfs_tx_agg_tid_en_file =
-		debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
-				  &lq_sta->tx_agg_tid_en);
-	lq_sta->pers.rs_sta_dbgfs_reduced_txp_file =
-		debugfs_create_u8("reduced_tpc", S_IRUSR | S_IWUSR, dir,
-				  &lq_sta->pers.dbg_fixed_txp_reduction);
+	debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
+			    lq_sta, &rs_sta_dbgfs_scale_table_ops);
+	debugfs_create_file("rate_stats_table", S_IRUSR, dir,
+			    lq_sta, &rs_sta_dbgfs_stats_table_ops);
+	debugfs_create_file("drv_tx_stats", S_IRUSR | S_IWUSR, dir,
+			    lq_sta, &rs_sta_dbgfs_drv_tx_stats_ops);
+	debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
+			  &lq_sta->tx_agg_tid_en);
+	debugfs_create_u8("reduced_tpc", S_IRUSR | S_IWUSR, dir,
+			  &lq_sta->pers.dbg_fixed_txp_reduction);
 }
 
 static void rs_remove_debugfs(void *mvm, void *mvm_sta)
 {
-	struct iwl_lq_sta *lq_sta = mvm_sta;
-	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_scale_table_file);
-	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_stats_table_file);
-	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_drv_tx_stats_file);
-	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_tx_agg_tid_en_file);
-	debugfs_remove(lq_sta->pers.rs_sta_dbgfs_reduced_txp_file);
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 2e1a683..f27b9d6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -363,11 +363,6 @@ struct iwl_lq_sta {
 	/* persistent fields - initialized only once - keep last! */
 	struct {
 #ifdef CONFIG_MAC80211_DEBUGFS
-		struct dentry *rs_sta_dbgfs_scale_table_file;
-		struct dentry *rs_sta_dbgfs_stats_table_file;
-		struct dentry *rs_sta_dbgfs_drv_tx_stats_file;
-		struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
-		struct dentry *rs_sta_dbgfs_reduced_txp_file;
 		u32 dbg_fixed_rate;
 		u8 dbg_fixed_txp_reduction;
 #endif
-- 
1.8.3.2

