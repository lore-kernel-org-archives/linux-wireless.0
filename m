Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4239 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/19] brcmfmac: determine alignment values during probe
Date: Fri, 29 Nov 2013 12:25:13 +0100
Message-ID: <1385724324-6361-9-git-send-email-arend@broadcom.com> (sfid-20131129_123808_964844_7F16DB0E)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The alignment values were being determined for each transmit
and receive depending on platform data. Instead determine
these once during the probe.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   48 ++++++++++----------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f5d36506..584ffb8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -462,6 +462,8 @@ struct brcmf_sdio {
 	u8 tx_hdrlen;		/* sdio bus header length for tx packet */
 	bool txglom;		/* host tx glomming enable flag */
 	struct sk_buff *txglom_sgpad;	/* scatter-gather padding buffer */
+	u16 head_align;		/* buffer pointer alignment */
+	u16 sgentry_align;	/* scatter-gather buffer alignment */
 };
 
 /* clkstate */
@@ -1313,7 +1315,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
-	u32 align = 0;
 	u16 sublen;
 	struct sk_buff *pfirst, *pnext;
 
@@ -1328,11 +1329,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	brcmf_dbg(SDIO, "start: glomd %p glom %p\n",
 		  bus->glomd, skb_peek(&bus->glom));
 
-	if (bus->sdiodev->pdata)
-		align = bus->sdiodev->pdata->sd_sgentry_align;
-	if (align < 4)
-		align = 4;
-
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
 		pfirst = pnext = NULL;
@@ -1356,9 +1352,9 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				pnext = NULL;
 				break;
 			}
-			if (sublen % align) {
+			if (sublen % bus->sgentry_align) {
 				brcmf_err("sublen %d not multiple of %d\n",
-					  sublen, align);
+					  sublen, bus->sgentry_align);
 			}
 			totlen += sublen;
 
@@ -1371,7 +1367,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			}
 
 			/* Allocate/chain packet for next subframe */
-			pnext = brcmu_pkt_buf_get_skb(sublen + align);
+			pnext = brcmu_pkt_buf_get_skb(sublen + bus->sgentry_align);
 			if (pnext == NULL) {
 				brcmf_err("bcm_pkt_buf_get_skb failed, num %d len %d\n",
 					  num, sublen);
@@ -1380,7 +1376,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			skb_queue_tail(&bus->glom, pnext);
 
 			/* Adhere to start alignment requirements */
-			pkt_align(pnext, sublen, align);
+			pkt_align(pnext, sublen, bus->sgentry_align);
 		}
 
 		/* If all allocations succeeded, save packet chain
@@ -1908,18 +1904,13 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 {
-	u16 head_align, head_pad;
+	u16 head_pad;
 	u8 *dat_buf;
 
-	/* SDIO ADMA requires at least 32 bit alignment */
-	head_align = 4;
-	if (bus->sdiodev->pdata && bus->sdiodev->pdata->sd_head_align > 4)
-		head_align = bus->sdiodev->pdata->sd_head_align;
-
 	dat_buf = (u8 *)(pkt->data);
 
 	/* Check head padding */
-	head_pad = ((unsigned long)dat_buf % head_align);
+	head_pad = ((unsigned long)dat_buf % bus->head_align);
 	if (head_pad) {
 		if (skb_headroom(pkt) < head_pad) {
 			bus->sdiodev->bus_if->tx_realloc++;
@@ -1949,25 +1940,22 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 {
 	struct brcmf_sdio_dev *sdiodev;
 	struct sk_buff *pkt_pad;
-	u16 tail_pad, tail_chop, sg_align, chain_pad;
+	u16 tail_pad, tail_chop, chain_pad;
 	unsigned int blksize;
 	bool lastfrm;
 	int ntail, ret;
 
 	sdiodev = bus->sdiodev;
 	blksize = sdiodev->func[SDIO_FUNC_2]->cur_blksize;
-	sg_align = 4;
-	if (sdiodev->pdata && sdiodev->pdata->sd_sgentry_align > 4)
-		sg_align = sdiodev->pdata->sd_sgentry_align;
 	/* sg entry alignment should be a divisor of block size */
-	WARN_ON(blksize % sg_align);
+	WARN_ON(blksize % bus->sgentry_align);
 
 	/* Check tail padding */
 	lastfrm = skb_queue_is_last(pktq, pkt);
 	tail_pad = 0;
-	tail_chop = pkt->len % sg_align;
+	tail_chop = pkt->len % bus->sgentry_align;
 	if (tail_chop)
-		tail_pad = sg_align - tail_chop;
+		tail_pad = bus->sgentry_align - tail_chop;
 	chain_pad = (total_len + tail_pad) % blksize;
 	if (lastfrm && chain_pad)
 		tail_pad += blksize - chain_pad;
@@ -4099,6 +4087,18 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->txminmax = BRCMF_TXMINMAX;
 	bus->tx_seq = SDPCM_SEQ_WRAP - 1;
 
+	/* platform specific configuration:
+	 *   alignments must be at least 4 bytes for ADMA
+         */
+	bus->head_align = ALIGNMENT;
+	bus->sgentry_align = ALIGNMENT;
+	if (sdiodev->pdata) {
+		if (sdiodev->pdata->sd_head_align > ALIGNMENT)
+			bus->head_align = sdiodev->pdata->sd_head_align;
+		if (sdiodev->pdata->sd_sgentry_align > ALIGNMENT)
+			bus->sgentry_align = sdiodev->pdata->sd_sgentry_align;
+	}
+
 	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
 	bus->brcmf_wq = create_singlethread_workqueue("brcmf_wq");
 	if (bus->brcmf_wq == NULL) {
-- 
1.7.10.4


