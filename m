Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56939 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbaLBSMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:12:01 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so17893257wgh.20
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:12:00 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/26] iwlwifi: mvm: Ability to work with packed usniffer image
Date: Tue,  2 Dec 2014 20:11:17 +0200
Message-Id: <1417543877-24193-26-git-send-email-egrumbach@gmail.com> (sfid-20141202_191214_896857_3CAC2467)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The new ucode package format holds also the usniffer images
(in addition to the operational images and the TLVs).
The driver can load the usniffer image if debug
configuration tells it to.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     | 17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h      | 13 +++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c      |  7 ++++++-
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index a53b534..38de151 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -591,6 +591,8 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	char buildstr[25];
 	u32 build;
 	int num_of_cpus;
+	bool usniffer_images = false;
+	bool usniffer_req = false;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -908,6 +910,9 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				break;
 			}
 
+			if (conf->usniffer)
+				usniffer_req = true;
+
 			IWL_INFO(drv, "Found debug configuration: %d\n",
 				 conf->id);
 
@@ -915,12 +920,24 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			pieces->dbg_conf_tlv_len[conf->id] = tlv_len;
 			break;
 			}
+		case IWL_UCODE_TLV_SEC_RT_USNIFFER:
+			usniffer_images = true;
+			iwl_store_ucode_sec(pieces, tlv_data,
+					    IWL_UCODE_REGULAR_USNIFFER,
+					    tlv_len);
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
 		}
 	}
 
+	if (usniffer_req && !usniffer_images) {
+		IWL_ERR(drv,
+			"user selected to work with usniffer but usniffer image isn't available in ucode package\n");
+		return -EINVAL;
+	}
+
 	if (len) {
 		IWL_ERR(drv, "invalid TLV after parsing: %zd\n", len);
 		iwl_print_hex_dump(drv, IWL_DL_FW, (u8 *)data, len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 9faad69..f2a047f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -131,6 +131,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_API_CHANGES_SET	= 29,
 	IWL_UCODE_TLV_ENABLED_CAPABILITIES	= 30,
 	IWL_UCODE_TLV_N_SCAN_CHANNELS		= 31,
+	IWL_UCODE_TLV_SEC_RT_USNIFFER	= 34,
 	IWL_UCODE_TLV_FW_DBG_DEST	= 38,
 	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 20d44ea..e6dc3b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -77,11 +77,13 @@
  * @IWL_UCODE_REGULAR: Normal runtime ucode
  * @IWL_UCODE_INIT: Initial ucode
  * @IWL_UCODE_WOWLAN: Wake on Wireless enabled ucode
+ * @IWL_UCODE_REGULAR_USNIFFER: Normal runtime ucode when using usniffer image
  */
 enum iwl_ucode_type {
 	IWL_UCODE_REGULAR,
 	IWL_UCODE_INIT,
 	IWL_UCODE_WOWLAN,
+	IWL_UCODE_REGULAR_USNIFFER,
 	IWL_UCODE_TYPE_MAX,
 };
 
@@ -231,4 +233,15 @@ iwl_fw_dbg_conf_enabled(const struct iwl_fw *fw, u8 id)
 	return trigger->enabled;
 }
 
+static inline bool
+iwl_fw_dbg_conf_usniffer(const struct iwl_fw *fw, u8 id)
+{
+	const struct iwl_fw_dbg_conf_tlv *conf_tlv = fw->dbg_conf_tlv[id];
+
+	if (!conf_tlv)
+		return false;
+
+	return conf_tlv->usniffer;
+}
+
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 1f1337a..d0fa6e9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -186,7 +186,12 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	static const u8 alive_cmd[] = { MVM_ALIVE };
 	struct iwl_sf_region st_fwrd_space;
 
-	fw = iwl_get_ucode_image(mvm, ucode_type);
+	if (ucode_type == IWL_UCODE_REGULAR &&
+	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_CUSTOM) &&
+	    iwl_fw_dbg_conf_enabled(mvm->fw, FW_DBG_CUSTOM))
+		fw = iwl_get_ucode_image(mvm, IWL_UCODE_REGULAR_USNIFFER);
+	else
+		fw = iwl_get_ucode_image(mvm, ucode_type);
 	if (WARN_ON(!fw))
 		return -EINVAL;
 	mvm->cur_ucode = ucode_type;
-- 
1.9.1

