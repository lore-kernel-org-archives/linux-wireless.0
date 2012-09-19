Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3074 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/13] brcmfmac: streamline SDIO read frame routine
Date: Wed, 19 Sep 2012 22:21:11 +0200
Message-ID: <1348086078-19183-7-git-send-email-arend@broadcom.com> (sfid-20120919_222552_551846_96DBB7D7)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

SDIO read non-glomming frame routine handles first frame and
follow up frame read separately. But they share a lot of common
code. This patch abstracts a brcmf_sdio_hdparser function and
optimize the code flow for better readability and future
optimization.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  621 ++++++++------------
 1 file changed, 233 insertions(+), 388 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ff7e829..3564686 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -482,6 +482,15 @@ struct sdpcm_shared_le {
 	__le32 brpt_addr;
 };
 
+/* SDIO read frame info */
+struct brcmf_sdio_read {
+	u8 seq_num;
+	u8 channel;
+	u16 len;
+	u16 len_left;
+	u16 len_nxtfrm;
+	u8 dat_offset;
+};
 
 /* misc chip info needed by some of the routines */
 /* Private data for SDIO bus interaction */
@@ -507,9 +516,11 @@ struct brcmf_sdio {
 
 	u8 hdrbuf[MAX_HDR_READ + BRCMF_SDALIGN];
 	u8 *rxhdr;		/* Header of current rx frame (in hdrbuf) */
-	u16 nextlen;		/* Next Read Len from last header */
 	u8 rx_seq;		/* Receive sequence number (expected) */
+	struct brcmf_sdio_read cur_read;
+				/* info of current read frame */
 	bool rxskip;		/* Skip receive (awaiting NAK ACK) */
+	bool rxpending;		/* Data frame pending in dongle */
 
 	uint rxbound;		/* Rx frames to read before resched */
 	uint txbound;		/* Tx frames to send before resched */
@@ -551,8 +562,6 @@ struct brcmf_sdio {
 	bool rxflow_mode;	/* Rx flow control mode */
 	bool rxflow;		/* Is rx flow control on */
 	bool alp_only;		/* Don't use HT clock (ALP only) */
-/* Field to decide if rx of control frames happen in rxbuf or lb-pool */
-	bool usebufpool;
 
 	u8 *ctrl_frame_buf;
 	u32 ctrl_frame_len;
@@ -655,15 +664,6 @@ w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
-/* Packet free applicable unconditionally for sdio and sdspi.
- * Conditional if bufpool was present for gspi bus.
- */
-static void brcmf_sdbrcm_pktfree2(struct brcmf_sdio *bus, struct sk_buff *pkt)
-{
-	if (bus->usebufpool)
-		brcmu_pkt_buf_free_skb(pkt);
-}
-
 /* Turn backplane clock on or off */
 static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 {
@@ -979,7 +979,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	}
 
 	/* Clear partial in any case */
-	bus->nextlen = 0;
+	bus->cur_read.len = 0;
 
 	/* If we can't reach the device, signal failure */
 	if (err)
@@ -1031,6 +1031,96 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
 	}
 }
 
