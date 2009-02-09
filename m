Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30461 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZBIIAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:00:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:00:46 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57807.978030.463335@gargle.gargle.HOWL> (sfid-20090209_090054_826214_C1B9E798)
Date: Mon, 9 Feb 2009 13:27:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 03/10] ath9k: Remove all the sc_ prefixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the useless sc_ prefixes for all variables.
Also, refer to interfaces as VIFs and not as VAPs anymore.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |  144 ++++++++---------
 drivers/net/wireless/ath9k/beacon.c |   56 ++++----
 drivers/net/wireless/ath9k/debug.c  |  130 ++++++++--------
 drivers/net/wireless/ath9k/hw.c     |    6 +-
 drivers/net/wireless/ath9k/main.c   |  302 +++++++++++++++++-----------------
 drivers/net/wireless/ath9k/recv.c   |   18 +-
 drivers/net/wireless/ath9k/xmit.c   |   16 +-
 7 files changed, 330 insertions(+), 342 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 3cb7bf8..d60b2e7 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -104,13 +104,13 @@ enum buffer_type {
 };
 
 struct ath_buf_state {
-	int bfs_nframes;		/* # frames in aggregate */
-	u16 bfs_al;			/* length of aggregate */
-	u16 bfs_frmlen;			/* length of frame */
-	int bfs_seqno;			/* sequence number */
-	int bfs_tidno;			/* tid of this frame */
-	int bfs_retries;		/* current retries */
-	u32 bf_type;			/* BUF_* (enum buffer_type) */
+	int bfs_nframes;
+	u16 bfs_al;
+	u16 bfs_frmlen;
+	int bfs_seqno;
+	int bfs_tidno;
+	int bfs_retries;
+	u32 bf_type;
 	u32 bfs_keyix;
 	enum ath9k_key_type bfs_keytype;
 };
@@ -129,10 +129,6 @@ struct ath_buf_state {
 #define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
 #define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
 
-/*
- * Abstraction of a contiguous buffer to transmit/receive.  There is only
- * a single hw descriptor encapsulated here.
- */
 struct ath_buf {
 	struct list_head list;
 	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
@@ -143,22 +139,20 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	u32 bf_status;
-	u16 bf_flags;			/* tx descriptor flags */
-	struct ath_buf_state bf_state;	/* buffer state */
+	u16 bf_flags;
+	struct ath_buf_state bf_state;
 	dma_addr_t bf_dmacontext;
 };
 
 #define ATH_RXBUF_RESET(_bf)    ((_bf)->bf_status = 0)
 #define ATH_BUFSTATUS_STALE     0x00000002
 
-/* DMA state for tx/rx descriptors */
-
 struct ath_descdma {
 	const char *dd_name;
-	struct ath_desc *dd_desc;	/* descriptors  */
-	dma_addr_t dd_desc_paddr;	/* physical addr of dd_desc  */
-	u32 dd_desc_len;		/* size of dd_desc  */
-	struct ath_buf *dd_bufptr;	/* associated buffers */
+	struct ath_desc *dd_desc;
+	dma_addr_t dd_desc_paddr;
+	u32 dd_desc_len;
+	struct ath_buf *dd_bufptr;
 	dma_addr_t dd_dmacontext;
 };
 
@@ -246,15 +240,15 @@ enum ATH_AGGR_STATUS {
 };
 
 struct ath_txq {
-	u32 axq_qnum;			/* hardware q number */
-	u32 *axq_link;			/* link ptr in last TX desc */
-	struct list_head axq_q;		/* transmit queue */
+	u32 axq_qnum;
+	u32 *axq_link;
+	struct list_head axq_q;
 	spinlock_t axq_lock;
-	u32 axq_depth;			/* queue depth */
-	u8 axq_aggr_depth;		/* aggregates queued */
-	u32 axq_totalqueued;		/* total ever queued */
-	bool stopped;			/* Is mac80211 queue stopped ? */
-	struct ath_buf *axq_linkbuf;	/* virtual addr of last buffer*/
+	u32 axq_depth;
+	u8 axq_aggr_depth;
+	u32 axq_totalqueued;
+	bool stopped;
+	struct ath_buf *axq_linkbuf;
 
 	/* first desc of the last descriptor that contains CTS */
 	struct ath_desc *axq_lastdsWithCTS;
@@ -270,45 +264,39 @@ struct ath_txq {
 #define AGGR_ADDBA_COMPLETE  BIT(2)
 #define AGGR_ADDBA_PROGRESS  BIT(3)
 
-/* per TID aggregate tx state for a destination */
 struct ath_atx_tid {
-	struct list_head list;		/* round-robin tid entry */
-	struct list_head buf_q;		/* pending buffers */
+	struct list_head list;
+	struct list_head buf_q;
 	struct ath_node *an;
 	struct ath_atx_ac *ac;
-	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS]; /* active tx frames */
+	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS];
 	u16 seq_start;
 	u16 seq_next;
 	u16 baw_size;
 	int tidno;
-	int baw_head;			/* first un-acked tx buffer */
-	int baw_tail;			/* next unused tx buffer slot */
+	int baw_head;	/* first un-acked tx buffer */
+	int baw_tail;	/* next unused tx buffer slot */
 	int sched;
 	int paused;
 	u8 state;
 	int addba_exchangeattempts;
 };
 
-/* per access-category aggregate tx state for a destination */
 struct ath_atx_ac {
-	int sched;			/* dest-ac is scheduled */
-	int qnum;			/* H/W queue number associated
-					   with this AC */
-	struct list_head list;		/* round-robin txq entry */
-	struct list_head tid_q;		/* queue of TIDs with buffers */
+	int sched;
+	int qnum;
+	struct list_head list;
+	struct list_head tid_q;
 };
 
-/* per-frame tx control block */
 struct ath_tx_control {
 	struct ath_txq *txq;
 	int if_id;
 };
 
-/* per frame tx status block */
 struct ath_xmit_status {
-	int retries;	/* number of retries to successufully
-			   transmit this frame */
-	int flags;	/* status of transmit */
+	int retries;
+	int flags;
 #define ATH_TX_ERROR        0x01
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
@@ -396,21 +384,21 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 
 /********/
-/* VAPs */
+/* VIFs */
 /********/
 
 /*
  * Define the scheme that we select MAC address for multiple
- * BSS on the same radio. The very first VAP will just use the MAC
- * address from the EEPROM. For the next 3 VAPs, we set the
+ * BSS on the same radio. The very first VIF will just use the MAC
+ * address from the EEPROM. For the next 3 VIFs, we set the
  * U/L bit (bit 1) in MAC address, and use the next two bits as the
- * index of the VAP.
+ * index of the VIF.
  */
 
-#define ATH_SET_VAP_BSSID_MASK(bssid_mask) \
+#define ATH_SET_VIF_BSSID_MASK(bssid_mask) \
 	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
 
-struct ath_vap {
+struct ath_vif {
 	int av_bslot;
 	enum nl80211_iftype av_opmode;
 	struct ath_buf *av_bcbuf;
@@ -469,7 +457,7 @@ void ath9k_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, int if_id);
 int ath_beaconq_setup(struct ath_hal *ah);
 int ath_beacon_alloc(struct ath_softc *sc, int if_id);
-void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp);
+void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 void ath_beacon_sync(struct ath_softc *sc, int if_id);
 
 /*******/
@@ -485,12 +473,12 @@ void ath_beacon_sync(struct ath_softc *sc, int if_id);
 #define ATH_RESTART_CALINTERVAL 1200000 /* 20 minutes between calibrations */
 
 struct ath_ani {
-	bool sc_caldone;
-	int16_t sc_noise_floor;
-	unsigned int sc_longcal_timer;
-	unsigned int sc_shortcal_timer;
-	unsigned int sc_resetcal_timer;
-	unsigned int sc_checkani_timer;
+	bool caldone;
+	int16_t noise_floor;
+	unsigned int longcal_timer;
+	unsigned int shortcal_timer;
+	unsigned int resetcal_timer;
+	unsigned int checkani_timer;
 	struct timer_list timer;
 };
 
@@ -591,31 +579,31 @@ struct ath_softc {
 	spinlock_t sc_resetlock;
 	struct mutex mutex;
 
-	u8 sc_curbssid[ETH_ALEN];
-	u8 sc_myaddr[ETH_ALEN];
-	u8 sc_bssidmask[ETH_ALEN];
-	u32 sc_intrstatus;
+	u8 curbssid[ETH_ALEN];
+	u8 macaddr[ETH_ALEN];
+	u8 bssidmask[ETH_ALEN];
+	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
-	u16 sc_curtxpow;
-	u16 sc_curaid;
-	u16 sc_cachelsz;
-	u8 sc_nbcnvaps;
-	u16 sc_nvaps;
-	u8 sc_tx_chainmask;
-	u8 sc_rx_chainmask;
-	u32 sc_keymax;
-	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
-	u8 sc_splitmic;
+	u16 curtxpow;
+	u16 curaid;
+	u16 cachelsz;
+	u8 nbcnvifs;
+	u16 nvifs;
+	u8 tx_chainmask;
+	u8 rx_chainmask;
+	u32 keymax;
+	DECLARE_BITMAP(keymap, ATH_KEYMAX);
+	u8 splitmic;
 	atomic_t ps_usecount;
-	enum ath9k_int sc_imask;
-	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
+	enum ath9k_int imask;
+	enum ath9k_ht_extprotspacing ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
 
-	struct ath_config sc_config;
+	struct ath_config config;
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
-	struct ieee80211_vif *sc_vaps[ATH_BCBUF];
+	struct ieee80211_vif *vifs[ATH_BCBUF];
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
 	struct ath_rate_table *cur_rate_table;
@@ -632,10 +620,10 @@ struct ath_softc {
 	int led_off_cnt;
 
 	struct ath_rfkill rf_kill;
-	struct ath_ani sc_ani;
-	struct ath9k_node_stats sc_halstats;
+	struct ath_ani ani;
+	struct ath9k_node_stats nodestats;
 #ifdef CONFIG_ATH9K_DEBUG
-	struct ath9k_debug sc_debug;
+	struct ath9k_debug debug;
 #endif
 	struct ath_bus_ops *bus_ops;
 };
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 1f92ad7..139bba7 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -63,7 +63,7 @@ static void ath_bstuck_process(struct ath_softc *sc)
  *  Beacons are always sent out at the lowest rate, and are not retried.
 */
 static void ath_beacon_setup(struct ath_softc *sc,
-			     struct ath_vap *avp, struct ath_buf *bf)
+			     struct ath_vif *avp, struct ath_buf *bf)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 	struct ath_hal *ah = sc->sc_ah;
@@ -96,7 +96,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 		 * SWBA's
 		 * XXX assumes two antenna
 		 */
-		antenna = ((sc->beacon.ast_be_xmit / sc->sc_nbcnvaps) & 1 ? 2 : 1);
+		antenna = ((sc->beacon.ast_be_xmit / sc->nbcnvifs) & 1 ? 2 : 1);
 	}
 
 	ds->ds_data = bf->bf_buf_addr;
@@ -132,24 +132,24 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
 	series[0].Rate = rate;
-	series[0].ChSel = sc->sc_tx_chainmask;
+	series[0].ChSel = sc->tx_chainmask;
 	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
 	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0,
 		ctsrate, ctsduration, series, 4, 0);
 }
 
