Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:32904 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614AbYJPXL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:11:26 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] p54: put broadcast frames into the right queues
Date: Fri, 17 Oct 2008 01:15:38 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810170115.38317.chunkeey@web.de> (sfid-20081017_011130_675602_1B548E66)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

stlc45xx's specs finally brought some light what all the 4 extra queues for.
multicast & managment frames go now into their own queue.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-10-17 00:32:12.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-10-17 00:32:53.000000000 +0200
@@ -902,6 +902,62 @@ free:
 }
 EXPORT_SYMBOL_GPL(p54_read_eeprom);
 
+#ifndef WLAN_FC_GET_TYPE
+#define WLAN_FC_GET_TYPE(fc) (fc & IEEE80211_FCTL_FTYPE)
+#define WLAN_FC_GET_STYPE(fc) (fc & IEEE80211_FCTL_STYPE)
+#endif
+
+static int p54_tx_fill(struct ieee80211_hw *dev, struct sk_buff *skb,
+		struct ieee80211_tx_info *info, u8 *queue, size_t *extra_len,
+		u16 *flags, u16 *aid)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct p54_common *priv = dev->priv;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	int ret = 0;
+
+	if (unlikely(WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT)) {
+		switch (WLAN_FC_GET_STYPE(fc)) {
+		case IEEE80211_STYPE_BEACON:
+			*aid = 0;
+			*queue = 0;
+			*extra_len = IEEE80211_MAX_TIM_LEN;
+			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP;
+			return 0;
+		case IEEE80211_STYPE_PROBE_RESP:
+			*aid = 0;
+			*queue = 2;
+			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP |
+				 P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			return 0;
+		default:
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
+		if (is_multicast_ether_addr(hdr->addr1)) {
+			*aid = 0;
+			*queue = 3;
+			return 0;
+		}
+	case NL80211_IFTYPE_ADHOC:
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
@@ -909,22 +965,26 @@ static int p54_tx(struct ieee80211_hw *d
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
@@ -935,7 +995,7 @@ static int p54_tx(struct ieee80211_hw *d
 	if (padding)
 		hdr_flags |= P54_HDR_FLAG_DATA_ALIGN;
 	hdr->len = cpu_to_le16(len);
-	hdr->type = (info->flags & IEEE80211_TX_CTL_NO_ACK) ? 0 : cpu_to_le16(1);
+	hdr->type = cpu_to_le16(aid);
 	hdr->rts_tries = info->control.rates[0].count;
 
 	/*
@@ -1013,7 +1073,7 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->rts_rate_idx = 0;
 	txhdr->key_type = 0;
 	txhdr->key_len = 0;
-	txhdr->hw_queue = skb_get_queue_mapping(skb) + 4;
+	txhdr->hw_queue = queue;
 	txhdr->backlog = 32;
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
 	txhdr->tx_antenna = (info->antenna_sel_tx == 0) ?
@@ -1024,7 +1084,7 @@ static int p54_tx(struct ieee80211_hw *d
 		txhdr->align[0] = padding;
 
 	/* modifies skb->cb and with it info, so must be last! */
-	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len))) {
+	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len + tim_len))) {
 		skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
 		if (current_queue) {
 			current_queue->len--;
@@ -1341,7 +1401,7 @@ static int p54_config(struct ieee80211_h
 	mutex_lock(&priv->conf_mutex);
 	priv->rx_antenna = 2; /* automatic */
 	priv->output_power = conf->power_level << 2;
-	ret = p54_set_freq(dev, conf->channel->center_freq);
+	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
 	if (!ret)
 		ret = p54_set_edcf(dev);
 	mutex_unlock(&priv->conf_mutex);