+static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
+				struct brcmf_sdio_read *rd)
+{
+	u16 len, checksum;
+	u8 rx_seq, fc, tx_seq_max;
+
+	/*
+	 * 4 bytes hardware header (frame tag)
+	 * Byte 0~1: Frame length
+	 * Byte 2~3: Checksum, bit-wise inverse of frame length
+	 */
+	len = get_unaligned_le16(header);
+	checksum = get_unaligned_le16(header + sizeof(u16));
+	/* All zero means no more to read */
+	if (!(len | checksum)) {
+		bus->rxpending = false;
+		return false;
+	}
+	if ((u16)(~(len ^ checksum))) {
+		brcmf_dbg(ERROR, "HW header checksum error\n");
+		bus->sdcnt.rx_badhdr++;
+		brcmf_sdbrcm_rxfail(bus, false, false);
+		return false;
+	}
+	if (len < SDPCM_HDRLEN) {
+		brcmf_dbg(ERROR, "HW header length error\n");
+		return false;
+	}
+	rd->len = len;
+
+	/*
+	 * 8 bytes hardware header
+	 * Byte 0: Rx sequence number
+	 * Byte 1: 4 MSB Channel number, 4 LSB arbitrary flag
+	 * Byte 2: Length of next data frame
+	 * Byte 3: Data offset
+	 * Byte 4: Flow control bits
+	 * Byte 5: Maximum Sequence number allow for Tx
+	 * Byte 6~7: Reserved
+	 */
+	rx_seq = SDPCM_PACKET_SEQUENCE(&header[SDPCM_FRAMETAG_LEN]);
+	rd->channel = SDPCM_PACKET_CHANNEL(&header[SDPCM_FRAMETAG_LEN]);
+	if (len > MAX_RX_DATASZ && rd->channel != SDPCM_CONTROL_CHANNEL) {
+		brcmf_dbg(ERROR, "HW header length too long\n");
+		bus->sdiodev->bus_if->dstats.rx_errors++;
+		bus->sdcnt.rx_toolong++;
+		brcmf_sdbrcm_rxfail(bus, false, false);
+		rd->len = 0;
+		return false;
+	}
+	rd->dat_offset = SDPCM_DOFFSET_VALUE(&header[SDPCM_FRAMETAG_LEN]);
+	if (rd->dat_offset < SDPCM_HDRLEN || rd->dat_offset > rd->len) {
+		brcmf_dbg(ERROR, "seq %d: bad data offset\n", rx_seq);
+		bus->sdcnt.rx_badhdr++;
+		brcmf_sdbrcm_rxfail(bus, false, false);
+		rd->len = 0;
+		return false;
+	}
+	if (rd->seq_num != rx_seq) {
+		brcmf_dbg(ERROR, "seq %d: sequence number error, expect %d\n",
+			  rx_seq, rd->seq_num);
+		bus->sdcnt.rx_badseq++;
+		rd->seq_num = rx_seq;
+	}
+	rd->len_nxtfrm = header[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
+	if (rd->len_nxtfrm << 4 > MAX_RX_DATASZ) {
+		/* only warm for NON glom packet */
+		if (rd->channel != SDPCM_GLOM_CHANNEL)
+			brcmf_dbg(ERROR, "seq %d: next length error\n", rx_seq);
+		rd->len_nxtfrm = 0;
+	}
+	fc = SDPCM_FCMASK_VALUE(&header[SDPCM_FRAMETAG_LEN]);
+	if (bus->flowcontrol != fc) {
+		if (~bus->flowcontrol & fc)
+			bus->sdcnt.fc_xoff++;
+		if (bus->flowcontrol & ~fc)
+			bus->sdcnt.fc_xon++;
+		bus->sdcnt.fc_rcvd++;
+		bus->flowcontrol = fc;
+	}
+	tx_seq_max = SDPCM_WINDOW_VALUE(&header[SDPCM_FRAMETAG_LEN]);
+	if ((u8)(tx_seq_max - bus->tx_seq) > 0x40) {
+		brcmf_dbg(ERROR, "seq %d: max tx seq number error\n", rx_seq);
+		tx_seq_max = bus->tx_seq + 2;
+	}
+	bus->tx_max = tx_seq_max;
+
+	return true;
+}
+
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
@@ -1045,6 +1135,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 	int ifidx = 0;
 	bool usechain = bus->use_rxchain;
+	u16 next_len;
 
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
@@ -1108,10 +1199,10 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		if (pnext) {
 			brcmf_dbg(GLOM, "allocated %d-byte packet chain for %d subframes\n",
 				  totlen, num);
-			if (BRCMF_GLOM_ON() && bus->nextlen &&
-			    totlen != bus->nextlen) {
+			if (BRCMF_GLOM_ON() && bus->cur_read.len &&
+			    totlen != bus->cur_read.len) {
 				brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
-					  bus->nextlen, totlen, rxseq);
+					  bus->cur_read.len, totlen, rxseq);
 			}
 			pfirst = pnext = NULL;
 		} else {
@@ -1122,7 +1213,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		/* Done with descriptor packet */
 		brcmu_pkt_buf_free_skb(bus->glomd);
 		bus->glomd = NULL;
-		bus->nextlen = 0;
+		bus->cur_read.len = 0;
 	}
 
 	/* Ok -- either we just generated a packet chain,
@@ -1195,12 +1286,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
 		seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
-		bus->nextlen = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
-		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
+		next_len = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
+		if ((next_len << 4) > MAX_RX_DATASZ) {
 			brcmf_dbg(INFO, "nextlen too large (%d) seq %d\n",
-				  bus->nextlen, seq);
-			bus->nextlen = 0;
+				  next_len, seq);
+			next_len = 0;
 		}
+		bus->cur_read.len = next_len << 4;
 		doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 		txmax = SDPCM_WINDOW_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
@@ -1301,7 +1393,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				bus->sdcnt.rxglomfail++;
 				brcmf_sdbrcm_free_glom(bus);
 			}
-			bus->nextlen = 0;
+			bus->cur_read.len = 0;
 			return 0;
 		}
 
@@ -1496,422 +1588,166 @@ static void brcmf_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
 	}
 }
 
-static void
-brcmf_alloc_pkt_and_read(struct brcmf_sdio *bus, u16 rdlen,
-			 struct sk_buff **pkt, u8 **rxbuf)
+static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 {
-	int sdret;		/* Return code from calls */
-
-	*pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
-	if (*pkt == NULL)
-		return;
-
-	pkt_align(*pkt, rdlen, BRCMF_SDALIGN);
-	*rxbuf = (u8 *) ((*pkt)->data);
-	/* Read the entire frame */
-	sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
-				      SDIO_FUNC_2, F2SYNC, *pkt);
-	bus->sdcnt.f2rxdata++;
-
-	if (sdret < 0) {
-		brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
-			  rdlen, sdret);
-		brcmu_pkt_buf_free_skb(*pkt);
-		bus->sdiodev->bus_if->dstats.rx_errors++;
-		/* Force retry w/normal header read.
-		 * Don't attempt NAK for
-		 * gSPI
-		 */
-		brcmf_sdbrcm_rxfail(bus, true, true);
-		*pkt = NULL;
-	}
-}
-
-/* Checks the header */
-static int
-brcmf_check_rxbuf(struct brcmf_sdio *bus, struct sk_buff *pkt, u8 *rxbuf,
-		  u8 rxseq, u16 nextlen, u16 *len)
-{
-	u16 check;
-	bool len_consistent;	/* Result of comparing readahead len and
-				   len from hw-hdr */
-
-	memcpy(bus->rxhdr, rxbuf, SDPCM_HDRLEN);
-
-	/* Extract hardware header fields */
-	*len = get_unaligned_le16(bus->rxhdr);
-	check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
-
-	/* All zeros means readahead info was bad */
-	if (!(*len | check)) {
-		brcmf_dbg(INFO, "(nextlen): read zeros in HW header???\n");
-		goto fail;
-	}
-
-	/* Validate check bytes */
-	if ((u16)~(*len ^ check)) {
-		brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
-			  nextlen, *len, check);
-		bus->sdcnt.rx_badhdr++;
-		brcmf_sdbrcm_rxfail(bus, false, false);
-		goto fail;
-	}
-
-	/* Validate frame length */
-	if (*len < SDPCM_HDRLEN) {
-		brcmf_dbg(ERROR, "(nextlen): HW hdr length invalid: %d\n",
-			  *len);
-		goto fail;
-	}
-
-	/* Check for consistency with readahead info */
-	len_consistent = (nextlen != (roundup(*len, 16) >> 4));
-	if (len_consistent) {
-		/* Mismatch, force retry w/normal
-			header (may be >4K) */
-		brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
-			  nextlen, *len, roundup(*len, 16),
-			  rxseq);
-		brcmf_sdbrcm_rxfail(bus, true, true);
-		goto fail;
-	}
-
-	return 0;
-
-fail:
-	brcmf_sdbrcm_pktfree2(bus, pkt);
-	return -EINVAL;
-}
-
-/* Return true if there may be more frames to read */
-static uint
-brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
-{
-	u16 len, check;	/* Extracted hardware header fields */
-	u8 chan, seq, doff;	/* Extracted software header fields */
-	u8 fcbits;		/* Extracted fcbits from software header */
-
 	struct sk_buff *pkt;		/* Packet for event or data frames */
 	u16 pad;		/* Number of pad bytes to read */
-	u16 rdlen;		/* Total number of bytes to read */
-	u8 rxseq;		/* Next sequence number to expect */
 	uint rxleft = 0;	/* Remaining number of frames allowed */
 	int sdret;		/* Return code from calls */
-	u8 txmax;		/* Maximum tx sequence offered */
-	u8 *rxbuf;
 	int ifidx = 0;
 	uint rxcount = 0;	/* Total frames read */
+	struct brcmf_sdio_read *rd = &bus->cur_read, rd_new;
+	u8 head_read = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Not finished unless we encounter no more frames indication */
-	*finished = false;
+	bus->rxpending = true;
 
-	for (rxseq = bus->rx_seq, rxleft = maxframes;
+	for (rd->seq_num = bus->rx_seq, rxleft = maxframes;
 	     !bus->rxskip && rxleft &&
 	     bus->sdiodev->bus_if->state != BRCMF_BUS_DOWN;
-	     rxseq++, rxleft--) {
+	     rd->seq_num++, rxleft--) {
 
 		/* Handle glomming separately */
 		if (bus->glomd || !skb_queue_empty(&bus->glom)) {
 			u8 cnt;
 			brcmf_dbg(GLOM, "calling rxglom: glomd %p, glom %p\n",
 				  bus->glomd, skb_peek(&bus->glom));
-			cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
+			cnt = brcmf_sdbrcm_rxglom(bus, rd->seq_num);
 			brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
-			rxseq += cnt - 1;
+			rd->seq_num += cnt - 1;
 			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
 			continue;
 		}
 
-		/* Try doing single read if we can */
-		if (bus->nextlen) {
-			u16 nextlen = bus->nextlen;
-			bus->nextlen = 0;
-
-			rdlen = len = nextlen << 4;
-			brcmf_pad(bus, &pad, &rdlen);
-
-			/*
-			 * After the frame is received we have to
-			 * distinguish whether it is data
-			 * or non-data frame.
-			 */
-			brcmf_alloc_pkt_and_read(bus, rdlen, &pkt, &rxbuf);
-			if (pkt == NULL) {
-				/* Give up on data, request rtx of events */
-				brcmf_dbg(ERROR, "(nextlen): brcmf_alloc_pkt_and_read failed: len %d rdlen %d expected rxseq %d\n",
-					  len, rdlen, rxseq);
-				continue;
-			}
-
-			if (brcmf_check_rxbuf(bus, pkt, rxbuf, rxseq, nextlen,
-					      &len) < 0)
+		rd->len_left = rd->len;
+		/* read header first for unknow frame length */
+		if (!rd->len) {
+			sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+						      bus->sdiodev->sbwad,
+						      SDIO_FUNC_2, F2SYNC,
+						      bus->rxhdr,
+						      BRCMF_FIRSTREAD);
+			bus->sdcnt.f2rxhdrs++;
+			if (sdret < 0) {
+				brcmf_dbg(ERROR, "RXHEADER FAILED: %d\n",
+					  sdret);
+				bus->sdcnt.rx_hdrfail++;
+				brcmf_sdbrcm_rxfail(bus, true, true);
 				continue;
-
-			/* Extract software header fields */
-			chan = SDPCM_PACKET_CHANNEL(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-			seq = SDPCM_PACKET_SEQUENCE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-			doff = SDPCM_DOFFSET_VALUE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-			txmax = SDPCM_WINDOW_VALUE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-
-			bus->nextlen =
-			    bus->rxhdr[SDPCM_FRAMETAG_LEN +
-				       SDPCM_NEXTLEN_OFFSET];
-			if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-				brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
-					  bus->nextlen, seq);
-				bus->nextlen = 0;
 			}
 
-			bus->sdcnt.rx_readahead_cnt++;
-
-			/* Handle Flow Control */
-			fcbits = SDPCM_FCMASK_VALUE(
-					&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-
-			if (bus->flowcontrol != fcbits) {
-				if (~bus->flowcontrol & fcbits)
-					bus->sdcnt.fc_xoff++;
-
-				if (bus->flowcontrol & ~fcbits)
-					bus->sdcnt.fc_xon++;
-
-				bus->sdcnt.fc_rcvd++;
-				bus->flowcontrol = fcbits;
-			}
-
-			/* Check and update sequence number */
-			if (rxseq != seq) {
-				brcmf_dbg(INFO, "(nextlen): rx_seq %d, expected %d\n",
-					  seq, rxseq);
-				bus->sdcnt.rx_badseq++;
-				rxseq = seq;
-			}
-
-			/* Check window for sanity */
-			if ((u8) (txmax - bus->tx_seq) > 0x40) {
-				brcmf_dbg(ERROR, "got unlikely tx max %d with tx_seq %d\n",
-					  txmax, bus->tx_seq);
-				txmax = bus->tx_seq + 2;
-			}
-			bus->tx_max = txmax;
-
-			brcmf_dbg_hex_dump(BRCMF_BYTES_ON() && BRCMF_DATA_ON(),
-					   rxbuf, len, "Rx Data:\n");
-			brcmf_dbg_hex_dump(!(BRCMF_BYTES_ON() &&
-					     BRCMF_DATA_ON()) &&
-					   BRCMF_HDRS_ON(),
+			brcmf_dbg_hex_dump(BRCMF_BYTES_ON() || BRCMF_HDRS_ON(),
 					   bus->rxhdr, SDPCM_HDRLEN,
 					   "RxHdr:\n");
 
-			if (chan == SDPCM_CONTROL_CHANNEL) {
-				brcmf_dbg(ERROR, "(nextlen): readahead on control packet %d?\n",
-					  seq);
-				/* Force retry w/normal header read */
-				bus->nextlen = 0;
-				brcmf_sdbrcm_rxfail(bus, false, true);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
+			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, rd)) {
+				if (!bus->rxpending)
+					break;
+				else
+					continue;
 			}
 
-			/* Validate data offset */
-			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-				brcmf_dbg(ERROR, "(nextlen): bad data offset %d: HW len %d min %d\n",
-					  doff, len, SDPCM_HDRLEN);
-				brcmf_sdbrcm_rxfail(bus, false, false);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
+			if (rd->channel == SDPCM_CONTROL_CHANNEL) {
+				brcmf_sdbrcm_read_control(bus, bus->rxhdr,
+							  rd->len,
+							  rd->dat_offset);
+				/* prepare the descriptor for the next read */
+				rd->len = rd->len_nxtfrm << 4;
+				rd->len_nxtfrm = 0;
+				/* treat all packet as event if we don't know */
+				rd->channel = SDPCM_EVENT_CHANNEL;
 				continue;
 			}
-
-			/* All done with this one -- now deliver the packet */
-			goto deliver;
-		}
-
-		/* Read frame header (hardware and software) */
-		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
-					      SDIO_FUNC_2, F2SYNC, bus->rxhdr,
-					      BRCMF_FIRSTREAD);
-		bus->sdcnt.f2rxhdrs++;
-
-		if (sdret < 0) {
-			brcmf_dbg(ERROR, "RXHEADER FAILED: %d\n", sdret);
-			bus->sdcnt.rx_hdrfail++;
-			brcmf_sdbrcm_rxfail(bus, true, true);
-			continue;
-		}
-		brcmf_dbg_hex_dump(BRCMF_BYTES_ON() || BRCMF_HDRS_ON(),
-				   bus->rxhdr, SDPCM_HDRLEN, "RxHdr:\n");
-
-
-		/* Extract hardware header fields */
-		len = get_unaligned_le16(bus->rxhdr);
-		check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
-
-		/* All zeros means no more frames */
-		if (!(len | check)) {
-			*finished = true;
-			break;
-		}
-
-		/* Validate check bytes */
-		if ((u16) ~(len ^ check)) {
-			brcmf_dbg(ERROR, "HW hdr err: len/check 0x%04x/0x%04x\n",
-				  len, check);
-			bus->sdcnt.rx_badhdr++;
-			brcmf_sdbrcm_rxfail(bus, false, false);
-			continue;
-		}
-
-		/* Validate frame length */
-		if (len < SDPCM_HDRLEN) {
-			brcmf_dbg(ERROR, "HW hdr length invalid: %d\n", len);
-			continue;
-		}
-
-		/* Extract software header fields */
-		chan = SDPCM_PACKET_CHANNEL(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-		seq = SDPCM_PACKET_SEQUENCE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-		doff = SDPCM_DOFFSET_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-		txmax = SDPCM_WINDOW_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-
-		/* Validate data offset */
-		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-			brcmf_dbg(ERROR, "Bad data offset %d: HW len %d, min %d seq %d\n",
-				  doff, len, SDPCM_HDRLEN, seq);
-			bus->sdcnt.rx_badhdr++;
-			brcmf_sdbrcm_rxfail(bus, false, false);
-			continue;
-		}
-
-		/* Save the readahead length if there is one */
-		bus->nextlen =
-		    bus->rxhdr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
-		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
-				  bus->nextlen, seq);
-			bus->nextlen = 0;
-		}
-
-		/* Handle Flow Control */
-		fcbits = SDPCM_FCMASK_VALUE(&bus->rxhdr[SDPCM_FRAMETAG_LEN]);
-
-		if (bus->flowcontrol != fcbits) {
-			if (~bus->flowcontrol & fcbits)
-				bus->sdcnt.fc_xoff++;
-
-			if (bus->flowcontrol & ~fcbits)
-				bus->sdcnt.fc_xon++;
-
-			bus->sdcnt.fc_rcvd++;
-			bus->flowcontrol = fcbits;
-		}
-
-		/* Check and update sequence number */
-		if (rxseq != seq) {
-			brcmf_dbg(INFO, "rx_seq %d, expected %d\n", seq, rxseq);
-			bus->sdcnt.rx_badseq++;
-			rxseq = seq;
+			rd->len_left = rd->len > BRCMF_FIRSTREAD ?
+				       rd->len - BRCMF_FIRSTREAD : 0;
+			head_read = BRCMF_FIRSTREAD;
 		}
 
-		/* Check window for sanity */
-		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
-				  txmax, bus->tx_seq);
-			txmax = bus->tx_seq + 2;
-		}
-		bus->tx_max = txmax;
+		brcmf_pad(bus, &pad, &rd->len_left);
 
