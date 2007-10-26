Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3983 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbXJZVH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8187: Fix more frag bit checking, rts duration calc
Date: Fri, 26 Oct 2007 17:04:38 -0400
Message-Id: <11934326831563-git-send-email-linville@tuxdriver.com> (sfid-20071026_220733_334202_824452FD)
In-Reply-To: <11934326831029-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
 <11934326812028-git-send-email-linville@tuxdriver.com>
 <11934326813245-git-send-email-linville@tuxdriver.com>
 <11934326823646-git-send-email-linville@tuxdriver.com>
 <11934326821301-git-send-email-linville@tuxdriver.com>
 <11934326823109-git-send-email-linville@tuxdriver.com>
 <11934326821662-git-send-email-linville@tuxdriver.com>
 <11934326831029-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The wrong pointer is passed to ieee80211_get_morefrag. Fix this.

While we're at it, reorder things so they look better and the rts duration
calculation is done with the right length.

Thanks to Christoph Hellwig for finding the ieee80211_get_morefrag issue.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl8187_dev.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index e61c6d5..66704b8 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -78,7 +78,8 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	struct rtl8187_tx_hdr *hdr;
 	struct rtl8187_tx_info *info;
 	struct urb *urb;
-	u32 tmp;
+	__le16 rts_dur = 0;
+	u32 flags;
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
@@ -86,24 +87,24 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
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
-			ieee80211_rts_duration(dev, skb->len, control);
+		flags |= RTL8187_TX_FLAG_RTS;
+		rts_dur = ieee80211_rts_duration(dev, skb->len, control);
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
-- 
1.5.2.4

