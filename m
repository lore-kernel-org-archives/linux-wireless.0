Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1804 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab2JVRgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:41 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/14] brcmfmac: streamline header parse code of sdio
 glom read
Date: Mon, 22 Oct 2012 10:36:24 -0700
Message-ID: <1350927387-25608-12-git-send-email-frankyl@broadcom.com> (sfid-20121022_193650_040741_FAF42200)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use brcmf_sdio_hdparser to handle header of super frame and sub
frame in glomming frame read.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  174 +++++++-------------
 1 files changed, 62 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3564686..415f2be 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -614,6 +614,12 @@ static const uint max_roundup = 512;
 
 #define ALIGNMENT  4
 
+enum brcmf_sdio_frmtype {
+	BRCMF_SDIO_FT_NORMAL,
+	BRCMF_SDIO_FT_SUPER,
+	BRCMF_SDIO_FT_SUB,
+};
+
 static void pkt_align(struct sk_buff *p, int len, int align)
 {
 	uint datalign;
@@ -1032,7 +1038,8 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
 }
 
 static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
-				struct brcmf_sdio_read *rd)
+				struct brcmf_sdio_read *rd,
+				enum brcmf_sdio_frmtype type)
 {
 	u16 len, checksum;
 	u8 rx_seq, fc, tx_seq_max;
@@ -1059,6 +1066,15 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		brcmf_dbg(ERROR, "HW header length error\n");
 		return false;
 	}
+	if (type == BRCMF_SDIO_FT_SUPER &&
+	    (roundup(len, bus->blocksize) != rd->len)) {
+		brcmf_dbg(ERROR, "HW superframe header length error\n");
+		return false;
+	}
+	if (type == BRCMF_SDIO_FT_SUB && len > rd->len) {
+		brcmf_dbg(ERROR, "HW subframe header length error\n");
+		return false;
+	}
 	rd->len = len;
 
 	/*
@@ -1071,9 +1087,16 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	 * Byte 5: Maximum Sequence number allow for Tx
 	 * Byte 6~7: Reserved
 	 */
+	if (type == BRCMF_SDIO_FT_SUPER &&
+	    SDPCM_GLOMDESC(&header[SDPCM_FRAMETAG_LEN])) {
+		brcmf_dbg(ERROR, "Glom descriptor found in superframe head\n");
+		rd->len = 0;
+		return false;
+	}
 	rx_seq = SDPCM_PACKET_SEQUENCE(&header[SDPCM_FRAMETAG_LEN]);
 	rd->channel = SDPCM_PACKET_CHANNEL(&header[SDPCM_FRAMETAG_LEN]);
