Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2738 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968553Ab3HJK14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/12] brcmfmac: abstract tx packet processing functions
Date: Sat, 10 Aug 2013 12:27:26 +0200
Message-ID: <1376130450-29746-9-git-send-email-arend@broadcom.com> (sfid-20130810_123909_038706_D1008B4A)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Abstract brcmf_sdio_txpkt_prep and brcmf_sdio_txpkt_postp as a preparation
of chained tx packets for host side tx glomming.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  16 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 237 +++++++++++++++------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   2 +-
 include/linux/platform_data/brcmfmac-sdio.h        |   6 +
 4 files changed, 183 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index e3f3c48..e13b1a6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -592,6 +592,7 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
+	struct sk_buff_head pktq;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
@@ -602,7 +603,10 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	}
 
 	memcpy(mypkt->data, buf, nbytes);
-	err = brcmf_sdcard_send_pkt(sdiodev, addr, fn, flags, mypkt);
+	__skb_queue_head_init(&pktq);
+	__skb_queue_tail(&pktq, mypkt);
+	err = brcmf_sdcard_send_pkt(sdiodev, addr, fn, flags, &pktq);
+	__skb_dequeue_tail(&pktq);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 	return err;
@@ -611,22 +615,18 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 int
 brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, struct sk_buff *pkt)
+		      uint flags, struct sk_buff_head *pktq)
 {
 	uint width;
 	int err = 0;
-	struct sk_buff_head pkt_list;
 
 	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
-		  fn, addr, pkt->len);
+		  fn, addr, pktq->qlen);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	brcmf_sdio_addrprep(sdiodev, width, &addr);
 
-	skb_queue_head_init(&pkt_list);
-	skb_queue_tail(&pkt_list, pkt);
-	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, &pkt_list);
-	skb_dequeue_tail(&pkt_list);
+	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, pktq);
 
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index db31312..aa4caca 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -510,7 +510,6 @@ struct brcmf_sdio {
 
 #ifdef DEBUG
 static int qcount[NUMPRIO];
-static int tx_packets[NUMPRIO];
 #endif				/* DEBUG */
 
 #define DEFAULT_SDIO_DRIVE_STRENGTH	6	/* in milliamps */
@@ -1759,85 +1758,185 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 	return;
 }
 
