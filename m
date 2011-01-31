Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab1AaVxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/11] iwlwifi: check ucode loading error and restart
Date: Mon, 31 Jan 2011 13:40:37 -0800
Message-Id: <1296510047-24576-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver check alive message from ucode, if it is not ok, then need
to restart the loading process. instead of checking multiple places
for failure, only need to check in once place when receive alive
message from uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c      |    8 --------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    8 --------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   15 ++++++---------
 3 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 7c14eb3..ace0b98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -251,14 +251,6 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 */
 static void iwl4965_init_alive_start(struct iwl_priv *priv)
 {
-	/* Check alive response for "valid" sign from uCode */
-	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
-		/* We had an error bringing up the hardware, so take it
-		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO(priv, "Initialize Alive failed.\n");
-		goto restart;
-	}
-
 	/* Bootstrap uCode has loaded initialize uCode ... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "initialize" alive if code weren't properly loaded.  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 24dabcd..d807e5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -308,14 +308,6 @@ void iwlagn_init_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	/* Check alive response for "valid" sign from uCode */
-	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
-		/* We had an error bringing up the hardware, so take it
-		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO(priv, "Initialize Alive failed.\n");
-		goto restart;
-	}
-
 	/* initialize uCode was loaded... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "initialize" alive if code weren't properly loaded.  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 646ccb2..3e586d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -462,8 +462,12 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 	if (palive->is_valid == UCODE_VALID_OK)
 		queue_delayed_work(priv->workqueue, pwork,
 				   msecs_to_jiffies(5));
-	else
-		IWL_WARN(priv, "uCode did not respond OK.\n");
+	else {
+		IWL_WARN(priv, "%s uCode did not respond OK.\n",
+			(palive->ver_subtype == INITIALIZE_SUBTYPE) ?
+			"init" : "runtime");
+		queue_work(priv->workqueue, &priv->restart);
+	}
 }
 
 static void iwl_bg_beacon_update(struct work_struct *work)
@@ -2648,13 +2652,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
-	if (priv->card_alive.is_valid != UCODE_VALID_OK) {
-		/* We had an error bringing up the hardware, so take it
-		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO(priv, "Alive failed.\n");
-		goto restart;
-	}
-
 	/* Initialize uCode has loaded Runtime uCode ... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "runtime" alive if code weren't properly loaded.  */
-- 
1.7.0.4

