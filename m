Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521Ab0GBSoe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8] iwlwifi: add debug print for parsing firmware TLV
Date: Fri,  2 Jul 2010 11:45:34 -0700
Message-Id: <1278096340-2546-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When parsing TLV during loading firmware, if encounter any TLV error,
log the error message to help debugging.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |  101 ++++++++++++++++++++------------
 1 files changed, 63 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3368cfd..22c0149 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1806,12 +1806,21 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 	const u8 *data;
 	int wanted_alternative = iwlagn_wanted_ucode_alternative, tmp;
 	u64 alternatives;
+	u32 tlv_len;
+	enum iwl_ucode_tlv_type tlv_type;
+	const u8 *tlv_data;
+	int ret = 0;
 
-	if (len < sizeof(*ucode))
+	if (len < sizeof(*ucode)) {
+		IWL_ERR(priv, "uCode has invalid length: %zd\n", len);
 		return -EINVAL;
+	}
 
-	if (ucode->magic != cpu_to_le32(IWL_TLV_UCODE_MAGIC))
+	if (ucode->magic != cpu_to_le32(IWL_TLV_UCODE_MAGIC)) {
+		IWL_ERR(priv, "invalid uCode magic: 0X%x\n",
+			le32_to_cpu(ucode->magic));
 		return -EINVAL;
+	}
 
 	/*
 	 * Check which alternatives are present, and "downgrade"
@@ -1836,11 +1845,9 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 
 	len -= sizeof(*ucode);
 
-	while (len >= sizeof(*tlv)) {
-		u32 tlv_len;
-		enum iwl_ucode_tlv_type tlv_type;
+	while (len >= sizeof(*tlv) && !ret) {
 		u16 tlv_alt;
-		const u8 *tlv_data;
+		u32 fixed_tlv_size = 4;
 
 		len -= sizeof(*tlv);
 		tlv = (void *)data;
@@ -1850,8 +1857,11 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 		tlv_alt = le16_to_cpu(tlv->alternative);
 		tlv_data = tlv->data;
 
-		if (len < tlv_len)
+		if (len < tlv_len) {
+			IWL_ERR(priv, "invalid TLV len: %zd/%u\n",
+				len, tlv_len);
 			return -EINVAL;
+		}
 		len -= ALIGN(tlv_len, 4);
 		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
 
@@ -1885,56 +1895,71 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			pieces->boot_size = tlv_len;
 			break;
 		case IWL_UCODE_TLV_PROBE_MAX_LEN:
-			if (tlv_len != 4)
-				return -EINVAL;
-			capa->max_probe_length =
-				le32_to_cpup((__le32 *)tlv_data);
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				capa->max_probe_length =
+					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
-			if (tlv_len != 4)
-				return -EINVAL;
-			pieces->init_evtlog_ptr =
-				le32_to_cpup((__le32 *)tlv_data);
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				pieces->init_evtlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_SIZE:
-			if (tlv_len != 4)
-				return -EINVAL;
-			pieces->init_evtlog_size =
-				le32_to_cpup((__le32 *)tlv_data);
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				pieces->init_evtlog_size =
+					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_INIT_ERRLOG_PTR:
-			if (tlv_len != 4)
-				return -EINVAL;
-			pieces->init_errlog_ptr =
-				le32_to_cpup((__le32 *)tlv_data);
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				pieces->init_errlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_RUNT_EVTLOG_PTR:
-			if (tlv_len != 4)
-				return -EINVAL;
-			pieces->inst_evtlog_ptr =
-				le32_to_cpup((__le32 *)tlv_data);
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				pieces->inst_evtlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_RUNT_EVTLOG_SIZE:
-			if (tlv_len != 4)
-				return -EINVAL;
-			pieces->inst_evtlog_size =
-				le32_to_cpup((__le32 *)tlv_data);
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				pieces->inst_evtlog_size =
+					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_RUNT_ERRLOG_PTR:
-			if (tlv_len != 4)
-				return -EINVAL;
-			pieces->inst_errlog_ptr =
-				le32_to_cpup((__le32 *)tlv_data);
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				pieces->inst_errlog_ptr =
+					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		default:
+			IWL_WARN(priv, "unknown TLV: %d\n", tlv_type);
 			break;
 		}
 	}
 
-	if (len)
-		return -EINVAL;
+	if (len) {
+		IWL_ERR(priv, "invalid TLV after parsing: %zd\n", len);
+		iwl_print_hex_dump(priv, IWL_DL_FW, (u8 *)data, len);
+		ret = -EINVAL;
+	} else if (ret) {
+		IWL_ERR(priv, "TLV %d has invalid size: %u\n",
+			tlv_type, tlv_len);
+		iwl_print_hex_dump(priv, IWL_DL_FW, (u8 *)tlv_data, tlv_len);
+	}
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
1.7.0.4

