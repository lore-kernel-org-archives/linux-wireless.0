Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:55720 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdGQQQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:16:52 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 08/29] brcmfmac: Fix uninitialised variable
Date: Mon, 17 Jul 2017 17:16:16 +0100
Message-Id: <20170717161637.4652-9-ian@mnementh.co.uk> (sfid-20170717_181656_539749_D3F6E809)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Unlikely to be a problem, but brcmf_sdiod_regrb() is
not symmetric with brcmf_sdiod_regrl() in this regard.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 6df12430a43f..9145dda11e5a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -369,7 +369,7 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 
 u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
-	u8 data;
+	u8 data = 0;
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-- 
2.11.0
