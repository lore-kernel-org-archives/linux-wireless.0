Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58753 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915Ab1INTYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 12/12] ath9k: do not insert padding into tx buffers on AR9380+
Date: Wed, 14 Sep 2011 21:24:27 +0200
Message-Id: <1316028267-34187-12-git-send-email-nbd@openwrt.org> (sfid-20110914_212441_562019_9DB60F26)
In-Reply-To: <1316028267-34187-11-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
 <1316028267-34187-7-git-send-email-nbd@openwrt.org>
 <1316028267-34187-8-git-send-email-nbd@openwrt.org>
 <1316028267-34187-9-git-send-email-nbd@openwrt.org>
 <1316028267-34187-10-git-send-email-nbd@openwrt.org>
 <1316028267-34187-11-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new EDMA descriptor format, a single descriptor can contain up
to four buffer pointers. By splitting the buffer into two parts, we can
let the hardware add the padding internally instead of using memmove on
the skb data.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   56 +++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a0cd51f..2c6aefa 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1017,6 +1017,8 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 	while (bf) {
 		struct sk_buff *skb = bf->bf_mpdu;
 		struct ath_frame_info *fi = get_frame_info(skb);
+		struct ieee80211_hdr *hdr;
+		int padpos, padsize;
 
 		info.type = get_hw_packet_type(skb);
 		if (bf->bf_next)
@@ -1024,8 +1026,20 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 		else
 			info.link = 0;
 
-		info.buf_addr[0] = bf->bf_buf_addr;
-		info.buf_len[0] = skb->len;
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+			hdr = (struct ieee80211_hdr *)skb->data;
+			padpos = ath9k_cmn_padpos(hdr->frame_control);
+			padsize = padpos & 3;
+
+			info.buf_addr[0] = bf->bf_buf_addr;
+			info.buf_len[0] = padpos + padsize;
+			info.buf_addr[1] = info.buf_addr[0] + padpos;
+			info.buf_len[1] = skb->len - padpos;
+		} else {
+			info.buf_addr[0] = bf->bf_buf_addr;
+			info.buf_len[0] = skb->len;
+		}
+
 		info.pkt_len = fi->framelen;
 		info.keyix = fi->keyix;
 		info.keytype = fi->keytype;
@@ -1878,15 +1892,17 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
 	}
 
-	/* Add the padding after the header if this is not already done */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
-	padsize = padpos & 3;
-	if (padsize && skb->len > padpos) {
-		if (skb_headroom(skb) < padsize)
-			return -ENOMEM;
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)) {
+		/* Add the padding after the header if this is not already done */
+		padpos = ath9k_cmn_padpos(hdr->frame_control);
+		padsize = padpos & 3;
+		if (padsize && skb->len > padpos) {
+			if (skb_headroom(skb) < padsize)
+				return -ENOMEM;
 
-		skb_push(skb, padsize);
-		memmove(skb->data, skb->data + padsize, padpos);
+			skb_push(skb, padsize);
+			memmove(skb->data, skb->data + padsize, padpos);
+		}
 	}
 
 	if ((vif && vif->type != NL80211_IFTYPE_AP &&
@@ -1936,15 +1952,17 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
-	padsize = padpos & 3;
-	if (padsize && skb->len>padpos+padsize) {
-		/*
-		 * Remove MAC header padding before giving the frame back to
-		 * mac80211.
-		 */
-		memmove(skb->data + padsize, skb->data, padpos);
-		skb_pull(skb, padsize);
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)) {
+		padpos = ath9k_cmn_padpos(hdr->frame_control);
+		padsize = padpos & 3;
+		if (padsize && skb->len>padpos+padsize) {
+			/*
+			 * Remove MAC header padding before giving the frame back to
+			 * mac80211.
+			 */
+			memmove(skb->data + padsize, skb->data, padpos);
+			skb_pull(skb, padsize);
+		}
 	}
 
 	if (sc->ps_flags & PS_WAIT_FOR_TX_ACK) {
-- 
1.7.3.2

