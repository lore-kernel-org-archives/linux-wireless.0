Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab0EJW20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/47] iwlagn: show and store firmware build number
Date: Mon, 10 May 2010 15:27:48 -0700
Message-Id: <1273530498-11876-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We currently display the build number only if debugging
is enabled, but it is really helpful so show it all the
time. Also store it so it can be retrieved later via
ethtool.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dd1324d..f9c9c08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1552,6 +1552,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	u32 inst_size, data_size, init_size, init_data_size, boot_size;
 	int err;
 	u16 eeprom_ver;
+	char buildstr[25];
 
 	if (!ucode_raw) {
 		IWL_ERR(priv, "request for firmware file '%s' failed.\n",
@@ -1599,22 +1600,26 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			  "from http://www.intellinuxwireless.org.\n",
 			  api_max, api_ver);
 
-	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u\n",
-	       IWL_UCODE_MAJOR(priv->ucode_ver),
-	       IWL_UCODE_MINOR(priv->ucode_ver),
-	       IWL_UCODE_API(priv->ucode_ver),
-	       IWL_UCODE_SERIAL(priv->ucode_ver));
+	if (build)
+		sprintf(buildstr, " build %u", build);
+	else
+		buildstr[0] = '\0';
+
+	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u%s\n",
+		 IWL_UCODE_MAJOR(priv->ucode_ver),
+		 IWL_UCODE_MINOR(priv->ucode_ver),
+		 IWL_UCODE_API(priv->ucode_ver),
+		 IWL_UCODE_SERIAL(priv->ucode_ver),
+		 buildstr);
 
 	snprintf(priv->hw->wiphy->fw_version,
 		 sizeof(priv->hw->wiphy->fw_version),
-		 "%u.%u.%u.%u",
+		 "%u.%u.%u.%u%s",
 		 IWL_UCODE_MAJOR(priv->ucode_ver),
 		 IWL_UCODE_MINOR(priv->ucode_ver),
 		 IWL_UCODE_API(priv->ucode_ver),
-		 IWL_UCODE_SERIAL(priv->ucode_ver));
-
-	if (build)
-		IWL_DEBUG_INFO(priv, "Build %u\n", build);
+		 IWL_UCODE_SERIAL(priv->ucode_ver),
+		 buildstr);
 
 	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
 	IWL_DEBUG_INFO(priv, "NVM Type: %s, version: 0x%x\n",
-- 
1.6.3.3

