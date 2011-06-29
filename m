Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1913 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 033/119] staging: brcm80211: correct bcmsdh_recv_buf()
 calls
Date: Wed, 29 Jun 2011 16:46:57 -0700
Message-ID: <1309391303-22741-34-git-send-email-frankyl@broadcom.com> (sfid-20110630_014859_422100_3DBB9D45)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The calls in dhd_sdio.c to bcmsdh_recv_buf() function passed a wrong
handle. The parameter in the function prototype was typed as void
pointer so compiler could not detect. This patch makes the type
explicit and fixes the calls to the function.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |    3 +--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   14 +++++++-------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 3d0c8e7..58dffc0 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -447,11 +447,10 @@ bool bcmsdh_regfail(void *sdh)
 }
 
 int
-bcmsdh_recv_buf(void *sdh, u32 addr, uint fn, uint flags,
+bcmsdh_recv_buf(bcmsdh_info_t *bcmsdh, u32 addr, uint fn, uint flags,
 		u8 *buf, uint nbytes, struct sk_buff *pkt,
 		bcmsdh_cmplt_fn_t complete, void *handle)
 {
-	bcmsdh_info_t *bcmsdh = (bcmsdh_info_t *) sdh;
 	SDIOH_API_RC status;
 	uint incr_fix;
 	uint width;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 0fae0b1..7e4dfde 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -3323,7 +3323,7 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 	}
 
 	/* Read remainder of frame body into the rxctl buffer */
-	sdret = bcmsdh_recv_buf(bus, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
+	sdret = bcmsdh_recv_buf(sdh, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
 				F2SYNC, (bus->rxctl + firstread), rdlen,
 				NULL, NULL, NULL);
 	bus->f2rxdata++;
@@ -3485,12 +3485,12 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 		 * packet and and copy into the chain.
 		 */
 		if (usechain) {
-			errcode = bcmsdh_recv_buf(bus,
+			errcode = bcmsdh_recv_buf(bus->sdh,
 					bcmsdh_cur_sbwad(bus->sdh), SDIO_FUNC_2,
 					F2SYNC, (u8 *) pfirst->data, dlen,
 					pfirst, NULL, NULL);
 		} else if (bus->dataptr) {
-			errcode = bcmsdh_recv_buf(bus,
+			errcode = bcmsdh_recv_buf(bus->sdh,
 					bcmsdh_cur_sbwad(bus->sdh), SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL, NULL, NULL);
@@ -3867,7 +3867,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					ASSERT(bus->rxctl >= bus->rxbuf);
 					rxbuf = bus->rxctl;
 					/* Read the entire frame */
-					sdret = bcmsdh_recv_buf(bus,
+					sdret = bcmsdh_recv_buf(sdh,
 						    bcmsdh_cur_sbwad(sdh),
 						    SDIO_FUNC_2, F2SYNC,
 						    rxbuf, rdlen,
@@ -3908,7 +3908,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 				PKTALIGN(pkt, rdlen, DHD_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
-				sdret = bcmsdh_recv_buf(bus,
+				sdret = bcmsdh_recv_buf(sdh,
 						bcmsdh_cur_sbwad(sdh),
 						SDIO_FUNC_2, F2SYNC,
 						rxbuf, rdlen,
@@ -4086,7 +4086,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			break;
 
 		/* Read frame header (hardware and software) */
-		sdret = bcmsdh_recv_buf(bus, bcmsdh_cur_sbwad(sdh),
+		sdret = bcmsdh_recv_buf(sdh, bcmsdh_cur_sbwad(sdh),
 				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
 				NULL, NULL, NULL);
 		bus->f2rxhdrs++;
@@ -4247,7 +4247,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		PKTALIGN(pkt, rdlen, DHD_SDALIGN);
 
 		/* Read the remaining frame data */
-		sdret = bcmsdh_recv_buf(bus, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
+		sdret = bcmsdh_recv_buf(sdh, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
 					F2SYNC, ((u8 *) (pkt->data)), rdlen,
 					pkt, NULL, NULL);
 		bus->f2rxdata++;
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 96a43cb..7fa79d6 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -150,7 +150,7 @@ typedef void (*bcmsdh_cmplt_fn_t) (void *handle, int status, bool sync_waiting);
 extern int bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 			   u8 *buf, uint nbytes, void *pkt,
 			   bcmsdh_cmplt_fn_t complete, void *handle);
-extern int bcmsdh_recv_buf(void *sdh, u32 addr, uint fn, uint flags,
+extern int bcmsdh_recv_buf(bcmsdh_info_t *sdh, u32 addr, uint fn, uint flags,
 			   u8 *buf, uint nbytes, struct sk_buff *pkt,
 			   bcmsdh_cmplt_fn_t complete, void *handle);
 
-- 
1.7.1


