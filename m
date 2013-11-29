Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1068 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/19] brcmfmac: use platform specific alignment in SDIO
Date: Fri, 29 Nov 2013 12:25:14 +0100
Message-ID: <1385724324-6361-10-git-send-email-arend@broadcom.com> (sfid-20131129_122549_196732_DB893DA7)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SDIO part of the brcmfmac driver uses a static define BRCMF_SDALIGN
to align buffers used for SDIO transfers. This patch replaces it by
using alignment derived from the platform specific data.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   50 +++++++++-----------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 584ffb8..0f95f3e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -389,7 +389,7 @@ struct brcmf_sdio {
 	u8 tx_seq;		/* Transmit sequence number (next) */
 	u8 tx_max;		/* Maximum transmit sequence allowed */
 
-	u8 hdrbuf[MAX_HDR_READ + BRCMF_SDALIGN];
+	u8 *hdrbuf;		/* buffer for handling rx frame */
 	u8 *rxhdr;		/* Header of current rx frame (in hdrbuf) */
 	u8 rx_seq;		/* Receive sequence number (expected) */
 	struct brcmf_sdio_hdrinfo cur_read;
@@ -1580,9 +1580,9 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		goto done;
 
 	rbuf = bus->rxbuf;
-	pad = ((unsigned long)rbuf % BRCMF_SDALIGN);
+	pad = ((unsigned long)rbuf % bus->head_align);
 	if (pad)
-		rbuf += (BRCMF_SDALIGN - pad);
+		rbuf += (bus->head_align - pad);
 
 	/* Copy the already-read portion over */
 	memcpy(buf, hdr, BRCMF_FIRSTREAD);
@@ -1596,14 +1596,10 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
 		    ((len + pad) < bus->sdiodev->bus_if->maxctl))
 			rdlen += pad;
-	} else if (rdlen % BRCMF_SDALIGN) {
-		rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
+	} else if (rdlen % bus->head_align) {
+		rdlen += bus->head_align - (rdlen % bus->head_align);
 	}
 
-	/* Satisfy length-alignment requirements */
-	if (rdlen & (ALIGNMENT - 1))
-		rdlen = roundup(rdlen, ALIGNMENT);
-
 	/* Drop if the read is too big or it exceeds our maximum */
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_err("%d-byte control read exceeds %d-byte buffer\n",
@@ -1668,8 +1664,8 @@ static void brcmf_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
 		if (*pad <= bus->roundup && *pad < bus->blocksize &&
 		    *rdlen + *pad + BRCMF_FIRSTREAD < MAX_RX_DATASZ)
 			*rdlen += *pad;
-	} else if (*rdlen % BRCMF_SDALIGN) {
-		*rdlen += BRCMF_SDALIGN - (*rdlen % BRCMF_SDALIGN);
+	} else if (*rdlen % bus->head_align) {
+		*rdlen += bus->head_align - (*rdlen % bus->head_align);
 	}
 }
 
@@ -1757,7 +1753,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		brcmf_pad(bus, &pad, &rd->len_left);
 
 		pkt = brcmu_pkt_buf_get_skb(rd->len_left + head_read +
-					    BRCMF_SDALIGN);
+					    bus->head_align);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
 			brcmf_err("brcmu_pkt_buf_get_skb failed\n");
@@ -1767,7 +1763,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			continue;
 		}
 		skb_pull(pkt, head_read);
-		pkt_align(pkt, rd->len_left, BRCMF_SDALIGN);
+		pkt_align(pkt, rd->len_left, bus->head_align);
 
 		ret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, pkt);
@@ -2762,14 +2758,14 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	len = (msglen += bus->tx_hdrlen);
 
 	/* Add alignment padding (optional for ctl frames) */
-	doff = ((unsigned long)frame % BRCMF_SDALIGN);
+	doff = ((unsigned long)frame % bus->head_align);
 	if (doff) {
 		frame -= doff;
 		len += doff;
 		msglen += doff;
 		memset(frame, 0, doff + bus->tx_hdrlen);
 	}
-	/* precondition: doff < BRCMF_SDALIGN */
+	/* precondition: doff < bus->head_align */
 	doff += bus->tx_hdrlen;
 
 	/* Round send length to next SDIO block */
@@ -2778,15 +2774,11 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		pad = bus->blocksize - (len % bus->blocksize);
 		if ((pad > bus->roundup) || (pad >= bus->blocksize))
 			pad = 0;
-	} else if (len % BRCMF_SDALIGN) {
-		pad = BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
+	} else if (len % bus->head_align) {
+		pad = bus->head_align - (len % bus->head_align);
 	}
 	len += pad;
 
-	/* Satisfy length-alignment requirements */
-	if (len & (ALIGNMENT - 1))
-		len = roundup(len, ALIGNMENT);
-
 	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
 
 	/* Make sure backplane clock is on */
@@ -2798,10 +2790,8 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	hd_info.channel = SDPCM_CONTROL_CHANNEL;
 	hd_info.dat_offset = doff;
 	hd_info.seq_num = bus->tx_seq;
-	if (bus->txglom) {
-		hd_info.lastfrm = true;
-		hd_info.tail_pad = pad;
-	}
+	hd_info.lastfrm = true;
+	hd_info.tail_pad = pad;
 	brcmf_sdio_hdpack(bus, frame, &hd_info);
 
 	if (bus->txglom)
@@ -3823,7 +3813,7 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
 	if (bus->sdiodev->bus_if->maxctl) {
 		bus->rxblen =
 		    roundup((bus->sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
-			    ALIGNMENT) + BRCMF_SDALIGN;
+			    ALIGNMENT) + bus->head_align;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf))
 			return false;
@@ -3924,9 +3914,13 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
+	/* allocate header buffer */
+	bus->hdrbuf = kzalloc(MAX_HDR_READ + bus->head_align, GFP_KERNEL);
+	if (!bus->hdrbuf)
+		return false;
 	/* Locate an appropriately-aligned portion of hdrbuf */
 	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0],
-				    BRCMF_SDALIGN);
+				    bus->head_align);
 
 	/* Set the poll and/or interrupt flags */
 	bus->intr = true;
@@ -4047,7 +4041,7 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 
 		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
 		brcmf_sdbrcm_release_malloc(bus);
-
+		kfree(bus->hdrbuf);
 		kfree(bus);
 	}
 
-- 
1.7.10.4


