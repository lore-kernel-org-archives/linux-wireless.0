Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52135 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755518AbdKMUgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 08/10] brcmfmac: Fix asymmetric IO functions.
Date: Mon, 13 Nov 2017 21:35:45 +0100
Message-Id: <1510605347-7629-9-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213624_584746_9E1FE2A1)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Unlikely to be a problem, but brcmf_sdiod_regrl() is
not symmetric with brcmf_sdiod_regrb() in initializing
the data value on stack. Fix that.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
[arend: reword the commit message a bit]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index bb2ebe6..e89e242 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -383,7 +383,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)

 u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
-	u32 data = 0;
+	u32 data;
 	int retval;

 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
--
1.9.1
