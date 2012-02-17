Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2BQUXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/26] iwlwifi: move firmware_name to iwl_nic
Date: Fri, 17 Feb 2012 11:13:38 -0800
Message-Id: <1329506034-1394-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212442_812775_BC6CE887)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Delete firmware_name from iwl_priv and use iwl_nic instead.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h   |    3 ---
 drivers/net/wireless/iwlwifi/iwl-ucode.c |   10 +++++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 008287f..3321010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -787,9 +787,6 @@ struct iwl_priv {
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[2];
 
-	/* uCode images, save to reload in case of failure */
-	char firmware_name[25];
-
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
 
 	__le16 switch_channel;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index c3ac2cc..0ba8ea9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -712,14 +712,14 @@ int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 		return -ENOENT;
 	}
 
-	sprintf(priv->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
+	sprintf(nic->firmware_name, "%s%s%s", name_pre, tag, ".ucode");
 
 	IWL_DEBUG_INFO(priv, "attempting to load firmware %s'%s'\n",
 		       (nic->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? "EXPERIMENTAL " : "",
-		       priv->firmware_name);
+		       nic->firmware_name);
 
-	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
+	return request_firmware_nowait(THIS_MODULE, 1, nic->firmware_name,
 				       trans(priv)->dev,
 				       GFP_KERNEL, priv, iwl_ucode_callback);
 }
@@ -1036,12 +1036,12 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		if (nic->fw_index <= api_ok)
 			IWL_ERR(priv,
 				"request for firmware file '%s' failed.\n",
-				priv->firmware_name);
+				nic->firmware_name);
 		goto try_again;
 	}
 
 	IWL_DEBUG_INFO(priv, "Loaded firmware file '%s' (%zd bytes).\n",
-		       priv->firmware_name, ucode_raw->size);
+		       nic->firmware_name, ucode_raw->size);
 
 	/* Make sure that we got at least the API version number */
 	if (ucode_raw->size < 4) {
-- 
1.7.0.4

