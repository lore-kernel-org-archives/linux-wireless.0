Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60132 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932550AbdHVLpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:30 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 26/30] brcmfmac: More efficient and slightly easier to read fixup for 4339 chips
Date: Tue, 22 Aug 2017 12:25:46 +0100
Message-Id: <20170822112550.60311-27-ian@mnementh.co.uk> (sfid-20170822_134534_014038_CB8FF014)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Its more efficient to test the register we're interested in first,
potentially avoiding two more comparisons, and therefore always avoiding
one comparison per call on all other chips.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 7ebe6460cb5c..8a730133db77 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3766,15 +3766,18 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	/* Force 4339 chips over rev2 to use the same ID */
 	/* This is borderline tolerable whilst there is only two exceptions */
 	/* But could be handled better */
-	if ((sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
-	     sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
-	     addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
+	if (addr == CORE_CC_REG(SI_ENUM_BASE, chipid) && 
+	    (sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339 ||
+	     sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339)) {
+
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
+
 		if (rev >= 2) {
 			val &= ~CID_ID_MASK;
 			val |= BRCM_CC_4339_CHIP_ID;
 		}
 	}
+
 	return val;
 }
 
-- 
2.11.0
