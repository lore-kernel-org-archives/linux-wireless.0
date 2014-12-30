Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaL3OT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:57 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/33] iwlwifi: support multiple d0i3 modes
Date: Tue, 30 Dec 2014 16:18:52 +0200
Message-Id: <1419949148-24046-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154347_969208_7AA65D55)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Allow configuring additional d0i3 mode, in which the
fw will be configured to enter d0i3 only on suspend
(while keeping the wake_lock accounting as usual)

The d0i3 mode to use will be determined by the
underlying trans layer.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 028408a..10ae9d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -552,6 +552,21 @@ enum iwl_trans_state {
 };
 
 /**
+ * enum iwl_d0i3_mode - d0i3 mode
+ *
+ * @IWL_D0I3_MODE_OFF - d0i3 is disabled
+ * @IWL_D0I3_MODE_ON_IDLE - enter d0i3 when device is idle
+ *	(e.g. no active references)
+ * @IWL_D0I3_MODE_ON_SUSPEND - enter d0i3 only on suspend
+ *	(in case of 'any' trigger)
+ */
+enum iwl_d0i3_mode {
+	IWL_D0I3_MODE_OFF = 0,
+	IWL_D0I3_MODE_ON_IDLE,
+	IWL_D0I3_MODE_ON_SUSPEND,
+};
+
+/**
  * struct iwl_trans - transport common data
  *
  * @ops - pointer to iwl_trans_ops
@@ -612,6 +627,8 @@ struct iwl_trans {
 	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
 	u8 dbg_dest_reg_num;
 
+	enum iwl_d0i3_mode d0i3_mode;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ff1a409..e608dc4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -850,6 +850,7 @@ iwl_mvm_sta_from_staid_protected(struct iwl_mvm *mvm, u8 sta_id)
 static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 {
 	return mvm->trans->cfg->d0i3 &&
+	       mvm->trans->d0i3_mode != IWL_D0I3_MODE_OFF &&
 	       (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
-- 
1.9.1

