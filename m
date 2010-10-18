Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54635 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240Ab0JRUhG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 16:37:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: make patches apply again
Date: Mon, 18 Oct 2010 22:36:55 +0200
Message-Id: <1287434215-8883-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1287434215-8883-1-git-send-email-hauke@hauke-m.de>
References: <1287434215-8883-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crap/0002-ath9k-Add-pktlog-support.patch |   50 +++++++++++++++---------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/crap/0002-ath9k-Add-pktlog-support.patch b/crap/0002-ath9k-Add-pktlog-support.patch
index ada8850..0cecf34 100644
--- a/crap/0002-ath9k-Add-pktlog-support.patch
+++ b/crap/0002-ath9k-Add-pktlog-support.patch
@@ -105,7 +105,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /*
   * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
-@@ -564,6 +565,7 @@ struct ath_ant_comb {
+@@ -563,6 +564,7 @@ struct ath_ant_comb {
  #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
  #define SC_OP_BT_SCAN		     BIT(13)
  #define SC_OP_ANI_RUN		     BIT(14)
@@ -113,7 +113,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  /* Powersave flags */
  #define PS_WAIT_FOR_BEACON        BIT(0)
-@@ -642,6 +644,10 @@ struct ath_softc {
+@@ -639,6 +641,10 @@ struct ath_softc {
  #ifdef CONFIG_ATH9K_DEBUGFS
  	struct ath9k_debug debug;
  #endif
@@ -126,7 +126,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	struct ath_btcoex btcoex;
 --- a/drivers/net/wireless/ath/ath9k/debug.c
 +++ b/drivers/net/wireless/ath/ath9k/debug.c
-@@ -1078,6 +1078,9 @@ int ath9k_init_debug(struct ath_hw *ah)
+@@ -984,6 +984,9 @@ int ath9k_init_debug(struct ath_hw *ah)
  			sc, &fops_regdump))
  		goto err;
  
@@ -136,7 +136,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	return 0;
  err:
  	ath9k_exit_debug(ah);
-@@ -1089,6 +1092,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
+@@ -995,6 +998,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
  	struct ath_common *common = ath9k_hw_common(ah);
  	struct ath_softc *sc = (struct ath_softc *) common->priv;
  
