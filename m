Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1733 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/20] staging: brcm80211: reduce indentation level in
 dhd_sdio.c #1
Date: Sun, 2 Oct 2011 10:14:35 -0700
Message-ID: <1317575685-3156-11-git-send-email-frankyl@broadcom.com> (sfid-20111002_191533_836535_0E7EA7ED)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

By introducing two new functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  108 ++++++++++++------------
 1 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4992d4d..169c6b2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1335,11 +1335,10 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		if (pnext) {
 			brcmf_dbg(GLOM, "allocated %d-byte packet chain for %d subframes\n",
 				  totlen, num);
-			if (BRCMF_GLOM_ON() && bus->nextlen) {
-				if (totlen != bus->nextlen) {
-					brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
-						  bus->nextlen, totlen, rxseq);
-				}
+			if (BRCMF_GLOM_ON() && bus->nextlen &&
+			    totlen != bus->nextlen) {
+				brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
+					  bus->nextlen, totlen, rxseq);
 			}
 			bus->glom = pfirst;
 			pfirst = pnext = NULL;
@@ -1753,6 +1752,51 @@ done:
 	brcmf_sdbrcm_ioctl_resp_wake(bus);
 }
 
+/* Pad read to blocksize for efficiency */
+static void brcmf_pad(struct brcmf_bus *bus, u16 *pad, u16 *rdlen)
+{
+	if (bus->roundup && bus->blocksize && *rdlen > bus->blocksize) {
+		*pad = bus->blocksize - (*rdlen % bus->blocksize);
+		if (*pad <= bus->roundup && *pad < bus->blocksize &&
+		    *rdlen + *pad + BRCMF_FIRSTREAD < MAX_RX_DATASZ)
+			*rdlen += *pad;
+	} else if (*rdlen % BRCMF_SDALIGN) {
+		*rdlen += BRCMF_SDALIGN - (*rdlen % BRCMF_SDALIGN);
+	}
+}
+
+static void
+brcmf_alloc_pkt_and_read(struct brcmf_bus *bus, u16 rdlen,
+			 struct sk_buff **pkt, u8 **rxbuf)
+{
+	int sdret;		/* Return code from calls */
+
+	*pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
+	if (*pkt == NULL)
+		return;
+
+	pkt_align(*pkt, rdlen, BRCMF_SDALIGN);
+	*rxbuf = (u8 *) ((*pkt)->data);
+	/* Read the entire frame */
+	sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
+				      SDIO_FUNC_2, F2SYNC,
+				      *rxbuf, rdlen, *pkt);
+	bus->f2rxdata++;
+
+	if (sdret < 0) {
+		brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
+			  rdlen, sdret);
+		brcmu_pkt_buf_free_skb(*pkt);
+		bus->drvr->rx_errors++;
+		/* Force retry w/normal header read.
+		 * Don't attempt NAK for
+		 * gSPI
+		 */
+		brcmf_sdbrcm_rxfail(bus, true, true);
+		*pkt = NULL;
+	}
+}
+
 /* Return true if there may be more frames to read */
 static uint
 brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
@@ -1801,63 +1845,19 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			bus->nextlen = 0;
 
 			rdlen = len = nextlen << 4;
+			brcmf_pad(bus, &pad, &rdlen);
 
-			/* Pad read to blocksize for efficiency */
-			if (bus->roundup && bus->blocksize
-			    && (rdlen > bus->blocksize)) {
-				pad =
-				    bus->blocksize -
-				    (rdlen % bus->blocksize);
-				if ((pad <= bus->roundup)
-				    && (pad < bus->blocksize)
-				    && ((rdlen + pad + BRCMF_FIRSTREAD) <
-					MAX_RX_DATASZ))
-					rdlen += pad;
-			} else if (rdlen % BRCMF_SDALIGN) {
-				rdlen += BRCMF_SDALIGN -
-					 (rdlen % BRCMF_SDALIGN);
-			}
-
-			/* We use bus->rxctl buffer in WinXP for initial
-			 * control pkt receives.
-			 * Later we use buffer-poll for data as well
-			 * as control packets.
-			 * This is required because dhd receives full
-			 * frame in gSPI unlike SDIO.
+			/*
 			 * After the frame is received we have to
 			 * distinguish whether it is data
 			 * or non-data frame.
 			 */
-			/* Allocate a packet buffer */
-			pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
-			if (!pkt) {
+			brcmf_alloc_pkt_and_read(bus, rdlen, &pkt, &rxbuf);
+			if (pkt == NULL) {
 				/* Give up on data, request rtx of events */
-				brcmf_dbg(ERROR, "(nextlen): brcmu_pkt_buf_get_skb failed: len %d rdlen %d expected rxseq %d\n",
+				brcmf_dbg(ERROR, "(nextlen): brcmf_alloc_pkt_and_read failed: len %d rdlen %d expected rxseq %d\n",
 					  len, rdlen, rxseq);
 				continue;
-			} else {
-				pkt_align(pkt, rdlen, BRCMF_SDALIGN);
-				rxbuf = (u8 *) (pkt->data);
-				/* Read the entire frame */
-				sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
-						bus->sdiodev->sbwad,
-						SDIO_FUNC_2, F2SYNC,
-						rxbuf, rdlen,
-						pkt);
-				bus->f2rxdata++;
-
-				if (sdret < 0) {
-					brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
-						  rdlen, sdret);
-					brcmu_pkt_buf_free_skb(pkt);
-					bus->drvr->rx_errors++;
-					/* Force retry w/normal header read.
-					 * Don't attempt NAK for
-					 * gSPI
-					 */
-					brcmf_sdbrcm_rxfail(bus, true, true);
-					continue;
-				}
 			}
 
 			/* Now check the header */
-- 
1.7.1


