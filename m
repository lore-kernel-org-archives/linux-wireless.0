Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:55696 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdGQQQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:16:49 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 05/29] brcmfmac: Remove dead IO code
Date: Mon, 17 Jul 2017 17:16:13 +0100
Message-Id: <20170717161637.4652-6-ian@mnementh.co.uk> (sfid-20170717_181735_392212_1226F4EF)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	The value passed to brcmf_sdiod_addrprep() is *always* 4
remove this parameter and the unused code to handle it.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index aee1ecb7260e..c3e909526a1d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -423,7 +423,7 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 }
 
 static int
-brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
+brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
 {
 	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
@@ -437,9 +437,7 @@ brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
 	}
 
 	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
-
-	if (width == 4)
-		*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	return 0;
 }
@@ -465,7 +463,7 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 
@@ -498,7 +496,7 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 
@@ -734,7 +732,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -755,7 +753,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
 		  addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -799,7 +797,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	memcpy(mypkt->data, buf, nbytes);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 
 	if (!err)
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
@@ -819,7 +817,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		return err;
 
-- 
2.11.0
