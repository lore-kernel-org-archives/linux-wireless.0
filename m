Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4925 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 64/83] staging: brcm80211: removed Broadcom specific
 acronym 'hnd'.
Date: Wed, 1 Jun 2011 13:45:49 +0200
Message-ID: <1306928768-7501-64-git-send-email-rvossen@broadcom.com> (sfid-20110601_134727_317535_8664E95A)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/pcicfg.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h  |    4 +---
 drivers/staging/brcm80211/brcmsmac/bcmdma.h   |    6 +++---
 drivers/staging/brcm80211/brcmsmac/d11.h      |    2 --
 drivers/staging/brcm80211/brcmsmac/dma.c      |   18 +++++++++---------
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h |    2 +-
 drivers/staging/brcm80211/include/bcmsoc.h    |    8 ++++----
 8 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/pcicfg.h b/drivers/staging/brcm80211/brcmfmac/pcicfg.h
index d0c617a..3258449 100644
--- a/drivers/staging/brcm80211/brcmfmac/pcicfg.h
+++ b/drivers/staging/brcm80211/brcmfmac/pcicfg.h
@@ -22,7 +22,7 @@
 /* PCI configuration address space size */
 #define PCI_SZPCR		256
 
-/* Everything below is BRCM HND proprietary */
+/* Everything below is Broadcom specific */
 
 /* Brcm PCI configuration registers */
 #define PCI_BAR0_WIN		0x80	/* backplane address space accessed by BAR0 */
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index ec7acd1..211a27a 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -151,9 +151,7 @@
 					 * maps all unused address ranges
 					 */
 
-/* There are TWO constants on all HND chips: SI_ENUM_BASE above,
- * and chipcommon being the first core:
- */
+/* chipcommon being the first core: */
 #define	SI_CC_IDX		0
 
 /* SOC Interconnect types (aka chip types) */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmdma.h b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
index 1a1ca03..dd55e29 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmdma.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
@@ -58,9 +58,9 @@ typedef volatile struct {
 
 /* range param for dma_getnexttxp() and dma_txreclaim */
 typedef enum txd_range {
-	HNDDMA_RANGE_ALL = 1,
-	HNDDMA_RANGE_TRANSMITTED,
-	HNDDMA_RANGE_TRANSFERED
+	DMA_RANGE_ALL = 1,
+	DMA_RANGE_TRANSMITTED,
+	DMA_RANGE_TRANSFERED
 } txd_range_t;
 
 /* dma function type */
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 12a0ead..e9fa4ca 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -105,8 +105,6 @@ typedef volatile struct {
 
 /*
  * Host Interface Registers
- * - primed from hnd_cores/dot11mac/systemC/registers/ihr.h
- * - but definitely not complete
  */
 typedef volatile struct _d11regs {
 	/* Device Control ("semi-standard host registers") */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index d50395d..a754cdd 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -1292,9 +1292,9 @@ static void dma64_txreclaim(dma_info_t *di, txd_range_t range)
 	void *p;
 
 	DMA_TRACE(("%s: dma_txreclaim %s\n", di->name,
-		   (range == HNDDMA_RANGE_ALL) ? "all" :
+		   (range == DMA_RANGE_ALL) ? "all" :
 		   ((range ==
-		     HNDDMA_RANGE_TRANSMITTED) ? "transmitted" :
+		     DMA_RANGE_TRANSMITTED) ? "transmitted" :
 		    "transferred")));
 
 	if (di->txin == di->txout)
@@ -1649,11 +1649,11 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 /*
  * Reclaim next completed txd (txds if using chained buffers) in the range
  * specified and return associated packet.
- * If range is HNDDMA_RANGE_TRANSMITTED, reclaim descriptors that have be
+ * If range is DMA_RANGE_TRANSMITTED, reclaim descriptors that have be
  * transmitted as noted by the hardware "CurrDescr" pointer.
- * If range is HNDDMA_RANGE_TRANSFERED, reclaim descriptors that have be
+ * If range is DMA_RANGE_TRANSFERED, reclaim descriptors that have be
  * transferred by the DMA as noted by the hardware "ActiveDescr" pointer.
- * If range is HNDDMA_RANGE_ALL, reclaim all txd(s) posted to the ring and
+ * If range is DMA_RANGE_ALL, reclaim all txd(s) posted to the ring and
  * return associated packet regardless of the value of hardware pointers.
  */
 static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
@@ -1663,9 +1663,9 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 	void *txp;
 
 	DMA_TRACE(("%s: dma_getnexttxp %s\n", di->name,
-		   (range == HNDDMA_RANGE_ALL) ? "all" :
+		   (range == DMA_RANGE_ALL) ? "all" :
 		   ((range ==
-		     HNDDMA_RANGE_TRANSMITTED) ? "transmitted" :
+		     DMA_RANGE_TRANSMITTED) ? "transmitted" :
 		    "transferred")));
 
 	if (di->ntxd == 0)
@@ -1674,7 +1674,7 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 	txp = NULL;
 
 	start = di->txin;
-	if (range == HNDDMA_RANGE_ALL)
+	if (range == DMA_RANGE_ALL)
 		end = di->txout;
 	else {
 		dma64regs_t *dregs = di->d64txregs;
@@ -1685,7 +1685,7 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 				 D64_XS0_CD_MASK) -
 				di->xmtptrbase) & D64_XS0_CD_MASK, dma64dd_t));
 
