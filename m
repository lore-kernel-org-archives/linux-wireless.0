Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085Ab0GWQN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlagn: fix firmware loading TLV error path
Date: Fri, 23 Jul 2010 09:15:35 -0700
Message-Id: <1279901739-10541-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

gcc complains about the firmware loading:

iwl-agn.c: In function ‘iwlagn_load_firmware’:
iwl-agn.c:1860: warning: ‘tlv_len’ may be used uninitialized in this function
iwl-agn.c:1861: warning: ‘tlv_type’ may be used uninitialized in this function
iwl-agn.c:1862: warning: ‘tlv_data’ may be used uninitialized in this function

This is almost correct but we do do break out of the TLV
parsing loop when setting ret. However, the code is hard
to follow, and clearly even the compiler is having issues
with it too.

Additionally, however, the current code is wrong. If there
is a TLV length check error, the code will report
	invalid TLV after parsing: ...
because "len" will still be non-zero as we broke out of
the loop.

So to remove the warning and fix that issue, make the code
easier to read by doing length checking with an error label.
As a result, we can completely remove the "ret" variable.

Also, while at it, remove the "fixed_tlv_size" variable
since each TLV type has its own specified length, it just
happens that we have only variable length, flags (0 length)
and u32 TLVs right now. It should still be checked with more
explicit length checks to make it easier to understand.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   79 ++++++++++++++------------------
 1 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index db86f70..573a81b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1828,7 +1828,6 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 	u32 tlv_len;
 	enum iwl_ucode_tlv_type tlv_type;
 	const u8 *tlv_data;
-	int ret = 0;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(priv, "uCode has invalid length: %zd\n", len);
@@ -1864,9 +1863,8 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 
 	len -= sizeof(*ucode);
 
-	while (len >= sizeof(*tlv) && !ret) {
+	while (len >= sizeof(*tlv)) {
 		u16 tlv_alt;
-		u32 fixed_tlv_size = 4;
 
 		len -= sizeof(*tlv);
 		tlv = (void *)data;
@@ -1914,65 +1912,56 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			pieces->boot_size = tlv_len;
 			break;
 		case IWL_UCODE_TLV_PROBE_MAX_LEN:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				capa->max_probe_length =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			capa->max_probe_length =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				pieces->init_evtlog_ptr =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->init_evtlog_ptr =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_SIZE:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				pieces->init_evtlog_size =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->init_evtlog_size =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_INIT_ERRLOG_PTR:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				pieces->init_errlog_ptr =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->init_errlog_ptr =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_RUNT_EVTLOG_PTR:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				pieces->inst_evtlog_ptr =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->inst_evtlog_ptr =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_RUNT_EVTLOG_SIZE:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				pieces->inst_evtlog_size =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->inst_evtlog_size =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_RUNT_ERRLOG_PTR:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				pieces->inst_errlog_ptr =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			pieces->inst_errlog_ptr =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_ENHANCE_SENS_TBL:
 			if (tlv_len)
-				ret = -EINVAL;
-			else
-				priv->enhance_sensitivity_table = true;
+				goto invalid_tlv_len;
+			priv->enhance_sensitivity_table = true;
 			break;
 		case IWL_UCODE_TLV_PHY_CALIBRATION_SIZE:
-			if (tlv_len != fixed_tlv_size)
-				ret = -EINVAL;
-			else
-				capa->standard_phy_calibration_size =
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			capa->standard_phy_calibration_size =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
 		default:
@@ -1984,14 +1973,16 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 	if (len) {
 		IWL_ERR(priv, "invalid TLV after parsing: %zd\n", len);
 		iwl_print_hex_dump(priv, IWL_DL_FW, (u8 *)data, len);
-		ret = -EINVAL;
-	} else if (ret) {
-		IWL_ERR(priv, "TLV %d has invalid size: %u\n",
-			tlv_type, tlv_len);
-		iwl_print_hex_dump(priv, IWL_DL_FW, (u8 *)tlv_data, tlv_len);
+		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
+
+ invalid_tlv_len:
+	IWL_ERR(priv, "TLV %d has invalid size: %u\n", tlv_type, tlv_len);
+	iwl_print_hex_dump(priv, IWL_DL_FW, tlv_data, tlv_len);
+
+	return -EINVAL;
 }
 
 /**
-- 
1.7.0.4

