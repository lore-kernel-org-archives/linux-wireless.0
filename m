Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54267 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYHGFej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:34:39 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:34:39 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18586.34494.681621.801716@localhost.localdomain> (sfid-20080807_073444_594839_C295B383)
Date: Thu, 7 Aug 2008 10:53:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/6] ath9k: Remove redundant data structure ath9k_txq_info
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Use ath9k_tx_queue_info which contains the same elements,
and merge get/set functions of tx queue properties.
Also, fix whitespace damage in struct ath_softc.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |   27 +----
 drivers/net/wireless/ath9k/beacon.c |    8 +-
 drivers/net/wireless/ath9k/core.h   |  206 +++++++++++++++++------------------
 drivers/net/wireless/ath9k/hw.c     |  118 +++++++++-----------
 drivers/net/wireless/ath9k/main.c   |    2 +-
 drivers/net/wireless/ath9k/xmit.c   |   29 +++---
 6 files changed, 178 insertions(+), 212 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 71027dc..587c0fe 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -282,23 +282,6 @@ enum ath9k_tx_queue_flags {
 	TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE = 0x0080,
 };
 
-struct ath9k_txq_info {
-	u32 tqi_ver;
-	enum ath9k_tx_queue_subtype tqi_subtype;
-	enum ath9k_tx_queue_flags tqi_qflags;
-	u32 tqi_priority;
-	u32 tqi_aifs;
-	u32 tqi_cwmin;
-	u32 tqi_cwmax;
-	u16 tqi_shretry;
-	u16 tqi_lgretry;
-	u32 tqi_cbrPeriod;
-	u32 tqi_cbrOverflowLimit;
-	u32 tqi_burstTime;
-	u32 tqi_readyTime;
-	u32 tqi_compBuf;
-};
-
 #define ATH9K_TXQ_USEDEFAULT ((u32) -1)
 
 #define ATH9K_DECOMP_MASK_SIZE     128
@@ -999,10 +982,10 @@ u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan);
 u32 ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
 				     struct ath9k_channel *chan);
 u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags);
-bool ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
-			      struct ath9k_txq_info *qInfo);
-bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
-			      const struct ath9k_txq_info *qInfo);
+bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
+			    struct ath9k_tx_queue_info *qinfo);
+bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
+			    const struct ath9k_tx_queue_info *qinfo);
 struct ath9k_channel *ath9k_regd_check_channel(struct ath_hal *ah,
 					      const struct ath9k_channel *c);
 void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
@@ -1053,7 +1036,7 @@ void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah,
 bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit);
 bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah);
 int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
