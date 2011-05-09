Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3429 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab1EIOd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 9/9] staging: brcm80211: move utility functions into new
 module
Date: Mon, 9 May 2011 16:33:10 +0200
Message-ID: <1304951590-2411-10-git-send-email-arend@broadcom.com> (sfid-20110509_163742_539971_EED38AFB)
In-Reply-To: <1304951590-2411-1-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Move utility functions shared by the brcmsmac and brcmfmac drivers into a new
module, brcmutil.ko.  This eliminates the need to compile and link the shared
functions into both drivers.  Prefix all exported symbols with "bcm_".

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Makefile                |    1 +
 drivers/staging/brcm80211/brcmfmac/Makefile       |    4 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   12 +-
 drivers/staging/brcm80211/brcmfmac/bcmutils.c     |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmwifi.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   16 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  124 +++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_iw.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/Makefile       |    2 -
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/hnddma.c       |   10 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c    |   14 +-
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c     |   43 ++++----
 drivers/staging/brcm80211/include/bcmutils.h      |   53 +++++-----
 drivers/staging/brcm80211/include/bcmwifi.h       |    6 +-
 drivers/staging/brcm80211/util/Makefile           |   29 +++++
 drivers/staging/brcm80211/util/bcmutils.c         |   81 ++++++++++----
 drivers/staging/brcm80211/util/bcmwifi.c          |   10 +-
 20 files changed, 245 insertions(+), 172 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmutils.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmwifi.c
 create mode 100644 drivers/staging/brcm80211/util/Makefile

diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
index c064cdf..287ad0e 100644
--- a/drivers/staging/brcm80211/Makefile
+++ b/drivers/staging/brcm80211/Makefile
@@ -19,5 +19,6 @@
 subdir-ccflags-y					:= -DBCMDMA32
 subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DBCMDBG -DBCMDBG_ASSERT
 
+obj-m			+= util/
 obj-$(CONFIG_BRCMFMAC)	+= brcmfmac/
 obj-$(CONFIG_BRCMSMAC)	+= brcmsmac/
diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 2732d7f..8c9c0dc 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -50,9 +50,7 @@ DHDOFILES = \
 	bcmsdh.o \
 	bcmsdh_linux.o	\
 	bcmsdh_sdmmc.o \
