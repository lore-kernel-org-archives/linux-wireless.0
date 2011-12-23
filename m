Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab1LWHOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:25 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/10] iwlegacy: 3945: simplify calculations of retry limit
Date: Fri, 23 Dec 2011 08:13:49 +0100
Message-Id: <1324624430-3688-9-git-send-email-sgruszka@redhat.com> (sfid-20111223_081427_548149_F762A6AA)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    3 +--
 drivers/net/wireless/iwlegacy/3945.c     |   15 ++++-----------
 drivers/net/wireless/iwlegacy/3945.h     |    3 +--
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index daef6b5..c817975 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -570,8 +570,7 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	/* TODO need this for burst mode later on */
 	il3945_build_tx_cmd_basic(il, out_cmd, info, hdr, sta_id);
 
-	/* set is_hcca to 0; it probably will never be implemented */
-	il3945_hw_build_tx_cmd_rate(il, out_cmd, info, hdr, sta_id, 0);
+	il3945_hw_build_tx_cmd_rate(il, out_cmd, info, hdr, sta_id);
 
 	/* Total # bytes to be transmitted */
 	len = (u16) skb->len;
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 44a1211..1489b15 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -680,13 +680,13 @@ il3945_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 void
 il3945_hw_build_tx_cmd_rate(struct il_priv *il, struct il_device_cmd *cmd,
 			    struct ieee80211_tx_info *info,
-			    struct ieee80211_hdr *hdr, int sta_id, int tx_id)
+			    struct ieee80211_hdr *hdr, int sta_id)
 {
 	u16 hw_value = ieee80211_get_tx_rate(il->hw, info)->hw_value;
 	u16 rate_idx = min(hw_value & 0xffff, RATE_COUNT_3945 - 1);
 	u16 rate_mask;
 	int rate;
-	u8 rts_retry_limit;
+	const u8 rts_retry_limit = 7;
 	u8 data_retry_limit;
 	__le32 tx_flags;
 	__le16 fc = hdr->frame_control;
@@ -705,15 +705,8 @@ il3945_hw_build_tx_cmd_rate(struct il_priv *il, struct il_device_cmd *cmd,
 	else
 		data_retry_limit = IL_DEFAULT_TX_RETRY;
 	tx_cmd->data_retry_limit = data_retry_limit;
-
-	if (tx_id >= IL39_CMD_QUEUE_NUM)
-		rts_retry_limit = 3;
-	else
-		rts_retry_limit = 7;
-
-	if (data_retry_limit < rts_retry_limit)
-		rts_retry_limit = data_retry_limit;
-	tx_cmd->rts_retry_limit = rts_retry_limit;
+	/* Set retry limit on RTS packets */
+	tx_cmd->rts_retry_limit = min(data_retry_limit, rts_retry_limit);
 
 	tx_cmd->rate = rate;
 	tx_cmd->tx_flags = tx_flags;
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 970e5c3..9f42f79 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -239,8 +239,7 @@ extern unsigned int il3945_hw_get_beacon_cmd(struct il_priv *il,
 					     u8 rate);
 void il3945_hw_build_tx_cmd_rate(struct il_priv *il, struct il_device_cmd *cmd,
 				 struct ieee80211_tx_info *info,
-				 struct ieee80211_hdr *hdr, int sta_id,
-				 int tx_id);
+				 struct ieee80211_hdr *hdr, int sta_id);
 extern int il3945_hw_reg_send_txpower(struct il_priv *il);
 extern int il3945_hw_reg_set_txpower(struct il_priv *il, s8 power);
 extern void il3945_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb);
-- 
1.7.4.4

