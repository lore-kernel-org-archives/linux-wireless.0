Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54786 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 37/97] ath9k_hw: Move code which populates ds_data to ath9k_hw
Date: Wed, 14 Apr 2010 23:29:51 -0400
Message-Id: <1271302251-9075-38-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    4 +---
 drivers/net/wireless/ath/ath9k/mac.c    |    5 ++++-
 drivers/net/wireless/ath/ath9k/mac.h    |    3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c   |    4 ++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 22375a7..268b598 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -93,8 +93,6 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 		antenna = ((sc->beacon.ast_be_xmit / sc->nbcnvifs) & 1 ? 2 : 1);
 	}
 
-	ds->ds_data = bf->bf_buf_addr;
-
 	sband = &sc->sbands[common->hw->conf.channel->band];
 	rate = sband->bitrates[rateidx].hw_value;
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
@@ -109,7 +107,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
 	ath9k_hw_filltxdesc(ah, ds, roundup(skb->len, 4),
-			    true, true, ds);
+			    true, true, ds, bf->bf_buf_addr);
 
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index ae9d54c..0c9c378 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -220,10 +220,13 @@ EXPORT_SYMBOL(ath9k_hw_stoptxdma);
 
 void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
-			 bool lastSeg, const struct ath_desc *ds0)
+			 bool lastSeg, const struct ath_desc *ds0,
+			 dma_addr_t buf_addr)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
+	ads->ds_data = buf_addr;
+
 	if (firstSeg) {
 		ads->ds_ctl1 |= segLen | (lastSeg ? 0 : AR_TxMore);
 	} else if (lastSeg) {
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 126a403..f2f4ad2 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -693,7 +693,8 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
 bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q);
 void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
-			 bool lastSeg, const struct ath_desc *ds0);
+			 bool lastSeg, const struct ath_desc *ds0,
+			 dma_addr_t buf_addr);
 void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds);
 int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			struct ath_tx_status *ts);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 02df4cb..7219e29 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1660,7 +1660,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 
 	ds = bf->bf_desc;
 	ds->ds_link = 0;
-	ds->ds_data = bf->bf_buf_addr;
 
 	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
 			       bf->bf_keyix, bf->bf_keytype, bf->bf_flags);
@@ -1669,7 +1668,8 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			    skb->len,	/* segment length */
 			    true,	/* first segment */
 			    true,	/* last segment */
-			    ds);	/* first descriptor */
+			    ds,		/* first descriptor */
+			    bf->bf_buf_addr);
 
 	spin_lock_bh(&txctl->txq->axq_lock);
 
-- 
1.6.3.3