-	bcmsdh_sdmmc_linux.o \
-	bcmutils.o \
-	bcmwifi.o
+	bcmsdh_sdmmc_linux.o
 
 obj-m += brcmfmac.o
 brcmfmac-objs += $(DHDOFILES)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 25fbd9c..43aebfd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -1042,9 +1042,9 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 	if (pkt == NULL) {
 		sd_data(("%s: Creating new %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", buflen_u));
-		mypkt = pkt_buf_get_skb(buflen_u);
+		mypkt = bcm_pkt_buf_get_skb(buflen_u);
 		if (!mypkt) {
-			sd_err(("%s: pkt_buf_get_skb failed: len %d\n",
+			sd_err(("%s: bcm_pkt_buf_get_skb failed: len %d\n",
 				__func__, buflen_u));
 			return SDIOH_API_RC_FAIL;
 		}
@@ -1060,7 +1060,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (!write)
 			memcpy(buffer, mypkt->data, buflen_u);
 
-		pkt_buf_free_skb(mypkt);
+		bcm_pkt_buf_free_skb(mypkt);
 	} else if (((u32) (pkt->data) & DMA_ALIGN_MASK) != 0) {
 		/* Case 2: We have a packet, but it is unaligned. */
 
@@ -1069,9 +1069,9 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 
 		sd_data(("%s: Creating aligned %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", pkt->len));
-		mypkt = pkt_buf_get_skb(pkt->len);
+		mypkt = bcm_pkt_buf_get_skb(pkt->len);
 		if (!mypkt) {
-			sd_err(("%s: pkt_buf_get_skb failed: len %d\n",
+			sd_err(("%s: bcm_pkt_buf_get_skb failed: len %d\n",
 				__func__, pkt->len));
 			return SDIOH_API_RC_FAIL;
 		}
@@ -1087,7 +1087,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (!write)
 			memcpy(pkt->data, mypkt->data, mypkt->len);
 
-		pkt_buf_free_skb(mypkt);
+		bcm_pkt_buf_free_skb(mypkt);
 	} else {		/* case 3: We have a packet and
 				 it is aligned. */
 		sd_data(("%s: Aligned %s Packet, direct DMA\n",
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmutils.c b/drivers/staging/brcm80211/brcmfmac/bcmutils.c
deleted file mode 100644
index 8e1296a..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmutils.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../util/bcmutils.c"
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmwifi.c b/drivers/staging/brcm80211/brcmfmac/bcmwifi.c
deleted file mode 100644
index 9fe988c..0000000
--- a/drivers/staging/brcm80211/brcmfmac/bcmwifi.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../util/bcmwifi.c"
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 5e7eebf..69f8957 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -316,7 +316,7 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 	 * exceeding total queue length
 	 */
 	if (!pktq_pfull(q, prec) && !pktq_full(q)) {
-		pktq_penq(q, prec, pkt);
+		bcm_pktq_penq(q, prec, pkt);
 		return true;
 	}
 
@@ -324,7 +324,7 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 	if (pktq_pfull(q, prec))
 		eprec = prec;
 	else if (pktq_full(q)) {
-		p = pktq_peek_tail(q, &eprec);
+		p = bcm_pktq_peek_tail(q, &eprec);
 		ASSERT(p);
 		if (eprec > prec)
 			return false;
@@ -338,21 +338,21 @@ bool dhd_prec_enq(dhd_pub_t *dhdp, struct pktq *q, struct sk_buff *pkt,
 		if (eprec == prec && !discard_oldest)
 			return false;	/* refuse newer (incoming) packet */
 		/* Evict packet according to discard policy */
-		p = discard_oldest ? pktq_pdeq(q, eprec) : pktq_pdeq_tail(q,
-						  eprec);
+		p = discard_oldest ? bcm_pktq_pdeq(q, eprec) :
+			bcm_pktq_pdeq_tail(q, eprec);
 		if (p == NULL) {
-			DHD_ERROR(("%s: pktq_penq() failed, oldest %d.",
+			DHD_ERROR(("%s: bcm_pktq_penq() failed, oldest %d.",
 				   __func__, discard_oldest));
 			ASSERT(p);
 		}
 
-		pkt_buf_free_skb(p);
+		bcm_pkt_buf_free_skb(p);
 	}
 
 	/* Enqueue */
-	p = pktq_penq(q, prec, pkt);
+	p = bcm_pktq_penq(q, prec, pkt);
 	if (p == NULL) {
-		DHD_ERROR(("%s: pktq_penq() failed.", __func__));
+		DHD_ERROR(("%s: bcm_pktq_penq() failed.", __func__));
 		ASSERT(p);
 	}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index c1d22c8..49e73b2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -481,7 +481,7 @@ static void dhdsdio_pktfree2(dhd_bus_t *bus, struct sk_buff *pkt)
 {
 	dhd_os_sdlock_rxq(bus->dhd);
 	if ((bus->bus != SPI_BUS) || bus->usebufpool)
-		pkt_buf_free_skb(pkt);
+		bcm_pkt_buf_free_skb(pkt);
 	dhd_os_sdunlock_rxq(bus->dhd);
 }
 
@@ -955,7 +955,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			DHD_INFO(("%s: insufficient headroom %d for %d pad\n",
 				  __func__, skb_headroom(pkt), pad));
 			bus->dhd->tx_realloc++;
-			new = pkt_buf_get_skb(pkt->len + DHD_SDALIGN);
+			new = bcm_pkt_buf_get_skb(pkt->len + DHD_SDALIGN);
 			if (!new) {
 				DHD_ERROR(("%s: couldn't allocate new %d-byte "
 					"packet\n",
@@ -967,7 +967,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			PKTALIGN(new, pkt->len, DHD_SDALIGN);
 			memcpy(new->data, pkt->data, pkt->len);
 			if (free_pkt)
-				pkt_buf_free_skb(pkt);
+				bcm_pkt_buf_free_skb(pkt);
 			/* free the pkt if canned one is not used */
 			free_pkt = true;
 			pkt = new;
@@ -1003,9 +1003,9 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	if (DHD_BYTES_ON() &&
 	    (((DHD_CTL_ON() && (chan == SDPCM_CONTROL_CHANNEL)) ||
 	      (DHD_DATA_ON() && (chan != SDPCM_CONTROL_CHANNEL))))) {
-		prhex("Tx Frame", frame, len);
+		bcm_prhex("Tx Frame", frame, len);
 	} else if (DHD_HDRS_ON()) {
-		prhex("TxHdr", frame, min_t(u16, len, 16));
+		bcm_prhex("TxHdr", frame, min_t(u16, len, 16));
 	}
 #endif
 
@@ -1081,7 +1081,7 @@ done:
 	dhd_os_sdlock(bus->dhd);
 
 	if (free_pkt)
-		pkt_buf_free_skb(pkt);
+		bcm_pkt_buf_free_skb(pkt);
 
 	return ret;
 }
@@ -1130,7 +1130,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		if (dhd_prec_enq(bus->dhd, &bus->txq, pkt, prec) == false) {
 			skb_pull(pkt, SDPCM_HDRLEN);
 			dhd_txcomplete(bus->dhd, pkt, false);
-			pkt_buf_free_skb(pkt);
+			bcm_pkt_buf_free_skb(pkt);
 			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
 			ret = -ENOSR;
 		} else {
@@ -1203,7 +1203,7 @@ static uint dhdsdio_sendfromq(dhd_bus_t *bus, uint maxframes)
 	/* Send frames until the limit or some other event */
 	for (cnt = 0; (cnt < maxframes) && DATAOK(bus); cnt++) {
 		dhd_os_sdlock_txq(bus->dhd);
-		pkt = pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
+		pkt = bcm_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
 		if (pkt == NULL) {
 			dhd_os_sdunlock_txq(bus->dhd);
 			break;
@@ -1334,9 +1334,9 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	if (ret == -1) {
 #ifdef DHD_DEBUG
 		if (DHD_BYTES_ON() && DHD_CTL_ON())
-			prhex("Tx Frame", frame, len);
+			bcm_prhex("Tx Frame", frame, len);
 		else if (DHD_HDRS_ON())
-			prhex("TxHdr", frame, min_t(u16, len, 16));
+			bcm_prhex("TxHdr", frame, min_t(u16, len, 16));
 #endif
 
 		do {
@@ -2835,14 +2835,14 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	dhdsdio_clkctl(bus, CLK_SDONLY, false);
 
 	/* Clear the data packet queues */
-	pktq_flush(&bus->txq, true, NULL, 0);
+	bcm_pktq_flush(&bus->txq, true, NULL, 0);
 
 	/* Clear any held glomming stuff */
 	if (bus->glomd)
-		pkt_buf_free_skb(bus->glomd);
+		bcm_pkt_buf_free_skb(bus->glomd);
 
 	if (bus->glom)
-		pkt_buf_free_skb(bus->glom);
+		bcm_pkt_buf_free_skb(bus->glom);
 
 	bus->glom = bus->glomd = NULL;
 
@@ -3118,7 +3118,7 @@ gotpkt:
 
 #ifdef DHD_DEBUG
 	if (DHD_BYTES_ON() && DHD_CTL_ON())
-		prhex("RxCtrl", bus->rxctl, len);
+		bcm_prhex("RxCtrl", bus->rxctl, len);
 #endif
 
 	/* Point to valid data and indicate its length */
@@ -3192,10 +3192,11 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			}
 
 			/* Allocate/chain packet for next subframe */
-			pnext = pkt_buf_get_skb(sublen + DHD_SDALIGN);
+			pnext = bcm_pkt_buf_get_skb(sublen + DHD_SDALIGN);
 			if (pnext == NULL) {
-				DHD_ERROR(("%s: pkt_buf_get_skb failed, num %d len %d\n",
-					   __func__, num, sublen));
+				DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed, "
+					"num %d len %d\n", __func__,
+					num, sublen));
 				break;
 			}
 			ASSERT(!(pnext->prev));
@@ -3228,13 +3229,13 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			pfirst = pnext = NULL;
 		} else {
 			if (pfirst)
-				pkt_buf_free_skb(pfirst);
+				bcm_pkt_buf_free_skb(pfirst);
 			bus->glom = NULL;
 			num = 0;
 		}
 
 		/* Done with descriptor packet */
-		pkt_buf_free_skb(bus->glomd);
+		bcm_pkt_buf_free_skb(bus->glomd);
 		bus->glomd = NULL;
 		bus->nextlen = 0;
 
@@ -3255,7 +3256,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		}
 
 		pfirst = bus->glom;
-		dlen = (u16) pkttotlen(pfirst);
+		dlen = (u16) bcm_pkttotlen(pfirst);
 
 		/* Do an SDIO read for the superframe.  Configurable iovar to
 		 * read directly into the chained packet, or allocate a large
@@ -3271,7 +3272,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 					bcmsdh_cur_sbwad(bus->sdh), SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL, NULL, NULL);
-			sublen = (u16) pktfrombuf(pfirst, 0, dlen,
+			sublen = (u16) bcm_pktfrombuf(pfirst, 0, dlen,
 						bus->dataptr);
 			if (sublen != dlen) {
 				DHD_ERROR(("%s: FAILED TO COPY, dlen %d sublen %d\n",
@@ -3299,7 +3300,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				bus->glomerr = 0;
 				dhdsdio_rxfail(bus, true, false);
 				dhd_os_sdlock_rxq(bus->dhd);
-				pkt_buf_free_skb(bus->glom);
+				bcm_pkt_buf_free_skb(bus->glom);
 				dhd_os_sdunlock_rxq(bus->dhd);
 				bus->rxglomfail++;
 				bus->glom = NULL;
@@ -3308,7 +3309,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		}
 #ifdef DHD_DEBUG
 		if (DHD_GLOM_ON()) {
-			prhex("SUPERFRAME", pfirst->data,
+			bcm_prhex("SUPERFRAME", pfirst->data,
 			      min_t(int, pfirst->len, 48));
 		}
 #endif
@@ -3391,7 +3392,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 #ifdef DHD_DEBUG
 			if (DHD_GLOM_ON())
-				prhex("subframe", dptr, 32);
+				bcm_prhex("subframe", dptr, 32);
 #endif
 
 			if ((u16)~(sublen ^ check)) {
@@ -3428,7 +3429,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				bus->glomerr = 0;
 				dhdsdio_rxfail(bus, true, false);
 				dhd_os_sdlock_rxq(bus->dhd);
-				pkt_buf_free_skb(bus->glom);
+				bcm_pkt_buf_free_skb(bus->glom);
 				dhd_os_sdunlock_rxq(bus->dhd);
 				bus->rxglomfail++;
 				bus->glom = NULL;
@@ -3469,14 +3470,14 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			}
 #ifdef DHD_DEBUG
 			if (DHD_BYTES_ON() && DHD_DATA_ON())
-				prhex("Rx Subframe Data", dptr, dlen);
+				bcm_prhex("Rx Subframe Data", dptr, dlen);
 #endif
 
 			__skb_trim(pfirst, sublen);
 			skb_pull(pfirst, doff);
 
 			if (pfirst->len == 0) {
-				pkt_buf_free_skb(pfirst);
+				bcm_pkt_buf_free_skb(pfirst);
 				if (plast) {
 					plast->next = pnext;
 				} else {
@@ -3489,7 +3490,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				DHD_ERROR(("%s: rx protocol error\n",
 					   __func__));
 				bus->dhd->rx_errors++;
-				pkt_buf_free_skb(pfirst);
+				bcm_pkt_buf_free_skb(pfirst);
 				if (plast) {
 					plast->next = pnext;
 				} else {
@@ -3512,7 +3513,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 				__func__, num, pfirst, pfirst->data,
 				pfirst->len, pfirst->next,
 				pfirst->prev));
-				prhex("", (u8 *) pfirst->data,
+				bcm_prhex("", (u8 *) pfirst->data,
 				      min_t(int, pfirst->len, 32));
 			}
 #endif				/* DHD_DEBUG */
@@ -3626,7 +3627,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			 */
 			/* Allocate a packet buffer */
 			dhd_os_sdlock_rxq(bus->dhd);
-			pkt = pkt_buf_get_skb(rdlen + DHD_SDALIGN);
+			pkt = bcm_pkt_buf_get_skb(rdlen + DHD_SDALIGN);
 			if (!pkt) {
 				if (bus->bus == SPI_BUS) {
 					bus->usebufpool = false;
@@ -3669,7 +3670,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				} else {
 					/* Give up on data,
 					request rtx of events */
-					DHD_ERROR(("%s (nextlen): pkt_buf_get_skb failed: len %d rdlen %d " "expected rxseq %d\n",
+					DHD_ERROR(("%s (nextlen): bcm_pkt_buf_get_skb failed: len %d rdlen %d " "expected rxseq %d\n",
 						__func__, len, rdlen, rxseq));
 					/* Just go try again w/normal
 					header read */
@@ -3695,7 +3696,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				if (sdret < 0) {
 					DHD_ERROR(("%s (nextlen): read %d bytes failed: %d\n",
 						__func__, rdlen, sdret));
-					pkt_buf_free_skb(pkt);
+					bcm_pkt_buf_free_skb(pkt);
 					bus->dhd->rx_errors++;
 					dhd_os_sdunlock_rxq(bus->dhd);
 					/* Force retry w/normal header read.
@@ -3816,9 +3817,9 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 #ifdef DHD_DEBUG
 			if (DHD_BYTES_ON() && DHD_DATA_ON())
-				prhex("Rx Data", rxbuf, len);
+				bcm_prhex("Rx Data", rxbuf, len);
 			else if (DHD_HDRS_ON())
-				prhex("RxHdr", bus->rxhdr, SDPCM_HDRLEN);
+				bcm_prhex("RxHdr", bus->rxhdr, SDPCM_HDRLEN);
 #endif
 
 			if (chan == SDPCM_CONTROL_CHANNEL) {
@@ -3874,7 +3875,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		}
 #ifdef DHD_DEBUG
 		if (DHD_BYTES_ON() || DHD_HDRS_ON())
-			prhex("RxHdr", bus->rxhdr, SDPCM_HDRLEN);
+			bcm_prhex("RxHdr", bus->rxhdr, SDPCM_HDRLEN);
 #endif
 
 		/* Extract hardware header fields */
@@ -4000,11 +4001,11 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		}
 
 		dhd_os_sdlock_rxq(bus->dhd);
-		pkt = pkt_buf_get_skb(rdlen + firstread + DHD_SDALIGN);
+		pkt = bcm_pkt_buf_get_skb(rdlen + firstread + DHD_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			DHD_ERROR(("%s: pkt_buf_get_skb failed: rdlen %d chan %d\n",
-				   __func__, rdlen, chan));
+			DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed: rdlen %d "
+				"chan %d\n", __func__, rdlen, chan));
 			bus->dhd->rx_dropped++;
 			dhd_os_sdunlock_rxq(bus->dhd);
 			dhdsdio_rxfail(bus, false, RETRYCHAN(chan));
@@ -4035,7 +4036,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				       ? "data" : "test")),
 				   sdret));
 			dhd_os_sdlock_rxq(bus->dhd);
-			pkt_buf_free_skb(pkt);
+			bcm_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
 			bus->dhd->rx_errors++;
 			dhdsdio_rxfail(bus, true, RETRYCHAN(chan));
@@ -4048,7 +4049,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 #ifdef DHD_DEBUG
 		if (DHD_BYTES_ON() && DHD_DATA_ON())
-			prhex("Rx Data", pkt->data, len);
+			bcm_prhex("Rx Data", pkt->data, len);
 #endif
 
 deliver:
@@ -4059,7 +4060,7 @@ deliver:
 					__func__, len));
 #ifdef DHD_DEBUG
 				if (DHD_GLOM_ON()) {
-					prhex("Glom Data", pkt->data, len);
+					bcm_prhex("Glom Data", pkt->data, len);
 				}
 #endif
 				__skb_trim(pkt, len);
@@ -4088,13 +4089,13 @@ deliver:
 
 		if (pkt->len == 0) {
 			dhd_os_sdlock_rxq(bus->dhd);
-			pkt_buf_free_skb(pkt);
+			bcm_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
 			continue;
 		} else if (dhd_prot_hdrpull(bus->dhd, &ifidx, pkt) != 0) {
 			DHD_ERROR(("%s: rx protocol error\n", __func__));
 			dhd_os_sdlock_rxq(bus->dhd);
-			pkt_buf_free_skb(pkt);
+			bcm_pkt_buf_free_skb(pkt);
 			dhd_os_sdunlock_rxq(bus->dhd);
 			bus->dhd->rx_errors++;
 			continue;
@@ -4415,7 +4416,7 @@ clkwait:
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
 	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
-		 pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
+		 bcm_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
 		 && DATAOK(bus)) {
 		framecnt = rxdone ? txlimit : min(txlimit, dhd_txminmax);
 		framecnt = dhdsdio_sendfromq(bus, framecnt);
@@ -4436,7 +4437,7 @@ clkwait:
 			"I_CHIPACTIVE interrupt\n", __func__));
 		resched = true;
 	} else if (bus->intstatus || bus->ipend ||
-		(!bus->fcstate && pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
+		(!bus->fcstate && bcm_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
 			DATAOK(bus)) || PKT_AVAILABLE()) {
 		resched = true;
 	}
@@ -4570,11 +4571,12 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 
 		/* Allocate an appropriate-sized packet */
 		len = bus->pktgen_len;
-		pkt = pkt_buf_get_skb(
+		pkt = bcm_pkt_buf_get_skb(
 			(len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + DHD_SDALIGN),
 			true);
 		if (!pkt) {
-			DHD_ERROR(("%s: pkt_buf_get_skb failed!\n", __func__));
+			DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed!\n",
+				__func__));
 			break;
 		}
 		PKTALIGN(pkt, (len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN),
@@ -4601,7 +4603,7 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 		default:
 			DHD_ERROR(("Unrecognized pktgen mode %d\n",
 				   bus->pktgen_mode));
-			pkt_buf_free_skb(pkt, true);
+			bcm_pkt_buf_free_skb(pkt, true);
 			bus->pktgen_count = 0;
 			return;
 		}
@@ -4619,7 +4621,7 @@ static void dhdsdio_pktgen(dhd_bus_t *bus)
 #ifdef DHD_DEBUG
 		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
 			data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
-			prhex("dhdsdio_pktgen: Tx Data", data,
+			bcm_prhex("dhdsdio_pktgen: Tx Data", data,
 			      pkt->len - SDPCM_HDRLEN);
 		}
 #endif
@@ -4649,10 +4651,10 @@ static void dhdsdio_sdtest_set(dhd_bus_t *bus, bool start)
 	u8 *data;
 
 	/* Allocate the packet */
-	pkt = pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + DHD_SDALIGN,
-			true);
+	pkt = bcm_pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN +
+		DHD_SDALIGN, true);
 	if (!pkt) {
-		DHD_ERROR(("%s: pkt_buf_get_skb failed!\n", __func__));
+		DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed!\n", __func__));
 		return;
 	}
 	PKTALIGN(pkt, (SDPCM_HDRLEN + SDPCM_TEST_HDRLEN), DHD_SDALIGN);
@@ -4684,7 +4686,7 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	if (pktlen < SDPCM_TEST_HDRLEN) {
 		DHD_ERROR(("dhdsdio_restrcv: toss runt frame, pktlen %d\n",
 			   pktlen));
-		pkt_buf_free_skb(pkt, false);
+		bcm_pkt_buf_free_skb(pkt, false);
 		return;
 	}
 
@@ -4702,7 +4704,7 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 			DHD_ERROR(("dhdsdio_testrcv: frame length mismatch, "
 				"pktlen %d seq %d" " cmd %d extra %d len %d\n",
 				pktlen, seq, cmd, extra, len));
-			pkt_buf_free_skb(pkt, false);
+			bcm_pkt_buf_free_skb(pkt, false);
 			return;
 		}
 	}
@@ -4717,14 +4719,14 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 			bus->pktgen_sent++;
 		} else {
 			bus->pktgen_fail++;
-			pkt_buf_free_skb(pkt, false);
+			bcm_pkt_buf_free_skb(pkt, false);
 		}
 		bus->pktgen_rcvd++;
 		break;
 
 	case SDPCM_TEST_ECHORSP:
 		if (bus->ext_loop) {
-			pkt_buf_free_skb(pkt, false);
+			bcm_pkt_buf_free_skb(pkt, false);
 			bus->pktgen_rcvd++;
 			break;
 		}
@@ -4737,12 +4739,12 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 				break;
 			}
 		}