-		if (range == HNDDMA_RANGE_TRANSFERED) {
+		if (range == DMA_RANGE_TRANSFERED) {
 			active_desc =
 			    (u16) (R_REG(&dregs->status1) &
 				      D64_XS1_AD_MASK);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 6b02ebe..caee8d9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -3415,7 +3415,7 @@ static void wlc_flushqueues(struct wlc_info *wlc)
 	/* free any posted tx packets */
 	for (i = 0; i < NFIFO; i++)
 		if (wlc_hw->di[i]) {
-			dma_txreclaim(wlc_hw->di[i], HNDDMA_RANGE_ALL);
+			dma_txreclaim(wlc_hw->di[i], DMA_RANGE_ALL);
 			TXPKTPENDCLR(wlc, i);
 			BCMMSG(wlc->wiphy, "pktpend fifo %d clrd\n", i);
 		}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 916b2a0..1dfa04b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -736,7 +736,7 @@ struct antsel_info {
 #define TXPKTPENDCLR(wlc, fifo)		((wlc)->core->txpktpend[(fifo)] = 0)
 #define TXAVAIL(wlc, fifo)		(*(wlc)->core->txavail[(fifo)])
 #define GETNEXTTXP(wlc, _queue)								\
-		dma_getnexttxp((wlc)->hw->di[(_queue)], HNDDMA_RANGE_TRANSMITTED)
+		dma_getnexttxp((wlc)->hw->di[(_queue)], DMA_RANGE_TRANSMITTED)
 
 #define WLC_IS_MATCH_SSID(wlc, ssid1, ssid2, len1, len2) \
 	((len1 == len2) && !memcmp(ssid1, ssid2, len1))
diff --git a/drivers/staging/brcm80211/include/bcmsoc.h b/drivers/staging/brcm80211/include/bcmsoc.h
index 012e465..4df0c64 100644
--- a/drivers/staging/brcm80211/include/bcmsoc.h
+++ b/drivers/staging/brcm80211/include/bcmsoc.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef	_HNDSOC_H
-#define	_HNDSOC_H
+#ifndef	_BCMSOC_H
+#define	_BCMSOC_H
 
 /* Include the soci specific files */
 #include <aidmp.h>
@@ -130,7 +130,7 @@
 					 * unused address ranges
 					 */
 
-/* There are TWO constants on all HND chips: SI_ENUM_BASE above,
+/* There are TWO constants on all Broadcom chips: SI_ENUM_BASE above,
  * and chipcommon being the first core:
  */
 #define	SI_CC_IDX		0
@@ -195,4 +195,4 @@
 #define	BISZ_BSSEND_IDX		6	/*      6: bss end */
 #define BISZ_SIZE		7	/* descriptor size in 32-bit integers */
 
-#endif				/* _HNDSOC_H */
+#endif				/* _BCMSOC_H */
-- 
1.7.4.1