-			  const struct ath9k_txq_info *qInfo);
+			  const struct ath9k_tx_queue_info *qinfo);
 u32 ath9k_hw_numtxpending(struct ath_hal *ah, u32 q);
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 bool ath9k_hw_disable(struct ath_hal *ah);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index ba3dd25..6e6538b 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -30,9 +30,9 @@
 static int ath_beaconq_config(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	struct ath9k_txq_info qi;
+	struct ath9k_tx_queue_info qi;
 
-	ath9k_hw_gettxqueueprops(ah, sc->sc_bhalq, &qi);
+	ath9k_hw_get_txq_props(ah, sc->sc_bhalq, &qi);
 	if (sc->sc_opmode == ATH9K_M_HOSTAP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
@@ -45,7 +45,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 		qi.tqi_cwmax = sc->sc_beacon_qi.tqi_cwmax;
 	}
 
-	if (!ath9k_hw_settxqueueprops(ah, sc->sc_bhalq, &qi)) {
+	if (!ath9k_hw_set_txq_props(ah, sc->sc_bhalq, &qi)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to update h/w beacon queue parameters\n",
 			__func__);
@@ -335,7 +335,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 
 int ath_beaconq_setup(struct ath_hal *ah)
 {
-	struct ath9k_txq_info qi;
+	struct ath9k_tx_queue_info qi;
 
 	memzero(&qi, sizeof(qi));
 	qi.tqi_aifs = 1;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index cf76b36..903bd46 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -568,7 +568,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_tx_cleanup(struct ath_softc *sc);
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
-int ath_txq_update(struct ath_softc *sc, int qnum, struct ath9k_txq_info *q);
+int ath_txq_update(struct ath_softc *sc, int qnum,
+		   struct ath9k_tx_queue_info *q);
 int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb);
 void ath_tx_tasklet(struct ath_softc *sc);
 u32 ath_txq_depth(struct ath_softc *sc, int qnum);
@@ -922,132 +923,123 @@ struct ath_ht_info {
 };
 
 struct ath_softc {
-	struct ieee80211_hw *hw; /* mac80211 instance */
-	struct pci_dev		*pdev;	    /* Bus handle */
-	void __iomem		*mem;	    /* address of the device */
-	struct tasklet_struct   intr_tq;    /* General tasklet */
-	struct tasklet_struct   bcon_tasklet; /* Beacon tasklet */
-	struct ath_config       sc_config;  /* per-instance load-time
-						parameters */
-	int                     sc_debug;   /* Debug masks */
-	struct ath_hal          *sc_ah;     /* HAL Instance */
-	struct ath_rate_softc    *sc_rc;     /* tx rate control support */
-	u32               sc_intrstatus; /* HAL_STATUS */
-	enum ath9k_opmode         sc_opmode;  /* current operating mode */
-
-	/* Properties, Config */
-	u8                sc_invalid;	/* being detached */
-	u8                sc_beacons;	/* beacons running */
-	u8                sc_scanning;	/* scanning active */
-	u8                sc_txaggr;	/* enable 11n tx aggregation */
-	u8                sc_rxaggr;	/* enable 11n rx aggregation */
-	u8                sc_update_chainmask;	/* change chain mask */
-	u8                sc_full_reset;		/* force full reset */
-	enum wireless_mode      sc_curmode;     /* current phy mode */
-	u16               sc_curtxpow;    /* current tx power limit */
-	u16               sc_curaid;      /* current association id */
-	u8                sc_curbssid[ETH_ALEN];
-	u8                sc_myaddr[ETH_ALEN];
-	enum PROT_MODE          sc_protmode;    /* protection mode */
-	u8                sc_mcastantenna;/* Multicast antenna number */
-	u8                sc_txantenna;   /* data tx antenna
-						(fixed or auto) */
-	u8                sc_nbcnvaps;    /* # of vaps sending beacons */
-	u16               sc_nvaps;       /* # of active virtual ap's */
-	struct ath_vap          *sc_vaps[ATH_BCBUF]; /* interface id
-						to avp map */
-	enum ath9k_int            sc_imask;       /* interrupt mask copy */
-	u8                sc_bssidmask[ETH_ALEN];
-	u8                sc_defant;      /* current default antenna */
-	u8                sc_rxotherant;  /* rx's on non-default antenna*/
-	u16               sc_cachelsz;    /* cache line size */
-	int                     sc_slotupdate;  /* slot to next advance fsm */
-	int                     sc_slottime;    /* slot time */
-	u8                sc_noreset;
-	int                     sc_bslot[ATH_BCBUF];/* beacon xmit slots */
-	struct ath9k_node_stats   sc_halstats;    /* station-mode rssi stats */
-	struct list_head        node_list;
-	struct ath_ht_info      sc_ht_info;
-	int16_t                 sc_noise_floor; /* signal noise floor in dBm */
-	enum ath9k_ht_extprotspacing   sc_ht_extprotspacing;
-	u8                sc_tx_chainmask;
-	u8                sc_rx_chainmask;
-	u8                sc_rxchaindetect_ref;
-	u8                sc_rxchaindetect_thresh5GHz;
-	u8                sc_rxchaindetect_thresh2GHz;
-	u8                sc_rxchaindetect_delta5GHz;
-	u8                sc_rxchaindetect_delta2GHz;
-	u32               sc_rtsaggrlimit; /* Chipset specific
-						aggr limit */
-	u32                     sc_flags;
+	struct ieee80211_hw *hw;
+	struct pci_dev *pdev;
+	void __iomem *mem;
+	struct tasklet_struct intr_tq;
+	struct tasklet_struct bcon_tasklet;
+	struct ath_config sc_config;	/* load-time parameters */
+	int sc_debug;
+	struct ath_hal *sc_ah;
+	struct ath_rate_softc *sc_rc;	/* tx rate control support */
+	u32 sc_intrstatus;
+	enum ath9k_opmode sc_opmode;	/* current operating mode */
+
+	u8 sc_invalid;			/* being detached */
+	u8 sc_beacons;			/* beacons running */
+	u8 sc_scanning;			/* scanning active */
+	u8 sc_txaggr;			/* enable 11n tx aggregation */
+	u8 sc_rxaggr;			/* enable 11n rx aggregation */
+	u8 sc_update_chainmask;		/* change chain mask */
+	u8 sc_full_reset;		/* force full reset */
+	enum wireless_mode sc_curmode;	/* current phy mode */
+	u16 sc_curtxpow;
+	u16 sc_curaid;
+	u8 sc_curbssid[ETH_ALEN];
+	u8 sc_myaddr[ETH_ALEN];
+	enum PROT_MODE sc_protmode;
+	u8 sc_mcastantenna;
+	u8 sc_txantenna;		/* data tx antenna (fixed or auto) */
+	u8 sc_nbcnvaps;			/* # of vaps sending beacons */
+	u16 sc_nvaps;			/* # of active virtual ap's */
+	struct ath_vap *sc_vaps[ATH_BCBUF];
+	enum ath9k_int sc_imask;
+	u8 sc_bssidmask[ETH_ALEN];
+	u8 sc_defant;			/* current default antenna */
+	u8 sc_rxotherant;		/* rx's on non-default antenna */
+	u16 sc_cachelsz;
+	int sc_slotupdate;		/* slot to next advance fsm */
+	int sc_slottime;
+	u8 sc_noreset;
+	int sc_bslot[ATH_BCBUF];
+	struct ath9k_node_stats sc_halstats; /* station-mode rssi stats */
+	struct list_head node_list;
+	struct ath_ht_info sc_ht_info;
+	int16_t sc_noise_floor;		/* signal noise floor in dBm */
+	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
+	u8 sc_tx_chainmask;
+	u8 sc_rx_chainmask;
+	u8 sc_rxchaindetect_ref;
+	u8 sc_rxchaindetect_thresh5GHz;
+	u8 sc_rxchaindetect_thresh2GHz;
+	u8 sc_rxchaindetect_delta5GHz;
+	u8 sc_rxchaindetect_delta2GHz;
+	u32 sc_rtsaggrlimit;		/* Chipset specific aggr limit */
+	u32 sc_flags;
 #ifdef CONFIG_SLOW_ANT_DIV
-	/* Slow antenna diversity */
-	struct ath_antdiv       sc_antdiv;
+	struct ath_antdiv sc_antdiv;
 #endif
 	enum {
-		OK,                 /* no change needed */
-		UPDATE,             /* update pending */
-		COMMIT              /* beacon sent, commit change */
-	} sc_updateslot;            /* slot time update fsm */
+		OK,		/* no change needed */
+		UPDATE,		/* update pending */
+		COMMIT		/* beacon sent, commit change */
+	} sc_updateslot;	/* slot time update fsm */
 
 	/* Crypto */
-	u32                   sc_keymax;      /* size of key cache */
-	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX); /* key use bit map */
-	u8		sc_splitmic;	/* split TKIP MIC keys */
-	int                     sc_keytype;     /* type of the key being used */
+	u32 sc_keymax;		/* size of key cache */
+	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);	/* key use bit map */
+	u8 sc_splitmic;		/* split TKIP MIC keys */
+	int sc_keytype;
 
 	/* RX */
