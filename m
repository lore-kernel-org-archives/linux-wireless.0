Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48004 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdGPLp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:45:26 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 05/21] brcmfmac: its ALWAYS 4.
Date: Sun, 16 Jul 2017 12:21:13 +0100
Message-Id: <20170716112129.10206-6-ian@mnementh.co.uk> (sfid-20170716_134530_646272_F97E2C57)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c   | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 1012df347c84..2b527d2a2f8a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -430,7 +430,7 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 }
 
 static int
-brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
+brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
 {
 	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
@@ -445,8 +445,7 @@ brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
 
 	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
 
-	if (width == 4)
-		*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	return 0;
 }
@@ -472,7 +471,7 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, sizeof(data), &data);
@@ -504,7 +503,7 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 
@@ -740,7 +739,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -761,7 +760,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
 		  addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -806,7 +805,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	memcpy(mypkt->data, buf, nbytes);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 
 	if (!err)
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
@@ -826,7 +825,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		return err;
 
-- 
2.11.0
