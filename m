Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbbHRH6C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/26] iwlwifi: add new TLV capability flag for gscan support
Date: Tue, 18 Aug 2015 10:57:16 +0300
Message-Id: <1439884656-18146-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095807_524986_80387723)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Gscan is a scan feature which is supported on certain devices only,
hence the need for a TLV flag for it. For devices that support gscan
store the gscan capabilities advertised by the FW so the driver can
report it to upper layers.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     | 40 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 27 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h      | 25 +++++++++++++++++++
 3 files changed, 92 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 721d3cb..a86aa5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -372,6 +372,30 @@ static int iwl_store_cscheme(struct iwl_fw *fw, const u8 *data, const u32 len)
 	return 0;
 }
 
+static int iwl_store_gscan_capa(struct iwl_fw *fw, const u8 *data,
+				const u32 len)
+{
+	struct iwl_fw_gscan_capabilities *fw_capa = (void *)data;
+	struct iwl_gscan_capabilities *capa = &fw->gscan_capa;
+
+	if (len < sizeof(*fw_capa))
+		return -EINVAL;
+
+	capa->max_scan_cache_size = le32_to_cpu(fw_capa->max_scan_cache_size);
+	capa->max_scan_buckets = le32_to_cpu(fw_capa->max_scan_buckets);
+	capa->max_ap_cache_per_scan =
+		le32_to_cpu(fw_capa->max_ap_cache_per_scan);
+	capa->max_rssi_sample_size = le32_to_cpu(fw_capa->max_rssi_sample_size);
+	capa->max_scan_reporting_threshold =
+		le32_to_cpu(fw_capa->max_scan_reporting_threshold);
+	capa->max_hotlist_aps = le32_to_cpu(fw_capa->max_hotlist_aps);
+	capa->max_significant_change_aps =
+		le32_to_cpu(fw_capa->max_significant_change_aps);
+	capa->max_bssid_history_entries =
+		le32_to_cpu(fw_capa->max_bssid_history_entries);
+	return 0;
+}
+
 /*
  * Gets uCode section from tlv.
  */
@@ -581,6 +605,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	int num_of_cpus;
 	bool usniffer_images = false;
 	bool usniffer_req = false;
+	bool gscan_capa = false;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -991,6 +1016,11 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			drv->fw.sdio_adma_addr =
 				le32_to_cpup((__le32 *)tlv_data);
 			break;
+		case IWL_UCODE_TLV_FW_GSCAN_CAPA:
+			if (iwl_store_gscan_capa(&drv->fw, tlv_data, tlv_len))
+				goto invalid_tlv_len;
+			gscan_capa = true;
+			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -1009,6 +1039,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		return -EINVAL;
 	}
 
+	/*
+	 * If ucode advertises that it supports GSCAN but GSCAN
+	 * capabilities TLV is not present, warn and continue without GSCAN.
+	 */
+	if (fw_has_capa(capa, IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT) &&
+	    WARN(!gscan_capa,
+		 "GSCAN is supported but capabilities TLV is unavailable\n"))
+		__clear_bit((__force long)IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT,
+			    capa->_capa);
+
 	return 0;
 
  invalid_tlv_len:
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 5d7f2d9..d1c5b90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -139,6 +139,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_FW_DBG_DEST	= 38,
 	IWL_UCODE_TLV_FW_DBG_CONF	= 39,
 	IWL_UCODE_TLV_FW_DBG_TRIGGER	= 40,
+	IWL_UCODE_TLV_FW_GSCAN_CAPA	= 50,
 };
 
 struct iwl_ucode_tlv {
@@ -306,6 +307,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  *	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE. When either is set, multi-source LAR
  *	is supported.
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
+ * @IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT: supports gscan
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= (__force iwl_ucode_tlv_capa_t)0,
@@ -327,6 +329,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= (__force iwl_ucode_tlv_capa_t)28,
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
+	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
 };
 
 /* The default calibrate table size if not specified by firmware file */
@@ -728,4 +731,28 @@ struct iwl_fw_dbg_conf_tlv {
 	struct iwl_fw_dbg_conf_hcmd hcmd;
 } __packed;
 
+/**
+ * struct iwl_fw_gscan_capabilities - gscan capabilities supported by FW
+ * @max_scan_cache_size: total space allocated for scan results (in bytes).
+ * @max_scan_buckets: maximum number of channel buckets.
+ * @max_ap_cache_per_scan: maximum number of APs that can be stored per scan.
+ * @max_rssi_sample_size: number of RSSI samples used for averaging RSSI.
+ * @max_scan_reporting_threshold: max possible report threshold. in percentage.
+ * @max_hotlist_aps: maximum number of entries for hotlist APs.
+ * @max_significant_change_aps: maximum number of entries for significant
+ *	change APs.
+ * @max_bssid_history_entries: number of BSSID/RSSI entries that the device can
+ *	hold.
+ */
+struct iwl_fw_gscan_capabilities {
+	__le32 max_scan_cache_size;
+	__le32 max_scan_buckets;
+	__le32 max_ap_cache_per_scan;
+	__le32 max_rssi_sample_size;
+	__le32 max_scan_reporting_threshold;
+	__le32 max_hotlist_aps;
+	__le32 max_significant_change_aps;
+	__le32 max_bssid_history_entries;
+} __packed;
+
 #endif  /* __iwl_fw_file_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 224c7f4..0d9d6f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -191,6 +191,30 @@ struct iwl_fw_cscheme_list {
 } __packed;
 
 /**
+ * struct iwl_gscan_capabilities - gscan capabilities supported by FW
+ * @max_scan_cache_size: total space allocated for scan results (in bytes).
+ * @max_scan_buckets: maximum number of channel buckets.
+ * @max_ap_cache_per_scan: maximum number of APs that can be stored per scan.
+ * @max_rssi_sample_size: number of RSSI samples used for averaging RSSI.
+ * @max_scan_reporting_threshold: max possible report threshold. in percentage.
+ * @max_hotlist_aps: maximum number of entries for hotlist APs.
+ * @max_significant_change_aps: maximum number of entries for significant
+ *	change APs.
+ * @max_bssid_history_entries: number of BSSID/RSSI entries that the device can
+ *	hold.
+ */
+struct iwl_gscan_capabilities {
+	u32 max_scan_cache_size;
+	u32 max_scan_buckets;
+	u32 max_ap_cache_per_scan;
+	u32 max_rssi_sample_size;
+	u32 max_scan_reporting_threshold;
+	u32 max_hotlist_aps;
+	u32 max_significant_change_aps;
+	u32 max_bssid_history_entries;
+};
+
+/**
  * struct iwl_fw - variables associated with the firmware
  *
  * @ucode_ver: ucode version from the ucode file
@@ -248,6 +272,7 @@ struct iwl_fw {
 	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
 	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
 	u8 dbg_dest_reg_num;
+	struct iwl_gscan_capabilities gscan_capa;
 };
 
 static inline const char *get_fw_dbg_mode_string(int mode)
-- 
2.1.4

