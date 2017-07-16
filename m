Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:47984 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLpX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:45:23 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 03/21] bcmfmac: simplify brcmf_sdiod_abort
Date: Sun, 16 Jul 2017 12:21:11 +0100
Message-Id: <20170716112129.10206-4-ian@mnementh.co.uk> (sfid-20170716_134527_487878_443B65EF)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index dadbba2f82ed..6ff4f10e36bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -872,12 +872,11 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 {
-	char t_func = (char)fn;
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
-	brcmf_sdiod_request_data(sdiodev, SDIO_FUNC_0, SDIO_CCCR_ABORT,
-				 sizeof(t_func), &t_func, true);
+	brcmf_sdiod_f0_writeb(sdiodev->func[0], (u8)fn, SDIO_CCCR_ABORT);
+
 
 	brcmf_dbg(SDIO, "Exit\n");
 	return 0;
-- 
2.11.0
