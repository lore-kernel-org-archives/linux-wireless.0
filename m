Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fed1rmfepo202.cox.net ([68.230.241.147]:57107 "EHLO
        fed1rmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdFBWd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 18:33:57 -0400
Received: from fed1rmimpo109.cox.net ([68.230.241.158])
          by fed1rmfepo202.cox.net
          (InterMail vM.8.01.05.28 201-2260-151-171-20160122) with ESMTP
          id <20170602223356.UJQZ26070.fed1rmfepo202.cox.net@fed1rmimpo109.cox.net>
          for <linux-wireless@vger.kernel.org>;
          Fri, 2 Jun 2017 18:33:56 -0400
From: "Peter S. Housel" <housel@acm.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Christian Daudt <csd@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "Peter S. Housel" <housel@acm.org>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
Date: Fri,  2 Jun 2017 15:29:25 -0700
Message-Id: <1496442569-11307-1-git-send-email-housel@acm.org> (sfid-20170603_003427_823479_8C56F7CF)
In-Reply-To: <CA+8PC_e8HdkBw4DfGUPO0BbM-W5wftK=i6_vjwFTmS7=axyFUw@mail.gmail.com>
References: <CA+8PC_e8HdkBw4DfGUPO0BbM-W5wftK=i6_vjwFTmS7=axyFUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An earlier change to this function (3bdae810721b) fixed a leak in the
case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
glom_skb buffer, used for emulating a scattering read, is never used
or referenced after its contents are copied into the destination
buffers, and therefore always needs to be freed by the end of the
function.

Fixes: 3bdae810721b ("brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain")
Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")
Signed-off-by: Peter S. Housel <housel@acm.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9b970dc..30fb54e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -727,15 +727,13 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			return -ENOMEM;
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
 					 glom_skb);
-		if (err) {
-			brcmu_pkt_buf_free_skb(glom_skb);
-			goto done;
-		}
-
-		skb_queue_walk(pktq, skb) {
-			memcpy(skb->data, glom_skb->data, skb->len);
-			skb_pull(glom_skb, skb->len);
+		if (!err) {
+			skb_queue_walk(pktq, skb) {
+				memcpy(skb->data, glom_skb->data, skb->len);
+				skb_pull(glom_skb, skb->len);
+			}
 		}
+		brcmu_pkt_buf_free_skb(glom_skb);
 	} else
 		err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, false, addr,
 					    pktq);
-- 
2.7.4