-		/* Call a separate function for control frames */
-		if (chan == SDPCM_CONTROL_CHANNEL) {
-			brcmf_sdbrcm_read_control(bus, bus->rxhdr, len, doff);
-			continue;
-		}
-
-		/* precondition: chan is either SDPCM_DATA_CHANNEL,
-		   SDPCM_EVENT_CHANNEL, SDPCM_TEST_CHANNEL or
-		   SDPCM_GLOM_CHANNEL */
-
-		/* Length to read */
-		rdlen = (len > BRCMF_FIRSTREAD) ? (len - BRCMF_FIRSTREAD) : 0;
-
-		/* May pad read to blocksize for efficiency */
-		if (bus->roundup && bus->blocksize &&
-			(rdlen > bus->blocksize)) {
-			pad = bus->blocksize - (rdlen % bus->blocksize);
-			if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
-			    ((rdlen + pad + BRCMF_FIRSTREAD) < MAX_RX_DATASZ))
-				rdlen += pad;
-		} else if (rdlen % BRCMF_SDALIGN) {
-			rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
-		}
-
-		/* Satisfy length-alignment requirements */
-		if (rdlen & (ALIGNMENT - 1))
-			rdlen = roundup(rdlen, ALIGNMENT);
-
-		if ((rdlen + BRCMF_FIRSTREAD) > MAX_RX_DATASZ) {
-			/* Too long -- skip this frame */
-			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
-				  len, rdlen);
-			bus->sdiodev->bus_if->dstats.rx_errors++;
-			bus->sdcnt.rx_toolong++;
-			brcmf_sdbrcm_rxfail(bus, false, false);
-			continue;
-		}
-
-		pkt = brcmu_pkt_buf_get_skb(rdlen +
-					    BRCMF_FIRSTREAD + BRCMF_SDALIGN);
+		pkt = brcmu_pkt_buf_get_skb(rd->len_left + head_read +
+					    BRCMF_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
-				  rdlen, chan);
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed\n");
 			bus->sdiodev->bus_if->dstats.rx_dropped++;