+/* flag marking a dummy skb added for DMA alignment requirement */
+#define DUMMY_SKB_FLAG		0x10000
+/* bit mask of data length chopped from the previous packet */
+#define DUMMY_SKB_CHOP_LEN_MASK	0xffff
+/**
+ * brcmf_sdio_txpkt_prep - packet preparation for transmit
+ * @bus: brcmf_sdio structure pointer
+ * @pktq: packet list pointer
+ * @chan: virtual channel to transmit the packet
+ *
+ * Processes to be applied to the packet
+ *	- Align data buffer pointer
+ *	- Align data buffer length
+ *	- Prepare header
+ * Return: negative value if there is error
+ */
+static int
+brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
+		      uint chan)
+{
+	u16 head_pad, tail_pad, tail_chop, pkt_len;
+	u16 head_align, sg_align;
+	u32 sw_header;
+	int ntail;
+	struct sk_buff *pkt_next, *pkt_new;
+	u8 *dat_buf;
+	unsigned blksize = bus->sdiodev->func[SDIO_FUNC_2]->cur_blksize;
+
+	/* SDIO ADMA requires at least 32 bit alignment */
+	head_align = 4;
+	sg_align = 4;
+	if (bus->sdiodev->pdata) {
+		head_align = bus->sdiodev->pdata->sd_head_align > 4 ?
+			     bus->sdiodev->pdata->sd_head_align : 4;
+		sg_align = bus->sdiodev->pdata->sd_sgentry_align > 4 ?
+			   bus->sdiodev->pdata->sd_sgentry_align : 4;
+	}
+	/* sg entry alignment should be a divisor of block size */
+	WARN_ON(blksize % sg_align);
+
+	pkt_next = pktq->next;
+	dat_buf = (u8 *)(pkt_next->data);
+
+	/* Check head padding */
+	head_pad = ((unsigned long)dat_buf % head_align);
+	if (head_pad) {
+		if (skb_headroom(pkt_next) < head_pad) {
+			bus->sdiodev->bus_if->tx_realloc++;
+			head_pad = 0;
+			if (skb_cow(pkt_next, head_pad))
+				return -ENOMEM;
+		}
+		skb_push(pkt_next, head_pad);
+		dat_buf = (u8 *)(pkt_next->data);
+		memset(dat_buf, 0, head_pad + SDPCM_HDRLEN);
+	}
+
+	/* Check tail padding */
+	pkt_new = NULL;
+	tail_chop = pkt_next->len % sg_align;
+	tail_pad = sg_align - tail_chop;
+	tail_pad += blksize - (pkt_next->len + tail_pad) % blksize;
+	if (skb_tailroom(pkt_next) < tail_pad && pkt_next->len > blksize) {
+		pkt_new = brcmu_pkt_buf_get_skb(tail_pad + tail_chop);
+		if (pkt_new == NULL)
+			return -ENOMEM;
+		memcpy(pkt_new->data,
+		       pkt_next->data + pkt_next->len - tail_chop,
+		       tail_chop);
+		*(u32 *)(pkt_new->cb) = DUMMY_SKB_FLAG + tail_chop;
+		skb_trim(pkt_next, pkt_next->len - tail_chop);
+		__skb_queue_after(pktq, pkt_next, pkt_new);
+	} else {
+		ntail = pkt_next->data_len + tail_pad -
+			(pkt_next->end - pkt_next->tail);
+		if (skb_cloned(pkt_next) || ntail > 0)
+			if (pskb_expand_head(pkt_next, 0, ntail, GFP_ATOMIC))
+				return -ENOMEM;
+		if (skb_linearize(pkt_next))
+			return -ENOMEM;
+		dat_buf = (u8 *)(pkt_next->data);
+		__skb_put(pkt_next, tail_pad);
+	}
+
+	/* Now prep the header */
+	/* 4 bytes hardware header (frame tag)
+	 * Byte 0~1: Frame length
+	 * Byte 2~3: Checksum, bit-wise inverse of frame length
+	 */
+	if (pkt_new)
+		pkt_len = pkt_next->len + tail_chop;
+	else
+		pkt_len = pkt_next->len - tail_pad;
+	*(__le16 *)dat_buf = cpu_to_le16(pkt_len);
+	*(((__le16 *)dat_buf) + 1) = cpu_to_le16(~pkt_len);
+	/* 8 bytes software header
+	 * Byte 0: Tx sequence number
+	 * Byte 1: 4 MSB Channel number
+	 * Byte 2: Reserved
+	 * Byte 3: Data offset
+	 * Byte 4~7: Reserved
+	 */
+	sw_header = bus->tx_seq;
+	sw_header |= ((chan << SDPCM_CHANNEL_SHIFT) & SDPCM_CHANNEL_MASK);
+	sw_header |= ((head_pad + SDPCM_HDRLEN) << SDPCM_DOFFSET_SHIFT) &
+		     SDPCM_DOFFSET_MASK;
+	*(((__le32 *)dat_buf) + 1) = cpu_to_le32(sw_header);
+	*(((__le32 *)dat_buf) + 2) = 0;
+
+	if (BRCMF_BYTES_ON() &&
+	    ((BRCMF_CTL_ON() && chan == SDPCM_CONTROL_CHANNEL) ||
+	     (BRCMF_DATA_ON() && chan != SDPCM_CONTROL_CHANNEL)))
+		brcmf_dbg_hex_dump(true, pkt_next, pkt_len, "Tx Frame:\n");
+	else if (BRCMF_HDRS_ON())
+		brcmf_dbg_hex_dump(true, pkt_next, head_pad + SDPCM_HDRLEN,
+				   "Tx Header:\n");
+
+	return 0;
+}
+
+/**
+ * brcmf_sdio_txpkt_postp - packet post processing for transmit
+ * @bus: brcmf_sdio structure pointer
+ * @pktq: packet list pointer
+ *
+ * Processes to be applied to the packet
+ *	- Remove head padding
+ *	- Remove tail padding
+ */
+static void
+brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
+{
+	u8 *hdr;
+	u32 dat_offset;
+	u32 dummy_flags, chop_len;
+	struct sk_buff *pkt_next, *tmp, *pkt_prev;
+
+	skb_queue_walk_safe(pktq, pkt_next, tmp) {
+		dummy_flags = *(u32 *)(pkt_next->cb);
+		if (dummy_flags & DUMMY_SKB_FLAG) {
+			chop_len = dummy_flags & DUMMY_SKB_CHOP_LEN_MASK;
+			if (chop_len) {
+				pkt_prev = pkt_next->prev;
+				memcpy(pkt_prev->data + pkt_prev->len,
+				       pkt_next->data, chop_len);
+				skb_put(pkt_prev, chop_len);
+			}
+			__skb_unlink(pkt_next, pktq);
+			brcmu_pkt_buf_free_skb(pkt_next);
+		} else {
+			hdr = pkt_next->data + SDPCM_FRAMETAG_LEN;
+			dat_offset = le32_to_cpu(*(__le32 *)hdr);
+			dat_offset = (dat_offset & SDPCM_DOFFSET_MASK) >>
+				     SDPCM_DOFFSET_SHIFT;
+			skb_pull(pkt_next, dat_offset);
+		}
+	}
+}
+
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
 static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 			      uint chan)
 {
 	int ret;
-	u8 *frame;
-	u16 len, pad = 0;
-	u32 swheader;
 	int i;
+	struct sk_buff_head localq;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	frame = (u8 *) (pkt->data);
-
-	/* Add alignment padding, allocate new packet if needed */
-	pad = ((unsigned long)frame % BRCMF_SDALIGN);
-	if (pad) {
-		if (skb_headroom(pkt) < pad) {
-			brcmf_dbg(INFO, "insufficient headroom %d for %d pad\n",
-				  skb_headroom(pkt), pad);
-			bus->sdiodev->bus_if->tx_realloc++;
-			ret = skb_cow(pkt, BRCMF_SDALIGN);
-			if (ret)
-				goto done;
-			pad = ((unsigned long)frame % BRCMF_SDALIGN);
-		}
-		skb_push(pkt, pad);
-		frame = (u8 *) (pkt->data);
-		memset(frame, 0, pad + SDPCM_HDRLEN);
-	}
-	/* precondition: pad < BRCMF_SDALIGN */
-
-	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
-	len = (u16) (pkt->len);
-	*(__le16 *) frame = cpu_to_le16(len);
-	*(((__le16 *) frame) + 1) = cpu_to_le16(~len);
-
-	/* Software tag: channel, sequence number, data offset */
-	swheader =
-	    ((chan << SDPCM_CHANNEL_SHIFT) & SDPCM_CHANNEL_MASK) | bus->tx_seq |
-	    (((pad +
-	       SDPCM_HDRLEN) << SDPCM_DOFFSET_SHIFT) & SDPCM_DOFFSET_MASK);
-
-	*(((__le32 *) frame) + 1) = cpu_to_le32(swheader);
-	*(((__le32 *) frame) + 2) = 0;
-
-#ifdef DEBUG
-	tx_packets[pkt->priority]++;
-#endif
-
-	brcmf_dbg_hex_dump(BRCMF_BYTES_ON() &&
-			   ((BRCMF_CTL_ON() && chan == SDPCM_CONTROL_CHANNEL) ||
-			    (BRCMF_DATA_ON() && chan != SDPCM_CONTROL_CHANNEL)),
-			   frame, len, "Tx Frame:\n");
-	brcmf_dbg_hex_dump(!(BRCMF_BYTES_ON() &&
-			     ((BRCMF_CTL_ON() &&
-			       chan == SDPCM_CONTROL_CHANNEL) ||
-			      (BRCMF_DATA_ON() &&
-			       chan != SDPCM_CONTROL_CHANNEL))) &&
-			   BRCMF_HDRS_ON(),
-			   frame, min_t(u16, len, 16), "TxHdr:\n");
-
-	/* Raise len to next SDIO block to eliminate tail command */
-	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
-		u16 pad = bus->blocksize - (len % bus->blocksize);
-		if ((pad <= bus->roundup) && (pad < bus->blocksize))
-				len += pad;
-	} else if (len % BRCMF_SDALIGN) {
-		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
-	}
-
-	/* Some controllers have trouble with odd bytes -- round to even */
-	if (len & (ALIGNMENT - 1))
-			len = roundup(len, ALIGNMENT);
+	__skb_queue_head_init(&localq);
+	__skb_queue_tail(&localq, pkt);
+	ret = brcmf_sdio_txpkt_prep(bus, &localq, chan);
+	if (ret)
+		goto done;
 
 	sdio_claim_host(bus->sdiodev->func[1]);
 	ret = brcmf_sdcard_send_pkt(bus->sdiodev, bus->sdiodev->sbwad,
-				    SDIO_FUNC_2, F2SYNC, pkt);
+				    SDIO_FUNC_2, F2SYNC, &localq);
 	bus->sdcnt.f2txdata++;
 
 	if (ret < 0) {
@@ -1868,8 +1967,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
 done:
-	/* restore pkt buffer pointer before calling tx complete routine */
-	skb_pull(pkt, SDPCM_HDRLEN + pad);
+	brcmf_sdio_txpkt_postp(bus, &localq);
+	__skb_dequeue_tail(&localq);
 	brcmf_txcomplete(bus->sdiodev->dev, pkt, ret == 0);
 	return ret;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 09786a5..2b5407f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -208,7 +208,7 @@ extern int brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
  */
 extern int
 brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-		      uint flags, struct sk_buff *pkt);
