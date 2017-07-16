Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46898 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLoO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:44:14 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 10/21] brcmfmac: Further SDIO addressing cleanup
Date: Sun, 16 Jul 2017 12:21:18 +0100
Message-Id: <20170716112129.10206-11-ian@mnementh.co.uk> (sfid-20170716_134417_984970_513B7383)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 39 +++++++++-------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 84ae67c11970..5214556465d1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -232,19 +232,23 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 }
 
 static int
-brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
+brcmf_sdiod_set_backplane_window(struct brcmf_sdio_dev *sdiodev, u32 addr)
 {
+	u32 a, bar0 = addr & SBSDIO_SBWINDOW_MASK;
 	int err = 0, i;
-	u32 addr;
 
-	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
+	if (bar0 == sdiodev->sbwad)
+		return 0;
 
-	for (i = 0 ; i < 3 && !err ; i++) {
-		u8 data = addr & 0xff;
-		addr = addr >> 8;
 
-		brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, data, &err);
-	}
+	a = bar0 >> 8;
+
+	for (i = 0 ; i < 3 && !err ; i++, a>>=8)
+		brcm_sdio_func1_wb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, a & 0xff, &err);
+
+
+	if(!err)
+		sdiodev->sbwad = bar0;
 
 	return err;
 }
@@ -257,17 +261,11 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 static int
 brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
 {
-	uint bar0 = *addr & SBSDIO_SBWINDOW_MASK;
 	int err = 0;
 
-	if (bar0 != sdiodev->sbwad) {
-		printk("WTAF? %08x %08x\n", bar0, sdiodev->sbwad);
-		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
-		if (err)
-			return err;
-
-		sdiodev->sbwad = bar0;
-	}
+	err = brcmf_sdiod_set_backplane_window(sdiodev, *addr);
+	if (err)
+		return err;
 
 	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
 	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
@@ -699,7 +697,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	while (size) {
 
 		/* Set the backplane window to include the start address */
-		err = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
+		err = brcmf_sdiod_set_backplane_window(sdiodev, address);
 		if (err)
 			break;
 
@@ -743,11 +741,6 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	dev_kfree_skb(pkt);
 
-	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdiod_set_sbaddr_window(sdiodev, sdiodev->sbwad))
-		brcmf_err("FAILED to set window back to 0x%x\n",
-			  sdiodev->sbwad);
-
 	sdio_release_host(sdiodev->func[1]);
 
 	return err;
-- 
2.11.0
