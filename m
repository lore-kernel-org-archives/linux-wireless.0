Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab2DPWB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/16] iwlwifi: remove uCode alternatives mechanism
Date: Mon, 16 Apr 2012 14:56:56 -0700
Message-Id: <1334613430-30720-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000138_422548_57642F71)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We've never released firmware using the alternatives
mechanism and our build process makes that difficult
anyway. This means that in every file we have ever
built (except maybe by hand for testing) the listed
alternative was 0. Make the alternative field in the
TLVs part of the TLV number (thus expanding that to
32 bits); this gives us more TLV numbers (not really
needed) and more importantly protects against rogue
firmware files that actually do use the alternatives
mechanism -- those will now be rejected since they
don't contain any valid TLVs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 -----
 drivers/net/wireless/iwlwifi/iwl-drv.c     |   33 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |   15 ++----------
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    2 -
 5 files changed, 4 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8834b1b..8e83fb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -101,7 +101,6 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.bt_coex_active = true,
 	.power_level = IWL_POWER_INDEX_1,
 	.bt_ch_announce = true,
-	.wanted_ucode_alternative = 1,
 	.auto_agg = true,
 	/* the rest are 0 by default */
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6cea8a7..427f63c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2409,12 +2409,6 @@ MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
 module_param_named(fw_restart, iwlagn_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
 
-module_param_named(ucode_alternative,
-		   iwlagn_mod_params.wanted_ucode_alternative,
-		   int, S_IRUGO);
-MODULE_PARM_DESC(ucode_alternative,
-		 "specify ucode alternative to use from ucode file");
-
 module_param_named(antenna_coupling, iwlagn_mod_params.ant_coupling,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(antenna_coupling,
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 6f312c7..fa12f73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -414,9 +414,6 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	struct iwl_ucode_tlv *tlv;
 	size_t len = ucode_raw->size;
 	const u8 *data;
-	int wanted_alternative = iwlagn_mod_params.wanted_ucode_alternative;
-	int tmp;
-	u64 alternatives;
 	u32 tlv_len;
 	enum iwl_ucode_tlv_type tlv_type;
 	const u8 *tlv_data;
@@ -434,23 +431,6 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		return -EINVAL;
 	}
 
-	/*
-	 * Check which alternatives are present, and "downgrade"
-	 * when the chosen alternative is not present, warning
-	 * the user when that happens. Some files may not have
-	 * any alternatives, so don't warn in that case.
-	 */
-	alternatives = le64_to_cpu(ucode->alternatives);
-	tmp = wanted_alternative;
-	if (wanted_alternative > 63)
-		wanted_alternative = 63;
-	while (wanted_alternative && !(alternatives & BIT(wanted_alternative)))
-		wanted_alternative--;
-	if (wanted_alternative && wanted_alternative != tmp)
-		IWL_WARN(drv,
-			 "uCode alternative %d not available, choosing %d\n",
-			 tmp, wanted_alternative);
-
 	drv->fw.ucode_ver = le32_to_cpu(ucode->ver);
 	build = le32_to_cpu(ucode->build);
 
@@ -475,14 +455,11 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	len -= sizeof(*ucode);
 
 	while (len >= sizeof(*tlv)) {
-		u16 tlv_alt;
-
 		len -= sizeof(*tlv);
 		tlv = (void *)data;
 
 		tlv_len = le32_to_cpu(tlv->length);
-		tlv_type = le16_to_cpu(tlv->type);
-		tlv_alt = le16_to_cpu(tlv->alternative);
+		tlv_type = le32_to_cpu(tlv->type);
 		tlv_data = tlv->data;
 
 		if (len < tlv_len) {
@@ -493,14 +470,6 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		len -= ALIGN(tlv_len, 4);
 		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
 
-		/*
-		 * Alternative 0 is always valid.
-		 *
-		 * Skip alternative TLVs that are not selected.
-		 */
-		if (tlv_alt != 0 && tlv_alt != wanted_alternative)
-			continue;
-
 		switch (tlv_type) {
 		case IWL_UCODE_TLV_INST:
 			set_sec_data(pieces, IWL_UCODE_REGULAR,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index c924ccb..e715640 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -93,15 +93,7 @@ struct iwl_ucode_header {
  * new TLV uCode file layout
  *
  * The new TLV file format contains TLVs, that each specify
- * some piece of data. To facilitate "groups", for example
- * different instruction image with different capabilities,
- * bundled with the same init image, an alternative mechanism
- * is provided:
- * When the alternative field is 0, that means that the item
- * is always valid. When it is non-zero, then it is only
- * valid in conjunction with items of the same alternative,
- * in which case the driver (user) selects one alternative
- * to use.
+ * some piece of data.
  */
 
 enum iwl_ucode_tlv_type {
@@ -132,8 +124,7 @@ enum iwl_ucode_tlv_type {
 };
 
 struct iwl_ucode_tlv {
-	__le16 type;		/* see above */
-	__le16 alternative;	/* see comment */
+	__le32 type;		/* see above */
 	__le32 length;		/* not including type/length fields */
 	u8 data[0];
 };
@@ -152,7 +143,7 @@ struct iwl_tlv_ucode_header {
 	u8 human_readable[64];
 	__le32 ver;		/* major/minor/API/serial */
 	__le32 build;
-	__le64 alternatives;	/* bitmask of valid alternatives */
+	__le64 ignore;
 	/*
 	 * The data contained herein has a TLV layout,
 	 * see above for the TLV header and types.
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 00543d9..8c962c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -129,7 +129,6 @@ extern struct iwl_mod_params iwlagn_mod_params;
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
  * @bt_ch_announce: BT channel inhibition, default = enable
- * @wanted_ucode_alternative: ucode alternative to use, default = 1
  * @auto_agg: enable agg. without check, default = true
  */
 struct iwl_mod_params {
@@ -147,7 +146,6 @@ struct iwl_mod_params {
 	u32 debug_level;
 	int ant_coupling;
 	bool bt_ch_announce;
-	int wanted_ucode_alternative;
 	bool auto_agg;
 };
 
-- 
1.7.0.4

