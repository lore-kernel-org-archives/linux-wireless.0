Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4243 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/19] brcmfmac: add host tx glomming support
Date: Fri, 29 Nov 2013 12:25:10 +0100
Message-ID: <1385724324-6361-6-git-send-email-arend@broadcom.com> (sfid-20131129_123809_130276_56347F03)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

New WiFi full dongle supports receiving chained packets in one command
through the SDIO bus. This patch adds the support on the host side to
send chained packets.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  327 ++++++++++++++------
 1 file changed, 227 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f017c92..f5d36506 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/vmalloc.h>
 #include <linux/platform_data/brcmfmac-sdio.h>
+#include <linux/moduleparam.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
@@ -110,6 +111,8 @@ struct rte_console {
 #define BRCMF_TXBOUND	20	/* Default for max tx frames in
 				 one scheduling */
 
+#define BRCMF_DEFAULT_TXGLOM_SIZE	32  /* max tx frames in glom chain */
+
 #define BRCMF_TXMINMAX	1	/* Max tx frames if rx still pending */
 
 #define MEMBLOCK	2048	/* Block size used for downloading
@@ -360,6 +363,8 @@ struct brcmf_sdio_hdrinfo {
 	u16 len_left;
 	u16 len_nxtfrm;
 	u8 dat_offset;
+	bool lastfrm;
+	u16 tail_pad;
 };
 
 /* misc chip info needed by some of the routines */
@@ -455,6 +460,8 @@ struct brcmf_sdio {
 	bool sleeping; /* SDIO bus sleeping */
 
 	u8 tx_hdrlen;		/* sdio bus header length for tx packet */
+	bool txglom;		/* host tx glomming enable flag */
+	struct sk_buff *txglom_sgpad;	/* scatter-gather padding buffer */
 };
 
 /* clkstate */
@@ -479,6 +486,10 @@ static const uint max_roundup = 512;
 
 #define ALIGNMENT  4
 
+static int brcmf_sdio_txglomsz = BRCMF_DEFAULT_TXGLOM_SIZE;
+module_param_named(txglomsz, brcmf_sdio_txglomsz, int, 0);
+MODULE_PARM_DESC(txglomsz, "maximum tx packet chain size [SDIO]");
+
 enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_NORMAL,
 	BRCMF_SDIO_FT_SUPER,
@@ -1102,10 +1113,18 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
  * host and WiFi dongle which contains information needed for SDIO core and
  * firmware
  *
- * It consists of 2 parts: hw header and software header
+ * It consists of 3 parts: hardware header, hardware extension header and
+ * software header
  * hardware header (frame tag) - 4 bytes
  * Byte 0~1: Frame length
  * Byte 2~3: Checksum, bit-wise inverse of frame length
+ * hardware extension header - 8 bytes
+ * Tx glom mode only, N/A for Rx or normal Tx
+ * Byte 0~1: Packet length excluding hw frame tag
+ * Byte 2: Reserved
+ * Byte 3: Frame flags, bit 0: last frame indication
+ * Byte 4~5: Reserved
+ * Byte 6~7: Tail padding length
  * software header - 8 bytes
  * Byte 0: Rx/Tx sequence number
  * Byte 1: 4 MSB Channel number, 4 LSB arbitrary flag
@@ -1116,6 +1135,7 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
  * Byte 6~7: Reserved
  */
 #define SDPCM_HWHDR_LEN			4
+#define SDPCM_HWEXT_LEN			8
 #define SDPCM_SWHDR_LEN			8
 #define SDPCM_HDRLEN			(SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN)
 /* software header */
@@ -1265,18 +1285,28 @@ static inline void brcmf_sdio_update_hwhdr(u8 *header, u16 frm_length)
 static void brcmf_sdio_hdpack(struct brcmf_sdio *bus, u8 *header,
 			      struct brcmf_sdio_hdrinfo *hd_info)
 {
-	u32 sw_header;
+	u32 hdrval;
+	u8 hdr_offset;
 
 	brcmf_sdio_update_hwhdr(header, hd_info->len);
-
-	sw_header = bus->tx_seq;
-	sw_header |= (hd_info->channel << SDPCM_CHANNEL_SHIFT) &
-		     SDPCM_CHANNEL_MASK;
-	sw_header |= (hd_info->dat_offset << SDPCM_DOFFSET_SHIFT) &
-		     SDPCM_DOFFSET_MASK;
-	*(((__le32 *)header) + 1) = cpu_to_le32(sw_header);
-	*(((__le32 *)header) + 2) = 0;
-	trace_brcmf_sdpcm_hdr(SDPCM_TX, header);
+	hdr_offset = SDPCM_HWHDR_LEN;
+
+	if (bus->txglom) {
+		hdrval = (hd_info->len - hdr_offset) | (hd_info->lastfrm << 24);
+		*((__le32 *)(header + hdr_offset)) = cpu_to_le32(hdrval);
+		hdrval = (u16)hd_info->tail_pad << 16;
+		*(((__le32 *)(header + hdr_offset)) + 1) = cpu_to_le32(hdrval);
+		hdr_offset += SDPCM_HWEXT_LEN;
+	}
+
+	hdrval = hd_info->seq_num;
+	hdrval |= (hd_info->channel << SDPCM_CHANNEL_SHIFT) &
+		  SDPCM_CHANNEL_MASK;
+	hdrval |= (hd_info->dat_offset << SDPCM_DOFFSET_SHIFT) &
+		  SDPCM_DOFFSET_MASK;
+	*((__le32 *)(header + hdr_offset)) = cpu_to_le32(hdrval);
+	*(((__le32 *)(header + hdr_offset)) + 1) = 0;
+	trace_brcmf_sdpcm_hdr(SDPCM_TX + !!(bus->txglom), header);
 }
 
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
@@ -1876,6 +1906,34 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 	return;
 }
 
