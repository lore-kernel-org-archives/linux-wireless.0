Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from LNeuilly-152-21-11-6.w193-253.abo.wanadoo.fr ([193.253.42.6]:34517
	"EHLO luceor-laptop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752494AbYLLOw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 09:52:28 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: [PATCH] ath5k: fix 802.11 header padding on RX, unpadding on TX
Date: Fri, 12 Dec 2008 15:29:58 +0100
Message-Id: <1229092198-21136-1-git-send-email-benoit.papillault@free.fr> (sfid-20081212_155232_013741_EDC142B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benoit PAPILLAULT <benoit.papillault@free.fr>

Padding the 802.11 header to a multiple of 4 bytes needs to be done only for
frames with a body. This fixes a bug where 2 bytes were missing in monitor
mode for ACK frames. Inspired by a patch from Jouni Malinen on ath9k.

Ref: http://bugzilla.kernel.org/show_bug.cgi?id=12101 :
Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath5k/base.c |   38 ++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index bfb0c49..9d2c597 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1667,7 +1667,7 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_desc *ds;
 	int ret;
 	int hdrlen;
-	int pad;
+	int padsize;
 
 	spin_lock(&sc->rxbuflock);
 	if (list_empty(&sc->rxbuf)) {
@@ -1752,16 +1752,19 @@ accept:
 
 		skb_put(skb, rs.rs_datalen);
 
-		/*
-		 * the hardware adds a padding to 4 byte boundaries between
-		 * the header and the payload data if the header length is
-		 * not multiples of 4 - remove it
-		 */
+		/* The MAC header is padded to have 32-bit boundary if the
+		 * packet payload is non-zero. The general calculation for
+		 * padsize would take into account odd header lengths:
+		 * padsize = (4 - hdrlen % 4) % 4; However, since only
+		 * even-length headers are used, padding can only be 0 or 2
+		 * bytes and we can optimize this a bit. In addition, we must
+		 * not try to remove padding from short control frames that do
+		 * not have payload. */
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		if (hdrlen & 3) {
-			pad = hdrlen % 4;
-			memmove(skb->data + pad, skb->data, hdrlen);
-			skb_pull(skb, pad);
+		padsize = hdrlen & 3;
+		if (padsize && hdrlen >= 24) {
+			memmove(skb->data + padsize, skb->data, hdrlen);
+			skb_pull(skb, padsize);
 		}
 
 		/*
@@ -2622,7 +2625,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ath5k_buf *bf;
 	unsigned long flags;
 	int hdrlen;
-	int pad;
+	int padsize;
 
 	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
 
@@ -2634,15 +2637,16 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * if this is not the case we add the padding after the header
 	 */
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	if (hdrlen & 3) {
-		pad = hdrlen % 4;
-		if (skb_headroom(skb) < pad) {
+	padsize = hdrlen & 3;
+	if (padsize && hdrlen >= 24) {
+
+		if (skb_headroom(skb) < padsize) {
 			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
-				" headroom to pad %d\n", hdrlen, pad);
+				  " headroom to pad %d\n", hdrlen, padsize);
 			return -1;
 		}
-		skb_push(skb, pad);
-		memmove(skb->data, skb->data+pad, hdrlen);
+		skb_push(skb, padsize);
+		memmove(skb->data, skb->data+padsize, hdrlen);
 	}
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
-- 
1.5.6.5

