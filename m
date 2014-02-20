Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:24238 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaBTR4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 12:56:05 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcmfmac: fix txglomming scatter-gather packet transfers
Date: Thu, 20 Feb 2014 18:55:55 +0100
Message-ID: <1392918955-4488-1-git-send-email-arend@broadcom.com> (sfid-20140220_185610_505315_6D649475)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver concatenates multiple packets in one MMC transfer. For
scatter-gather to work the total length need to be multiple of 512
bytes. A pre-allocated buffer was used to add padding to accomplish
that. However, the length was not properly set and it was freed after
the first transfer causing a crash.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

This patch is intended for 3.14 fixing a kernel crash. The patch applies
to the master branc of the wireless repository.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3e99189..119ee6e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -457,7 +457,6 @@ struct brcmf_sdio {
 
 	u8 tx_hdrlen;		/* sdio bus header length for tx packet */
 	bool txglom;		/* host tx glomming enable flag */
-	struct sk_buff *txglom_sgpad;	/* scatter-gather padding buffer */
 	u16 head_align;		/* buffer pointer alignment */
 	u16 sgentry_align;	/* scatter-gather buffer alignment */
 };
@@ -1944,9 +1943,8 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 	if (lastfrm && chain_pad)
 		tail_pad += blksize - chain_pad;
 	if (skb_tailroom(pkt) < tail_pad && pkt->len > blksize) {
-		pkt_pad = bus->txglom_sgpad;
-		if (pkt_pad == NULL)
-			  brcmu_pkt_buf_get_skb(tail_pad + tail_chop);
+		pkt_pad = brcmu_pkt_buf_get_skb(tail_pad + tail_chop +
+						bus->head_align);
 		if (pkt_pad == NULL)
 			return -ENOMEM;
 		ret = brcmf_sdio_txpkt_hdalign(bus, pkt_pad);
@@ -1957,6 +1955,7 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 		       tail_chop);
 		*(u32 *)(pkt_pad->cb) = ALIGN_SKB_FLAG + tail_chop;
 		skb_trim(pkt, pkt->len - tail_chop);
+		skb_trim(pkt_pad, tail_pad + tail_chop);
 		__skb_queue_after(pktq, pkt, pkt_pad);
 	} else {
 		ntail = pkt->data_len + tail_pad -
@@ -2011,7 +2010,7 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 			return ret;
 		head_pad = (u16)ret;
 		if (head_pad)
-			memset(pkt_next->data, 0, head_pad + bus->tx_hdrlen);
+			memset(pkt_next->data + bus->tx_hdrlen, 0, head_pad);
 
 		total_len += pkt_next->len;
 
@@ -3486,10 +3485,6 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 		bus->txglom = false;
 		value = 1;
 		pad_size = bus->sdiodev->func[2]->cur_blksize << 1;
-		bus->txglom_sgpad = brcmu_pkt_buf_get_skb(pad_size);
-		if (!bus->txglom_sgpad)
-			brcmf_err("allocating txglom padding skb failed, reduced performance\n");
-
 		err = brcmf_iovar_data_set(bus->sdiodev->dev, "bus:rxglom",
 					   &value, sizeof(u32));
 		if (err < 0) {
@@ -4053,7 +4048,6 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 			brcmf_sdio_chip_detach(&bus->ci);
 		}
 
-		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
 		kfree(bus->rxbuf);
 		kfree(bus->hdrbuf);
 		kfree(bus);
-- 
1.7.10.4

