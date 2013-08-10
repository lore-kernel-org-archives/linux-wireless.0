Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2744 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968550Ab3HJK14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/12] brcmfmac: streamline sdio bus header code
Date: Sat, 10 Aug 2013 12:27:28 +0200
Message-ID: <1376130450-29746-11-git-send-email-arend@broadcom.com> (sfid-20130810_122829_007068_B774181E)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Streamlining sdio bus specific header related code as preparation for host
tx glomming

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 243 ++++++++++-----------
 1 file changed, 120 insertions(+), 123 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2563875..02ab5cd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -201,13 +201,6 @@ struct rte_console {
 #define SFC_CRC4WOOS	(1 << 2)	/* CRC error for write out of sync */
 #define SFC_ABORTALL	(1 << 3)	/* Abort all in-progress frames */
 
-/* HW frame tag */
-#define SDPCM_FRAMETAG_LEN	4	/* 2 bytes len, 2 bytes check val */
-
-/* Total length of frame header for dongle protocol */
-#define SDPCM_HDRLEN	(SDPCM_FRAMETAG_LEN + SDPCM_SWHEADER_LEN)
-#define SDPCM_RESERVE	(SDPCM_HDRLEN + BRCMF_SDALIGN)
-
 /*
  * Software allocation of To SB Mailbox resources
  */
@@ -250,38 +243,6 @@ struct rte_console {
 /* Current protocol version */
 #define SDPCM_PROT_VERSION	4
 
-/* SW frame header */
-#define SDPCM_PACKET_SEQUENCE(p)	(((u8 *)p)[0] & 0xff)
-
-#define SDPCM_CHANNEL_MASK		0x00000f00
-#define SDPCM_CHANNEL_SHIFT		8
-#define SDPCM_PACKET_CHANNEL(p)		(((u8 *)p)[1] & 0x0f)
-
-#define SDPCM_NEXTLEN_OFFSET		2
-
-/* Data Offset from SOF (HW Tag, SW Tag, Pad) */
-#define SDPCM_DOFFSET_OFFSET		3	/* Data Offset */
-#define SDPCM_DOFFSET_VALUE(p)		(((u8 *)p)[SDPCM_DOFFSET_OFFSET] & 0xff)
-#define SDPCM_DOFFSET_MASK		0xff000000
-#define SDPCM_DOFFSET_SHIFT		24
-#define SDPCM_FCMASK_OFFSET		4	/* Flow control */
-#define SDPCM_FCMASK_VALUE(p)		(((u8 *)p)[SDPCM_FCMASK_OFFSET] & 0xff)
-#define SDPCM_WINDOW_OFFSET		5	/* Credit based fc */
-#define SDPCM_WINDOW_VALUE(p)		(((u8 *)p)[SDPCM_WINDOW_OFFSET] & 0xff)
-
-#define SDPCM_SWHEADER_LEN	8	/* SW header is 64 bits */
-
-/* logical channel numbers */
-#define SDPCM_CONTROL_CHANNEL	0	/* Control channel Id */
-#define SDPCM_EVENT_CHANNEL	1	/* Asyc Event Indication Channel Id */
-#define SDPCM_DATA_CHANNEL	2	/* Data Xmit/Recv Channel Id */
-#define SDPCM_GLOM_CHANNEL	3	/* For coalesced packets */
-#define SDPCM_TEST_CHANNEL	15	/* Reserved for test/debug packets */
-
-#define SDPCM_SEQUENCE_WRAP	256	/* wrap-around val for 8bit frame seq */
-
-#define SDPCM_GLOMDESC(p)	(((u8 *)p)[1] & 0x80)
-
 /*
  * Shared structure between dongle and the host.
  * The structure contains pointers to trap or assert information.
@@ -396,8 +357,8 @@ struct sdpcm_shared_le {
 	__le32 brpt_addr;
 };
 
-/* SDIO read frame info */
-struct brcmf_sdio_read {
+/* dongle SDIO bus specific header info */
+struct brcmf_sdio_hdrinfo {
 	u8 seq_num;
 	u8 channel;
 	u16 len;
@@ -431,7 +392,7 @@ struct brcmf_sdio {
 	u8 hdrbuf[MAX_HDR_READ + BRCMF_SDALIGN];
 	u8 *rxhdr;		/* Header of current rx frame (in hdrbuf) */
 	u8 rx_seq;		/* Receive sequence number (expected) */
-	struct brcmf_sdio_read cur_read;
+	struct brcmf_sdio_hdrinfo cur_read;
 				/* info of current read frame */
 	bool rxskip;		/* Skip receive (awaiting NAK ACK) */
 	bool rxpending;		/* Data frame pending in dongle */
@@ -1042,18 +1003,64 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
 	}
 }
 
-static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
-			       struct brcmf_sdio_read *rd,
-			       enum brcmf_sdio_frmtype type)
+/**
+ * brcmfmac sdio bus specific header
+ * This is the lowest layer header wrapped on the packets transmitted between
+ * host and WiFi dongle which contains information needed for SDIO core and
+ * firmware
+ *
+ * It consists of 2 parts: hw header and software header
+ * hardware header (frame tag) - 4 bytes
+ * Byte 0~1: Frame length
+ * Byte 2~3: Checksum, bit-wise inverse of frame length
+ * software header - 8 bytes
+ * Byte 0: Rx/Tx sequence number
+ * Byte 1: 4 MSB Channel number, 4 LSB arbitrary flag
+ * Byte 2: Length of next data frame, reserved for Tx
+ * Byte 3: Data offset
+ * Byte 4: Flow control bits, reserved for Tx
+ * Byte 5: Maximum Sequence number allowed by firmware for Tx, N/A for Tx packet
+ * Byte 6~7: Reserved
+ */
+#define SDPCM_HWHDR_LEN			4
+#define SDPCM_SWHDR_LEN			8
+#define SDPCM_HDRLEN			(SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN)
+#define SDPCM_RESERVE			(SDPCM_HDRLEN + BRCMF_SDALIGN)
+/* software header */
+#define SDPCM_SEQ_MASK			0x000000ff
+#define SDPCM_SEQ_WRAP			256
+#define SDPCM_CHANNEL_MASK		0x00000f00
+#define SDPCM_CHANNEL_SHIFT		8
+#define SDPCM_CONTROL_CHANNEL		0	/* Control */
+#define SDPCM_EVENT_CHANNEL		1	/* Asyc Event Indication */
+#define SDPCM_DATA_CHANNEL		2	/* Data Xmit/Recv */
+#define SDPCM_GLOM_CHANNEL		3	/* Coalesced packets */
+#define SDPCM_TEST_CHANNEL		15	/* Test/debug packets */
+#define SDPCM_GLOMDESC(p)		(((u8 *)p)[1] & 0x80)
+#define SDPCM_NEXTLEN_MASK		0x00ff0000
+#define SDPCM_NEXTLEN_SHIFT		16
+#define SDPCM_DOFFSET_MASK		0xff000000
+#define SDPCM_DOFFSET_SHIFT		24
+#define SDPCM_FCMASK_MASK		0x000000ff
+#define SDPCM_WINDOW_MASK		0x0000ff00
+#define SDPCM_WINDOW_SHIFT		8
+
+static inline u8 brcmf_sdio_getdatoffset(u8 *swheader)
+{
+	u32 hdrvalue;
+	hdrvalue = *(u32 *)swheader;
+	return (u8)((hdrvalue & SDPCM_DOFFSET_MASK) >> SDPCM_DOFFSET_SHIFT);
+}
+
+static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
+			      struct brcmf_sdio_hdrinfo *rd,
+			      enum brcmf_sdio_frmtype type)
 {
 	u16 len, checksum;
 	u8 rx_seq, fc, tx_seq_max;
+	u32 swheader;
 
-	/*
-	 * 4 bytes hardware header (frame tag)
-	 * Byte 0~1: Frame length
-	 * Byte 2~3: Checksum, bit-wise inverse of frame length
-	 */
+	/* hw header */
 	len = get_unaligned_le16(header);
 	checksum = get_unaligned_le16(header + sizeof(u16));
 	/* All zero means no more to read */
@@ -1082,24 +1089,16 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	}
 	rd->len = len;
 
-	/*
-	 * 8 bytes hardware header
-	 * Byte 0: Rx sequence number
-	 * Byte 1: 4 MSB Channel number, 4 LSB arbitrary flag
-	 * Byte 2: Length of next data frame
-	 * Byte 3: Data offset
-	 * Byte 4: Flow control bits
-	 * Byte 5: Maximum Sequence number allow for Tx
-	 * Byte 6~7: Reserved
-	 */
-	if (type == BRCMF_SDIO_FT_SUPER &&
-	    SDPCM_GLOMDESC(&header[SDPCM_FRAMETAG_LEN])) {
+	/* software header */
+	header += SDPCM_HWHDR_LEN;
+	swheader = le32_to_cpu(*(__le32 *)header);
+	if (type == BRCMF_SDIO_FT_SUPER && SDPCM_GLOMDESC(header)) {
 		brcmf_err("Glom descriptor found in superframe head\n");
 		rd->len = 0;
 		return -EINVAL;
 	}
-	rx_seq = SDPCM_PACKET_SEQUENCE(&header[SDPCM_FRAMETAG_LEN]);
-	rd->channel = SDPCM_PACKET_CHANNEL(&header[SDPCM_FRAMETAG_LEN]);
+	rx_seq = (u8)(swheader & SDPCM_SEQ_MASK);
+	rd->channel = (swheader & SDPCM_CHANNEL_MASK) >> SDPCM_CHANNEL_SHIFT;
 	if (len > MAX_RX_DATASZ && rd->channel != SDPCM_CONTROL_CHANNEL &&
 	    type != BRCMF_SDIO_FT_SUPER) {
 		brcmf_err("HW header length too long\n");
@@ -1119,7 +1118,7 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		rd->len = 0;
 		return -EINVAL;
 	}
-	rd->dat_offset = SDPCM_DOFFSET_VALUE(&header[SDPCM_FRAMETAG_LEN]);
+	rd->dat_offset = brcmf_sdio_getdatoffset(header);
 	if (rd->dat_offset < SDPCM_HDRLEN || rd->dat_offset > rd->len) {
 		brcmf_err("seq %d: bad data offset\n", rx_seq);
 		bus->sdcnt.rx_badhdr++;
@@ -1136,14 +1135,15 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	/* no need to check the reset for subframe */
 	if (type == BRCMF_SDIO_FT_SUB)
 		return 0;
-	rd->len_nxtfrm = header[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
+	rd->len_nxtfrm = (swheader & SDPCM_NEXTLEN_MASK) >> SDPCM_NEXTLEN_SHIFT;
 	if (rd->len_nxtfrm << 4 > MAX_RX_DATASZ) {
 		/* only warm for NON glom packet */
 		if (rd->channel != SDPCM_GLOM_CHANNEL)
 			brcmf_err("seq %d: next length error\n", rx_seq);
 		rd->len_nxtfrm = 0;
 	}
-	fc = SDPCM_FCMASK_VALUE(&header[SDPCM_FRAMETAG_LEN]);
+	swheader = le32_to_cpu(*(__le32 *)(header + 4));
+	fc = swheader & SDPCM_FCMASK_MASK;
 	if (bus->flowcontrol != fc) {
 		if (~bus->flowcontrol & fc)
 			bus->sdcnt.fc_xoff++;
@@ -1152,7 +1152,7 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		bus->sdcnt.fc_rcvd++;
 		bus->flowcontrol = fc;
 	}
-	tx_seq_max = SDPCM_WINDOW_VALUE(&header[SDPCM_FRAMETAG_LEN]);
+	tx_seq_max = (swheader & SDPCM_WINDOW_MASK) >> SDPCM_WINDOW_SHIFT;
 	if ((u8)(tx_seq_max - bus->tx_seq) > 0x40) {
 		brcmf_err("seq %d: max tx seq number error\n", rx_seq);
 		tx_seq_max = bus->tx_seq + 2;
@@ -1162,6 +1162,28 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	return 0;
 }
 
+static inline void brcmf_sdio_update_hwhdr(u8 *header, u16 frm_length)
+{
+	*(__le16 *)header = cpu_to_le16(frm_length);
+	*(((__le16 *)header) + 1) = cpu_to_le16(~frm_length);
+}
+
+static void brcmf_sdio_hdpack(struct brcmf_sdio *bus, u8 *header,
+			      struct brcmf_sdio_hdrinfo *hd_info)
+{
+	u32 sw_header;
+
+	brcmf_sdio_update_hwhdr(header, hd_info->len);
+
+	sw_header = bus->tx_seq;
+	sw_header |= (hd_info->channel << SDPCM_CHANNEL_SHIFT) &
+		     SDPCM_CHANNEL_MASK;
+	sw_header |= (hd_info->dat_offset << SDPCM_DOFFSET_SHIFT) &
+		     SDPCM_DOFFSET_MASK;
+	*(((__le32 *)header) + 1) = cpu_to_le32(sw_header);
+	*(((__le32 *)header) + 2) = 0;
+}
+
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
@@ -1173,7 +1195,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	int errcode;
 	u8 doff, sfdoff;
 
-	struct brcmf_sdio_read rd_new;
+	struct brcmf_sdio_hdrinfo rd_new;
 
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
@@ -1309,8 +1331,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
 		sdio_claim_host(bus->sdiodev->func[1]);
-		errcode = brcmf_sdio_hdparser(bus, pfirst->data, &rd_new,
-					      BRCMF_SDIO_FT_SUPER);
+		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
+					     BRCMF_SDIO_FT_SUPER);
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
@@ -1328,8 +1350,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			rd_new.len = pnext->len;
 			rd_new.seq_num = rxseq++;
 			sdio_claim_host(bus->sdiodev->func[1]);
-			errcode = brcmf_sdio_hdparser(bus, pnext->data, &rd_new,
-						      BRCMF_SDIO_FT_SUB);
+			errcode = brcmf_sdio_hdparse(bus, pnext->data, &rd_new,
+						     BRCMF_SDIO_FT_SUB);
 			sdio_release_host(bus->sdiodev->func[1]);
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
 					   pnext->data, 32, "subframe:\n");
@@ -1361,7 +1383,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
 			dptr = (u8 *) (pfirst->data);
 			sublen = get_unaligned_le16(dptr);
-			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
+			doff = brcmf_sdio_getdatoffset(&dptr[SDPCM_HWHDR_LEN]);
 
 			brcmf_dbg_hex_dump(BRCMF_BYTES_ON() && BRCMF_DATA_ON(),
 					   dptr, pfirst->len,
@@ -1539,7 +1561,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 	uint rxleft = 0;	/* Remaining number of frames allowed */
 	int ret;		/* Return code from calls */
 	uint rxcount = 0;	/* Total frames read */
-	struct brcmf_sdio_read *rd = &bus->cur_read, rd_new;
+	struct brcmf_sdio_hdrinfo *rd = &bus->cur_read, rd_new;
 	u8 head_read = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1587,8 +1609,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					   bus->rxhdr, SDPCM_HDRLEN,
 					   "RxHdr:\n");
 
-			if (brcmf_sdio_hdparser(bus, bus->rxhdr, rd,
-						BRCMF_SDIO_FT_NORMAL)) {
+			if (brcmf_sdio_hdparse(bus, bus->rxhdr, rd,
+					       BRCMF_SDIO_FT_NORMAL)) {
 				sdio_release_host(bus->sdiodev->func[1]);
 				if (!bus->rxpending)
 					break;
@@ -1652,8 +1674,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
 			rd_new.seq_num = rd->seq_num;
 			sdio_claim_host(bus->sdiodev->func[1]);
-			if (brcmf_sdio_hdparser(bus, bus->rxhdr, &rd_new,
-						BRCMF_SDIO_FT_NORMAL)) {
+			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
+					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
 				brcmu_pkt_buf_free_skb(pkt);
 			}
@@ -1697,7 +1719,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 
 		/* Save superframe descriptor and allocate packet frame */
 		if (rd->channel == SDPCM_GLOM_CHANNEL) {
-			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
+			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_HWHDR_LEN])) {
 				brcmf_dbg(GLOM, "glom descriptor, %d bytes:\n",
 					  rd->len);
 				brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
@@ -1783,13 +1805,12 @@ static int
 brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		      uint chan)
 {
-	u16 head_pad, tail_pad, tail_chop, pkt_len;
-	u16 head_align, sg_align;
-	u32 sw_header;
+	u16 head_pad, tail_pad, tail_chop, head_align, sg_align;
 	int ntail;
 	struct sk_buff *pkt_next, *pkt_new;
 	u8 *dat_buf;
 	unsigned blksize = bus->sdiodev->func[SDIO_FUNC_2]->cur_blksize;
+	struct brcmf_sdio_hdrinfo hd_info = {0};
 
 	/* SDIO ADMA requires at least 32 bit alignment */
 	head_align = 4;
@@ -1848,34 +1869,18 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	}
 
 	/* Now prep the header */
-	/* 4 bytes hardware header (frame tag)
-	 * Byte 0~1: Frame length
-	 * Byte 2~3: Checksum, bit-wise inverse of frame length
-	 */
 	if (pkt_new)
-		pkt_len = pkt_next->len + tail_chop;
+		hd_info.len = pkt_next->len + tail_chop;
 	else
-		pkt_len = pkt_next->len - tail_pad;
-	*(__le16 *)dat_buf = cpu_to_le16(pkt_len);
-	*(((__le16 *)dat_buf) + 1) = cpu_to_le16(~pkt_len);
-	/* 8 bytes software header
-	 * Byte 0: Tx sequence number
-	 * Byte 1: 4 MSB Channel number
-	 * Byte 2: Reserved
-	 * Byte 3: Data offset
-	 * Byte 4~7: Reserved
-	 */
-	sw_header = bus->tx_seq;
-	sw_header |= ((chan << SDPCM_CHANNEL_SHIFT) & SDPCM_CHANNEL_MASK);
-	sw_header |= ((head_pad + SDPCM_HDRLEN) << SDPCM_DOFFSET_SHIFT) &
-		     SDPCM_DOFFSET_MASK;
-	*(((__le32 *)dat_buf) + 1) = cpu_to_le32(sw_header);
-	*(((__le32 *)dat_buf) + 2) = 0;
+		hd_info.len = pkt_next->len - tail_pad;
+	hd_info.channel = chan;
+	hd_info.dat_offset = head_pad + SDPCM_HDRLEN;
+	brcmf_sdio_hdpack(bus, dat_buf, &hd_info);
 
 	if (BRCMF_BYTES_ON() &&
 	    ((BRCMF_CTL_ON() && chan == SDPCM_CONTROL_CHANNEL) ||
 	     (BRCMF_DATA_ON() && chan != SDPCM_CONTROL_CHANNEL)))
-		brcmf_dbg_hex_dump(true, pkt_next, pkt_len, "Tx Frame:\n");
+		brcmf_dbg_hex_dump(true, pkt_next, hd_info.len, "Tx Frame:\n");
 	else if (BRCMF_HDRS_ON())
 		brcmf_dbg_hex_dump(true, pkt_next, head_pad + SDPCM_HDRLEN,
 				   "Tx Header:\n");
@@ -1913,7 +1918,7 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
 			__skb_unlink(pkt_next, pktq);
 			brcmu_pkt_buf_free_skb(pkt_next);
 		} else {
-			hdr = pkt_next->data + SDPCM_FRAMETAG_LEN;
+			hdr = pkt_next->data + SDPCM_HWHDR_LEN;
 			dat_offset = le32_to_cpu(*(__le32 *)hdr);
 			dat_offset = (dat_offset & SDPCM_DOFFSET_MASK) >>
 				     SDPCM_DOFFSET_SHIFT;
@@ -1969,7 +1974,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 	}
 	sdio_release_host(bus->sdiodev->func[1]);
 	if (ret == 0)
-		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
+		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
 
 done:
 	brcmf_sdio_txpkt_postp(bus, &localq);
@@ -2325,7 +2330,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			}
 
 		} else {
-			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
+			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
 		}
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->ctrl_frame_stat = false;
@@ -2540,7 +2545,7 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 		return ret;
 	}
 
