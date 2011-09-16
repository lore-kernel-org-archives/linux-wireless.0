Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3488 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/19] staging: brcm80211: remove static global
 variables from dhd_sdio.c
Date: Fri, 16 Sep 2011 12:28:07 -0700
Message-ID: <1316201288-29635-19-git-send-email-frankyl@broadcom.com> (sfid-20110916_212849_660585_564D0F6E)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several global variables that were set but never initialized have
been removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  161 ++++++++++--------------
 1 files changed, 67 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index dade3ec..720f567 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -761,26 +761,18 @@ module_param(brcmf_poll, uint, 0);
 uint brcmf_intr = true;
 module_param(brcmf_intr, uint, 0);
 
-/* IOCTL response timeout */
-static int brcmf_ioctl_timeout_msec = IOCTL_RESP_TIMEOUT;
-
 /* override the RAM size if possible */
 #define DONGLE_MIN_MEMSIZE (128 * 1024)
 int brcmf_dongle_memsize;
 module_param(brcmf_dongle_memsize, int, 0);
 
-static bool brcmf_alignctl;
-
-static bool retrydata;
-#define RETRYCHAN(chan) (((chan) == SDPCM_EVENT_CHANNEL) || retrydata)
-
-static const uint firstread = BRCMF_FIRSTREAD;
+#define RETRYCHAN(chan) ((chan) == SDPCM_EVENT_CHANNEL)
 
 /* Retry count for register access failures */
 static const uint retry_limit = 2;
 
-/* Force even SD lengths (some host controllers mess up on odd bytes) */
-static bool forcealign;
+/* Limit on rounding up frames */
+static const uint max_roundup = 512;
 
 #define ALIGNMENT  4
 
@@ -794,12 +786,6 @@ static void pkt_align(struct sk_buff *p, int len, int align)
 	__skb_trim(p, len);
 }
 
-/* Limit on rounding up frames */
-static const uint max_roundup = 512;
-
-/* Try doing readahead */
-static bool brcmf_readahead;
-
 /* To check if there's window offered */
 static bool data_ok(struct brcmf_bus *bus)
 {
@@ -1697,7 +1683,7 @@ static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
 					bool *pending)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	int timeout = msecs_to_jiffies(brcmf_ioctl_timeout_msec);
+	int timeout = msecs_to_jiffies(IOCTL_RESP_TIMEOUT);
 
 	/* Wait until control frame is available */
 	add_wait_queue(&bus->ioctl_resp_wait, &wait);
@@ -1733,21 +1719,19 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	/* Set rxctl for frame (w/optional alignment) */
 	bus->rxctl = bus->rxbuf;
-	if (brcmf_alignctl) {
-		bus->rxctl += firstread;
-		pad = ((unsigned long)bus->rxctl % BRCMF_SDALIGN);
-		if (pad)
-			bus->rxctl += (BRCMF_SDALIGN - pad);
-		bus->rxctl -= firstread;
-	}
+	bus->rxctl += BRCMF_FIRSTREAD;
+	pad = ((unsigned long)bus->rxctl % BRCMF_SDALIGN);
+	if (pad)
+		bus->rxctl += (BRCMF_SDALIGN - pad);
+	bus->rxctl -= BRCMF_FIRSTREAD;
 
 	/* Copy the already-read portion over */
-	memcpy(bus->rxctl, hdr, firstread);
-	if (len <= firstread)
+	memcpy(bus->rxctl, hdr, BRCMF_FIRSTREAD);
+	if (len <= BRCMF_FIRSTREAD)
 		goto gotpkt;
 
 	/* Raise rdlen to next SDIO block to avoid tail command */
-	rdlen = len - firstread;
+	rdlen = len - BRCMF_FIRSTREAD;
 	if (bus->roundup && bus->blocksize && (rdlen > bus->blocksize)) {
 		pad = bus->blocksize - (rdlen % bus->blocksize);
 		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
@@ -1758,11 +1742,11 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 	}
 
 	/* Satisfy length-alignment requirements */
-	if (forcealign && (rdlen & (ALIGNMENT - 1)))
+	if (rdlen & (ALIGNMENT - 1))
 		rdlen = roundup(rdlen, ALIGNMENT);
 
 	/* Drop if the read is too big or it exceeds our maximum */
