Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53381 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYJRVO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 17:14:29 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/3 v3] p54: put broadcast frames into the right queues
Date: Sat, 18 Oct 2008 23:18:44 +0200
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
References: <200810170115.38317.chunkeey@web.de> <200810170354.25392.chunkeey@web.de> <1224332511.6324.3.camel@johannes.berg>
In-Reply-To: <1224332511.6324.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810182318.44880.chunkeey@web.de> (sfid-20081018_231432_481901_7C7D0C8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

stlc45xx's specs finally brought some light what all the 4 extra queues for.
now CAB data and managment frames have their own queue.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-18 21:25:46.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-18 22:52:36.000000000 +0200
@@ -902,6 +902,55 @@ free:
 }
 EXPORT_SYMBOL_GPL(p54_read_eeprom);
 
+static int p54_tx_fill(struct ieee80211_hw *dev, struct sk_buff *skb,
+		struct ieee80211_tx_info *info, u8 *queue, size_t *extra_len,
+		u16 *flags, u16 *aid)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct p54_common *priv = dev->priv;
+	int ret = 0;
+
+	if (unlikely(ieee80211_is_mgmt(hdr->frame_control))) {
+		if (ieee80211_is_beacon(hdr->frame_control)) {
+			*aid = 0;
+			*queue = 0;
+			*extra_len = IEEE80211_MAX_TIM_LEN;
+			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP;
+			return 0;
+		} else if (ieee80211_is_probe_resp(hdr->frame_control)) {
+			*aid = 0;
+			*queue = 2;
+			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP |
+				 P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			return 0;
+		} else {
+			*queue = 2;
+			ret = 0;
+		}
+	} else {
+		*queue += 4;
+		ret = 1;
+	}
+
+	switch (priv->mode) {
+	case NL80211_IFTYPE_STATION:
+		*aid = 1;
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+		if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
+			*aid = 0;
+			*queue = 3;
+			return 0;
+		}
+		if (info->control.sta)
+			*aid = info->control.sta->aid;
+		else
+			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+	}
+	return ret;
+}
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -909,22 +958,26 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	size_t padding, len;
+	size_t padding, len, tim_len;
 	int i, j, ridx;
-	u16 hdr_flags = 0;
-	u8 rate;
+	u16 hdr_flags = 0, aid = 0;
+	u8 rate, queue;
 	u8 cts_rate = 0x20;
 	u8 rc_flags;
 	u8 calculated_tries[4];
 	u8 nrates = 0, nremaining = 8;
 
-	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb) + 4];
-	if (unlikely(current_queue->len > current_queue->limit))
-		return NETDEV_TX_BUSY;
-	current_queue->len++;
-	current_queue->count++;
-	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
+	queue = skb_get_queue_mapping(skb);
+
+	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
+		current_queue = &priv->tx_stats[queue];
+		if (unlikely(current_queue->len > current_queue->limit))
+			return NETDEV_TX_BUSY;
+		current_queue->len++;
+		current_queue->count++;
+		if (current_queue->len == current_queue->limit)
+			ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
+	}
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
@@ -935,7 +988,7 @@ static int p54_tx(struct ieee80211_hw *d
 	if (padding)
 		hdr_flags |= P54_HDR_FLAG_DATA_ALIGN;
 	hdr->len = cpu_to_le16(len);
-	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
+	hdr->type = cpu_to_le16(aid);
 	hdr->rts_tries = info->control.rates[0].count;
 
 	/*
@@ -1013,7 +1066,7 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->rts_rate_idx = 0;
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
-	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
+	txhdr->hw_queue = queue;
 	txhdr->backlog = 32;
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
 	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
@@ -1024,7 +1077,7 @@ static int p54_tx(struct ieee80211_hw *d
 		txhdr->align[0] = padding;
 
 	/* modifies skb->cb and with it info, so must be last! */
-	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len))) {
+	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len + tim_len))) {
 		skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
 		if (current_queue) {
 			current_queue->len--;
@@ -1509,8 +1562,7 @@ struct ieee80211_hw *p54_init_common(siz
 	priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	skb_queue_head_init(&priv->tx_queue);
-	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
-		     IEEE80211_HW_RX_INCLUDES_FCS |
+	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_NOISE_DBM;
 
