Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34572 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316Ab2JZOYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 13/18] brcmsmac: Add DMA debug macro
Date: Fri, 26 Oct 2012 09:23:28 -0500
Message-Id: <1351261413-20821-14-git-send-email-seth.forshee@canonical.com> (sfid-20121026_163931_742778_BC2F43D1)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also convert relevant messages to use this macro.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/brcms_debug.h  |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |  155 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/dma.h      |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   10 +-
 drivers/net/wireless/brcm80211/include/defs.h      |    1 +
 5 files changed, 73 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
index 16f7304..5bfe97f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
@@ -40,5 +40,6 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 #define BRCMS_DBG_RX(core, f, a...)		BRCMS_DBG(core, BRCM_DL_RX, f, ##a)
 #define BRCMS_DBG_TX(core, f, a...)		BRCMS_DBG(core, BRCM_DL_TX, f, ##a)
 #define BRCMS_DBG_INT(core, f, a...)		BRCMS_DBG(core, BRCM_DL_INT, f, ##a)
+#define BRCMS_DBG_DMA(core, f, a...)		BRCMS_DBG(core, BRCM_DL_DMA, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index d7ce1ac..5b5dd3c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
@@ -30,6 +28,7 @@
 #include "soc.h"
 #include "scb.h"
 #include "ampdu.h"
