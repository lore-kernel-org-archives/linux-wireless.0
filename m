Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:56162 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933720AbdGSTIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:08:40 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 06/34] brcmfmac: Remove bandaid for SleepCSR
Date: Wed, 19 Jul 2017 20:07:54 +0100
Message-Id: <20170719190822.10857-7-ian@mnementh.co.uk> (sfid-20170719_211042_336965_9317D144)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register access code is not the place for band-aid fixes like this.
If this is a genuine problem, it should be fixed further up in the driver
stack.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 26 ----------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index c3e909526a1d..7eb54539a85e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -334,19 +334,6 @@ static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
 
 	if (ret == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
-	else if (ret != 0) {
-		/*
-		 * SleepCSR register access can fail when
-		 * waking up the device so reduce this noise
-		 * in the logs.
-		 */
-		if (addr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("failed to write data F%d@0x%05x, err: %d\n",
-				  func, addr, ret);
-		else
-			brcmf_dbg(SDIO, "failed to write data F%d@0x%05x, err: %d\n",
-				  func, addr, ret);
-	}
 
 	return ret;
 }
@@ -387,19 +374,6 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 
 	if (ret == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
-	else if (ret != 0) {
-		/*
-		 * SleepCSR register access can fail when
-		 * waking up the device so reduce this noise
-		 * in the logs.
-		 */
-		if (addr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("failed to read data F%d@0x%05x, err: %d\n",
-				  func, addr, ret);
-		else
-			brcmf_dbg(SDIO, "failed to read data F%d@0x%05x, err: %d\n",
-				  func, addr, ret);
-	}
 
 	return ret;
 }
-- 
2.11.0
