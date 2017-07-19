Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:56202 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933714AbdGSTIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:08:43 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 09/34] brcmfmac: Remove noisy debugging.
Date: Wed, 19 Jul 2017 20:07:57 +0100
Message-Id: <20170719190822.10857-10-ian@mnementh.co.uk> (sfid-20170719_211035_840829_FB1D962C)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you need debugging this low level, you're doing something wrong.
Remove these noisy debug statements so the code is more readable.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9145dda11e5a..7dd6af689ac8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -372,9 +372,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u8 data = 0;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 1, &data);
-	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -387,8 +385,6 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u32 data = 0;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
 
 	if (ret)
@@ -402,7 +398,6 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
 	retval = brcmf_sdiod_reg_write(sdiodev, addr, 1, &data);
 
 	if (ret)
@@ -414,7 +409,7 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, 4, &data);
 
 	if (ret)
 		*ret = retval;
-- 
2.11.0
