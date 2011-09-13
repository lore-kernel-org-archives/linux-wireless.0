Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4053 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab1IMHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/17] staging: brcm80211: macro cleanup in softmac dma
Date: Tue, 13 Sep 2011 09:49:45 +0200
Message-ID: <1315900197-7260-6-git-send-email-rvossen@broadcom.com> (sfid-20110913_095058_256804_1D198299)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted macro's by functions. Renamed several struct members in dma.c
to get rid of a set of macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |  139 +++++++++++++++++-------------
 1 files changed, 80 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 63e5e0e..6c9b1fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -155,9 +155,6 @@
 #define D64_RX_FRM_STS_DSCRCNT	0x0f000000  /* no. of descriptors used - 1 */
 #define D64_RX_FRM_STS_DATATYPE	0xf0000000	/* core-dependent data type */
 
-#define DMA64_DD_PARITY(dd) \
-	parity32((dd)->addrlow ^ (dd)->addrhigh ^ (dd)->ctrl1 ^ (dd)->ctrl2)
-
 /*
  * packet headroom necessary to accommodate the largest header
  * in the system, (i.e TXOFF). By doing, we avoid the need to
@@ -192,27 +189,8 @@
 
 #define	DMA_NONE(args)
 
-#define d64txregs	dregs.d64_u.txregs_64
-#define d64rxregs	dregs.d64_u.rxregs_64
-#define txd64		dregs.d64_u.txd_64
-#define rxd64		dregs.d64_u.rxd_64
-
 #define	MAXNAMEL	8	/* 8 char names */
 
-/* descriptor bumping macros */
-/* faster than %, but n must be power of 2 */
-#define	XXD(x, n)	((x) & ((n) - 1))
-
-#define	TXD(x)		XXD((x), di->ntxd)
-#define	RXD(x)		XXD((x), di->nrxd)
-#define	NEXTTXD(i)	TXD((i) + 1)
-#define	PREVTXD(i)	TXD((i) - 1)
-#define	NEXTRXD(i)	RXD((i) + 1)
-#define	PREVRXD(i)	RXD((i) - 1)
-
-#define	NTXDACTIVE(h, t)	TXD((t) - (h))
-#define	NRXDACTIVE(h, t)	RXD((t) - (h))
-
 /* macros to convert between byte offsets and indexes */
 #define	B2I(bytes, type)	((bytes) / sizeof(type))
 #define	I2B(index, type)	((index) * sizeof(type))
@@ -245,18 +223,14 @@ struct dma_info {
 	bool dma64;	/* this dma engine is operating in 64-bit mode */
 	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
 
-	union {
-		struct {
-			/* 64-bit dma tx engine registers */
-			struct dma64regs *txregs_64;
-			/* 64-bit dma rx engine registers */
-			struct dma64regs *rxregs_64;
-			/* pointer to dma64 tx descriptor ring */
-			struct dma64desc *txd_64;
-			/* pointer to dma64 rx descriptor ring */
-			struct dma64desc *rxd_64;
-		} d64_u;
-	} dregs;
+	/* 64-bit dma tx engine registers */
+	struct dma64regs *d64txregs;
+	/* 64-bit dma rx engine registers */
+	struct dma64regs *d64rxregs;
+	/* pointer to dma64 tx descriptor ring */
+	struct dma64desc *txd64;
+	/* pointer to dma64 rx descriptor ring */
+	struct dma64desc *rxd64;
 
 	u16 dmadesc_align;	/* alignment requirement for dma descriptors */
 
@@ -320,6 +294,65 @@ struct dma_info {
  */
 static uint dma_msg_level;
 
+/* Check for odd number of 1's */
+static u32 parity32(u32 data)
+{
+	data ^= data >> 16;
+	data ^= data >> 8;
+	data ^= data >> 4;
+	data ^= data >> 2;
+	data ^= data >> 1;
+
+	return data & 1;
+}
+
+static bool dma64_dd_parity(struct dma64desc *dd)
+{
+	return parity32(dd->addrlow ^ dd->addrhigh ^ dd->ctrl1 ^ dd->ctrl2);
+}
+
+/* descriptor bumping functions */
+
+static uint xxd(uint x, uint n)
+{
+	return x & (n - 1); /* faster than %, but n must be power of 2 */
+}
+
+static uint txd(struct dma_info *di, uint x)
+{
+	return xxd(x, di->ntxd);
+}
+
+static uint rxd(struct dma_info *di, uint x)
+{
+	return xxd(x, di->nrxd);
+}
+
+static uint nexttxd(struct dma_info *di, uint i)
+{
+	return txd(di, i + 1);
+}
+
+static uint prevtxd(struct dma_info *di, uint i)
+{
+	return txd(di, i - 1);
+}
+
+static uint nextrxd(struct dma_info *di, uint i)
+{
+	return txd(di, i + 1);
+}
+
+static uint ntxdactive(struct dma_info *di, uint h, uint t)
+{
+	return txd(di, t-h);
+}
+
+static uint nrxdactive(struct dma_info *di, uint h, uint t)
+{
+	return rxd(di, t-h);
+}
+
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 {
 	uint dmactrlflags = di->dma.dmactrlflags;
@@ -675,18 +708,6 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	return NULL;
 }
 
-/* Check for odd number of 1's */
-static inline u32 parity32(u32 data)
-{
-	data ^= data >> 16;
-	data ^= data >> 8;
-	data ^= data >> 4;
-	data ^= data >> 2;
-	data ^= data >> 1;
-
-	return data & 1;
-}
-
 static inline void
 dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 	     dma_addr_t pa, uint outidx, u32 *flags, u32 bufcount)
@@ -713,7 +734,7 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 		ddring[outidx].ctrl2 = cpu_to_le32(ctrl2);
 	}
 	if (di->dma.dmactrlflags & DMA_CTRL_PEN) {
-		if (DMA64_DD_PARITY(&ddring[outidx]))
+		if (dma64_dd_parity(&ddring[outidx]))
 			ddring[outidx].ctrl2 =
 			     cpu_to_le32(ctrl2 | D64_CTRL2_PARITY);
 	}
