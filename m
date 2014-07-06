Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:34484 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaGFJgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:55 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so3158948wes.28
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/40] iwlwifi: mvm: init lmac scan command
Date: Sun,  6 Jul 2014 12:35:57 +0300
Message-Id: <1404639376-3792-21-git-send-email-egrumbach@gmail.com> (sfid-20140706_115952_677610_7911496D)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Initialize LMAC scan command.
Fix EBS flag to be dependant on TLV flg and fix other bugs.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 919ed0e..14fc6ad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1099,6 +1099,7 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 				       struct iwl_scan_req_unified_lmac *cmd,
 				       struct iwl_mvm_scan_params *params)
 {
+	memset(cmd, 0, ksize(cmd));
 	cmd->active_dwell = (u8)params->dwell[IEEE80211_BAND_2GHZ].active;
 	cmd->passive_dwell = (u8)params->dwell[IEEE80211_BAND_2GHZ].passive;
 	/* TODO: Use params; now fragmented isn't used. */
@@ -1107,14 +1108,19 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
 	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
-	cmd->channel_opt[0].flags = mvm->last_ebs_successful ?
-				cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS &
-					    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE &
-					    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD) :
-				0;
-	cmd->channel_opt[0].non_ebs_ratio = 0;
 	cmd->iter_num = cpu_to_le32(1);
-	cmd->delay = 0;
+
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT &&
+	    mvm->last_ebs_successful) {
+		cmd->channel_opt[0].flags =
+			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
+				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+		cmd->channel_opt[1].flags =
+			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
+				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
+	}
 }
 
 int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
-- 
1.8.3.2

