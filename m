Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab1GWSBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 14:01:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/11] iwlagn: separate firmware version warning
Date: Sat, 23 Jul 2011 10:24:44 -0700
Message-Id: <1311441890-19959-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110723_200137_670757_66A3E273)
In-Reply-To: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We sometimes need to support new firmware API for
a while before we can publish them since testing
them fully takes a long time. We could keep all
the new code private, but that causes plenty of
problems and sometimes we can give a pre-release
version of firmware to people who need to test.
However, when we just bump the API version, the
driver will warn everybody that their firmware is
outdated, when in fact it isn't. (Currently our
case for this doesn't really change the API but
bumping the API version is necessary because the
firmware isn't fully backward compatible)

In order to handle this in the future, add a new
"api_ok" version; only below this will the driver
warn that the uCode is too old.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   24 +++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 +++
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bb16726..871d880 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -952,6 +952,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	int err;
 	struct iwlagn_firmware_pieces pieces;
 	const unsigned int api_max = priv->cfg->ucode_api_max;
+	unsigned int api_ok = priv->cfg->ucode_api_ok;
 	const unsigned int api_min = priv->cfg->ucode_api_min;
 	u32 api_ver;
 	char buildstr[25];
@@ -962,10 +963,13 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE,
 	};
 
+	if (!api_ok)
+		api_ok = api_max;
+
 	memset(&pieces, 0, sizeof(pieces));
 
 	if (!ucode_raw) {
-		if (priv->fw_index <= priv->cfg->ucode_api_max)
+		if (priv->fw_index <= api_ok)
 			IWL_ERR(priv,
 				"request for firmware file '%s' failed.\n",
 				priv->firmware_name);
@@ -1011,12 +1015,18 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			goto try_again;
 		}
 
-		if (api_ver != api_max)
-			IWL_ERR(priv,
-				"Firmware has old API version. Expected v%u, "
-				"got v%u. New firmware can be obtained "
-				"from http://www.intellinuxwireless.org.\n",
-				api_max, api_ver);
+		if (api_ver < api_ok) {
+			if (api_ok != api_max)
+				IWL_ERR(priv, "Firmware has old API version, "
+					"expected v%u through v%u, got v%u.\n",
+					api_ok, api_max, api_ver);
+			else
+				IWL_ERR(priv, "Firmware has old API version, "
+					"expected v%u, got v%u.\n",
+					api_max, api_ver);
+			IWL_ERR(priv, "New firmware can be obtained from "
+				      "http://www.intellinuxwireless.org/.\n");
+		}
 	}
 
 	if (build)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3e6bb73..74f043d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -192,6 +192,8 @@ struct iwl_ht_params {
  *	(.ucode) will be added to filename before loading from disk. The
  *	filename is constructed as fw_name_pre<api>.ucode.
  * @ucode_api_max: Highest version of uCode API supported by driver.
+ * @ucode_api_ok: oldest version of the uCode API that is OK to load
+ *	without a warning, for use in transitions
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @valid_tx_ant: valid transmit antenna
  * @valid_rx_ant: valid receive antenna
@@ -235,6 +237,7 @@ struct iwl_cfg {
 	const char *name;
 	const char *fw_name_pre;
 	const unsigned int ucode_api_max;
+	const unsigned int ucode_api_ok;
 	const unsigned int ucode_api_min;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
-- 
1.7.0.4

