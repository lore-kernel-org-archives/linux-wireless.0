Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1DERBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/25] iwlagn: verify specific ucode
Date: Tue,  5 Apr 2011 09:41:56 -0700
Message-Id: <1302021732-21250-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we loaded a ucode, there's no point in
checking any one that is present, we know
which one is supposed to be present so also
verify that it is exactly the right one.

That also simplifies the code and makes it
faster since it doesn't have to check all.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   51 ++++++--------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    2 +-
 3 files changed, 14 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 2205b60..c7b9b83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -311,7 +311,7 @@ void iwlagn_init_alive_start(struct iwl_priv *priv)
 	/* initialize uCode was loaded... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "initialize" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv)) {
+	if (iwl_verify_ucode(priv, &priv->ucode_init)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
 		IWL_DEBUG_INFO(priv, "Bad \"initialize\" uCode load.\n");
@@ -539,8 +539,11 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
+static int iwlcore_verify_inst_sparse(struct iwl_priv *priv,
+				      struct fw_desc *fw_desc)
 {
+	__le32 *image = (__le32 *)fw_desc->v_addr;
+	u32 len = fw_desc->len;
 	u32 val;
 	u32 i;
 
@@ -561,8 +564,10 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 }
 
 static void iwl_print_mismatch_inst(struct iwl_priv *priv,
-				    __le32 *image, u32 len)
+				    struct fw_desc *fw_desc)
 {
+	__le32 *image = (__le32 *)fw_desc->v_addr;
+	u32 len = fw_desc->len;
 	u32 val;
 	u32 offs;
 	int errors = 0;
@@ -592,47 +597,15 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-int iwl_verify_ucode(struct iwl_priv *priv)
+int iwl_verify_ucode(struct iwl_priv *priv, struct fw_desc *fw_desc)
 {
-	__le32 *image;
-	u32 len;
-	int ret;
-
-	/* Try bootstrap */
-	image = (__le32 *)priv->ucode_boot.v_addr;
-	len = priv->ucode_boot.len;
-	ret = iwlcore_verify_inst_sparse(priv, image, len);
-	if (!ret) {
+	if (!iwlcore_verify_inst_sparse(priv, fw_desc)) {
 		IWL_DEBUG_INFO(priv, "Bootstrap uCode is good in inst SRAM\n");
 		return 0;
 	}
 
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
-	iwl_print_mismatch_inst(priv, image, len);
+	IWL_ERR(priv, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
+	iwl_print_mismatch_inst(priv, fw_desc);
 	return -EIO;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 18d6d66..8fd9a60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2239,7 +2239,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	/* Initialize uCode has loaded Runtime uCode ... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "runtime" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv)) {
+	if (iwl_verify_ucode(priv, &priv->ucode_code)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
 		IWL_DEBUG_INFO(priv, "Bad runtime uCode load.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 4a0a46e..d2953bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -152,7 +152,7 @@ void iwlagn_rx_calib_complete(struct iwl_priv *priv,
 			   struct iwl_rx_mem_buffer *rxb);
 void iwlagn_init_alive_start(struct iwl_priv *priv);
 int iwlagn_alive_notify(struct iwl_priv *priv);
-int iwl_verify_ucode(struct iwl_priv *priv);
+int iwl_verify_ucode(struct iwl_priv *priv, struct fw_desc *fw_desc);
 void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwlagn_send_prio_tbl(struct iwl_priv *priv);
 
-- 
1.7.0.4

