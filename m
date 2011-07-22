Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3357 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/29] staging: brcm80211: cleaned up softmac DMA layer
Date: Fri, 22 Jul 2011 20:56:57 +0200
Message-ID: <1311361036-3175-11-git-send-email-arend@broadcom.com> (sfid-20110722_205745_345091_97984F63)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Since this driver only needs to support 64 bit DMA hardware,
an unnecessary layer of abstraction could be removed. Also DMA functions that
were not called have been removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |  461 +++---------------------------
 drivers/staging/brcm80211/brcmsmac/dma.h |  114 +-------
 2 files changed, 58 insertions(+), 517 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 27b07ce..48a053c 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -364,30 +364,10 @@ struct dma_info {
 static bool _dma_isaddrext(struct dma_info *di);
 static bool _dma_descriptor_align(struct dma_info *di);
 static bool _dma_alloc(struct dma_info *di, uint direction);
-static void _dma_detach(struct dma_info *di);
 static void _dma_ddtable_init(struct dma_info *di, uint direction,
 			      unsigned long pa);
-static void _dma_rxinit(struct dma_info *di);
-static void *_dma_rx(struct dma_info *di);
-static bool _dma_rxfill(struct dma_info *di);
-static void _dma_rxreclaim(struct dma_info *di);
 static void _dma_rxenable(struct dma_info *di);
 static void *_dma_getnextrxp(struct dma_info *di, bool forceall);
-static void _dma_rx_param_get(struct dma_info *di, u16 *rxoffset,
-			      u16 *rxbufsize);
-
-static void _dma_txblock(struct dma_info *di);
-static void _dma_txunblock(struct dma_info *di);
-static uint _dma_txactive(struct dma_info *di);
-static uint _dma_rxactive(struct dma_info *di);
-static uint _dma_txpending(struct dma_info *di);
-static uint _dma_txcommitted(struct dma_info *di);
-
-static void *_dma_peeknexttxp(struct dma_info *di);
-static void *_dma_peeknextrxp(struct dma_info *di);
-static unsigned long _dma_getvar(struct dma_info *di, const char *name);
-static void _dma_counterreset(struct dma_info *di);
-static void _dma_fifoloopbackenable(struct dma_info *di);
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags);
 static u8 dma_align_sizetobits(uint size);
 static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
@@ -396,78 +376,12 @@ static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 
 /* Prototypes for 64-bit routines */
 static bool dma64_alloc(struct dma_info *di, uint direction);
-static bool dma64_txreset(struct dma_info *di);
-static bool dma64_rxreset(struct dma_info *di);
-static bool dma64_txsuspendedidle(struct dma_info *di);
-static int dma64_txfast(struct dma_info *di, struct sk_buff *p0, bool commit);
-static int dma64_txunframed(struct dma_info *di, void *p0, uint len,
-			    bool commit);
-static void *dma64_getpos(struct dma_info *di, bool direction);
-static void *dma64_getnexttxp(struct dma_info *di, enum txd_range range);
 static void *dma64_getnextrxp(struct dma_info *di, bool forceall);
-static void dma64_txrotate(struct dma_info *di);
-
 static bool dma64_rxidle(struct dma_info *di);
-static void dma64_txinit(struct dma_info *di);
-static bool dma64_txenabled(struct dma_info *di);
-static void dma64_txsuspend(struct dma_info *di);
-static void dma64_txresume(struct dma_info *di);
-static bool dma64_txsuspended(struct dma_info *di);
-static void dma64_txreclaim(struct dma_info *di, enum txd_range range);
-static bool dma64_txstopped(struct dma_info *di);
-static bool dma64_rxstopped(struct dma_info *di);
-static bool dma64_rxenabled(struct dma_info *di);
 static bool _dma64_addrext(struct dma64regs *dma64regs);
 
 static inline u32 parity32(u32 data);
 
