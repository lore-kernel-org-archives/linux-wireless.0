Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:58116 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932655AbdHVLnR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:43:17 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 17/30] brcmfamc: remove unnecessary call to brcmf_sdiod_set_backplane_window()
Date: Tue, 22 Aug 2017 12:25:37 +0100
Message-Id: <20170822112550.60311-18-ian@mnementh.co.uk> (sfid-20170822_134324_817845_0A965EC4)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All functions that might require the window address changing call
brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
the window is not required.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 0d37c68637f2..cabfab9a02a2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -721,11 +721,6 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	dev_kfree_skb(pkt);
 
-	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdiod_set_backplane_window(sdiodev, sdiodev->sbwad))
-		brcmf_err("FAILED to set window back to 0x%x\n",
-			  sdiodev->sbwad);
-
 	sdio_release_host(sdiodev->func[1]);
 
 	return err;
-- 
2.11.0
