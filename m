Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaL3OU0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/33] iwlwifi: tlv: add support for IWL_UCODE_TLV_SDIO_ADMA_ADDR TLV
Date: Tue, 30 Dec 2014 16:19:03 +0200
Message-Id: <1419949148-24046-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154349_801227_DEB5D1C5)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

A new TLV supplies the ADMA address for SDIO mode, allowing
the driver to configure the default base address to be this
(as given in the FW), rather than hardcoding the values to
use until the FW sends the ALIVE message.

Use the value given by the FW in the IWL_UCODE_TLV_SDIO_ADMA_ADDR
TLV for setting the default SDTM base address until the FW sends
the ALIVE message. If it isn't given in the FW - use the current
hardcoded values.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     | 6 ++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h      | 4 ++++
 drivers/net/wireless/iwlwifi/iwl-trans.h   | 4 ++++
 drivers/net/wireless/iwlwifi/mvm/ops.c     | 2 ++
 5 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 0381dc4..0d34726 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -903,6 +903,12 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 					    IWL_UCODE_REGULAR_USNIFFER,
 					    tlv_len);
 			break;
+		case IWL_UCODE_TLV_SDIO_ADMA_ADDR:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			drv->fw.sdio_adma_addr =
+				le32_to_cpup((__le32 *)tlv_data);
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index f2a047f..752c72b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -132,6 +132,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_ENABLED_CAPABILITIES	= 30,
 	IWL_UCODE_TLV_N_SCAN_CHANNELS		= 31,
 	IWL_UCODE_TLV_SEC_RT_USNIFFER	= 34,
+	IWL_UCODE_TLV_SDIO_ADMA_ADDR	= 35,
 	IWL_UCODE_TLV_FW_DBG_DEST	= 38,
 	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index e6dc3b8..ffd785c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -152,6 +152,8 @@ struct iwl_fw_cscheme_list {
  * @mvm_fw: indicates this is MVM firmware
  * @cipher_scheme: optional external cipher scheme.
  * @human_readable: human readable version
+ * @sdio_adma_addr: the default address to set for the ADMA in SDIO mode until
+ *	we get the ALIVE from the uCode
  * @dbg_dest_tlv: points to the destination TLV for debug
  * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
  * @dbg_conf_tlv_len: lengths of the @dbg_conf_tlv entries
@@ -181,6 +183,8 @@ struct iwl_fw {
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
 
+	u32 sdio_adma_addr;
+
 	struct iwl_fw_dbg_dest_tlv *dbg_dest_tlv;
 	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
 	size_t dbg_conf_tlv_len[FW_DBG_MAX];
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 10ae9d7..84d8477 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -382,6 +382,8 @@ enum iwl_trans_status {
  *	are considered stuck and will trigger device restart
  * @command_names: array of command names, must be 256 entries
  *	(one for each command); for debugging only
+ * @sdio_adma_addr: the default address to set for the ADMA in SDIO mode until
+ *	we get the ALIVE from the uCode
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
@@ -396,6 +398,8 @@ struct iwl_trans_config {
 	bool scd_set_active;
 	unsigned int queue_watchdog_timeout;
 	const char *const *command_names;
+
+	u32 sdio_adma_addr;
 };
 
 struct iwl_trans_dump_data {
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 6bb6546..4906967 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -481,6 +481,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.cmd_fifo = IWL_MVM_TX_FIFO_CMD;
 	trans_cfg.scd_set_active = true;
 
+	trans_cfg.sdio_adma_addr = fw->sdio_adma_addr;
+
 	snprintf(mvm->hw->wiphy->fw_version,
 		 sizeof(mvm->hw->wiphy->fw_version),
 		 "%s", fw->fw_version);
-- 
1.9.1