-const struct di_fcn_s dma64proc = {
-	(void (*)(struct dma_pub *)) _dma_detach,
-	(void (*)(struct dma_pub *)) dma64_txinit,
-	(bool(*)(struct dma_pub *)) dma64_txreset,
-	(bool(*)(struct dma_pub *)) dma64_txenabled,
-	(void (*)(struct dma_pub *)) dma64_txsuspend,
-	(void (*)(struct dma_pub *)) dma64_txresume,
-	(bool(*)(struct dma_pub *)) dma64_txsuspended,
-	(bool(*)(struct dma_pub *)) dma64_txsuspendedidle,
-	(int (*)(struct dma_pub *, struct sk_buff *, bool)) dma64_txfast,
-	(int (*)(struct dma_pub *, void *, uint, bool)) dma64_txunframed,
-	(void *(*)(struct dma_pub *, bool)) dma64_getpos,
-	(bool(*)(struct dma_pub *)) dma64_txstopped,
-	(void (*)(struct dma_pub *, enum txd_range)) dma64_txreclaim,
-	(void *(*)(struct dma_pub *, enum txd_range)) dma64_getnexttxp,
-	(void *(*)(struct dma_pub *)) _dma_peeknexttxp,
-	(void (*)(struct dma_pub *)) _dma_txblock,
-	(void (*)(struct dma_pub *)) _dma_txunblock,
-	(uint (*)(struct dma_pub *)) _dma_txactive,
-	(void (*)(struct dma_pub *)) dma64_txrotate,
-
-	(void (*)(struct dma_pub *)) _dma_rxinit,
-	(bool(*)(struct dma_pub *)) dma64_rxreset,
-	(bool(*)(struct dma_pub *)) dma64_rxidle,
-	(bool(*)(struct dma_pub *)) dma64_rxstopped,
-	(bool(*)(struct dma_pub *)) _dma_rxenable,
-	(bool(*)(struct dma_pub *)) dma64_rxenabled,
-	(void *(*)(struct dma_pub *)) _dma_rx,
-	(bool(*)(struct dma_pub *)) _dma_rxfill,
-	(void (*)(struct dma_pub *)) _dma_rxreclaim,
-	(void *(*)(struct dma_pub *, bool)) _dma_getnextrxp,
-	(void *(*)(struct dma_pub *)) _dma_peeknextrxp,
-	(void (*)(struct dma_pub *, u16 *, u16 *)) _dma_rx_param_get,
-
-	(void (*)(struct dma_pub *)) _dma_fifoloopbackenable,
-	(unsigned long (*)(struct dma_pub *, const char *)) _dma_getvar,
-	(void (*)(struct dma_pub *)) _dma_counterreset,
-	(uint (*)(struct dma_pub *, uint, uint)) _dma_ctrlflags,
-	NULL,
-	NULL,
-	NULL,
-	(uint (*)(struct dma_pub *)) _dma_rxactive,
-	(uint (*)(struct dma_pub *)) _dma_txpending,
-	(uint (*)(struct dma_pub *)) _dma_txcommitted,
-	39
-};
-
 struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		     void *dmaregstx, void *dmaregsrx, uint ntxd,
 		     uint nrxd, uint rxbufsize, int rxextheadroom,
@@ -493,15 +407,13 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	/* init dma reg pointer */
 	di->d64txregs = (struct dma64regs *) dmaregstx;
 	di->d64rxregs = (struct dma64regs *) dmaregsrx;
-	di->dma.di_fn = (const struct di_fcn_s *)&dma64proc;
 
 	/*
 	 * Default flags (which can be changed by the driver calling
 	 * dma_ctrlflags before enable): For backwards compatibility
 	 * both Rx Overflow Continue and Parity are DISABLED.
 	 */
-	di->dma.di_fn->ctrlflags(&di->dma, DMA_CTRL_ROC | DMA_CTRL_PEN,
-				 0);
+	_dma_ctrlflags(di, DMA_CTRL_ROC | DMA_CTRL_PEN, 0);
 
 	DMA_TRACE(("%s: dma_attach: %s flags 0x%x ntxd %d nrxd %d "
 		   "rxbufsize %d rxextheadroom %d nrxpost %d rxoffset %d "
@@ -654,7 +566,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	return (struct dma_pub *) di;
 
  fail:
-	_dma_detach(di);
+	dma_detach((struct dma_pub *)di);
 	return NULL;
 }
 
@@ -730,8 +642,9 @@ void *dma_alloc_consistent(struct pci_dev *pdev, uint size, u16 align_bits,
 }
 
 /* !! may be called with core in reset */
-static void _dma_detach(struct dma_info *di)
+void dma_detach(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 
 	DMA_TRACE(("%s: dma_detach\n", di->name));
 
@@ -854,15 +767,10 @@ _dma_ddtable_init(struct dma_info *di, uint direction, unsigned long pa)
 	}
 }
 
