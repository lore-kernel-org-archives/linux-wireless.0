Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760240AbXHHHhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:41 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 16/28] iwlwifi: Endianity fix for beacon host command
Date: Wed,  8 Aug 2007 15:33:33 +0800
Message-Id: <11865584631842-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584603865-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issues in beacon host command

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |    9 +++++----
 drivers/net/wireless/iwl-4965.c |    9 +++++----
 drivers/net/wireless/iwl-base.c |    8 +++++---
 drivers/net/wireless/iwlwifi.h  |    8 ++++----
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index c4441db..d209873 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -2232,24 +2232,25 @@ int iwl_hw_set_hw_setting(struct iwl_priv *priv)
 	return 0;
 }
 
-int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
+unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 			  struct iwl_frame *frame, u8 rate)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
-	int frame_size;
+	unsigned int frame_size;
 
 	tx_beacon_cmd = (struct iwl_tx_beacon_cmd *)&frame->u;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
 	tx_beacon_cmd->tx.sta_id = IWL_BROADCAST_ID;
-	tx_beacon_cmd->tx.stop_time.life_time = 0xFFFFFFFF;
+	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = iwl_fill_beacon_frame(priv,
 				tx_beacon_cmd->frame,
 				BROADCAST_ADDR,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.len = frame_size;
+	BUG_ON(frame_size > MAX_MPDU_SIZE);
+	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
 
 	tx_beacon_cmd->tx.rate = rate;
 	tx_beacon_cmd->tx.tx_flags = (TX_CMD_FLG_SEQ_CTL_MSK |
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 5999be5..e907f06 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2695,24 +2695,25 @@ int iwl_hw_get_temperature(struct iwl_priv *priv)
 	return priv->temperature;
 }
 
-int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
+unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 			  struct iwl_frame *frame, u8 rate)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
-	int frame_size;
+	unsigned int frame_size;
 
 	tx_beacon_cmd = &frame->u.beacon;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
 	tx_beacon_cmd->tx.sta_id = IWL_BROADCAST_ID;
-	tx_beacon_cmd->tx.stop_time.life_time = 0xFFFFFFFF;
+	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = iwl_fill_beacon_frame(priv,
 				tx_beacon_cmd->frame,
 				BROADCAST_ADDR,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.len = frame_size;
+	BUG_ON(frame_size > MAX_MPDU_SIZE);
+	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
 
 	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
 		tx_beacon_cmd->tx.rate_n_flags =
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 25931f5..8f19494 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1481,8 +1481,9 @@ static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
 	list_add(&frame->list, &priv->free_frames);
 }
 
-int iwl_fill_beacon_frame(struct iwl_priv *priv, struct ieee80211_hdr *hdr,
-			  const u8 *dest, int left)
+unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+				struct ieee80211_hdr *hdr,
+				const u8 *dest, int left)
 {
 
 	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
@@ -1501,7 +1502,8 @@ int iwl_fill_beacon_frame(struct iwl_priv *priv, struct ieee80211_hdr *hdr,
 static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl_frame *frame;
-	int frame_size, rc;
+	unsigned int frame_size;
+	int rc;
 	u8 rate;
 
 	frame = iwl_get_free_frame(priv);
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index be94217..6fea9a4 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -630,9 +630,9 @@ extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
 extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
 				     struct iwl_host_cmd *cmd);
-extern int iwl_fill_beacon_frame(struct iwl_priv *priv,
-				 struct ieee80211_hdr *hdr, const u8 *dest,
-				 int left);
+extern unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+					struct ieee80211_hdr *hdr,
+					const u8 *dest, int left);
 extern int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl_rx_queue *q);
 extern int iwl_send_statistics_request(struct iwl_priv *priv);
@@ -692,7 +692,7 @@ extern int iwl_tx_queue_free_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq);
 extern int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl_tx_queue *txq);
-extern int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
+extern unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
 extern int iwl_hw_get_rx_read(struct iwl_priv *priv);
 extern void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-- 
1.5.2
