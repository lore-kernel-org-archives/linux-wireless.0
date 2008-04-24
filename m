Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6913 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbYDXSzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 01/21] iwlwifi: move verify_ucode functions to iwl-core
Date: Thu, 24 Apr 2008 11:55:18 -0700
Message-Id: <1209063338-6572-2-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205618_177688_83864080)
In-Reply-To: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves verify_ucode functions to iwl-core.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |  134 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  144 +--------------------------
 3 files changed, 137 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ca32fb3..8c8b51d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -704,3 +704,137 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
 }
 EXPORT_SYMBOL(iwl_send_statistics_request);
 
+/**
+ * iwl_verify_inst_sparse - verify runtime uCode image in card vs. host,
+ *   using sample data 100 bytes apart.  If these sample points are good,
+ *   it's a pretty good bet that everything between them is good, too.
+ */
+static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
+{
+	u32 val;
+	int ret = 0;
+	u32 errcnt = 0;
+	u32 i;
+
+	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
+
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
+		/* read data comes through single port, auto-incr addr */
+		/* NOTE: Use the debugless read so we don't flood kernel log
+		 * if IWL_DL_IO is set */
+		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+			i + RTC_INST_LOWER_BOUND);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		if (val != le32_to_cpu(*image)) {
+			ret = -EIO;
+			errcnt++;
+			if (errcnt >= 3)
+				break;
+		}
+	}
+
+	iwl_release_nic_access(priv);
+
+	return ret;
+}
+
+/**
+ * iwlcore_verify_inst_full - verify runtime uCode image in card vs. host,
+ *     looking at all data.
+ */
+static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
+				 u32 len)
+{
+	u32 val;
+	u32 save_len = len;
+	int ret = 0;
+	u32 errcnt;
+
+	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
+
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		return ret;
+
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
+
+	errcnt = 0;
+	for (; len > 0; len -= sizeof(u32), image++) {
+		/* read data comes through single port, auto-incr addr */
+		/* NOTE: Use the debugless read so we don't flood kernel log
+		 * if IWL_DL_IO is set */
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		if (val != le32_to_cpu(*image)) {
+			IWL_ERROR("uCode INST section is invalid at "
+				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
+				  save_len - len, val, le32_to_cpu(*image));
+			ret = -EIO;
+			errcnt++;
+			if (errcnt >= 20)
+				break;
+		}
+	}
+
+	iwl_release_nic_access(priv);
+
+	if (!errcnt)
+		IWL_DEBUG_INFO
+		    ("ucode image in INSTRUCTION memory is good\n");
+
+	return ret;
+}
+
+/**
+ * iwl_verify_ucode - determine which instruction image is in SRAM,
+ *    and verify its contents
+ */
+int iwl_verify_ucode(struct iwl_priv *priv)
+{
+	__le32 *image;
+	u32 len;
+	int ret;
+
+	/* Try bootstrap */
+	image = (__le32 *)priv->ucode_boot.v_addr;
+	len = priv->ucode_boot.len;
+	ret = iwlcore_verify_inst_sparse(priv, image, len);
+	if (!ret) {
+		IWL_DEBUG_INFO("Bootstrap uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	/* Try initialize */
+	image = (__le32 *)priv->ucode_init.v_addr;
+	len = priv->ucode_init.len;
+	ret = iwlcore_verify_inst_sparse(priv, image, len);
+	if (!ret) {
+		IWL_DEBUG_INFO("Initialize uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	/* Try runtime/protocol */
+	image = (__le32 *)priv->ucode_code.v_addr;
+	len = priv->ucode_code.len;
+	ret = iwlcore_verify_inst_sparse(priv, image, len);
+	if (!ret) {
+		IWL_DEBUG_INFO("Runtime uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	IWL_ERROR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
+
+	/* Since nothing seems to match, show first several data entries in
+	 * instruction SRAM, so maybe visual inspection will give a clue.
+	 * Selection of bootstrap image (vs. other images) is arbitrary. */
+	image = (__le32 *)priv->ucode_boot.v_addr;
+	len = priv->ucode_boot.len;
+	ret = iwl_verify_inst_full(priv, image, len);
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_verify_ucode);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e18940d..8196ef7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -253,6 +253,7 @@ enum iwlcore_card_notify {
 int iwlcore_low_level_notify(struct iwl_priv *priv,
 			     enum iwlcore_card_notify notify);
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
+extern int iwl_verify_ucode(struct iwl_priv *priv);
 int iwl_send_lq_cmd(struct iwl_priv *priv,
 		    struct iwl_link_quality_cmd *lq, u8 flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9e46517..d2726dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4512,146 +4512,6 @@ static void iwl4965_dealloc_ucode_pci(struct iwl_priv *priv)
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_boot);
 }
 
-/**
- * iwl4965_verify_inst_full - verify runtime uCode image in card vs. host,
- *     looking at all data.
- */
-static int iwl4965_verify_inst_full(struct iwl_priv *priv, __le32 *image,
-				 u32 len)
-{
-	u32 val;
-	u32 save_len = len;
-	int rc = 0;
-	u32 errcnt;
-
-	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
-
-	rc = iwl_grab_nic_access(priv);
-	if (rc)
-		return rc;
-
-	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
-
-	errcnt = 0;
-	for (; len > 0; len -= sizeof(u32), image++) {
-		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IWL_DL_IO is set */
-		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-			IWL_ERROR("uCode INST section is invalid at "
-				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
-				  save_len - len, val, le32_to_cpu(*image));
-			rc = -EIO;
-			errcnt++;
-			if (errcnt >= 20)
-				break;
-		}
-	}
-
-	iwl_release_nic_access(priv);
-
-	if (!errcnt)
-		IWL_DEBUG_INFO
-		    ("ucode image in INSTRUCTION memory is good\n");
-
-	return rc;
-}
-
-
-/**
- * iwl4965_verify_inst_sparse - verify runtime uCode image in card vs. host,
- *   using sample data 100 bytes apart.  If these sample points are good,
- *   it's a pretty good bet that everything between them is good, too.
- */
-static int iwl4965_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
-{
-	u32 val;
-	int rc = 0;
-	u32 errcnt = 0;
-	u32 i;
-
-	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
-
-	rc = iwl_grab_nic_access(priv);
-	if (rc)
-		return rc;
-
-	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
-		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IWL_DL_IO is set */
-		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
-			i + RTC_INST_LOWER_BOUND);
-		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-#if 0 /* Enable this if you want to see details */
-			IWL_ERROR("uCode INST section is invalid at "
-				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
-				  i, val, *image);
-#endif
-			rc = -EIO;
-			errcnt++;
-			if (errcnt >= 3)
-				break;
-		}
-	}
-
-	iwl_release_nic_access(priv);
-
-	return rc;
-}
-
-
-/**
- * iwl4965_verify_ucode - determine which instruction image is in SRAM,
- *    and verify its contents
- */
-static int iwl4965_verify_ucode(struct iwl_priv *priv)
-{
-	__le32 *image;
-	u32 len;
-	int rc = 0;
-
-	/* Try bootstrap */
-	image = (__le32 *)priv->ucode_boot.v_addr;
-	len = priv->ucode_boot.len;
-	rc = iwl4965_verify_inst_sparse(priv, image, len);
-	if (rc == 0) {
-		IWL_DEBUG_INFO("Bootstrap uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	/* Try initialize */
-	image = (__le32 *)priv->ucode_init.v_addr;
-	len = priv->ucode_init.len;
-	rc = iwl4965_verify_inst_sparse(priv, image, len);
-	if (rc == 0) {
-		IWL_DEBUG_INFO("Initialize uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	/* Try runtime/protocol */
-	image = (__le32 *)priv->ucode_code.v_addr;
-	len = priv->ucode_code.len;
-	rc = iwl4965_verify_inst_sparse(priv, image, len);
-	if (rc == 0) {
-		IWL_DEBUG_INFO("Runtime uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	IWL_ERROR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
-
-	/* Since nothing seems to match, show first several data entries in
-	 * instruction SRAM, so maybe visual inspection will give a clue.
-	 * Selection of bootstrap image (vs. other images) is arbitrary. */
-	image = (__le32 *)priv->ucode_boot.v_addr;
-	len = priv->ucode_boot.len;
-	rc = iwl4965_verify_inst_full(priv, image, len);
-
-	return rc;
-}
-
 static void iwl4965_nic_start(struct iwl_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
@@ -4927,7 +4787,7 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
 	/* Bootstrap uCode has loaded initialize uCode ... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "initialize" alive if code weren't properly loaded.  */
-	if (iwl4965_verify_ucode(priv)) {
+	if (iwl_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
 		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
@@ -4975,7 +4835,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	/* Initialize uCode has loaded Runtime uCode ... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "runtime" alive if code weren't properly loaded.  */
-	if (iwl4965_verify_ucode(priv)) {
+	if (iwl_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
 		IWL_DEBUG_INFO("Bad runtime uCode load.\n");
-- 
1.5.3.4

