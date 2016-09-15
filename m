Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54876 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753418AbcIOSMr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:28 +0300
Message-Id: <20160915181131.32213-22-luca@coelho.fi> (sfid-20160915_201250_071358_70A4D073)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: unify iwl_get_ucode_image() implementations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

Avoid multiple implementations.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c | 11 +----------
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h    |  9 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c    | 13 ++-----------
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
index b662cf3..c7509c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
@@ -46,15 +46,6 @@
  *
  ******************************************************************************/
 
-static inline const struct fw_img *
-iwl_get_ucode_image(struct iwl_priv *priv, enum iwl_ucode_type ucode_type)
-{
-	if (ucode_type >= IWL_UCODE_TYPE_MAX)
-		return NULL;
-
-	return &priv->fw->img[ucode_type];
-}
-
 /*
  *  Calibration
  */
@@ -330,7 +321,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	enum iwl_ucode_type old_type;
 	static const u16 alive_cmd[] = { REPLY_ALIVE };
 
-	fw = iwl_get_ucode_image(priv, ucode_type);
+	fw = iwl_get_ucode_image(priv->fw, ucode_type);
 	if (WARN_ON(!fw))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 74ea68d..5f22955 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -329,4 +329,13 @@ iwl_fw_dbg_conf_usniffer(const struct iwl_fw *fw, u8 id)
 	return conf_tlv->usniffer;
 }
 
+static inline const struct fw_img *
+iwl_get_ucode_image(const struct iwl_fw *fw, enum iwl_ucode_type ucode_type)
+{
+	if (ucode_type >= IWL_UCODE_TYPE_MAX)
+		return NULL;
+
+	return &fw->img[ucode_type];
+}
+
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index b951a7f..7322c43 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -90,15 +90,6 @@ struct iwl_mvm_alive_data {
 	u32 scd_base_addr;
 };
 
-static inline const struct fw_img *
-iwl_get_ucode_image(struct iwl_mvm *mvm, enum iwl_ucode_type ucode_type)
-{
-	if (ucode_type >= IWL_UCODE_TYPE_MAX)
-		return NULL;
-
-	return &mvm->fw->img[ucode_type];
-}
-
 static int iwl_send_tx_ant_cfg(struct iwl_mvm *mvm, u8 valid_tx_ant)
 {
 	struct iwl_tx_ant_cfg_cmd tx_ant_cmd = {
@@ -592,9 +583,9 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_START_FROM_ALIVE) &&
 	    !(fw_has_capa(&mvm->fw->ucode_capa,
 			  IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED)))
-		fw = iwl_get_ucode_image(mvm, IWL_UCODE_REGULAR_USNIFFER);
+		fw = iwl_get_ucode_image(mvm->fw, IWL_UCODE_REGULAR_USNIFFER);
 	else
-		fw = iwl_get_ucode_image(mvm, ucode_type);
+		fw = iwl_get_ucode_image(mvm->fw, ucode_type);
 	if (WARN_ON(!fw))
 		return -EINVAL;
 	mvm->cur_ucode = ucode_type;
-- 
2.9.3