-/* Generate beacon frame and queue cab data for a vap */
+/* Generate beacon frame and queue cab data for a VIF */
 static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 {
 	struct ath_buf *bf;
-	struct ath_vap *avp;
+	struct ath_vif *avp;
 	struct sk_buff *skb;
 	struct ath_txq *cabq;
 	struct ieee80211_vif *vif;
 	struct ieee80211_tx_info *info;
 	int cabq_depth;
 
-	vif = sc->sc_vaps[if_id];
+	vif = sc->vifs[if_id];
 	ASSERT(vif);
 
 	avp = (void *)vif->drv_priv;
@@ -204,10 +204,10 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	/*
 	 * if the CABQ traffic from previous DTIM is pending and the current
 	 *  beacon is also a DTIM.
-	 *  1) if there is only one vap let the cab traffic continue.
-	 *  2) if there are more than one vap and we are using staggered
+	 *  1) if there is only one vif let the cab traffic continue.
+	 *  2) if there are more than one vif and we are using staggered
 	 *     beacons, then drain the cabq by dropping all the frames in
-	 *     the cabq so that the current vaps cab traffic can be scheduled.
+	 *     the cabq so that the current vifs cab traffic can be scheduled.
 	 */
 	spin_lock_bh(&cabq->axq_lock);
 	cabq_depth = cabq->axq_depth;
@@ -219,7 +219,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		 * the lock again which is a common function and that
 		 * acquires txq lock inside.
 		 */
-		if (sc->sc_nvaps > 1) {
+		if (sc->nvifs > 1) {
 			ath_draintxq(sc, cabq, false);
 			DPRINTF(sc, ATH_DBG_BEACON,
 				"flush previous cabq traffic\n");
@@ -250,10 +250,10 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 	struct ieee80211_vif *vif;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf;
-	struct ath_vap *avp;
+	struct ath_vif *avp;
 	struct sk_buff *skb;
 
-	vif = sc->sc_vaps[if_id];
+	vif = sc->vifs[if_id];
 	ASSERT(vif);
 
 	avp = (void *)vif->drv_priv;
@@ -291,13 +291,13 @@ int ath_beaconq_setup(struct ath_hal *ah)
 int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 {
 	struct ieee80211_vif *vif;
-	struct ath_vap *avp;
+	struct ath_vif *avp;
 	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
 	__le64 tstamp;
 
-	vif = sc->sc_vaps[if_id];
+	vif = sc->vifs[if_id];
 	ASSERT(vif);
 
 	avp = (void *)vif->drv_priv;
@@ -314,7 +314,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		    !(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 			int slot;
 			/*
-			 * Assign the vap to a beacon xmit slot. As
+			 * Assign the vif to a beacon xmit slot. As
 			 * above, this cannot fail to find one.
 			 */
 			avp->av_bslot = 0;
@@ -335,7 +335,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 				}
 			BUG_ON(sc->beacon.bslot[avp->av_bslot] != ATH_IF_ID_ANY);
 			sc->beacon.bslot[avp->av_bslot] = if_id;
-			sc->sc_nbcnvaps++;
+			sc->nbcnvifs++;
 		}
 	}
 
@@ -384,8 +384,8 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		 * timestamp then convert to TSF units and handle
 		 * byte swapping before writing it in the frame.
 		 * The hardware will then add this each time a beacon
-		 * frame is sent.  Note that we align vap's 1..N
-		 * and leave vap 0 untouched.  This means vap 0
+		 * frame is sent.  Note that we align vif's 1..N
+		 * and leave vif 0 untouched.  This means vap 0
 		 * has a timestamp in one beacon interval while the
 		 * others get a timestamp aligned to the next interval.
 		 */
@@ -416,14 +416,14 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	return 0;
 }
 
-void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
+void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 {
 	if (avp->av_bcbuf != NULL) {
 		struct ath_buf *bf;
 
 		if (avp->av_bslot != -1) {
 			sc->beacon.bslot[avp->av_bslot] = ATH_IF_ID_ANY;
-			sc->sc_nbcnvaps--;
+			sc->nbcnvifs--;
 		}
 
 		bf = avp->av_bcbuf;
@@ -597,7 +597,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bfaddr);
 		ath9k_hw_txstart(ah, sc->beacon.beaconq);
 
-		sc->beacon.ast_be_xmit += bc;     /* XXX per-vap? */
+		sc->beacon.ast_be_xmit += bc;     /* XXX per-vif? */
 	}
 }
 