+static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
+{
+	u16 head_align, head_pad;
+	u8 *dat_buf;
+
+	/* SDIO ADMA requires at least 32 bit alignment */
+	head_align = 4;
+	if (bus->sdiodev->pdata && bus->sdiodev->pdata->sd_head_align > 4)
+		head_align = bus->sdiodev->pdata->sd_head_align;
+
+	dat_buf = (u8 *)(pkt->data);
+
+	/* Check head padding */
+	head_pad = ((unsigned long)dat_buf % head_align);
+	if (head_pad) {
+		if (skb_headroom(pkt) < head_pad) {
+			bus->sdiodev->bus_if->tx_realloc++;
+			head_pad = 0;
+			if (skb_cow(pkt, head_pad))
+				return -ENOMEM;
+		}
+		skb_push(pkt, head_pad);
+		dat_buf = (u8 *)(pkt->data);
+		memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
+	}
+	return head_pad;
+}
+
 /**
  * struct brcmf_skbuff_cb reserves first two bytes in sk_buff::cb for
  * bus layer usage.
@@ -1885,16 +1943,18 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 /* bit mask of data length chopped from the previous packet */
 #define ALIGN_SKB_CHOP_LEN_MASK	0x7fff
 
-static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio_dev *sdiodev,
+static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 				    struct sk_buff_head *pktq,
-				    struct sk_buff *pkt, uint chan)
+				    struct sk_buff *pkt, u16 total_len)
 {
+	struct brcmf_sdio_dev *sdiodev;
 	struct sk_buff *pkt_pad;
-	u16 tail_pad, tail_chop, sg_align;
+	u16 tail_pad, tail_chop, sg_align, chain_pad;
 	unsigned int blksize;
-	u8 *dat_buf;
-	int ntail;
+	bool lastfrm;
+	int ntail, ret;
 
+	sdiodev = bus->sdiodev;
 	blksize = sdiodev->func[SDIO_FUNC_2]->cur_blksize;
 	sg_align = 4;
 	if (sdiodev->pdata && sdiodev->pdata->sd_sgentry_align > 4)
@@ -1903,14 +1963,23 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio_dev *sdiodev,
 	WARN_ON(blksize % sg_align);
 
 	/* Check tail padding */
-	pkt_pad = NULL;
+	lastfrm = skb_queue_is_last(pktq, pkt);
+	tail_pad = 0;
 	tail_chop = pkt->len % sg_align;
-	tail_pad = sg_align - tail_chop;
-	tail_pad += blksize - (pkt->len + tail_pad) % blksize;
+	if (tail_chop)
+		tail_pad = sg_align - tail_chop;
+	chain_pad = (total_len + tail_pad) % blksize;
+	if (lastfrm && chain_pad)
+		tail_pad += blksize - chain_pad;
 	if (skb_tailroom(pkt) < tail_pad && pkt->len > blksize) {
-		pkt_pad = brcmu_pkt_buf_get_skb(tail_pad + tail_chop);
+		pkt_pad = bus->txglom_sgpad;
+		if (pkt_pad == NULL)
+			  brcmu_pkt_buf_get_skb(tail_pad + tail_chop);
 		if (pkt_pad == NULL)
 			return -ENOMEM;
+		ret = brcmf_sdio_txpkt_hdalign(bus, pkt_pad);
+		if (unlikely(ret < 0))
+			return ret;
 		memcpy(pkt_pad->data,
 		       pkt->data + pkt->len - tail_chop,
 		       tail_chop);
@@ -1925,14 +1994,10 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio_dev *sdiodev,
 				return -ENOMEM;
 		if (skb_linearize(pkt))
 			return -ENOMEM;
-		dat_buf = (u8 *)(pkt->data);
 		__skb_put(pkt, tail_pad);
 	}
 
-	if (pkt_pad)
-		return pkt->len + tail_chop;
-	else
-		return pkt->len - tail_pad;
+	return tail_pad;
 }
 
 /**
@@ -1951,58 +2016,66 @@ static int
 brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		      uint chan)
 {
-	u16 head_pad, head_align;
+	u16 head_pad, total_len;
 	struct sk_buff *pkt_next;
-	u8 *dat_buf;
-	int err;
+	u8 txseq;
+	int ret;
 	struct brcmf_sdio_hdrinfo hd_info = {0};
 
-	/* SDIO ADMA requires at least 32 bit alignment */
-	head_align = 4;
-	if (bus->sdiodev->pdata && bus->sdiodev->pdata->sd_head_align > 4)
-		head_align = bus->sdiodev->pdata->sd_head_align;
+	txseq = bus->tx_seq;
+	total_len = 0;
+	skb_queue_walk(pktq, pkt_next) {
+		/* alignment packet inserted in previous
+		 * loop cycle can be skipped as it is
+		 * already properly aligned and does not
+		 * need an sdpcm header.
+		 */
+		if (*(u32 *)(pkt_next->cb) & ALIGN_SKB_FLAG)
+			continue;
 
-	pkt_next = pktq->next;
-	dat_buf = (u8 *)(pkt_next->data);
+		/* align packet data pointer */
+		ret = brcmf_sdio_txpkt_hdalign(bus, pkt_next);
+		if (ret < 0)
+			return ret;
+		head_pad = (u16)ret;
+		if (head_pad)
+			memset(pkt_next->data, 0, head_pad + bus->tx_hdrlen);
 
-	/* Check head padding */
-	head_pad = ((unsigned long)dat_buf % head_align);
-	if (head_pad) {
-		if (skb_headroom(pkt_next) < head_pad) {
-			bus->sdiodev->bus_if->tx_realloc++;
-			head_pad = 0;
-			if (skb_cow(pkt_next, head_pad))
-				return -ENOMEM;
-		}
-		skb_push(pkt_next, head_pad);
-		dat_buf = (u8 *)(pkt_next->data);
-		memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
-	}
+		total_len += pkt_next->len;
 
-	if (bus->sdiodev->sg_support && pktq->qlen > 1) {
-		err = brcmf_sdio_txpkt_prep_sg(bus->sdiodev, pktq,
-					       pkt_next, chan);
-		if (err < 0)
-			return err;
-		hd_info.len = (u16)err;
-	} else {
 		hd_info.len = pkt_next->len;
-	}
-
-	hd_info.channel = chan;
-	hd_info.dat_offset = head_pad + bus->tx_hdrlen;
-
-	/* Now fill the header */
-	brcmf_sdio_hdpack(bus, dat_buf, &hd_info);
-
-	if (BRCMF_BYTES_ON() &&
-	    ((BRCMF_CTL_ON() && chan == SDPCM_CONTROL_CHANNEL) ||
-	     (BRCMF_DATA_ON() && chan != SDPCM_CONTROL_CHANNEL)))
-		brcmf_dbg_hex_dump(true, pkt_next, hd_info.len, "Tx Frame:\n");
-	else if (BRCMF_HDRS_ON())
-		brcmf_dbg_hex_dump(true, pkt_next, head_pad + bus->tx_hdrlen,
-				   "Tx Header:\n");
+		hd_info.lastfrm = skb_queue_is_last(pktq, pkt_next);
+		if (bus->txglom && pktq->qlen > 1) {
+			ret = brcmf_sdio_txpkt_prep_sg(bus, pktq,
+						       pkt_next, total_len);
+			if (ret < 0)
+				return ret;
+			hd_info.tail_pad = (u16)ret;
+			total_len += (u16)ret;
+		}
 
+		hd_info.channel = chan;
+		hd_info.dat_offset = head_pad + bus->tx_hdrlen;
+		hd_info.seq_num = txseq++;
+
+		/* Now fill the header */
+		brcmf_sdio_hdpack(bus, pkt_next->data, &hd_info);
+
+		if (BRCMF_BYTES_ON() &&
+		    ((BRCMF_CTL_ON() && chan == SDPCM_CONTROL_CHANNEL) ||
+		     (BRCMF_DATA_ON() && chan != SDPCM_CONTROL_CHANNEL)))
+			brcmf_dbg_hex_dump(true, pkt_next, hd_info.len,
+					   "Tx Frame:\n");
+		else if (BRCMF_HDRS_ON())
+			brcmf_dbg_hex_dump(true, pkt_next,
+					   head_pad + bus->tx_hdrlen,
+					   "Tx Header:\n");
+	}
+	/* Hardware length tag of the first packet should be total
+	 * length of the chain (including padding)
+	 */
+	if (bus->txglom)
+		brcmf_sdio_update_hwhdr(pktq->next->data, total_len);
 	return 0;
 }
 
