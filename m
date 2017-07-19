Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:59644 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755185AbdGSTNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:13:22 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 14/34] brcmfmac: Remove brcmf_sdiod_addrprep()
Date: Wed, 19 Jul 2017 20:08:02 +0100
Message-Id: <20170719190822.10857-15-ian@mnementh.co.uk> (sfid-20170719_211326_613653_13FF0B64)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function has become trivial enough that it may as well be pushed into
its callers, which has the side-benefit of clarifying what's going on.

Remove it, and rename brcmf_sdiod_set_sbaddr_window() to
brcmf_sdiod_set_backplane_window() as it's easier to understand.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 78 ++++++++++++----------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 13f20b58d34e..eb388b69418a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -229,41 +229,23 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 }
 
 static int
-brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
+brcmf_sdiod_set_backplane_window(struct brcmf_sdio_dev *sdiodev, u32 addr)
 {
+	u32 v, bar0 = addr & SBSDIO_SBWINDOW_MASK;
 	int err = 0, i;
-	u32 addr;
 
-	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
-		return -ENOMEDIUM;
-
-	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
+	if (bar0 == sdiodev->sbwad)
+		return 0;
 
-	for ( i = 0 ; i < 3 && !err ; i++, addr >>= 8 )
-		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
-					&err);
+	v = bar0 >> 8;
 
-	return err;
-}
-
-static int
-brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
-{
-	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
-	int err = 0;
-
-	if (bar0 != sdiodev->sbwad) {
-		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
-		if (err)
-			return err;
+	for (i = 0 ; i < 3 && !err ; i++, v>>=8)
+		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, v & 0xff, &err);
 
+	if(!err)
 		sdiodev->sbwad = bar0;
-	}
-
-	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
-	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return 0;
+	return err;
 }
 
 u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
@@ -271,11 +253,17 @@ u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u32 data = 0;
 	int retval;
 
-	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
+	retval = brcmf_sdiod_set_backplane_window(sdiodev, addr);
+	if (retval)
+		goto out;
+
+	addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!retval)
 		data = sdio_readl(sdiodev->func[1], addr, &retval);
 
+out:
 	if (ret)
 		*ret = retval;
 
@@ -287,11 +275,17 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
+	retval = brcmf_sdiod_set_backplane_window(sdiodev, addr);
+	if (retval)
+		goto out;
+
+	addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!retval)
 		sdio_writel(sdiodev->func[1], data, addr, &retval);
 
+out:
 	if (ret)
 		*ret = retval;
 }
@@ -539,10 +533,13 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
 
-	err = brcmf_sdiod_addrprep(sdiodev, &addr);
+	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
 	if (err)
 		goto done;
 
+	addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+
 	err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr, pkt);
 
 done:
@@ -560,10 +557,13 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
 		  addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, &addr);
+	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
 	if (err)
 		goto done;
 
+	addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+
 	if (pktq->qlen == 1)
 		err = brcmf_sdiod_buff_read(sdiodev, SDIO_FUNC_2, addr,
 					 pktq->next);
@@ -605,7 +605,12 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	memcpy(mypkt->data, buf, nbytes);
 
-	err = brcmf_sdiod_addrprep(sdiodev, &addr);
+	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
+	if (err)
+		return err;
+
+	addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	if (!err)
 		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
@@ -625,10 +630,13 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, &addr);
+	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
 	if (err)
 		return err;
 
+	addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+
 	if (pktq->qlen == 1 || !sdiodev->sg_support)
 		skb_queue_walk(pktq, skb) {
 			err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2,
@@ -672,7 +680,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	/* Do the transfer(s) */
 	while (size) {
 		/* Set the backplane window to include the start address */
-		err = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
+		err = brcmf_sdiod_set_backplane_window(sdiodev, address);
 		if (err)
 			break;
 
@@ -716,7 +724,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	dev_kfree_skb(pkt);
 
 	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdiod_set_sbaddr_window(sdiodev, sdiodev->sbwad))
+	if (brcmf_sdiod_set_backplane_window(sdiodev, sdiodev->sbwad))
 		brcmf_err("FAILED to set window back to 0x%x\n",
 			  sdiodev->sbwad);
 
-- 
2.11.0
