Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4469 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760465Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/25] brcmfmac: use skb_cow() in brcmf_sdbrcm_txpkt()
 to assure alignment
Date: Wed, 3 Apr 2013 12:40:28 +0200
Message-ID: <1364985650-11719-4-git-send-email-arend@broadcom.com> (sfid-20130403_124303_948487_2CF84587)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_sdbrcm_txpkt() a new packet is allocated and used to transmit
to firmware freeing up the original packet. However, that packet is
still referenced in firmware-signalling so this would result in a
double free. Using skb_cow() avoids this as the packet reference is
unchanged.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   25 +++++---------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4fa19b9..f5f04ba 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1781,7 +1781,6 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 	u8 *frame;
 	u16 len, pad = 0;
 	u32 swheader;
-	struct sk_buff *new;
 	int i;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1795,26 +1794,14 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 			brcmf_dbg(INFO, "insufficient headroom %d for %d pad\n",
 				  skb_headroom(pkt), pad);
 			bus->sdiodev->bus_if->tx_realloc++;
-			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
-			if (!new) {
-				brcmf_err("couldn't allocate new %d-byte packet\n",
-					  pkt->len + BRCMF_SDALIGN);
-				ret = -ENOMEM;
+			ret = skb_cow(pkt, BRCMF_SDALIGN);
+			if (ret)
 				goto done;
-			}
-
-			pkt_align(new, pkt->len, BRCMF_SDALIGN);
-			memcpy(new->data, pkt->data, pkt->len);
-			brcmu_pkt_buf_free_skb(pkt);
-			pkt = new;
-			frame = (u8 *) (pkt->data);
-			/* precondition: (frame % BRCMF_SDALIGN) == 0) */
-			pad = 0;
-		} else {
-			skb_push(pkt, pad);
-			frame = (u8 *) (pkt->data);
-			memset(frame + SDPCM_HDRLEN, 0, pad);
+			pad = ((unsigned long)frame % BRCMF_SDALIGN);
 		}
+		skb_push(pkt, pad);
+		frame = (u8 *) (pkt->data);
+		memset(frame, 0, pad + SDPCM_HDRLEN);
 	}
 	/* precondition: pad < BRCMF_SDALIGN */
 
-- 
1.7.10.4


