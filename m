Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab0HRQSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/16] iwlwifi: enable experimental ucode support
Date: Wed, 18 Aug 2010 09:22:50 -0700
Message-Id: <1282148571-9258-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

ucode firmware may need to be released as experimental for testing or
debugging. released ucode filenames have the API version as the last
component.  experimental ucode files will have that component be "exp"
and the fw_version string reported by ethtool will also contain the
string EXP to clearly identify this ucode from released ucode.
EXP is short for EXPERIMENTAL since fw_version has a max lenght on 32.

this capability is controlled by Kconfig and defaulted to not be used.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   |    6 +++++
 drivers/net/wireless/iwlwifi/iwl-agn.c |   33 ++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index a51e4da..7ab5b51 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -36,6 +36,12 @@ config IWLWIFI_DEBUGFS
 	  is a low-impact option that allows getting insight into the
 	  driver's state at runtime.
 
+config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
+        bool "Experimental uCode support"
+        depends on IWLWIFI && IWLWIFI_DEBUG
+        ---help---
+	  Enable use of experimental ucode for testing and debugging.
+
 config IWLWIFI_DEVICE_TRACING
 	bool "iwlwifi device access tracing"
 	depends on IWLWIFI
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a88fabc..ca2cd9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1659,24 +1659,37 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 static int iwl_mac_setup_register(struct iwl_priv *priv,
 				  struct iwlagn_ucode_capabilities *capa);
 
+#define UCODE_EXPERIMENTAL_INDEX	100
+#define UCODE_EXPERIMENTAL_TAG		"exp"
+
 static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 {
 	const char *name_pre = priv->cfg->fw_name_pre;
+	char tag[8];
 
-	if (first)
+	if (first) {
+#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
+		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
+		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
+	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
+#endif
 		priv->fw_index = priv->cfg->ucode_api_max;
-	else
+		sprintf(tag, "%d", priv->fw_index);
+	} else {
 		priv->fw_index--;
+		sprintf(tag, "%d", priv->fw_index);
+	}
 
 	if (priv->fw_index < priv->cfg->ucode_api_min) {
 		IWL_ERR(priv, "no suitable firmware found!\n");
 		return -ENOENT;
 	}
 
-	sprintf(priv->firmware_name, "%s%d%s",
-		name_pre, priv->fw_index, ".ucode");
+	sprintf(priv->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
 
-	IWL_DEBUG_INFO(priv, "attempting to load firmware '%s'\n",
+	IWL_DEBUG_INFO(priv, "attempting to load firmware %s'%s'\n",
+		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
+				? "EXPERIMENTAL " : "",
 		       priv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
@@ -1971,8 +1984,10 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	memset(&pieces, 0, sizeof(pieces));
 
 	if (!ucode_raw) {
-		IWL_ERR(priv, "request for firmware file '%s' failed.\n",
-			priv->firmware_name);
+		if (priv->fw_index <= priv->cfg->ucode_api_max)
+			IWL_ERR(priv,
+				"request for firmware file '%s' failed.\n",
+				priv->firmware_name);
 		goto try_again;
 	}
 
@@ -2019,7 +2034,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			  api_max, api_ver);
 
 	if (build)
-		sprintf(buildstr, " build %u", build);
+		sprintf(buildstr, " build %u%s", build,
+		       (priv->fw_index == UCODE_EXPERIMENTAL_INDEX)
+				? " (EXP)" : "");
 	else
 		buildstr[0] = '\0';
 
-- 
1.7.0.4

