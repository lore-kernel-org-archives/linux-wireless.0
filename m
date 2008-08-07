Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54271 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbYHGFfh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:35:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:35:37 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18586.34551.769609.86393@localhost.localdomain> (sfid-20080807_073541_464680_AE8A5D26)
Date: Thu, 7 Aug 2008 10:54:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/6] ath9k: Remove a few unused macros and fix indentation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |  275 +++++++++++++++++-------------------
 1 files changed, 130 insertions(+), 145 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 903bd46..e294c1b 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -51,24 +51,24 @@ struct ath_node;
 
 /* Macro to expand scalars to 64-bit objects */
 
-#define	ito64(x) (sizeof(x) == 8) ? \
-	(((unsigned long long int)(x)) & (0xff)) : \
-	(sizeof(x) == 16) ? \
-	(((unsigned long long int)(x)) & 0xffff) : \
-	((sizeof(x) == 32) ?			\
+#define	ito64(x) (sizeof(x) == 8) ?			\
+	(((unsigned long long int)(x)) & (0xff)) :	\
+	(sizeof(x) == 16) ?				\
+	(((unsigned long long int)(x)) & 0xffff) :	\
+	((sizeof(x) == 32) ?				\
 	 (((unsigned long long int)(x)) & 0xffffffff) : \
-	(unsigned long long int)(x))
+	 (unsigned long long int)(x))
 
 /* increment with wrap-around */
-#define INCR(_l, _sz)   do { \
-	(_l)++; \
-	(_l) &= ((_sz) - 1); \
+#define INCR(_l, _sz)   do {			\
+		(_l)++;				\
+		(_l) &= ((_sz) - 1);		\
 	} while (0)
 
 /* decrement with wrap-around */
-#define DECR(_l,  _sz)  do { \
-	(_l)--; \
-	(_l) &= ((_sz) - 1); \
+#define DECR(_l,  _sz)  do {			\
+		(_l)--;				\
+		(_l) &= ((_sz) - 1);		\
 	} while (0)
 
 #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
