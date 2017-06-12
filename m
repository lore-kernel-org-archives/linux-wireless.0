Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:58688 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751746AbdFLKqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 06:46:32 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, "Peter S. Housel" <housel@acm.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
Date: Mon, 12 Jun 2017 11:46:22 +0100
Message-Id: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170612_124634_738486_3547EF8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Peter S. Housel" <housel@acm.org>

An earlier change to this function (3bdae810721b) fixed a leak in the
case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
glom_skb buffer, used for emulating a scattering read, is never used
or referenced after its contents are copied into the destination
buffers, and therefore always needs to be freed by the end of the
function.

Fixes: 3bdae810721b ("brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain")
Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")
Signed-off-by: Peter S. Housel <housel@acm.org>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 changes:
  V2:
   - avoid goto using if (!err) {}.
  V3:
   - free glom_skb at done label.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9b970dc..844c1e6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -706,7 +706,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			   struct sk_buff_head *pktq, uint totlen)
 {
-	struct sk_buff *glom_skb;
+	struct sk_buff *glom_skb = NULL;
 	struct sk_buff *skb;
 	u32 addr = sdiodev->sbwad;
 	int err = 0;
@@ -727,10 +727,8 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			return -ENOMEM;
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
 					 glom_skb);
-		if (err) {
-			brcmu_pkt_buf_free_skb(glom_skb);
+		if (err)
 			goto done;
-		}
 
 		skb_queue_walk(pktq, skb) {
 			memcpy(skb->data, glom_skb->data, skb->len);
@@ -741,6 +739,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 					    pktq);
 
 done:
+	brcmu_pkt_buf_free_skb(glom_skb);
 	return err;
 }
 
-- 
1.9.1