-	if ((rdlen + firstread) > bus->drvr->maxctl) {
+	if ((rdlen + BRCMF_FIRSTREAD) > bus->drvr->maxctl) {
 		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->drvr->maxctl);
 		bus->drvr->rx_errors++;
@@ -1783,7 +1767,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 	sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
 				bus->sdiodev->sbwad,
 				SDIO_FUNC_2,
-				F2SYNC, (bus->rxctl + firstread), rdlen,
+				F2SYNC, (bus->rxctl + BRCMF_FIRSTREAD), rdlen,
 				NULL);
 	bus->f2rxdata++;
 
@@ -1857,7 +1841,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		}
 
 		/* Try doing single read if we can */
-		if (brcmf_readahead && bus->nextlen) {
+		if (bus->nextlen) {
 			u16 nextlen = bus->nextlen;
 			bus->nextlen = 0;
 
@@ -1871,7 +1855,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				    (rdlen % bus->blocksize);
 				if ((pad <= bus->roundup)
 				    && (pad < bus->blocksize)
-				    && ((rdlen + pad + firstread) <
+				    && ((rdlen + pad + BRCMF_FIRSTREAD) <
 					MAX_RX_DATASZ))
 					rdlen += pad;
 			} else if (rdlen % BRCMF_SDALIGN) {
@@ -2055,8 +2039,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Read frame header (hardware and software) */
 		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
-				SDIO_FUNC_2, F2SYNC, bus->rxhdr, firstread,
-				NULL);
+					      SDIO_FUNC_2, F2SYNC, bus->rxhdr,
+					      BRCMF_FIRSTREAD, NULL);
 		bus->f2rxhdrs++;
 
 		if (sdret < 0) {
@@ -2162,24 +2146,24 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		   SDPCM_GLOM_CHANNEL */
 
 		/* Length to read */
-		rdlen = (len > firstread) ? (len - firstread) : 0;
+		rdlen = (len > BRCMF_FIRSTREAD) ? (len - BRCMF_FIRSTREAD) : 0;
 
 		/* May pad read to blocksize for efficiency */
 		if (bus->roundup && bus->blocksize &&
 			(rdlen > bus->blocksize)) {
 			pad = bus->blocksize - (rdlen % bus->blocksize);
 			if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
-			    ((rdlen + pad + firstread) < MAX_RX_DATASZ))
+			    ((rdlen + pad + BRCMF_FIRSTREAD) < MAX_RX_DATASZ))
 				rdlen += pad;
 		} else if (rdlen % BRCMF_SDALIGN) {
 			rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
 		}
 
 		/* Satisfy length-alignment requirements */
-		if (forcealign && (rdlen & (ALIGNMENT - 1)))
+		if (rdlen & (ALIGNMENT - 1))
 			rdlen = roundup(rdlen, ALIGNMENT);
 
-		if ((rdlen + firstread) > MAX_RX_DATASZ) {
+		if ((rdlen + BRCMF_FIRSTREAD) > MAX_RX_DATASZ) {
 			/* Too long -- skip this frame */
 			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
 				  len, rdlen);
@@ -2189,7 +2173,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			continue;
 		}
 
-		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + BRCMF_SDALIGN);
+		pkt = brcmu_pkt_buf_get_skb(rdlen +
+					    BRCMF_FIRSTREAD + BRCMF_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
 			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
@@ -2200,7 +2185,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		}
 
 		/* Leave room for what we already read, and align remainder */
-		skb_pull(pkt, firstread);
+		skb_pull(pkt, BRCMF_FIRSTREAD);
 		pkt_align(pkt, rdlen, BRCMF_SDALIGN);
 
 		/* Read the remaining frame data */
@@ -2221,8 +2206,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		}
 
 		/* Copy the already-read portion */
-		skb_push(pkt, firstread);
-		memcpy(pkt->data, bus->rxhdr, firstread);
+		skb_push(pkt, BRCMF_FIRSTREAD);
+		memcpy(pkt->data, bus->rxhdr, BRCMF_FIRSTREAD);
 
 #ifdef BCMDBG
 		if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
@@ -2328,7 +2313,6 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 	u8 *frame;
 	u16 len, pad = 0;
 	u32 swheader;