@@ -2020,6 +2093,7 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
 {
 	u8 *hdr;
 	u32 dat_offset;
+	u16 tail_pad;
 	u32 dummy_flags, chop_len;
 	struct sk_buff *pkt_next, *tmp, *pkt_prev;
 
@@ -2029,42 +2103,42 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
 			chop_len = dummy_flags & ALIGN_SKB_CHOP_LEN_MASK;
 			if (chop_len) {
 				pkt_prev = pkt_next->prev;
-				memcpy(pkt_prev->data + pkt_prev->len,
-				       pkt_next->data, chop_len);
 				skb_put(pkt_prev, chop_len);
 			}
 			__skb_unlink(pkt_next, pktq);
 			brcmu_pkt_buf_free_skb(pkt_next);
 		} else {
-			hdr = pkt_next->data + SDPCM_HWHDR_LEN;
+			hdr = pkt_next->data + bus->tx_hdrlen - SDPCM_SWHDR_LEN;
 			dat_offset = le32_to_cpu(*(__le32 *)hdr);
 			dat_offset = (dat_offset & SDPCM_DOFFSET_MASK) >>
 				     SDPCM_DOFFSET_SHIFT;
 			skb_pull(pkt_next, dat_offset);
+			if (bus->txglom) {
+				tail_pad = le16_to_cpu(*(__le16 *)(hdr - 2));
+				skb_trim(pkt_next, pkt_next->len - tail_pad);
+			}
 		}
 	}
 }
 
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
-static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
+static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 			      uint chan)
 {
 	int ret;
 	int i;
-	struct sk_buff_head localq;
+	struct sk_buff *pkt_next, *tmp;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	__skb_queue_head_init(&localq);
-	__skb_queue_tail(&localq, pkt);
-	ret = brcmf_sdio_txpkt_prep(bus, &localq, chan);
+	ret = brcmf_sdio_txpkt_prep(bus, pktq, chan);
 	if (ret)
 		goto done;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
 	ret = brcmf_sdcard_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
-				    SDIO_FUNC_2, F2SYNC, &localq);
+				    SDIO_FUNC_2, F2SYNC, pktq);
 	bus->sdcnt.f2txdata++;
 
 	if (ret < 0) {
@@ -2088,42 +2162,56 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 			if ((hi == 0) && (lo == 0))
 				break;
 		}
