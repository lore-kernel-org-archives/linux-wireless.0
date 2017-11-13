Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52100 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755418AbdKMUgC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:02 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 04/10] brcmfmac: Clean up brcmf_sdiod_set_sbaddr_window()
Date: Mon, 13 Nov 2017 21:35:41 +0100
Message-Id: <1510605347-7629-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213607_656848_6BD1DB2C)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

This function sets the address of the IO window used for
SDIO accesses onto the backplane of the chip.

It currently uses 3 separate masks despite the full mask being
defined in the code already. Remove the separate masks and clean up.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c   | 17 +++++------------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h |  3 ---
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 3acc0ff..1ea42c3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -410,23 +410,16 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
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
-				  &err);
-		if (err) {
-			brcmf_err("failed at addr: 0x%0x\n",
-				  SBSDIO_FUNC1_SBADDRLOW + i);
-		}
-	}
+	for (i = 0 ; i < 3 && !err ; i++, addr >>= 8)
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i,
+				  addr & 0xff, &err);
 
 	return err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index f3da32f..e3b78db 100644
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
1.9.1
