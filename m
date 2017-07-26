Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49560 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751466AbdGZUqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:46:46 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 14/34] brcmfmac: Remove brcmf_sdiod_addrprep()
Date: Wed, 26 Jul 2017 21:25:37 +0100
Message-Id: <20170726202557.15632-15-ian@mnementh.co.uk> (sfid-20170726_230043_727953_3C2778CA)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function has become trivial enough that it may as well be pushed into
its callers, which has the side-benefit of clarifying what's going on.

Remove it, and rename brcmf_sdiod_set_sbaddr_window() to
brcmf_sdiod_set_backplane_window() as it's easier to understand.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>

# Conflicts:
#	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 78 ++++++++++++----------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index b2945b463fd3..24775869aee4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -228,41 +228,25 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 	sdiodev->state = state;
 }
 
-static int brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev,
-					 u32 address)
+static int
+brcmf_sdiod_set_backplane_window(struct brcmf_sdio_dev *sdiodev, u32 addr)
 {
+	u32 v, bar0 = addr & SBSDIO_SBWINDOW_MASK;
 	int err = 0, i;
-	u32 addr;
 
-	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
-		return -ENOMEDIUM;
+	if (bar0 == sdiodev->sbwad)
+		return 0;
 
-	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
+	v = bar0 >> 8;
 
-	for (i = 0 ; i < 3 && !err ; i++, addr >>= 8)
+	for (i = 0 ; i < 3 && !err ; i++, v >>= 8)
 		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i,
-				   addr & 0xff, &err);
-
-	return err;
-}
-
-static int brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
-{
-	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
-	int err = 0;
-
-	if (bar0 != sdiodev->sbwad) {
-		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
-		if (err)
-			return err;
+				   v & 0xff, &err);
 
+	if (!err)
 		sdiodev->sbwad = bar0;
-	}
-
-	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
-	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return 0;
+	return err;
 }
 
 u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
@@ -270,11 +254,17 @@ u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
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
 
@@ -286,11 +276,17 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
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
@@ -538,10 +534,13 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 
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
@@ -559,10 +558,13 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
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
@@ -604,7 +606,12 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
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
@@ -624,10 +631,13 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
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
@@ -671,7 +681,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	/* Do the transfer(s) */
 	while (size) {
 		/* Set the backplane window to include the start address */
-		err = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
+		err = brcmf_sdiod_set_backplane_window(sdiodev, address);
 		if (err)
 			break;
 
@@ -714,7 +724,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	dev_kfree_skb(pkt);
 
 	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdiod_set_sbaddr_window(sdiodev, sdiodev->sbwad))
+	if (brcmf_sdiod_set_backplane_window(sdiodev, sdiodev->sbwad))
 		brcmf_err("FAILED to set window back to 0x%x\n",
 			  sdiodev->sbwad);
 
-- 
2.11.0
