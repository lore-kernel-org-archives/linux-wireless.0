Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:33926 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751202AbdGZU0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:26:15 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 06/34] brcmfmac: Remove bandaid for SleepCSR
Date: Wed, 26 Jul 2017 21:25:29 +0100
Message-Id: <20170726202557.15632-7-ian@mnementh.co.uk> (sfid-20170726_222630_600496_0E218A5B)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register access code is not the place for band-aid fixes like this.
If this is a genuine problem, it should be fixed further up in the driver
stack.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>

# Conflicts:
#	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 28 +---------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 609a934c1658..d217b1281e0d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -334,21 +334,8 @@ static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	} while (ret != 0 && ret != -ENOMEDIUM &&
 		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
-	if (ret == -ENOMEDIUM) {
+	if (ret == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
-	} else if (ret != 0) {
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
@@ -389,19 +376,6 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 
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
