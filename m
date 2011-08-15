Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2703 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab1HONem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/15] staging: brcm80211: replaced void pointers in dma
 functions
Date: Mon, 15 Aug 2011 15:34:14 +0200
Message-ID: <1313415267-5264-3-git-send-email-arend@broadcom.com> (sfid-20110815_153446_516869_215C5E97)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced by less generic pointer types.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c  |   31 +++++++++++++++--------------
 drivers/staging/brcm80211/brcmsmac/dma.h  |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c |    4 +-
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 10a25d2..3cb9e68 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -275,7 +275,8 @@ struct dma_info {
 	u16 ntxd;		/* # tx descriptors tunable */
 	u16 txin;		/* index of next descriptor to reclaim */
 	u16 txout;		/* index of next descriptor to post */
-	void **txp;	/* pointer to parallel array of pointers to packets */
+	/* pointer to parallel array of pointers to packets */
+	struct sk_buff **txp;
 	struct dma_seg_map *txp_dmah;	/* DMA MAP meta-data handle */
 	/* Aligned physical address of descriptor ring */
 	unsigned long txdpa;
@@ -291,7 +292,8 @@ struct dma_info {
 	u16 nrxd;	/* # rx descriptors tunable */
 	u16 rxin;	/* index of next descriptor to reclaim */
 	u16 rxout;	/* index of next descriptor to post */
-	void **rxp;	/* pointer to parallel array of pointers to packets */
+	/* pointer to parallel array of pointers to packets */
+	struct sk_buff **rxp;
 	struct dma_seg_map *rxp_dmah;	/* DMA MAP meta-data handle */
 	/* Aligned physical address of descriptor ring */
 	unsigned long rxdpa;
@@ -367,7 +369,7 @@ static bool _dma_alloc(struct dma_info *di, uint direction);
 static void _dma_ddtable_init(struct dma_info *di, uint direction,
 			      unsigned long pa);
 static void _dma_rxenable(struct dma_info *di);
-static void *_dma_getnextrxp(struct dma_info *di, bool forceall);
+static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall);
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags);
 static u8 dma_align_sizetobits(uint size);
 static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
@@ -376,7 +378,7 @@ static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 
 /* Prototypes for 64-bit routines */
 static bool dma64_alloc(struct dma_info *di, uint direction);
-static void *dma64_getnextrxp(struct dma_info *di, bool forceall);
+static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall);
 static bool dma64_rxidle(struct dma_info *di);
 static bool _dma64_addrext(struct dma64regs *dma64regs);
 
@@ -776,8 +778,7 @@ void dma_rxinit(struct dma_pub *pub)
 	di->rxin = di->rxout = 0;
 
 	/* clear rx descriptor ring */
-	memset((void *)di->rxd64, '\0',
-		(di->nrxd * sizeof(struct dma64desc)));
+	memset(di->rxd64, '\0', di->nrxd * sizeof(struct dma64desc));
 
 	/* DMA engine with out alignment requirement requires table to be inited
 	 * before enabling the engine
@@ -822,7 +823,7 @@ static void _dma_rxenable(struct dma_info *di)
  *   buffer data. After it reaches the max size of buffer, the data continues
  *   in next DMA descriptor buffer WITHOUT DMA header
  */
-void *dma_rx(struct dma_pub *pub)
+struct sk_buff *dma_rx(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
 	struct sk_buff *p, *head, *tail;
@@ -976,7 +977,7 @@ bool dma_rxfill(struct dma_pub *pub)
 void dma_rxreclaim(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
-	void *p;
+	struct sk_buff *p;
 
 	DMA_TRACE(("%s: dma_rxreclaim\n", di->name));
 
@@ -984,7 +985,7 @@ void dma_rxreclaim(struct dma_pub *pub)
 		brcmu_pkt_buf_free_skb(p);
 }
 
-static void *_dma_getnextrxp(struct dma_info *di, bool forceall)
+static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall)
 {
 	if (di->nrxd == 0)
 		return NULL;
@@ -1100,7 +1101,7 @@ void dma_txinit(struct dma_pub *pub)
 	di->dma.txavail = di->ntxd - 1;
 
 	/* clear tx descriptor ring */
-	memset((void *)di->txd64, '\0', (di->ntxd * sizeof(struct dma64desc)));
+	memset(di->txd64, '\0', (di->ntxd * sizeof(struct dma64desc)));
 
 	/* DMA engine with out alignment requirement requires table to be inited
 	 * before enabling the engine
@@ -1155,7 +1156,7 @@ bool dma_txsuspended(struct dma_pub *pub)
 void dma_txreclaim(struct dma_pub *pub, enum txd_range range)
 {
 	struct dma_info *di = (struct dma_info *)pub;
-	void *p;
+	struct sk_buff *p;
 
 	DMA_TRACE(("%s: dma_txreclaim %s\n", di->name,
 		   (range == DMA_RANGE_ALL) ? "all" :
@@ -1406,12 +1407,12 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
  * If range is DMA_RANGE_ALL, reclaim all txd(s) posted to the ring and
  * return associated packet regardless of the value of hardware pointers.
  */
-void *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
+struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 {
 	struct dma_info *di = (struct dma_info *)pub;
 	u16 start, end, i;
 	u16 active_desc;
-	void *txp;
+	struct sk_buff *txp;
 
 	DMA_TRACE(("%s: dma_getnexttxp %s\n", di->name,
 		   (range == DMA_RANGE_ALL) ? "all" :
@@ -1499,10 +1500,10 @@ void *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	return NULL;
 }
 
-static void *dma64_getnextrxp(struct dma_info *di, bool forceall)
+static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 {
 	uint i, curr;
-	void *rxp;
+	struct sk_buff *rxp;
 	unsigned long pa;
 
 	i = di->rxin;
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 3b23517..134402c 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -80,7 +80,7 @@ extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 			    uint nrxpost, uint rxoffset, uint *msg_level);
 
 void dma_rxinit(struct dma_pub *pub);
-void *dma_rx(struct dma_pub *pub);
+struct sk_buff *dma_rx(struct dma_pub *pub);
 bool dma_rxfill(struct dma_pub *pub);
 bool dma_rxreset(struct dma_pub *pub);
 bool dma_txreset(struct dma_pub *pub);
@@ -93,7 +93,7 @@ void dma_txreclaim(struct dma_pub *pub, enum txd_range range);
 void dma_rxreclaim(struct dma_pub *pub);
 void dma_detach(struct dma_pub *pub);
 unsigned long dma_getvar(struct dma_pub *pub, const char *name);
-void *dma_getnexttxp(struct dma_pub *pub, enum txd_range range);
+struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range);
 void dma_counterreset(struct dma_pub *pub);
 
 void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index bdc7fb4..c462377 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -239,8 +239,8 @@
 
 #define DMAREG(wlc_hw, direction, fifonum) \
 	((direction == DMA_TX) ? \
-		(void *)&(wlc_hw->regs->fifo64regs[fifonum].dmaxmt) : \
-		(void *)&(wlc_hw->regs->fifo64regs[fifonum].dmarcv))
+		&(wlc_hw->regs->fifo64regs[fifonum].dmaxmt) : \
+		&(wlc_hw->regs->fifo64regs[fifonum].dmarcv))
 
 #define APHY_SLOT_TIME		9
 #define BPHY_SLOT_TIME		20
-- 
1.7.4.1


