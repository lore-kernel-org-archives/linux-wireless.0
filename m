Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:43793 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753079AbdLHMKq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:10:46 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 07/10] brcmfmac: remove unnecessary call to brcmf_sdiod_set_backplane_window()
Date: Fri,  8 Dec 2017 13:10:32 +0100
Message-Id: <1512735035-342-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171208_131059_185648_583CF12F)
In-Reply-To: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

All functions that might require the window address changing call
brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
the window is not required.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
[arend: corrected the driver prefix in the subject]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 5fcd193..f8b47c1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -723,11 +723,6 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	dev_kfree_skb(pkt);
 
-	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdiod_set_backplane_window(sdiodev, sdiodev->sbwad))
-		brcmf_err("FAILED to set window back to 0x%x\n",
-			  sdiodev->sbwad);
-
 	sdio_release_host(sdiodev->func[1]);
 
 	return err;
-- 
1.9.1
