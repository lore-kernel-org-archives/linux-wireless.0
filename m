Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:50534 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdGQQsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:48:41 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 15/29] brcmfamc: remove unnecessary call to brcmf_sdiod_set_backplane_window()
Date: Mon, 17 Jul 2017 17:16:23 +0100
Message-Id: <20170717161637.4652-16-ian@mnementh.co.uk> (sfid-20170717_184851_507370_923D6A36)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
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
index eb388b69418a..ab015bad02f2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -723,11 +723,6 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
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
