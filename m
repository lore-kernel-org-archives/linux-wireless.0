Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46230 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbdGPLnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:43:09 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 01/21] net: brcmfmac: Write function depends on size of regs not types.
Date: Sun, 16 Jul 2017 12:21:09 +0100
Message-Id: <20170716112129.10206-2-ian@mnementh.co.uk> (sfid-20170716_134314_309485_1FDE1424)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The choice of read/write function depends on the size of the
device registers, not compipler types.


Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9b970dc2b922..fd398d27a30c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -266,7 +266,7 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 	func = sdiodev->func[fn];
 
 	switch (regsz) {
-	case sizeof(u8):
+	case 1:
 		if (write) {
 			if (fn)
 				sdio_writeb(func, *(u8 *)data, addr, &ret);
@@ -280,13 +280,13 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 				*(u8 *)data = sdio_f0_readb(func, addr, &ret);
 		}
 		break;
-	case sizeof(u16):
+	case 2:
 		if (write)
 			sdio_writew(func, *(u16 *)data, addr, &ret);
 		else
 			*(u16 *)data = sdio_readw(func, addr, &ret);
 		break;
-	case sizeof(u32):
+	case 4:
 		if (write)
 			sdio_writel(func, *(u32 *)data, addr, &ret);
 		else
-- 
2.11.0
