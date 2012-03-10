Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48736 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab2CJU72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlwifi: explicitly track whether INIT uCode was run
Date: Sat, 10 Mar 2012 13:00:11 -0800
Message-Id: <1331413215-10027-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_220016_008798_F4821E2A)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Remove IWL_UCODE_NONE from enum iwl_ucode_type which,
by being the default value in 0-initialized memory,
implicitly allowed us to track whether any uCode had
ever been loaded successfully (which would have been
the INIT uCode) and instead explicitly track whether
or not INIT uCode has been run.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-shared.h |    4 +---
 drivers/net/wireless/iwlwifi/iwl-ucode.c  |    6 ++++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 01dbe11..16956b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -770,6 +770,7 @@ struct iwl_priv {
 	unsigned long reload_jiffies;
 	int reload_count;
 	bool ucode_loaded;
+	bool init_ucode_run;		/* Don't run init uCode again */
 
 	/* we allocate array of iwl_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 29d2a85..4cd2ece 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -195,15 +195,13 @@ struct iwl_hw_params {
 /**
  * enum iwl_ucode_type
  *
- * The type of ucode currently loaded on the hardware.
+ * The type of ucode.
  *
- * @IWL_UCODE_NONE: No ucode loaded
  * @IWL_UCODE_REGULAR: Normal runtime ucode
  * @IWL_UCODE_INIT: Initial ucode
  * @IWL_UCODE_WOWLAN: Wake on Wireless enabled ucode
  */
 enum iwl_ucode_type {
-	IWL_UCODE_NONE,
 	IWL_UCODE_REGULAR,
 	IWL_UCODE_INIT,
 	IWL_UCODE_WOWLAN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index ae935c0..0908880 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -87,7 +87,7 @@ iwl_get_ucode_image(struct iwl_priv *priv, enum iwl_ucode_type ucode_type)
 		return &priv->fw->ucode_wowlan;
 	case IWL_UCODE_REGULAR:
 		return &priv->fw->ucode_rt;
-	case IWL_UCODE_NONE:
+	default:
 		break;
 	}
 	return NULL;
@@ -537,7 +537,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	if (!priv->fw->ucode_init.code.len)
 		return 0;
 
-	if (priv->shrd->ucode_type != IWL_UCODE_NONE)
+	if (priv->init_ucode_run)
 		return 0;
 
 	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
@@ -559,6 +559,8 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	 */
 	ret = iwl_wait_notification(&priv->notif_wait, &calib_wait,
 					UCODE_CALIB_TIMEOUT);
+	if (!ret)
+		priv->init_ucode_run = true;
 
 	goto out;
 
-- 
1.7.0.4

