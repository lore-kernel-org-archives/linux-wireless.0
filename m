Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fed1rmfepi103.cox.net ([68.230.241.134]:56245 "EHLO
        fed1rmfepi103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdFBRhs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 13:37:48 -0400
Received: from fed1rmimpo110.cox.net ([68.230.241.159])
          by fed1rmfepo102.cox.net
          (InterMail vM.8.01.05.28 201-2260-151-171-20160122) with ESMTP
          id <20170602172832.FKNF32620.fed1rmfepo102.cox.net@fed1rmimpo110.cox.net>
          for <linux-wireless@vger.kernel.org>;
          Fri, 2 Jun 2017 13:28:32 -0400
From: "Peter S. Housel" <housel@acm.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Christian Daudt <csd@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Peter S. Housel" <housel@acm.org>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
Date: Fri,  2 Jun 2017 10:22:21 -0700
Message-Id: <1496424146-10928-1-git-send-email-housel@acm.org> (sfid-20170602_193752_667588_915A71D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An earlier change to this function (3bdae810721b) fixed a leak in the
case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
glob_skb buffer, used for emulating a scattering read, is never used
or referenced after its contents are copied into the destination
buffers, and therefore always needs to be freed by the end of the
function.

Signed-off-by: Peter S. Housel <housel@acm.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9b970dc..4c5064f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -727,15 +727,16 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			return -ENOMEM;
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
 					 glom_skb);
-		if (err) {
-			brcmu_pkt_buf_free_skb(glom_skb);
-			goto done;
-		}
+		if (err)
+			goto free_glom_skb;
 
 		skb_queue_walk(pktq, skb) {
 			memcpy(skb->data, glom_skb->data, skb->len);
 			skb_pull(glom_skb, skb->len);
 		}
+
+free_glom_skb:
+		brcmu_pkt_buf_free_skb(glom_skb);
 	} else
 		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, false, addr,
 					    pktq);
-- 
2.7.4
