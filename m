Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4880 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 23/83] staging: brcm80211: removed 'hnd' from everything
 but function names
Date: Wed, 1 Jun 2011 13:45:08 +0200
Message-ID: <1306928768-7501-23-git-send-email-rvossen@broadcom.com> (sfid-20110601_134813_747550_D966122F)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. 'hnd' is a company specific acronym.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |   12 ++--
 drivers/staging/brcm80211/brcmfmac/rte_armtrap.h |    6 +-
 drivers/staging/brcm80211/brcmfmac/rte_cons.h    |   13 ++--
 drivers/staging/brcm80211/brcmsmac/bcmdma.h      |  102 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/bcmotp.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/dma.c         |   90 +++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_types.h   |    8 +--
 drivers/staging/brcm80211/include/bcmdefs.h      |    8 +-
 drivers/staging/brcm80211/include/bcmsdpcm.h     |    2 +-
 drivers/staging/brcm80211/include/sbdma.h        |    6 +-
 13 files changed, 123 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9593cff..6882c9f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -151,7 +151,7 @@ extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 typedef struct dhd_console {
 	uint count;		/* Poll interval msec counter */
 	uint log_addr;		/* Log struct address (fixed) */
-	hndrte_log_t log;	/* Log struct (host copy) */
+	rte_log_t log;	/* Log struct (host copy) */
 	uint bufsize;		/* Size of log buffer */
 	u8 *buf;		/* Log buffer (host copy) */
 	uint last;		/* Last buffer read index */
@@ -1733,7 +1733,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 		return -EBADE;
 	}
 
-	/* Read hndrte_shared structure */
+	/* Read rte_shared structure */
 	rv = dhdsdio_membytes(bus, false, addr, (u8 *) sh,
 			      sizeof(sdpcm_shared_t));
 	if (rv < 0)
@@ -1948,7 +1948,7 @@ static int dhdsdio_readconsole(dhd_bus_t *bus)
 		return 0;
 
 	/* Read console log struct */
-	addr = bus->console_addr + offsetof(hndrte_cons_t, log);
+	addr = bus->console_addr + offsetof(rte_cons_t, log);
 	rv = dhdsdio_membytes(bus, false, addr, (u8 *)&c->log,
 				sizeof(c->log));
 	if (rv < 0)
@@ -4825,20 +4825,20 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 	dhdsdio_clkctl(bus, CLK_AVAIL, false);
 
 	/* Zero cbuf_index */
-	addr = bus->console_addr + offsetof(hndrte_cons_t, cbuf_idx);
+	addr = bus->console_addr + offsetof(rte_cons_t, cbuf_idx);
 	val = cpu_to_le32(0);
 	rv = dhdsdio_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
 	if (rv < 0)
 		goto done;
 
 	/* Write message into cbuf */
-	addr = bus->console_addr + offsetof(hndrte_cons_t, cbuf);
+	addr = bus->console_addr + offsetof(rte_cons_t, cbuf);
 	rv = dhdsdio_membytes(bus, true, addr, (u8 *)msg, msglen);
 	if (rv < 0)
 		goto done;
 
 	/* Write length into vcons_in */
-	addr = bus->console_addr + offsetof(hndrte_cons_t, vcons_in);
+	addr = bus->console_addr + offsetof(rte_cons_t, vcons_in);
 	val = cpu_to_le32(msglen);
 	rv = dhdsdio_membytes(bus, true, addr, (u8 *)&val, sizeof(val));
 	if (rv < 0)
diff --git a/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h b/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
index 28f092c..ebb2237 100644
--- a/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
+++ b/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_hndrte_armtrap_h
-#define	_hndrte_armtrap_h
+#ifndef	_rte_armtrap_h
+#define	_rte_armtrap_h
 
 /* ARM trap handling */
 
