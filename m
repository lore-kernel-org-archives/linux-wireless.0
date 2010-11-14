Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48075 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755857Ab0KNOUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:24 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 03/13] ath9k: remove bfs_keytype from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:03 +0100
Message-Id: <1289744413-20789-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-2-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/xmit.c  |    9 +++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 05fe1c1..7316459 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -106,7 +106,6 @@ enum buffer_type {
 #define bf_frmlen       	bf_state.bfs_frmlen
 #define bf_retries      	bf_state.bfs_retries
 #define bf_keyix                bf_state.bfs_keyix
-#define bf_keytype      	bf_state.bfs_keytype
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
@@ -224,7 +223,6 @@ struct ath_buf_state {
 	u8 bfs_paprd;
 	unsigned long bfs_paprd_timestamp;
 	u32 bfs_keyix;
-	enum ath9k_key_type bfs_keytype;
 	enum ath9k_internal_frame_type bfs_ftype;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c7097a5..6e0467c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -630,7 +630,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * TODO - this could be improved to be dependent on the rate.
 	 *      The hardware can keep up at lower rates, but not higher rates
 	 */
-	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR)
+	if (tx_info->control.hw_key)
 		ndelim += ATH_AGGR_ENCRYPTDELIM;
 
 	/*
@@ -1604,8 +1604,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 
 	bf->bf_flags = setup_tx_flags(skb);
 
-	bf->bf_keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
-	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
+	if (tx_info->control.hw_key) {
 		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
 		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
 	} else {
@@ -1642,6 +1641,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	struct ath_desc *ds;
 	struct ath_atx_tid *tid;
 	struct ath_hw *ah = sc->sc_ah;
+	enum ath9k_key_type keytype;
 	int frm_type;
 	__le16 fc;
 	u8 tidno;
@@ -1655,8 +1655,9 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	ds = bf->bf_desc;
 	ath9k_hw_set_desc_link(ah, ds, 0);
 
+	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
-			       bf->bf_keyix, bf->bf_keytype, bf->bf_flags);
+			       bf->bf_keyix, keytype, bf->bf_flags);
 
 	ath9k_hw_filltxdesc(ah, ds,
 			    skb->len,	/* segment length */
-- 
1.7.3.2