-	bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
+	bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
 
 	return ret;
 }
@@ -2550,13 +2555,13 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
 	u16 len;
-	u32 swheader;
 	uint retries = 0;
 	u8 doff = 0;
 	int ret = -1;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_sdio_hdrinfo hd_info = {0};
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2595,18 +2600,10 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	brcmf_sdbrcm_bus_sleep(bus, false, false);
 	sdio_release_host(bus->sdiodev->func[1]);
 
-	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
-	*(__le16 *) frame = cpu_to_le16((u16) msglen);
-	*(((__le16 *) frame) + 1) = cpu_to_le16(~msglen);
-
-	/* Software tag: channel, sequence number, data offset */
-	swheader =
-	    ((SDPCM_CONTROL_CHANNEL << SDPCM_CHANNEL_SHIFT) &
-	     SDPCM_CHANNEL_MASK)
-	    | bus->tx_seq | ((doff << SDPCM_DOFFSET_SHIFT) &
-			     SDPCM_DOFFSET_MASK);
-	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
-	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
+	hd_info.len = (u16)msglen;
+	hd_info.channel = SDPCM_CONTROL_CHANNEL;
+	hd_info.dat_offset = doff;
+	brcmf_sdio_hdpack(bus, frame, &hd_info);
 
 	if (!data_ok(bus)) {
 		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
@@ -3856,7 +3853,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->txbound = BRCMF_TXBOUND;
 	bus->rxbound = BRCMF_RXBOUND;
 	bus->txminmax = BRCMF_TXMINMAX;
-	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
+	bus->tx_seq = SDPCM_SEQ_WRAP - 1;
 
 	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
 	bus->brcmf_wq = create_singlethread_workqueue("brcmf_wq");
-- 
1.8.1.3


