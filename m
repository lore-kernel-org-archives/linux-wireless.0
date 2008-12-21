Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33047 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYLUTyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 14:54:39 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] p54: label queues with their corresponding names
Date: Sun, 21 Dec 2008 20:54:34 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812212054.35216.chunkeey@web.de> (sfid-20081221_205444_219531_EA978A67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduce new shiny named labels for our 8 (4 - on old firmware) queues.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-20 01:30:41.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-21 20:42:16.000000000 +0100
@@ -228,11 +228,11 @@ int p54_parse_firmware(struct ieee80211_
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
-		priv->tx_stats[4].limit = 3;		/* AC_VO */
-		priv->tx_stats[5].limit = 4;		/* AC_VI */
-		priv->tx_stats[6].limit = 3;		/* AC_BE */
-		priv->tx_stats[7].limit = 2;		/* AC_BK */
-		dev->queues = 4;
+		priv->tx_stats[P54_QUEUE_AC_VO].limit = 3;
+		priv->tx_stats[P54_QUEUE_AC_VI].limit = 4;
+		priv->tx_stats[P54_QUEUE_AC_BE].limit = 3;
+		priv->tx_stats[P54_QUEUE_AC_BK].limit = 2;
+		dev->queues = P54_QUEUE_AC_NUM;
 	}
 
 	if (!modparam_nohwcrypt)
@@ -641,7 +641,8 @@ static void inline p54_wake_free_queues(
 		return ;
 
 	for (i = 0; i < dev->queues; i++)
-		if (priv->tx_stats[i + 4].len < priv->tx_stats[i + 4].limit)
+		if (priv->tx_stats[i + P54_QUEUE_DATA].len <
+		    priv->tx_stats[i + P54_QUEUE_DATA].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
@@ -1216,22 +1217,22 @@ static int p54_tx_fill(struct ieee80211_
 	if (unlikely(ieee80211_is_mgmt(hdr->frame_control))) {
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			*aid = 0;
-			*queue = 0;
+			*queue = P54_QUEUE_BEACON;
 			*extra_len = IEEE80211_MAX_TIM_LEN;
 			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP;
 			return 0;
 		} else if (ieee80211_is_probe_resp(hdr->frame_control)) {
 			*aid = 0;
-			*queue = 2;
+			*queue = P54_QUEUE_MGMT;
 			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP |
 				 P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 			return 0;
 		} else {
-			*queue = 2;
+			*queue = P54_QUEUE_MGMT;
 			ret = 0;
 		}
 	} else {
-		*queue += 4;
+		*queue += P54_QUEUE_DATA;
 		ret = 1;
 	}
 
@@ -1244,7 +1245,7 @@ static int p54_tx_fill(struct ieee80211_
 	case NL80211_IFTYPE_MESH_POINT:
 		if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 			*aid = 0;
-			*queue = 3;
+			*queue = P54_QUEUE_CAB;
 			return 0;
 		}
 		if (info->control.sta)
@@ -1272,7 +1273,7 @@ static u8 p54_convert_algo(enum ieee8021
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_queue_stats *current_queue = NULL;
+	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
@@ -1415,10 +1416,7 @@ static int p54_tx(struct ieee80211_hw *d
 	}
 	txhdr->crypt_offset = crypt_offset;
 	txhdr->hw_queue = queue;
-	if (current_queue)
-		txhdr->backlog = current_queue->len;
-	else
-		txhdr->backlog = 0;
+	txhdr->backlog = current_queue->len;
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
 	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1;
@@ -1440,10 +1438,8 @@ static int p54_tx(struct ieee80211_hw *d
 
  err:
 	skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
-	if (current_queue) {
-		current_queue->len--;
-		current_queue->count--;
-	}
+	current_queue->len--;
+	current_queue->count--;
 	return NETDEV_TX_BUSY;
 }
 
@@ -1991,8 +1987,8 @@ static int p54_get_tx_stats(struct ieee8
 {
 	struct p54_common *priv = dev->priv;
 
-	memcpy(stats, &priv->tx_stats[4], sizeof(stats[0]) * dev->queues);
-
+	memcpy(stats, &priv->tx_stats[P54_QUEUE_DATA],
+	       sizeof(stats[0]) * dev->queues);
 	return 0;
 }
 
@@ -2153,11 +2149,11 @@ struct ieee80211_hw *p54_init_common(siz
 				      BIT(NL80211_IFTYPE_MESH_POINT);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	priv->tx_stats[0].limit = 1;		/* Beacon queue */
-	priv->tx_stats[1].limit = 1;		/* Probe queue for HW scan */
-	priv->tx_stats[2].limit = 3;		/* queue for MLMEs */
-	priv->tx_stats[3].limit = 3;		/* Broadcast / MC queue */
-	priv->tx_stats[4].limit = 5;		/* Data */
+	priv->tx_stats[P54_QUEUE_BEACON].limit = 1;
+	priv->tx_stats[P54_QUEUE_FWSCAN].limit = 1;
+	priv->tx_stats[P54_QUEUE_MGMT].limit = 3;
+	priv->tx_stats[P54_QUEUE_CAB].limit = 3;
+	priv->tx_stats[P54_QUEUE_DATA].limit = 5;
 	dev->queues = 1;
 	priv->noise = -94;
 	/*
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-20 01:08:33.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-21 20:41:27.000000000 +0100
@@ -329,7 +329,7 @@ struct p54_frame_sent {
 	u8 padding;
 } __attribute__ ((packed));
 
-enum  p54_tx_data_crypt {
+enum p54_tx_data_crypt {
 	P54_CRYPTO_NONE = 0,
 	P54_CRYPTO_WEP,
 	P54_CRYPTO_TKIP,
@@ -340,6 +340,23 @@ enum  p54_tx_data_crypt {
 	P54_CRYPTO_AESCCMP
 };
 
+enum p54_tx_data_queue {
+	P54_QUEUE_BEACON	= 0,
+	P54_QUEUE_FWSCAN	= 1,
+	P54_QUEUE_MGMT		= 2,
+	P54_QUEUE_CAB		= 3,
+	P54_QUEUE_DATA		= 4,
+
+	P54_QUEUE_AC_NUM	= 4,
+	P54_QUEUE_AC_VO		= 4,
+	P54_QUEUE_AC_VI		= 5,
+	P54_QUEUE_AC_BE		= 6,
+	P54_QUEUE_AC_BK		= 7,
+
+	/* keep last */
+	P54_QUEUE_NUM		= 8,
+};
+
 struct p54_tx_data {
 	u8 rateset[8];
 	u8 rts_rate_idx;
