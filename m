Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35068 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967272AbdLSMr2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:28 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>
Subject: [PATCH 06/11] brcmfmac: More efficient and slightly easier to read fixup for 4339 chips
Date: Tue, 19 Dec 2017 13:47:12 +0100
Message-Id: <1513687637-5555-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171219_134754_211076_849B2C28)
In-Reply-To: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Its more efficient to test the register we're interested in first,
potentially avoiding two more comparisons, and therefore always avoiding
one comparison per call on all other chips.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
[arend: fix some checkpatch warnings]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 1aa2a79..12fc0b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3772,15 +3772,16 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 
 	val = brcmf_sdiod_readl(sdiodev, addr, NULL);
 
-	if ((sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
-	     sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
-	     addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
+	if (addr == CORE_CC_REG(SI_ENUM_BASE, chipid) &&
+	    (sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339 ||
+	     sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339)) {
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
 		if (rev >= 2) {
 			val &= ~CID_ID_MASK;
 			val |= BRCM_CC_4339_CHIP_ID;
 		}
 	}
+
 	return val;
 }
 
-- 
1.9.1
