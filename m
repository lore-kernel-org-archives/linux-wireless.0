Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3826 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/20] staging: brcm80211: removed softmac 'tunable'
 functionality
Date: Mon, 12 Sep 2011 12:14:55 +0200
Message-ID: <1315822504-24210-12-git-send-email-rvossen@broadcom.com> (sfid-20110912_121559_020585_E8A257E7)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unused mechanism as part of code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c |   58 ----------------------------
 drivers/staging/brcm80211/brcmsmac/ampdu.c |    5 ++-
 drivers/staging/brcm80211/brcmsmac/main.c  |   41 +++++++++++++-------
 drivers/staging/brcm80211/brcmsmac/pub.h   |   20 ----------
 drivers/staging/brcm80211/brcmsmac/types.h |   16 --------
 5 files changed, 31 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 344c0ad..52189dc 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -20,61 +20,12 @@
 #include "main.h"
 #include "alloc.h"
 
-/* Max # of entries in Tx FIFO based on 4kb page size */
-#define NTXD		256
-/* Max # of entries in Rx FIFO based on 4kb page size */
-#define NRXD		256
-/* try to keep this # rbufs posted to the chip */
-#define	NRXBUFPOST	32
-/* Maximum SCBs in cache for STA */
-#define MAXSCB		32
-
-/* Count of packet callback structures. either of following
- * 1. Set to the number of SCBs since a STA
- * can queue up a rate callback for each IBSS STA it knows about, and an AP can
- * queue up an "are you there?" Null Data callback for each associated STA
- * 2. controlled by tunable config file
- */
-#define MAXPKTCB	MAXSCB	/* Max number of packet callbacks */
-
-/* Number of BSS handled in ucode bcn/prb */
-#define BRCMS_MAX_UCODE_BSS	(16)
-/* Number of BSS handled in sw bcn/prb */
-#define BRCMS_MAX_UCODE_BSS4	(4)
-
-/* data msg txq hiwat mark */
-#define BRCMS_DATAHIWAT		50
-#define BRCMS_AMPDUDATAHIWAT 255
-
-/* bounded rx loops */
-#define RXBND		8 /* max # frames to process in brcms_c_recv() */
-#define TXSBND		8 /* max # tx status to process in wlc_txstatus() */
-
-static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid)
-{
-	tunables->ntxd = NTXD;
-	tunables->nrxd = NRXD;
-	tunables->rxbufsz = RXBUFSZ;
-	tunables->nrxbufpost = NRXBUFPOST;
-	tunables->maxscb = MAXSCB;
-	tunables->ampdunummpdu = AMPDU_NUM_MPDU;
-	tunables->maxpktcb = MAXPKTCB;
-	tunables->maxucodebss = BRCMS_MAX_UCODE_BSS;
-	tunables->maxucodebss4 = BRCMS_MAX_UCODE_BSS4;
-	tunables->maxbss = MAXBSS;
-	tunables->datahiwat = BRCMS_DATAHIWAT;
-	tunables->ampdudatahiwat = BRCMS_AMPDUDATAHIWAT;
-	tunables->rxbnd = RXBND;
-	tunables->txsbnd = TXSBND;
-}
-
 static void brcms_c_pub_mfree(struct brcms_pub *pub)
 {
 	if (pub == NULL)
 		return;
 
 	kfree(pub->multicast);
-	kfree(pub->tunables);
 	kfree(pub);
 }
 
@@ -88,15 +39,6 @@ static struct brcms_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
 		goto fail;
 	}
 