-		pkt_buf_free_skb(pkt, false);
+		bcm_pkt_buf_free_skb(pkt, false);
 		bus->pktgen_rcvd++;
 		break;
 
 	case SDPCM_TEST_DISCARD:
-		pkt_buf_free_skb(pkt, false);
+		bcm_pkt_buf_free_skb(pkt, false);
 		bus->pktgen_rcvd++;
 		break;
 
@@ -4752,7 +4754,7 @@ static void dhdsdio_testrcv(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 		DHD_INFO(("dhdsdio_testrcv: unsupported or unknown command, "
 			"pktlen %d seq %d" " cmd %d extra %d len %d\n",
 			pktlen, seq, cmd, extra, len));
-		pkt_buf_free_skb(pkt, false);
+		bcm_pkt_buf_free_skb(pkt, false);
 		break;
 	}
 
@@ -4913,7 +4915,7 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 	/* Bump dongle by sending an empty event pkt.
 	 * sdpcm_sendup (RX) checks for virtual console input.
 	 */
-	pkt = pkt_buf_get_skb(4 + SDPCM_RESERVE);
+	pkt = bcm_pkt_buf_get_skb(4 + SDPCM_RESERVE);
 	if ((pkt != NULL) && bus->clkstate == CLK_AVAIL)
 		dhdsdio_txpkt(bus, pkt, SDPCM_EVENT_CHANNEL, true);
 
