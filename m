Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49576 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751522AbdGZUqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:46:47 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 11/34] brcmfmac: Split brcmf_sdiod_buffrw function up.
Date: Wed, 26 Jul 2017 21:25:34 +0100
Message-Id: <20170726202557.15632-12-ian@mnementh.co.uk> (sfid-20170726_230043_875200_502FEC2D)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function needs to be split up into separate read / write variants
for clarity.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>

# Conflicts:
#	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 69 +++++++++++++++-------
 1 file changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9d5716d0ad73..858ad2d8706b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -413,8 +413,8 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
-			     bool write, u32 addr, struct sk_buff *pkt)
+static int brcmf_sdiod_buff_read(struct brcmf_sdio_dev *sdiodev, uint fn,
+				 u32 addr, struct sk_buff *pkt)
 {
 	unsigned int req_sz;
 	int err;
@@ -423,18 +423,36 @@ static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	req_sz = pkt->len + 3;
 	req_sz &= (uint)~3;
 
-	if (write)
-		err = sdio_memcpy_toio(sdiodev->func[fn], addr,
-				       ((u8 *)(pkt->data)), req_sz);
-	else if (fn == 1)
-		err = sdio_memcpy_fromio(sdiodev->func[fn], ((u8 *)(pkt->data)),
-					 addr, req_sz);
+	if (fn == 1)
+		err = sdio_memcpy_fromio(sdiodev->func[fn],
+					 ((u8 *)(pkt->data)), addr, req_sz);
 	else
 		/* function 2 read is FIFO operation */
-		err = sdio_readsb(sdiodev->func[fn], ((u8 *)(pkt->data)), addr,
-				  req_sz);
+		err = sdio_readsb(sdiodev->func[fn],
+				  ((u8 *)(pkt->data)), addr, req_sz);
+
+	if (err == -ENOMEDIUM)
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
+
+	return err;
+}
+
+static int brcmf_sdiod_buff_write(struct brcmf_sdio_dev *sdiodev, uint fn,
+				  u32 addr, struct sk_buff *pkt)
+{
+	unsigned int req_sz;
+	int err;
+
+	/* Single skb use the standard mmc interface */
+	req_sz = pkt->len + 3;
+	req_sz &= (uint)~3;
+
+	err = sdio_memcpy_toio(sdiodev->func[fn], addr,
+			       ((u8 *)(pkt->data)), req_sz);
+
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
+
 	return err;
 }
 
@@ -642,7 +660,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 	if (err)
 		goto done;
 
-	err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr, pkt);
+	err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr, pkt);
 
 done:
 	return err;
@@ -664,14 +682,14 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 		goto done;
 
 	if (pktq->qlen == 1)
-		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
-					 pktq->next);
+		err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr,
+					    pktq->next);
 	else if (!sdiodev->sg_support) {
 		glom_skb = brcmu_pkt_buf_get_skb(totlen);
 		if (!glom_skb)
 			return -ENOMEM;
-		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
-					 glom_skb);
+		err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr,
+					    glom_skb);
 		if (err)
 			goto done;
 
@@ -695,6 +713,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
+
 	if (!mypkt) {
 		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
@@ -706,10 +725,10 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 
 	if (!err)
-		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
-					 mypkt);
+		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
+
 	return err;
 
 }
@@ -729,8 +748,8 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
-			err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true,
-						 addr, skb);
+			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2,
+						     addr, skb);
 			if (err)
 				break;
 		}
@@ -782,10 +801,16 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		sdaddr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 		skb_put(pkt, dsize);
-		if (write)
+
+		if (write) {
 			memcpy(pkt->data, data, dsize);
-		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write, sdaddr,
-					 pkt);
+			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_1,
+						     sdaddr, pkt);
+		} else {
+			err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_1,
+						    sdaddr, pkt);
+		}
+
 		if (err) {
 			brcmf_err("membytes transfer failed\n");
 			break;
-- 
2.11.0
