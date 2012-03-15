Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161434Ab2COU2C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:02 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/26] iwlwifi: simplify calibration collection
Date: Thu, 15 Mar 2012 13:26:45 -0700
Message-Id: <1331843226-29860-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212858_568502_C9C9313C)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The calibration results all come in while we're
waiting for the calibration complete notification.
As a consequence, there's no need to install a
global RX handler for them, we can use the newly
extended notification wait framework for this and
make the code easier to follow.

It is now quite explicit that we are processing
the calibration results while waiting for the
complete notification, before this was implicit
and developers had to know this to understand why
we wait for the calibration complete notification
and what happens while we wait.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |    3 --
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    3 --
 drivers/net/wireless/iwlwifi/iwl-ucode.c  |   46 +++++++++++++++++------------
 3 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 45bfeed..872dc86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1134,9 +1134,6 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	handlers[REPLY_COMPRESSED_BA]		=
 		iwlagn_rx_reply_compressed_ba;
 
-	/* init calibration handlers */
-	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
-					iwlagn_rx_calib_result;
 	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
 
 	/* set up notification wait support */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 3780a03..2dfa564 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -115,9 +115,6 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 			struct iwl_rxon_context *ctx);
 
 /* uCode */
-int iwlagn_rx_calib_result(struct iwl_priv *priv,
-			    struct iwl_rx_cmd_buffer *rxb,
-			    struct iwl_device_cmd *cmd);
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwl_send_prio_tbl(struct iwl_priv *priv);
 int iwl_init_alive_start(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 44b0e72..a5b2189 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -174,24 +174,6 @@ static int iwl_send_calib_cfg(struct iwl_priv *priv)
 	return iwl_dvm_send_cmd(priv, &cmd);
 }
 
-int iwlagn_rx_calib_result(struct iwl_priv *priv,
-			    struct iwl_rx_cmd_buffer *rxb,
-			    struct iwl_device_cmd *cmd)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->data;
-	int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-
-	/* reduce the size of the length field itself */
-	len -= 4;
-
-	if (iwl_calib_set(priv, hdr, len))
-		IWL_ERR(priv, "Failed to record calibration data %d\n",
-			hdr->op_code);
-
-	return 0;
-}
-
 int iwl_init_alive_start(struct iwl_priv *priv)
 {
 	int ret;
@@ -522,10 +504,36 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	return 0;
 }
 
+static bool iwlagn_wait_calib(struct iwl_notif_wait_data *notif_wait,
+			      struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_priv *priv = data;
+	struct iwl_calib_hdr *hdr;
+	int len;
+
+	if (pkt->hdr.cmd != CALIBRATION_RES_NOTIFICATION) {
+		WARN_ON(pkt->hdr.cmd != CALIBRATION_COMPLETE_NOTIFICATION);
+		return true;
+	}
+
+	hdr = (struct iwl_calib_hdr *)pkt->data;
+	len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+
+	/* reduce the size by the length field itself */
+	len -= sizeof(__le32);
+
+	if (iwl_calib_set(priv, hdr, len))
+		IWL_ERR(priv, "Failed to record calibration data %d\n",
+			hdr->op_code);
+
+	return false;
+}
+
 int iwl_run_init_ucode(struct iwl_priv *priv)
 {
 	struct iwl_notification_wait calib_wait;
 	static const u8 calib_complete[] = {
+		CALIBRATION_RES_NOTIFICATION,
 		CALIBRATION_COMPLETE_NOTIFICATION
 	};
 	int ret;
@@ -541,7 +549,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 
 	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
 				   calib_complete, ARRAY_SIZE(calib_complete),
-				   NULL, NULL);
+				   iwlagn_wait_calib, priv);
 
 	/* Will also start the device */
 	ret = iwl_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
-- 
1.7.0.4

