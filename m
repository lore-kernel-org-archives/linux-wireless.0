Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44673 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaGFJg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:56 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so2067831wgg.21
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:55 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/40] iwlwifi: mvm: fix endianity in scan command
Date: Sun,  6 Jul 2014 12:35:58 +0300
Message-Id: <1404639376-3792-22-git-send-email-egrumbach@gmail.com> (sfid-20140706_115956_102168_E6EE8971)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 48a1d8f..c02a9e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -509,7 +509,7 @@ struct iwl_scan_offload_profile_cfg {
  * @full_scan_mul:	number of partial scans before each full scan
  */
 struct iwl_scan_offload_schedule {
-	u16 delay;
+	__le16 delay;
 	u8 iterations;
 	u8 full_scan_mul;
 } __packed;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 14fc6ad..004b1f5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -899,11 +899,11 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		.watchdog = IWL_SCHED_SCAN_WATCHDOG,
 
 		.schedule_line[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS,
-		.schedule_line[0].delay = req->interval / 1000,
+		.schedule_line[0].delay = cpu_to_le16(req->interval / 1000),
 		.schedule_line[0].full_scan_mul = 1,
 
 		.schedule_line[1].iterations = 0xff,
-		.schedule_line[1].delay = req->interval / 1000,
+		.schedule_line[1].delay = cpu_to_le16(req->interval / 1000),
 		.schedule_line[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER,
 	};
 
@@ -1281,11 +1281,11 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	iwl_mvm_unified_scan_fill_tx_cmd(mvm, cmd->tx_cmd, false);
 	iwl_scan_offload_build_ssid(req, cmd->direct_scan, &ssid_bitmap, false);
 
-	cmd->schedule[0].delay = req->interval / MSEC_PER_SEC;
+	cmd->schedule[0].delay = cpu_to_le16(req->interval / MSEC_PER_SEC);
 	cmd->schedule[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS;
 	cmd->schedule[0].full_scan_mul = 1;
 
-	cmd->schedule[1].delay = req->interval / MSEC_PER_SEC;
+	cmd->schedule[1].delay = cpu_to_le16(req->interval / MSEC_PER_SEC);
 	cmd->schedule[1].iterations = 0xff;
 	cmd->schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
 
-- 
1.8.3.2

