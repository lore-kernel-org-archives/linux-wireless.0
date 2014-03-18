Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47935 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbaCROp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:58 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so5454316eei.33
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/35] iwlwifi: mvm: fix scan offload for BGN SKU
Date: Tue, 18 Mar 2014 16:45:13 +0200
Message-Id: <1395153939-23897-9-git-send-email-egrumbach@gmail.com> (sfid-20140318_154824_237803_8543F55C)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

BGN SKU won't scan on 5.2GHz obviously, but the firmware
still expects the driver to reserve space for the the probe
request for the 5.2GHz band.
Fix this by allocating space and leave it empty.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=69541

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 713efd7..b4c9fb6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -709,7 +709,6 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 			      struct cfg80211_sched_scan_request *req,
 			      struct ieee80211_sched_scan_ies *ies)
 {
-	int supported_bands = 0;
 	int band_2ghz = mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels;
 	int band_5ghz = mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
 	int head = 0;
@@ -726,13 +725,8 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (band_2ghz)
-		supported_bands++;
-	if (band_5ghz)
-		supported_bands++;
-
 	cmd_len = sizeof(struct iwl_scan_offload_cfg) +
-				supported_bands * SCAN_OFFLOAD_PROBE_REQ_SIZE;
+		  2 * SCAN_OFFLOAD_PROBE_REQ_SIZE;
 
 	scan_cfg = kzalloc(cmd_len, GFP_KERNEL);
 	if (!scan_cfg)
-- 
1.8.3.2