-	struct list_head	sc_rxbuf;       /* receive buffer */
-	struct ath_descdma      sc_rxdma;       /* RX descriptors */
-	int                     sc_rxbufsize;   /* rx size based on mtu */
-	u32               *sc_rxlink;     /* link ptr in last RX desc */
-	u32               sc_rxflush;     /* rx flush in progress */
-	u64               sc_lastrx;      /* tsf of last rx'd frame */
+	struct list_head sc_rxbuf;
+	struct ath_descdma sc_rxdma;
+	int sc_rxbufsize;	/* rx size based on mtu */
+	u32 *sc_rxlink;		/* link ptr in last RX desc */
+	u32 sc_rxflush;		/* rx flush in progress */
+	u64 sc_lastrx;		/* tsf of last rx'd frame */
 
 	/* TX */
-	struct list_head	sc_txbuf;       /* transmit buffer */
-	struct ath_txq          sc_txq[ATH9K_NUM_TX_QUEUES];
-	struct ath_descdma      sc_txdma;       /* TX descriptors */
-	u32                   sc_txqsetup;    /* h/w queues setup */
-	u32                   sc_txintrperiod;/* tx interrupt batching */
-	int                     sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME
-							AC -> h/w qnum */
-	u32               sc_ant_tx[8];   /* recent tx frames/antenna */
+	struct list_head sc_txbuf;
+	struct ath_txq sc_txq[ATH9K_NUM_TX_QUEUES];
+	struct ath_descdma sc_txdma;
+	u32 sc_txqsetup;
+	u32 sc_txintrperiod;	/* tx interrupt batching */
+	int sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME	AC -> h/w qnum */
+	u32 sc_ant_tx[8];	/* recent tx frames/antenna */
 
 	/* Beacon */