@@ -866,7 +887,7 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 	di->rxd64[i].addrlow = 0xdeadbeef;
 	di->rxd64[i].addrhigh = 0xdeadbeef;
 
-	di->rxin = NEXTRXD(i);
+	di->rxin = nextrxd(di, i);
 
 	return rxp;
 }
@@ -988,7 +1009,7 @@ bool dma_rxfill(struct dma_pub *pub)
 	rxin = di->rxin;
 	rxout = di->rxout;
 
-	n = di->nrxpost - NRXDACTIVE(rxin, rxout);
+	n = di->nrxpost - nrxdactive(di, rxin, rxout);
 
 	DMA_TRACE(("%s: dma_rxfill: post %d\n", di->name, n));
 
@@ -1035,7 +1056,7 @@ bool dma_rxfill(struct dma_pub *pub)
 
 		dma64_dd_upd(di, di->rxd64, pa, rxout, &flags,
 			     di->rxbufsize);
-		rxout = NEXTRXD(rxout);
+		rxout = nextrxd(di, rxout);
 	}
 
 	di->rxout = rxout;
@@ -1237,7 +1258,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 		next = p->next;
 
 		/* return nonzero if out of tx descriptors */
-		if (NEXTTXD(txout) == di->txin)
+		if (nexttxd(di, txout) == di->txin)
 			goto outoftxd;
 
 		if (len == 0)
@@ -1262,16 +1283,16 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 
 		dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
 
-		txout = NEXTTXD(txout);
+		txout = nexttxd(di, txout);
 	}
 
 	/* if last txd eof not set, fix it */
 	if (!(flags & D64_CTRL1_EOF))
-		di->txd64[PREVTXD(txout)].ctrl1 =
+		di->txd64[prevtxd(di, txout)].ctrl1 =
 		     cpu_to_le32(flags | D64_CTRL1_IOC | D64_CTRL1_EOF);
 
 	/* save the packet */
-	di->txp[PREVTXD(txout)] = p0;
+	di->txp[prevtxd(di, txout)] = p0;
 
 	/* bump the tx descriptor index */
 	di->txout = txout;
@@ -1282,7 +1303,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 		      di->xmtptrbase + I2B(txout, struct dma64desc));
 
 	/* tx flow control */
-	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
+	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
 
 	return 0;
 
@@ -1341,14 +1362,14 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 			    (active_desc - di->xmtptrbase) & D64_XS0_CD_MASK;
 			active_desc = B2I(active_desc, struct dma64desc);
 			if (end != active_desc)
-				end = PREVTXD(active_desc);
+				end = prevtxd(di, active_desc);
 		}
 	}
 
 	if ((start == 0) && (end > di->txout))
 		goto bogus;
 
-	for (i = start; i != end && !txp; i = NEXTTXD(i)) {
+	for (i = start; i != end && !txp; i = nexttxd(di, i)) {
 		dma_addr_t pa;
 		uint size;
 
@@ -1370,7 +1391,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	di->txin = i;
 
 	/* tx flow control */
-	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
+	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
 
 	return txp;
 
@@ -1401,6 +1422,6 @@ void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 			tx_info = (struct ieee80211_tx_info *)skb->cb;
 			(callback_fnc)(tx_info, arg_a);
 		}
-		i = NEXTTXD(i);
+		i = nexttxd(di, i);
 	}
 }
-- 
1.7.4.1


