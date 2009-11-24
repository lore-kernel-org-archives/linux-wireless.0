Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2e.orange.fr ([80.12.242.113]:22997 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126AbZKXOt1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 09:49:27 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: lrodriguez@atheros.com
Cc: jmalinen@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: This patch fix RX unpadding for any received frame.
Date: Tue, 24 Nov 2009 15:49:17 +0100
Message-Id: <1259074158-2101-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>

It has been tested with a 802.11 frame generator and by checking the FCS field
of each received frame with the value reported by the Atheros hardware. This
patch is useful if you are trying to analyze non standard 802.11 frame going
over the air.

Signed-off-by: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>
---
 drivers/net/wireless/ath/ath9k/common.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 2f1e161..4a13632 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -231,26 +231,35 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 {
 	struct ath_hw *ah = common->ah;
 	struct ieee80211_hdr *hdr;
-	int hdrlen, padsize;
+	int hdrlen, padpos, padsize;
 	u8 keyix;
 	__le16 fc;
 
 	/* see if any padding is done by the hw and remove it */
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	padpos = 24;
 	fc = hdr->frame_control;
+	if ((fc & cpu_to_le16(IEEE80211_FCTL_FROMDS|IEEE80211_FCTL_TODS)) ==
+	    cpu_to_le16(IEEE80211_FCTL_FROMDS|IEEE80211_FCTL_TODS)) {
+	  padpos += 6; /* ETH_ALEN */
+	}
+	if ((fc & cpu_to_le16(IEEE80211_STYPE_QOS_DATA|IEEE80211_FCTL_FTYPE)) ==
+	    cpu_to_le16(IEEE80211_STYPE_QOS_DATA|IEEE80211_FTYPE_DATA)) {
+	  padpos += 2;
+	}
 
 	/* The MAC header is padded to have 32-bit boundary if the
 	 * packet payload is non-zero. The general calculation for
 	 * padsize would take into account odd header lengths:
-	 * padsize = (4 - hdrlen % 4) % 4; However, since only
+	 * padsize = (4 - padpos % 4) % 4; However, since only
 	 * even-length headers are used, padding can only be 0 or 2
 	 * bytes and we can optimize this a bit. In addition, we must
 	 * not try to remove padding from short control frames that do
 	 * not have payload. */
-	padsize = hdrlen & 3;
-	if (padsize && hdrlen >= 24) {
-		memmove(skb->data + padsize, skb->data, hdrlen);
+	padsize = padpos & 3;
+	if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
+		memmove(skb->data + padsize, skb->data, padpos);
 		skb_pull(skb, padsize);
 	}
 
-- 
1.6.3.3