@@ -72,4 +72,4 @@ typedef struct _trap_struct {
 
 #endif				/* !_LANGUAGE_ASSEMBLY */
 
-#endif				/* _hndrte_armtrap_h */
+#endif				/* _rte_armtrap_h */
diff --git a/drivers/staging/brcm80211/brcmfmac/rte_cons.h b/drivers/staging/brcm80211/brcmfmac/rte_cons.h
index 4df3eec..7977e08 100644
--- a/drivers/staging/brcm80211/brcmfmac/rte_cons.h
+++ b/drivers/staging/brcm80211/brcmfmac/rte_cons.h
@@ -13,8 +13,8 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#ifndef _hndrte_cons_h
-#define _hndrte_cons_h
+#ifndef _rte_cons_h
+#define _rte_cons_h
 
 #define CBUF_LEN	(128)
 
@@ -25,7 +25,7 @@ typedef struct {
 	uint buf_size;
 	uint idx;
 	char *_buf_compat;	/* Redundant pointer for backward compat. */
-} hndrte_log_t;
+} rte_log_t;
 
 typedef struct {
 	/* Virtual UART
@@ -46,7 +46,7 @@ typedef struct {
 	 * Output will be lost if the output wraps around faster than the host
 	 * polls.
 	 */
-	hndrte_log_t log;
+	rte_log_t log;
 
 	/* Console input line buffer
 	 * Characters are read one at a time into cbuf
@@ -56,7 +56,6 @@ typedef struct {
 	 */
 	uint cbuf_idx;
 	char cbuf[CBUF_LEN];
-} hndrte_cons_t;
-
-#endif /* _hndrte_cons_h */
+} rte_cons_t;
 
+#endif /* _rte_cons_h */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmdma.h b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
index fbbcb9b..fc68d49 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmdma.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
@@ -14,13 +14,13 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_hnddma_h_
-#define	_hnddma_h_
+#ifndef	_bcmdma_h_
+#define	_bcmdma_h_
 
-#ifndef _hnddma_pub_
-#define _hnddma_pub_
-struct hnddma_pub;
-#endif				/* _hnddma_pub_ */
+#ifndef _dma_pub_
+#define _dma_pub_
+struct dma_pub;
+#endif				/* _dma_pub_ */
 
 /* map/unmap direction */
 #define	DMA_TX	1		/* TX direction for DMA */
@@ -35,54 +35,54 @@ typedef enum txd_range {
 } txd_range_t;
 
 /* dma function type */