@@ -621,12 +621,12 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	struct ieee80211_vif *vif;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_beacon_config conf;
-	struct ath_vap *avp;
+	struct ath_vif *avp;
 	enum nl80211_iftype opmode;
 	u32 nexttbtt, intval;
 
 	if (if_id != ATH_IF_ID_ANY) {
-		vif = sc->sc_vaps[if_id];
+		vif = sc->vifs[if_id];
 		ASSERT(vif);
 		avp = (void *)vif->drv_priv;
 		opmode = avp->av_opmode;
@@ -781,8 +781,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 
 		ath9k_hw_set_interrupts(ah, 0);
 		ath9k_hw_set_sta_beacon_timers(ah, &bs);
-		sc->sc_imask |= ATH9K_INT_BMISS;
-		ath9k_hw_set_interrupts(ah, sc->sc_imask);
+		sc->imask |= ATH9K_INT_BMISS;
+		ath9k_hw_set_interrupts(ah, sc->imask);
 	} else {
 		u64 tsf;
 		u32 tsftu;
@@ -819,7 +819,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			 */
 			intval |= ATH9K_BEACON_ENA;
 			if (!(ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
-				sc->sc_imask |= ATH9K_INT_SWBA;
+				sc->imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
 		} else if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
 			/*
@@ -827,12 +827,12 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			 * SWBA interrupts to prepare beacon frames.
 			 */
 			intval |= ATH9K_BEACON_ENA;
-			sc->sc_imask |= ATH9K_INT_SWBA;   /* beacon prepare */
+			sc->imask |= ATH9K_INT_SWBA;   /* beacon prepare */
 			ath_beaconq_config(sc);
 		}
 		ath9k_hw_beaconinit(ah, nexttbtt, intval);
 		sc->beacon.bmisscnt = 0;
-		ath9k_hw_set_interrupts(ah, sc->sc_imask);
+		ath9k_hw_set_interrupts(ah, sc->imask);
 		/*
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index c9b47b3..daca5ce 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -24,7 +24,7 @@ void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
 	if (!sc)
 		return;
 
-	if (sc->sc_debug.debug_mask & dbg_mask) {
+	if (sc->debug.debug_mask & dbg_mask) {
 		va_list args;
 
 		va_start(args, fmt);
@@ -130,41 +130,41 @@ static const struct file_operations fops_dma = {
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 {
 	if (status)
-		sc->sc_debug.stats.istats.total++;
+		sc->debug.stats.istats.total++;
 	if (status & ATH9K_INT_RX)
-		sc->sc_debug.stats.istats.rxok++;
+		sc->debug.stats.istats.rxok++;
 	if (status & ATH9K_INT_RXEOL)
-		sc->sc_debug.stats.istats.rxeol++;
+		sc->debug.stats.istats.rxeol++;
 	if (status & ATH9K_INT_RXORN)
-		sc->sc_debug.stats.istats.rxorn++;
+		sc->debug.stats.istats.rxorn++;
 	if (status & ATH9K_INT_TX)
-		sc->sc_debug.stats.istats.txok++;
+		sc->debug.stats.istats.txok++;
 	if (status & ATH9K_INT_TXURN)
-		sc->sc_debug.stats.istats.txurn++;
+		sc->debug.stats.istats.txurn++;
 	if (status & ATH9K_INT_MIB)
-		sc->sc_debug.stats.istats.mib++;
+		sc->debug.stats.istats.mib++;
 	if (status & ATH9K_INT_RXPHY)
-		sc->sc_debug.stats.istats.rxphyerr++;
+		sc->debug.stats.istats.rxphyerr++;
 	if (status & ATH9K_INT_RXKCM)
-		sc->sc_debug.stats.istats.rx_keycache_miss++;
+		sc->debug.stats.istats.rx_keycache_miss++;
 	if (status & ATH9K_INT_SWBA)
-		sc->sc_debug.stats.istats.swba++;
+		sc->debug.stats.istats.swba++;
 	if (status & ATH9K_INT_BMISS)
-		sc->sc_debug.stats.istats.bmiss++;
+		sc->debug.stats.istats.bmiss++;
 	if (status & ATH9K_INT_BNR)
-		sc->sc_debug.stats.istats.bnr++;
+		sc->debug.stats.istats.bnr++;
 	if (status & ATH9K_INT_CST)
-		sc->sc_debug.stats.istats.cst++;
+		sc->debug.stats.istats.cst++;
 	if (status & ATH9K_INT_GTT)
-		sc->sc_debug.stats.istats.gtt++;
+		sc->debug.stats.istats.gtt++;
 	if (status & ATH9K_INT_TIM)
-		sc->sc_debug.stats.istats.tim++;
+		sc->debug.stats.istats.tim++;
 	if (status & ATH9K_INT_CABEND)
-		sc->sc_debug.stats.istats.cabend++;
+		sc->debug.stats.istats.cabend++;
 	if (status & ATH9K_INT_DTIMSYNC)
-		sc->sc_debug.stats.istats.dtimsync++;
+		sc->debug.stats.istats.dtimsync++;
 	if (status & ATH9K_INT_DTIM)
-		sc->sc_debug.stats.istats.dtim++;
+		sc->debug.stats.istats.dtim++;
 }
 
 static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
@@ -175,41 +175,41 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	unsigned int len = 0;
 
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RX", sc->sc_debug.stats.istats.rxok);
+		"%8s: %10u\n", "RX", sc->debug.stats.istats.rxok);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXEOL", sc->sc_debug.stats.istats.rxeol);
+		"%8s: %10u\n", "RXEOL", sc->debug.stats.istats.rxeol);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXORN", sc->sc_debug.stats.istats.rxorn);
+		"%8s: %10u\n", "RXORN", sc->debug.stats.istats.rxorn);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TX", sc->sc_debug.stats.istats.txok);
+		"%8s: %10u\n", "TX", sc->debug.stats.istats.txok);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TXURN", sc->sc_debug.stats.istats.txurn);
+		"%8s: %10u\n", "TXURN", sc->debug.stats.istats.txurn);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "MIB", sc->sc_debug.stats.istats.mib);
+		"%8s: %10u\n", "MIB", sc->debug.stats.istats.mib);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXPHY", sc->sc_debug.stats.istats.rxphyerr);
+		"%8s: %10u\n", "RXPHY", sc->debug.stats.istats.rxphyerr);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXKCM", sc->sc_debug.stats.istats.rx_keycache_miss);
+		"%8s: %10u\n", "RXKCM", sc->debug.stats.istats.rx_keycache_miss);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "SWBA", sc->sc_debug.stats.istats.swba);
+		"%8s: %10u\n", "SWBA", sc->debug.stats.istats.swba);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "BMISS", sc->sc_debug.stats.istats.bmiss);
+		"%8s: %10u\n", "BMISS", sc->debug.stats.istats.bmiss);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "BNR", sc->sc_debug.stats.istats.bnr);
+		"%8s: %10u\n", "BNR", sc->debug.stats.istats.bnr);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "CST", sc->sc_debug.stats.istats.cst);
+		"%8s: %10u\n", "CST", sc->debug.stats.istats.cst);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "GTT", sc->sc_debug.stats.istats.gtt);
+		"%8s: %10u\n", "GTT", sc->debug.stats.istats.gtt);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TIM", sc->sc_debug.stats.istats.tim);
+		"%8s: %10u\n", "TIM", sc->debug.stats.istats.tim);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "CABEND", sc->sc_debug.stats.istats.cabend);
+		"%8s: %10u\n", "CABEND", sc->debug.stats.istats.cabend);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "DTIMSYNC", sc->sc_debug.stats.istats.dtimsync);
+		"%8s: %10u\n", "DTIMSYNC", sc->debug.stats.istats.dtimsync);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "DTIM", sc->sc_debug.stats.istats.dtim);
+		"%8s: %10u\n", "DTIM", sc->debug.stats.istats.dtim);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TOTAL", sc->sc_debug.stats.istats.total);
+		"%8s: %10u\n", "TOTAL", sc->debug.stats.istats.total);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
@@ -231,7 +231,7 @@ static void ath_debug_stat_11n_rc(struct ath_softc *sc, struct sk_buff *skb)
 	final_ts_idx = tx_info_priv->tx.ts_rateindex;
 	idx = sc->cur_rate_table->info[rates[final_ts_idx].idx].dot11rate;
 
-	sc->sc_debug.stats.n_rcstats[idx].success++;
+	sc->debug.stats.n_rcstats[idx].success++;
 }
 
 static void ath_debug_stat_legacy_rc(struct ath_softc *sc, struct sk_buff *skb)
@@ -245,7 +245,7 @@ static void ath_debug_stat_legacy_rc(struct ath_softc *sc, struct sk_buff *skb)
 	final_ts_idx = tx_info_priv->tx.ts_rateindex;
 	idx = rates[final_ts_idx].idx;
 
-	sc->sc_debug.stats.legacy_rcstats[idx].success++;
+	sc->debug.stats.legacy_rcstats[idx].success++;
 }
 
 void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb)
@@ -263,8 +263,8 @@ void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 	if (conf_is_ht(&sc->hw->conf)) {
 		int idx = sc->cur_rate_table->info[rix].dot11rate;
 
-		sc->sc_debug.stats.n_rcstats[idx].xretries += xretries;
-		sc->sc_debug.stats.n_rcstats[idx].retries += retries;
+		sc->debug.stats.n_rcstats[idx].xretries += xretries;
+		sc->debug.stats.n_rcstats[idx].retries += retries;
 	}
 }
 
@@ -283,9 +283,9 @@ static ssize_t ath_read_file_stat_11n_rc(struct file *file,
 	for (i = 0; i <= 15; i++) {
 		len += snprintf(buf + len, sizeof(buf) - len,
 				"%5s%3d: %8u %8u %8u\n", "MCS", i,
-				sc->sc_debug.stats.n_rcstats[i].success,
-				sc->sc_debug.stats.n_rcstats[i].retries,
-				sc->sc_debug.stats.n_rcstats[i].xretries);
+				sc->debug.stats.n_rcstats[i].success,
+				sc->debug.stats.n_rcstats[i].retries,
+				sc->debug.stats.n_rcstats[i].xretries);
 	}
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
@@ -305,7 +305,7 @@ static ssize_t ath_read_file_stat_legacy_rc(struct file *file,
 	for (i = 0; i < sc->cur_rate_table->rate_cnt; i++) {
 		len += snprintf(buf + len, sizeof(buf) - len, "%5u: %12u\n",
 				sc->cur_rate_table->info[i].ratekbps / 1000,
-				sc->sc_debug.stats.legacy_rcstats[i].success);
+				sc->debug.stats.legacy_rcstats[i].success);
 	}
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
@@ -330,34 +330,34 @@ static const struct file_operations fops_rcstat = {
 
 int ath9k_init_debug(struct ath_softc *sc)
 {
-	sc->sc_debug.debug_mask = ath9k_debug;
+	sc->debug.debug_mask = ath9k_debug;
 
-	sc->sc_debug.debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!sc->sc_debug.debugfs_root)
+	sc->debug.debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!sc->debug.debugfs_root)
 		goto err;
 
-	sc->sc_debug.debugfs_phy = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
-						      sc->sc_debug.debugfs_root);
-	if (!sc->sc_debug.debugfs_phy)
+	sc->debug.debugfs_phy = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
+						      sc->debug.debugfs_root);
+	if (!sc->debug.debugfs_phy)
 		goto err;
 
-	sc->sc_debug.debugfs_dma = debugfs_create_file("dma", S_IRUGO,
-				       sc->sc_debug.debugfs_phy, sc, &fops_dma);
-	if (!sc->sc_debug.debugfs_dma)
+	sc->debug.debugfs_dma = debugfs_create_file("dma", S_IRUGO,
+				       sc->debug.debugfs_phy, sc, &fops_dma);
+	if (!sc->debug.debugfs_dma)
 		goto err;
 
-	sc->sc_debug.debugfs_interrupt = debugfs_create_file("interrupt",
+	sc->debug.debugfs_interrupt = debugfs_create_file("interrupt",
 						     S_IRUGO,
-						     sc->sc_debug.debugfs_phy,
+						     sc->debug.debugfs_phy,
 						     sc, &fops_interrupt);
-	if (!sc->sc_debug.debugfs_interrupt)
+	if (!sc->debug.debugfs_interrupt)
 		goto err;
 
-	sc->sc_debug.debugfs_rcstat = debugfs_create_file("rcstat",
+	sc->debug.debugfs_rcstat = debugfs_create_file("rcstat",
 						  S_IRUGO,
-						  sc->sc_debug.debugfs_phy,
+						  sc->debug.debugfs_phy,
 						  sc, &fops_rcstat);
-	if (!sc->sc_debug.debugfs_rcstat)
+	if (!sc->debug.debugfs_rcstat)
 		goto err;
 
 	return 0;
@@ -368,9 +368,9 @@ err:
 
 void ath9k_exit_debug(struct ath_softc *sc)
 {
-	debugfs_remove(sc->sc_debug.debugfs_rcstat);
-	debugfs_remove(sc->sc_debug.debugfs_interrupt);
-	debugfs_remove(sc->sc_debug.debugfs_dma);
-	debugfs_remove(sc->sc_debug.debugfs_phy);
-	debugfs_remove(sc->sc_debug.debugfs_root);
+	debugfs_remove(sc->debug.debugfs_rcstat);
+	debugfs_remove(sc->debug.debugfs_interrupt);
+	debugfs_remove(sc->debug.debugfs_dma);
+	debugfs_remove(sc->debug.debugfs_phy);
+	debugfs_remove(sc->debug.debugfs_root);
 }
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 075ddc5..1a6c5ac 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2158,9 +2158,9 @@ int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	u32 macStaId1;
 	int i, rx_chainmask, r;
 
-	ahp->ah_extprotspacing = sc->sc_ht_extprotspacing;
-	ahp->ah_txchainmask = sc->sc_tx_chainmask;
-	ahp->ah_rxchainmask = sc->sc_rx_chainmask;
+	ahp->ah_extprotspacing = sc->ht_extprotspacing;
+	ahp->ah_txchainmask = sc->tx_chainmask;
+	ahp->ah_rxchainmask = sc->rx_chainmask;
 
 	if (AR_SREV_9285(ah)) {
 		ahp->ah_txchainmask &= 0x1;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2ed0bd2..dacf97a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -140,11 +140,11 @@ static void ath_update_txpow(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	u32 txpow;
 
-	if (sc->sc_curtxpow != sc->sc_config.txpowlimit) {
-		ath9k_hw_set_txpowerlimit(ah, sc->sc_config.txpowlimit);
+	if (sc->curtxpow != sc->config.txpowlimit) {
+		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit);
 		/* read back in case value is clamped */
 		ath9k_hw_getcapability(ah, ATH9K_CAP_TXPOW, 1, &txpow);
-		sc->sc_curtxpow = txpow;
+		sc->curtxpow = txpow;
 	}
 }
 
