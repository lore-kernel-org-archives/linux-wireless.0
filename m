Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44164 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0LAPET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:04:19 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Wed,  1 Dec 2010 16:04:11 +0100
Message-Id: <1291215851-1186-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crap/0002-ath9k-Add-pktlog-support.patch |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/crap/0002-ath9k-Add-pktlog-support.patch b/crap/0002-ath9k-Add-pktlog-support.patch
index 78b2820..96ffc10 100644
--- a/crap/0002-ath9k-Add-pktlog-support.patch
+++ b/crap/0002-ath9k-Add-pktlog-support.patch
@@ -97,7 +97,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	return 0;
 --- a/drivers/net/wireless/ath/ath9k/ath9k.h
 +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
-@@ -24,6 +24,7 @@
+@@ -25,6 +25,7 @@
  
  #include "debug.h"
  #include "common.h"
@@ -105,15 +105,15 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /*
   * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
-@@ -544,6 +545,7 @@ struct ath_ant_comb {
- #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
+@@ -546,6 +547,7 @@ struct ath_ant_comb {
  #define SC_OP_BT_SCAN		     BIT(13)
  #define SC_OP_ANI_RUN		     BIT(14)
-+#define SC_OP_PKTLOGGING	     BIT(15)
+ #define SC_OP_ENABLE_APM	     BIT(15)
++#define SC_OP_PKTLOGGING	     BIT(16)
  
  /* Powersave flags */
  #define PS_WAIT_FOR_BEACON        BIT(0)
-@@ -621,6 +623,10 @@ struct ath_softc {
+@@ -623,6 +625,10 @@ struct ath_softc {
  #ifdef CONFIG_ATH9K_DEBUGFS
  	struct ath9k_debug debug;
  #endif
@@ -161,7 +161,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  static inline void ath9k_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2142,7 +2142,7 @@ void ath9k_hw_setrxfilter(struct ath_hw
+@@ -2147,7 +2147,7 @@ void ath9k_hw_setrxfilter(struct ath_hw
  		phybits |= AR_PHY_ERR_RADAR;
  	if (bits & ATH9K_RX_FILTER_PHYERR)
  		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
@@ -172,7 +172,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		REG_WRITE(ah, AR_RXCFG,
 --- a/drivers/net/wireless/ath/ath9k/hw.h
 +++ b/drivers/net/wireless/ath/ath9k/hw.h
-@@ -616,7 +616,7 @@ struct ath_hw_ops {
+@@ -617,7 +617,7 @@ struct ath_hw_ops {
  			    const void *ds0, dma_addr_t buf_addr,
  			    unsigned int qcu);
  	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
@@ -181,7 +181,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
  			      u32 pktLen, enum ath9k_pkt_type type,
  			      u32 txPower, u32 keyIx,
-@@ -845,6 +845,8 @@ struct ath_hw {
+@@ -846,6 +846,8 @@ struct ath_hw {
  
  	/* Enterprise mode cap */
  	u32 ent_mode;
@@ -1310,7 +1310,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	if (conf_is_ht(&sc->hw->conf) &&
 --- a/drivers/net/wireless/ath/ath9k/recv.c
 +++ b/drivers/net/wireless/ath/ath9k/recv.c
-@@ -1617,6 +1617,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
+@@ -1619,6 +1619,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
  	struct ieee80211_rx_status *rxs;
  	struct ath_hw *ah = sc->sc_ah;
  	struct ath_common *common = ath9k_hw_common(ah);
@@ -1318,7 +1318,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	/*
  	 * The hw can techncically differ from common->hw when using ath9k
  	 * virtual wiphy so to account for that we iterate over the active
-@@ -1709,12 +1710,24 @@ int ath_rx_tasklet(struct ath_softc *sc,
+@@ -1711,12 +1712,24 @@ int ath_rx_tasklet(struct ath_softc *sc,
  				 dma_type);
  
  		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
@@ -1355,7 +1355,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (!txpending || (tid->state & AGGR_CLEANUP)) {
  			/*
  			 * complete the acked-ones/xretried ones; update
-@@ -2006,7 +2008,7 @@ static void ath_tx_processq(struct ath_s
+@@ -2025,7 +2027,7 @@ static void ath_tx_processq(struct ath_s
  		ds = lastbf->bf_desc;
  
  		memset(&ts, 0, sizeof(ts));
@@ -1364,7 +1364,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS) {
  			spin_unlock_bh(&txq->axq_lock);
  			break;
-@@ -2045,11 +2047,15 @@ static void ath_tx_processq(struct ath_s
+@@ -2064,11 +2066,15 @@ static void ath_tx_processq(struct ath_s
  
  		qnum = skb_get_queue_mapping(bf->bf_mpdu);
  
@@ -1382,7 +1382,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  		if (txq == sc->tx.txq_map[qnum])
  			ath_wake_mac80211_queue(sc, qnum);
-@@ -2123,9 +2129,11 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2142,9 +2148,11 @@ void ath_tx_edma_tasklet(struct ath_soft
  	int status;
  	int txok;
  	int qnum;
@@ -1395,7 +1395,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS)
  			break;
  		if (status == -EIO) {
-@@ -2168,16 +2176,20 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2187,16 +2195,20 @@ void ath_tx_edma_tasklet(struct ath_soft
  
  		qnum = skb_get_queue_mapping(bf->bf_mpdu);
  
-- 
1.7.1

