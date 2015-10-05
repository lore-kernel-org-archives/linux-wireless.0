Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57197 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502AbbJEPBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:59 +0300
Message-Id: <1444055820-27506-28-git-send-email-luca@coelho.fi> (sfid-20151005_170149_042957_ECC53708)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 28/29] iwlwifi: size firmware flags memory correctly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of relying on a hard-coded constant of a maximum of 64 API and
capability bits, add a new enum value after the others that will then
always track the number of used bits in the API/capabilities. We thus
no longer need to maintain the maximum number, and on 32-bit platforms
even (currently) reduce the number of bits kept in memory.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 19 ++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-fw.h      |  4 ++--
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index a86aa5b..463cadf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -450,7 +450,7 @@ static int iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
 	u32 api_flags = le32_to_cpu(ucode_api->api_flags);
 	int i;
 
-	if (api_index >= IWL_API_MAX_BITS / 32) {
+	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_API, 32)) {
 		IWL_ERR(drv, "api_index larger than supported by driver\n");
 		/* don't return an error so we can load FW that has more bits */
 		return 0;
@@ -472,7 +472,7 @@ static int iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
 	u32 api_flags = le32_to_cpu(ucode_capa->api_capa);
 	int i;
 
-	if (api_index >= IWL_CAPABILITIES_MAX_BITS / 32) {
+	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_CAPA, 32)) {
 		IWL_ERR(drv, "api_index larger than supported by driver\n");
 		/* don't return an error so we can load FW that has more bits */
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 352d245..72ddd4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -254,6 +254,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  *	instead of 3.
  * @IWL_UCODE_TLV_API_TX_POWER_CHAIN: TX power API has larger command size
  *	(command version 3) that supports per-chain limits
+ *
+ * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = (__force iwl_ucode_tlv_api_t)3,
@@ -264,6 +266,12 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= (__force iwl_ucode_tlv_api_t)24,
 	IWL_UCODE_TLV_API_TX_POWER_CHAIN	= (__force iwl_ucode_tlv_api_t)27,
+
+	NUM_IWL_UCODE_TLV_API
+#ifdef __CHECKER__
+		/* sparse says it cannot increment the previous enum member */
+		= 128
+#endif
 };
 
 typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
@@ -298,6 +306,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  *	is supported.
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  * @IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT: supports gscan
+ *
+ * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= (__force iwl_ucode_tlv_capa_t)0,
@@ -320,6 +330,12 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
+
+	NUM_IWL_UCODE_TLV_CAPA
+#ifdef __CHECKER__
+		/* sparse says it cannot increment the previous enum member */
+		= 128
+#endif
 };
 
 /* The default calibrate table size if not specified by firmware file */
@@ -330,9 +346,6 @@ enum iwl_ucode_tlv_capa {
 /* The default max probe length if not specified by the firmware file */
 #define IWL_DEFAULT_MAX_PROBE_LENGTH	200
 
-#define IWL_API_MAX_BITS		64
-#define IWL_CAPABILITIES_MAX_BITS	64
-
 /*
  * For 16.0 uCode and above, there is no differentiation between sections,
  * just an offset to the HW address.
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 45e7321..84ec0ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -105,8 +105,8 @@ struct iwl_ucode_capabilities {
 	u32 n_scan_channels;
 	u32 standard_phy_calibration_size;
 	u32 flags;
-	unsigned long _api[BITS_TO_LONGS(IWL_API_MAX_BITS)];
-	unsigned long _capa[BITS_TO_LONGS(IWL_CAPABILITIES_MAX_BITS)];
+	unsigned long _api[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_API)];
+	unsigned long _capa[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_CAPA)];
 };
 
 static inline bool
-- 
2.5.3

