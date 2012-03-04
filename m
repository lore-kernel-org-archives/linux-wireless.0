Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab2CDUnN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:13 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 093/101] iwlwifi: move setting up fw parameters
Date: Sun,  4 Mar 2012 11:29:47 -0800
Message-Id: <1330889395-533-94-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214426_254153_40367F2B)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Gather parameters required to configure the
transport layer before invoking the transport
configuration API.

Change-Id: I5b39da284af6d9b5432a08911b4e1173a4d7207d
Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   45 +++++++++++++++++---------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 83018ec..3973424 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1206,6 +1206,30 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/* TODO: remove fw from shared data later */
 	priv->shrd->fw = fw;
 
+	/************************
+	 * 2. Setup HW constants
+	 ************************/
+	iwl_set_hw_params(priv);
+
+	ucode_flags = fw->ucode_capa.flags;
+
+#ifndef CONFIG_IWLWIFI_P2P
+	ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+#endif
+	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_IPAN_ENABLE))
+		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+
+	/*
+	 * if not PAN, then don't support P2P -- might be a uCode
+	 * packaging bug or due to the eeprom check above
+	 */
+	if (!(ucode_flags & IWL_UCODE_TLV_FLAGS_PAN))
+		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
+
+
+	/*****************************
+	 * Configure transport layer
+	 *****************************/
 	/*
 	 * Populate the state variables that the transport layer needs
 	 * to know about.
@@ -1286,27 +1310,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		priv->hw->wiphy->n_addresses++;
 	}
 
-	/************************
-	 * 5. Setup HW constants
-	 ************************/
-	iwl_set_hw_params(priv);
-
-	ucode_flags = fw->ucode_capa.flags;
-
-#ifndef CONFIG_IWLWIFI_P2P
-	ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
-#endif
-	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_IPAN_ENABLE))
-		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
-
-	/*
-	 * if not PAN, then don't support P2P -- might be a uCode
-	 * packaging bug or due to the eeprom check above
-	 */
-	if (!(ucode_flags & IWL_UCODE_TLV_FLAGS_PAN))
-		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
-
-
 	/*******************
 	 * 6. Setup priv
 	 *******************/
-- 
1.7.0.4

