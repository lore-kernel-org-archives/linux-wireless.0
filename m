Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab2BQUXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/26] iwlwifi: move fw_index from iwl_priv to iwl_nic
Date: Fri, 17 Feb 2012 11:13:37 -0800
Message-Id: <1329506034-1394-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212358_233872_E65DA8A6)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Delete fw_index from iwl_priv and use iwl_nic instead.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h   |    1 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c |   23 ++++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f3dc67c..008287f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -788,7 +788,6 @@ struct iwl_priv {
 	struct mac_address addresses[2];
 
 	/* uCode images, save to reload in case of failure */
-	int fw_index;			/* firmware we're trying to load */
 	char firmware_name[25];
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index ca3cd8a..c3ac2cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -690,23 +690,24 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 
 int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 {
+	struct iwl_nic *nic = nic(priv);
 	const char *name_pre = cfg(priv)->fw_name_pre;
 	char tag[8];
 
 	if (first) {
 #ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
-		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
+		nic->fw_index = UCODE_EXPERIMENTAL_INDEX;
 		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
-	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
+	} else if (nic->fw_index == UCODE_EXPERIMENTAL_INDEX) {
 #endif
-		priv->fw_index = cfg(priv)->ucode_api_max;
-		sprintf(tag, "%d", priv->fw_index);
+		nic->fw_index = cfg(priv)->ucode_api_max;
+		sprintf(tag, "%d", nic->fw_index);
 	} else {
-		priv->fw_index--;
-		sprintf(tag, "%d", priv->fw_index);
+		nic->fw_index--;
+		sprintf(tag, "%d", nic->fw_index);
 	}
 
-	if (priv->fw_index < cfg(priv)->ucode_api_min) {
+	if (nic->fw_index < cfg(priv)->ucode_api_min) {
 		IWL_ERR(priv, "no suitable firmware found!\n");
 		return -ENOENT;
 	}
@@ -714,7 +715,7 @@ int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 	sprintf(priv->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
 
 	IWL_DEBUG_INFO(priv, "attempting to load firmware %s'%s'\n",
-		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
+		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? "EXPERIMENTAL " : "",
 		       priv->firmware_name);
 
@@ -1032,7 +1033,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	memset(&pieces, 0, sizeof(pieces));
 
 	if (!ucode_raw) {
-		if (priv->fw_index <= api_ok)
+		if (nic->fw_index <= api_ok)
 			IWL_ERR(priv,
 				"request for firmware file '%s' failed.\n",
 				priv->firmware_name);
@@ -1069,7 +1070,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * on the API version read from firmware header from here on forward
 	 */
 	/* no api version check required for experimental uCode */
-	if (priv->fw_index != UCODE_EXPERIMENTAL_INDEX) {
+	if (nic->fw_index != UCODE_EXPERIMENTAL_INDEX) {
 		if (api_ver < api_min || api_ver > api_max) {
 			IWL_ERR(priv,
 				"Driver unable to support your firmware API. "
@@ -1094,7 +1095,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	if (build)
 		sprintf(buildstr, " build %u%s", build,
-		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
+		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? " (EXP)" : "");
 	else
 		buildstr[0] = '\0';
-- 
1.7.0.4

