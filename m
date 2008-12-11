Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp7-g19.free.fr ([212.27.42.64]:38039 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758599AbYLKV7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 16:59:03 -0500
Message-ID: <49418D23.8060905@free.fr> (sfid-20081211_225920_318663_0EE458F5)
Date: Thu, 11 Dec 2008 22:58:59 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k : Fix correct padding
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Padding the 802.11 header to a multiple of 4 bytes needs to be done only
for DATA frames. This fixes a bug where 2 bytes were missing in monitor
mode for ACK frames.

Ref: http://bugzilla.kernel.org/show_bug.cgi?id=12101 :
Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
  drivers/net/wireless/ath5k/base.c |   49
+++++++++++++++++++++++-------------
  1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index bfb0c49..2318b1c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1668,6 +1668,7 @@ ath5k_tasklet_rx(unsigned long data)
  	int ret;
  	int hdrlen;
  	int pad;
+	struct ieee80211_hdr * hdr;

  	spin_lock(&sc->rxbuflock);
  	if (list_empty(&sc->rxbuf)) {
@@ -1754,14 +1755,19 @@ accept:

  		/*
  		 * the hardware adds a padding to 4 byte boundaries between
-		 * the header and the payload data if the header length is
-		 * not multiples of 4 - remove it
+		 * the header and the payload data if the header length is not
+		 * multiple of 4 - remove it. This only affect data frames.
  		 */
-		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		if (hdrlen & 3) {
-			pad = hdrlen % 4;
-			memmove(skb->data + pad, skb->data, hdrlen);
-			skb_pull(skb, pad);
+
+		hdr = (struct ieee80211_hdr *) skb;
+		if ((skb->len >= 2) && ieee80211_is_data(hdr->frame_control)) {
+
+			hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+			if (hdrlen & 3) {
+				pad = hdrlen % 4;
+				memmove(skb->data + pad, skb->data, hdrlen);
+				skb_pull(skb, pad);
+			}
  		}

  		/*
@@ -2623,6 +2629,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
  	unsigned long flags;
  	int hdrlen;
  	int pad;
+	const struct ieee80211_hdr * hdr = (const struct ieee80211_hdr *)skb;

  	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);

@@ -2630,19 +2637,25 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff
*skb)
  		ATH5K_DBG(sc, ATH5K_DEBUG_XMIT, "tx in monitor (scan?)\n");

  	/*
-	 * the hardware expects the header padded to 4 byte boundaries
-	 * if this is not the case we add the padding after the header
+	 * the hardware expects the header padded to 4 byte boundaries for
+	 * data frames, if this is not the case we add the padding after the
+	 * header
  	 */
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	if (hdrlen & 3) {
-		pad = hdrlen % 4;
-		if (skb_headroom(skb) < pad) {
-			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
-				" headroom to pad %d\n", hdrlen, pad);
-			return -1;
+
+	if ((skb->len >= 2) && ieee80211_is_data(hdr->frame_control)) {
+
+		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+		if (hdrlen & 3) {
+			pad = hdrlen % 4;
+			if (skb_headroom(skb) < pad) {
+				ATH5K_ERR(sc,
+					  "tx hdrlen not %%4: %d not enough"
+					  " headroom to pad %d\n", hdrlen, pad);
+				return -1;
+			}
+			skb_push(skb, pad);
+			memmove(skb->data, skb->data+pad, hdrlen);
  		}
-		skb_push(skb, pad);
-		memmove(skb->data, skb->data+pad, hdrlen);
  	}

  	spin_lock_irqsave(&sc->txbuflock, flags);
-- 1.5.6.5