-	pub->tunables = kzalloc(sizeof(struct brcms_tunables), GFP_ATOMIC);
-	if (pub->tunables == NULL) {
-		*err = 1028;
-		goto fail;
-	}
-
-	/* need to init the tunables now */
-	brcms_c_tunables_init(pub->tunables, devid);
-
 	pub->multicast = kzalloc(ETH_ALEN * MAXMULTILIST, GFP_ATOMIC);
 	if (pub->multicast == NULL) {
 		*err = 1003;
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index efae10f..76f4871 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -62,6 +62,9 @@
 
 #define AMPDU_DELIMITER_LEN	4
 
+/* max allowed number of mpdus in an ampdu (2 streams) */
+#define AMPDU_NUM_MPDU		16
+
 #define TX_SEQ_TO_INDEX(seq) ((seq) % AMPDU_TX_BA_MAX_WSIZE)
 
 /* max possible overhead per mpdu in the ampdu; 3 is for roundup if needed */
@@ -287,7 +290,7 @@ static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
 	struct scb_ampdu *scb_ampdu = &scb->scb_ampdu;
 	int i;
 
-	scb_ampdu->max_pdu = (u8) ampdu->wlc->pub->tunables->ampdunummpdu;
+	scb_ampdu->max_pdu = AMPDU_NUM_MPDU;
 
 	/* go back to legacy size if some preloading is occurring */
 	for (i = 0; i < NUM_FFPLD_FIFO; i++) {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index cc669d6..c5cecb4 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -320,6 +320,21 @@
 
 #define MAX_DMA_SEGS 4
 
+/* Max # of entries in Tx FIFO based on 4kb page size */
+#define NTXD		256
+/* Max # of entries in Rx FIFO based on 4kb page size */
+#define NRXD		256
+
+/* try to keep this # rbufs posted to the chip */
+#define	NRXBUFPOST	32
+
+/* data msg txq hiwat mark */
+#define BRCMS_DATAHIWAT		50
+
+/* bounded rx loops */
+#define RXBND		8 /* max # frames to process in brcms_c_recv() */
+#define TXSBND		8 /* max # tx status to process in wlc_txstatus() */
+
 /*
  * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
  */
@@ -646,7 +661,7 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	struct sk_buff *head = NULL;
 	struct sk_buff *tail = NULL;
 	uint n = 0;
-	uint bound_limit = bound ? wlc_hw->wlc->pub->tunables->rxbnd : -1;
+	uint bound_limit = bound ? RXBND : -1;
 	struct brcms_d11rxhdr *wlc_rxhdr = NULL;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -718,7 +733,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	 * Param 'max_tx_num' indicates max. # tx status to process before
 	 * break out.
 	 */
-	uint max_tx_num = bound ? wlc->pub->tunables->txsbnd : -1;
+	uint max_tx_num = bound ? TXSBND : -1;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -925,7 +940,6 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	u16 pio_mhf2 = 0;
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	uint unit = wlc_hw->unit;
-	struct brcms_tunables *tune = wlc->pub->tunables;
 	struct wiphy *wiphy = wlc->wiphy;
 
 	/* name and offsets for dma_attach */
@@ -942,8 +956,8 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		wlc_hw->di[0] = dma_attach(name, wlc_hw->sih,
 					   (wme ? DMAREG(wlc_hw, DMA_TX, 0) :
 					    NULL), DMAREG(wlc_hw, DMA_RX, 0),
-					   (wme ? tune->ntxd : 0), tune->nrxd,
-					   tune->rxbufsz, -1, tune->nrxbufpost,
+					   (wme ? NTXD : 0), NRXD,
+					   RXBUFSZ, -1, NRXBUFPOST,
 					   BRCMS_HWRXOFF, &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[0]);
 
@@ -955,7 +969,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 */
 		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih,
 					   DMAREG(wlc_hw, DMA_TX, 1), NULL,
-					   tune->ntxd, 0, 0, -1, 0, 0,
+					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[1]);
 
@@ -966,7 +980,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 */
 		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih,
 					   DMAREG(wlc_hw, DMA_TX, 2), NULL,
-					   tune->ntxd, 0, 0, -1, 0, 0,
+					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[2]);
 		/*
@@ -976,7 +990,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 */
 		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih,
 					   DMAREG(wlc_hw, DMA_TX, 3),
-					   NULL, tune->ntxd, 0, 0, -1,
+					   NULL, NTXD, 0, 0, -1,
 					   0, 0, &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[3]);
 /* Cleaner to leave this as if with AP defined */
@@ -4963,7 +4977,7 @@ static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
 		 * will remain the same
 		 */
 		brcmu_pktq_init(&qi->q, BRCMS_PREC_COUNT,
-			  (2 * wlc->pub->tunables->datahiwat) + PKTQ_LEN_DEFAULT
+			  2 * BRCMS_DATAHIWAT + PKTQ_LEN_DEFAULT
 			  + wlc->pub->psq_pkts_total);
 
 		/* add this queue to the the global list */
