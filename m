Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:33948 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751420AbdGZU0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:26:17 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 09/34] brcmfmac: Remove noisy debugging.
Date: Wed, 26 Jul 2017 21:25:32 +0100
Message-Id: <20170726202557.15632-10-ian@mnementh.co.uk> (sfid-20170726_222622_789360_9B70C444)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you need debugging this low level, you're doing something wrong.
Remove these noisy debug statements so the code is more readable.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 73f2194a854f..049086f6db97 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -370,9 +370,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u8 data = 0;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 1, &data);
-	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -385,8 +383,6 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u32 data = 0;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
 
 	if (ret)
@@ -400,7 +396,6 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
 	retval = brcmf_sdiod_reg_write(sdiodev, addr, 1, &data);
 
 	if (ret)
@@ -412,7 +407,7 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, 4, &data);
 
 	if (ret)
 		*ret = retval;
-- 
2.11.0
