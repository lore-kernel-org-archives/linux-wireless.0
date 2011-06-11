Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591Ab1FKOzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/18] iwlagn: use IWL_DEBUG_FW for firmware related debug msg
Date: Sat, 11 Jun 2011 07:25:46 -0700
Message-Id: <1307802352-16398-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165612_507367_7634A9C3)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead use generic IWL_DEBUG_INFO, use IWL_DEBUG_FW for uCode related stuffs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index a5cb1f6..e916157 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -143,7 +143,7 @@ static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
-	IWL_DEBUG_INFO(priv, "%s uCode section being loaded...\n", name);
+	IWL_DEBUG_FW(priv, "%s uCode section being loaded...\n", name);
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
 					priv->ucode_write_complete, 5 * HZ);
 	if (ret == -ERESTARTSYS) {
@@ -508,7 +508,7 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv,
 	u32 val;
 	u32 i;
 
-	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
 
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
@@ -533,7 +533,7 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 	u32 offs;
 	int errors = 0;
 
-	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
 
 	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			   IWLAGN_RTC_INST_LOWER_BOUND);
@@ -559,7 +559,7 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 static int iwl_verify_ucode(struct iwl_priv *priv, struct fw_img *img)
 {
 	if (!iwlcore_verify_inst_sparse(priv, &img->code)) {
-		IWL_DEBUG_INFO(priv, "uCode is good in inst SRAM\n");
+		IWL_DEBUG_FW(priv, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -583,7 +583,7 @@ static void iwlagn_alive_fn(struct iwl_priv *priv,
 
 	palive = &pkt->u.alive_frame;
 
-	IWL_DEBUG_INFO(priv, "Alive ucode status 0x%08X revision "
+	IWL_DEBUG_FW(priv, "Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
-- 
1.7.0.4