-
 	}
 	sdio_release_host(bus->sdiodev->func[1]);
-	if (ret == 0)
-		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
 
 done:
-	brcmf_sdio_txpkt_postp(bus, &localq);
-	__skb_dequeue_tail(&localq);
-	brcmf_txcomplete(bus->sdiodev->dev, pkt, ret == 0);
+	brcmf_sdio_txpkt_postp(bus, pktq);
+	if (ret == 0)
+		bus->tx_seq = (bus->tx_seq + pktq->qlen) % SDPCM_SEQ_WRAP;
+	skb_queue_walk_safe(pktq, pkt_next, tmp) {
+		__skb_unlink(pkt_next, pktq);
+		brcmf_txcomplete(bus->sdiodev->dev, pkt_next, ret == 0);
+	}
 	return ret;
 }
 
 static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 {
 	struct sk_buff *pkt;
+	struct sk_buff_head pktq;
 	u32 intstatus = 0;
-	int ret = 0, prec_out;
+	int ret = 0, prec_out, i;
 	uint cnt = 0;
-	u8 tx_prec_map;
+	u8 tx_prec_map, pkt_num;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	tx_prec_map = ~bus->flowcontrol;
 
 	/* Send frames until the limit or some other event */
-	for (cnt = 0; (cnt < maxframes) && data_ok(bus); cnt++) {
+	for (cnt = 0; (cnt < maxframes) && data_ok(bus);) {
+		pkt_num = 1;
+		__skb_queue_head_init(&pktq);
+		if (bus->txglom)
+			pkt_num = min_t(u8, bus->tx_max - bus->tx_seq,
+					brcmf_sdio_txglomsz);
+		pkt_num = min_t(u32, pkt_num,
+				brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol));
 		spin_lock_bh(&bus->txqlock);
-		pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
-		if (pkt == NULL) {
-			spin_unlock_bh(&bus->txqlock);
-			break;
+		for (i = 0; i < pkt_num; i++) {
+			pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map,
+					      &prec_out);
+			if (pkt == NULL)
+				break;
+			__skb_queue_tail(&pktq, pkt);
 		}
 		spin_unlock_bh(&bus->txqlock);
+		if (i == 0)
+			break;
 
-		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL);
+		ret = brcmf_sdbrcm_txpkt(bus, &pktq, SDPCM_DATA_CHANNEL);
+		cnt += i;
 
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
@@ -2670,7 +2758,7 @@ static int
 brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
-	u16 len;
+	u16 len, pad;
 	uint retries = 0;
 	u8 doff = 0;
 	int ret = -1;
@@ -2697,13 +2785,15 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	doff += bus->tx_hdrlen;
 
 	/* Round send length to next SDIO block */
+	pad = 0;
 	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
-		u16 pad = bus->blocksize - (len % bus->blocksize);
-		if ((pad <= bus->roundup) && (pad < bus->blocksize))
-			len += pad;
+		pad = bus->blocksize - (len % bus->blocksize);
+		if ((pad > bus->roundup) || (pad >= bus->blocksize))
+			pad = 0;
 	} else if (len % BRCMF_SDALIGN) {
-		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
+		pad = BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
 	}