@@ -136,12 +136,11 @@ enum ATH_DEBUG {
 /* Per-instance load-time (note: NOT run-time) configurations
  * for Atheros Device */
 struct ath_config {
-	u32   ath_aggr_prot;
-	u16   txpowlimit;
-	u16   txpowlimit_override;
-	u8    cabqReadytime; /* Cabq Readytime % */
-	u8    swBeaconProcess; /* Process received beacons
-					in SW (vs HW) */
+	u32 ath_aggr_prot;
+	u16 txpowlimit;
+	u16 txpowlimit_override;
+	u8 cabqReadytime; /* Cabq Readytime % */
+	u8 swBeaconProcess; /* Process received beacons in SW (vs HW) */
 };
 
 /***********************/
@@ -161,12 +160,12 @@ struct ath_config {
 #define ATH_CHAINMASK_SEL_DOWN_RSSI_THRES  35
 /* Struct to store the chainmask select related info */
 struct ath_chainmask_sel {
-	struct timer_list   timer;
-	int                 cur_tx_mask; 	/* user configured or 3x3 */
-	int                 cur_rx_mask; 	/* user configured or 3x3 */
-	int                 tx_avgrssi;
-	u8                  switch_allowed:1, 	/* timer will set this */
-			    cm_sel_enabled:1;
+	struct timer_list timer;
+	int cur_tx_mask; 	/* user configured or 3x3 */
+	int cur_rx_mask; 	/* user configured or 3x3 */
+	int tx_avgrssi;
+	u8 switch_allowed:1, 	/* timer will set this */
+	   cm_sel_enabled : 1;
 };
 
 int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an);
@@ -192,8 +191,8 @@ chains is due to FF aggregation in the driver. */
 
 struct ath_buf_state {
 	int bfs_nframes;	/* # frames in aggregate */
-	u16 bfs_al;	/* length of aggregate */
-	u16 bfs_frmlen;	/* length of frame */
+	u16 bfs_al;		/* length of aggregate */
+	u16 bfs_frmlen;		/* length of frame */
 	int bfs_seqno;		/* sequence number */
 	int bfs_tidno;		/* tid of this frame */
 	int bfs_retries;	/* current retries */
@@ -205,7 +204,7 @@ struct ath_buf_state {
 	u8 bfs_isretried:1;	/* is retried */
 	u8 bfs_isxretried:1;	/* is excessive retried */
 	u8 bfs_shpreamble:1;	/* is short preamble */
-	u8 bfs_isbar:1;	/* is a BAR */
+	u8 bfs_isbar:1;		/* is a BAR */
 	u8 bfs_ispspoll:1;	/* is a PS-Poll */
 	u8 bfs_aggrburst:1;	/* is a aggr burst */
 	u8 bfs_calcairtime:1;	/* requests airtime be calculated
@@ -247,7 +246,7 @@ struct ath_buf {
 	struct list_head list;
 	struct list_head *last;
 	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
-					an aggregate) */
+					   an aggregate) */
 	struct ath_buf *bf_lastfrm;	/* last buf of this frame */
 	struct ath_buf *bf_next;	/* next subframe in the aggregate */
 	struct ath_buf *bf_rifslast;	/* last buf for RIFS burst */
@@ -257,7 +256,7 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	u32 bf_status;
-	u16 bf_flags;		/* tx descriptor flags */
+	u16 bf_flags;			/* tx descriptor flags */
 	struct ath_buf_state bf_state;	/* buffer state */
 	dma_addr_t bf_dmacontext;
 };
@@ -331,8 +330,8 @@ struct ath_recv_status {
 	int8_t rssictl[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
 	int8_t rssiextn[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
 	int8_t abs_rssi;	/* absolute RSSI */
-	u8 rateieee;	/* data rate received (IEEE rate code) */
-	u8 ratecode;	/* phy rate code */
+	u8 rateieee;		/* data rate received (IEEE rate code) */
+	u8 ratecode;		/* phy rate code */
 	int rateKbps;		/* data rate received (Kbps) */
 	int antenna;		/* rx antenna */
 	int flags;		/* status of associated skb */
@@ -351,28 +350,28 @@ struct ath_recv_status {
 };
 
 struct ath_rxbuf {
-	struct sk_buff         		*rx_wbuf; /* buffer */
-	unsigned long               	rx_time; /* system time when received */
-	struct ath_recv_status   	rx_status; /* cached rx status */
+	struct sk_buff *rx_wbuf;
+	unsigned long rx_time;			/* system time when received */
+	struct ath_recv_status rx_status;	/* cached rx status */
 };
 
 /* Per-TID aggregate receiver state for a node */
 struct ath_arx_tid {
-	struct ath_node     *an;        /* parent ath node */
-	struct ath_rxbuf    *rxbuf; 	/* re-ordering buffer */
-	struct timer_list   timer;
-	spinlock_t          tidlock;    /* lock to protect this TID structure */
-	int                 baw_head;   /* seq_next at head */
-	int                 baw_tail;   /* tail of block-ack window */
-	int                 seq_reset;  /* need to reset start sequence */
-	int         	    addba_exchangecomplete;
-	u16           seq_next;   /* next expected sequence */
-	u16           baw_size;   /* block-ack window size */
+	struct ath_node *an;
+	struct ath_rxbuf *rxbuf;	/* re-ordering buffer */
+	struct timer_list timer;
+	spinlock_t tidlock;
+	int baw_head;			/* seq_next at head */
+	int baw_tail;			/* tail of block-ack window */
+	int seq_reset;			/* need to reset start sequence */
+	int addba_exchangecomplete;
+	u16 seq_next;			/* next expected sequence */
+	u16 baw_size;			/* block-ack window size */
 };
 
 /* Per-node receiver aggregate state */
 struct ath_arx {
-	struct ath_arx_tid  tid[WME_NUM_TID];
+	struct ath_arx_tid tid[WME_NUM_TID];
 };
 
 int ath_startrecv(struct ath_softc *sc);
@@ -444,96 +443,95 @@ enum ATH_SM_PWRSAV{
  * hardware queue).
  */
 struct ath_txq {
-	u32			axq_qnum;	/* hardware q number */
-	u32		*axq_link;	/* link ptr in last TX desc */
-	struct list_head	axq_q;		/* transmit queue */
-	spinlock_t		axq_lock;	/* lock on q and link */
-	unsigned long		axq_lockflags;	/* intr state when must cli */
-	u32			axq_depth;	/* queue depth */
-	u8                axq_aggr_depth; /* aggregates queued */
-	u32		axq_totalqueued;/* total ever queued */
-	u32			axq_intrcnt;	/* count to determine
-						if descriptor should generate
-						int on this txq. */
-	bool			stopped;	/* Is mac80211 queue
-						stopped ? */
-	/* State for patching up CTS when bursting */
-	struct	ath_buf		*axq_linkbuf;	/* virtual addr of last buffer*/
-	struct	ath_desc	*axq_lastdsWithCTS;	/* first desc of the
-					last descriptor that contains CTS  */
-	struct	ath_desc	*axq_gatingds; /* final desc of the gating desc
-				* that determines whether lastdsWithCTS has
-				* been DMA'ed or not */
-	struct list_head	axq_acq;
+	u32 axq_qnum;			/* hardware q number */
+	u32 *axq_link;			/* link ptr in last TX desc */
+	struct list_head axq_q;		/* transmit queue */
+	spinlock_t axq_lock;
+	unsigned long axq_lockflags;	/* intr state when must cli */
+	u32 axq_depth;			/* queue depth */
+	u8 axq_aggr_depth;		/* aggregates queued */
+	u32 axq_totalqueued;		/* total ever queued */
+
+	/* count to determine if descriptor should generate int on this txq. */
+	u32 axq_intrcnt;
+
+	bool stopped;			/* Is mac80211 queue stopped ? */
+	struct ath_buf *axq_linkbuf;	/* virtual addr of last buffer*/
+
+	/* first desc of the last descriptor that contains CTS */
+	struct ath_desc *axq_lastdsWithCTS;
+
+	/* final desc of the gating desc that determines whether
+	   lastdsWithCTS has been DMA'ed or not */
+	struct ath_desc *axq_gatingds;
+
+	struct list_head axq_acq;
 };
 
 /* per TID aggregate tx state for a destination */
 struct ath_atx_tid {
-	struct list_head	list;	/* round-robin tid entry */
-	struct list_head	buf_q;    /* pending buffers */
-	struct ath_node         *an;        /* parent node structure */
-	struct ath_atx_ac       *ac;        /* parent access category */
-	struct ath_buf          *tx_buf[ATH_TID_MAX_BUFS];/* active tx frames */
-	u16               seq_start;  /* starting seq of BA window */
-	u16               seq_next;   /* next seq to be used */
-	u16               baw_size;   /* BA window size */
-	int                     tidno;      /* TID number */
-	int                     baw_head;   /* first un-acked tx buffer */
-	int                     baw_tail;   /* next unused tx buffer slot */
-	int                     sched;      /* TID is scheduled */
-	int                     paused;     /* TID is paused */
-	int                     cleanup_inprogress; /* aggr of this TID is
-						being teared down */
-	u32               addba_exchangecomplete:1; /* ADDBA state */
-	int32_t                 addba_exchangeinprogress;
-	int                     addba_exchangeattempts;
+	struct list_head list;		/* round-robin tid entry */
+	struct list_head buf_q;		/* pending buffers */
+	struct ath_node *an;
+	struct ath_atx_ac *ac;
+	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS]; /* active tx frames */
+	u16 seq_start;
+	u16 seq_next;
+	u16 baw_size;
+	int tidno;
+	int baw_head;			/* first un-acked tx buffer */
+	int baw_tail;			/* next unused tx buffer slot */
+	int sched;
+	int paused;
+	int cleanup_inprogress;
+	u32 addba_exchangecomplete:1;
+	int32_t addba_exchangeinprogress;
+	int addba_exchangeattempts;
 };
 
 /* per access-category aggregate tx state for a destination */
 struct ath_atx_ac {
-	int                     sched;      /* dest-ac is scheduled */
-	int                     qnum; /* H/W queue number associated
-					with this AC */
-	struct list_head	list;   /* round-robin txq entry */
-	struct list_head	tid_q;      /* queue of TIDs with buffers */
+	int sched;			/* dest-ac is scheduled */
+	int qnum;			/* H/W queue number associated
+					   with this AC */
+	struct list_head list;		/* round-robin txq entry */
+	struct list_head tid_q;		/* queue of TIDs with buffers */
 };
 
 /* per dest tx state */
 struct ath_atx {
-	struct ath_atx_tid  tid[WME_NUM_TID];
-	struct ath_atx_ac   ac[WME_NUM_AC];
+	struct ath_atx_tid tid[WME_NUM_TID];
+	struct ath_atx_ac ac[WME_NUM_AC];
 };
 
 /* per-frame tx control block */
 struct ath_tx_control {
-	struct ath_node *an;	/* destination to sent to */
-	int if_id;		/* only valid for cab traffic */
-	int qnum;		/* h/w queue number */
-	u32 ht:1;             /* if it can be transmitted using HT */
-	u32 ps:1;             /* if one or more stations are in PS mode */
-	u32 use_minrate:1;	/* if this frame should transmitted using
-				minimum rate */
-	enum ath9k_pkt_type atype;	/* Atheros packet type */
-	enum ath9k_key_type keytype;	/* key type */
-	u32 flags;		/* HAL flags */
-	u16 seqno;	/* sequence number */
-	u16 tidno;	/* tid number */
-	u16 txpower;	/* transmit power */
-	u16 frmlen;       /* frame length */
-	u32 keyix;        /* key index */
-	int min_rate;		/* minimum rate */
-	int mcast_rate;		/* multicast rate */
-	u16 nextfraglen;	/* next fragment length */
-	/* below is set only by ath_dev */
-	struct ath_softc *dev;	/* device handle */
+	struct ath_node *an;
+	int if_id;
+	int qnum;
+	u32 ht:1;
+	u32 ps:1;
+	u32 use_minrate:1;
+	enum ath9k_pkt_type atype;
+	enum ath9k_key_type keytype;
+	u32 flags;
+	u16 seqno;
+	u16 tidno;
+	u16 txpower;
+	u16 frmlen;
+	u32 keyix;
+	int min_rate;
+	int mcast_rate;
+	u16 nextfraglen;
+	struct ath_softc *dev;
 	dma_addr_t dmacontext;
 };
 
 /* per frame tx status block */
 struct ath_xmit_status {
-	int retries; /* number of retries to successufully
-			transmit this frame */
-	int flags; /* status of transmit */
+	int retries;	/* number of retries to successufully
+			   transmit this frame */
+	int flags;	/* status of transmit */
 #define ATH_TX_ERROR        0x01
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
@@ -647,20 +645,20 @@ struct aggr_rifs_param {
 
 /* Per-node aggregation state */
 struct ath_node_aggr {
-	struct ath_atx      tx;         /* node transmit state */
-	struct ath_arx      rx;         /* node receive state */
+	struct ath_atx tx;	/* node transmit state */
+	struct ath_arx rx;	/* node receive state */
 };
 
 /* driver-specific node state */
 struct ath_node {
-	struct list_head	list;
-	struct ath_softc    	*an_sc; 		/* back pointer */
-	atomic_t		an_refcnt;
+	struct list_head list;
+	struct ath_softc *an_sc;
+	atomic_t an_refcnt;
 	struct ath_chainmask_sel an_chainmask_sel;
-	struct ath_node_aggr 	an_aggr; /* A-MPDU aggregation state */
-	u8             	an_smmode; /* SM Power save mode */
-	u8         	an_flags;
-	u8	 		an_addr[ETH_ALEN];
+	struct ath_node_aggr an_aggr;
+	u8 an_smmode; /* SM Power save mode */
+	u8 an_flags;
+	u8 an_addr[ETH_ALEN];
 };
 
 void ath_tx_resume_tid(struct ath_softc *sc,
@@ -754,15 +752,6 @@ int ath_update_beacon(struct ath_softc *sc,
 /* VAPs */
 /********/
 
-#define ATH_IF_HW_OFF           0x0001	/* hardware state needs to turn off */
-#define ATH_IF_HW_ON            0x0002	/* hardware state needs to turn on */
-/* STA only: the associated AP is HT capable */
-#define ATH_IF_HT               0x0004
-/* AP/IBSS only: current BSS has privacy on */
-#define ATH_IF_PRIVACY          0x0008
-#define ATH_IF_BEACON_ENABLE    0x0010	/* AP/IBSS only: enable beacon */
-#define ATH_IF_BEACON_SYNC      0x0020	/* IBSS only: need to sync beacon */
-
 /*
  * Define the scheme that we select MAC address for multiple
  * BSS on the same radio. The very first VAP will just use the MAC
@@ -782,19 +771,15 @@ struct ath_vap_config {
 
 /* driver-specific vap state */
 struct ath_vap {
-	struct ieee80211_vif            *av_if_data; /* interface(vap)
-				instance from 802.11 protocal layer */
-	enum ath9k_opmode                 av_opmode;  /* VAP operational mode */
-	struct ath_buf                  *av_bcbuf;  /* beacon buffer */
-	struct ath_beacon_offset        av_boff;    /* dynamic update state */
-	struct ath_tx_control           av_btxctl;  /* tx control information
-							for beacon */
-	int                             av_bslot;   /* beacon slot index */
-	struct ath_txq                  av_mcastq;  /* multicast
-						transmit queue */
-	struct ath_vap_config           av_config;  /* vap configuration
-					parameters from 802.11 protocol layer*/
-	struct ath_rate_node            *rc_node;
+	struct ieee80211_vif *av_if_data;
+	enum ath9k_opmode av_opmode;	/* VAP operational mode */
+	struct ath_buf *av_bcbuf;	/* beacon buffer */
+	struct ath_beacon_offset av_boff; /* dynamic update state */
+	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
+	int av_bslot;			/* beacon slot index */
+	struct ath_txq av_mcastq;	/* multicast transmit queue */
+	struct ath_vap_config av_config;/* vap configuration parameters*/
+	struct ath_rate_node *rc_node;
 };
 
 int ath_vap_attach(struct ath_softc *sc,
-- 
1.5.6.5

