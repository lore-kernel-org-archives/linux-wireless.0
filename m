Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab2B0XTC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:02 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/24] iwlwifi: parse_tlv functions set the fw_version string
Date: Mon, 27 Feb 2012 14:07:25 -0800
Message-Id: <1330380468-17674-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001910_096664_513801EE)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

struct iwl_fw contains a string that describe the fw. This string
is now set by the iwl_parse_*_firmware.
This string is later used to update the cfg80211 data.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-ucode.c |   70 ++++++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-ucode.h |    5 +-
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 61c6c05..ea75709 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -731,8 +731,6 @@ struct iwlagn_firmware_pieces {
 	size_t inst_size, data_size, init_size, init_data_size,
 	       wowlan_inst_size, wowlan_data_size;
 
-	u32 build;
-
 	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 };
@@ -742,7 +740,8 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 				       struct iwlagn_firmware_pieces *pieces)
 {
 	struct iwl_ucode_header *ucode = (void *)ucode_raw->data;
-	u32 api_ver, hdr_size;
+	u32 api_ver, hdr_size, build;
+	char buildstr[25];
 	const u8 *src;
 
 	nic->fw.ucode_ver = le32_to_cpu(ucode->ver);
@@ -755,7 +754,7 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 			IWL_ERR(nic, "File size too small!\n");
 			return -EINVAL;
 		}
-		pieces->build = le32_to_cpu(ucode->u.v2.build);
+		build = le32_to_cpu(ucode->u.v2.build);
 		pieces->inst_size = le32_to_cpu(ucode->u.v2.inst_size);
 		pieces->data_size = le32_to_cpu(ucode->u.v2.data_size);
 		pieces->init_size = le32_to_cpu(ucode->u.v2.init_size);
@@ -770,7 +769,7 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 			IWL_ERR(nic, "File size too small!\n");
 			return -EINVAL;
 		}
-		pieces->build = 0;
+		build = 0;
 		pieces->inst_size = le32_to_cpu(ucode->u.v1.inst_size);
 		pieces->data_size = le32_to_cpu(ucode->u.v1.data_size);
 		pieces->init_size = le32_to_cpu(ucode->u.v1.init_size);
@@ -779,6 +778,22 @@ static int iwl_parse_v1_v2_firmware(struct iwl_nic *nic,
 		break;
 	}
 
+	if (build)
+		sprintf(buildstr, " build %u%s", build,
+		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
+				? " (EXP)" : "");
+	else
+		buildstr[0] = '\0';
+
+	snprintf(nic->fw.fw_version,
+		 sizeof(nic->fw.fw_version),
+		 "%u.%u.%u.%u%s",
+		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
+		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
+		 IWL_UCODE_API(nic->fw.ucode_ver),
+		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
+		 buildstr);
+
 	/* Verify size of file vs. image size info in file's header */
 	if (ucode_raw->size != hdr_size + pieces->inst_size +
 				pieces->data_size + pieces->init_size +
@@ -817,6 +832,8 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 	u32 tlv_len;
 	enum iwl_ucode_tlv_type tlv_type;
 	const u8 *tlv_data;
+	char buildstr[25];
+	u32 build;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(nic, "uCode has invalid length: %zd\n", len);
@@ -847,7 +864,24 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 			 tmp, wanted_alternative);
 
 	nic->fw.ucode_ver = le32_to_cpu(ucode->ver);
-	pieces->build = le32_to_cpu(ucode->build);
+	build = le32_to_cpu(ucode->build);
+
+	if (build)
+		sprintf(buildstr, " build %u%s", build,
+		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
+				? " (EXP)" : "");
+	else
+		buildstr[0] = '\0';
+
+	snprintf(nic->fw.fw_version,
+		 sizeof(nic->fw.fw_version),
+		 "%u.%u.%u.%u%s",
+		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
+		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
+		 IWL_UCODE_API(nic->fw.ucode_ver),
+		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
+		 buildstr);
+
 	data = ucode->data;
 
 	len -= sizeof(*ucode);
@@ -1021,8 +1055,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	unsigned int api_ok = cfg->ucode_api_ok;
 	const unsigned int api_min = cfg->ucode_api_min;
 	u32 api_ver;
-	char buildstr[25];
-	u32 build;
 
 	fw->ucode_capa.max_probe_length = 200;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1063,7 +1095,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		goto try_again;
 
 	api_ver = IWL_UCODE_API(nic->fw.ucode_ver);
-	build = pieces.build;
 
 	/*
 	 * api_ver should match the api version forming part of the
@@ -1094,28 +1125,11 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		}
 	}
 
-	if (build)
-		sprintf(buildstr, " build %u%s", build,
-		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
-				? " (EXP)" : "");
-	else
-		buildstr[0] = '\0';
-
-	IWL_INFO(nic, "loaded firmware version %u.%u.%u.%u%s\n",
-		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
-		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
-		 IWL_UCODE_API(nic->fw.ucode_ver),
-		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
-		 buildstr);
+	IWL_INFO(nic, "loaded firmware version %s", nic->fw.fw_version);
 
 	snprintf(priv->hw->wiphy->fw_version,
 		 sizeof(priv->hw->wiphy->fw_version),
-		 "%u.%u.%u.%u%s",
-		 IWL_UCODE_MAJOR(nic->fw.ucode_ver),
-		 IWL_UCODE_MINOR(nic->fw.ucode_ver),
-		 IWL_UCODE_API(nic->fw.ucode_ver),
-		 IWL_UCODE_SERIAL(nic->fw.ucode_ver),
-		 buildstr);
+		 "%s", nic->fw.fw_version);
 
 	/*
 	 * For any of the failures below (before allocating pci memory)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.h b/drivers/net/wireless/iwlwifi/iwl-ucode.h
index d13e624..8bebeb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.h
@@ -204,9 +204,8 @@ struct fw_img {
  */
 struct iwl_fw {
 
-	/* ucode image and variables */
-	u32 ucode_ver;                  /* version of ucode, copy of
-					   iwl_ucode.ver */
+	u32 ucode_ver;
+
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 
 	/* ucode images */
-- 
1.7.0.4

