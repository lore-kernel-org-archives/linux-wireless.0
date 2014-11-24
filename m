Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57559 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbaKXOfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:40 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so5847555wiw.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:39 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/75] iwlwifi: mvm: go to umac scan even if lmac tlv bit is on
Date: Mon, 24 Nov 2014 16:34:02 +0200
Message-Id: <1416839691-28533-26-git-send-email-egrumbach@gmail.com> (sfid-20141124_154347_254261_070AF5AC)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

LMAC TLV bit may be on in FWs that support UMAC scan; so check
for UMAC TLV bit first.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 79ad695..bc5883a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1951,10 +1951,10 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
-		ret = iwl_mvm_unified_scan_lmac(mvm, vif, hw_req);
-	else if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
 		ret = iwl_mvm_scan_umac(mvm, vif, hw_req);
+	else if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		ret = iwl_mvm_unified_scan_lmac(mvm, vif, hw_req);
 	else
 		ret = iwl_mvm_scan_request(mvm, vif, req);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index c440b7b..2191745 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1025,17 +1025,17 @@ int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
 {
 	int ret;
 
-	if ((mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
-		mvm->scan_status = IWL_MVM_SCAN_SCHED;
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 		if (ret)
 			return ret;
-		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
-	} else if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies);
+	} else if ((mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
+		mvm->scan_status = IWL_MVM_SCAN_SCHED;
 		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 		if (ret)
 			return ret;
-		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies);
+		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
 	} else {
 		mvm->scan_status = IWL_MVM_SCAN_SCHED;
 		ret = iwl_mvm_config_sched_scan(mvm, vif, req, ies);
-- 
1.9.1

