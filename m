Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab0EMVuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:21 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/17] iwlwifi: move ucode related function to iwl-agn-ucode.c
Date: Thu, 13 May 2010 14:49:58 -0700
Message-Id: <1273787399-9280-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Cleanup the code and move all the uCode related functions specific to _agn
devices to iwl-agn-ucode.c

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |  123 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c      |  124 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h      |    1 -
 4 files changed, 124 insertions(+), 125 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 637286c..6f77441 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -423,3 +423,126 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	return 0;
 }
+
+
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
+	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
+
+	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
+		/* read data comes through single port, auto-incr addr */
+		/* NOTE: Use the debugless read so we don't flood kernel log
+		 * if IWL_DL_IO is set */
+		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+			i + IWLAGN_RTC_INST_LOWER_BOUND);
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		if (val != le32_to_cpu(*image)) {
+			ret = -EIO;
+			errcnt++;
+			if (errcnt >= 3)
+				break;
+		}
+	}
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
+	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
+
+	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+			   IWLAGN_RTC_INST_LOWER_BOUND);
+
+	errcnt = 0;
+	for (; len > 0; len -= sizeof(u32), image++) {
+		/* read data comes through single port, auto-incr addr */
+		/* NOTE: Use the debugless read so we don't flood kernel log
+		 * if IWL_DL_IO is set */
+		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		if (val != le32_to_cpu(*image)) {
+			IWL_ERR(priv, "uCode INST section is invalid at "
+				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
+				  save_len - len, val, le32_to_cpu(*image));
+			ret = -EIO;
+			errcnt++;
+			if (errcnt >= 20)
+				break;
+		}
+	}
+
+	if (!errcnt)
+		IWL_DEBUG_INFO(priv,
+		    "ucode image in INSTRUCTION memory is good\n");
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
+		IWL_DEBUG_INFO(priv, "Bootstrap uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	/* Try initialize */
+	image = (__le32 *)priv->ucode_init.v_addr;
+	len = priv->ucode_init.len;
+	ret = iwlcore_verify_inst_sparse(priv, image, len);
+	if (!ret) {
+		IWL_DEBUG_INFO(priv, "Initialize uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	/* Try runtime/protocol */
+	image = (__le32 *)priv->ucode_code.v_addr;
+	len = priv->ucode_code.len;
+	ret = iwlcore_verify_inst_sparse(priv, image, len);
+	if (!ret) {
+		IWL_DEBUG_INFO(priv, "Runtime uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	IWL_ERR(priv, "NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2ebbe81..f7ef893 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -130,6 +130,7 @@ void iwlagn_rx_calib_complete(struct iwl_priv *priv,
 			   struct iwl_rx_mem_buffer *rxb);
 void iwlagn_init_alive_start(struct iwl_priv *priv);
 int iwlagn_alive_notify(struct iwl_priv *priv);
+int iwl_verify_ucode(struct iwl_priv *priv);
 
 /* lib */
 void iwl_check_abort_status(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 10ce008..4a50c04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1460,130 +1460,6 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 }
 EXPORT_SYMBOL(iwl_send_statistics_request);
 
-/**
- * iwl_verify_inst_sparse - verify runtime uCode image in card vs. host,
- *   using sample data 100 bytes apart.  If these sample points are good,
- *   it's a pretty good bet that everything between them is good, too.
- */
-static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
-{
-	u32 val;
-	int ret = 0;
-	u32 errcnt = 0;
-	u32 i;
-
-	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
-
-	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
-		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IWL_DL_IO is set */
-		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
-			i + IWL49_RTC_INST_LOWER_BOUND);
-		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-			ret = -EIO;
-			errcnt++;
-			if (errcnt >= 3)
-				break;
-		}
-	}
-
-	return ret;
-}
-
-/**
- * iwlcore_verify_inst_full - verify runtime uCode image in card vs. host,
- *     looking at all data.
- */
-static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
-				 u32 len)
-{
-	u32 val;
-	u32 save_len = len;
-	int ret = 0;
-	u32 errcnt;
-
-	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
-
-	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
-			   IWL49_RTC_INST_LOWER_BOUND);
-
-	errcnt = 0;
-	for (; len > 0; len -= sizeof(u32), image++) {
-		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IWL_DL_IO is set */
-		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(priv, "uCode INST section is invalid at "
-				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
-				  save_len - len, val, le32_to_cpu(*image));
-			ret = -EIO;
-			errcnt++;
-			if (errcnt >= 20)
-				break;
-		}
-	}
-
-	if (!errcnt)
-		IWL_DEBUG_INFO(priv,
-		    "ucode image in INSTRUCTION memory is good\n");
-
-	return ret;
-}
-
-/**
- * iwl_verify_ucode - determine which instruction image is in SRAM,
- *    and verify its contents
- */
-int iwl_verify_ucode(struct iwl_priv *priv)
-{
-	__le32 *image;
-	u32 len;
-	int ret;
-
-	/* Try bootstrap */
-	image = (__le32 *)priv->ucode_boot.v_addr;
-	len = priv->ucode_boot.len;
-	ret = iwlcore_verify_inst_sparse(priv, image, len);
-	if (!ret) {
-		IWL_DEBUG_INFO(priv, "Bootstrap uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	/* Try initialize */
-	image = (__le32 *)priv->ucode_init.v_addr;
-	len = priv->ucode_init.len;
-	ret = iwlcore_verify_inst_sparse(priv, image, len);
-	if (!ret) {
-		IWL_DEBUG_INFO(priv, "Initialize uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	/* Try runtime/protocol */
-	image = (__le32 *)priv->ucode_code.v_addr;
-	len = priv->ucode_code.len;
-	ret = iwlcore_verify_inst_sparse(priv, image, len);
-	if (!ret) {
-		IWL_DEBUG_INFO(priv, "Runtime uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	IWL_ERR(priv, "NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
-
-	/* Since nothing seems to match, show first several data entries in
-	 * instruction SRAM, so maybe visual inspection will give a clue.
-	 * Selection of bootstrap image (vs. other images) is arbitrary. */
-	image = (__le32 *)priv->ucode_boot.v_addr;
-	len = priv->ucode_boot.len;
-	ret = iwl_verify_inst_full(priv, image, len);
-
-	return ret;
-}
-EXPORT_SYMBOL(iwl_verify_ucode);
-
-
 void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 63229dc..d3b61dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -689,7 +689,6 @@ extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
 extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
-extern int iwl_verify_ucode(struct iwl_priv *priv);
 extern int iwl_send_lq_cmd(struct iwl_priv *priv,
 		struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 void iwl_apm_stop(struct iwl_priv *priv);
-- 
1.6.3.3