-	uint retries = 0;
 	struct sk_buff *new;
 	int i;
 
@@ -2413,48 +2397,44 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 	}
 
 	/* Some controllers have trouble with odd bytes -- round to even */
-	if (forcealign && (len & (ALIGNMENT - 1)))
+	if (len & (ALIGNMENT - 1))
 			len = roundup(len, ALIGNMENT);
 
-	do {
-		ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
-					    SDIO_FUNC_2, F2SYNC, frame,
-					    len, pkt);
-		bus->f2txdata++;
+	ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+				    SDIO_FUNC_2, F2SYNC, frame,
+				    len, pkt);
+	bus->f2txdata++;
 
-		if (ret < 0) {
-			/* On failure, abort the command
-			 and terminate the frame */
-			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-				  ret);
-			bus->tx_sderrs++;
+	if (ret < 0) {
+		/* On failure, abort the command and terminate the frame */
+		brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+			  ret);
+		bus->tx_sderrs++;
 
-			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-					 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
-					 NULL);
-			bus->f1regdata++;
-
-			for (i = 0; i < 3; i++) {
-				u8 hi, lo;
-				hi = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCHI,
-						     NULL);
-				lo = brcmf_sdcard_cfg_read(bus->sdiodev,
-						     SDIO_FUNC_1,
-						     SBSDIO_FUNC1_WFRAMEBCLO,
-						     NULL);
-				bus->f1regdata += 2;
-				if ((hi == 0) && (lo == 0))
-					break;
-			}
+		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				 SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM,
+				 NULL);
+		bus->f1regdata++;
 
+		for (i = 0; i < 3; i++) {
+			u8 hi, lo;
+			hi = brcmf_sdcard_cfg_read(bus->sdiodev,
+					     SDIO_FUNC_1,
+					     SBSDIO_FUNC1_WFRAMEBCHI,
+					     NULL);
+			lo = brcmf_sdcard_cfg_read(bus->sdiodev,
+					     SDIO_FUNC_1,
+					     SBSDIO_FUNC1_WFRAMEBCLO,
+					     NULL);
+			bus->f1regdata += 2;
+			if ((hi == 0) && (lo == 0))
+				break;
 		}
-		if (ret == 0)
-			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-	} while ((ret < 0) && retrydata && retries++ < TXRETRIES);
+	}
+	if (ret == 0)
+		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
 done:
 	/* restore pkt buffer pointer before calling tx complete routine */
@@ -3259,16 +3239,14 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	len = (msglen += SDPCM_HDRLEN);
 
 	/* Add alignment padding (optional for ctl frames) */
-	if (brcmf_alignctl) {
-		doff = ((unsigned long)frame % BRCMF_SDALIGN);
-		if (doff) {
-			frame -= doff;
-			len += doff;
-			msglen += doff;
-			memset(frame, 0, doff + SDPCM_HDRLEN);
-		}
-		/* precondition: doff < BRCMF_SDALIGN */
+	doff = ((unsigned long)frame % BRCMF_SDALIGN);
+	if (doff) {
+		frame -= doff;
+		len += doff;
+		msglen += doff;
+		memset(frame, 0, doff + SDPCM_HDRLEN);
 	}
+	/* precondition: doff < BRCMF_SDALIGN */
 	doff += SDPCM_HDRLEN;
 
 	/* Round send length to next SDIO block */
@@ -3281,7 +3259,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	}
 
 	/* Satisfy length-alignment requirements */
-	if (forcealign && (len & (ALIGNMENT - 1)))
+	if (len & (ALIGNMENT - 1))
 		len = roundup(len, ALIGNMENT);
 
 	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
@@ -4825,14 +4803,9 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	 */
 	brcmf_txbound = BRCMF_TXBOUND;
 	brcmf_rxbound = BRCMF_RXBOUND;
-	brcmf_alignctl = true;
-	brcmf_readahead = true;
-	retrydata = false;
 	brcmf_dongle_memsize = 0;
 	brcmf_txminmax = BRCMF_TXMINMAX;
 
-	forcealign = true;
-
 	brcmf_c_init();
 
 	brcmf_dbg(TRACE, "Enter\n");
-- 
1.7.1


