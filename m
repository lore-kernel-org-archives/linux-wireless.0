Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab0JGXIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/22] iwlagn: no version check for experimental uCode
Date: Thu,  7 Oct 2010 16:07:59 -0700
Message-Id: <1286492881-15743-21-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For experimental uCode, it should work with the driver
if driver has experimental uCode support option enabled;
remove the API version checking.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 763a93d..1b682dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2104,18 +2104,23 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * firmware filename ... but we don't check for that and only rely
 	 * on the API version read from firmware header from here on forward
 	 */
-	if (api_ver < api_min || api_ver > api_max) {
-		IWL_ERR(priv, "Driver unable to support your firmware API. "
-			  "Driver supports v%u, firmware is v%u.\n",
-			  api_max, api_ver);
-		goto try_again;
-	}
+	/* no api version check required for experimental uCode */
+	if (priv->fw_index != UCODE_EXPERIMENTAL_INDEX) {
+		if (api_ver < api_min || api_ver > api_max) {
+			IWL_ERR(priv,
+				"Driver unable to support your firmware API. "
+				"Driver supports v%u, firmware is v%u.\n",
+				api_max, api_ver);
+			goto try_again;
+		}
 
-	if (api_ver != api_max)
-		IWL_ERR(priv, "Firmware has old API version. Expected v%u, "
-			  "got v%u. New firmware can be obtained "
-			  "from http://www.intellinuxwireless.org.\n",
-			  api_max, api_ver);
+		if (api_ver != api_max)
+			IWL_ERR(priv,
+				"Firmware has old API version. Expected v%u, "
+				"got v%u. New firmware can be obtained "
+				"from http://www.intellinuxwireless.org.\n",
+				api_max, api_ver);
+	}
 
 	if (build)
 		sprintf(buildstr, " build %u%s", build,
-- 
1.7.0.4

