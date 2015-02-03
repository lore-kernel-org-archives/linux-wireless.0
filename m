Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966209AbbBCHPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:15 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/19] iwlwifi: mvm: Enable EBS also in single scan on umac interface
Date: Tue,  3 Feb 2015 09:14:35 +0200
Message-Id: <1422947678-16917-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081522_087395_8056F93C)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Enable EBS on one shot scans if supported by FW.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 4169e3d..8b74ce7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1863,6 +1863,13 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
 
 	cmd->general_flags = cpu_to_le32(flags);
+
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS &&
+	    mvm->last_ebs_successful)
+		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
+				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
+				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
+
 	cmd->n_channels = req->req.n_channels;
 
 	for (i = 0; i < req->req.n_ssids; i++)
-- 
1.9.1

