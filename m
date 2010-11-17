Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51638 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062Ab0KQVxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:53:05 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Wed, 17 Nov 2010 22:52:53 +0100
Message-Id: <1290030773-2486-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crap/0002-ath9k-Add-pktlog-support.patch |   34 +++++++++++++++--------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/crap/0002-ath9k-Add-pktlog-support.patch b/crap/0002-ath9k-Add-pktlog-support.patch
index 89b0074..775be74 100644
--- a/crap/0002-ath9k-Add-pktlog-support.patch
+++ b/crap/0002-ath9k-Add-pktlog-support.patch
@@ -105,7 +105,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /*
   * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
-@@ -559,6 +560,7 @@ struct ath_ant_comb {
+@@ -544,6 +545,7 @@ struct ath_ant_comb {
  #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
  #define SC_OP_BT_SCAN		     BIT(13)
  #define SC_OP_ANI_RUN		     BIT(14)
@@ -113,7 +113,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /* Powersave flags */
  #define PS_WAIT_FOR_BEACON        BIT(0)
-@@ -635,6 +637,10 @@ struct ath_softc {
+@@ -621,6 +623,10 @@ struct ath_softc {
  #ifdef CONFIG_ATH9K_DEBUGFS
  	struct ath9k_debug debug;
  #endif
@@ -161,7 +161,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  static inline void ath9k_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2140,7 +2140,7 @@ void ath9k_hw_setrxfilter(struct ath_hw
+@@ -2143,7 +2143,7 @@ void ath9k_hw_setrxfilter(struct ath_hw
  		phybits |= AR_PHY_ERR_RADAR;
  	if (bits & ATH9K_RX_FILTER_PHYERR)
  		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
@@ -172,7 +172,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		REG_WRITE(ah, AR_RXCFG,
 --- a/drivers/net/wireless/ath/ath9k/hw.h
 +++ b/drivers/net/wireless/ath/ath9k/hw.h
-@@ -580,7 +580,7 @@ struct ath_hw_ops {
+@@ -616,7 +616,7 @@ struct ath_hw_ops {
  			    const void *ds0, dma_addr_t buf_addr,
  			    unsigned int qcu);
  	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
@@ -181,10 +181,10 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
  			      u32 pktLen, enum ath9k_pkt_type type,
  			      u32 txPower, u32 keyIx,
-@@ -804,6 +804,8 @@ struct ath_hw {
- 	 * this register when in sleep states.
- 	 */
- 	u32 WARegVal;
+@@ -845,6 +845,8 @@ struct ath_hw {
+ 
+ 	/* Enterprise mode cap */
+ 	u32 ent_mode;
 +
 +	bool is_pkt_logging;
  };
@@ -1298,7 +1298,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  }
  
  static const
-@@ -1374,7 +1381,8 @@ static void ath_tx_status(void *priv, st
+@@ -1358,7 +1365,8 @@ static void ath_tx_status(void *priv, st
  		tx_status = 1;
  
  	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
@@ -1346,7 +1346,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
 --- a/drivers/net/wireless/ath/ath9k/xmit.c
 +++ b/drivers/net/wireless/ath/ath9k/xmit.c
-@@ -436,6 +436,8 @@ static void ath_tx_complete_aggr(struct
+@@ -476,6 +476,8 @@ static void ath_tx_complete_aggr(struct
  			list_move_tail(&bf->list, &bf_head);
  		}
  
@@ -1355,7 +1355,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (!txpending || (tid->state & AGGR_CLEANUP)) {
  			/*
  			 * complete the acked-ones/xretried ones; update
-@@ -2069,7 +2071,7 @@ static void ath_tx_processq(struct ath_s
+@@ -2004,7 +2006,7 @@ static void ath_tx_processq(struct ath_s
  		ds = lastbf->bf_desc;
  
  		memset(&ts, 0, sizeof(ts));
@@ -1364,13 +1364,14 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS) {
  			spin_unlock_bh(&txq->axq_lock);
  			break;
-@@ -2108,10 +2110,14 @@ static void ath_tx_processq(struct ath_s
+@@ -2043,11 +2045,15 @@ static void ath_tx_processq(struct ath_s
  
  		qnum = skb_get_queue_mapping(bf->bf_mpdu);
  
 -		if (bf_isampdu(bf))
 +		if (bf_isampdu(bf)) {
- 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok);
+ 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok,
+ 					     true);
 -		else
 +		} else {
 +			ath9k_pktlog_txctrl(sc, &bf_head, lastbf);
@@ -1381,7 +1382,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  		if (txq == sc->tx.txq_map[qnum])
  			ath_wake_mac80211_queue(sc, qnum);
-@@ -2185,9 +2191,11 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2121,9 +2127,11 @@ void ath_tx_edma_tasklet(struct ath_soft
  	int status;
  	int txok;
  	int qnum;
@@ -1394,13 +1395,14 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS)
  			break;
  		if (status == -EIO) {
-@@ -2230,15 +2238,19 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2166,16 +2174,20 @@ void ath_tx_edma_tasklet(struct ath_soft
  
  		qnum = skb_get_queue_mapping(bf->bf_mpdu);
  
 -		if (bf_isampdu(bf))
 +		if (bf_isampdu(bf)) {
- 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs, txok);
+ 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs,
+ 					     txok, true);
 -		else
 +		} else {
 +			ath9k_pktlog_txctrl(sc, &bf_head, lastbf);
-- 
1.7.1

