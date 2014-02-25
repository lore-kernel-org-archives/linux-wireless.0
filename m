Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:44801 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaBYTaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:46 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/14] brcmfmac: fix use of skb control buffer in SDIO driver part
Date: Tue, 25 Feb 2014 20:30:27 +0100
Message-ID: <1393356639-19169-4-git-send-email-arend@broadcom.com> (sfid-20140225_203058_386881_942E9C06)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SDIO driver has a 16-bit field defined in the skbuff control buffer.
However, it is accessed as a u32 overwriting other control info. Another
issue is that the field is not initialized for networking packets, but
the control buffer content is unspecified as other networking layers can
use it.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 631d5dc..fa4ec69 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2112,7 +2112,7 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
 		memcpy(pkt_pad->data,
 		       pkt->data + pkt->len - tail_chop,
 		       tail_chop);
-		*(u32 *)(pkt_pad->cb) = ALIGN_SKB_FLAG + tail_chop;
+		*(u16 *)(pkt_pad->cb) = ALIGN_SKB_FLAG + tail_chop;
 		skb_trim(pkt, pkt->len - tail_chop);
 		__skb_queue_after(pktq, pkt, pkt_pad);
 	} else {
@@ -2159,7 +2159,7 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		 * already properly aligned and does not
 		 * need an sdpcm header.
 		 */
-		if (*(u32 *)(pkt_next->cb) & ALIGN_SKB_FLAG)
+		if (*(u16 *)(pkt_next->cb) & ALIGN_SKB_FLAG)
 			continue;
 
 		/* align packet data pointer */
@@ -2223,11 +2223,11 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
 	u8 *hdr;
 	u32 dat_offset;
 	u16 tail_pad;
-	u32 dummy_flags, chop_len;
+	u16 dummy_flags, chop_len;
 	struct sk_buff *pkt_next, *tmp, *pkt_prev;
 
 	skb_queue_walk_safe(pktq, pkt_next, tmp) {
-		dummy_flags = *(u32 *)(pkt_next->cb);
+		dummy_flags = *(u16 *)(pkt_next->cb);
 		if (dummy_flags & ALIGN_SKB_FLAG) {
 			chop_len = dummy_flags & ALIGN_SKB_CHOP_LEN_MASK;
 			if (chop_len) {
@@ -2709,6 +2709,8 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 
 	/* Priority based enq */
 	spin_lock_irqsave(&bus->txqlock, flags);
+	/* reset bus_flags in packet cb */
+	*(u16 *)(pkt->cb) = 0;
 	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
 		skb_pull(pkt, bus->tx_hdrlen);
 		brcmf_err("out of bus->txq !!!\n");
-- 
1.7.10.4