@@ -161,7 +161,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  static inline void ath9k_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2155,7 +2155,7 @@ void ath9k_hw_setrxfilter(struct ath_hw 
+@@ -2129,7 +2129,7 @@ void ath9k_hw_setrxfilter(struct ath_hw 
  		phybits |= AR_PHY_ERR_RADAR;
  	if (bits & ATH9K_RX_FILTER_PHYERR)
  		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
@@ -172,7 +172,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		REG_WRITE(ah, AR_RXCFG,
 --- a/drivers/net/wireless/ath/ath9k/hw.h
 +++ b/drivers/net/wireless/ath/ath9k/hw.h
-@@ -584,7 +584,7 @@ struct ath_hw_ops {
+@@ -573,7 +573,7 @@ struct ath_hw_ops {
  			    const void *ds0, dma_addr_t buf_addr,
  			    unsigned int qcu);
  	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
@@ -181,7 +181,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
  			      u32 pktLen, enum ath9k_pkt_type type,
  			      u32 txPower, u32 keyIx,
-@@ -807,6 +807,8 @@ struct ath_hw {
+@@ -796,6 +796,8 @@ struct ath_hw {
  	 * this register when in sleep states.
  	 */
  	u32 WARegVal;
@@ -1223,7 +1223,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
 +#endif
 --- a/drivers/net/wireless/ath/ath9k/rc.c
 +++ b/drivers/net/wireless/ath/ath9k/rc.c
-@@ -610,7 +610,7 @@ static u8 ath_rc_setvalid_htrates(struct
+@@ -599,7 +599,7 @@ static u8 ath_rc_setvalid_htrates(struct
  static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
  			         struct ath_rate_priv *ath_rc_priv,
  				 const struct ath_rate_table *rate_table,
@@ -1232,7 +1232,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  {
  	u32 best_thruput, this_thruput, now_msec;
  	u8 rate, next_rate, best_rate, maxindex, minindex;
-@@ -701,6 +701,8 @@ static u8 ath_rc_get_highest_rix(struct 
+@@ -690,6 +690,8 @@ static u8 ath_rc_get_highest_rix(struct 
  
  	rate = ath_rc_priv->valid_rate_index[0];
  
@@ -1241,16 +1241,16 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	return rate;
  }
  
-@@ -792,7 +794,7 @@ static void ath_get_rate(void *priv, str
+@@ -781,7 +783,7 @@ static void ath_get_rate(void *priv, str
  	try_per_rate = 4;
  
- 	rate_table = sc->cur_rate_table;
+ 	rate_table = ath_rc_priv->rate_table;
 -	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
 +	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe, skb_get_queue_mapping(skb));
  
  	/*
  	 * If we're in HT mode and both us and our peer supports LDPC.
-@@ -1032,7 +1034,8 @@ static bool ath_rc_update_per(struct ath
+@@ -1031,7 +1033,8 @@ static void ath_debug_stat_retries(struc
  static void ath_rc_update_ht(struct ath_softc *sc,
  			     struct ath_rate_priv *ath_rc_priv,
  			     struct ieee80211_tx_info *tx_info,
@@ -1260,8 +1260,8 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  {
  	u32 now_msec = jiffies_to_msecs(jiffies);
  	int rate;
-@@ -1101,6 +1104,9 @@ static void ath_rc_update_ht(struct ath_
- 	ath_debug_stat_retries(sc, tx_rate, xretries, retries,
+@@ -1100,6 +1103,9 @@ static void ath_rc_update_ht(struct ath_
+ 	ath_debug_stat_retries(ath_rc_priv, tx_rate, xretries, retries,
  			       ath_rc_priv->per[tx_rate]);
  
 +	ath9k_pktlog_rcupdate(sc, ath_rc_priv, tx_rate,
@@ -1270,7 +1270,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  }
  
  static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
-@@ -1133,7 +1139,8 @@ static int ath_rc_get_rateindex(const st
+@@ -1132,7 +1138,8 @@ static int ath_rc_get_rateindex(const st
  static void ath_rc_tx_status(struct ath_softc *sc,
  			     struct ath_rate_priv *ath_rc_priv,
  			     struct ieee80211_tx_info *tx_info,
@@ -1280,7 +1280,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  {
  	const struct ath_rate_table *rate_table;
  	struct ieee80211_tx_rate *rates = tx_info->status.rates;
-@@ -1162,7 +1169,7 @@ static void ath_rc_tx_status(struct ath_
+@@ -1161,7 +1168,7 @@ static void ath_rc_tx_status(struct ath_
  				rix = ath_rc_get_rateindex(rate_table, &rates[i]);
  				ath_rc_update_ht(sc, ath_rc_priv, tx_info,
  						rix, xretries ? 1 : 2,
@@ -1289,7 +1289,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  			}
  		}
  	} else {
-@@ -1184,7 +1191,7 @@ static void ath_rc_tx_status(struct ath_
+@@ -1183,7 +1190,7 @@ static void ath_rc_tx_status(struct ath_
  		return;
  
  	rix = ath_rc_get_rateindex(rate_table, &rates[i]);
@@ -1298,7 +1298,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  }
  
  static const
-@@ -1401,7 +1408,8 @@ static void ath_tx_status(void *priv, st
+@@ -1393,7 +1400,8 @@ static void ath_tx_status(void *priv, st
  		tx_status = 1;
  
  	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
@@ -1310,7 +1310,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	if (conf_is_ht(&sc->hw->conf) &&
 --- a/drivers/net/wireless/ath/ath9k/recv.c
 +++ b/drivers/net/wireless/ath/ath9k/recv.c
-@@ -1627,6 +1627,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
+@@ -1630,6 +1630,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
  	struct ieee80211_rx_status *rxs;
  	struct ath_hw *ah = sc->sc_ah;
  	struct ath_common *common = ath9k_hw_common(ah);
@@ -1318,7 +1318,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  	/*
  	 * The hw can techncically differ from common->hw when using ath9k
  	 * virtual wiphy so to account for that we iterate over the active
-@@ -1719,12 +1720,24 @@ int ath_rx_tasklet(struct ath_softc *sc,
+@@ -1722,12 +1723,24 @@ int ath_rx_tasklet(struct ath_softc *sc,
  				 dma_type);
  
  		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
@@ -1346,7 +1346,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
 --- a/drivers/net/wireless/ath/ath9k/xmit.c
 +++ b/drivers/net/wireless/ath/ath9k/xmit.c
-@@ -437,6 +437,8 @@ static void ath_tx_complete_aggr(struct 
+@@ -436,6 +436,8 @@ static void ath_tx_complete_aggr(struct 
  			list_move_tail(&bf->list, &bf_head);
  		}
  
@@ -1355,7 +1355,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (!txpending || (tid->state & AGGR_CLEANUP)) {
  			/*
  			 * complete the acked-ones/xretried ones; update
-@@ -2075,7 +2077,7 @@ static void ath_tx_processq(struct ath_s
+@@ -2078,7 +2080,7 @@ static void ath_tx_processq(struct ath_s
  		ds = lastbf->bf_desc;
  
  		memset(&ts, 0, sizeof(ts));
@@ -1364,7 +1364,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS) {
  			spin_unlock_bh(&txq->axq_lock);
  			break;
-@@ -2112,10 +2114,14 @@ static void ath_tx_processq(struct ath_s
+@@ -2115,10 +2117,14 @@ static void ath_tx_processq(struct ath_s
  			ath_tx_rc_status(bf, &ts, txok ? 0 : 1, txok, true);
  		}
  
@@ -1381,7 +1381,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  
  		ath_wake_mac80211_queue(sc, txq);
  
-@@ -2187,9 +2193,11 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2190,9 +2196,11 @@ void ath_tx_edma_tasklet(struct ath_soft
  	struct list_head bf_head;
  	int status;
  	int txok;
@@ -1394,7 +1394,7 @@ Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
  		if (status == -EINPROGRESS)
  			break;
  		if (status == -EIO) {
-@@ -2230,14 +2238,18 @@ void ath_tx_edma_tasklet(struct ath_soft
+@@ -2233,14 +2241,18 @@ void ath_tx_edma_tasklet(struct ath_soft
  			ath_tx_rc_status(bf, &txs, txok ? 0 : 1, txok, true);
  		}
  
-- 
1.7.0.4