-	if (len > MAX_RX_DATASZ && rd->channel != SDPCM_CONTROL_CHANNEL) {
+	if (len > MAX_RX_DATASZ && rd->channel != SDPCM_CONTROL_CHANNEL &&
+	    type != BRCMF_SDIO_FT_SUPER) {
 		brcmf_dbg(ERROR, "HW header length too long\n");
 		bus->sdiodev->bus_if->dstats.rx_errors++;
 		bus->sdcnt.rx_toolong++;
@@ -1081,6 +1104,17 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		rd->len = 0;
 		return false;
 	}
+	if (type == BRCMF_SDIO_FT_SUPER && rd->channel != SDPCM_GLOM_CHANNEL) {
+		brcmf_dbg(ERROR, "Wrong channel for superframe\n");
+		rd->len = 0;
+		return false;
+	}
+	if (type == BRCMF_SDIO_FT_SUB && rd->channel != SDPCM_DATA_CHANNEL &&
+	    rd->channel != SDPCM_EVENT_CHANNEL) {
+		brcmf_dbg(ERROR, "Wrong channel for subframe\n");
+		rd->len = 0;
+		return false;
+	}
 	rd->dat_offset = SDPCM_DOFFSET_VALUE(&header[SDPCM_FRAMETAG_LEN]);
 	if (rd->dat_offset < SDPCM_HDRLEN || rd->dat_offset > rd->len) {
 		brcmf_dbg(ERROR, "seq %d: bad data offset\n", rx_seq);
@@ -1095,6 +1129,9 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		bus->sdcnt.rx_badseq++;
 		rd->seq_num = rx_seq;
 	}
+	/* no need to check the reset for subframe */
+	if (type == BRCMF_SDIO_FT_SUB)
+		return true;
 	rd->len_nxtfrm = header[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 	if (rd->len_nxtfrm << 4 > MAX_RX_DATASZ) {
 		/* only warm for NON glom packet */
@@ -1126,16 +1163,16 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
 
-	u16 sublen, check;
+	u16 sublen;
 	struct sk_buff *pfirst, *pnext;
 
 	int errcode;
-	u8 chan, seq, doff, sfdoff;
-	u8 txmax;
+	u8 doff, sfdoff;
 
 	int ifidx = 0;
 	bool usechain = bus->use_rxchain;
-	u16 next_len;
+
+	struct brcmf_sdio_read rd_new;
 
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
@@ -1279,68 +1316,15 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				   pfirst->data, min_t(int, pfirst->len, 48),
 				   "SUPERFRAME:\n");
 
-		/* Validate the superframe header */
-		dptr = (u8 *) (pfirst->data);
-		sublen = get_unaligned_le16(dptr);
-		check = get_unaligned_le16(dptr + sizeof(u16));
-
-		chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
-		seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
-		next_len = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
-		if ((next_len << 4) > MAX_RX_DATASZ) {
-			brcmf_dbg(INFO, "nextlen too large (%d) seq %d\n",
-				  next_len, seq);
-			next_len = 0;
-		}
-		bus->cur_read.len = next_len << 4;
-		doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
-		txmax = SDPCM_WINDOW_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
-
-		errcode = 0;
-		if ((u16)~(sublen ^ check)) {
-			brcmf_dbg(ERROR, "(superframe): HW hdr error: len/check 0x%04x/0x%04x\n",
-				  sublen, check);
-			errcode = -1;
-		} else if (roundup(sublen, bus->blocksize) != dlen) {
-			brcmf_dbg(ERROR, "(superframe): len 0x%04x, rounded 0x%04x, expect 0x%04x\n",
-				  sublen, roundup(sublen, bus->blocksize),
-				  dlen);
-			errcode = -1;
-		} else if (SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]) !=
-			   SDPCM_GLOM_CHANNEL) {
-			brcmf_dbg(ERROR, "(superframe): bad channel %d\n",
-				  SDPCM_PACKET_CHANNEL(
-					  &dptr[SDPCM_FRAMETAG_LEN]));
-			errcode = -1;
-		} else if (SDPCM_GLOMDESC(&dptr[SDPCM_FRAMETAG_LEN])) {
-			brcmf_dbg(ERROR, "(superframe): got 2nd descriptor?\n");
-			errcode = -1;
-		} else if ((doff < SDPCM_HDRLEN) ||
-			   (doff > (pfirst->len - SDPCM_HDRLEN))) {
-			brcmf_dbg(ERROR, "(superframe): Bad data offset %d: HW %d pkt %d min %d\n",
-				  doff, sublen, pfirst->len, SDPCM_HDRLEN);
-			errcode = -1;
-		}
-
-		/* Check sequence number of superframe SW header */
-		if (rxseq != seq) {
-			brcmf_dbg(INFO, "(superframe) rx_seq %d, expected %d\n",
-				  seq, rxseq);
-			bus->sdcnt.rx_badseq++;
-			rxseq = seq;
-		}
-
-		/* Check window for sanity */
-		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
-				  txmax, bus->tx_seq);
-			txmax = bus->tx_seq + 2;
-		}
-		bus->tx_max = txmax;
+		rd_new.seq_num = rxseq;
+		rd_new.len = dlen;
+		errcode = -!brcmf_sdio_hdparser(bus, pfirst->data, &rd_new,
+						   BRCMF_SDIO_FT_SUPER);
+		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
 		/* Remove superframe header, remember offset */
