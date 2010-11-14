Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48060 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755751Ab0KNOUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:22 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 05/13] ath9k: remove bfs_keyix from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:05 +0100
Message-Id: <1289744413-20789-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-4-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/xmit.c  |   14 ++++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9106d41..30c18e8 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -105,7 +105,6 @@ enum buffer_type {
 #define bf_al           	bf_state.bfs_al
 #define bf_frmlen       	bf_state.bfs_frmlen
 #define bf_retries      	bf_state.bfs_retries
-#define bf_keyix                bf_state.bfs_keyix
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
@@ -221,7 +220,6 @@ struct ath_buf_state {
 	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
-	u32 bfs_keyix;
 	enum ath9k_internal_frame_type bfs_ftype;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9f3d23a..176d88c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1604,12 +1604,8 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 
 	bf->bf_flags = setup_tx_flags(skb);
 
-	if (tx_info->control.hw_key) {
+	if (tx_info->control.hw_key)
 		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
-		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
-	} else {
-		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
-	}
 
 	bf->bf_mpdu = skb;
 
@@ -1642,6 +1638,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	struct ath_atx_tid *tid;
 	struct ath_hw *ah = sc->sc_ah;
 	enum ath9k_key_type keytype;
+	u32 keyix;
 	int frm_type;
 	__le16 fc;
 	u8 tidno;
@@ -1656,8 +1653,13 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	ath9k_hw_set_desc_link(ah, ds, 0);
 
 	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
+	if (tx_info->control.hw_key)
+		keyix = tx_info->control.hw_key->hw_key_idx;
+	else
+		keyix = ATH9K_TXKEYIX_INVALID;
+
 	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
-			       bf->bf_keyix, keytype, bf->bf_flags);
+			       keyix, keytype, bf->bf_flags);
 
 	ath9k_hw_filltxdesc(ah, ds,
 			    skb->len,	/* segment length */
-- 
1.7.3.2