@@ -294,7 +294,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 	ath_cache_conf_rate(sc, &hw->conf);
 	ath_update_txpow(sc);
-	ath9k_hw_set_interrupts(ah, sc->sc_imask);
+	ath9k_hw_set_interrupts(ah, sc->imask);
 	ath9k_ps_restore(sc);
 	return 0;
 }
@@ -327,42 +327,42 @@ static void ath_ani_calibrate(unsigned long data)
 		return;
 
 	/* Long calibration runs independently of short calibration. */
-	if ((timestamp - sc->sc_ani.sc_longcal_timer) >= ATH_LONG_CALINTERVAL) {
+	if ((timestamp - sc->ani.longcal_timer) >= ATH_LONG_CALINTERVAL) {
 		longcal = true;
 		DPRINTF(sc, ATH_DBG_ANI, "longcal @%lu\n", jiffies);
-		sc->sc_ani.sc_longcal_timer = timestamp;
+		sc->ani.longcal_timer = timestamp;
 	}
 
-	/* Short calibration applies only while sc_caldone is false */
-	if (!sc->sc_ani.sc_caldone) {
-		if ((timestamp - sc->sc_ani.sc_shortcal_timer) >=
+	/* Short calibration applies only while caldone is false */
+	if (!sc->ani.caldone) {
+		if ((timestamp - sc->ani.shortcal_timer) >=
 		    ATH_SHORT_CALINTERVAL) {
 			shortcal = true;
 			DPRINTF(sc, ATH_DBG_ANI, "shortcal @%lu\n", jiffies);
-			sc->sc_ani.sc_shortcal_timer = timestamp;
-			sc->sc_ani.sc_resetcal_timer = timestamp;
+			sc->ani.shortcal_timer = timestamp;
+			sc->ani.resetcal_timer = timestamp;
 		}
 	} else {
-		if ((timestamp - sc->sc_ani.sc_resetcal_timer) >=
+		if ((timestamp - sc->ani.resetcal_timer) >=
 		    ATH_RESTART_CALINTERVAL) {
-			sc->sc_ani.sc_caldone = ath9k_hw_reset_calvalid(ah);
-			if (sc->sc_ani.sc_caldone)
-				sc->sc_ani.sc_resetcal_timer = timestamp;
+			sc->ani.caldone = ath9k_hw_reset_calvalid(ah);
+			if (sc->ani.caldone)
+				sc->ani.resetcal_timer = timestamp;
 		}
 	}
 
 	/* Verify whether we must check ANI */
-	if ((timestamp - sc->sc_ani.sc_checkani_timer) >=
+	if ((timestamp - sc->ani.checkani_timer) >=
 	   ATH_ANI_POLLINTERVAL) {
 		aniflag = true;
-		sc->sc_ani.sc_checkani_timer = timestamp;
+		sc->ani.checkani_timer = timestamp;
 	}
 
 	/* Skip all processing if there's nothing to do. */
 	if (longcal || shortcal || aniflag) {
 		/* Call ANI routine if necessary */
 		if (aniflag)
-			ath9k_hw_ani_monitor(ah, &sc->sc_halstats,
+			ath9k_hw_ani_monitor(ah, &sc->nodestats,
 					     ah->ah_curchan);
 
 		/* Perform calibration if necessary */
@@ -370,10 +370,10 @@ static void ath_ani_calibrate(unsigned long data)
 			bool iscaldone = false;
 
 			if (ath9k_hw_calibrate(ah, ah->ah_curchan,
-					       sc->sc_rx_chainmask, longcal,
+					       sc->rx_chainmask, longcal,
 					       &iscaldone)) {
 				if (longcal)
-					sc->sc_ani.sc_noise_floor =
+					sc->ani.noise_floor =
 						ath9k_hw_getchan_noise(ah,
 							       ah->ah_curchan);
 
@@ -381,14 +381,14 @@ static void ath_ani_calibrate(unsigned long data)
 					"calibrate chan %u/%x nf: %d\n",
 					ah->ah_curchan->channel,
 					ah->ah_curchan->channelFlags,
-					sc->sc_ani.sc_noise_floor);
+					sc->ani.noise_floor);
 			} else {
 				DPRINTF(sc, ATH_DBG_ANY,
 					"calibrate chan %u/%x failed\n",
 					ah->ah_curchan->channel,
 					ah->ah_curchan->channelFlags);
 			}
-			sc->sc_ani.sc_caldone = iscaldone;
+			sc->ani.caldone = iscaldone;
 		}
 	}
 
@@ -400,10 +400,10 @@ static void ath_ani_calibrate(unsigned long data)
 	cal_interval = ATH_LONG_CALINTERVAL;
 	if (sc->sc_ah->ah_config.enable_ani)
 		cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
-	if (!sc->sc_ani.sc_caldone)
+	if (!sc->ani.caldone)
 		cal_interval = min(cal_interval, (u32)ATH_SHORT_CALINTERVAL);
 
-	mod_timer(&sc->sc_ani.timer, jiffies + msecs_to_jiffies(cal_interval));
+	mod_timer(&sc->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 }
 
 /*
@@ -417,15 +417,15 @@ static void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 	sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
 	if (is_ht ||
 	    (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_BT_COEX)) {
-		sc->sc_tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
-		sc->sc_rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
+		sc->tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
+		sc->rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
 	} else {
-		sc->sc_tx_chainmask = 1;
-		sc->sc_rx_chainmask = 1;
+		sc->tx_chainmask = 1;
+		sc->rx_chainmask = 1;
 	}
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "tx chmask: %d, rx chmask: %d\n",
-		sc->sc_tx_chainmask, sc->sc_rx_chainmask);
+		sc->tx_chainmask, sc->rx_chainmask);
 }
 
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
@@ -453,7 +453,7 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 static void ath9k_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
-	u32 status = sc->sc_intrstatus;
+	u32 status = sc->intrstatus;
 
 	if (status & ATH9K_INT_FATAL) {
 		/* need a chip reset */
@@ -473,7 +473,7 @@ static void ath9k_tasklet(unsigned long data)
 	}
 
 	/* re-enable hardware interrupt */
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 }
 
 irqreturn_t ath_isr(int irq, void *dev)
@@ -504,7 +504,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		 */
 		ath9k_hw_getisr(ah, &status);	/* NB: clears ISR too */
 
-		status &= sc->sc_imask;	/* discard unasked-for bits */
+		status &= sc->imask;	/* discard unasked-for bits */
 
 		/*
 		 * If there are no status bits set, then this interrupt was not
@@ -513,7 +513,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		if (!status)
 			return IRQ_NONE;
 
-		sc->sc_intrstatus = status;
+		sc->intrstatus = status;
 
 		if (status & ATH9K_INT_FATAL) {
 			/* need a chip reset */
@@ -560,8 +560,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 				 * it will clear whatever condition caused
 				 * the interrupt.
 				 */
-				ath9k_hw_procmibevent(ah, &sc->sc_halstats);
-				ath9k_hw_set_interrupts(ah, sc->sc_imask);
+				ath9k_hw_procmibevent(ah, &sc->nodestats);
+				ath9k_hw_set_interrupts(ah, sc->imask);
 			}
 			if (status & ATH9K_INT_TIM_TIMER) {
 				if (!(ah->ah_caps.hw_caps &
@@ -581,7 +581,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 	if (sched) {
 		/* turn off every interrupt except SWBA */
-		ath9k_hw_set_interrupts(ah, (sc->sc_imask & ATH9K_INT_SWBA));
+		ath9k_hw_set_interrupts(ah, (sc->imask & ATH9K_INT_SWBA));
 		tasklet_schedule(&sc->intr_tq);
 	}
 
@@ -656,7 +656,7 @@ static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
 		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 		return ath_keyset(sc, keyix, hk, addr);
 	}
-	if (!sc->sc_splitmic) {
+	if (!sc->splitmic) {
 		/*
 		 * data key goes at first index,
 		 * the hal handles the MIC keys at index+64.
@@ -686,13 +686,13 @@ static int ath_reserve_key_cache_slot_tkip(struct ath_softc *sc)
 {
 	int i;
 
-	for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax / 2; i++) {
-		if (test_bit(i, sc->sc_keymap) ||
-		    test_bit(i + 64, sc->sc_keymap))
+	for (i = IEEE80211_WEP_NKID; i < sc->keymax / 2; i++) {
+		if (test_bit(i, sc->keymap) ||
+		    test_bit(i + 64, sc->keymap))
 			continue; /* At least one part of TKIP key allocated */
-		if (sc->sc_splitmic &&
-		    (test_bit(i + 32, sc->sc_keymap) ||
-		     test_bit(i + 64 + 32, sc->sc_keymap)))
+		if (sc->splitmic &&
+		    (test_bit(i + 32, sc->keymap) ||
+		     test_bit(i + 64 + 32, sc->keymap)))
 			continue; /* At least one part of TKIP key allocated */
 
 		/* Found a free slot for a TKIP key */
@@ -706,55 +706,55 @@ static int ath_reserve_key_cache_slot(struct ath_softc *sc)
 	int i;
 
 	/* First, try to find slots that would not be available for TKIP. */
-	if (sc->sc_splitmic) {
-		for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax / 4; i++) {
-			if (!test_bit(i, sc->sc_keymap) &&
-			    (test_bit(i + 32, sc->sc_keymap) ||
-			     test_bit(i + 64, sc->sc_keymap) ||
-			     test_bit(i + 64 + 32, sc->sc_keymap)))
+	if (sc->splitmic) {
+		for (i = IEEE80211_WEP_NKID; i < sc->keymax / 4; i++) {
+			if (!test_bit(i, sc->keymap) &&
+			    (test_bit(i + 32, sc->keymap) ||
+			     test_bit(i + 64, sc->keymap) ||
+			     test_bit(i + 64 + 32, sc->keymap)))
 				return i;
-			if (!test_bit(i + 32, sc->sc_keymap) &&
-			    (test_bit(i, sc->sc_keymap) ||
-			     test_bit(i + 64, sc->sc_keymap) ||
-			     test_bit(i + 64 + 32, sc->sc_keymap)))
+			if (!test_bit(i + 32, sc->keymap) &&
+			    (test_bit(i, sc->keymap) ||
+			     test_bit(i + 64, sc->keymap) ||
+			     test_bit(i + 64 + 32, sc->keymap)))
 				return i + 32;
-			if (!test_bit(i + 64, sc->sc_keymap) &&
-			    (test_bit(i , sc->sc_keymap) ||
-			     test_bit(i + 32, sc->sc_keymap) ||
-			     test_bit(i + 64 + 32, sc->sc_keymap)))
+			if (!test_bit(i + 64, sc->keymap) &&
+			    (test_bit(i , sc->keymap) ||
+			     test_bit(i + 32, sc->keymap) ||
+			     test_bit(i + 64 + 32, sc->keymap)))
 				return i + 64;
-			if (!test_bit(i + 64 + 32, sc->sc_keymap) &&
-			    (test_bit(i, sc->sc_keymap) ||
-			     test_bit(i + 32, sc->sc_keymap) ||
-			     test_bit(i + 64, sc->sc_keymap)))
+			if (!test_bit(i + 64 + 32, sc->keymap) &&
+			    (test_bit(i, sc->keymap) ||
+			     test_bit(i + 32, sc->keymap) ||
+			     test_bit(i + 64, sc->keymap)))
 				return i + 64 + 32;
 		}
 	} else {
-		for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax / 2; i++) {
-			if (!test_bit(i, sc->sc_keymap) &&
-			    test_bit(i + 64, sc->sc_keymap))
+		for (i = IEEE80211_WEP_NKID; i < sc->keymax / 2; i++) {
+			if (!test_bit(i, sc->keymap) &&
+			    test_bit(i + 64, sc->keymap))
 				return i;
-			if (test_bit(i, sc->sc_keymap) &&
-			    !test_bit(i + 64, sc->sc_keymap))
+			if (test_bit(i, sc->keymap) &&
+			    !test_bit(i + 64, sc->keymap))
 				return i + 64;
 		}
 	}
 
 	/* No partially used TKIP slots, pick any available slot */
-	for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax; i++) {
+	for (i = IEEE80211_WEP_NKID; i < sc->keymax; i++) {
 		/* Do not allow slots that could be needed for TKIP group keys
 		 * to be used. This limitation could be removed if we know that
 		 * TKIP will not be used. */
 		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
 			continue;
-		if (sc->sc_splitmic) {
+		if (sc->splitmic) {
 			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
 				continue;
 			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
 				continue;
 		}
 
-		if (!test_bit(i, sc->sc_keymap))
+		if (!test_bit(i, sc->keymap))
 			return i; /* Found a free slot for a key */
 	}
 
@@ -801,7 +801,7 @@ static int ath_key_config(struct ath_softc *sc,
 			return -EOPNOTSUPP;
 		mac = sta->addr;
 
-		vif = sc->sc_vaps[0];
+		vif = sc->vifs[0];
 		if (vif->type != NL80211_IFTYPE_AP) {
 			/* Only keyidx 0 should be used with unicast key, but
 			 * allow this for client mode for now. */
@@ -829,12 +829,12 @@ static int ath_key_config(struct ath_softc *sc,
 	if (!ret)
 		return -EIO;
 
-	set_bit(idx, sc->sc_keymap);
+	set_bit(idx, sc->keymap);
 	if (key->alg == ALG_TKIP) {
-		set_bit(idx + 64, sc->sc_keymap);
-		if (sc->sc_splitmic) {
-			set_bit(idx + 32, sc->sc_keymap);
-			set_bit(idx + 64 + 32, sc->sc_keymap);
+		set_bit(idx + 64, sc->keymap);
+		if (sc->splitmic) {
+			set_bit(idx + 32, sc->keymap);
+			set_bit(idx + 64 + 32, sc->keymap);
 		}
 	}
 
@@ -847,14 +847,14 @@ static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 	if (key->hw_key_idx < IEEE80211_WEP_NKID)
 		return;
 
-	clear_bit(key->hw_key_idx, sc->sc_keymap);
+	clear_bit(key->hw_key_idx, sc->keymap);
 	if (key->alg != ALG_TKIP)
 		return;
 
-	clear_bit(key->hw_key_idx + 64, sc->sc_keymap);
-	if (sc->sc_splitmic) {
-		clear_bit(key->hw_key_idx + 32, sc->sc_keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, sc->sc_keymap);
+	clear_bit(key->hw_key_idx + 64, sc->keymap);
+	if (sc->splitmic) {
+		clear_bit(key->hw_key_idx + 32, sc->keymap);
+		clear_bit(key->hw_key_idx + 64 + 32, sc->keymap);
 	}
 }
 
@@ -876,7 +876,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
 
-	switch(sc->sc_rx_chainmask) {
+	switch(sc->rx_chainmask) {
 	case 1:
 		ht_info->mcs.rx_mask[0] = 0xff;
 		break;
@@ -896,17 +896,17 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *bss_conf)
 {
-	struct ath_vap *avp = (void *)vif->drv_priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	if (bss_conf->assoc) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
-			bss_conf->aid, sc->sc_curbssid);
+			bss_conf->aid, sc->curbssid);
 
 		/* New association, store aid */
 		if (avp->av_opmode == NL80211_IFTYPE_STATION) {
-			sc->sc_curaid = bss_conf->aid;
-			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
-					       sc->sc_curaid);
+			sc->curaid = bss_conf->aid;
+			ath9k_hw_write_associd(sc->sc_ah, sc->curbssid,
+					       sc->curaid);
 		}
 
 		/* Configure the beacon */
@@ -914,18 +914,18 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		sc->sc_flags |= SC_OP_BEACONS;
 
 		/* Reset rssi stats */
-		sc->sc_halstats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_halstats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
+		sc->nodestats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->nodestats.ns_avgrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->nodestats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
+		sc->nodestats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
 
 		/* Start ANI */
-		mod_timer(&sc->sc_ani.timer,
+		mod_timer(&sc->ani.timer,
 			jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISSOC\n");
-		sc->sc_curaid = 0;
+		sc->curaid = 0;
 	}
 }
 
@@ -1120,7 +1120,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
 
 	/* Re-Enable  interrupts */
-	ath9k_hw_set_interrupts(ah, sc->sc_imask);
+	ath9k_hw_set_interrupts(ah, sc->imask);
 
 	/* Enable LED */
 	ath9k_hw_cfg_output(ah, ATH_LED_PIN,
@@ -1369,7 +1369,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	 */
 	ath_read_cachesize(sc, &csz);
 	/* XXX assert csz is non-zero */
-	sc->sc_cachelsz = csz << 2;	/* convert to bytes */
+	sc->cachelsz = csz << 2;	/* convert to bytes */
 
 	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
 	if (ah == NULL) {
@@ -1381,19 +1381,19 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_ah = ah;
 
 	/* Get the hardware key cache size. */
-	sc->sc_keymax = ah->ah_caps.keycache_size;
-	if (sc->sc_keymax > ATH_KEYMAX) {
+	sc->keymax = ah->ah_caps.keycache_size;
+	if (sc->keymax > ATH_KEYMAX) {
 		DPRINTF(sc, ATH_DBG_KEYCACHE,
 			"Warning, using only %u entries in %u key cache\n",
-			ATH_KEYMAX, sc->sc_keymax);
-		sc->sc_keymax = ATH_KEYMAX;
+			ATH_KEYMAX, sc->keymax);
+		sc->keymax = ATH_KEYMAX;
 	}
 
 	/*
 	 * Reset the key cache since some parts do not
 	 * reset the contents on initial power up.
 	 */
-	for (i = 0; i < sc->sc_keymax; i++)
+	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
 	if (ath9k_regd_init(sc->sc_ah))
@@ -1429,7 +1429,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
-	sc->sc_config.cabqReadytime = ATH_CABQ_READY_TIME;
+	sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
 	ath_cabq_update(sc);
 
 	for (i = 0; i < ARRAY_SIZE(sc->tx.hwq_map); i++)
@@ -1466,8 +1466,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* Initializes the noise floor to a reasonable default value.
 	 * Later on this will be updated during ANI processing. */
 
-	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
-	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
+	sc->ani.noise_floor = ATH_DEFAULT_NOISE_FLOOR;
+	setup_timer(&sc->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
 				   ATH9K_CIPHER_TKIP, NULL)) {
@@ -1493,14 +1493,14 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 				      ATH9K_CIPHER_MIC, NULL)
 	    && ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
 				      0, NULL))
-		sc->sc_splitmic = 1;
+		sc->splitmic = 1;
 
 	/* turn on mcast key search if possible */
 	if (!ath9k_hw_getcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
 		(void)ath9k_hw_setcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 1,
 					     1, NULL);
 
-	sc->sc_config.txpowlimit = ATH_TXPOWER_MAX;
+	sc->config.txpowlimit = ATH_TXPOWER_MAX;
 
 	/* 11n Capabilities */
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
@@ -1508,17 +1508,17 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
-	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
-	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
+	sc->tx_chainmask = ah->ah_caps.tx_chainmask;
+	sc->rx_chainmask = ah->ah_caps.rx_chainmask;
 
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->rx.defant = ath9k_hw_getdefantenna(ah);
 
-	ath9k_hw_getmac(ah, sc->sc_myaddr);
+	ath9k_hw_getmac(ah, sc->macaddr);
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
-		ath9k_hw_getbssidmask(ah, sc->sc_bssidmask);
-		ATH_SET_VAP_BSSID_MASK(sc->sc_bssidmask);
-		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
+		ath9k_hw_getbssidmask(ah, sc->bssidmask);
+		ATH_SET_VIF_BSSID_MASK(sc->bssidmask);
+		ath9k_hw_setbssidmask(ah, sc->bssidmask);
 	}
 
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
@@ -1528,7 +1528,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		sc->beacon.bslot[i] = ATH_IF_ID_ANY;
 
 	/* save MISC configurations */
-	sc->sc_config.swBeaconProcess = 1;
+	sc->config.swBeaconProcess = 1;
 
 	/* setup channels and rates */
 
@@ -1577,7 +1577,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	/* get mac address from hardware and set in mac80211 */
 
-	SET_IEEE80211_PERM_ADDR(hw, sc->sc_myaddr);
+	SET_IEEE80211_PERM_ADDR(hw, sc->macaddr);
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
@@ -1601,7 +1601,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	hw->max_rates = 4;
 	hw->max_rate_tries = ATH_11N_TXMAXTRY;
 	hw->sta_data_size = sizeof(struct ath_node);
-	hw->vif_data_size = sizeof(struct ath_vap);
+	hw->vif_data_size = sizeof(struct ath_vif);
 
 	hw->rate_control_algorithm = "ath9k_rate_control";
 
@@ -1704,7 +1704,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
 
-	ath9k_hw_set_interrupts(ah, sc->sc_imask);
+	ath9k_hw_set_interrupts(ah, sc->imask);
 
 	if (retry_tx) {
 		int i;
@@ -1987,23 +1987,23 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	}
 
 	/* Setup our intr mask. */
-	sc->sc_imask = ATH9K_INT_RX | ATH9K_INT_TX
+	sc->imask = ATH9K_INT_RX | ATH9K_INT_TX
 		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
 		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
 
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_GTT)
-		sc->sc_imask |= ATH9K_INT_GTT;
+		sc->imask |= ATH9K_INT_GTT;
 
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
-		sc->sc_imask |= ATH9K_INT_CST;
+		sc->imask |= ATH9K_INT_CST;
 
 	ath_cache_conf_rate(sc, &hw->conf);
 
 	sc->sc_flags &= ~SC_OP_INVALID;
 
 	/* Disable BMISS interrupt when we're not associated */
-	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
+	sc->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
 	ieee80211_wake_queues(sc->hw);
 
@@ -2112,12 +2112,12 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_if_init_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_vap *avp = (void *)conf->vif->drv_priv;
+	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
 
-	/* Support only vap for now */
+	/* Support only vif for now */
 
-	if (sc->sc_nvaps)
+	if (sc->nvifs)
 		return -ENOBUFS;
 
 	mutex_lock(&sc->mutex);
@@ -2138,17 +2138,17 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Attach a VAP of type: %d\n", ic_opmode);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Attach a VIF of type: %d\n", ic_opmode);
 
-	/* Set the VAP opmode */
+	/* Set the VIF opmode */
 	avp->av_opmode = ic_opmode;
 	avp->av_bslot = -1;
 
 	if (ic_opmode == NL80211_IFTYPE_AP)
 		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
 
-	sc->sc_vaps[0] = conf->vif;
-	sc->sc_nvaps++;
+	sc->vifs[0] = conf->vif;
+	sc->nvifs++;
 
 	/* Set the device opmode */
 	sc->sc_ah->ah_opmode = ic_opmode;
@@ -2160,7 +2160,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if (ath9k_hw_phycounters(sc->sc_ah) &&
 	    ((conf->type == NL80211_IFTYPE_STATION) ||
 	     (conf->type == NL80211_IFTYPE_ADHOC)))
-		sc->sc_imask |= ATH9K_INT_MIB;
+		sc->imask |= ATH9K_INT_MIB;
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
@@ -2169,15 +2169,15 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	 */
 	if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
 	    (conf->type == NL80211_IFTYPE_STATION) &&
-	    !sc->sc_config.swBeaconProcess)
-		sc->sc_imask |= ATH9K_INT_TIM;
+	    !sc->config.swBeaconProcess)
+		sc->imask |= ATH9K_INT_TIM;
 
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
 	if (conf->type == NL80211_IFTYPE_AP) {
 		/* TODO: is this a suitable place to start ANI for AP mode? */
 		/* Start ANI */
-		mod_timer(&sc->sc_ani.timer,
+		mod_timer(&sc->ani.timer,
 			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 	}
 
@@ -2190,14 +2190,14 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_if_init_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_vap *avp = (void *)conf->vif->drv_priv;
+	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach Interface\n");
 
 	mutex_lock(&sc->mutex);
 
 	/* Stop ANI */
-	del_timer_sync(&sc->sc_ani.timer);
+	del_timer_sync(&sc->ani.timer);
 
 	/* Reclaim beacon resources */
 	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP ||
@@ -2208,8 +2208,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
-	sc->sc_vaps[0] = NULL;
-	sc->sc_nvaps--;
+	sc->vifs[0] = NULL;
+	sc->nvifs--;
 
 	mutex_unlock(&sc->mutex);
 }
@@ -2223,10 +2223,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
-			if ((sc->sc_imask & ATH9K_INT_TIM_TIMER) == 0) {
-				sc->sc_imask |= ATH9K_INT_TIM_TIMER;
+			if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
+				sc->imask |= ATH9K_INT_TIM_TIMER;
 				ath9k_hw_set_interrupts(sc->sc_ah,
-						sc->sc_imask);
+						sc->imask);
 			}
 			ath9k_hw_setrxabort(sc->sc_ah, 1);
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
@@ -2234,10 +2234,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 			ath9k_hw_setrxabort(sc->sc_ah, 0);
 			sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
-			if (sc->sc_imask & ATH9K_INT_TIM_TIMER) {
-				sc->sc_imask &= ~ATH9K_INT_TIM_TIMER;
+			if (sc->imask & ATH9K_INT_TIM_TIMER) {
+				sc->imask &= ~ATH9K_INT_TIM_TIMER;
 				ath9k_hw_set_interrupts(sc->sc_ah,
-						sc->sc_imask);
+						sc->imask);
 			}
 		}
 	}
@@ -2262,7 +2262,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
-		sc->sc_config.txpowlimit = 2 * conf->power_level;
+		sc->config.txpowlimit = 2 * conf->power_level;
 
 	mutex_unlock(&sc->mutex);
 
@@ -2275,7 +2275,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hal *ah = sc->sc_ah;
-	struct ath_vap *avp = (void *)vif->drv_priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 	u32 rfilt = 0;
 	int error, i;
 
@@ -2285,7 +2285,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	    ah->ah_opmode != NL80211_IFTYPE_AP) {
 		ah->ah_opmode = NL80211_IFTYPE_STATION;
 		ath9k_hw_setopmode(ah);
-		ath9k_hw_write_associd(ah, sc->sc_myaddr, 0);
+		ath9k_hw_write_associd(ah, sc->macaddr, 0);
 		/* Request full reset to get hw opmode changed properly */
 		sc->sc_flags |= SC_OP_FULL_RESET;
 	}