-	struct ath9k_txq_info     sc_beacon_qi;   /* adhoc only: beacon
-						queue parameters */
-	struct ath_descdma      sc_bdma;        /* beacon descriptors */
-	struct ath_txq          *sc_cabq;       /* tx q for cab frames */
-	struct list_head	sc_bbuf;	/* beacon buffers */
-	u32                   sc_bhalq;       /* HAL q for outgoing beacons */
-	u32                   sc_bmisscount;  /* missed beacon transmits */
-	u32               ast_be_xmit; /* beacons transmitted */
+	struct ath9k_tx_queue_info sc_beacon_qi;
+	struct ath_descdma sc_bdma;
+	struct ath_txq *sc_cabq;
+	struct list_head sc_bbuf;
+	u32 sc_bhalq;
+	u32 sc_bmisscount;
+	u32 ast_be_xmit;	/* beacons transmitted */
 
 	/* Rate */
-	struct ieee80211_rate          rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
-	const struct ath9k_rate_table    *sc_rates[WIRELESS_MODE_MAX];
-	const struct ath9k_rate_table    *sc_currates; /* current rate table */
-	u8                       sc_rixmap[256]; /* IEEE to h/w
-						rate table ix */
-	u8                       sc_minrateix;   /* min h/w rate index */
-	u8                       sc_protrix; /* protection rate index */
+	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
+	const struct ath9k_rate_table *sc_rates[WIRELESS_MODE_MAX];
+	const struct ath9k_rate_table *sc_currates;
+	u8 sc_rixmap[256];	/* IEEE to h/w rate table ix */
+	u8 sc_minrateix;	/* min h/w rate index */
+	u8 sc_protrix;		/* protection rate index */
 	struct {
-		u32 rateKbps;      /* transfer rate in kbs */
-		u8 ieeerate;       /* IEEE rate */
-	} sc_hwmap[256];         /* h/w rate ix mappings */
+		u32 rateKbps;	/* transfer rate in kbs */
+		u8 ieeerate;	/* IEEE rate */
+	} sc_hwmap[256];	/* h/w rate ix mappings */
 
 	/* Channel, Band */
 	struct ieee80211_channel channels[IEEE80211_NUM_BANDS][ATH_CHAN_MAX];
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
-	struct ath9k_channel            sc_curchan; /* current h/w channel */
+	struct ath9k_channel sc_curchan;
 
 	/* Locks */
-	spinlock_t              sc_rxflushlock; /* lock of RX flush */
-	spinlock_t              sc_rxbuflock;   /* rxbuf lock */
-	spinlock_t              sc_txbuflock;   /* txbuf lock */
-	spinlock_t              sc_resetlock;
-	spinlock_t              node_lock;
+	spinlock_t sc_rxflushlock;
+	spinlock_t sc_rxbuflock;
+	spinlock_t sc_txbuflock;
+	spinlock_t sc_resetlock;
+	spinlock_t node_lock;
 };
 
 int ath_init(u16 devid, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4ee3116..cf1800a 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -7390,12 +7390,21 @@ ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
 	return newLevel != curLevel;
 }
 
