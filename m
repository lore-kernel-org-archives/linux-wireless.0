Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4382 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab3JONpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:08 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/12] brcmfmac: fix brcmf_sdio_txpkt_prep() for host
 without sg support
Date: Tue, 15 Oct 2013 15:44:56 +0200
Message-ID: <1381844697-24881-12-git-send-email-arend@broadcom.com> (sfid-20131015_154650_287654_BA2543D4)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running on a host controller that does not support scatter-gather
transfers the function brcmf_sdio_txpkt_prep() should not add tail
padding buffers.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  106 ++++++++++++--------
 1 file changed, 64 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ab1c919..c927701 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1880,6 +1880,56 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 /* bit mask of data length chopped from the previous packet */
 #define ALIGN_SKB_CHOP_LEN_MASK	0x7fff
 
+static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio_dev *sdiodev,
+				    struct sk_buff_head *pktq,
+				    struct sk_buff *pkt, uint chan)
+{
+	struct sk_buff *pkt_pad;
+	u16 tail_pad, tail_chop, sg_align;
+	unsigned int blksize;
+	u8 *dat_buf;
+	int ntail;
+
+	blksize = sdiodev->func[SDIO_FUNC_2]->cur_blksize;
+	sg_align = 4;
+	if (sdiodev->pdata && sdiodev->pdata->sd_sgentry_align > 4)
+		sg_align = sdiodev->pdata->sd_sgentry_align;
+	/* sg entry alignment should be a divisor of block size */
+	WARN_ON(blksize % sg_align);
+
+	/* Check tail padding */
+	pkt_pad = NULL;
+	tail_chop = pkt->len % sg_align;
+	tail_pad = sg_align - tail_chop;
+	tail_pad += blksize - (pkt->len + tail_pad) % blksize;
+	if (skb_tailroom(pkt) < tail_pad && pkt->len > blksize) {
+		pkt_pad = brcmu_pkt_buf_get_skb(tail_pad + tail_chop);
+		if (pkt_pad == NULL)
+			return -ENOMEM;
+		memcpy(pkt_pad->data,
+		       pkt->data + pkt->len - tail_chop,
+		       tail_chop);
+		*(u32 *)(pkt_pad->cb) = ALIGN_SKB_FLAG + tail_chop;
+		skb_trim(pkt, pkt->len - tail_chop);
+		__skb_queue_after(pktq, pkt, pkt_pad);
+	} else {
+		ntail = pkt->data_len + tail_pad -
+			(pkt->end - pkt->tail);
+		if (skb_cloned(pkt) || ntail > 0)
+			if (pskb_expand_head(pkt, 0, ntail, GFP_ATOMIC))
+				return -ENOMEM;
+		if (skb_linearize(pkt))
+			return -ENOMEM;
+		dat_buf = (u8 *)(pkt->data);
+		__skb_put(pkt, tail_pad);
+	}
+
+	if (pkt_pad)
+		return pkt->len + tail_chop;
+	else
+		return pkt->len - tail_pad;
+}
+
 /**
  * brcmf_sdio_txpkt_prep - packet preparation for transmit
  * @bus: brcmf_sdio structure pointer
@@ -1896,24 +1946,16 @@ static int
 brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		      uint chan)
 {
-	u16 head_pad, tail_pad, tail_chop, head_align, sg_align;
-	int ntail;
-	struct sk_buff *pkt_next, *pkt_new;
+	u16 head_pad, head_align;
+	struct sk_buff *pkt_next;
 	u8 *dat_buf;
-	unsigned blksize = bus->sdiodev->func[SDIO_FUNC_2]->cur_blksize;
+	int err;
 	struct brcmf_sdio_hdrinfo hd_info = {0};
 
 	/* SDIO ADMA requires at least 32 bit alignment */
 	head_align = 4;
-	sg_align = 4;
-	if (bus->sdiodev->pdata) {
-		head_align = bus->sdiodev->pdata->sd_head_align > 4 ?
-			     bus->sdiodev->pdata->sd_head_align : 4;
-		sg_align = bus->sdiodev->pdata->sd_sgentry_align > 4 ?
-			   bus->sdiodev->pdata->sd_sgentry_align : 4;
-	}
-	/* sg entry alignment should be a divisor of block size */
-	WARN_ON(blksize % sg_align);
+	if (bus->sdiodev->pdata && bus->sdiodev->pdata->sd_head_align > 4)
+		head_align = bus->sdiodev->pdata->sd_head_align;
 
 	pkt_next = pktq->next;
 	dat_buf = (u8 *)(pkt_next->data);
@@ -1932,40 +1974,20 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
 	}
 
-	/* Check tail padding */
-	pkt_new = NULL;
-	tail_chop = pkt_next->len % sg_align;
-	tail_pad = sg_align - tail_chop;
-	tail_pad += blksize - (pkt_next->len + tail_pad) % blksize;
-	if (skb_tailroom(pkt_next) < tail_pad && pkt_next->len > blksize) {
-		pkt_new = brcmu_pkt_buf_get_skb(tail_pad + tail_chop);
-		if (pkt_new == NULL)
-			return -ENOMEM;
-		memcpy(pkt_new->data,
-		       pkt_next->data + pkt_next->len - tail_chop,
-		       tail_chop);
-		*(u32 *)(pkt_new->cb) = ALIGN_SKB_FLAG + tail_chop;
-		skb_trim(pkt_next, pkt_next->len - tail_chop);
-		__skb_queue_after(pktq, pkt_next, pkt_new);
+	if (bus->sdiodev->sg_support && pktq->qlen > 1) {
+		err = brcmf_sdio_txpkt_prep_sg(bus->sdiodev, pktq,
+					       pkt_next, chan);
+		if (err < 0)
+			return err;
+		hd_info.len = (u16)err;
 	} else {
-		ntail = pkt_next->data_len + tail_pad -
-			(pkt_next->end - pkt_next->tail);
-		if (skb_cloned(pkt_next) || ntail > 0)
-			if (pskb_expand_head(pkt_next, 0, ntail, GFP_ATOMIC))
-				return -ENOMEM;
-		if (skb_linearize(pkt_next))
-			return -ENOMEM;
-		dat_buf = (u8 *)(pkt_next->data);
-		__skb_put(pkt_next, tail_pad);
+		hd_info.len = pkt_next->len;
 	}
 
-	/* Now prep the header */
-	if (pkt_new)
-		hd_info.len = pkt_next->len + tail_chop;
-	else
-		hd_info.len = pkt_next->len - tail_pad;
 	hd_info.channel = chan;
 	hd_info.dat_offset = head_pad + bus->tx_hdrlen;
+
+	/* Now fill the header */
 	brcmf_sdio_hdpack(bus, dat_buf, &hd_info);
 
 	if (BRCMF_BYTES_ON() &&
-- 
1.7.10.4


