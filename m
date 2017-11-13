Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52140 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755524AbdKMUgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 06/10] brcmfmac: Remove bandaid for SleepCSR
Date: Mon, 13 Nov 2017 21:35:43 +0100
Message-Id: <1510605347-7629-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213610_480447_FE8102BD)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Register access code is not the place for band-aid fixes like this.
If this is a genuine problem, it should be fixed further up in the driver
stack.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 28 +---------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index ad81ea4..355aebd 100644
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
1.9.1