+		      uint flags, struct sk_buff_head *pktq);
 extern int
 brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes);
diff --git a/include/linux/platform_data/brcmfmac-sdio.h b/include/linux/platform_data/brcmfmac-sdio.h
index b717499..e75dcbf 100644
--- a/include/linux/platform_data/brcmfmac-sdio.h
+++ b/include/linux/platform_data/brcmfmac-sdio.h
@@ -94,6 +94,10 @@ void __init brcmfmac_init_pdata(void)
  * Set this to true if the SDIO host controller has higher align requirement
  * than 32 bytes for each scatterlist item.
  *
+ * sd_head_align: alignment requirement for start of data buffer
+ *
+ * sd_sgentry_align: length alignment requirement for each sg entry
+ *
  * power_on: This function is called by the brcmfmac when the module gets
  * loaded. This can be particularly useful for low power devices. The platform
  * spcific routine may for example decide to power up the complete device.
@@ -121,6 +125,8 @@ struct brcmfmac_sdio_platform_data {
 	unsigned int oob_irq_nr;
 	unsigned long oob_irq_flags;
 	bool broken_sg_support;
+	unsigned short sd_head_align;
+	unsigned short sd_sgentry_align;
 	void (*power_on)(void);
 	void (*power_off)(void);
 	void (*reset)(void);
-- 
1.8.1.3