-static void _dma_fifoloopbackenable(struct dma_info *di)
+void dma_rxinit(struct dma_pub *pub)
 {
-	DMA_TRACE(("%s: dma_fifoloopbackenable\n", di->name));
+	struct dma_info *di = (struct dma_info *)pub;
 
-	OR_REG(&di->d64txregs->control, D64_XC_LE);
-}
-
-static void _dma_rxinit(struct dma_info *di)
-{
 	DMA_TRACE(("%s: dma_rxinit\n", di->name));
 
 	if (di->nrxd == 0)
@@ -907,14 +815,6 @@ static void _dma_rxenable(struct dma_info *di)
 		((di->rxoffset << D64_RC_RO_SHIFT) | control));
 }
 
-static void
-_dma_rx_param_get(struct dma_info *di, u16 *rxoffset, u16 *rxbufsize)
-{
-	/* the normal values fit into 16 bits */
-	*rxoffset = (u16) di->rxoffset;
-	*rxbufsize = (u16) di->rxbufsize;
-}
-
 /*
  * !! rx entry routine
  * returns a pointer to the next frame received, or NULL if there are no more
@@ -925,8 +825,9 @@ _dma_rx_param_get(struct dma_info *di, u16 *rxoffset, u16 *rxbufsize)
  *   buffer data. After it reaches the max size of buffer, the data continues
  *   in next DMA descriptor buffer WITHOUT DMA header
  */
-static void *_dma_rx(struct dma_info *di)
+void *dma_rx(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	struct sk_buff *p, *head, *tail;
 	uint len;
 	uint pkt_len;
@@ -966,7 +867,7 @@ static void *_dma_rx(struct dma_info *di)
 				  D64_RS0_CD_MASK) -
 				 di->rcvptrbase) & D64_RS0_CD_MASK,
 				struct dma64desc);
-			DMA_ERROR(("_dma_rx, rxin %d rxout %d, hw_curr %d\n",
+			DMA_ERROR(("dma_rx, rxin %d rxout %d, hw_curr %d\n",
 				   di->rxin, di->rxout, cur));
 		}
 #endif				/* BCMDBG */
@@ -989,8 +890,9 @@ static void *_dma_rx(struct dma_info *di)
  *  the rx dma and user might want to call rxfill again asap. This unlikely
  *  happens on memory-rich NIC, but often on memory-constrained dongle
  */
-static bool _dma_rxfill(struct dma_info *di)
+bool dma_rxfill(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	struct sk_buff *p;
 	u16 rxin, rxout;
 	u32 flags = 0;
@@ -1074,48 +976,9 @@ static bool _dma_rxfill(struct dma_info *di)
 	return ring_empty;
 }
 
-/* like getnexttxp but no reclaim */
-static void *_dma_peeknexttxp(struct dma_info *di)
-{
-	uint end, i;
-
-	if (di->ntxd == 0)
-		return NULL;
-
-	end =
-	    B2I(((R_REG(&di->d64txregs->status0) &
-		  D64_XS0_CD_MASK) - di->xmtptrbase) & D64_XS0_CD_MASK,
-		  struct dma64desc);
-
-	for (i = di->txin; i != end; i = NEXTTXD(i))
-		if (di->txp[i])
-			return di->txp[i];
-
-	return NULL;
-}
-
-/* like getnextrxp but not take off the ring */
-static void *_dma_peeknextrxp(struct dma_info *di)
-{
-	uint end, i;
-
-	if (di->nrxd == 0)
-		return NULL;
-
-	end =
-	    B2I(((R_REG(&di->d64rxregs->status0) &
-		  D64_RS0_CD_MASK) - di->rcvptrbase) & D64_RS0_CD_MASK,
-		  struct dma64desc);
-
-	for (i = di->rxin; i != end; i = NEXTRXD(i))
-		if (di->rxp[i])
-			return di->rxp[i];
-
-	return NULL;
-}
-
-static void _dma_rxreclaim(struct dma_info *di)
+void dma_rxreclaim(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	void *p;
 
 	DMA_TRACE(("%s: dma_rxreclaim\n", di->name));
@@ -1132,57 +995,12 @@ static void *_dma_getnextrxp(struct dma_info *di, bool forceall)
 	return dma64_getnextrxp(di, forceall);
 }
 
-static void _dma_txblock(struct dma_info *di)
-{
-	di->dma.txavail = 0;
-}
-
-static void _dma_txunblock(struct dma_info *di)
-{
-	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
-}
-
-static uint _dma_txactive(struct dma_info *di)
+void dma_counterreset(struct dma_pub *pub)
 {
-	return NTXDACTIVE(di->txin, di->txout);
-}
-
-static uint _dma_txpending(struct dma_info *di)
-{
-	uint curr;
-
-	curr =
-	    B2I(((R_REG(&di->d64txregs->status0) &
-		  D64_XS0_CD_MASK) - di->xmtptrbase) & D64_XS0_CD_MASK,
-		  struct dma64desc);
-
-	return NTXDACTIVE(curr, di->txout);
-}
-
-static uint _dma_txcommitted(struct dma_info *di)
-{
-	uint ptr;
-	uint txin = di->txin;
-
-	if (txin == di->txout)
-		return 0;
-
-	ptr = B2I(R_REG(&di->d64txregs->ptr), struct dma64desc);
-
-	return NTXDACTIVE(di->txin, ptr);
-}
-
-static uint _dma_rxactive(struct dma_info *di)
-{
-	return NRXDACTIVE(di->rxin, di->rxout);
-}
-
-static void _dma_counterreset(struct dma_info *di)
-{
-	/* reset all software counter */
-	di->dma.rxgiants = 0;
-	di->dma.rxnobuf = 0;
-	di->dma.txnobuf = 0;
+	/* reset all software counters */
+	pub->rxgiants = 0;
+	pub->rxnobuf = 0;
+	pub->txnobuf = 0;
 }
 
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
@@ -1221,8 +1039,10 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 }
 
 /* get the address of the var in order to change later */
