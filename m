Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:34480 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1A3TK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:10:57 -0500
Message-ID: <4D45B7B8.1060607@davizone.at>
Date: Sun, 30 Jan 2011 20:10:48 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 02/18] wl1251: fix 4-byte TX buffer alignment
References: <4D45A591.6040600@davizone.at>
In-Reply-To: <4D45A591.6040600@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements TX buffer alignment for cloned or too small skb by
copying and replacing the original skb.
Recent changes in wireless-testing seems to make this really necessary.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/tx.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl1251/tx.c b/drivers/net/wireless/wl1251/tx.c
index 10112de..28121c5 100644
--- a/drivers/net/wireless/wl1251/tx.c
+++ b/drivers/net/wireless/wl1251/tx.c
@@ -213,16 +213,30 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
 		wl1251_debug(DEBUG_TX, "skb offset %d", offset);
 
 		/* check whether the current skb can be used */
-		if (!skb_cloned(skb) && (skb_tailroom(skb) >= offset)) {
-			unsigned char *src = skb->data;
+		if (skb_cloned(skb) || (skb_tailroom(skb) < offset)) {
+			struct sk_buff *newskb = skb_copy_expand(skb, 0, 3,
+								 GFP_KERNEL);
+
+			if (unlikely(newskb == NULL)) {
+				wl1251_error("Can't allocate skb!");
+				return -EINVAL;
+			}
+
+			tx_hdr = (struct tx_double_buffer_desc *) newskb->data;
+
+			dev_kfree_skb_any(skb);
+			wl->tx_frames[tx_hdr->id] = skb = newskb;
 
-			/* align the buffer on a 4-byte boundary */
+			offset = (4 - (long)skb->data) & 0x03;
+			wl1251_debug(DEBUG_TX, "new skb offset %d", offset);
+		}
+
+		/* align the buffer on a 4-byte boundary */
+		if (offset) {
+			unsigned char *src = skb->data;
 			skb_reserve(skb, offset);
 			memmove(skb->data, src, skb->len);
 			tx_hdr = (struct tx_double_buffer_desc *) skb->data;
-		} else {
-			wl1251_info("No handler, fixme!");
-			return -EINVAL;
 		}
 	}
 
-- 
1.7.0.4