+#include "brcms_debug.h"
 
 /*
  * dma register field offset calculation
@@ -181,28 +180,6 @@
 
 #define BCMEXTRAHDROOM 172
 
-/* debug/trace */
-#ifdef DEBUG
-#define	DMA_ERROR(fmt, ...)					\
-do {								\
-	if (*di->msg_level & 1)					\
-		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
-} while (0)
-#define	DMA_TRACE(fmt, ...)					\
-do {								\
-	if (*di->msg_level & 2)					\
-		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
-} while (0)
-#else
-#define	DMA_ERROR(fmt, ...)			\
-	no_printk(fmt, ##__VA_ARGS__)
-#define	DMA_TRACE(fmt, ...)			\
-	no_printk(fmt, ##__VA_ARGS__)
-#endif				/* DEBUG */
-
-#define	DMA_NONE(fmt, ...)			\
-	no_printk(fmt, ##__VA_ARGS__)
-
 #define	MAXNAMEL	8	/* 8 char names */
 
 /* macros to convert between byte offsets and indexes */
@@ -229,7 +206,6 @@ struct dma64desc {
 /* dma engine software state */
 struct dma_info {
 	struct dma_pub dma; /* exported structure */
-	uint *msg_level;	/* message level pointer */
 	char name[MAXNAMEL];	/* callers name for diag msgs */
 
 	struct bcma_device *core;
@@ -306,12 +282,6 @@ struct dma_info {
 	bool aligndesc_4k;
 };
 
-/*
- * default dma message level (if input msg_level
- * pointer is null in dma_attach())
- */
-static uint dma_msg_level;
-
 /* Check for odd number of 1's */
 static u32 parity32(__le32 data)
 {
@@ -379,7 +349,7 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 	uint dmactrlflags;
 
 	if (di == NULL) {
-		DMA_ERROR("NULL dma handle\n");
+		BRCMS_DBG_DMA(di->core, "NULL dma handle\n");
 		return 0;
 	}
 
@@ -431,13 +401,15 @@ static bool _dma_isaddrext(struct dma_info *di)
 	/* not all tx or rx channel are available */
 	if (di->d64txregbase != 0) {
 		if (!_dma64_addrext(di, DMA64TXREGOFFS(di, control)))
-			DMA_ERROR("%s: DMA64 tx doesn't have AE set\n",
-				  di->name);
+			BRCMS_DBG_DMA(di->core,
+				      "%s: DMA64 tx doesn't have AE set\n",
+				      di->name);
 		return true;
 	} else if (di->d64rxregbase != 0) {
 		if (!_dma64_addrext(di, DMA64RXREGOFFS(di, control)))
-			DMA_ERROR("%s: DMA64 rx doesn't have AE set\n",
-				  di->name);
+			BRCMS_DBG_DMA(di->core,
+				      "%s: DMA64 rx doesn't have AE set\n",
+				      di->name);
 		return true;
 	}
 
@@ -538,8 +510,9 @@ static bool dma64_alloc(struct dma_info *di, uint direction)
 		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
 			&alloced, &di->txdpaorig);
 		if (va == NULL) {
-			DMA_ERROR("%s: DMA_ALLOC_CONSISTENT(ntxd) failed\n",
-				  di->name);
+			BRCMS_DBG_DMA(di->core,
+				      "%s: DMA_ALLOC_CONSISTENT(ntxd) failed\n",
+				      di->name);
 			return false;
 		}
 		align = (1 << align_bits);
@@ -552,8 +525,9 @@ static bool dma64_alloc(struct dma_info *di, uint direction)
 		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
 			&alloced, &di->rxdpaorig);
 		if (va == NULL) {
-			DMA_ERROR("%s: DMA_ALLOC_CONSISTENT(nrxd) failed\n",
-				  di->name);
+			BRCMS_DBG_DMA(di->core,
+				      "%s: DMA_ALLOC_CONSISTENT(nrxd) failed\n",
+				      di->name);
 			return false;
 		}
 		align = (1 << align_bits);
@@ -575,7 +549,7 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 			   uint txregbase, uint rxregbase, uint ntxd, uint nrxd,
 			   uint rxbufsize, int rxextheadroom,
-			   uint nrxpost, uint rxoffset, uint *msg_level)
+			   uint nrxpost, uint rxoffset)
 {
 	struct si_pub *sih = wlc->hw->sih;
 	struct bcma_device *core = wlc->hw->d11core;
@@ -589,9 +563,6 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 	if (di == NULL)
 		return NULL;
 
-	di->msg_level = msg_level ? msg_level : &dma_msg_level;
-
-
 	di->dma64 =
 		((bcma_aread32(core, BCMA_IOST) & SISF_DMA64) == SISF_DMA64);
 
@@ -607,11 +578,11 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 	 */
 	_dma_ctrlflags(di, DMA_CTRL_ROC | DMA_CTRL_PEN, 0);
 
-	DMA_TRACE("%s: %s flags 0x%x ntxd %d nrxd %d "
-		  "rxbufsize %d rxextheadroom %d nrxpost %d rxoffset %d "
-		  "txregbase %u rxregbase %u\n", name, "DMA64",
-		  di->dma.dmactrlflags, ntxd, nrxd, rxbufsize,
-		  rxextheadroom, nrxpost, rxoffset, txregbase, rxregbase);
+	BRCMS_DBG_DMA(di->core, "%s: %s flags 0x%x ntxd %d nrxd %d "
+		      "rxbufsize %d rxextheadroom %d nrxpost %d rxoffset %d "
+		      "txregbase %u rxregbase %u\n", name, "DMA64",
+		      di->dma.dmactrlflags, ntxd, nrxd, rxbufsize,
+		      rxextheadroom, nrxpost, rxoffset, txregbase, rxregbase);
 
 	/* make a private copy of our callers name */
 	strncpy(di->name, name, MAXNAMEL);
@@ -673,8 +644,8 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 		di->dmadesc_align = 4;	/* 16 byte alignment */
 	}
 
-	DMA_NONE("DMA descriptor align_needed %d, align %d\n",
-		 di->aligndesc_4k, di->dmadesc_align);
+	BRCMS_DBG_DMA(di->core, "DMA descriptor align_needed %d, align %d\n",
+		      di->aligndesc_4k, di->dmadesc_align);
 
 	/* allocate tx packet pointer vector */
 	if (ntxd) {
@@ -712,13 +683,15 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 
 	if ((di->ddoffsetlow != 0) && !di->addrext) {
 		if (di->txdpa > SI_PCI_DMA_SZ) {
-			DMA_ERROR("%s: txdpa 0x%x: addrext not supported\n",
-				  di->name, (u32)di->txdpa);
+			BRCMS_DBG_DMA(di->core,
+				      "%s: txdpa 0x%x: addrext not supported\n",
+				      di->name, (u32)di->txdpa);
 			goto fail;
 		}
 		if (di->rxdpa > SI_PCI_DMA_SZ) {
-			DMA_ERROR("%s: rxdpa 0x%x: addrext not supported\n",
-				  di->name, (u32)di->rxdpa);
+			BRCMS_DBG_DMA(di->core,
+				      "%s: rxdpa 0x%x: addrext not supported\n",
+				      di->name, (u32)di->rxdpa);
 			goto fail;
 		}
 	}
@@ -726,10 +699,11 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 	/* Initialize AMPDU session */
 	brcms_c_ampdu_reset_session(&di->ampdu_session, wlc);
 
-	DMA_TRACE("ddoffsetlow 0x%x ddoffsethigh 0x%x dataoffsetlow 0x%x dataoffsethigh 0x%x addrext %d\n",
-		  di->ddoffsetlow, di->ddoffsethigh,
-		  di->dataoffsetlow, di->dataoffsethigh,
-		  di->addrext);
+	BRCMS_DBG_DMA(di->core,
+		      "ddoffsetlow 0x%x ddoffsethigh 0x%x dataoffsetlow 0x%x dataoffsethigh 0x%x addrext %d\n",
+		      di->ddoffsetlow, di->ddoffsethigh,
+		      di->dataoffsetlow, di->dataoffsethigh,
+		      di->addrext);
 
 	return (struct dma_pub *) di;
 
@@ -775,7 +749,7 @@ void dma_detach(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	/* free dma descriptor rings */
 	if (di->txd64)
@@ -851,7 +825,7 @@ static void _dma_rxenable(struct dma_info *di)
 	uint dmactrlflags = di->dma.dmactrlflags;
 	u32 control;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	control = D64_RC_RE | (bcma_read32(di->core,
 					   DMA64RXREGOFFS(di, control)) &
@@ -871,7 +845,7 @@ void dma_rxinit(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	if (di->nrxd == 0)
 		return;
@@ -966,7 +940,7 @@ int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list)
 		return 0;
 
 	len = le16_to_cpu(*(__le16 *) (p->data));
-	DMA_TRACE("%s: dma_rx len %d\n", di->name, len);
+	BRCMS_DBG_DMA(di->core, "%s: dma_rx len %d\n", di->name, len);
 	dma_spin_for_len(len, p);
 
 	/* set actual length */
@@ -993,14 +967,15 @@ int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list)
 					      DMA64RXREGOFFS(di, status0)) &
 				  D64_RS0_CD_MASK) - di->rcvptrbase) &
 				D64_RS0_CD_MASK, struct dma64desc);
