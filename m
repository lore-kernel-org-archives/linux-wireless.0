Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933676AbcCIRqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/21] iwlwifi: mvm: update GSCAN capabilities
Date: Wed,  9 Mar 2016 19:45:50 +0200
Message-Id: <1457545550-30677-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185950_209515_AB8C9B2F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Gscan capabilities were updated with new capabilities supported
by the device. While at it, simplify the firmware support
conditional and move both conditions into the WARN() to make it
easier to undertand and use the unlikely() for both.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 38 +++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 11 +++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h      | 13 ++++++++
 3 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 184c0fe..f899666 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -374,15 +376,12 @@ static int iwl_store_cscheme(struct iwl_fw *fw, const u8 *data, const u32 len)
 	return 0;
 }
 
-static int iwl_store_gscan_capa(struct iwl_fw *fw, const u8 *data,
-				const u32 len)
+static void iwl_store_gscan_capa(struct iwl_fw *fw, const u8 *data,
+				 const u32 len)
 {
 	struct iwl_fw_gscan_capabilities *fw_capa = (void *)data;
 	struct iwl_gscan_capabilities *capa = &fw->gscan_capa;
 
-	if (len < sizeof(*fw_capa))
-		return -EINVAL;
-
 	capa->max_scan_cache_size = le32_to_cpu(fw_capa->max_scan_cache_size);
 	capa->max_scan_buckets = le32_to_cpu(fw_capa->max_scan_buckets);
 	capa->max_ap_cache_per_scan =
@@ -395,7 +394,15 @@ static int iwl_store_gscan_capa(struct iwl_fw *fw, const u8 *data,
 		le32_to_cpu(fw_capa->max_significant_change_aps);
 	capa->max_bssid_history_entries =
 		le32_to_cpu(fw_capa->max_bssid_history_entries);
-	return 0;
+	capa->max_hotlist_ssids = le32_to_cpu(fw_capa->max_hotlist_ssids);
+	capa->max_number_epno_networks =
+		le32_to_cpu(fw_capa->max_number_epno_networks);
+	capa->max_number_epno_networks_by_ssid =
+		le32_to_cpu(fw_capa->max_number_epno_networks_by_ssid);
+	capa->max_number_of_white_listed_ssid =
+		le32_to_cpu(fw_capa->max_number_of_white_listed_ssid);
+	capa->max_number_of_black_listed_ssid =
+		le32_to_cpu(fw_capa->max_number_of_black_listed_ssid);
 }
 
 /*
@@ -1023,8 +1030,15 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_FW_GSCAN_CAPA:
-			if (iwl_store_gscan_capa(&drv->fw, tlv_data, tlv_len))
-				goto invalid_tlv_len;
+			/*
+			 * Don't return an error in case of a shorter tlv_len
+			 * to enable loading of FW that has an old format
+			 * of GSCAN capabilities TLV.
+			 */
+			if (tlv_len < sizeof(struct iwl_fw_gscan_capabilities))
+				break;
+
+			iwl_store_gscan_capa(&drv->fw, tlv_data, tlv_len);
 			gscan_capa = true;
 			break;
 		default:
@@ -1046,12 +1060,8 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		return -EINVAL;
 	}
 
-	/*
-	 * If ucode advertises that it supports GSCAN but GSCAN
-	 * capabilities TLV is not present, warn and continue without GSCAN.
-	 */
-	if (fw_has_capa(capa, IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT) &&
-	    WARN(!gscan_capa,
+	if (WARN(fw_has_capa(capa, IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT) &&
+		 !gscan_capa,
 		 "GSCAN is supported but capabilities TLV is unavailable\n"))
 		__clear_bit((__force long)IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT,
 			    capa->_capa);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 5f69bf5..15ec4e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -809,6 +809,12 @@ struct iwl_fw_dbg_conf_tlv {
  *	change APs.
  * @max_bssid_history_entries: number of BSSID/RSSI entries that the device can
  *	hold.
+ * @max_hotlist_ssids: maximum number of entries for hotlist SSIDs.
+ * @max_number_epno_networks: max number of epno entries.
+ * @max_number_epno_networks_by_ssid: max number of epno entries if ssid is
+ *	specified.
+ * @max_number_of_white_listed_ssid: max number of white listed SSIDs.
+ * @max_number_of_black_listed_ssid: max number of black listed SSIDs.
  */
 struct iwl_fw_gscan_capabilities {
 	__le32 max_scan_cache_size;
@@ -819,6 +825,11 @@ struct iwl_fw_gscan_capabilities {
 	__le32 max_hotlist_aps;
 	__le32 max_significant_change_aps;
 	__le32 max_bssid_history_entries;
+	__le32 max_hotlist_ssids;
+	__le32 max_number_epno_networks;
+	__le32 max_number_epno_networks_by_ssid;
+	__le32 max_number_of_white_listed_ssid;
+	__le32 max_number_of_black_listed_ssid;
 } __packed;
 
 #endif  /* __iwl_fw_file_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 85d6d6d..2942571 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -205,6 +207,12 @@ struct iwl_fw_cscheme_list {
  *	change APs.
  * @max_bssid_history_entries: number of BSSID/RSSI entries that the device can
  *	hold.
+ * @max_hotlist_ssids: maximum number of entries for hotlist SSIDs.
+ * @max_number_epno_networks: max number of epno entries.
+ * @max_number_epno_networks_by_ssid: max number of epno entries if ssid is
+ *	specified.
+ * @max_number_of_white_listed_ssid: max number of white listed SSIDs.
+ * @max_number_of_black_listed_ssid: max number of black listed SSIDs.
  */
 struct iwl_gscan_capabilities {
 	u32 max_scan_cache_size;
@@ -215,6 +223,11 @@ struct iwl_gscan_capabilities {
 	u32 max_hotlist_aps;
 	u32 max_significant_change_aps;
 	u32 max_bssid_history_entries;
+	u32 max_hotlist_ssids;
+	u32 max_number_epno_networks;
+	u32 max_number_epno_networks_by_ssid;
+	u32 max_number_of_white_listed_ssid;
+	u32 max_number_of_black_listed_ssid;
 };
 
 /**
-- 
2.5.0