@@ -2296,17 +2296,17 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_ADHOC:
 			/* Set BSSID */
-			memcpy(sc->sc_curbssid, conf->bssid, ETH_ALEN);
-			sc->sc_curaid = 0;
-			ath9k_hw_write_associd(sc->sc_ah, sc->sc_curbssid,
-					       sc->sc_curaid);
+			memcpy(sc->curbssid, conf->bssid, ETH_ALEN);
+			sc->curaid = 0;
+			ath9k_hw_write_associd(sc->sc_ah, sc->curbssid,
+					       sc->curaid);
 
 			/* Set aggregation protection mode parameters */
-			sc->sc_config.ath_aggr_prot = 0;
+			sc->config.ath_aggr_prot = 0;
 
 			DPRINTF(sc, ATH_DBG_CONFIG,
 				"RX filter 0x%x bssid %pM aid 0x%x\n",
-				rfilt, sc->sc_curbssid, sc->sc_curaid);
+				rfilt, sc->curbssid, sc->curaid);
 
 			/* need to reconfigure the beacon */
 			sc->sc_flags &= ~SC_OP_BEACONS ;
@@ -2346,7 +2346,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
 				ath9k_hw_keysetmac(sc->sc_ah,
 						   (u16)i,
-						   sc->sc_curbssid);
+						   sc->curbssid);
 	}
 
 	/* Only legacy IBSS for now */
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 69dd5e2..e8e4a32 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -97,11 +97,11 @@ static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
 	 * Unfortunately this means we may get 8 KB here from the
 	 * kernel... and that is actually what is observed on some
 	 * systems :( */
-	skb = dev_alloc_skb(len + sc->sc_cachelsz - 1);
+	skb = dev_alloc_skb(len + sc->cachelsz - 1);
 	if (skb != NULL) {
-		off = ((unsigned long) skb->data) % sc->sc_cachelsz;
+		off = ((unsigned long) skb->data) % sc->cachelsz;
 		if (off != 0)
-			skb_reserve(skb, sc->sc_cachelsz - off);
+			skb_reserve(skb, sc->cachelsz - off);
 	} else {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"skbuff alloc of size %u failed\n", len);
@@ -210,7 +210,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
 	rx_status->band = sc->hw->conf.channel->band;
 	rx_status->freq =  sc->hw->conf.channel->center_freq;
-	rx_status->noise = sc->sc_ani.sc_noise_floor;
+	rx_status->noise = sc->ani.noise_floor;
 	rx_status->signal = rx_status->noise + ds->ds_rxstat.rs_rssi;
 	rx_status->antenna = ds->ds_rxstat.rs_antenna;
 
@@ -242,13 +242,13 @@ static void ath_opmode_init(struct ath_softc *sc)
 
 	/* configure bssid mask */
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
+		ath9k_hw_setbssidmask(ah, sc->bssidmask);
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
 
 	/* Handle any link-level address change. */
-	ath9k_hw_setmac(ah, sc->sc_myaddr);
+	ath9k_hw_setmac(ah, sc->macaddr);
 
 	/* calculate and install multicast filter */
 	mfilt[0] = mfilt[1] = ~0;
@@ -267,11 +267,11 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		spin_lock_init(&sc->rx.rxbuflock);
 
 		sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
-					   min(sc->sc_cachelsz,
+					   min(sc->cachelsz,
 					       (u16)64));
 
 		DPRINTF(sc, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-			sc->sc_cachelsz, sc->rx.bufsize);
+			sc->cachelsz, sc->rx.bufsize);
 
 		/* Initialize rx descriptors */
 