-static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
-				   struct ath9k_tx_queue_info *qi,
-				   const struct ath9k_txq_info *qInfo)
+bool ath9k_hw_set_txq_props(struct ath_hal *ah, int q,
+			    const struct ath9k_tx_queue_info *qinfo)
 {
 	u32 cw;
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_tx_queue_info *qi;
 
+	if (q >= pCap->total_queues) {
+		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
+			 __func__, q);
+		return false;
+	}
+
+	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
@@ -7404,43 +7413,43 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 
 	DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: queue %p\n", __func__, qi);
 
-	qi->tqi_ver = qInfo->tqi_ver;
-	qi->tqi_subtype = qInfo->tqi_subtype;
-	qi->tqi_qflags = qInfo->tqi_qflags;
-	qi->tqi_priority = qInfo->tqi_priority;
-	if (qInfo->tqi_aifs != ATH9K_TXQ_USEDEFAULT)
-		qi->tqi_aifs = min(qInfo->tqi_aifs, 255U);
+	qi->tqi_ver = qinfo->tqi_ver;
+	qi->tqi_subtype = qinfo->tqi_subtype;
+	qi->tqi_qflags = qinfo->tqi_qflags;
+	qi->tqi_priority = qinfo->tqi_priority;
+	if (qinfo->tqi_aifs != ATH9K_TXQ_USEDEFAULT)
+		qi->tqi_aifs = min(qinfo->tqi_aifs, 255U);
 	else
 		qi->tqi_aifs = INIT_AIFS;
