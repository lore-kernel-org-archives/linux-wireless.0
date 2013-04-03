Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2979 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760285Ab3DCKlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/25] brcmfmac: minor optimization of
 brcmf_sdbrcm_txpkt() function
Date: Wed, 3 Apr 2013 12:40:27 +0200
Message-ID: <1364985650-11719-3-git-send-email-arend@broadcom.com> (sfid-20130403_124304_484424_A5B5A2CA)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When taking care of packet alignment to 64-byte boundary padding may
be added between SDPCM header and CDC data. It clear both SDPCM header
space and padding space. Changed it to only clear padding space. In
filling the SDPCM header it uses unaligned access to set SDPCM software
header, but preceding code assures it is properly aligned.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Change-Id: Iad22f277f3496440ba4d2db771205714774570ac
Reviewed-on: http://lb-bun-88.bun.broadcom.com:8080/76
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 535a5eb..4fa19b9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1813,8 +1813,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 		} else {
 			skb_push(pkt, pad);
 			frame = (u8 *) (pkt->data);
-			/* precondition: pad + SDPCM_HDRLEN <= pkt->len */
-			memset(frame, 0, pad + SDPCM_HDRLEN);
+			memset(frame + SDPCM_HDRLEN, 0, pad);
 		}
 	}
 	/* precondition: pad < BRCMF_SDALIGN */
@@ -1830,8 +1829,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 	    (((pad +
 	       SDPCM_HDRLEN) << SDPCM_DOFFSET_SHIFT) & SDPCM_DOFFSET_MASK);
 
-	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
-	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
+	*(((__le32 *) frame) + 1) = cpu_to_le32(swheader);
+	*(((__le32 *) frame) + 2) = 0;
 
 #ifdef DEBUG
 	tx_packets[pkt->priority]++;
-- 
1.7.10.4


