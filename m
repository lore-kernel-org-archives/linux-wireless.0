Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1734 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbKXQ5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 11:57:20 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: Fix write permission on few debugfs files
Date: Tue, 24 Nov 2015 22:26:37 +0530
Message-ID: <1448384198-19964-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20151124_175724_474337_2CD6CE60)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Fix write permission for few of the debugfs entries
which support write file operations as well.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 145c066..b502b7f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2185,8 +2185,8 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("wmi_services", S_IRUSR, ar->debug.debugfs_phy, ar,
 			    &fops_wmi_services);
 
-	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
-			    ar, &fops_simulate_fw_crash);
+	debugfs_create_file("simulate_fw_crash", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_simulate_fw_crash);
 
 	debugfs_create_file("fw_crash_dump", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_fw_crash_dump);
@@ -2203,15 +2203,15 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
-	debugfs_create_file("htt_stats_mask", S_IRUSR, ar->debug.debugfs_phy,
-			    ar, &fops_htt_stats_mask);
+	debugfs_create_file("htt_stats_mask", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_htt_stats_mask);
 
 	debugfs_create_file("htt_max_amsdu_ampdu", S_IRUSR | S_IWUSR,
 			    ar->debug.debugfs_phy, ar,
 			    &fops_htt_max_amsdu_ampdu);
 
-	debugfs_create_file("fw_dbglog", S_IRUSR, ar->debug.debugfs_phy,
-			    ar, &fops_fw_dbglog);
+	debugfs_create_file("fw_dbglog", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_fw_dbglog);
 
 	debugfs_create_file("cal_data", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_cal_data);
-- 
1.7.9.5

