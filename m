Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab1DERBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/25] iwlagn: simplify ucode check code
Date: Tue,  5 Apr 2011 09:41:55 -0700
Message-Id: <1302021732-21250-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code in iwlcore_verify_inst_sparse really
doesn't need to keep track of the number of
errors it encountered since a single one is
fatal.

Also, the code in iwl_verify_inst_full is just
used to print out some things, so rename it to
iwl_print_inst and don't give it a return code
and just make it print out the values.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   51 +++++++++-----------------
 1 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 127c842..2205b60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -542,8 +542,6 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 {
 	u32 val;
-	int ret = 0;
-	u32 errcnt = 0;
 	u32 i;
 
 	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
@@ -555,56 +553,39 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			i + IWLAGN_RTC_INST_LOWER_BOUND);
 		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-			ret = -EIO;
-			errcnt++;
-			if (errcnt >= 3)
-				break;
-		}
+		if (val != le32_to_cpu(*image))
+			return -EIO;
 	}
 
-	return ret;
+	return 0;
 }
 
-/**
- * iwlcore_verify_inst_full - verify runtime uCode image in card vs. host,
- *     looking at all data.
- */
-static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
-				 u32 len)
+static void iwl_print_mismatch_inst(struct iwl_priv *priv,
+				    __le32 *image, u32 len)
 {
 	u32 val;
-	u32 save_len = len;
-	int ret = 0;
-	u32 errcnt;
+	u32 offs;
+	int errors = 0;
 
 	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
 	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
 			   IWLAGN_RTC_INST_LOWER_BOUND);
 
-	errcnt = 0;
-	for (; len > 0; len -= sizeof(u32), image++) {
+	for (offs = 0;
+	     offs < len && errors < 20;
+	     offs += sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
 		val = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(priv, "uCode INST section is invalid at "
-				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
-				  save_len - len, val, le32_to_cpu(*image));
-			ret = -EIO;
-			errcnt++;
-			if (errcnt >= 20)
-				break;
+			IWL_ERR(priv, "uCode INST section at "
+				"offset 0x%x, is 0x%x, s/b 0x%x\n",
+				offs, val, le32_to_cpu(*image));
+			errors++;
 		}
 	}
-
-	if (!errcnt)
-		IWL_DEBUG_INFO(priv,
-		    "ucode image in INSTRUCTION memory is good\n");
-
-	return ret;
 }
 
 /**
@@ -651,5 +632,7 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 	 * Selection of bootstrap image (vs. other images) is arbitrary. */
 	image = (__le32 *)priv->ucode_boot.v_addr;
 	len = priv->ucode_boot.len;
-	return iwl_verify_inst_full(priv, image, len);
+	iwl_print_mismatch_inst(priv, image, len);
+
+	return -EIO;
 }
-- 
1.7.0.4

