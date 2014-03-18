Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64869 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaCROqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:00 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so5464073eek.4
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/35] iwlwifi: mvm: check for d0i3 fw capability
Date: Tue, 18 Mar 2014 16:45:14 +0200
Message-Id: <1395153939-23897-10-git-send-email-egrumbach@gmail.com> (sfid-20140318_154613_281454_60F422A5)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Check for both cfg->d0i3 and fw d0i3 support in order
to enable d0i3 support.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       | 8 ++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 6 +++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 6 ++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index f04ff87..18f867c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -125,6 +125,14 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
 };
 
+/**
+ * enum iwl_ucode_tlv_capa - ucode capabilities
+ * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
+ */
+enum iwl_ucode_tlv_capa {
+	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT		= BIT(0),
+};
+
 /* The default calibrate table size if not specified by firmware file */
 #define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE	18
 #define IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE		19
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index d74cc43..41b9e65 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -205,7 +205,7 @@ static const struct iwl_fw_bcast_filter iwl_mvm_default_bcast_filters[] = {
 
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
-	if (!mvm->trans->cfg->d0i3)
+	if (!iwl_mvm_is_d0i3_supported(mvm))
 		return;
 
 	IWL_DEBUG_RPM(mvm, "Take mvm reference - type %d\n", ref_type);
@@ -215,7 +215,7 @@ void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 
 void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
-	if (!mvm->trans->cfg->d0i3)
+	if (!iwl_mvm_is_d0i3_supported(mvm))
 		return;
 
 	IWL_DEBUG_RPM(mvm, "Leave mvm reference - type %d\n", ref_type);
@@ -228,7 +228,7 @@ iwl_mvm_unref_all_except(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref)
 {
 	int i;
 
-	if (!mvm->trans->cfg->d0i3)
+	if (!iwl_mvm_is_d0i3_supported(mvm))
 		return;
 
 	for_each_set_bit(i, mvm->ref_bitmap, IWL_MVM_REF_COUNT) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5fb5109..3511bf7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -656,6 +656,12 @@ iwl_mvm_sta_from_staid_protected(struct iwl_mvm *mvm, u8 sta_id)
 	return iwl_mvm_sta_from_mac80211(sta);
 }
 
+static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
+{
+	return mvm->trans->cfg->d0i3 &&
+	       (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
-- 
1.8.3.2