-	if (qInfo->tqi_cwmin != ATH9K_TXQ_USEDEFAULT) {
-		cw = min(qInfo->tqi_cwmin, 1024U);
+	if (qinfo->tqi_cwmin != ATH9K_TXQ_USEDEFAULT) {
+		cw = min(qinfo->tqi_cwmin, 1024U);
 		qi->tqi_cwmin = 1;
 		while (qi->tqi_cwmin < cw)
 			qi->tqi_cwmin = (qi->tqi_cwmin << 1) | 1;
 	} else
-		qi->tqi_cwmin = qInfo->tqi_cwmin;
-	if (qInfo->tqi_cwmax != ATH9K_TXQ_USEDEFAULT) {
-		cw = min(qInfo->tqi_cwmax, 1024U);
+		qi->tqi_cwmin = qinfo->tqi_cwmin;
+	if (qinfo->tqi_cwmax != ATH9K_TXQ_USEDEFAULT) {
+		cw = min(qinfo->tqi_cwmax, 1024U);
 		qi->tqi_cwmax = 1;
 		while (qi->tqi_cwmax < cw)
 			qi->tqi_cwmax = (qi->tqi_cwmax << 1) | 1;
 	} else
 		qi->tqi_cwmax = INIT_CWMAX;
 
-	if (qInfo->tqi_shretry != 0)
-		qi->tqi_shretry = min((u32) qInfo->tqi_shretry, 15U);
+	if (qinfo->tqi_shretry != 0)
+		qi->tqi_shretry = min((u32) qinfo->tqi_shretry, 15U);
 	else
 		qi->tqi_shretry = INIT_SH_RETRY;
-	if (qInfo->tqi_lgretry != 0)
-		qi->tqi_lgretry = min((u32) qInfo->tqi_lgretry, 15U);
+	if (qinfo->tqi_lgretry != 0)
+		qi->tqi_lgretry = min((u32) qinfo->tqi_lgretry, 15U);
 	else
 		qi->tqi_lgretry = INIT_LG_RETRY;
-	qi->tqi_cbrPeriod = qInfo->tqi_cbrPeriod;
-	qi->tqi_cbrOverflowLimit = qInfo->tqi_cbrOverflowLimit;
-	qi->tqi_burstTime = qInfo->tqi_burstTime;
-	qi->tqi_readyTime = qInfo->tqi_readyTime;
+	qi->tqi_cbrPeriod = qinfo->tqi_cbrPeriod;
+	qi->tqi_cbrOverflowLimit = qinfo->tqi_cbrOverflowLimit;
+	qi->tqi_burstTime = qinfo->tqi_burstTime;
+	qi->tqi_readyTime = qinfo->tqi_readyTime;
 
-	switch (qInfo->tqi_subtype) {
+	switch (qinfo->tqi_subtype) {
 	case ATH9K_WME_UPSD:
 		if (qi->tqi_type == ATH9K_TX_QUEUE_DATA)
 			qi->tqi_intFlags = ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS;
@@ -7451,66 +7460,47 @@ static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 	return true;
 }
 
-bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
-			      const struct ath9k_txq_info *qInfo)
+bool ath9k_hw_get_txq_props(struct ath_hal *ah, int q,
+			    struct ath9k_tx_queue_info *qinfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_tx_queue_info *qi;
 
 	if (q >= pCap->total_queues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
 	}
-	return ath9k_hw_set_txq_props(ah, &ahp->ah_txq[q], qInfo);
-}
 
-static bool ath9k_hw_get_txq_props(struct ath_hal *ah,
-				   struct ath9k_txq_info *qInfo,
-				   const struct ath9k_tx_queue_info *qi)
-{
+	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
 		return false;
 	}
 
-	qInfo->tqi_qflags = qi->tqi_qflags;
-	qInfo->tqi_ver = qi->tqi_ver;
-	qInfo->tqi_subtype = qi->tqi_subtype;
-	qInfo->tqi_qflags = qi->tqi_qflags;
-	qInfo->tqi_priority = qi->tqi_priority;
-	qInfo->tqi_aifs = qi->tqi_aifs;
-	qInfo->tqi_cwmin = qi->tqi_cwmin;
-	qInfo->tqi_cwmax = qi->tqi_cwmax;
-	qInfo->tqi_shretry = qi->tqi_shretry;
-	qInfo->tqi_lgretry = qi->tqi_lgretry;
-	qInfo->tqi_cbrPeriod = qi->tqi_cbrPeriod;
-	qInfo->tqi_cbrOverflowLimit = qi->tqi_cbrOverflowLimit;
-	qInfo->tqi_burstTime = qi->tqi_burstTime;
-	qInfo->tqi_readyTime = qi->tqi_readyTime;
+	qinfo->tqi_qflags = qi->tqi_qflags;
+	qinfo->tqi_ver = qi->tqi_ver;
+	qinfo->tqi_subtype = qi->tqi_subtype;
+	qinfo->tqi_qflags = qi->tqi_qflags;
+	qinfo->tqi_priority = qi->tqi_priority;
+	qinfo->tqi_aifs = qi->tqi_aifs;
+	qinfo->tqi_cwmin = qi->tqi_cwmin;
+	qinfo->tqi_cwmax = qi->tqi_cwmax;
+	qinfo->tqi_shretry = qi->tqi_shretry;
+	qinfo->tqi_lgretry = qi->tqi_lgretry;
+	qinfo->tqi_cbrPeriod = qi->tqi_cbrPeriod;
+	qinfo->tqi_cbrOverflowLimit = qi->tqi_cbrOverflowLimit;
+	qinfo->tqi_burstTime = qi->tqi_burstTime;
+	qinfo->tqi_readyTime = qi->tqi_readyTime;
 
 	return true;
 }
 
-bool
-ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
-			 struct ath9k_txq_info *qInfo)
-{
-	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
-
-	if (q >= pCap->total_queues) {
-		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
-			 __func__, q);
-		return false;
-	}
-	return ath9k_hw_get_txq_props(ah, qInfo, &ahp->ah_txq[q]);
-}
-
 int
 ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
-		      const struct ath9k_txq_info *qInfo)
+		      const struct ath9k_tx_queue_info *qinfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_tx_queue_info *qi;
@@ -7557,7 +7547,7 @@ ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 	}
 	memset(qi, 0, sizeof(struct ath9k_tx_queue_info));
 	qi->tqi_type = type;
