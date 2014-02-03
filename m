Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55341 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBCUjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:39:36 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so3973744eaj.15
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:39:34 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/8] iwlwifi: mvm: notify match found without filtering
Date: Mon,  3 Feb 2014 22:39:19 +0200
Message-Id: <1391459962-7381-5-git-send-email-egrumbach@gmail.com> (sfid-20140203_213940_999338_CD9D8643)
In-Reply-To: <52EFFCE8.6070505@gmail.com>
References: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Configure scheduled scan to notify match found on every beacon
or probe response if the scan request doesn't contain valid ssid
list for filtering.
Without this configuration the FW passes all beacons to the host
but doesn't notify the stack that the scan results are ready for
processing.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |    4 +++-
 drivers/net/wireless/iwlwifi/mvm/scan.c        |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 73cbba7..9426905 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -504,6 +504,7 @@ struct iwl_scan_offload_profile {
  * @match_notify:	clients waiting for match found notification
  * @pass_match:		clients waiting for the results
  * @active_clients:	active clients bitmap - enum scan_framework_client
+ * @any_beacon_notify:	clients waiting for match notification without match
  */
 struct iwl_scan_offload_profile_cfg {
 	struct iwl_scan_offload_profile profiles[IWL_SCAN_MAX_PROFILES];
@@ -512,7 +513,8 @@ struct iwl_scan_offload_profile_cfg {
 	u8 match_notify;
 	u8 pass_match;
 	u8 active_clients;
-	u8 reserved[3];
+	u8 any_beacon_notify;
+	u8 reserved[2];
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 0e00079..c35f35c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -807,6 +807,8 @@ int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 	profile_cfg->active_clients = SCAN_CLIENT_SCHED_SCAN;
 	profile_cfg->pass_match = SCAN_CLIENT_SCHED_SCAN;
 	profile_cfg->match_notify = SCAN_CLIENT_SCHED_SCAN;
+	if (!req->n_match_sets || !req->match_sets[0].ssid.ssid_len)
+		profile_cfg->any_beacon_notify = SCAN_CLIENT_SCHED_SCAN;
 
 	for (i = 0; i < req->n_match_sets; i++) {
 		profile = &profile_cfg->profiles[i];
-- 
1.7.9.5

