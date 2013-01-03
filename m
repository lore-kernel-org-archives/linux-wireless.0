Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3ACOpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/12] iwlwifi: don't verify fw after download
Date: Thu,  3 Jan 2013 15:46:07 +0100
Message-Id: <1357224376-27803-3-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154936_674147_61263252)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

No need to verify that the fw has been written correctly.
In case it hasn't, we won't get ALIVE notification.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/ucode.c | 94 --------------------------------
 1 file changed, 94 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index c6467e5..ecf700b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -286,89 +286,6 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 	return iwl_send_calib_results(priv);
 }
 
-
-/**
- * iwl_verify_inst_sparse - verify runtime uCode image in card vs. host,
- *   using sample data 100 bytes apart.  If these sample points are good,
- *   it's a pretty good bet that everything between them is good, too.
- */
-static int iwl_verify_sec_sparse(struct iwl_priv *priv,
-				  const struct fw_desc *fw_desc)
-{
-	__le32 *image = (__le32 *)fw_desc->data;
-	u32 len = fw_desc->len;
-	u32 val;
-	u32 i;
-
-	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
-
-	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
-		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IWL_DL_IO is set */
-		iwl_write_direct32(priv->trans, HBUS_TARG_MEM_RADDR,
-			i + fw_desc->offset);
-		val = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image))
-			return -EIO;
-	}
-
-	return 0;
-}
-
-static void iwl_print_mismatch_sec(struct iwl_priv *priv,
-				    const struct fw_desc *fw_desc)
-{
-	__le32 *image = (__le32 *)fw_desc->data;
-	u32 len = fw_desc->len;
-	u32 val;
-	u32 offs;
-	int errors = 0;
-
-	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
-
-	iwl_write_direct32(priv->trans, HBUS_TARG_MEM_RADDR,
-				fw_desc->offset);
-
-	for (offs = 0;
-	     offs < len && errors < 20;
-	     offs += sizeof(u32), image++) {
-		/* read data comes through single port, auto-incr addr */
-		val = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(priv, "uCode INST section at "
-				"offset 0x%x, is 0x%x, s/b 0x%x\n",
-				offs, val, le32_to_cpu(*image));
-			errors++;
-		}
-	}
-}
-
-/**
- * iwl_verify_ucode - determine which instruction image is in SRAM,
- *    and verify its contents
- */
-static int iwl_verify_ucode(struct iwl_priv *priv,
-			    enum iwl_ucode_type ucode_type)
-{
-	const struct fw_img *img = iwl_get_ucode_image(priv, ucode_type);
-
-	if (!img) {
-		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
-		return -EINVAL;
-	}
-
-	if (!iwl_verify_sec_sparse(priv, &img->sec[IWL_UCODE_SECTION_INST])) {
-		IWL_DEBUG_FW(priv, "uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	IWL_ERR(priv, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
-
-	iwl_print_mismatch_sec(priv, &img->sec[IWL_UCODE_SECTION_INST]);
-	return -EIO;
-}
-
 struct iwl_alive_data {
 	bool valid;
 	u8 subtype;
@@ -450,18 +367,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return -EIO;
 	}
 
-	/*
-	 * This step takes a long time (60-80ms!!) and
-	 * WoWLAN image should be loaded quickly, so
-	 * skip it for WoWLAN.
-	 */
 	if (ucode_type != IWL_UCODE_WOWLAN) {
-		ret = iwl_verify_ucode(priv, ucode_type);
-		if (ret) {
-			priv->cur_ucode = old_type;
-			return ret;
-		}
-
 		/* delay a bit to give rfkill time to run */
 		msleep(5);
 	}
-- 
1.8.0

