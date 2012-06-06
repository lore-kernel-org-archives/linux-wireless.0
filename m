Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2FFNX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/29] iwlwifi: configure the SKU in the HW
Date: Wed,  6 Jun 2012 15:22:05 +0200
Message-Id: <1338988930-11561-24-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152331_318161_ED2DB48D)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This was missing. Fix the mask of the REV_TYPE on the way.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-csr.h  |   12 ++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 6cca1f4..10a2800 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2218,6 +2218,15 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
+	/* SKU Control */
+	iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
+			  CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH |
+			  CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP,
+			  (CSR_HW_REV_STEP(priv->trans->hw_rev) <<
+				CSR_HW_IF_CONFIG_REG_POS_MAC_STEP) |
+			  (CSR_HW_REV_DASH(priv->trans->hw_rev) <<
+				CSR_HW_IF_CONFIG_REG_POS_MAC_DASH));
+
 	priv->lib->nic_config(priv);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 41dc691..34a5287 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -97,13 +97,10 @@
 /*
  * Hardware revision info
  * Bit fields:
- * 31-8:  Reserved
- *  7-4:  Type of device:  see CSR_HW_REV_TYPE_xxx definitions
+ * 31-16:  Reserved
+ *  15-4:  Type of device:  see CSR_HW_REV_TYPE_xxx definitions
  *  3-2:  Revision step:  0 = A, 1 = B, 2 = C, 3 = D
  *  1-0:  "Dash" (-) value, as in A-1, etc.
- *
- * NOTE:  Revision step affects calculation of CCK txpower for 4965.
- * NOTE:  See also CSR_HW_REV_WA_REG (work-around for bug in 4965).
  */
 #define CSR_HW_REV              (CSR_BASE+0x028)
 
@@ -282,7 +279,10 @@
 
 
 /* HW REV */
-#define CSR_HW_REV_TYPE_MSK            (0x00001F0)
+#define CSR_HW_REV_DASH(_val)          (((_val) & 0x0000003) >> 0)
+#define CSR_HW_REV_STEP(_val)          (((_val) & 0x000000C) >> 2)
+
+#define CSR_HW_REV_TYPE_MSK            (0x000FFF0)
 #define CSR_HW_REV_TYPE_5300           (0x0000020)
 #define CSR_HW_REV_TYPE_5350           (0x0000030)
 #define CSR_HW_REV_TYPE_5100           (0x0000050)
-- 
1.7.10

