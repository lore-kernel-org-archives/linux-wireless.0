Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:46472 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756747AbXJJVcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 17:32:42 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8187: Fix more frag bit checking, rts duration calc
Date: Wed, 10 Oct 2007 17:28:59 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Message-Id: <20071010212859.12117.92418.stgit@magic.sourmilk.net> (sfid-20071010_223248_050804_F9BE5485)
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The wrong pointer is passed to ieee80211_get_morefrag. Fix this.

While we're at it, reorder things so they look better and the rts duration
calculation is done with the right length.

Thanks to Christoph Hellwig for finding the ieee80211_get_morefrag issue.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8187_dev.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 815d576..a675540 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -129,7 +129,8 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	struct rtl8187_tx_hdr *hdr;
 	struct rtl8187_tx_info *info;
 	struct urb *urb;
-	u32 tmp;
+	__le16 rts_dur = 0;
+	u32 flags;
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
@@ -137,24 +138,24 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		return 0;
 	}
 
-	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
-	tmp = skb->len - sizeof(*hdr);
-	tmp |= RTL8187_TX_FLAG_NO_ENCRYPT;
-	tmp |= control->rts_cts_rate << 19;
-	tmp |= control->tx_rate << 24;
-	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb))
-		tmp |= RTL8187_TX_FLAG_MORE_FRAG;
+	flags = skb->len;
+	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
+	flags |= control->rts_cts_rate << 19;
+	flags |= control->tx_rate << 24;
+	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
+		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
-		tmp |= RTL8187_TX_FLAG_RTS;
-		hdr->rts_duration =
-			ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
+		flags |= RTL8187_TX_FLAG_RTS;
+		rts_dur = ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
 	}
 	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		tmp |= RTL8187_TX_FLAG_CTS;
-	hdr->flags = cpu_to_le32(tmp);
+		flags |= RTL8187_TX_FLAG_CTS;
+
+	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
+	hdr->flags = cpu_to_le32(flags);
 	hdr->len = 0;
-	tmp = control->retry_limit << 8;
-	hdr->retry = cpu_to_le32(tmp);
+	hdr->rts_duration = rts_dur;
+	hdr->retry = cpu_to_le32(control->retry_limit << 8);
 
 	info = (struct rtl8187_tx_info *)skb->cb;
 	info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);

