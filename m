Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627Ab0EJW21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 19/47] iwlwifi: remove ucode virtual functions
Date: Mon, 10 May 2010 15:27:50 -0700
Message-Id: <1273530498-11876-20-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

AGN devices all use the same ucode operations,
except for 4965, because 4965 uses only v1 file
headers.

Therefore, we can remove all the indirection
we have here and just code the API distinction
in place, with a small special case for 4965.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   39 ----------------
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    2 -
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   49 ---------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   61 +++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h      |   12 -----
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |    2 +-
 10 files changed, 47 insertions(+), 123 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index ebaf02d..a2f7cbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -225,7 +225,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 };
 
 static const struct iwl_ops iwl1000_ops = {
-	.ucode = &iwlagn_ucode,
 	.lib = &iwl1000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 5904a1b..a3562a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2112,34 +2112,6 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->txpower_work);
 }
 
-#define IWL4965_UCODE_GET(item)						\
-static u32 iwl4965_ucode_get_##item(const struct iwl_ucode_header *ucode,\
-				    u32 api_ver)			\
-{									\
-	return le32_to_cpu(ucode->u.v1.item);				\
-}
-
-static u32 iwl4965_ucode_get_header_size(u32 api_ver)
-{
-	return UCODE_HEADER_SIZE(1);
-}
-static u32 iwl4965_ucode_get_build(const struct iwl_ucode_header *ucode,
-				   u32 api_ver)
-{
-	return 0;
-}
-static u8 *iwl4965_ucode_get_data(const struct iwl_ucode_header *ucode,
-				  u32 api_ver)
-{
-	return (u8 *) ucode->u.v1.data;
-}
-
-IWL4965_UCODE_GET(inst_size);
-IWL4965_UCODE_GET(data_size);
-IWL4965_UCODE_GET(init_size);
-IWL4965_UCODE_GET(init_data_size);
-IWL4965_UCODE_GET(boot_size);
-
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
@@ -2147,16 +2119,6 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.send_bt_config = iwl_send_bt_config,
 };
 