+	len += pad;
 
 	/* Satisfy length-alignment requirements */
 	if (len & (ALIGNMENT - 1))
@@ -2719,8 +2809,16 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	hd_info.len = (u16)msglen;
 	hd_info.channel = SDPCM_CONTROL_CHANNEL;
 	hd_info.dat_offset = doff;
+	hd_info.seq_num = bus->tx_seq;
+	if (bus->txglom) {
+		hd_info.lastfrm = true;
+		hd_info.tail_pad = pad;
+	}
 	brcmf_sdio_hdpack(bus, frame, &hd_info);
 
+	if (bus->txglom)
+		brcmf_sdio_update_hwhdr(frame, len);
+
 	if (!data_ok(bus)) {
 		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
 			  bus->tx_max, bus->tx_seq);
@@ -3435,11 +3533,15 @@ static int brcmf_sdbrcm_bus_preinit(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	uint pad_size;
 	u32 value;
 	u8 idx;
 	int err;
 
-	/* sdio bus core specific dcmd */
+	/* the commands below use the terms tx and rx from
+	 * a device perspective, ie. bus:txglom affects the
+	 * bus transfers from device to host.
+	 */
 	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	if (bus->ci->c_inf[idx].rev < 12) {
 		/* for sdio core rev < 12, disable txgloming */
@@ -3456,6 +3558,32 @@ static int brcmf_sdbrcm_bus_preinit(struct device *dev)
 		err = brcmf_iovar_data_set(dev, "bus:txglomalign", &value,
 					   sizeof(u32));
 	}
+
+	if (err < 0)
+		goto done;
+
+	bus->tx_hdrlen = SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN;
+	if (sdiodev->sg_support) {
+		bus->txglom = false;
+		value = 1;
+		pad_size = bus->sdiodev->func[2]->cur_blksize << 1;
+		bus->txglom_sgpad = brcmu_pkt_buf_get_skb(pad_size);
+		if (!bus->txglom_sgpad)
+			brcmf_err("allocating txglom padding skb failed, reduced performance\n");
+
+		err = brcmf_iovar_data_set(bus->sdiodev->dev, "bus:rxglom",
+					   &value, sizeof(u32));
+		if (err < 0) {
+			/* bus:rxglom is allowed to fail */
+			err = 0;
+		} else {
+			bus->txglom = true;
+			bus->tx_hdrlen += SDPCM_HWEXT_LEN;
+		}
+	}
+	brcmf_bus_add_txhdrlen(bus->sdiodev->dev, bus->tx_hdrlen);
+
+done:
 	return err;
 }
 
@@ -3929,6 +4057,7 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 			brcmf_sdbrcm_release_dongle(bus);
 		}
 
+		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
 		brcmf_sdbrcm_release_malloc(bus);
 
 		kfree(bus);
@@ -4034,8 +4163,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
-	brcmf_bus_add_txhdrlen(bus->sdiodev->dev, bus->tx_hdrlen);
-
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->sdiodev->dev);
 	if (ret != 0) {
-- 
1.7.10.4