-			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
+			brcmf_sdbrcm_rxfail(bus, false,
+					    RETRYCHAN(rd->channel));
 			continue;
 		}
+		skb_pull(pkt, head_read);
+		pkt_align(pkt, rd->len_left, BRCMF_SDALIGN);
 
-		/* Leave room for what we already read, and align remainder */
-		skb_pull(pkt, BRCMF_FIRSTREAD);
-		pkt_align(pkt, rdlen, BRCMF_SDALIGN);
-
-		/* Read the remaining frame data */
 		sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, pkt);
 		bus->sdcnt.f2rxdata++;
 
 		if (sdret < 0) {
-			brcmf_dbg(ERROR, "read %d %s bytes failed: %d\n", rdlen,
-				  ((chan == SDPCM_EVENT_CHANNEL) ? "event"
-				   : ((chan == SDPCM_DATA_CHANNEL) ? "data"
-				      : "test")), sdret);
+			brcmf_dbg(ERROR, "read %d bytes from channel %d failed: %d\n",
+				  rd->len, rd->channel, sdret);
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->sdiodev->bus_if->dstats.rx_errors++;
-			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
+			brcmf_sdbrcm_rxfail(bus, true,
+					    RETRYCHAN(rd->channel));
 			continue;
 		}
 
-		/* Copy the already-read portion */
-		skb_push(pkt, BRCMF_FIRSTREAD);
-		memcpy(pkt->data, bus->rxhdr, BRCMF_FIRSTREAD);
+		if (head_read) {
+			skb_push(pkt, head_read);
+			memcpy(pkt->data, bus->rxhdr, head_read);
+			head_read = 0;
+		} else {
+			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
+			rd_new.seq_num = rd->seq_num;
+			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, &rd_new)) {
+				rd->len = 0;
+				brcmu_pkt_buf_free_skb(pkt);
+			}
+			bus->sdcnt.rx_readahead_cnt++;
+			if (rd->len != roundup(rd_new.len, 16)) {
+				brcmf_dbg(ERROR, "frame length mismatch:read %d, should be %d\n",
+					  rd->len,
+					  roundup(rd_new.len, 16) >> 4);
+				rd->len = 0;
+				brcmf_sdbrcm_rxfail(bus, true, true);
+				brcmu_pkt_buf_free_skb(pkt);
+				continue;
+			}
+			rd->len_nxtfrm = rd_new.len_nxtfrm;
+			rd->channel = rd_new.channel;
+			rd->dat_offset = rd_new.dat_offset;
+
+			brcmf_dbg_hex_dump(!(BRCMF_BYTES_ON() &&
+					     BRCMF_DATA_ON()) &&
+					   BRCMF_HDRS_ON(),
+					   bus->rxhdr, SDPCM_HDRLEN,
+					   "RxHdr:\n");
+
+			if (rd_new.channel == SDPCM_CONTROL_CHANNEL) {
+				brcmf_dbg(ERROR, "readahead on control packet %d?\n",
+					  rd_new.seq_num);
+				/* Force retry w/normal header read */
+				rd->len = 0;
+				brcmf_sdbrcm_rxfail(bus, false, true);
+				brcmu_pkt_buf_free_skb(pkt);
+				continue;
+			}
+		}
 
 		brcmf_dbg_hex_dump(BRCMF_BYTES_ON() && BRCMF_DATA_ON(),
-				   pkt->data, len, "Rx Data:\n");
+				   pkt->data, rd->len, "Rx Data:\n");
 