-			DMA_ERROR("rxin %d rxout %d, hw_curr %d\n",
-				   di->rxin, di->rxout, cur);
+			BRCMS_DBG_DMA(di->core,
+				      "rxin %d rxout %d, hw_curr %d\n",
+				      di->rxin, di->rxout, cur);
 		}
 #endif				/* DEBUG */
 
 		if ((di->dma.dmactrlflags & DMA_CTRL_RXMULTI) == 0) {
-			DMA_ERROR("%s: bad frame length (%d)\n",
-				  di->name, len);
+			BRCMS_DBG_DMA(di->core, "%s: bad frame length (%d)\n",
+				      di->name, len);
 			skb_queue_walk_safe(&dma_frames, p, next) {
 				skb_unlink(p, &dma_frames);
 				brcmu_pkt_buf_free_skb(p);
@@ -1017,7 +992,7 @@ int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list)
 
 static bool dma64_rxidle(struct dma_info *di)
 {
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	if (di->nrxd == 0)
 		return true;
@@ -1070,7 +1045,7 @@ bool dma_rxfill(struct dma_pub *pub)
 
 	n = di->nrxpost - nrxdactive(di, rxin, rxout);
 
-	DMA_TRACE("%s: post %d\n", di->name, n);
+	BRCMS_DBG_DMA(di->core, "%s: post %d\n", di->name, n);
 
 	if (di->rxbufsize > BCMEXTRAHDROOM)
 		extra_offset = di->rxextrahdrroom;
@@ -1083,9 +1058,11 @@ bool dma_rxfill(struct dma_pub *pub)
 		p = brcmu_pkt_buf_get_skb(di->rxbufsize + extra_offset);
 
 		if (p == NULL) {
-			DMA_ERROR("%s: out of rxbufs\n", di->name);
+			BRCMS_DBG_DMA(di->core, "%s: out of rxbufs\n",
+				      di->name);
 			if (i == 0 && dma64_rxidle(di)) {
-				DMA_ERROR("%s: ring is empty !\n", di->name);
+				BRCMS_DBG_DMA(di->core, "%s: ring is empty !\n",
+					      di->name);
 				ring_empty = true;
 			}
 			di->dma.rxnobuf++;
@@ -1130,7 +1107,7 @@ void dma_rxreclaim(struct dma_pub *pub)
 	struct dma_info *di = (struct dma_info *)pub;
 	struct sk_buff *p;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	while ((p = _dma_getnextrxp(di, true)))
 		brcmu_pkt_buf_free_skb(p);
@@ -1161,7 +1138,7 @@ void dma_txinit(struct dma_pub *pub)
 	struct dma_info *di = (struct dma_info *)pub;
 	u32 control = D64_XC_XE;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	if (di->ntxd == 0)
 		return;
@@ -1193,7 +1170,7 @@ void dma_txsuspend(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	if (di->ntxd == 0)
 		return;
@@ -1205,7 +1182,7 @@ void dma_txresume(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	if (di->ntxd == 0)
 		return;
@@ -1228,11 +1205,11 @@ void dma_txreclaim(struct dma_pub *pub, enum txd_range range)
 	struct dma_info *di = (struct dma_info *)pub;
 	struct sk_buff *p;
 
-	DMA_TRACE("%s: %s\n",
-		  di->name,
-		  range == DMA_RANGE_ALL ? "all" :
-		  range == DMA_RANGE_TRANSMITTED ? "transmitted" :
-		  "transferred");
+	BRCMS_DBG_DMA(di->core, "%s: %s\n",
+		      di->name,
+		      range == DMA_RANGE_ALL ? "all" :
+		      range == DMA_RANGE_TRANSMITTED ? "transmitted" :
+		      "transferred");
 
 	if (di->txin == di->txout)
 		return;
@@ -1392,7 +1369,7 @@ int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
 	struct ieee80211_tx_info *tx_info;
 	bool is_ampdu;
 
-	DMA_TRACE("%s:\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s:\n", di->name);
 
 	/* no use to transmit a zero length packet */
 	if (p->len == 0)
@@ -1430,7 +1407,7 @@ int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
 	return 0;
 
  outoftxd:
-	DMA_ERROR("%s: out of txds !!!\n", di->name);
+	BRCMS_DBG_DMA(di->core, "%s: out of txds !!!\n", di->name);
 	brcmu_pkt_buf_free_skb(p);
 	di->dma.txavail = 0;
 	di->dma.txnobuf++;
@@ -1482,11 +1459,11 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	u16 active_desc;
 	struct sk_buff *txp;
 
-	DMA_TRACE("%s: %s\n",
-		  di->name,
-		  range == DMA_RANGE_ALL ? "all" :
-		  range == DMA_RANGE_TRANSMITTED ? "transmitted" :
-		  "transferred");
+	BRCMS_DBG_DMA(di->core, "%s: %s\n",
+		      di->name,
+		      range == DMA_RANGE_ALL ? "all" :
+		      range == DMA_RANGE_TRANSMITTED ? "transmitted" :
+		      "transferred");
 
 	if (di->ntxd == 0)
 		return NULL;
@@ -1545,8 +1522,8 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	return txp;
 
  bogus:
-	DMA_NONE("bogus curr: start %d end %d txout %d\n",
-		 start, end, di->txout);
+	BRCMS_DBG_DMA(di->core, "bogus curr: start %d end %d txout %d\n",
+		      start, end, di->txout);
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.h b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
index 459abf1..ff5b80b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
@@ -78,7 +78,7 @@ extern struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 				  uint txregbase, uint rxregbase,
 				  uint ntxd, uint nrxd,
 				  uint rxbufsize, int rxextheadroom,
-				  uint nrxpost, uint rxoffset, uint *msg_level);
+				  uint nrxpost, uint rxoffset);
 
 void dma_rxinit(struct dma_pub *pub);
 int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index ba64b38..2073f08 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1159,7 +1159,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 					   dmareg(DMA_RX, 0),
 					   (wme ? NTXD : 0), NRXD,
 					   RXBUFSZ, -1, NRXBUFPOST,
-					   BRCMS_HWRXOFF, &brcm_msg_level);
+					   BRCMS_HWRXOFF);
 		dma_attach_err |= (NULL == wlc_hw->di[0]);
 
 		/*
@@ -1170,8 +1170,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 */
 		wlc_hw->di[1] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 1), 0,
-					   NTXD, 0, 0, -1, 0, 0,
-					   &brcm_msg_level);
+					   NTXD, 0, 0, -1, 0, 0);
 		dma_attach_err |= (NULL == wlc_hw->di[1]);
 
 		/*
@@ -1181,8 +1180,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 */
 		wlc_hw->di[2] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 2), 0,
-					   NTXD, 0, 0, -1, 0, 0,
-					   &brcm_msg_level);
+					   NTXD, 0, 0, -1, 0, 0);
 		dma_attach_err |= (NULL == wlc_hw->di[2]);
 		/*
 		 * FIFO 3
@@ -1192,7 +1190,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		wlc_hw->di[3] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 3),
 					   0, NTXD, 0, 0, -1,
-					   0, 0, &brcm_msg_level);
+					   0, 0);
 		dma_attach_err |= (NULL == wlc_hw->di[3]);
 /* Cleaner to leave this as if with AP defined */
 
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index 12dd33f..54ffe7f 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -84,6 +84,7 @@
 #define BRCM_DL_RX		0x00000004
 #define BRCM_DL_TX		0x00000008
 #define BRCM_DL_INT		0x00000010
+#define BRCM_DL_DMA		0x00000020
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5