-		skb_pull(pfirst, doff);
-		sfdoff = doff;
+		skb_pull(pfirst, rd_new.dat_offset);
+		sfdoff = rd_new.dat_offset;
 		num = 0;
 
 		/* Validate all the subframe headers */
@@ -1349,34 +1333,14 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			if (errcode)
 				break;
 
-			dptr = (u8 *) (pnext->data);
-			dlen = (u16) (pnext->len);
-			sublen = get_unaligned_le16(dptr);
-			check = get_unaligned_le16(dptr + sizeof(u16));
-			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
-			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
+			rd_new.len = pnext->len;
+			rd_new.seq_num = rxseq++;
+			errcode = -!brcmf_sdio_hdparser(bus, pnext->data,
+							   &rd_new,
+							   BRCMF_SDIO_FT_SUB);
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
-					   dptr, 32, "subframe:\n");
+					   pnext->data, 32, "subframe:\n");
 
-			if ((u16)~(sublen ^ check)) {
-				brcmf_dbg(ERROR, "(subframe %d): HW hdr error: len/check 0x%04x/0x%04x\n",
-					  num, sublen, check);
-				errcode = -1;
-			} else if ((sublen > dlen) || (sublen < SDPCM_HDRLEN)) {
-				brcmf_dbg(ERROR, "(subframe %d): length mismatch: len 0x%04x, expect 0x%04x\n",
-					  num, sublen, dlen);
-				errcode = -1;
-			} else if ((chan != SDPCM_DATA_CHANNEL) &&
-				   (chan != SDPCM_EVENT_CHANNEL)) {
-				brcmf_dbg(ERROR, "(subframe %d): bad channel %d\n",
-					  num, chan);
-				errcode = -1;
-			} else if ((doff < SDPCM_HDRLEN) || (doff > sublen)) {
-				brcmf_dbg(ERROR, "(subframe %d): Bad data offset %d: HW %d min %d\n",
-					  num, doff, sublen, SDPCM_HDRLEN);
-				errcode = -1;
-			}
-			/* increase the subframe count */
 			num++;
 		}
 
@@ -1402,27 +1366,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
 			dptr = (u8 *) (pfirst->data);
 			sublen = get_unaligned_le16(dptr);
-			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
-			seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
-			brcmf_dbg(GLOM, "Get subframe %d, %p(%p/%d), sublen %d chan %d seq %d\n",
-				  num, pfirst, pfirst->data,
-				  pfirst->len, sublen, chan, seq);
-
-			/* precondition: chan == SDPCM_DATA_CHANNEL ||
-					 chan == SDPCM_EVENT_CHANNEL */
-
-			if (rxseq != seq) {
-				brcmf_dbg(GLOM, "rx_seq %d, expected %d\n",
-					  seq, rxseq);
-				bus->sdcnt.rx_badseq++;
-				rxseq = seq;
-			}
-			rxseq++;
-
 			brcmf_dbg_hex_dump(BRCMF_BYTES_ON() && BRCMF_DATA_ON(),
-					   dptr, dlen, "Rx Subframe Data:\n");
+					   dptr, pfirst->len,
+					   "Rx Subframe Data:\n");
 
 			__skb_trim(pfirst, sublen);
 			skb_pull(pfirst, doff);
@@ -1642,7 +1590,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					   bus->rxhdr, SDPCM_HDRLEN,
 					   "RxHdr:\n");
 
-			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, rd)) {
+			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, rd,
+						 BRCMF_SDIO_FT_NORMAL)) {
 				if (!bus->rxpending)
 					break;
 				else
@@ -1701,7 +1650,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		} else {
 			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
 			rd_new.seq_num = rd->seq_num;
-			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, &rd_new)) {
+			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, &rd_new,
+						 BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
 				brcmu_pkt_buf_free_skb(pkt);
 			}
-- 
1.7.6