-typedef void (*di_detach_t) (struct hnddma_pub *dmah);
-typedef bool(*di_txreset_t) (struct hnddma_pub *dmah);
-typedef bool(*di_rxreset_t) (struct hnddma_pub *dmah);
-typedef bool(*di_rxidle_t) (struct hnddma_pub *dmah);
-typedef void (*di_txinit_t) (struct hnddma_pub *dmah);
-typedef bool(*di_txenabled_t) (struct hnddma_pub *dmah);
-typedef void (*di_rxinit_t) (struct hnddma_pub *dmah);
-typedef void (*di_txsuspend_t) (struct hnddma_pub *dmah);
-typedef void (*di_txresume_t) (struct hnddma_pub *dmah);
-typedef bool(*di_txsuspended_t) (struct hnddma_pub *dmah);
-typedef bool(*di_txsuspendedidle_t) (struct hnddma_pub *dmah);
-typedef int (*di_txfast_t) (struct hnddma_pub *dmah, struct sk_buff *p,
+typedef void (*di_detach_t) (struct dma_pub *dmah);
+typedef bool(*di_txreset_t) (struct dma_pub *dmah);
+typedef bool(*di_rxreset_t) (struct dma_pub *dmah);
+typedef bool(*di_rxidle_t) (struct dma_pub *dmah);
+typedef void (*di_txinit_t) (struct dma_pub *dmah);
+typedef bool(*di_txenabled_t) (struct dma_pub *dmah);
+typedef void (*di_rxinit_t) (struct dma_pub *dmah);
+typedef void (*di_txsuspend_t) (struct dma_pub *dmah);
+typedef void (*di_txresume_t) (struct dma_pub *dmah);
+typedef bool(*di_txsuspended_t) (struct dma_pub *dmah);
+typedef bool(*di_txsuspendedidle_t) (struct dma_pub *dmah);
+typedef int (*di_txfast_t) (struct dma_pub *dmah, struct sk_buff *p,
 			    bool commit);
-typedef int (*di_txunframed_t) (struct hnddma_pub *dmah, void *p, uint len,
+typedef int (*di_txunframed_t) (struct dma_pub *dmah, void *p, uint len,
 				bool commit);
-typedef void *(*di_getpos_t) (struct hnddma_pub *di, bool direction);
-typedef void (*di_fifoloopbackenable_t) (struct hnddma_pub *dmah);
-typedef bool(*di_txstopped_t) (struct hnddma_pub *dmah);
-typedef bool(*di_rxstopped_t) (struct hnddma_pub *dmah);
-typedef bool(*di_rxenable_t) (struct hnddma_pub *dmah);
-typedef bool(*di_rxenabled_t) (struct hnddma_pub *dmah);
-typedef void *(*di_rx_t) (struct hnddma_pub *dmah);
-typedef bool(*di_rxfill_t) (struct hnddma_pub *dmah);
-typedef void (*di_txreclaim_t) (struct hnddma_pub *dmah, txd_range_t range);
-typedef void (*di_rxreclaim_t) (struct hnddma_pub *dmah);
-typedef unsigned long (*di_getvar_t) (struct hnddma_pub *dmah,
+typedef void *(*di_getpos_t) (struct dma_pub *di, bool direction);
+typedef void (*di_fifoloopbackenable_t) (struct dma_pub *dmah);
+typedef bool(*di_txstopped_t) (struct dma_pub *dmah);
+typedef bool(*di_rxstopped_t) (struct dma_pub *dmah);
+typedef bool(*di_rxenable_t) (struct dma_pub *dmah);
+typedef bool(*di_rxenabled_t) (struct dma_pub *dmah);
+typedef void *(*di_rx_t) (struct dma_pub *dmah);
+typedef bool(*di_rxfill_t) (struct dma_pub *dmah);
+typedef void (*di_txreclaim_t) (struct dma_pub *dmah, txd_range_t range);
+typedef void (*di_rxreclaim_t) (struct dma_pub *dmah);
+typedef unsigned long (*di_getvar_t) (struct dma_pub *dmah,
 				      const char *name);
-typedef void *(*di_getnexttxp_t) (struct hnddma_pub *dmah, txd_range_t range);
-typedef void *(*di_getnextrxp_t) (struct hnddma_pub *dmah, bool forceall);
-typedef void *(*di_peeknexttxp_t) (struct hnddma_pub *dmah);
-typedef void *(*di_peeknextrxp_t) (struct hnddma_pub *dmah);
-typedef void (*di_rxparam_get_t) (struct hnddma_pub *dmah, u16 *rxoffset,
+typedef void *(*di_getnexttxp_t) (struct dma_pub *dmah, txd_range_t range);
+typedef void *(*di_getnextrxp_t) (struct dma_pub *dmah, bool forceall);
+typedef void *(*di_peeknexttxp_t) (struct dma_pub *dmah);
+typedef void *(*di_peeknextrxp_t) (struct dma_pub *dmah);
+typedef void (*di_rxparam_get_t) (struct dma_pub *dmah, u16 *rxoffset,
 				  u16 *rxbufsize);
-typedef void (*di_txblock_t) (struct hnddma_pub *dmah);
-typedef void (*di_txunblock_t) (struct hnddma_pub *dmah);
-typedef uint(*di_txactive_t) (struct hnddma_pub *dmah);
-typedef void (*di_txrotate_t) (struct hnddma_pub *dmah);
-typedef void (*di_counterreset_t) (struct hnddma_pub *dmah);
-typedef uint(*di_ctrlflags_t) (struct hnddma_pub *dmah, uint mask, uint flags);
-typedef char *(*di_dump_t) (struct hnddma_pub *dmah, struct bcmstrbuf *b,
+typedef void (*di_txblock_t) (struct dma_pub *dmah);
+typedef void (*di_txunblock_t) (struct dma_pub *dmah);
+typedef uint(*di_txactive_t) (struct dma_pub *dmah);
+typedef void (*di_txrotate_t) (struct dma_pub *dmah);
+typedef void (*di_counterreset_t) (struct dma_pub *dmah);
+typedef uint(*di_ctrlflags_t) (struct dma_pub *dmah, uint mask, uint flags);
+typedef char *(*di_dump_t) (struct dma_pub *dmah, struct bcmstrbuf *b,
 			    bool dumpring);
-typedef char *(*di_dumptx_t) (struct hnddma_pub *dmah, struct bcmstrbuf *b,
+typedef char *(*di_dumptx_t) (struct dma_pub *dmah, struct bcmstrbuf *b,
 			      bool dumpring);
-typedef char *(*di_dumprx_t) (struct hnddma_pub *dmah, struct bcmstrbuf *b,
+typedef char *(*di_dumprx_t) (struct dma_pub *dmah, struct bcmstrbuf *b,
 			      bool dumpring);
-typedef uint(*di_rxactive_t) (struct hnddma_pub *dmah);
-typedef uint(*di_txpending_t) (struct hnddma_pub *dmah);
-typedef uint(*di_txcommitted_t) (struct hnddma_pub *dmah);
+typedef uint(*di_rxactive_t) (struct dma_pub *dmah);
+typedef uint(*di_txpending_t) (struct dma_pub *dmah);
+typedef uint(*di_txcommitted_t) (struct dma_pub *dmah);
 
 /* dma opsvec */
 typedef struct di_fcn_s {
@@ -136,7 +136,7 @@ typedef struct di_fcn_s {
  * Exported data structure (read-only)
  */
 /* export structure */
-struct hnddma_pub {
+struct dma_pub {
 	const di_fcn_t *di_fn;	/* DMA function pointers */
 	uint txavail;		/* # free tx descriptors */
 	uint dmactrlflags;	/* dma control flags */
@@ -148,7 +148,7 @@ struct hnddma_pub {
 	uint txnobuf;		/* tx out of dma descriptors */
 };
 
-extern struct hnddma_pub *dma_attach(char *name, si_t *sih,
+extern struct dma_pub *dma_attach(char *name, si_t *sih,
 			    void *dmaregstx, void *dmaregsrx, uint ntxd,
 			    uint nrxd, uint rxbufsize, int rxextheadroom,
 			    uint nrxpost, uint rxoffset, uint *msg_level);
@@ -202,7 +202,7 @@ extern const di_fcn_t dma64proc;
  * This info is needed by DMA_ALLOC_CONSISTENT in dma attach
  */
 extern uint dma_addrwidth(si_t *sih, void *dmaregs);
-void dma_walk_packets(struct hnddma_pub *dmah, void (*callback_fnc)
+void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a);
 
 /*
@@ -223,4 +223,4 @@ static inline void dma_spin_for_len(uint len, struct sk_buff *head)
 #endif				/* defined(__mips__) */
 }
 
-#endif				/* _hnddma_h_ */
+#endif				/* _bcmdma_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index f025641..d01f60a 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -819,7 +819,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 	return rc;
 }
 
-static otp_fn_t hndotp_fn = {
+static otp_fn_t otp_fn = {
 	(otp_size_t) hndotp_size,
 	(otp_read_bit_t) hndotp_read_bit,
 
@@ -883,7 +883,7 @@ void *otp_init(si_t *sih)
 
 #ifdef BCMHNDOTP
 	if (OTPTYPE_HND(oi->ccrev))
-		oi->fn = &hndotp_fn;
+		oi->fn = &otp_fn;
 #endif
 
 	if (oi->fn == NULL) {
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 6fde51f..2557255 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -31,10 +31,6 @@
 #include <asm/addrspace.h>
 #endif
 
-#ifdef BRCM_FULLMAC
-#error "hnddma.c shouldn't be needed for FULLMAC"
-#endif
-
 /* debug/trace */
 #ifdef BCMDBG
 #define	DMA_ERROR(args) \
@@ -75,7 +71,7 @@ static uint dma_msg_level;
 
 /* dma engine software state */
 typedef struct dma_info {
-	struct hnddma_pub hnddma; /* exported structure */
+	struct dma_pub dma; /* exported structure */
 	uint *msg_level;	/* message level pointer */
 	char name[MAXNAMEL];	/* callers name for diag msgs */
 
@@ -99,7 +95,7 @@ typedef struct dma_info {
 	u16 txin;		/* index of next descriptor to reclaim */
 	u16 txout;		/* index of next descriptor to post */
 	void **txp;		/* pointer to parallel array of pointers to packets */
-	hnddma_seg_map_t *txp_dmah;	/* DMA MAP meta-data handle */
+	dma_seg_map_t *txp_dmah;	/* DMA MAP meta-data handle */
 	dmaaddr_t txdpa;	/* Aligned physical address of descriptor ring */
 	dmaaddr_t txdpaorig;	/* Original physical address of descriptor ring */
 	u16 txdalign;	/* #bytes added to alloc'd mem to align txd */
@@ -113,7 +109,7 @@ typedef struct dma_info {
 	u16 rxin;		/* index of next descriptor to reclaim */
 	u16 rxout;		/* index of next descriptor to post */
 	void **rxp;		/* pointer to parallel array of pointers to packets */
-	hnddma_seg_map_t *rxp_dmah;	/* DMA MAP meta-data handle */
+	dma_seg_map_t *rxp_dmah;	/* DMA MAP meta-data handle */
 	dmaaddr_t rxdpa;	/* Aligned physical address of descriptor ring */
 	dmaaddr_t rxdpaorig;	/* Original physical address of descriptor ring */
 	u16 rxdalign;	/* #bytes added to alloc'd mem to align rxd */
@@ -274,7 +270,7 @@ const di_fcn_t dma64proc = {
 	39
 };
 
-struct hnddma_pub *dma_attach(char *name, si_t *sih,
+struct dma_pub *dma_attach(char *name, si_t *sih,
 		     void *dmaregstx, void *dmaregsrx, uint ntxd,
 		     uint nrxd, uint rxbufsize, int rxextheadroom,
 		     uint nrxpost, uint rxoffset, uint *msg_level)
@@ -299,20 +295,20 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 	/* init dma reg pointer */
 	di->d64txregs = (dma64regs_t *) dmaregstx;
 	di->d64rxregs = (dma64regs_t *) dmaregsrx;
-	di->hnddma.di_fn = (const di_fcn_t *)&dma64proc;
+	di->dma.di_fn = (const di_fcn_t *)&dma64proc;
 
 	/* Default flags (which can be changed by the driver calling dma_ctrlflags
 	 * before enable): For backwards compatibility both Rx Overflow Continue
 	 * and Parity are DISABLED.
 	 * supports it.
 	 */
-	di->hnddma.di_fn->ctrlflags(&di->hnddma, DMA_CTRL_ROC | DMA_CTRL_PEN,
-				    0);
+	di->dma.di_fn->ctrlflags(&di->dma, DMA_CTRL_ROC | DMA_CTRL_PEN,
+				 0);
 
 	DMA_TRACE(("%s: dma_attach: %s flags 0x%x ntxd %d nrxd %d "
 		   "rxbufsize %d rxextheadroom %d nrxpost %d rxoffset %d "
 		   "dmaregstx %p dmaregsrx %p\n", name, "DMA64",
-		   di->hnddma.dmactrlflags, ntxd, nrxd, rxbufsize,
+		   di->dma.dmactrlflags, ntxd, nrxd, rxbufsize,
 		   rxextheadroom, nrxpost, rxoffset, dmaregstx, dmaregsrx));
 
 	/* make a private copy of our callers name */
@@ -427,21 +423,21 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 	/* allocate DMA mapping vectors */
 	if (DMASGLIST_ENAB) {
 		if (ntxd) {
-			size = ntxd * sizeof(hnddma_seg_map_t);
+			size = ntxd * sizeof(dma_seg_map_t);
 			di->txp_dmah = kzalloc(size, GFP_ATOMIC);
 			if (di->txp_dmah == NULL)
 				goto fail;
 		}
 
 		if (nrxd) {
-			size = nrxd * sizeof(hnddma_seg_map_t);
+			size = nrxd * sizeof(dma_seg_map_t);
 			di->rxp_dmah = kzalloc(size, GFP_ATOMIC);
 			if (di->rxp_dmah == NULL)
 				goto fail;
 		}
 	}
 
-	return (struct hnddma_pub *) di;
+	return (struct dma_pub *) di;
 
  fail:
 	_dma_detach(di);
@@ -497,7 +493,7 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 		W_SM(&ddring[outidx].ctrl1, BUS_SWAP32(*flags));
 		W_SM(&ddring[outidx].ctrl2, BUS_SWAP32(ctrl2));
 	}
-	if (di->hnddma.dmactrlflags & DMA_CTRL_PEN) {
+	if (di->dma.dmactrlflags & DMA_CTRL_PEN) {
 		if (DMA64_DD_PARITY(&ddring[outidx])) {
 			W_SM(&ddring[outidx].ctrl2,
 			     BUS_SWAP32(ctrl2 | D64_CTRL2_PARITY));
@@ -678,7 +674,7 @@ static void _dma_rxinit(dma_info_t *di)
 
 static void _dma_rxenable(dma_info_t *di)
 {
-	uint dmactrlflags = di->hnddma.dmactrlflags;
+	uint dmactrlflags = di->dma.dmactrlflags;
 	u32 control;
 
 	DMA_TRACE(("%s: dma_rxenable\n", di->name));
@@ -760,11 +756,11 @@ static void *_dma_rx(dma_info_t *di)
 		}
 #endif				/* BCMDBG */
 
-		if ((di->hnddma.dmactrlflags & DMA_CTRL_RXMULTI) == 0) {
+		if ((di->dma.dmactrlflags & DMA_CTRL_RXMULTI) == 0) {
 			DMA_ERROR(("%s: dma_rx: bad frame length (%d)\n",
 				   di->name, len));
 			bcm_pkt_buf_free_skb(head);
-			di->hnddma.rxgiants++;
+			di->dma.rxgiants++;
 			goto next_frame;
 		}
 	}
@@ -821,7 +817,7 @@ static bool _dma_rxfill(dma_info_t *di)
 					   di->name));
 				ring_empty = true;
 			}
-			di->hnddma.rxnobuf++;
+			di->dma.rxnobuf++;
 			break;
 		}
 		/* reserve an extra headroom, if applicable */
@@ -835,7 +831,7 @@ static bool _dma_rxfill(dma_info_t *di)
 
 		if (DMASGLIST_ENAB)
 			memset(&di->rxp_dmah[rxout], 0,
-				sizeof(hnddma_seg_map_t));
+				sizeof(dma_seg_map_t));
 
 		pa = pci_map_single(di->pbus, p->data,
 			di->rxbufsize, PCI_DMA_FROMDEVICE);
@@ -922,12 +918,12 @@ static void *_dma_getnextrxp(dma_info_t *di, bool forceall)
 
 static void _dma_txblock(dma_info_t *di)
 {
-	di->hnddma.txavail = 0;
+	di->dma.txavail = 0;
 }
 
 static void _dma_txunblock(dma_info_t *di)
 {
-	di->hnddma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
+	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
 }
 
 static uint _dma_txactive(dma_info_t *di)
@@ -968,14 +964,14 @@ static uint _dma_rxactive(dma_info_t *di)
 static void _dma_counterreset(dma_info_t *di)
 {
 	/* reset all software counter */
-	di->hnddma.rxgiants = 0;
-	di->hnddma.rxnobuf = 0;
-	di->hnddma.txnobuf = 0;
+	di->dma.rxgiants = 0;
+	di->dma.rxnobuf = 0;
+	di->dma.txnobuf = 0;
 }
 
 static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags)
 {
-	uint dmactrlflags = di->hnddma.dmactrlflags;
+	uint dmactrlflags = di->dma.dmactrlflags;
 
 	if (di == NULL) {
 		DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
@@ -1004,7 +1000,7 @@ static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags)
 		}
 	}
 
-	di->hnddma.dmactrlflags = dmactrlflags;
+	di->dma.dmactrlflags = dmactrlflags;
 
 	return dmactrlflags;
 }
@@ -1013,7 +1009,7 @@ static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags)
 static unsigned long _dma_getvar(dma_info_t *di, const char *name)
 {
 	if (!strcmp(name, "&txavail"))
-		return (unsigned long)&(di->hnddma.txavail);
+		return (unsigned long)&(di->dma.txavail);
 	return 0;
 }
 
@@ -1069,7 +1065,7 @@ static void dma64_txinit(dma_info_t *di)
 		return;
 
 	di->txin = di->txout = 0;
-	di->hnddma.txavail = di->ntxd - 1;
+	di->dma.txavail = di->ntxd - 1;
 
 	/* clear tx descriptor ring */
 	memset((void *)di->txd64, '\0', (di->ntxd * sizeof(dma64dd_t)));
@@ -1080,7 +1076,7 @@ static void dma64_txinit(dma_info_t *di)
 	if (!di->aligndesc_4k)
 		_dma_ddtable_init(di, DMA_TX, di->txdpa);
 
-	if ((di->hnddma.dmactrlflags & DMA_CTRL_PEN) == 0)
+	if ((di->dma.dmactrlflags & DMA_CTRL_PEN) == 0)
 		control |= D64_XC_PD;
 	OR_REG(&di->d64txregs->control, control);
 
@@ -1142,7 +1138,7 @@ static void dma64_txreclaim(dma_info_t *di, txd_range_t range)
 
 	while ((p = dma64_getnexttxp(di, range))) {
 		/* For unframed data, we don't have any packets to free */
-		if (!(di->hnddma.dmactrlflags & DMA_CTRL_UNFRAMED))
+		if (!(di->dma.dmactrlflags & DMA_CTRL_UNFRAMED))
 			bcm_pkt_buf_free_skb(p);
 	}
 }
@@ -1316,7 +1312,7 @@ static void *dma64_getpos(dma_info_t *di, bool direction)
 /* TX of unframed data
  *
  * Adds a DMA ring descriptor for the data pointed to by "buf".
- * This is for DMA of a buffer of data and is unlike other hnddma TX functions
+ * This is for DMA of a buffer of data and is unlike other dma TX functions
  * that take a pointer to a "packet"
  * Each call to this is results in a single descriptor being added for "len" bytes of
  * data starting at "buf", it doesn't handle chained buffers.
@@ -1359,14 +1355,14 @@ static int dma64_txunframed(dma_info_t *di, void *buf, uint len, bool commit)
 	}
 
 	/* tx flow control */
-	di->hnddma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
+	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
 
 	return 0;
 
  outoftxd:
 	DMA_ERROR(("%s: %s: out of txds !!!\n", di->name, __func__));
-	di->hnddma.txavail = 0;
-	di->hnddma.txnobuf++;
+	di->dma.txavail = 0;
+	di->dma.txnobuf++;
 	return -1;
 }
 
@@ -1394,7 +1390,7 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 	 */
 	for (p = p0; p; p = next) {
 		uint nsegs, j;
-		hnddma_seg_map_t *map;
+		dma_seg_map_t *map;
 
 		data = p->data;
 		len = p->len;
@@ -1410,7 +1406,7 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 		/* get physical address of buffer start */
 		if (DMASGLIST_ENAB)
 			memset(&di->txp_dmah[txout], 0,
-				sizeof(hnddma_seg_map_t));
+				sizeof(dma_seg_map_t));
 
 		pa = pci_map_single(di->pbus, data, len, PCI_DMA_TODEVICE);
 
@@ -1474,15 +1470,15 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 		      di->xmtptrbase + I2B(txout, dma64dd_t));
 
 	/* tx flow control */
-	di->hnddma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
+	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
 
 	return 0;
 
  outoftxd:
 	DMA_ERROR(("%s: dma_txfast: out of txds !!!\n", di->name));
 	bcm_pkt_buf_free_skb(p0);
-	di->hnddma.txavail = 0;
-	di->hnddma.txnobuf++;
+	di->dma.txavail = 0;
+	di->dma.txnobuf++;
 	return -1;
 }
 
@@ -1542,7 +1538,7 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 
 	for (i = start; i != end && !txp; i = NEXTTXD(i)) {
 		dmaaddr_t pa;
-		hnddma_seg_map_t *map = NULL;
+		dma_seg_map_t *map = NULL;
 		uint size, j, nsegs;
 
 		PHYSADDRLOSET(pa,
@@ -1579,7 +1575,7 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 	di->txin = i;
 
 	/* tx flow control */
-	di->hnddma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
+	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
 
 	return txp;
 
@@ -1696,8 +1692,8 @@ static void dma64_txrotate(dma_info_t *di)
 		/* Move the map */
 		if (DMASGLIST_ENAB) {
 			memcpy(&di->txp_dmah[new], &di->txp_dmah[old],
-			       sizeof(hnddma_seg_map_t));
-			memset(&di->txp_dmah[old], 0, sizeof(hnddma_seg_map_t));
+			       sizeof(dma_seg_map_t));
+			memset(&di->txp_dmah[old], 0, sizeof(dma_seg_map_t));
 		}
 
 		di->txp[old] = NULL;
@@ -1706,7 +1702,7 @@ static void dma64_txrotate(dma_info_t *di)
 	/* update txin and txout */
 	di->txin = ad;
 	di->txout = TXD(di->txout + rot);
-	di->hnddma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
+	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
 
 	/* kick the chip */
 	W_REG(&di->d64txregs->ptr,
@@ -1736,7 +1732,7 @@ uint dma_addrwidth(si_t *sih, void *dmaregs)
  * engine. This function calls a caller-supplied function for each packet in
  * the caller specified dma chain.
  */
-void dma_walk_packets(struct hnddma_pub *dmah, void (*callback_fnc)
+void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a)
 {
 	dma_info_t *di = (dma_info_t *) dmah;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 492fb3e..e2e5653 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -2064,7 +2064,7 @@ void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
 
 static bool wlc_dma_rxreset(struct wlc_hw_info *wlc_hw, uint fifo)
 {
-	struct hnddma_pub *di = wlc_hw->di[fifo];
+	struct dma_pub *di = wlc_hw->di[fifo];
 	return dma_rxreset(di);
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index c63920c..026d200 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -5837,7 +5837,7 @@ void wlc_inval_dma_pkts(struct wlc_hw_info *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn))
 {
-	struct hnddma_pub *dmah;
+	struct dma_pub *dmah;
 	int i;
 	for (i = 0; i < NFIFO; i++) {
 		dmah = hw->di[i];
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 3bbb774..d4ae29b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -384,7 +384,7 @@ struct wlc_hw_info {
 	struct wlc_info *wlc;
 
 	/* fifo */
-	struct hnddma_pub *di[NFIFO];	/* hnddma handles, per fifo */
+	struct dma_pub *di[NFIFO];	/* dma handles, per fifo */
 
 	uint unit;		/* device instance number */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index df6e04c..b8cede1 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -18,7 +18,6 @@
 #define _wlc_types_h_
 
 /* forward declarations */
-
 struct wlc_info;
 struct wlc_hw_info;
 struct wlc_if;
@@ -26,12 +25,7 @@ struct wl_if;
 struct ampdu_info;
 struct antsel_info;
 struct bmac_pmq;
-
 struct d11init;
-
-#ifndef _hnddma_pub_
-#define _hnddma_pub_
-struct hnddma_pub;
-#endif				/* _hnddma_pub_ */
+struct dma_pub;
 
 #endif				/* _wlc_types_h_ */
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 6500547..7613845 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -89,7 +89,7 @@ typedef unsigned long dmaaddr_t;
 typedef struct {
 	dmaaddr_t addr;
 	u32 length;
-} hnddma_seg_t;
+} dma_seg_t;
 
 #define MAX_DMA_SEGS 4
 
@@ -97,13 +97,13 @@ typedef struct {
 	void *oshdmah;		/* Opaque handle for OSL to store its information */
 	uint origsize;		/* Size of the virtual packet */
 	uint nsegs;
-	hnddma_seg_t segs[MAX_DMA_SEGS];
-} hnddma_seg_map_t;
+	dma_seg_t segs[MAX_DMA_SEGS];
+} dma_seg_map_t;
 
 /* packet headroom necessary to accommodate the largest header in the system, (i.e TXOFF).
  * By doing, we avoid the need  to allocate an extra buffer for the header when bridging to WL.
  * There is a compile time check in wlc.c which ensure that this value is at least as big
- * as TXOFF. This value is used in dma_rxfill (hnddma.c).
+ * as TXOFF. This value is used in dma_rxfill (dma.c).
  */
 
 #define BCMEXTRAHDROOM 172
diff --git a/drivers/staging/brcm80211/include/bcmsdpcm.h b/drivers/staging/brcm80211/include/bcmsdpcm.h
index 5175e67..21d6a3a 100644
--- a/drivers/staging/brcm80211/include/bcmsdpcm.h
+++ b/drivers/staging/brcm80211/include/bcmsdpcm.h
@@ -198,7 +198,7 @@ typedef struct {
 	u32 assert_exp_addr;
 	u32 assert_file_addr;
 	u32 assert_line;
-	u32 console_addr;	/* Address of hndrte_cons_t */
+	u32 console_addr;	/* Address of rte_cons_t */
 	u32 msgtrace_addr;
 	u8 tag[32];
 } sdpcm_shared_t;
diff --git a/drivers/staging/brcm80211/include/sbdma.h b/drivers/staging/brcm80211/include/sbdma.h
index 08cb7f6..1da979a 100644
--- a/drivers/staging/brcm80211/include/sbdma.h
+++ b/drivers/staging/brcm80211/include/sbdma.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_sbhnddma_h_
-#define	_sbhnddma_h_
+#ifndef	_sbdma_h_
+#define	_sbdma_h_
 
 /* DMA structure:
  *  support two DMA engines: 32 bits address or 64 bit addressing
@@ -312,4 +312,4 @@ typedef volatile struct {
 	u16 flags;
 } dma_rxh_t;
 
-#endif				/* _sbhnddma_h_ */
+#endif				/* _sbdma_h_ */
-- 
1.7.4.1


