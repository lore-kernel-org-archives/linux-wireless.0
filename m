Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbbDBGl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/31] iwlwifi: mvm: assign new TLV bit for multi-source LAR
Date: Thu,  2 Apr 2015 09:40:50 +0300
Message-Id: <1427956879-11725-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084128_949583_A5F77640)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

According to FW methodology, the capability bits should be the only ones
that change per-HW. The API bits should remain constant across different
HWs.
Currently this is not the case with multi-source LAR (API bit 9). Assign
a new capability bit to eventually replace the API bit. Until the API bit
can be deprecated, the driver will check either to enable multi-source
LAR.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 5 +++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 291a338..60f3f86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -290,6 +290,10 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
  * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
  * @IWL_UCODE_TLV_CAPA_BT_COEX_PLCR: enabled BT Coex packet level co-running
+ * @IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC: ucode supports LAR updates with different
+ *	sources for the MCC. This TLV bit is a future replacement to
+ *	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE. When either is set, multi-source LAR
+ *	is supported.
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  */
 enum iwl_ucode_tlv_capa {
@@ -307,6 +311,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
 	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= BIT(22),
 	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= BIT(28),
+	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= BIT(29),
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= BIT(30),
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4903dec..23c6c8a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -936,7 +936,8 @@ static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_is_wifi_mcc_supported(struct iwl_mvm *mvm)
 {
-	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_WIFI_MCC_UPDATE;
+	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_WIFI_MCC_UPDATE ||
+	       mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC;
 }
 
 static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
-- 
1.9.1