@@ -5244,7 +5246,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 	/* Set core control so an SDIO reset does a backplane reset */
 	OR_REG(&bus->regs->corecontrol, CC_BPRESEN);
 
-	pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
+	bcm_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
 	/* Locate an appropriately-aligned portion of hdrbuf */
 	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0], DHD_SDALIGN);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index a16b46c..a085800 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -375,7 +375,7 @@ wl_iw_set_freq(struct net_device *dev,
 		if (fwrq->m > 4000 && fwrq->m < 5000)
 			sf = WF_CHAN_FACTOR_4_G;
 
-		chan = wf_mhz2channel(fwrq->m, sf);
+		chan = bcm_mhz2channel(fwrq->m, sf);
 	}
 	chan = cpu_to_le32(chan);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index ccf1ced..84ae245 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -51,8 +51,6 @@ BRCMSMAC_OFILES := \
 	bcmsrom.o \
 	hnddma.o \
 	nicpci.o \
-	../util/bcmutils.o \
-	../util/bcmwifi.o \
 	nvram.o
 
 MODULEPFX := brcmsmac
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index 8df4455..bbfc642 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -256,7 +256,7 @@ sprom_read_pci(si_t *sih, u16 *sprom, uint wordoff,
 
 		/* fixup the endianness so crc8 will pass */
 		htol16_buf(buf, nwords * 2);
-		if (hndcrc8((u8 *) buf, nwords * 2, CRC8_INIT_VALUE) !=
+		if (bcm_crc8((u8 *) buf, nwords * 2, CRC8_INIT_VALUE) !=
 		    CRC8_GOOD_VALUE) {
 			/* DBG only pci always read srom4 first, then srom8/9 */
 			err = 1;
@@ -296,7 +296,7 @@ static int otp_read_pci(si_t *sih, u16 *buf, uint bufsz)
 
 	/* fixup the endianness so crc8 will pass */
 	htol16_buf(buf, bufsz);
-	if (hndcrc8((u8 *) buf, SROM4_WORDS * 2, CRC8_INIT_VALUE) !=
+	if (bcm_crc8((u8 *) buf, SROM4_WORDS * 2, CRC8_INIT_VALUE) !=
 	    CRC8_GOOD_VALUE) {
 		err = 1;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/hnddma.c b/drivers/staging/brcm80211/brcmsmac/hnddma.c
index 0737fb2..8a42147 100644
--- a/drivers/staging/brcm80211/brcmsmac/hnddma.c
+++ b/drivers/staging/brcm80211/brcmsmac/hnddma.c
@@ -772,7 +772,7 @@ static void *BCMFASTPATH _dma_rx(dma_info_t *di)
 		if ((di->hnddma.dmactrlflags & DMA_CTRL_RXMULTI) == 0) {
 			DMA_ERROR(("%s: dma_rx: bad frame length (%d)\n",
 				   di->name, len));
-			pkt_buf_free_skb(head);
+			bcm_pkt_buf_free_skb(head);
 			di->hnddma.rxgiants++;
 			goto next_frame;
 		}
@@ -820,7 +820,7 @@ static bool BCMFASTPATH _dma_rxfill(dma_info_t *di)
 		   size to be allocated
 		 */
 
-		p = pkt_buf_get_skb(di->rxbufsize + extra_offset);
+		p = bcm_pkt_buf_get_skb(di->rxbufsize + extra_offset);
 
 		if (p == NULL) {
 			DMA_ERROR(("%s: dma_rxfill: out of rxbufs\n",
@@ -918,7 +918,7 @@ static void _dma_rxreclaim(dma_info_t *di)
 	DMA_TRACE(("%s: dma_rxreclaim\n", di->name));
 
 	while ((p = _dma_getnextrxp(di, true)))
-		pkt_buf_free_skb(p);
+		bcm_pkt_buf_free_skb(p);
 }
 
 static void *BCMFASTPATH _dma_getnextrxp(dma_info_t *di, bool forceall)
@@ -1152,7 +1152,7 @@ static void BCMFASTPATH dma64_txreclaim(dma_info_t *di, txd_range_t range)
 	while ((p = dma64_getnexttxp(di, range))) {
 		/* For unframed data, we don't have any packets to free */
 		if (!(di->hnddma.dmactrlflags & DMA_CTRL_UNFRAMED))
-			pkt_buf_free_skb(p);
+			bcm_pkt_buf_free_skb(p);
 	}
 }
 
@@ -1489,7 +1489,7 @@ static int BCMFASTPATH dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 
  outoftxd:
 	DMA_ERROR(("%s: dma_txfast: out of txds !!!\n", di->name));
-	pkt_buf_free_skb(p0);
+	bcm_pkt_buf_free_skb(p0);
 	di->hnddma.txavail = 0;
 	di->hnddma.txnobuf++;
 	return -1;
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 2dd7c7b..419ed80 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -593,7 +593,7 @@ wl_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	wl->pub->global_ampdu = &(scb->scb_ampdu);
 	wl->pub->global_ampdu->scb = scb;
 	wl->pub->global_ampdu->max_pdu = 16;
-	pktq_init(&scb->scb_ampdu.txq, AMPDU_MAX_SCB_TID,
+	bcm_pktq_init(&scb->scb_ampdu.txq, AMPDU_MAX_SCB_TID,
 		  AMPDU_MAX_SCB_TID * PKTQ_LEN_DEFAULT);
 
 	sta->ht_cap.ht_supported = true;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 876e523..e9f62dd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -622,7 +622,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		len = roundup(len, 4);
 		ampdu_len += (len + (ndelim + 1) * AMPDU_DELIMITER_LEN);
 
-		dma_len += (u16) pkttotlen(p);
+		dma_len += (u16) bcm_pkttotlen(p);
 
 		BCMMSG(wlc->wiphy, "wl%d: ampdu_len %d"
 			" seg_cnt %d null delim %d\n",
@@ -718,7 +718,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			    ((u8) (p->priority) == tid)) {
 
 				plen =
-				    pkttotlen(p) + AMPDU_MAX_MPDU_OVERHEAD;
+				    bcm_pkttotlen(p) + AMPDU_MAX_MPDU_OVERHEAD;
 				plen = max(scb_ampdu->min_len, plen);
 
 				if ((plen + ampdu_len) > maxlen) {
@@ -735,7 +735,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 					p = NULL;
 					continue;
 				}
-				p = pktq_pdeq(&qi->q, prec);
+				p = bcm_pktq_pdeq(&qi->q, prec);
 			} else {
 				p = NULL;
 			}
@@ -899,7 +899,7 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			tx_info = IEEE80211_SKB_CB(p);
 			txh = (d11txh_t *) p->data;
 			mcl = le16_to_cpu(txh->MacTxControlLow);
-			pkt_buf_free_skb(p);
+			bcm_pkt_buf_free_skb(p);
 			/* break out if last packet of ampdu */
 			if (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
 			    TXC_AMPDU_LAST)
@@ -1034,7 +1034,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				  txs->phyerr);
 
 			if (WL_ERROR_ON()) {
-				prpkt("txpkt (AMPDU)", p);
+				bcm_prpkt("txpkt (AMPDU)", p);
 				wlc_print_txdesc((d11txh_t *) p->data);
 			}
 			wlc_print_txstatus(txs);
@@ -1148,7 +1148,7 @@ ampdu_cleanup_tid_ini(struct ampdu_info *ampdu, scb_ampdu_t *scb_ampdu, u8 tid,
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, ini->scb);
 
 	/* free all buffered tx packets */
-	pktq_pflush(&scb_ampdu->txq, ini->tid, true, NULL, 0);
+	bcm_pktq_pflush(&scb_ampdu->txq, ini->tid, true, NULL, 0);
 }
 
 /* initialize the initiator code for tid */
@@ -1337,7 +1337,7 @@ void wlc_ampdu_flush(struct wlc_info *wlc,
 	ampdu_pars.sta = sta;
 	ampdu_pars.tid = tid;
 	for (prec = 0; prec < pq->num_prec; prec++) {
-		pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
+		bcm_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
 			    (int)&ampdu_pars);
 	}
 	wlc_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index fe3e392..d6b1dcd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -1494,7 +1494,7 @@ wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
 	u8 channel = CHSPEC_CHANNEL(chspec);
 
 	/* check the chanspec */
-	if (wf_chspec_malformed(chspec)) {
+	if (bcm_chspec_malformed(chspec)) {
 		wiphy_err(wlc->wiphy, "wl%d: malformed chanspec 0x%x\n",
 			wlc->pub->unit, chspec);
 		return false;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 3eaabe9..0e244d9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -709,8 +709,8 @@ static u8 wlc_local_constraint_qdbm(struct wlc_info *wlc)
 
 	local = WLC_TXPWR_MAX;
 	if (wlc->pub->associated &&
-	    (wf_chspec_ctlchan(wlc->chanspec) ==
-	     wf_chspec_ctlchan(wlc->home_chanspec))) {
+	    (bcm_chspec_ctlchan(wlc->chanspec) ==
+	     bcm_chspec_ctlchan(wlc->home_chanspec))) {
 
 		/* get the local power constraint if we are on the AP's
 		 * channel [802.11h, 7.3.2.13]
@@ -2521,7 +2521,7 @@ uint wlc_down(struct wlc_info *wlc)
 
 	/* flush tx queues */
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
-		pktq_flush(&qi->q, true, NULL, 0);
+		bcm_pktq_flush(&qi->q, true, NULL, 0);
 	}
 
 	callbacks += wlc_bmac_down_finish(wlc->hw);
@@ -4682,7 +4682,8 @@ void wlc_print_txdesc(d11txh_t *txh)
 	char hexbuf[256];
 
 	/* add plcp header along with txh descriptor */
-	prhex("Raw TxDesc + plcp header", (unsigned char *) txh, sizeof(d11txh_t) + 48);
+	bcm_prhex("Raw TxDesc + plcp header", (unsigned char *) txh,
+		sizeof(d11txh_t) + 48);
 
 	printk(KERN_DEBUG "TxCtlLow: %04x ", mtcl);
 	printk(KERN_DEBUG "TxCtlHigh: %04x ", mtch);
@@ -4753,7 +4754,7 @@ void wlc_print_rxh(d11rxhdr_t *rxh)
 		{0, NULL}
 	};
 
-	prhex("Raw RxDesc", (unsigned char *) rxh, sizeof(d11rxhdr_t));
+	bcm_prhex("Raw RxDesc", (unsigned char *) rxh, sizeof(d11rxhdr_t));
 
 	bcm_format_flags(macstat_flags, macstatus1, flagstr, 64);
 
@@ -4829,7 +4830,7 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 	if (pktq_pfull(q, prec))
 		eprec = prec;
 	else if (pktq_full(q)) {
-		p = pktq_peek_tail(q, &eprec);
+		p = bcm_pktq_peek_tail(q, &eprec);
 		if (eprec > prec) {
 			wiphy_err(wlc->wiphy, "%s: Failing: eprec %d > prec %d"
 				  "\n", __func__, eprec, prec);
@@ -4851,25 +4852,25 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		}
 
 		/* Evict packet according to discard policy */
-		p = discard_oldest ? pktq_pdeq(q, eprec) : pktq_pdeq_tail(q,
-									  eprec);
+		p = discard_oldest ? bcm_pktq_pdeq(q, eprec) :
+			bcm_pktq_pdeq_tail(q, eprec);
 		/* Increment wme stats */
 		if (WME_ENAB(wlc->pub)) {
 			WLCNTINCR(wlc->pub->_wme_cnt->
 				  tx_failed[WME_PRIO2AC(p->priority)].packets);
 			WLCNTADD(wlc->pub->_wme_cnt->
 				 tx_failed[WME_PRIO2AC(p->priority)].bytes,
-				 pkttotlen(p));
+				 bcm_pkttotlen(p));
 		}
-		pkt_buf_free_skb(p);
+		bcm_pkt_buf_free_skb(p);
 		wlc->pub->_cnt->txnobuf++;
 	}
 
 	/* Enqueue */
 	if (head)
-		p = pktq_penq_head(q, prec, pkt);
+		p = bcm_pktq_penq_head(q, prec, pkt);
 	else
-		p = pktq_penq(q, prec, pkt);
+		p = bcm_pktq_penq(q, prec, pkt);
 
 	return true;
 }
@@ -4894,7 +4895,7 @@ void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 		 * XXX we might hit this condtion in case
 		 * packet flooding from mac80211 stack
 		 */
-		pkt_buf_free_skb(sdu);
+		bcm_pkt_buf_free_skb(sdu);
 		wlc->pub->_cnt->txnobuf++;
 	}
 
@@ -4961,7 +4962,7 @@ void BCMFASTPATH wlc_send_q(struct wlc_info *wlc)
 	/* Send all the enq'd pkts that we can.
 	 * Dequeue packets with precedence with empty HW fifo only
 	 */
-	while (prec_map && (pkt[0] = pktq_mdeq(q, prec_map, &prec))) {
+	while (prec_map && (pkt[0] = bcm_pktq_mdeq(q, prec_map, &prec))) {
 		tx_info = IEEE80211_SKB_CB(pkt[0]);
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			err = wlc_sendampdu(wlc->ampdu, qi, pkt, prec);
@@ -4976,7 +4977,7 @@ void BCMFASTPATH wlc_send_q(struct wlc_info *wlc)
 		}
 
 		if (err == -EBUSY) {
-			pktq_penq_head(q, prec, pkt[0]);
+			bcm_pktq_penq_head(q, prec, pkt[0]);
 			/* If send failed due to any other reason than a change in
 			 * HW FIFO condition, quit. Otherwise, read the new prec_map!
 			 */
@@ -5444,7 +5445,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	qos = ieee80211_is_data_qos(h->frame_control);
 
 	/* compute length of frame in bytes for use in PLCP computations */
-	len = pkttotlen(p);
+	len = bcm_pkttotlen(p);
 	phylen = len + FCS_LEN;
 
 	/* If WEP enabled, add room in phylen for the additional bytes of
@@ -6330,7 +6331,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	totlen = pkttotlen(p);
+	totlen = bcm_pkttotlen(p);
 	free_pdu = true;
 
 	wlc_txfifo_complete(wlc, queue, 1);
@@ -6353,7 +6354,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
  fatal:
 	if (p)
-		pkt_buf_free_skb(p);
+		bcm_pkt_buf_free_skb(p);
 
 	return true;
 
@@ -6758,7 +6759,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	return;
 
  toss:
-	pkt_buf_free_skb(p);
+	bcm_pkt_buf_free_skb(p);
 }
 
 /* calculate frame duration for Mixed-mode L-SIG spoofing, return
@@ -8049,7 +8050,7 @@ static struct wlc_txq_info *wlc_txq_alloc(struct wlc_info *wlc)
 		 * leave PS mode. The watermark for flowcontrol to OS packets
 		 * will remain the same
 		 */
-		pktq_init(&qi->q, WLC_PREC_COUNT,
+		bcm_pktq_init(&qi->q, WLC_PREC_COUNT,
 			  (2 * wlc->pub->tunables->datahiwat) + PKTQ_LEN_DEFAULT
 			  + wlc->pub->psq_pkts_total);
 
@@ -8133,7 +8134,7 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
 {
 	/* flush packet queue when requested */
 	if (drop)
-		pktq_flush(&wlc->pkt_queue->q, false, NULL, 0);
+		bcm_pktq_flush(&wlc->pkt_queue->q, false, NULL, 0);
 
 	/* wait for queue and DMA fifos to run dry */
 	while (!pktq_empty(&wlc->pkt_queue->q) ||
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 905e3ce..2a00741 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -87,25 +87,26 @@
 #define pktq_ppeek(pq, prec)            ((pq)->q[prec].head)
 #define pktq_ppeek_tail(pq, prec)       ((pq)->q[prec].tail)
 
-extern struct sk_buff *pktq_penq(struct pktq *pq, int prec,
+extern struct sk_buff *bcm_pktq_penq(struct pktq *pq, int prec,
 				 struct sk_buff *p);
-extern struct sk_buff *pktq_penq_head(struct pktq *pq, int prec,
+extern struct sk_buff *bcm_pktq_penq_head(struct pktq *pq, int prec,
 				      struct sk_buff *p);
-extern struct sk_buff *pktq_pdeq(struct pktq *pq, int prec);
-extern struct sk_buff *pktq_pdeq_tail(struct pktq *pq, int prec);
+extern struct sk_buff *bcm_pktq_pdeq(struct pktq *pq, int prec);
+extern struct sk_buff *bcm_pktq_pdeq_tail(struct pktq *pq, int prec);
 
 /* packet primitives */
-extern struct sk_buff *pkt_buf_get_skb(uint len);
-extern void pkt_buf_free_skb(struct sk_buff *skb);
+extern struct sk_buff *bcm_pkt_buf_get_skb(uint len);
+extern void bcm_pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
-extern void pktq_pflush(struct pktq *pq, int prec,
+extern void bcm_pktq_pflush(struct pktq *pq, int prec,
 	bool dir, ifpkt_cb_t fn, int arg);
 
 /* operations on a set of precedences in packet queue */
 
-extern int pktq_mlen(struct pktq *pq, uint prec_bmp);
-extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
+extern int bcm_pktq_mlen(struct pktq *pq, uint prec_bmp);
+extern struct sk_buff *bcm_pktq_mdeq(struct pktq *pq, uint prec_bmp,
+	int *prec_out);
 
 /* operations on packet queue as a whole */
 
@@ -116,35 +117,35 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 #define pktq_empty(pq)                  ((pq)->len == 0)
 
 /* operations for single precedence queues */
-#define pktenq(pq, p)		pktq_penq(((struct pktq *)pq), 0, (p))
-#define pktenq_head(pq, p)	pktq_penq_head(((struct pktq *)pq), 0, (p))
-#define pktdeq(pq)		pktq_pdeq(((struct pktq *)pq), 0)
-#define pktdeq_tail(pq)		pktq_pdeq_tail(((struct pktq *)pq), 0)
-#define pktqinit(pq, len) pktq_init(((struct pktq *)pq), 1, len)
+#define pktenq(pq, p)		bcm_pktq_penq(((struct pktq *)pq), 0, (p))
+#define pktenq_head(pq, p)	bcm_pktq_penq_head(((struct pktq *)pq), 0, (p))
+#define pktdeq(pq)		bcm_pktq_pdeq(((struct pktq *)pq), 0)
+#define pktdeq_tail(pq)		bcm_pktq_pdeq_tail(((struct pktq *)pq), 0)
+#define pktqinit(pq, len)	bcm_pktq_init(((struct pktq *)pq), 1, len)
 
-	extern void pktq_init(struct pktq *pq, int num_prec, int max_len);
+extern void bcm_pktq_init(struct pktq *pq, int num_prec, int max_len);
 /* prec_out may be NULL if caller is not interested in return value */
-	extern struct sk_buff *pktq_peek_tail(struct pktq *pq, int *prec_out);
-	extern void pktq_flush(struct pktq *pq, bool dir,
-		ifpkt_cb_t fn, int arg);
+extern struct sk_buff *bcm_pktq_peek_tail(struct pktq *pq, int *prec_out);
+extern void bcm_pktq_flush(struct pktq *pq, bool dir,
+	ifpkt_cb_t fn, int arg);
 
 /* externs */
 /* packet */
-	extern uint pktfrombuf(struct sk_buff *p,
-			       uint offset, int len, unsigned char *buf);
-	extern uint pkttotlen(struct sk_buff *p);
+extern uint bcm_pktfrombuf(struct sk_buff *p,
+	uint offset, int len, unsigned char *buf);
+extern uint bcm_pkttotlen(struct sk_buff *p);
 
 /* ethernet address */
-	extern int bcm_ether_atoe(char *p, u8 *ea);
+extern int bcm_ether_atoe(char *p, u8 *ea);
 
 /* ip address */
 	struct ipv4_addr;
 	extern char *bcm_ip_ntoa(struct ipv4_addr *ia, char *buf);
 
 #ifdef BCMDBG
-	extern void prpkt(const char *msg, struct sk_buff *p0);
+extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 #else
-#define prpkt(a, b)
+#define bcm_prpkt(a, b)
 #endif				/* BCMDBG */
 
 #define bcm_perf_enable()
@@ -467,7 +468,7 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 
 /* externs */
 /* crc */
-	extern u8 hndcrc8(u8 *p, uint nbytes, u8 crc);
+extern u8 bcm_crc8(u8 *p, uint nbytes, u8 crc);
 /* format/print */
 #if defined(BCMDBG)
 	extern int bcm_format_flags(const bcm_bit_desc_t *bd, u32 flags,
@@ -475,7 +476,7 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 	extern int bcm_format_hex(char *str, const void *bytes, int len);
 #endif
 	extern char *bcm_chipname(uint chipid, char *buf, uint len);
-	extern void prhex(const char *msg, unsigned char *buf, uint len);
+	extern void bcm_prhex(const char *msg, unsigned char *buf, uint len);
 
 	extern bcm_tlv_t *bcm_parse_tlvs(void *buf, int buflen,
 						    uint key);
diff --git a/drivers/staging/brcm80211/include/bcmwifi.h b/drivers/staging/brcm80211/include/bcmwifi.h
index 4a0f976..a573ebf 100644
--- a/drivers/staging/brcm80211/include/bcmwifi.h
+++ b/drivers/staging/brcm80211/include/bcmwifi.h
@@ -134,14 +134,14 @@ typedef u16 chanspec_t;
  * combination could be legal given any set of circumstances.
  * RETURNS: true is the chanspec is malformed, false if it looks good.
  */
-extern bool wf_chspec_malformed(chanspec_t chanspec);
+extern bool bcm_chspec_malformed(chanspec_t chanspec);
 
 /*
  * This function returns the channel number that control traffic is being sent on, for legacy
  * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
  * sideband depending on the chanspec selected
  */
-extern u8 wf_chspec_ctlchan(chanspec_t chspec);
+extern u8 bcm_chspec_ctlchan(chanspec_t chspec);
 
 /*
  * Return the channel number for a given frequency and base frequency.
@@ -162,6 +162,6 @@ extern u8 wf_chspec_ctlchan(chanspec_t chspec);
  *
  * Reference 802.11 REVma, section 17.3.8.3, and 802.11B section 18.4.6.2
  */
-extern int wf_mhz2channel(uint freq, uint start_factor);
+extern int bcm_mhz2channel(uint freq, uint start_factor);
 
 #endif				/* _bcmwifi_h_ */
diff --git a/drivers/staging/brcm80211/util/Makefile b/drivers/staging/brcm80211/util/Makefile
new file mode 100644
index 0000000..6a18d11
--- /dev/null
+++ b/drivers/staging/brcm80211/util/Makefile
@@ -0,0 +1,29 @@
+#
+# Makefile fragment for Broadcom 802.11n Networking Device Driver Utilities
+#
+# Copyright (c) 2011 Broadcom Corporation
+#
+# Permission to use, copy, modify, and/or distribute this software for any
+# purpose with or without fee is hereby granted, provided that the above
+# copyright notice and this permission notice appear in all copies.
+#
+# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+
+ccflags-y :=				\
+	-Idrivers/staging/brcm80211/util \
+	-Idrivers/staging/brcm80211/include
+
+BRCMUTIL_OFILES := \
+	bcmutils.o \
+	bcmwifi.o
+
+MODULEPFX := brcmutil
+
+obj-m	+= $(MODULEPFX).o
+$(MODULEPFX)-objs	= $(BRCMUTIL_OFILES)
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 0c21e43..607d331 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -28,7 +28,12 @@
 #include <bcmdevs.h>
 #include <proto/802.11.h>
 
-struct sk_buff *BCMFASTPATH pkt_buf_get_skb(uint len)
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver utilities.");
+MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
+MODULE_LICENSE("Dual BSD/GPL");
+
+struct sk_buff *BCMFASTPATH bcm_pkt_buf_get_skb(uint len)
 {
 	struct sk_buff *skb;
 
@@ -40,9 +45,10 @@ struct sk_buff *BCMFASTPATH pkt_buf_get_skb(uint len)
 
 	return skb;
 }
+EXPORT_SYMBOL(bcm_pkt_buf_get_skb);
 
 /* Free the driver packet. Free the tag if present */
-void BCMFASTPATH pkt_buf_free_skb(struct sk_buff *skb)
+void BCMFASTPATH bcm_pkt_buf_free_skb(struct sk_buff *skb)
 {
 	struct sk_buff *nskb;
 	int nest = 0;
@@ -67,9 +73,11 @@ void BCMFASTPATH pkt_buf_free_skb(struct sk_buff *skb)
 		skb = nskb;
 	}
 }
+EXPORT_SYMBOL(bcm_pkt_buf_free_skb);
+
 
 /* copy a buffer into a pkt buffer chain */
-uint pktfrombuf(struct sk_buff *p, uint offset, int len,
+uint bcm_pktfrombuf(struct sk_buff *p, uint offset, int len,
 		unsigned char *buf)
 {
 	uint n, ret = 0;
@@ -96,8 +104,10 @@ uint pktfrombuf(struct sk_buff *p, uint offset, int len,
 
 	return ret;
 }
+EXPORT_SYMBOL(bcm_pktfrombuf);
+
 /* return total length of buffer chain */
-uint BCMFASTPATH pkttotlen(struct sk_buff *p)
+uint BCMFASTPATH bcm_pkttotlen(struct sk_buff *p)
 {
 	uint total;
 
@@ -106,12 +116,13 @@ uint BCMFASTPATH pkttotlen(struct sk_buff *p)
 		total += p->len;
 	return total;
 }
+EXPORT_SYMBOL(bcm_pkttotlen);
 
 /*
  * osl multiple-precedence packet queue
  * hi_prec is always >= the number of the highest non-empty precedence
  */
-struct sk_buff *BCMFASTPATH pktq_penq(struct pktq *pq, int prec,
+struct sk_buff *BCMFASTPATH bcm_pktq_penq(struct pktq *pq, int prec,
 				      struct sk_buff *p)
 {
 	struct pktq_prec *q;
@@ -136,8 +147,9 @@ struct sk_buff *BCMFASTPATH pktq_penq(struct pktq *pq, int prec,
 
 	return p;
 }
+EXPORT_SYMBOL(bcm_pktq_penq);
 
-struct sk_buff *BCMFASTPATH pktq_penq_head(struct pktq *pq, int prec,
+struct sk_buff *BCMFASTPATH bcm_pktq_penq_head(struct pktq *pq, int prec,
 					   struct sk_buff *p)
 {
 	struct pktq_prec *q;
@@ -161,8 +173,9 @@ struct sk_buff *BCMFASTPATH pktq_penq_head(struct pktq *pq, int prec,
 
 	return p;
 }
+EXPORT_SYMBOL(bcm_pktq_penq_head);
 
-struct sk_buff *BCMFASTPATH pktq_pdeq(struct pktq *pq, int prec)
+struct sk_buff *BCMFASTPATH bcm_pktq_pdeq(struct pktq *pq, int prec)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p;
@@ -185,8 +198,9 @@ struct sk_buff *BCMFASTPATH pktq_pdeq(struct pktq *pq, int prec)
 
 	return p;
 }
+EXPORT_SYMBOL(bcm_pktq_pdeq);
 
-struct sk_buff *BCMFASTPATH pktq_pdeq_tail(struct pktq *pq, int prec)
+struct sk_buff *BCMFASTPATH bcm_pktq_pdeq_tail(struct pktq *pq, int prec)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p, *prev;
@@ -212,9 +226,10 @@ struct sk_buff *BCMFASTPATH pktq_pdeq_tail(struct pktq *pq, int prec)
 
 	return p;
 }
+EXPORT_SYMBOL(bcm_pktq_pdeq_tail);
 
 void
-pktq_pflush(struct pktq *pq, int prec, bool dir,
+bcm_pktq_pflush(struct pktq *pq, int prec, bool dir,
 	    ifpkt_cb_t fn, int arg)
 {
 	struct pktq_prec *q;
@@ -230,7 +245,7 @@ pktq_pflush(struct pktq *pq, int prec, bool dir,
 			else
 				prev->prev = p->prev;
 			p->prev = NULL;
-			pkt_buf_free_skb(p);
+			bcm_pkt_buf_free_skb(p);
 			q->len--;
 			pq->len--;
 			p = (head ? q->head : prev->prev);
@@ -244,16 +259,18 @@ pktq_pflush(struct pktq *pq, int prec, bool dir,
 		q->tail = NULL;
 	}
 }
+EXPORT_SYMBOL(bcm_pktq_pflush);
 
-void pktq_flush(struct pktq *pq, bool dir,
+void bcm_pktq_flush(struct pktq *pq, bool dir,
 		ifpkt_cb_t fn, int arg)
 {
 	int prec;
 	for (prec = 0; prec < pq->num_prec; prec++)
-		pktq_pflush(pq, prec, dir, fn, arg);
+		bcm_pktq_pflush(pq, prec, dir, fn, arg);
 }
+EXPORT_SYMBOL(bcm_pktq_flush);
 
-void pktq_init(struct pktq *pq, int num_prec, int max_len)
+void bcm_pktq_init(struct pktq *pq, int num_prec, int max_len)
 {
 	int prec;
 
@@ -268,8 +285,9 @@ void pktq_init(struct pktq *pq, int num_prec, int max_len)
 	for (prec = 0; prec < num_prec; prec++)
 		pq->q[prec].max = pq->max;
 }
+EXPORT_SYMBOL(bcm_pktq_init);
 
-struct sk_buff *pktq_peek_tail(struct pktq *pq, int *prec_out)
+struct sk_buff *bcm_pktq_peek_tail(struct pktq *pq, int *prec_out)
 {
 	int prec;
 
@@ -285,9 +303,10 @@ struct sk_buff *pktq_peek_tail(struct pktq *pq, int *prec_out)
 
 	return pq->q[prec].tail;
 }
+EXPORT_SYMBOL(bcm_pktq_peek_tail);
 
 /* Return sum of lengths of a specific set of precedences */
-int pktq_mlen(struct pktq *pq, uint prec_bmp)
+int bcm_pktq_mlen(struct pktq *pq, uint prec_bmp)
 {
 	int prec, len;
 
@@ -299,8 +318,10 @@ int pktq_mlen(struct pktq *pq, uint prec_bmp)
 
 	return len;
 }
+EXPORT_SYMBOL(bcm_pktq_mlen);
+
 /* Priority dequeue from a specific set of precedences */
-struct sk_buff *BCMFASTPATH pktq_mdeq(struct pktq *pq, uint prec_bmp,
+struct sk_buff *BCMFASTPATH bcm_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 				      int *prec_out)
 {
 	struct pktq_prec *q;
@@ -338,6 +359,7 @@ struct sk_buff *BCMFASTPATH pktq_mdeq(struct pktq *pq, uint prec_bmp,
 
 	return p;
 }
+EXPORT_SYMBOL(bcm_pktq_mdeq);
 
 /* parse a xx:xx:xx:xx:xx:xx format ethernet address */
 int bcm_ether_atoe(char *p, u8 *ea)
@@ -352,10 +374,11 @@ int bcm_ether_atoe(char *p, u8 *ea)
 
 	return i == 6;
 }
+EXPORT_SYMBOL(bcm_ether_atoe);
 
 #if defined(BCMDBG)
 /* pretty hex print a pkt buffer chain */
-void prpkt(const char *msg, struct sk_buff *p0)
+void bcm_prpkt(const char *msg, struct sk_buff *p0)
 {
 	struct sk_buff *p;
 
@@ -363,8 +386,9 @@ void prpkt(const char *msg, struct sk_buff *p0)
 		printk(KERN_DEBUG "%s:\n", msg);
 
 	for (p = p0; p; p = p->next)
-		prhex(NULL, p->data, p->len);
+		bcm_prhex(NULL, p->data, p->len);
 }
+EXPORT_SYMBOL(bcm_prpkt);
 #endif				/* defined(BCMDBG) */
 
 /* iovar table lookup */
@@ -388,6 +412,7 @@ const bcm_iovar_t *bcm_iovar_lookup(const bcm_iovar_t *table, const char *name)
 
 	return NULL;		/* var name not found */
 }
+EXPORT_SYMBOL(bcm_iovar_lookup);
 
 int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 {
@@ -432,6 +457,7 @@ int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 
 	return bcmerror;
 }
+EXPORT_SYMBOL(bcm_iovar_lencheck);
 
 /*******************************************************************************
  * crc8
@@ -490,7 +516,7 @@ static const u8 crc8_table[256] = {
 	0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F
 };
 
-u8 hndcrc8(u8 *pdata,	/* pointer to array of data to process */
+u8 bcm_crc8(u8 *pdata,	/* pointer to array of data to process */
 			 uint nbytes,	/* number of input data bytes to process */
 			 u8 crc	/* either CRC8_INIT_VALUE or previous return value */
     ) {
@@ -500,6 +526,7 @@ u8 hndcrc8(u8 *pdata,	/* pointer to array of data to process */
 
 	return crc;
 }
+EXPORT_SYMBOL(bcm_crc8);
 
 /*
  * Traverse a string of 1-byte tag/1-byte length/variable-length value
@@ -528,6 +555,7 @@ bcm_tlv_t *bcm_parse_tlvs(void *buf, int buflen, uint key)
 
 	return NULL;
 }
+EXPORT_SYMBOL(bcm_parse_tlvs);
 
 
 #if defined(BCMDBG)
@@ -583,6 +611,7 @@ bcm_format_flags(const bcm_bit_desc_t *bd, u32 flags, char *buf, int len)
 
 	return (int)(p - buf);
 }
+EXPORT_SYMBOL(bcm_format_flags);
 
 /* print bytes formatted as hex to a string. return the resulting string length */
 int bcm_format_hex(char *str, const void *bytes, int len)
@@ -597,10 +626,11 @@ int bcm_format_hex(char *str, const void *bytes, int len)
 	}
 	return (int)(p - str);
 }
+EXPORT_SYMBOL(bcm_format_hex);
 #endif				/* defined(BCMDBG) */
 
 /* pretty hex print a contiguous buffer */
-void prhex(const char *msg, unsigned char *buf, uint nbytes)
+void bcm_prhex(const char *msg, unsigned char *buf, uint nbytes)
 {
 	char line[128], *p;
 	int len = sizeof(line);
@@ -634,6 +664,7 @@ void prhex(const char *msg, unsigned char *buf, uint nbytes)
 	if (p != line)
 		printk(KERN_DEBUG "%s\n", line);
 }
+EXPORT_SYMBOL(bcm_prhex);
 
 char *bcm_chipname(uint chipid, char *buf, uint len)
 {
@@ -643,6 +674,7 @@ char *bcm_chipname(uint chipid, char *buf, uint len)
 	snprintf(buf, len, fmt, chipid);
 	return buf;
 }
+EXPORT_SYMBOL(bcm_chipname);
 
 uint bcm_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 {
@@ -661,6 +693,7 @@ uint bcm_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 
 	return len;
 }
+EXPORT_SYMBOL(bcm_mkiovar);
 
 /* Quarter dBm units to mW
  * Table starts at QDBM_OFFSET, so the first entry is mW for qdBm=153
@@ -715,6 +748,8 @@ u16 bcm_qdbm_to_mw(u8 qdbm)
 	 */
 	return (nqdBm_to_mW_map[idx] + factor / 2) / factor;
 }
+EXPORT_SYMBOL(bcm_qdbm_to_mw);
+
 u8 bcm_mw_to_qdbm(u16 mw)
 {
 	u8 qdbm;
@@ -745,6 +780,8 @@ u8 bcm_mw_to_qdbm(u16 mw)
 
 	return qdbm;
 }
+EXPORT_SYMBOL(bcm_mw_to_qdbm);
+
 uint bcm_bitcount(u8 *bitmap, uint length)
 {
 	uint bitcount = 0, i;
@@ -758,12 +795,15 @@ uint bcm_bitcount(u8 *bitmap, uint length)
 	}
 	return bitcount;
 }
+EXPORT_SYMBOL(bcm_bitcount);
+
 /* Initialization of bcmstrbuf structure */
 void bcm_binit(struct bcmstrbuf *b, char *buf, uint size)
 {
 	b->origsize = b->size = size;
 	b->origbuf = b->buf = buf;
 }
+EXPORT_SYMBOL(bcm_binit);
 
 /* Buffer sprintf wrapper to guard against buffer overflow */
 int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...)
@@ -789,3 +829,4 @@ int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...)
 
 	return r;
 }
+EXPORT_SYMBOL(bcm_bprintf);
diff --git a/drivers/staging/brcm80211/util/bcmwifi.c b/drivers/staging/brcm80211/util/bcmwifi.c
index b03cb4a..955a3ab 100644
--- a/drivers/staging/brcm80211/util/bcmwifi.c
+++ b/drivers/staging/brcm80211/util/bcmwifi.c
@@ -15,6 +15,7 @@
  */
 #include <linux/ctype.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
@@ -25,7 +26,7 @@
  * combination could be legal given any set of circumstances.
  * RETURNS: true is the chanspec is malformed, false if it looks good.
  */
-bool wf_chspec_malformed(chanspec_t chanspec)
+bool bcm_chspec_malformed(chanspec_t chanspec)
 {
 	/* must be 2G or 5G band */
 	if (!CHSPEC_IS5G(chanspec) && !CHSPEC_IS2G(chanspec))
@@ -45,13 +46,14 @@ bool wf_chspec_malformed(chanspec_t chanspec)
 
 	return false;
 }
+EXPORT_SYMBOL(bcm_chspec_malformed);
 
 /*
  * This function returns the channel number that control traffic is being sent on, for legacy
  * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
  * sideband depending on the chanspec selected
  */
-u8 wf_chspec_ctlchan(chanspec_t chspec)
+u8 bcm_chspec_ctlchan(chanspec_t chspec)
 {
 	u8 ctl_chan;
 
@@ -74,6 +76,7 @@ u8 wf_chspec_ctlchan(chanspec_t chspec)
 
 	return ctl_chan;
 }
+EXPORT_SYMBOL(bcm_chspec_ctlchan);
 
 /*
  * Return the channel number for a given frequency and base frequency.
@@ -94,7 +97,7 @@ u8 wf_chspec_ctlchan(chanspec_t chspec)
  *
  * Reference 802.11 REVma, section 17.3.8.3, and 802.11B section 18.4.6.2
  */
-int wf_mhz2channel(uint freq, uint start_factor)
+int bcm_mhz2channel(uint freq, uint start_factor)
 {
 	int ch = -1;
 	uint base;
@@ -130,4 +133,5 @@ int wf_mhz2channel(uint freq, uint start_factor)
 
 	return ch;
 }
+EXPORT_SYMBOL(bcm_mhz2channel);
 
-- 
1.7.4.1