@@ -6798,11 +6812,10 @@ void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 	 */
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
-		if (pktq_len(q) >= wlc->pub->tunables->datahiwat)
+		if (pktq_len(q) >= BRCMS_DATAHIWAT)
 			brcms_c_txflowcontrol(wlc, qi, ON, ALLPRIO);
 	} else if (wlc->pub->_priofc) {
-		if (pktq_plen(q, wlc_prio2prec_map[prio]) >=
-		    wlc->pub->tunables->datahiwat)
+		if (pktq_plen(q, wlc_prio2prec_map[prio]) >= BRCMS_DATAHIWAT)
 			brcms_c_txflowcontrol(wlc, qi, ON, prio);
 	}
 }
@@ -7806,14 +7819,14 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
 		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
-		    && (pktq_len(q) < wlc->pub->tunables->datahiwat / 2))
+		    && (pktq_len(q) < BRCMS_DATAHIWAT / 2))
 			brcms_c_txflowcontrol(wlc, qi, OFF, ALLPRIO);
 	} else if (wlc->pub->_priofc) {
 		int prio;
 		for (prio = MAXPRIO; prio >= 0; prio--) {
 			if (brcms_c_txflowcontrol_prio_isset(wlc, qi, prio) &&
 			    q->q[wlc_prio2prec_map[prio]].len <
-			    wlc->pub->tunables->datahiwat / 2)
+			    BRCMS_DATAHIWAT / 2)
 				brcms_c_txflowcontrol(wlc, qi, OFF, prio);
 		}
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 9e767fb..acad21b 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -102,24 +102,6 @@
 
 #define MAX_STREAMS_SUPPORTED	4	/* max number of streams supported */
 
-struct brcms_tunables {
-	int ntxd;	/* size of tx descriptor table */
-	int nrxd;	/* size of rx descriptor table */
-	int rxbufsz;	/* size of rx buffers to post */
-	int nrxbufpost;	/* # of rx buffers to post */
-	int maxscb;	/* # of SCBs supported */
-	int ampdunummpdu;	/* max number of mpdu in an ampdu */
-	int maxpktcb;	/* max # of packet callbacks */
-	int maxucodebss;/* max # of BSS handled in ucode bcn/prb */
-	int maxucodebss4;	/* max # of BSS handled in sw bcn/prb */
-	int maxbss;	/* max # of bss info elements in scan list */
-	int datahiwat;	/* data msg txq hiwat mark */
-	int ampdudatahiwat;	/* AMPDU msg txq hiwat mark */
-	int rxbnd;	/* max # rx bufs to process before deferring to dpc */
-	int txsbnd;	/* max # tx status to process in wlc_txstatus() */
-	int memreserved;/* memory reserved for BMAC's USB dma rx */
-};
-
 struct brcms_c_rateset {
 	uint count;		/* number of rates in rates[] */
 	 /* rates in 500kbps units w/hi bit set if basic */
@@ -176,8 +158,6 @@ struct brcms_pub {
 	char *vars;		/* "environment" name=value */
 	bool up;		/* interface up and running */
 	bool hw_off;		/* HW is off */
-	/* tunables: ntxd, nrxd, maxscb, etc. */
-	struct brcms_tunables *tunables;
 	bool hw_up;		/* one time hw up/down */
 	bool _piomode;		/* true if pio mode */
 	uint _nbands;		/* # bands supported */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index ed2870b..0ae3d83 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -244,26 +244,10 @@
  * ********************************************************************
  */
 
-/*************************************************
- * Defaults for tunables (e.g. sizing constants)
- *
- * For each new tunable, add a member to the end
- * of struct brcms_tunables in brcms_c_pub.h to enable
- * runtime checks of tunable values. (Directly
- * using the macros in code invalidates ROM code)
- *
- * ***********************************************
- */
-
-/* max allowed number of mpdus in an ampdu (2 streams) */
-#define AMPDU_NUM_MPDU		16
-
 /* NetBSD also needs to keep track of this */
 
 /* max # BSS configs */
 #define BRCMS_MAXBSSCFG		(1)
-/* max # available networks */
-#define MAXBSS		64
 
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
-- 
1.7.4.1


