Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbbLAJ7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:18 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/41] iwlwifi: mvm: Enable MPLUT only on supported hw
Date: Tue,  1 Dec 2015 11:58:33 +0200
Message-Id: <1448963947-24302-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105926_523979_070DB89F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

When there's a bt-wifi contention that requires arbitration,
we use a priority-based mechanism to decide which comm wins.
Over time, use cases become more and more complex, with multiple
concurrent active links with different traffic types and different QoS
requirements, on both WiFi and BT sides.
This, in turn, requires us to elaborate our prioritization mechanism.
However, our legacy products included hw that does not supports this,
so selectively enable this on specific hw - as signaled by the firmware.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c    | 5 +----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     | 7 +++++++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 08303db..6aeeceb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -308,6 +308,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT: supports gscan
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
+ * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -334,6 +335,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
+	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index e290ac6..808f234 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -443,11 +443,8 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	if (iwl_mvm_bt_is_plcr_supported(mvm))
 		bt_cmd.enabled_modules |= cpu_to_le32(BT_COEX_CORUN_ENABLED);
 
-	if (IWL_MVM_BT_COEX_MPLUT) {
+	if (iwl_mvm_is_mplut_supported(mvm))
 		bt_cmd.enabled_modules |= cpu_to_le32(BT_COEX_MPLUT_ENABLED);
-		bt_cmd.enabled_modules |=
-			cpu_to_le32(BT_COEX_MPLUT_BOOST_ENABLED);
-	}
 
 	bt_cmd.enabled_modules |= cpu_to_le32(BT_COEX_HIGH_BAND_RET);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 419afa4..aff71d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -976,6 +976,13 @@ static inline bool iwl_mvm_is_csum_supported(struct iwl_mvm *mvm)
 			   IWL_UCODE_TLV_CAPA_CSUM_SUPPORT);
 }
 
+static inline bool iwl_mvm_is_mplut_supported(struct iwl_mvm *mvm)
+{
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT) &&
+		IWL_MVM_BT_COEX_MPLUT;
+}
+
 static inline bool iwl_mvm_has_new_rx_api(struct iwl_mvm *mvm)
 {
 	/* firmware flag isn't defined yet */
-- 
2.5.0