-deliver:
 		/* Save superframe descriptor and allocate packet frame */
-		if (chan == SDPCM_GLOM_CHANNEL) {
+		if (rd->channel == SDPCM_GLOM_CHANNEL) {
 			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
 				brcmf_dbg(GLOM, "glom descriptor, %d bytes:\n",
-					  len);
+					  rd->len);
 				brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
-						   pkt->data, len,
+						   pkt->data, rd->len,
 						   "Glom Data:\n");
-				__skb_trim(pkt, len);
+				__skb_trim(pkt, rd->len);
 				skb_pull(pkt, SDPCM_HDRLEN);
 				bus->glomd = pkt;
 			} else {
@@ -1919,12 +1755,23 @@ deliver:
 					  "descriptor!\n", __func__);
 				brcmf_sdbrcm_rxfail(bus, false, false);
 			}
+			/* prepare the descriptor for the next read */
+			rd->len = rd->len_nxtfrm << 4;
+			rd->len_nxtfrm = 0;
+			/* treat all packet as event if we don't know */
+			rd->channel = SDPCM_EVENT_CHANNEL;
 			continue;
 		}
 
 		/* Fill in packet len and prio, deliver upward */
-		__skb_trim(pkt, len);
-		skb_pull(pkt, doff);
+		__skb_trim(pkt, rd->len);
+		skb_pull(pkt, rd->dat_offset);
+
+		/* prepare the descriptor for the next read */
+		rd->len = rd->len_nxtfrm << 4;
+		rd->len_nxtfrm = 0;
+		/* treat all packet as event if we don't know */
+		rd->channel = SDPCM_EVENT_CHANNEL;
 
 		if (pkt->len == 0) {
 			brcmu_pkt_buf_free_skb(pkt);
@@ -1942,17 +1789,17 @@ deliver:
 		brcmf_rx_packet(bus->sdiodev->dev, ifidx, pkt);
 		down(&bus->sdsem);
 	}
