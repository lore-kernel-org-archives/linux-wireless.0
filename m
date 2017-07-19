Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:56142 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933715AbdGSTIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:08:39 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 04/34] brcmfmac: Clean up brcmf_sdiod_set_sbaddr_window()
Date: Wed, 19 Jul 2017 20:07:52 +0100
Message-Id: <20170719190822.10857-5-ian@mnementh.co.uk> (sfid-20170719_211051_228772_BE712B79)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	This function sets the address of the IO window used for
SDIO accesses onto the backplane of the chip.

It currently uses 3 separate masks despite the full mask being
defined in the code already. Remove the separate masks and clean up.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 15 ++++-----------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   |  3 ---
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 5b9a21d6b6b2..aee1ecb7260e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -408,23 +408,16 @@ static int
 brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
 	int err = 0, i;
-	u8 addr[3];
+	u32 addr;
 
 	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
 		return -ENOMEDIUM;
 
-	addr[0] = (address >> 8) & SBSDIO_SBADDRLOW_MASK;
-	addr[1] = (address >> 16) & SBSDIO_SBADDRMID_MASK;
-	addr[2] = (address >> 24) & SBSDIO_SBADDRHIGH_MASK;
+	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
 
-	for (i = 0; i < 3; i++) {
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr[i],
+	for ( i = 0 ; i < 3 && !err ; i++, addr >>= 8 )
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
 					&err);
-		if (err) {
-			brcmf_err("failed at addr: 0x%0x\n",
-				  SBSDIO_FUNC1_SBADDRLOW + i);
-		}
-	}
 
 	return err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index f3da32fc6360..e3b78db331b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -133,9 +133,6 @@
 
 /* valid bits in SBSDIO_FUNC1_SBADDRxxx regs */
 
-#define SBSDIO_SBADDRLOW_MASK		0x80	/* Valid bits in SBADDRLOW */
-#define SBSDIO_SBADDRMID_MASK		0xff	/* Valid bits in SBADDRMID */
-#define SBSDIO_SBADDRHIGH_MASK		0xffU	/* Valid bits in SBADDRHIGH */
 /* Address bits from SBADDR regs */
 #define SBSDIO_SBWINDOW_MASK		0xffff8000
 
-- 
2.11.0
