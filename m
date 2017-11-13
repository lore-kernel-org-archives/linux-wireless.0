Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52157 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755519AbdKMUgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 09/10] brcmfmac: Remove noisy debugging.
Date: Mon, 13 Nov 2017 21:35:46 +0100
Message-Id: <1510605347-7629-10-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213624_289726_E0C735E7)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

If you need debugging this low level, you're doing something wrong.
Remove these noisy debug statements so the code is more readable.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index e89e242..9a3f903 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -371,9 +371,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u8 data;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 1, &data);
-	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -386,9 +384,7 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u32 data;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
-	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -401,7 +397,6 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
 	retval = brcmf_sdiod_reg_write(sdiodev, addr, 1, &data);
 
 	if (ret)
@@ -413,7 +408,6 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
 	retval = brcmf_sdiod_reg_write(sdiodev, addr, 4, &data);
 
 	if (ret)
-- 
1.9.1
