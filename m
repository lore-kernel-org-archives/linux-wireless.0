Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab0EJW22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/47] iwl3945: remove ucode access indirection
Date: Mon, 10 May 2010 15:27:49 -0700
Message-Id: <1273530498-11876-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As these function pointers will always point to
the 3945 functions, we can just call them directly
and avoid the indirection.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   40 ---------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   39 ++++++++++++++++++++------
 2 files changed, 30 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1e95939..a4d842a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2751,51 +2751,12 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 	return 0;
 }
 
-#define IWL3945_UCODE_GET(item)						\
-static u32 iwl3945_ucode_get_##item(const struct iwl_ucode_header *ucode,\
-				    u32 api_ver)			\
-{									\
-	return le32_to_cpu(ucode->u.v1.item);				\
-}
-
-static u32 iwl3945_ucode_get_header_size(u32 api_ver)
-{
-	return UCODE_HEADER_SIZE(1);
-}
-static u32 iwl3945_ucode_get_build(const struct iwl_ucode_header *ucode,
-				   u32 api_ver)
-{
-	return 0;
-}
-static u8 *iwl3945_ucode_get_data(const struct iwl_ucode_header *ucode,
-				  u32 api_ver)
-{
-	return (u8 *) ucode->u.v1.data;
-}
-
-IWL3945_UCODE_GET(inst_size);
-IWL3945_UCODE_GET(data_size);
-IWL3945_UCODE_GET(init_size);
-IWL3945_UCODE_GET(init_data_size);
-IWL3945_UCODE_GET(boot_size);
-
 static struct iwl_hcmd_ops iwl3945_hcmd = {
 	.rxon_assoc = iwl3945_send_rxon_assoc,
 	.commit_rxon = iwl3945_commit_rxon,
 	.send_bt_config = iwl_send_bt_config,
 };
 
-static struct iwl_ucode_ops iwl3945_ucode = {
-	.get_header_size = iwl3945_ucode_get_header_size,
-	.get_build = iwl3945_ucode_get_build,
-	.get_inst_size = iwl3945_ucode_get_inst_size,
-	.get_data_size = iwl3945_ucode_get_data_size,
-	.get_init_size = iwl3945_ucode_get_init_size,
-	.get_init_data_size = iwl3945_ucode_get_init_data_size,
-	.get_boot_size = iwl3945_ucode_get_boot_size,
-	.get_data = iwl3945_ucode_get_data,
-};
-
 static struct iwl_lib_ops iwl3945_lib = {
 	.txq_attach_buf_to_tfd = iwl3945_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl3945_hw_txq_free_tfd,
@@ -2847,7 +2808,6 @@ static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 };
 
 static const struct iwl_ops iwl3945_ops = {
-	.ucode = &iwl3945_ucode,
 	.lib = &iwl3945_lib,
 	.hcmd = &iwl3945_hcmd,
 	.utils = &iwl3945_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9486b32..e9de109 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2109,6 +2109,28 @@ static void iwl3945_nic_start(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_RESET, 0);
 }
 
+#define IWL3945_UCODE_GET(item)						\
+static u32 iwl3945_ucode_get_##item(const struct iwl_ucode_header *ucode)\
+{									\
+	return le32_to_cpu(ucode->u.v1.item);				\
+}
+
+static u32 iwl3945_ucode_get_header_size(u32 api_ver)
+{
+	return UCODE_HEADER_SIZE(1);
+}
+
+static u8 *iwl3945_ucode_get_data(const struct iwl_ucode_header *ucode)
+{
+	return (u8 *) ucode->u.v1.data;
+}
+
+IWL3945_UCODE_GET(inst_size);
+IWL3945_UCODE_GET(data_size);
+IWL3945_UCODE_GET(init_size);
+IWL3945_UCODE_GET(init_data_size);
+IWL3945_UCODE_GET(boot_size);
+
 /**
  * iwl3945_read_ucode - Read uCode images from disk file.
  *
@@ -2157,7 +2179,7 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 		goto error;
 
 	/* Make sure that we got at least our header! */
-	if (ucode_raw->size <  priv->cfg->ops->ucode->get_header_size(1)) {
+	if (ucode_raw->size <  iwl3945_ucode_get_header_size(1)) {
 		IWL_ERR(priv, "File size way too small!\n");
 		ret = -EINVAL;
 		goto err_release;
@@ -2168,13 +2190,12 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 
 	priv->ucode_ver = le32_to_cpu(ucode->ver);
 	api_ver = IWL_UCODE_API(priv->ucode_ver);
-	inst_size = priv->cfg->ops->ucode->get_inst_size(ucode, api_ver);
-	data_size = priv->cfg->ops->ucode->get_data_size(ucode, api_ver);
-	init_size = priv->cfg->ops->ucode->get_init_size(ucode, api_ver);
-	init_data_size =
-		priv->cfg->ops->ucode->get_init_data_size(ucode, api_ver);
-	boot_size = priv->cfg->ops->ucode->get_boot_size(ucode, api_ver);
-	src = priv->cfg->ops->ucode->get_data(ucode, api_ver);
+	inst_size = iwl3945_ucode_get_inst_size(ucode);
+	data_size = iwl3945_ucode_get_data_size(ucode);
+	init_size = iwl3945_ucode_get_init_size(ucode);
+	init_data_size = iwl3945_ucode_get_init_data_size(ucode);
+	boot_size = iwl3945_ucode_get_boot_size(ucode);
+	src = iwl3945_ucode_get_data(ucode);
 
 	/* api_ver should match the api version forming part of the
 	 * firmware filename ... but we don't check for that and only rely
@@ -2223,7 +2244,7 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 
 
 	/* Verify size of file vs. image size info in file's header */
-	if (ucode_raw->size != priv->cfg->ops->ucode->get_header_size(api_ver) +
+	if (ucode_raw->size != iwl3945_ucode_get_header_size(api_ver) +
 		inst_size + data_size + init_size +
 		init_data_size + boot_size) {
 
-- 
1.6.3.3

