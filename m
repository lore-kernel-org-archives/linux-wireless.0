Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:50439 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYKXUYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 15:24:17 -0500
To: "Stefan Steuerwald" <salsasepp@googlemail.com>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
From: Christian Lamparter <chunkeey@web.de>
Date: Mon, 24 Nov 2008 21:24:16 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_w1wKJbXDU2BNxvk"
Message-Id: <200811242124.16358.chunkeey@web.de> (sfid-20081124_212422_231398_990A91B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_w1wKJbXDU2BNxvk
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 24 November 2008 17:51:45 Stefan Steuerwald wrote:
> Thanks again Christian and Johannes,
> 
> from a first quick check
> - set-and-clear.diff doesn't seem to change anything
> - both patches together freeze my system
> 
> I don't have a serial console on this embedded thing, so I don't know
> its death poem yet. Let me set up my debug environment properly and
> report back to you.

This might not be necessary.

Try this updated patch. And let us know if we no do the right thing.

Regards,
	Chr

--Boundary-00=_w1wKJbXDU2BNxvk
Content-Type: text/x-diff;
  charset="utf-8";
  name="p54-sta-flags-v2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-sta-flags-v2.diff"

diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-24 13:07:09.053832187 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-24 21:05:42.590287518 +0100
@@ -688,7 +688,8 @@ static void p54_rx_frame_sent(struct iee
 			}
 		}
 
-		priv->tx_stats[entry_data->hw_queue].len--;
+		if (priv->tx_stats[entry_data->hw_queue].len > 0)
+			priv->tx_stats[entry_data->hw_queue].len--;
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
 		     (!payload->status))
 			info->flags |= IEEE80211_TX_STAT_ACK;
@@ -1067,9 +1068,15 @@ static int p54_tx_fill(struct ieee80211_
 			*queue = 3;
 			return 0;
 		}
-		if (info->control.sta)
+		if (info->control.sta) {
+			if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
+				ret = p54_sta_unlock(dev, info->control.sta->addr);
+				if (ret)
+					return ret;
+				*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			}
 			*aid = info->control.sta->aid;
-		else
+		} else
 			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 	}
 	return ret;
@@ -1083,7 +1090,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
 	size_t padding, len, tim_len = 0;
-	int i, j, ridx;
+	int i, j, ridx, ret;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue;
 	u8 cts_rate = 0x20;
@@ -1093,7 +1100,10 @@ static int p54_tx(struct ieee80211_hw *d
 
 	queue = skb_get_queue_mapping(skb);
 
-	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
+	ret = p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid);
+	if (ret < 0)
+		return NETDEV_TX_BUSY;
+	if (ret) {
 		current_queue = &priv->tx_stats[queue];
 		if (unlikely(current_queue->len > current_queue->limit))
 			return NETDEV_TX_BUSY;
@@ -1106,17 +1116,6 @@ static int p54_tx(struct ieee80211_hw *d
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
-	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
-		if (info->control.sta)
-			if (p54_sta_unlock(dev, info->control.sta->addr)) {
-				if (current_queue) {
-					current_queue->len--;
-					current_queue->count--;
-				}
-				return NETDEV_TX_BUSY;
-			}
-	}
-
 	txhdr = (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 

--Boundary-00=_w1wKJbXDU2BNxvk--
