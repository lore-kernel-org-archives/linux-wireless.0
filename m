Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50242 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754343AbeFMFDp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 01:03:45 -0400
From: Surabhi Vishnoi <svishnoi@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH] ath10k: Skip data calibration for non-bmi target
Date: Wed, 13 Jun 2018 10:33:35 +0530
Message-Id: <1528866215-24754-1-git-send-email-svishnoi@codeaurora.org> (sfid-20180613_070354_423155_CF92D285)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In non-bmi target ex. WCN3990, data calibration
is handled via QMI.

Skip data calibration in debug routine to enable ath10k
debugfs for non bmi targets.

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 181fd8e..20a465d 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1965,7 +1965,9 @@ int ath10k_debug_start(struct ath10k *ar)
 			ath10k_warn(ar, "failed to disable pktlog: %d\n", ret);
 	}
 
-	if (ar->debug.nf_cal_period) {
+	if (ar->debug.nf_cal_period &&
+	    !test_bit(ATH10K_FW_FEATURE_NON_BMI,
+		      ar->normal_mode_fw.fw_file.fw_features)) {
 		ret = ath10k_wmi_pdev_set_param(ar,
 						ar->wmi.pdev_param->cal_period,
 						ar->debug.nf_cal_period);
@@ -1982,7 +1984,9 @@ void ath10k_debug_stop(struct ath10k *ar)
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath10k_debug_cal_data_fetch(ar);
+	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
+		      ar->normal_mode_fw.fw_file.fw_features))
+		ath10k_debug_cal_data_fetch(ar);
 
 	/* Must not use _sync to avoid deadlock, we do that in
 	 * ath10k_debug_destroy(). The check for htt_stats_mask is to avoid
@@ -2484,15 +2488,18 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("fw_dbglog", 0600, ar->debug.debugfs_phy, ar,
 			    &fops_fw_dbglog);
 
-	debugfs_create_file("cal_data", 0400, ar->debug.debugfs_phy, ar,
-			    &fops_cal_data);
+	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
+		      ar->normal_mode_fw.fw_file.fw_features)) {
+		debugfs_create_file("cal_data", 0400, ar->debug.debugfs_phy, ar,
+				    &fops_cal_data);
+
+		debugfs_create_file("nf_cal_period", 0600, ar->debug.debugfs_phy, ar,
+				    &fops_nf_cal_period);
+	}
 
 	debugfs_create_file("ani_enable", 0600, ar->debug.debugfs_phy, ar,
 			    &fops_ani_enable);
 
-	debugfs_create_file("nf_cal_period", 0600, ar->debug.debugfs_phy, ar,
-			    &fops_nf_cal_period);
-
 	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		debugfs_create_file("dfs_simulate_radar", 0200, ar->debug.debugfs_phy,
 				    ar, &fops_simulate_radar);
-- 
1.9.1
