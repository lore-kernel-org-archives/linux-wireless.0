Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.18]:18842 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933105AbZKXOt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 09:49:57 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: lrodriguez@atheros.com
Cc: jmalinen@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 2/2] ath9k: Proper padding/unpadding for the TX/RX path.
Date: Tue, 24 Nov 2009 15:49:18 +0100
Message-Id: <1259074158-2101-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1259074158-2101-1-git-send-email-benoit.papillault@free.fr>
References: <1259074158-2101-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Software padding is done on the TX path and software unpadding is done on the
RX path. This patch corrects the position where the padding occurs. A specific
function computes the pad position and this function is used in the TX and RX
path. This patch has been tested by generating every possible 802.11 frames
with every possible frame_control field and a varying length. This patch is
useful for analyzing non standard 802.11 frames going over the air

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath9k/common.c |   24 +++++++++++++++---------
 drivers/net/wireless/ath/ath9k/common.h |    2 ++
 drivers/net/wireless/ath/ath9k/main.c   |   14 ++++++--------
 drivers/net/wireless/ath/ath9k/xmit.c   |    9 ++++++++-
 4 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 4a13632..d363bb3 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -238,16 +238,8 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 	/* see if any padding is done by the hw and remove it */
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padpos = 24;
 	fc = hdr->frame_control;
-	if ((fc & cpu_to_le16(IEEE80211_FCTL_FROMDS|IEEE80211_FCTL_TODS)) ==
-	    cpu_to_le16(IEEE80211_FCTL_FROMDS|IEEE80211_FCTL_TODS)) {
-	  padpos += 6; /* ETH_ALEN */
-	}
-	if ((fc & cpu_to_le16(IEEE80211_STYPE_QOS_DATA|IEEE80211_FCTL_FTYPE)) ==
-	    cpu_to_le16(IEEE80211_STYPE_QOS_DATA|IEEE80211_FTYPE_DATA)) {
-	  padpos += 2;
-	}
+	padpos = ath9k_cmn_padpos(hdr->frame_control);
 
 	/* The MAC header is padded to have 32-bit boundary if the
 	 * packet payload is non-zero. The general calculation for
@@ -282,6 +274,20 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 }
 EXPORT_SYMBOL(ath9k_cmn_rx_skb_postprocess);
 
+int ath9k_cmn_padpos(__le16 frame_control)
+{
+	int padpos = 24;
+	if (ieee80211_has_a4(frame_control)) {
+		padpos += ETH_ALEN;
+	}
+	if (ieee80211_is_data_qos(frame_control)) {
+		padpos += IEEE80211_QOS_CTL_LEN;
+	}
+
+	return padpos;
+}
+EXPORT_SYMBOL(ath9k_cmn_padpos);
+
 static int __init ath9k_cmn_init(void)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 4e11760..b188fc3 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -122,3 +122,5 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 				  struct ath_rx_status *rx_stats,
 				  struct ieee80211_rx_status *rxs,
 				  bool decrypt_error);
+
+int ath9k_cmn_padpos(__le16 frame_control);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cbf5d2a..df2e2ae 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2394,7 +2394,8 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_tx_control txctl;
-	int hdrlen, padsize;
+	int padpos, padsize;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
 	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
 		ath_print(common, ATH_DBG_XMIT,
@@ -2404,7 +2405,6 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	}
 
 	if (sc->ps_enabled) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		/*
 		 * mac80211 does not set PM field for normal data frames, so we
 		 * need to update that based on the current PS mode.
@@ -2424,7 +2424,6 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		 * power save mode. Need to wake up hardware for the TX to be
 		 * completed and if needed, also for RX of buffered frames.
 		 */
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		ath9k_ps_wakeup(sc);
 		ath9k_hw_setrxabort(sc->sc_ah, 0);
 		if (ieee80211_is_pspoll(hdr->frame_control)) {
@@ -2452,7 +2451,6 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	 * BSSes.
 	 */
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
@@ -2460,13 +2458,13 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	}
 
 	/* Add the padding after the header if this is not already done */
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	if (hdrlen & 3) {
-		padsize = hdrlen % 4;
+	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padsize = padpos & 3;
+	if (padsize && skb->len>padpos) {
 		if (skb_headroom(skb) < padsize)
 			return -1;
 		skb_push(skb, padsize);
-		memmove(skb->data, skb->data + padsize, hdrlen);
+		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
 	/* Check if a tx queue is available */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 745d919..046986e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1554,6 +1554,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int hdrlen;
 	__le16 fc;
+	int padpos, padsize;
 
 	tx_info->pad[0] = 0;
 	switch (txctl->frame_type) {
@@ -1572,7 +1573,13 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	ATH_TXBUF_RESET(bf);
 
 	bf->aphy = aphy;
-	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
+	bf->bf_frmlen = skb->len + FCS_LEN;
+	/* Remove the padding size from bf_frmlen, if any */
+	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padsize = padpos & 3;
+	if (padsize && skb->len>padpos+padsize) {
+		bf->bf_frmlen -= padsize;
+	}
 
 	if (conf_is_ht(&hw->conf) && !is_pae(skb))
 		bf->bf_state.bf_type |= BUF_HT;
-- 
1.6.3.3



