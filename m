Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:35176 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932587AbdHVL0V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:26:21 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 09/30] brcmfmac: Remove noisy debugging.
Date: Tue, 22 Aug 2017 12:25:29 +0100
Message-Id: <20170822112550.60311-10-ian@mnementh.co.uk> (sfid-20170822_133252_846799_D425FF29)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you need debugging this low level, you're doing something wrong.
Remove these noisy debug statements so the code is more readable.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 074dc10b5ac5..6669e28279d9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -370,9 +370,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u8 data;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 1, &data);
-	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -385,9 +383,7 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u32 data;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
-	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -400,7 +396,6 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
 	retval = brcmf_sdiod_reg_write(sdiodev, addr, 1, &data);
 
 	if (ret)
@@ -412,7 +407,6 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
 	retval = brcmf_sdiod_reg_write(sdiodev, addr, 4, &data);
 
 	if (ret)
-- 
2.11.0