@@ -593,7 +593,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			   && !decrypt_error && skb->len >= hdrlen + 4) {
 			keyix = skb->data[hdrlen + 3] >> 6;
 
-			if (test_bit(keyix, sc->sc_keymap))
+			if (test_bit(keyix, sc->keymap))
 				rx_status.flag |= RX_FLAG_DECRYPTED;
 		}
 		if (ah->sw_mgmt_crypto &&
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 7a3ea92..7773760 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -970,14 +970,14 @@ int ath_cabq_update(struct ath_softc *sc)
 	/*
 	 * Ensure the readytime % is within the bounds.
 	 */
-	if (sc->sc_config.cabqReadytime < ATH9K_READY_TIME_LO_BOUND)
-		sc->sc_config.cabqReadytime = ATH9K_READY_TIME_LO_BOUND;
-	else if (sc->sc_config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
-		sc->sc_config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
+	if (sc->config.cabqReadytime < ATH9K_READY_TIME_LO_BOUND)
+		sc->config.cabqReadytime = ATH9K_READY_TIME_LO_BOUND;
+	else if (sc->config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
+		sc->config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
 	ath_get_beaconconfig(sc, ATH_IF_ID_ANY, &conf);
 	qi.tqi_readyTime =
-		(conf.beacon_interval * sc->sc_config.cabqReadytime) / 100;
+		(conf.beacon_interval * sc->config.cabqReadytime) / 100;
 	ath_txq_update(sc, qnum, &qi);
 
 	return 0;
@@ -1471,7 +1471,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		flags = ATH9K_TXDESC_RTSENA;
 
 	/* FIXME: Handle aggregation protection */
-	if (sc->sc_config.ath_aggr_prot &&
+	if (sc->config.ath_aggr_prot &&
 	    (!bf_isaggr(bf) || (bf_isaggr(bf) && bf->bf_al < 8192))) {
 		flags = ATH9K_TXDESC_RTSENA;
 	}
@@ -1486,7 +1486,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 
 		rix = rates[i].idx;
 		series[i].Tries = rates[i].count;
-		series[i].ChSel = sc->sc_tx_chainmask;
+		series[i].ChSel = sc->tx_chainmask;
 
 		if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 			series[i].Rate = rt->info[rix].ratecode |
@@ -1513,7 +1513,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 				     !is_pspoll, ctsrate,
 				     0, series, 4, flags);
 
-	if (sc->sc_config.ath_aggr_prot && flags)
+	if (sc->config.ath_aggr_prot && flags)
 		ath9k_hw_set11n_burstduration(sc->sc_ah, bf->bf_desc, 8192);
 }
 
-- 
1.6.1

