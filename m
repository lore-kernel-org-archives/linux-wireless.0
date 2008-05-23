Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759814AbYEWCLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: remove 4965 from alive_resp structures
Date: Fri, 23 May 2008 10:09:14 +0800
Message-Id: <1211508569-3163-37-git-send-email-yi.zhu@intel.com> (sfid-20080523_042836_042031_12AA8AD5)
In-Reply-To: <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes 4965 from alive_resp and init_alivie_resp.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   16 ++++++++--------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5b9e9bf..afd0f7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -373,7 +373,7 @@ struct iwl4965_tx_power_db {
  * 3)  Tx gain compensation to balance 4965's 2 Tx chains for MIMO operation,
  *     for each of 5 frequency ranges.
  */
-struct iwl4965_init_alive_resp {
+struct iwl_init_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
@@ -449,7 +449,7 @@ struct iwl4965_init_alive_resp {
  * The Linux driver can print both logs to the system log when a uCode error
  * occurs.
  */
-struct iwl4965_alive_resp {
+struct iwl_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
@@ -473,7 +473,7 @@ union tsf {
 /*
  * REPLY_ERROR = 0x2 (response only, not a command)
  */
-struct iwl4965_error_resp {
+struct iwl_error_resp {
 	__le32 error_type;
 	u8 cmd_id;
 	u8 reserved1;
@@ -2861,12 +2861,12 @@ struct iwl_rx_packet {
 	__le32 len;
 	struct iwl_cmd_header hdr;
 	union {
-		struct iwl4965_alive_resp alive_frame;
+		struct iwl_alive_resp alive_frame;
 		struct iwl4965_rx_frame rx_frame;
 		struct iwl4965_tx_resp tx_resp;
 		struct iwl4965_spectrum_notification spectrum_notif;
 		struct iwl4965_csa_notification csa_notif;
-		struct iwl4965_error_resp err_resp;
+		struct iwl_error_resp err_resp;
 		struct iwl4965_card_state_notif card_state_notif;
 		struct iwl4965_beacon_notif beacon_status;
 		struct iwl4965_add_sta_resp add_sta;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ea08cf9..4c31164 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1036,8 +1036,8 @@ struct iwl_priv {
 
 	/* 1st responses from initialize and runtime uCode images.
 	 * 4965's initialize alive response contains some calibration data. */
-	struct iwl4965_init_alive_resp card_alive_init;
-	struct iwl4965_alive_resp card_alive;
+	struct iwl_init_alive_resp card_alive_init;
+	struct iwl_alive_resp card_alive;
 #ifdef CONFIG_IWLWIFI_RFKILL
 	struct iwl_rfkill_mngr rfkill_mngr;
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0559cdc..857ec37 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1935,11 +1935,11 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 }
 
 
-static void iwl4965_rx_reply_alive(struct iwl_priv *priv,
-				   struct iwl_rx_mem_buffer *rxb)
+static void iwl_rx_reply_alive(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_alive_resp *palive;
+	struct iwl_alive_resp *palive;
 	struct delayed_work *pwork;
 
 	palive = &pkt->u.alive_frame;
@@ -1953,12 +1953,12 @@ static void iwl4965_rx_reply_alive(struct iwl_priv *priv,
 		IWL_DEBUG_INFO("Initialization Alive received.\n");
 		memcpy(&priv->card_alive_init,
 		       &pkt->u.alive_frame,
-		       sizeof(struct iwl4965_init_alive_resp));
+		       sizeof(struct iwl_init_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
 		IWL_DEBUG_INFO("Runtime Alive received.\n");
 		memcpy(&priv->card_alive, &pkt->u.alive_frame,
-		       sizeof(struct iwl4965_alive_resp));
+		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->alive_start;
 	}
 
@@ -2287,7 +2287,7 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
  */
 static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 {
-	priv->rx_handlers[REPLY_ALIVE] = iwl4965_rx_reply_alive;
+	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
 	priv->rx_handlers[REPLY_ADD_STA] = iwl4965_rx_reply_add_sta;
 	priv->rx_handlers[REPLY_ERROR] = iwl4965_rx_reply_error;
 	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl4965_rx_csa;
@@ -3431,7 +3431,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	priv->cfg->ops->lib->free_shared_mem(priv);
 
  exit:
-	memset(&priv->card_alive, 0, sizeof(struct iwl4965_alive_resp));
+	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
@@ -5085,7 +5085,7 @@ static ssize_t show_version(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = d->driver_data;
-	struct iwl4965_alive_resp *palive = &priv->card_alive;
+	struct iwl_alive_resp *palive = &priv->card_alive;
 
 	if (palive->is_valid)
 		return sprintf(buf, "fw version: 0x%01X.0x%01X.0x%01X.0x%01X\n"
-- 
1.5.3.6

