Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:37819 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752437AbYAIJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:11 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/6] ath5k: code cosmetics
Date: Wed,  9 Jan 2008 18:16:04 +0900
Message-Id: <1199870169-10476-2-git-send-email-bruno@thinktube.com> (sfid-20080109_091625_314448_BB43B4DA)
In-Reply-To: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  * move some enums to kdoc
  * small cosmetic changes of indentation etc

base.[ch]: Changes-licensed-under: 3-clause-BSD
all others: Changes-licensed-under: ISC
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/ath5k.h |   35 +++++++++++++++++++++--------------
 drivers/net/wireless/ath5k/base.c  |    4 ++--
 drivers/net/wireless/ath5k/base.h  |   12 ++++++------
 drivers/net/wireless/ath5k/reg.h   |    6 +++---
 4 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index a30f28c..47b33d2 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -289,16 +289,22 @@ struct ath5k_tx_status {
 #define AR5K_TXERR_FILT		0x02
 #define AR5K_TXERR_FIFO		0x04
 
-/*
- * Queue types used to classify tx queues.
+/**
+ * enum ath5k_tx_queue - Queue types used to classify tx queues.
+ * @AR5K_TX_QUEUE_INACTIVE: q is unused -- see ath5k_hw_release_tx_queue
+ * @AR5K_TX_QUEUE_DATA: A normal data queue
+ * @AR5K_TX_QUEUE_XR_DATA: An XR-data queue
+ * @AR5K_TX_QUEUE_BEACON: The beacon queue
+ * @AR5K_TX_QUEUE_CAB: The after-beacon queue
+ * @AR5K_TX_QUEUE_UAPSD: Unscheduled Automatic Power Save Delivery queue
  */
 enum ath5k_tx_queue {
-	AR5K_TX_QUEUE_INACTIVE = 0, /* q is unused -- see ath5k_hw_release_tx_queue */
-	AR5K_TX_QUEUE_DATA,	  /*A normal data queue*/
-	AR5K_TX_QUEUE_XR_DATA,	  /*An XR-data queue*/
-	AR5K_TX_QUEUE_BEACON,	  /*The beacon queue*/
-	AR5K_TX_QUEUE_CAB,	  /*The ater-beacon queue*/
-	AR5K_TX_QUEUE_UAPSD,	  /*Unscheduled Automatic Power Save Delivery queue*/
+	AR5K_TX_QUEUE_INACTIVE = 0,
+	AR5K_TX_QUEUE_DATA,
+	AR5K_TX_QUEUE_XR_DATA,
+	AR5K_TX_QUEUE_BEACON,
+	AR5K_TX_QUEUE_CAB,
+	AR5K_TX_QUEUE_UAPSD,
 };
 
 #define	AR5K_NUM_TX_QUEUES		10
@@ -453,18 +459,19 @@ struct ath5k_mib_stats {
 #define AR5K_BEACON_ENA		0x00800000 /*enable beacon xmit*/
 #define AR5K_BEACON_RESET_TSF	0x01000000 /*force a TSF reset*/
 
-/*
- * Per-station beacon timer state.
+/**
+ * struct ath5k_beacon_state - Per-station beacon timer state.
+ * @bs_interval: in TU's, can also include the above flags
+ * @bs_cfp_max_duration: if non-zero hw is setup to coexist with a
+ * 	Point Coordination Function capable AP
  */
 struct ath5k_beacon_state {
 	u32	bs_next_beacon;
 	u32	bs_next_dtim;
-	u32	bs_interval;		/*in TU's -see net80211/ieee80211_var.h-
-						can also include the above flags*/
+	u32	bs_interval;
 	u8	bs_dtim_period;
 	u8	bs_cfp_period;
-	u16	bs_cfp_max_duration;	/*if non-zero hw is setup to coexist with
-						a Point Coordination Function capable AP*/
+	u16	bs_cfp_max_duration;
 	u16	bs_cfp_du_remain;
 	u16	bs_tim_offset;
 	u16	bs_sleep_duration;
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index ff5117c..8d5ffcd 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1446,7 +1446,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 	if (ret)
 		return ret;
 	if (sc->opmode == IEEE80211_IF_TYPE_AP ||
-			sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+	    sc->opmode == IEEE80211_IF_TYPE_IBSS) {
 		/*
 		 * Always burst out beacon and CAB traffic
 		 * (aifs = cwmin = cwmax = 0)
@@ -1504,7 +1504,7 @@ ath5k_txq_cleanup(struct ath5k_softc *sc)
 	/* XXX return value */
 	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
 		/* don't touch the hardware if marked invalid */
-		(void)ath5k_hw_stop_tx_dma(ah, sc->bhalq);
+		ath5k_hw_stop_tx_dma(ah, sc->bhalq);
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "beacon queue %x\n",
 			ath5k_hw_get_tx_buf(ah, sc->bhalq));
 		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index fce947c..7ba2223 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -56,7 +56,7 @@
 struct ath5k_buf {
 	struct list_head	list;
 	unsigned int		flags;	/* tx descriptor flags */
-	struct ath5k_desc		*desc;	/* virtual addr of desc */
+	struct ath5k_desc	*desc;	/* virtual addr of desc */
 	dma_addr_t		daddr;	/* physical addr of desc */
 	struct sk_buff		*skb;	/* skbuff for buf */
 	dma_addr_t		skbaddr;/* physical addr of skb data */
@@ -73,11 +73,11 @@ struct ath5k_buf {
  * hardware queue).
  */
 struct ath5k_txq {
-	unsigned int	qnum;		/* hardware q number */
-	u32		*link;		/* link ptr in last TX desc */
-	struct list_head q;		/* transmit queue */
-	spinlock_t	lock;		/* lock on q and link */
-	bool		setup;
+	unsigned int		qnum;	/* hardware q number */
+	u32			*link;	/* link ptr in last TX desc */
+	struct list_head	q;	/* transmit queue */
+	spinlock_t		lock;	/* lock on q and link */
+	bool			setup;
 };
 
 #if CHAN_DEBUG
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index bdd10a7..2f41c83 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -83,7 +83,7 @@
 /*
  * Interrupt enable register
  */
-#define AR5K_IER		0x0024			/* Register Address */
+#define AR5K_IER		0x0024		/* Register Address */
 #define AR5K_IER_DISABLE	0x00000000	/* Disable card interrupts */
 #define AR5K_IER_ENABLE		0x00000001	/* Enable card interrupts */
 
@@ -96,7 +96,7 @@
 /*
  * Beacon control register [5210]
  */
-#define AR5K_BCR		0x0028			/* Register Address */
+#define AR5K_BCR		0x0028		/* Register Address */
 #define AR5K_BCR_AP		0x00000000	/* AP mode */
 #define AR5K_BCR_ADHOC		0x00000001	/* Ad-Hoc mode */
 #define AR5K_BCR_BDMAE		0x00000002	/* DMA enable */
@@ -107,7 +107,7 @@
 /*
  * First RTS duration register [5211]
  */
-#define AR5K_RTSD0		0x0028			/* Register Address */
+#define AR5K_RTSD0		0x0028		/* Register Address */
 #define	AR5K_RTSD0_6		0x000000ff	/* 6Mb RTS duration mask (?) */
 #define	AR5K_RTSD0_6_S		0		/* 6Mb RTS duration shift (?) */
 #define	AR5K_RTSD0_9		0x0000ff00	/* 9Mb*/
-- 
1.5.3.4