-static unsigned long _dma_getvar(struct dma_info *di, const char *name)
+unsigned long dma_getvar(struct dma_pub *pub, const char *name)
 {
+	struct dma_info *di = (struct dma_info *)pub;
+
 	if (!strcmp(name, "&txavail"))
 		return (unsigned long)&(di->dma.txavail);
 	return 0;
@@ -1269,8 +1089,9 @@ static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 
 /* 64-bit DMA functions */
 
-static void dma64_txinit(struct dma_info *di)
+void dma_txinit(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	u32 control = D64_XC_XE;
 
 	DMA_TRACE(("%s: dma_txinit\n", di->name));
@@ -1301,17 +1122,10 @@ static void dma64_txinit(struct dma_info *di)
 		_dma_ddtable_init(di, DMA_TX, di->txdpa);
 }
 
-static bool dma64_txenabled(struct dma_info *di)
+void dma_txsuspend(struct dma_pub *pub)
 {
-	u32 xc;
+	struct dma_info *di = (struct dma_info *)pub;
 
-	/* If the chip is dead, it is not enabled :-) */
-	xc = R_REG(&di->d64txregs->control);
-	return (xc != 0xffffffff) && (xc & D64_XC_XE);
-}
-
-static void dma64_txsuspend(struct dma_info *di)
-{
 	DMA_TRACE(("%s: dma_txsuspend\n", di->name));
 
 	if (di->ntxd == 0)
@@ -1320,8 +1134,10 @@ static void dma64_txsuspend(struct dma_info *di)
 	OR_REG(&di->d64txregs->control, D64_XC_SE);
 }
 
-static void dma64_txresume(struct dma_info *di)
+void dma_txresume(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
+
 	DMA_TRACE(("%s: dma_txresume\n", di->name));
 
 	if (di->ntxd == 0)
@@ -1330,15 +1146,18 @@ static void dma64_txresume(struct dma_info *di)
 	AND_REG(&di->d64txregs->control, ~D64_XC_SE);
 }
 
-static bool dma64_txsuspended(struct dma_info *di)
+bool dma_txsuspended(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
+
 	return (di->ntxd == 0) ||
 	    ((R_REG(&di->d64txregs->control) & D64_XC_SE) ==
 	     D64_XC_SE);
 }
 
-static void dma64_txreclaim(struct dma_info *di, enum txd_range range)
+void dma_txreclaim(struct dma_pub *pub, enum txd_range range)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	void *p;
 
 	DMA_TRACE(("%s: dma_txreclaim %s\n", di->name,
@@ -1350,25 +1169,13 @@ static void dma64_txreclaim(struct dma_info *di, enum txd_range range)
 	if (di->txin == di->txout)
 		return;
 
-	while ((p = dma64_getnexttxp(di, range))) {
+	while ((p = dma_getnexttxp(pub, range))) {
 		/* For unframed data, we don't have any packets to free */
 		if (!(di->dma.dmactrlflags & DMA_CTRL_UNFRAMED))
 			brcmu_pkt_buf_free_skb(p);
 	}
 }
 
-static bool dma64_txstopped(struct dma_info *di)
-{
-	return ((R_REG(&di->d64txregs->status0) & D64_XS0_XS_MASK) ==
-		D64_XS0_XS_STOPPED);
-}
-
-static bool dma64_rxstopped(struct dma_info *di)
-{
-	return ((R_REG(&di->d64rxregs->status0) & D64_RS0_RS_MASK) ==
-		D64_RS0_RS_STOPPED);
-}
-
 static bool dma64_alloc(struct dma_info *di, uint direction)
 {
 	u16 size;
@@ -1421,8 +1228,9 @@ static bool dma64_alloc(struct dma_info *di, uint direction)
 	return true;
 }
 
-static bool dma64_txreset(struct dma_info *di)
+bool dma_txreset(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	u32 status;
 
 	if (di->ntxd == 0)
@@ -1457,8 +1265,9 @@ static bool dma64_rxidle(struct dma_info *di)
 		(R_REG(&di->d64rxregs->ptr) & D64_RS0_CD_MASK));
 }
 
-static bool dma64_rxreset(struct dma_info *di)
+bool dma_rxreset(struct dma_pub *pub)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	u32 status;
 
 	if (di->nrxd == 0)
@@ -1472,128 +1281,15 @@ static bool dma64_rxreset(struct dma_info *di)
 	return status == D64_RS0_RS_DISABLED;
 }
 
-static bool dma64_rxenabled(struct dma_info *di)
-{
-	u32 rc;
-
-	rc = R_REG(&di->d64rxregs->control);
-	return (rc != 0xffffffff) && (rc & D64_RC_RE);
-}
-
-static bool dma64_txsuspendedidle(struct dma_info *di)
-{
-
-	if (di->ntxd == 0)
-		return true;
-
-	if (!(R_REG(&di->d64txregs->control) & D64_XC_SE))
-		return 0;
-
-	if ((R_REG(&di->d64txregs->status0) & D64_XS0_XS_MASK) ==
-	    D64_XS0_XS_IDLE)
-		return 1;
-
-	return 0;
-}
-
-/*
- * Useful when sending unframed data.  This allows us to get a progress report
- * from the DMA. We return a pointer to the beginning of the DATA buffer of the
- * current descriptor. If DMA is idle, we return NULL.
- */
-static void *dma64_getpos(struct dma_info *di, bool direction)
-{
-	void *va;
-	bool idle;
-	u32 cd_offset;
-
-	if (direction == DMA_TX) {
-		cd_offset =
-		    R_REG(&di->d64txregs->status0) & D64_XS0_CD_MASK;
-		idle = !NTXDACTIVE(di->txin, di->txout);
-		va = di->txp[B2I(cd_offset, struct dma64desc)];
-	} else {
-		cd_offset =
-		    R_REG(&di->d64rxregs->status0) & D64_XS0_CD_MASK;
-		idle = !NRXDACTIVE(di->rxin, di->rxout);
-		va = di->rxp[B2I(cd_offset, struct dma64desc)];
-	}
-
-	/* If DMA is IDLE, return NULL */
-	if (idle) {
-		DMA_TRACE(("%s: DMA idle, return NULL\n", __func__));
-		va = NULL;
-	}
-
-	return va;
-}
-
-/* TX of unframed data
- *
- * Adds a DMA ring descriptor for the data pointed to by "buf".
- * This is for DMA of a buffer of data and is unlike other dma TX functions
- * that take a pointer to a "packet"
- * Each call to this is results in a single descriptor being added for "len"
- * bytes of data starting at "buf", it doesn't handle chained buffers.
- */
-static int
-dma64_txunframed(struct dma_info *di, void *buf, uint len, bool commit)
-{
-	u16 txout;
-	u32 flags = 0;
-	unsigned long pa;		/* phys addr */
-
-	txout = di->txout;
-
-	/* return nonzero if out of tx descriptors */
-	if (NEXTTXD(txout) == di->txin)
-		goto outoftxd;
-
-	if (len == 0)
-		return 0;
-
-	pa = pci_map_single(di->pbus, buf, len, PCI_DMA_TODEVICE);
-
-	flags = (D64_CTRL1_SOF | D64_CTRL1_IOC | D64_CTRL1_EOF);
-
-	if (txout == (di->ntxd - 1))
-		flags |= D64_CTRL1_EOT;
-
-	dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
-
-	/* save the buffer pointer - used by dma_getpos */
-	di->txp[txout] = buf;
-
-	txout = NEXTTXD(txout);
-	/* bump the tx descriptor index */
-	di->txout = txout;
-
-	/* kick the chip */
-	if (commit)
-		W_REG(&di->d64txregs->ptr,
-		      di->xmtptrbase + I2B(txout, struct dma64desc));
-
-	/* tx flow control */
-	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
-
-	return 0;
-
- outoftxd:
-	DMA_ERROR(("%s: %s: out of txds !!!\n", di->name, __func__));
-	di->dma.txavail = 0;
-	di->dma.txnobuf++;
-	return -1;
-}
-
 /*
  * !! tx entry routine
  * WARNING: call must check the return value for error.
  *   the error(toss frames) could be fatal and cause many subsequent hard
  *   to debug problems
  */
-static int dma64_txfast(struct dma_info *di, struct sk_buff *p0,
-				    bool commit)
+int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	struct sk_buff *p, *next;
 	unsigned char *data;
 	uint len;
@@ -1713,8 +1409,9 @@ static int dma64_txfast(struct dma_info *di, struct sk_buff *p0,
  * If range is DMA_RANGE_ALL, reclaim all txd(s) posted to the ring and
  * return associated packet regardless of the value of hardware pointers.
  */
-static void *dma64_getnexttxp(struct dma_info *di, enum txd_range range)
+void *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 {
+	struct dma_info *di = (struct dma_info *)pub;
 	u16 start, end, i;
 	u16 active_desc;
 	void *txp;
@@ -1857,80 +1554,6 @@ static bool _dma64_addrext(struct dma64regs *dma64regs)
 }
 
 /*
- * Rotate all active tx dma ring entries "forward" by (ActiveDescriptor - txin).
- */
-static void dma64_txrotate(struct dma_info *di)
-{
-	u16 ad;
-	uint nactive;
-	uint rot;
-	u16 old, new;
-	u32 w;
-	u16 first, last;
-
-	nactive = _dma_txactive(di);
-	ad = (u16) (B2I((((R_REG(&di->d64txregs->status1) &
-			   D64_XS1_AD_MASK) - di->xmtptrbase) &
-			   D64_XS1_AD_MASK), struct dma64desc));
-	rot = TXD(ad - di->txin);
-
-	/* full-ring case is a lot harder - don't worry about this */
-	if (rot >= (di->ntxd - nactive)) {
-		DMA_ERROR(("%s: dma_txrotate: ring full - punt\n", di->name));
-		return;
-	}
-
-	first = di->txin;
-	last = PREVTXD(di->txout);
-
-	/* move entries starting at last and moving backwards to first */
-	for (old = last; old != PREVTXD(first); old = PREVTXD(old)) {
-		new = TXD(old + rot);
-
-		/*
-		 * Move the tx dma descriptor.
-		 * EOT is set only in the last entry in the ring.
-		 */
-		w = BUS_SWAP32(R_SM(&di->txd64[old].ctrl1)) & ~D64_CTRL1_EOT;
-		if (new == (di->ntxd - 1))
-			w |= D64_CTRL1_EOT;
-		W_SM(&di->txd64[new].ctrl1, BUS_SWAP32(w));
-
-		w = BUS_SWAP32(R_SM(&di->txd64[old].ctrl2));
-		W_SM(&di->txd64[new].ctrl2, BUS_SWAP32(w));
-
-		W_SM(&di->txd64[new].addrlow, R_SM(&di->txd64[old].addrlow));
-		W_SM(&di->txd64[new].addrhigh, R_SM(&di->txd64[old].addrhigh));
-
-		/* zap the old tx dma descriptor address field */
-		W_SM(&di->txd64[old].addrlow, BUS_SWAP32(0xdeadbeef));
-		W_SM(&di->txd64[old].addrhigh, BUS_SWAP32(0xdeadbeef));
-
-		/* move the corresponding txp[] entry */
-		di->txp[new] = di->txp[old];
-
-		/* Move the map */
-		if (DMASGLIST_ENAB) {
-			memcpy(&di->txp_dmah[new], &di->txp_dmah[old],
-			       sizeof(struct dma_seg_map));
-			memset(&di->txp_dmah[old], 0,
-			       sizeof(struct dma_seg_map));
-		}
-
-		di->txp[old] = NULL;
-	}
-
-	/* update txin and txout */
-	di->txin = ad;
-	di->txout = TXD(di->txout + rot);
-	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
-
-	/* kick the chip */
-	W_REG(&di->d64txregs->ptr,
-	      di->xmtptrbase + I2B(di->txout, struct dma64desc));
-}
-
-/*
  * Mac80211 initiated actions sometimes require packets in the DMA queue to be
  * modified. The modified portion of the packet is not under control of the DMA
  * engine. This function calls a caller-supplied function for each packet in
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index f75a020..3b23517 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -59,66 +59,11 @@ enum txd_range {
 	DMA_RANGE_TRANSFERED
 };
 
-/* dma opsvec */
-struct di_fcn_s {
-	void (*detach)(struct dma_pub *dmah);
-	void (*txinit)(struct dma_pub *dmah);
-	bool (*txreset)(struct dma_pub *dmah);
-	bool (*txenabled)(struct dma_pub *dmah);
-	void (*txsuspend)(struct dma_pub *dmah);
-	void (*txresume)(struct dma_pub *dmah);
-	bool (*txsuspended)(struct dma_pub *dmah);
-	bool (*txsuspendedidle)(struct dma_pub *dmah);
-	int (*txfast)(struct dma_pub *dmah, struct sk_buff *p, bool commit);
-	int (*txunframed)(struct dma_pub *dmah, void *p, uint len, bool commit);
-
-	void *(*getpos)(struct dma_pub *di, bool direction);
-	bool (*txstopped)(struct dma_pub *dmah);
-	void (*txreclaim)(struct dma_pub *dmah, enum txd_range range);
-	void *(*getnexttxp)(struct dma_pub *dmah, enum txd_range range);
-	void *(*peeknexttxp) (struct dma_pub *dmah);
-	void (*txblock) (struct dma_pub *dmah);
-	void (*txunblock) (struct dma_pub *dmah);
-	uint (*txactive)(struct dma_pub *dmah);
-	void (*txrotate) (struct dma_pub *dmah);
-
-	void (*rxinit)(struct dma_pub *dmah);
-	bool (*rxreset)(struct dma_pub *dmah);
-	bool (*rxidle)(struct dma_pub *dmah);
-	bool (*rxstopped)(struct dma_pub *dmah);
-	bool (*rxenable)(struct dma_pub *dmah);
-	bool (*rxenabled)(struct dma_pub *dmah);
-	void *(*rx)(struct dma_pub *dmah);
-	bool (*rxfill)(struct dma_pub *dmah);
-	void (*rxreclaim)(struct dma_pub *dmah);
-	void *(*getnextrxp)(struct dma_pub *dmah, bool forceall);
-	void *(*peeknextrxp)(struct dma_pub *dmah);
-	void (*rxparam_get)(struct dma_pub *dmah, u16 *rxoffset,
-			    u16 *rxbufsize);
-
-	void (*fifoloopbackenable)(struct dma_pub *dmah);
-	unsigned long (*d_getvar)(struct dma_pub *dmah, const char *name);
-
-	void (*counterreset)(struct dma_pub *dmah);
-	uint (*ctrlflags)(struct dma_pub *dmah, uint mask, uint flags);
-	char *(*dump)(struct dma_pub *dmah, struct brcmu_strbuf *b,
-		      bool dumpring);
-	char *(*dumptx)(struct dma_pub *dmah, struct brcmu_strbuf *b,
-			bool dumpring);
-	char *(*dumprx)(struct dma_pub *dmah, struct brcmu_strbuf *b,
-			bool dumpring);
-	uint (*rxactive)(struct dma_pub *dmah);
-	uint (*txpending)(struct dma_pub *dmah);
-	uint (*txcommitted)(struct dma_pub *dmah);
-	uint endnum;
-};
-
 /*
  * Exported data structure (read-only)
  */
 /* export structure */
 struct dma_pub {
-	const struct di_fcn_s *di_fn;	/* DMA function pointers */
 	uint txavail;		/* # free tx descriptors */
 	uint dmactrlflags;	/* dma control flags */
 
@@ -134,49 +79,22 @@ extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 			    uint nrxd, uint rxbufsize, int rxextheadroom,
 			    uint nrxpost, uint rxoffset, uint *msg_level);
 
-extern const struct di_fcn_s dma64proc;
-
-#define dma_detach(di)			(dma64proc.detach(di))
-#define dma_txreset(di)			(dma64proc.txreset(di))
-#define dma_rxreset(di)			(dma64proc.rxreset(di))
-#define dma_rxidle(di)			(dma64proc.rxidle(di))
-#define dma_txinit(di)                  (dma64proc.txinit(di))
-#define dma_txenabled(di)               (dma64proc.txenabled(di))
-#define dma_rxinit(di)                  (dma64proc.rxinit(di))
-#define dma_txsuspend(di)               (dma64proc.txsuspend(di))
-#define dma_txresume(di)                (dma64proc.txresume(di))
-#define dma_txsuspended(di)             (dma64proc.txsuspended(di))
-#define dma_txsuspendedidle(di)         (dma64proc.txsuspendedidle(di))
-#define dma_txfast(di, p, commit)	(dma64proc.txfast(di, p, commit))
-#define dma_txunframed(di, p, l, commit)(dma64proc.txunframed(di, p, l, commit))
-#define dma_getpos(di, dir)		(dma64proc.getpos(di, dir))
-#define dma_fifoloopbackenable(di)      (dma64proc.fifoloopbackenable(di))
-#define dma_txstopped(di)               (dma64proc.txstopped(di))
-#define dma_rxstopped(di)               (dma64proc.rxstopped(di))
-#define dma_rxenable(di)                (dma64proc.rxenable(di))
-#define dma_rxenabled(di)               (dma64proc.rxenabled(di))
-#define dma_rx(di)                      (dma64proc.rx(di))
-#define dma_rxfill(di)                  (dma64proc.rxfill(di))
-#define dma_txreclaim(di, range)	(dma64proc.txreclaim(di, range))
-#define dma_rxreclaim(di)               (dma64proc.rxreclaim(di))
-#define dma_getvar(di, name)		(dma64proc.d_getvar(di, name))
-#define dma_getnexttxp(di, range)	(dma64proc.getnexttxp(di, range))
-#define dma_getnextrxp(di, forceall)    (dma64proc.getnextrxp(di, forceall))
-#define dma_peeknexttxp(di)             (dma64proc.peeknexttxp(di))
-#define dma_peeknextrxp(di)             (dma64proc.peeknextrxp(di))
-#define dma_rxparam_get(di, off, bufs)	(dma64proc.rxparam_get(di, off, bufs))
-
-#define dma_txblock(di)                 (dma64proc.txblock(di))
-#define dma_txunblock(di)               (dma64proc.txunblock(di))
-#define dma_txactive(di)                (dma64proc.txactive(di))
-#define dma_rxactive(di)                (dma64proc.rxactive(di))
-#define dma_txrotate(di)                (dma64proc.txrotate(di))
-#define dma_counterreset(di)            (dma64proc.counterreset(di))
-#define dma_ctrlflags(di, mask, flags) \
-	(dma64proc.ctrlflags((di), (mask), (flags)))
-#define dma_txpending(di)		(dma64proc.txpending(di))
-#define dma_txcommitted(di)		(dma64proc.txcommitted(di))
-
+void dma_rxinit(struct dma_pub *pub);
+void *dma_rx(struct dma_pub *pub);
+bool dma_rxfill(struct dma_pub *pub);
+bool dma_rxreset(struct dma_pub *pub);
+bool dma_txreset(struct dma_pub *pub);
+void dma_txinit(struct dma_pub *pub);
+int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit);
+void dma_txsuspend(struct dma_pub *pub);
+bool dma_txsuspended(struct dma_pub *pub);
+void dma_txresume(struct dma_pub *pub);
+void dma_txreclaim(struct dma_pub *pub, enum txd_range range);
+void dma_rxreclaim(struct dma_pub *pub);
+void dma_detach(struct dma_pub *pub);
+unsigned long dma_getvar(struct dma_pub *pub, const char *name);
+void *dma_getnexttxp(struct dma_pub *pub, enum txd_range range);
+void dma_counterreset(struct dma_pub *pub);
 
 void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a);
-- 
1.7.4.1


