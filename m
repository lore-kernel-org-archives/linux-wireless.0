Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35075 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967278AbdLSMr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:29 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 11/11] brcmfmac: rename brcmf_sdiod_buff_{read,write}() functions
Date: Tue, 19 Dec 2017 13:47:17 +0100
Message-Id: <1513687637-5555-12-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171219_134749_504143_2BDC453F)
In-Reply-To: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename functions to brcmf_sdio_skbuff_{read,write}() as we pass an
skbuff to this function.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 48 +++++++++++-----------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index a47b252..0b68240 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -292,24 +292,24 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev,
-				 struct sdio_func *func, u32 addr,
-				 struct sk_buff *pkt)
+static int brcmf_sdiod_skbuff_read(struct brcmf_sdio_dev *sdiodev,
+				   struct sdio_func *func, u32 addr,
+				   struct sk_buff *skb)
 {
 	unsigned int req_sz;
 	int err;
 
 	/* Single skb use the standard mmc interface */
-	req_sz = pkt->len + 3;
+	req_sz = skb->len + 3;
 	req_sz &= (uint)~3;
 
 	switch (func->num) {
 	case 1:
-		err = sdio_memcpy_fromio(func, ((u8 *)(pkt->data)), addr,
+		err = sdio_memcpy_fromio(func, ((u8 *)(skb->data)), addr,
 					 req_sz);
 		break;
 	case 2:
-		err = sdio_readsb(func, ((u8 *)(pkt->data)), addr, req_sz);
+		err = sdio_readsb(func, ((u8 *)(skb->data)), addr, req_sz);
 		break;
 	default:
 		/* bail out as things are really fishy here */
@@ -323,18 +323,18 @@ static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev,
 	return err;
 }
 
-static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev,
-				  struct sdio_func *func, u32 addr,
-				  struct sk_buff *pkt)
+static int brcmf_sdiod_skbuff_write(struct brcmf_sdio_dev *sdiodev,
+				    struct sdio_func *func, u32 addr,
+				    struct sk_buff *skb)
 {
 	unsigned int req_sz;
 	int err;
 
 	/* Single skb use the standard mmc interface */
-	req_sz = pkt->len + 3;
+	req_sz = skb->len + 3;
 	req_sz &= (uint)~3;
 
-	err = sdio_memcpy_toio(func, addr, ((u8 *)(pkt->data)), req_sz);
+	err = sdio_memcpy_toio(func, addr, ((u8 *)(skb->data)), req_sz);
 
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
@@ -550,7 +550,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 	addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr, pkt);
+	err = brcmf_sdiod_skbuff_read(sdiodev, sdiodev->func2, addr, pkt);
 
 done:
 	return err;
@@ -575,14 +575,14 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr,
-					    pktq->next);
+		err = brcmf_sdiod_skbuff_read(sdiodev, sdiodev->func2, addr,
+					      pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func2, addr,
-					    glom_skb);
+		err = brcmf_sdiod_skbuff_read(sdiodev, sdiodev->func2, addr,
+					      glom_skb);
 		if (err)
 			goto done;
 
@@ -623,8 +623,8 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!err)
-		err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func2, addr,
-					     mypkt);
+		err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr,
+					       mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
 
@@ -649,8 +649,8 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support) {
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func2,
-						     addr, skb);
+			err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2,
+						       addr, skb);
 			if (err)
 				break;
 		}
@@ -706,11 +706,11 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 		if (write) {
 			memcpy(pkt->data, data, dsize);
-			err = brcmf_sdiod_buff_write(sdiodev, sdiodev->func1,
-						     sdaddr, pkt);
+			err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func1,
+						       sdaddr, pkt);
 		} else {
-			err = brcmf_sdiod_buff_read(sdiodev, sdiodev->func1,
-						    sdaddr, pkt);
+			err = brcmf_sdiod_skbuff_read(sdiodev, sdiodev->func1,
+						      sdaddr, pkt);
 		}
 
 		if (err) {
-- 
1.9.1