-static struct iwl_ucode_ops iwl4965_ucode = {
-	.get_header_size = iwl4965_ucode_get_header_size,
-	.get_build = iwl4965_ucode_get_build,
-	.get_inst_size = iwl4965_ucode_get_inst_size,
-	.get_data_size = iwl4965_ucode_get_data_size,
-	.get_init_size = iwl4965_ucode_get_init_size,
-	.get_init_data_size = iwl4965_ucode_get_init_data_size,
-	.get_boot_size = iwl4965_ucode_get_boot_size,
-	.get_data = iwl4965_ucode_get_data,
-};
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.get_hcmd_size = iwl4965_get_hcmd_size,
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
@@ -2229,7 +2191,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 };
 
 static const struct iwl_ops iwl4965_ops = {
-	.ucode = &iwl4965_ucode,
 	.lib = &iwl4965_lib,
 	.hcmd = &iwl4965_hcmd,
 	.utils = &iwl4965_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index bde0f18..efda0e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -427,7 +427,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 };
 
 static const struct iwl_ops iwl5000_ops = {
-	.ucode = &iwlagn_ucode,
 	.lib = &iwl5000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
@@ -435,7 +434,6 @@ static const struct iwl_ops iwl5000_ops = {
 };
 
 static const struct iwl_ops iwl5150_ops = {
-	.ucode = &iwlagn_ucode,
 	.lib = &iwl5150_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5f0f586..03c7324 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -330,7 +330,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 };
 
 static const struct iwl_ops iwl6000_ops = {
-	.ucode = &iwlagn_ucode,
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
@@ -404,7 +403,6 @@ static struct iwl_lib_ops iwl6050_lib = {
 };
 
 static const struct iwl_ops iwl6050_ops = {
-	.ucode = &iwlagn_ucode,
 	.lib = &iwl6050_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index c3e3283..637286c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -182,55 +182,6 @@ int iwlagn_load_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
-#define IWL_UCODE_GET(item)						\
-static u32 iwlagn_ucode_get_##item(const struct iwl_ucode_header *ucode,\
-				    u32 api_ver)			\
-{									\
-	if (api_ver <= 2)						\
-		return le32_to_cpu(ucode->u.v1.item);			\
-	return le32_to_cpu(ucode->u.v2.item);				\
-}
-
-static u32 iwlagn_ucode_get_header_size(u32 api_ver)
-{
-	if (api_ver <= 2)
-		return UCODE_HEADER_SIZE(1);
-	return UCODE_HEADER_SIZE(2);
-}
-
-static u32 iwlagn_ucode_get_build(const struct iwl_ucode_header *ucode,
-				   u32 api_ver)
-{
-	if (api_ver <= 2)
-		return 0;
-	return le32_to_cpu(ucode->u.v2.build);
-}
-
-static u8 *iwlagn_ucode_get_data(const struct iwl_ucode_header *ucode,
-				  u32 api_ver)
-{
-	if (api_ver <= 2)
-		return (u8 *) ucode->u.v1.data;
-	return (u8 *) ucode->u.v2.data;
-}
-
-IWL_UCODE_GET(inst_size);
-IWL_UCODE_GET(data_size);
-IWL_UCODE_GET(init_size);
-IWL_UCODE_GET(init_data_size);
-IWL_UCODE_GET(boot_size);
-
-struct iwl_ucode_ops iwlagn_ucode = {
-	.get_header_size = iwlagn_ucode_get_header_size,
-	.get_build = iwlagn_ucode_get_build,
-	.get_inst_size = iwlagn_ucode_get_inst_size,
-	.get_data_size = iwlagn_ucode_get_data_size,
-	.get_init_size = iwlagn_ucode_get_init_size,
-	.get_init_data_size = iwlagn_ucode_get_init_data_size,
-	.get_boot_size = iwlagn_ucode_get_boot_size,
-	.get_data = iwlagn_ucode_get_data,
-};
-
 /*
  *  Calibration
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f9c9c08..7bcc8a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1550,7 +1550,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	size_t len;
 	u32 api_ver, build;
 	u32 inst_size, data_size, init_size, init_data_size, boot_size;
-	int err;
+	int err, hdr_size;
 	u16 eeprom_ver;
 	char buildstr[25];
 
@@ -1563,8 +1563,8 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	IWL_DEBUG_INFO(priv, "Loaded firmware file '%s' (%zd bytes).\n",
 		       priv->firmware_name, ucode_raw->size);
 
-	/* Make sure that we got at least the v1 header! */
-	if (ucode_raw->size < priv->cfg->ops->ucode->get_header_size(1)) {
+	/* Make sure that we got at least the API version number */
+	if (ucode_raw->size < 4) {
 		IWL_ERR(priv, "File size way too small!\n");
 		goto try_again;
 	}
@@ -1574,14 +1574,47 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	priv->ucode_ver = le32_to_cpu(ucode->ver);
 	api_ver = IWL_UCODE_API(priv->ucode_ver);
-	build = priv->cfg->ops->ucode->get_build(ucode, api_ver);
-	inst_size = priv->cfg->ops->ucode->get_inst_size(ucode, api_ver);
-	data_size = priv->cfg->ops->ucode->get_data_size(ucode, api_ver);
-	init_size = priv->cfg->ops->ucode->get_init_size(ucode, api_ver);
-	init_data_size =
-		priv->cfg->ops->ucode->get_init_data_size(ucode, api_ver);
-	boot_size = priv->cfg->ops->ucode->get_boot_size(ucode, api_ver);
-	src = priv->cfg->ops->ucode->get_data(ucode, api_ver);
+
+	switch (api_ver) {
+	default:
+		/*
+		 * 4965 doesn't revision the firmware file format
+		 * along with the API version, it always uses v1
+		 * file format.
+		 */
+		if (priv->cfg != &iwl4965_agn_cfg) {
+			hdr_size = 28;
+			if (ucode_raw->size < hdr_size) {
+				IWL_ERR(priv, "File size too small!\n");
+				goto try_again;
+			}
+			build = ucode->u.v2.build;
+			inst_size = ucode->u.v2.inst_size;
+			data_size = ucode->u.v2.data_size;
+			init_size = ucode->u.v2.init_size;
+			init_data_size = ucode->u.v2.init_data_size;
+			boot_size = ucode->u.v2.boot_size;
+			src = ucode->u.v2.data;
+			break;
+		}
+		/* fall through for 4965 */
+	case 0:
+	case 1:
+	case 2:
+		hdr_size = 24;
+		if (ucode_raw->size < hdr_size) {
+			IWL_ERR(priv, "File size too small!\n");
+			goto try_again;
+		}
+		build = 0;
+		inst_size = ucode->u.v1.inst_size;
+		data_size = ucode->u.v1.data_size;
+		init_size = ucode->u.v1.init_size;
+		init_data_size = ucode->u.v1.init_data_size;
+		boot_size = ucode->u.v1.boot_size;
+		src = ucode->u.v1.data;
+		break;
+	}
 
 	/* api_ver should match the api version forming part of the
 	 * firmware filename ... but we don't check for that and only rely
@@ -1646,10 +1679,8 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 */
 
 	/* Verify size of file vs. image size info in file's header */
-	if (ucode_raw->size !=
-		priv->cfg->ops->ucode->get_header_size(api_ver) +
-		inst_size + data_size + init_size +
-		init_data_size + boot_size) {
+	if (ucode_raw->size != hdr_size + inst_size + data_size + init_size +
+				init_data_size + boot_size) {
 
 		IWL_DEBUG_INFO(priv,
 			"uCode file size %d does not match expected size\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a9ba9fc..4a1e7b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -66,7 +66,6 @@
 #include "iwl-dev.h"
 
 extern struct iwl_mod_params iwlagn_mod_params;
-extern struct iwl_ucode_ops iwlagn_ucode;
 extern struct iwl_hcmd_ops iwlagn_hcmd;
 extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0fa9965..2f664a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -131,17 +131,6 @@ struct iwl_temp_ops {
 	void (*set_calib_version)(struct iwl_priv *priv);
 };
 
-struct iwl_ucode_ops {
-	u32 (*get_header_size)(u32);
-	u32 (*get_build)(const struct iwl_ucode_header *, u32);
-	u32 (*get_inst_size)(const struct iwl_ucode_header *, u32);
-	u32 (*get_data_size)(const struct iwl_ucode_header *, u32);
-	u32 (*get_init_size)(const struct iwl_ucode_header *, u32);
-	u32 (*get_init_data_size)(const struct iwl_ucode_header *, u32);
-	u32 (*get_boot_size)(const struct iwl_ucode_header *, u32);
-	u8 * (*get_data)(const struct iwl_ucode_header *, u32);
-};
-
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
@@ -222,7 +211,6 @@ struct iwl_led_ops {
 };
 
 struct iwl_ops {
-	const struct iwl_ucode_ops *ucode;
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e485465..fe938d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -541,7 +541,6 @@ struct iwl_ucode_header {
 		} v2;
 	} u;
 };
-#define UCODE_HEADER_SIZE(ver) ((ver) == 1 ? 24 : 28)
 
 struct iwl4965_ibss_seq {
 	u8 mac[ETH_ALEN];
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e9de109..59c85f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2117,7 +2117,7 @@ static u32 iwl3945_ucode_get_##item(const struct iwl_ucode_header *ucode)\
 
 static u32 iwl3945_ucode_get_header_size(u32 api_ver)
 {
-	return UCODE_HEADER_SIZE(1);
+	return 24;
 }
 
 static u8 *iwl3945_ucode_get_data(const struct iwl_ucode_header *ucode)
-- 
1.6.3.3

