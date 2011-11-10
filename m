Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab1KJBdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/28] iwlagn: push knowledge of ucode image lower down
Date: Wed,  9 Nov 2011 16:39:13 -0800
Message-Id: <1320885571-19122-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023345_075456_24F1FC33)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the knowledge of the ucode image to lower level routines.  Also do
not pass the iwl_priv structure lower than it needs to be.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   51 +++++++++++++++-----------
 1 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 1ad4af4..9144ef5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -142,9 +142,16 @@ static inline struct fw_img *iwl_get_ucode_image(struct iwl_priv *priv,
 }
 
 static int iwlagn_load_given_ucode(struct iwl_priv *priv,
-				   struct fw_img *image)
+				   enum iwlagn_ucode_type ucode_type)
 {
 	int ret = 0;
+	struct fw_img *image = iwl_get_ucode_image(priv, ucode_type);
+
+
+	if (!image) {
+		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
+		return -EINVAL;
+	}
 
 	ret = iwlagn_load_section(trans(priv), "INST", &image->code,
 				   IWLAGN_RTC_INST_LOWER_BOUND);
@@ -435,7 +442,7 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl_verify_inst_sparse(struct iwl_priv *priv,
+static int iwl_verify_inst_sparse(struct iwl_bus *bus,
 				      struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
@@ -443,15 +450,15 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv,
 	u32 val;
 	u32 i;
 
-	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(bus, "ucode inst image size is %u\n", len);
 
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_direct32(bus(priv), HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(bus, HBUS_TARG_MEM_RADDR,
 			i + IWLAGN_RTC_INST_LOWER_BOUND);
-		val = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image))
 			return -EIO;
 	}
@@ -459,7 +466,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv,
 	return 0;
 }
 
-static void iwl_print_mismatch_inst(struct iwl_priv *priv,
+static void iwl_print_mismatch_inst(struct iwl_bus *bus,
 				    struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
@@ -468,18 +475,18 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 	u32 offs;
 	int errors = 0;
 
-	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(bus, "ucode inst image size is %u\n", len);
 
-	iwl_write_direct32(bus(priv), HBUS_TARG_MEM_RADDR,
+	iwl_write_direct32(bus, HBUS_TARG_MEM_RADDR,
 			   IWLAGN_RTC_INST_LOWER_BOUND);
 
 	for (offs = 0;
 	     offs < len && errors < 20;
 	     offs += sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
-		val = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(priv, "uCode INST section at "
+			IWL_ERR(bus, "uCode INST section at "
 				"offset 0x%x, is 0x%x, s/b 0x%x\n",
 				offs, val, le32_to_cpu(*image));
 			errors++;
@@ -491,16 +498,24 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl_verify_ucode(struct iwl_priv *priv, struct fw_img *img)
+static int iwl_verify_ucode(struct iwl_priv *priv,
+			    enum iwlagn_ucode_type ucode_type)
 {
-	if (!iwl_verify_inst_sparse(priv, &img->code)) {
+	struct fw_img *img = iwl_get_ucode_image(priv, ucode_type);
+
+	if (!img) {
+		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
+		return -EINVAL;
+	}
+
+	if (!iwl_verify_inst_sparse(bus(priv), &img->code)) {
 		IWL_DEBUG_FW(priv, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
 	IWL_ERR(priv, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
-	iwl_print_mismatch_inst(priv, &img->code);
+	iwl_print_mismatch_inst(bus(priv), &img->code);
 	return -EIO;
 }
 
@@ -542,12 +557,6 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	struct iwlagn_alive_data alive_data;
 	int ret;
 	enum iwlagn_ucode_type old_type;
-	struct fw_img *image = iwl_get_ucode_image(priv, ucode_type);
-
-	if (!image) {
-		IWL_ERR(priv, "Invalid ucode requested (%d)\n", ucode_type);
-		return -EINVAL;
-	}
 
 	ret = iwl_trans_start_device(trans(priv));
 	if (ret)
@@ -559,7 +568,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	old_type = priv->ucode_type;
 	priv->ucode_type = ucode_type;
 
-	ret = iwlagn_load_given_ucode(priv, image);
+	ret = iwlagn_load_given_ucode(priv, ucode_type);
 	if (ret) {
 		priv->ucode_type = old_type;
 		iwlagn_remove_notification(priv, &alive_wait);
@@ -590,7 +599,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	 * skip it for WoWLAN.
 	 */
 	if (ucode_type != IWL_UCODE_WOWLAN) {
-		ret = iwl_verify_ucode(priv, image);
+		ret = iwl_verify_ucode(priv, ucode_type);
 		if (ret) {
 			priv->ucode_type = old_type;
 			return ret;
-- 
1.7.0.4