+
 	rxcount = maxframes - rxleft;
 	/* Message if we hit the limit */
 	if (!rxleft)
-		brcmf_dbg(DATA, "hit rx limit of %d frames\n",
-			  maxframes);
+		brcmf_dbg(DATA, "hit rx limit of %d frames\n", maxframes);
 	else
 		brcmf_dbg(DATA, "processed %d frames\n", rxcount);
 	/* Back off rxseq if awaiting rtx, update rx_seq */
 	if (bus->rxskip)
-		rxseq--;
-	bus->rx_seq = rxseq;
+		rd->seq_num--;
+	bus->rx_seq = rd->seq_num;
 
 	return rxcount;
 }
@@ -2313,7 +2160,6 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	uint rxlimit = bus->rxbound;	/* Rx frames to read before resched */
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
-	bool rxdone = true;	/* Flag for no more read data */
 	int err = 0, n;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2431,8 +2277,8 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 
 	/* On frame indication, read available frames */
 	if (PKT_AVAILABLE() && bus->clkstate == CLK_AVAIL) {
-		framecnt = brcmf_sdbrcm_readframes(bus, rxlimit, &rxdone);
-		if (rxdone || bus->rxskip)
+		framecnt = brcmf_sdio_readframes(bus, rxlimit);
+		if (!bus->rxpending)
 			intstatus &= ~I_HMB_FRAME_IND;
 		rxlimit -= min(framecnt, rxlimit);
 	}
@@ -2489,7 +2335,8 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	else if ((bus->clkstate == CLK_AVAIL) && !atomic_read(&bus->fcstate) &&
 		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
 		 && data_ok(bus)) {
-		framecnt = rxdone ? txlimit : min(txlimit, bus->txminmax);
+		framecnt = bus->rxpending ? min(txlimit, bus->txminmax) :
+					    txlimit;
 		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
 		txlimit -= framecnt;
 	}
@@ -4056,8 +3903,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->rxbound = BRCMF_RXBOUND;
 	bus->txminmax = BRCMF_TXMINMAX;
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
-	bus->usebufpool = false;	/* Use bufpool if allocated,
-					 else use locally malloced rxbuf */
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
-- 
1.7.9.5