-	if (qInfo == NULL) {
+	if (qinfo == NULL) {
 		qi->tqi_qflags =
 			TXQ_FLAG_TXOKINT_ENABLE
 			| TXQ_FLAG_TXERRINT_ENABLE
@@ -7569,8 +7559,8 @@ ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 		qi->tqi_lgretry = INIT_LG_RETRY;
 		qi->tqi_physCompBuf = 0;
 	} else {
-		qi->tqi_physCompBuf = qInfo->tqi_compBuf;
-		(void) ath9k_hw_settxqueueprops(ah, q, qInfo);
+		qi->tqi_physCompBuf = qinfo->tqi_physCompBuf;
+		(void) ath9k_hw_set_txq_props(ah, q, qinfo);
 	}
 
 	return q;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 01bee5e..4cf0d26 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -700,7 +700,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 			 const struct ieee80211_tx_queue_params *params)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath9k_txq_info qi;
+	struct ath9k_tx_queue_info qi;
 	int ret = 0, qnum;
 
 	if (queue >= WME_NUM_AC)
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 92bb3c2..debd7f4 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2209,7 +2209,7 @@ int ath_tx_cleanup(struct ath_softc *sc)
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	struct ath9k_txq_info qi;
+	struct ath9k_tx_queue_info qi;
 	int qnum;
 
 	memzero(&qi, sizeof(qi));
@@ -2217,7 +2217,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	qi.tqi_aifs = ATH9K_TXQ_USEDEFAULT;
 	qi.tqi_cwmin = ATH9K_TXQ_USEDEFAULT;
 	qi.tqi_cwmax = ATH9K_TXQ_USEDEFAULT;
-	qi.tqi_compBuf = 0;
+	qi.tqi_physCompBuf = 0;
 
 	/*
 	 * Enable interrupts only for EOL and DESC conditions.
@@ -2337,11 +2337,12 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 
 /* Update parameters for a transmit queue */
 
-int ath_txq_update(struct ath_softc *sc, int qnum, struct ath9k_txq_info *qi0)
+int ath_txq_update(struct ath_softc *sc, int qnum,
+		   struct ath9k_tx_queue_info *qinfo)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	int error = 0;
-	struct ath9k_txq_info qi;
+	struct ath9k_tx_queue_info qi;
 
 	if (qnum == sc->sc_bhalq) {
 		/*
@@ -2349,20 +2350,20 @@ int ath_txq_update(struct ath_softc *sc, int qnum, struct ath9k_txq_info *qi0)
 		 * It will be picked up by ath_beaconq_config when
 		 * it's necessary.
 		 */
-		sc->sc_beacon_qi = *qi0;
+		sc->sc_beacon_qi = *qinfo;
 		return 0;
 	}
 
 	ASSERT(sc->sc_txq[qnum].axq_qnum == qnum);
 
-	ath9k_hw_gettxqueueprops(ah, qnum, &qi);
-	qi.tqi_aifs = qi0->tqi_aifs;
-	qi.tqi_cwmin = qi0->tqi_cwmin;
-	qi.tqi_cwmax = qi0->tqi_cwmax;
-	qi.tqi_burstTime = qi0->tqi_burstTime;
-	qi.tqi_readyTime = qi0->tqi_readyTime;
+	ath9k_hw_get_txq_props(ah, qnum, &qi);
+	qi.tqi_aifs = qinfo->tqi_aifs;
+	qi.tqi_cwmin = qinfo->tqi_cwmin;
+	qi.tqi_cwmax = qinfo->tqi_cwmax;
+	qi.tqi_burstTime = qinfo->tqi_burstTime;
+	qi.tqi_readyTime = qinfo->tqi_readyTime;
 
-	if (!ath9k_hw_settxqueueprops(ah, qnum, &qi)) {
+	if (!ath9k_hw_set_txq_props(ah, qnum, &qi)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to update hardware queue %u!\n",
 			__func__, qnum);
@@ -2376,11 +2377,11 @@ int ath_txq_update(struct ath_softc *sc, int qnum, struct ath9k_txq_info *qi0)
 
 int ath_cabq_update(struct ath_softc *sc)
 {
-	struct ath9k_txq_info qi;
+	struct ath9k_tx_queue_info qi;
 	int qnum = sc->sc_cabq->axq_qnum;
 	struct ath_beacon_config conf;
 
-	ath9k_hw_gettxqueueprops(sc->sc_ah, qnum, &qi);
+	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
 	/*
 	 * Ensure the readytime % is within the bounds.
 	 */
-- 
1.5.6.5

