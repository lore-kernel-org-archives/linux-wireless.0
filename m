Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64825 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbaA2TIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:08:24 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0Lb90f-1VOIJT1sin-00kfe5 for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:08:23 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 10/13] ath9k: move ath9k_rx_skb_postprocess to common.c
Date: Wed, 29 Jan 2014 20:07:01 +0100
Message-Id: <1391022424-21087-9-git-send-email-linux@rempel-privat.de> (sfid-20140129_200826_719193_B428B03C)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and rename it to ath9k_cmn_rx_skb_postprocess. We will use it
on ath9k_htc.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common.c | 52 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |  5 +++
 drivers/net/wireless/ath/ath9k/recv.c   | 55 ++-------------------------------
 3 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 5c0d949..c6dd7f1 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -115,6 +115,58 @@ bool ath9k_cmn_rx_accept(struct ath_common *common,
 }
 EXPORT_SYMBOL(ath9k_cmn_rx_accept);
 
+void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
+				  struct sk_buff *skb,
+				  struct ath_rx_status *rx_stats,
+				  struct ieee80211_rx_status *rxs,
+				  bool decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_hdr *hdr;
+	int hdrlen, padpos, padsize;
+	u8 keyix;
+	__le16 fc;
+
+	/* see if any padding is done by the hw and remove it */
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	fc = hdr->frame_control;
+	padpos = ieee80211_hdrlen(fc);
+
+	/* The MAC header is padded to have 32-bit boundary if the
+	 * packet payload is non-zero. The general calculation for
+	 * padsize would take into account odd header lengths:
+	 * padsize = (4 - padpos % 4) % 4; However, since only
+	 * even-length headers are used, padding can only be 0 or 2
+	 * bytes and we can optimize this a bit. In addition, we must
+	 * not try to remove padding from short control frames that do
+	 * not have payload. */
+	padsize = padpos & 3;
+	if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
+		memmove(skb->data + padsize, skb->data, padpos);
+		skb_pull(skb, padsize);
+	}
+
+	keyix = rx_stats->rs_keyix;
+
+	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
+	    ieee80211_has_protected(fc)) {
+		rxs->flag |= RX_FLAG_DECRYPTED;
+	} else if (ieee80211_has_protected(fc)
+		   && !decrypt_error && skb->len >= hdrlen + 4) {
+		keyix = skb->data[hdrlen + 3] >> 6;
+
+		if (test_bit(keyix, common->keymap))
+			rxs->flag |= RX_FLAG_DECRYPTED;
+	}
+	if (ah->sw_mgmt_crypto &&
+	    (rxs->flag & RX_FLAG_DECRYPTED) &&
+	    ieee80211_is_mgmt(fc))
+		/* Use software decrypt for management frames. */
+		rxs->flag &= ~RX_FLAG_DECRYPTED;
+}
+EXPORT_SYMBOL(ath9k_cmn_rx_skb_postprocess);
+
 int ath9k_cmn_process_rate(struct ath_common *common,
 			   struct ieee80211_hw *hw,
 			   struct ath_rx_status *rx_stats,
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index c59d3f5..38b5609 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -48,6 +48,11 @@ bool ath9k_cmn_rx_accept(struct ath_common *common,
 			 struct ath_rx_status *rx_stats,
 			 bool *decrypt_error,
 			 unsigned int rxfilter);
+void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
+				  struct sk_buff *skb,
+				  struct ath_rx_status *rx_stats,
+				  struct ieee80211_rx_status *rxs,
+				  bool decrypt_error);
 int ath9k_cmn_process_rate(struct ath_common *common,
 			   struct ieee80211_hw *hw,
 			   struct ath_rx_status *rx_stats,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4dedbc2..076dae1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -901,57 +901,6 @@ exit:
 	return ret;
 }
 
-static void ath9k_rx_skb_postprocess(struct ath_common *common,
-				     struct sk_buff *skb,
-				     struct ath_rx_status *rx_stats,
-				     struct ieee80211_rx_status *rxs,
-				     bool decrypt_error)
-{
-	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
-	int hdrlen, padpos, padsize;
-	u8 keyix;
-	__le16 fc;
-
-	/* see if any padding is done by the hw and remove it */
-	hdr = (struct ieee80211_hdr *) skb->data;
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	fc = hdr->frame_control;
-	padpos = ieee80211_hdrlen(fc);
-
-	/* The MAC header is padded to have 32-bit boundary if the
-	 * packet payload is non-zero. The general calculation for
-	 * padsize would take into account odd header lengths:
-	 * padsize = (4 - padpos % 4) % 4; However, since only
-	 * even-length headers are used, padding can only be 0 or 2
-	 * bytes and we can optimize this a bit. In addition, we must
-	 * not try to remove padding from short control frames that do
-	 * not have payload. */
-	padsize = padpos & 3;
-	if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
-		memmove(skb->data + padsize, skb->data, padpos);
-		skb_pull(skb, padsize);
-	}
-
-	keyix = rx_stats->rs_keyix;
-
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
-	    ieee80211_has_protected(fc)) {
-		rxs->flag |= RX_FLAG_DECRYPTED;
-	} else if (ieee80211_has_protected(fc)
-		   && !decrypt_error && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
-
-		if (test_bit(keyix, common->keymap))
-			rxs->flag |= RX_FLAG_DECRYPTED;
-	}
-	if (ah->sw_mgmt_crypto &&
-	    (rxs->flag & RX_FLAG_DECRYPTED) &&
-	    ieee80211_is_mgmt(fc))
-		/* Use software decrypt for management frames. */
-		rxs->flag &= ~RX_FLAG_DECRYPTED;
-}
-
 /*
  * Run the LNA combining algorithm only in these cases:
  *
@@ -1101,8 +1050,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			skb_pull(skb, ah->caps.rx_status_len);
 
 		if (!rs.rs_more)
-			ath9k_rx_skb_postprocess(common, hdr_skb, &rs,
-						 rxs, decrypt_error);
+			ath9k_cmn_rx_skb_postprocess(common, hdr_skb, &rs,
+						     rxs, decrypt_error);
 
 		if (rs.rs_more) {
 			RX_STAT_INC(rx_frags);
-- 
1.8.5.3

