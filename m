Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60056 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932427AbdHVLpZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:25 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 28/30] brcmfmac: Clean up interrupt macros
Date: Tue, 22 Aug 2017 12:25:48 +0100
Message-Id: <20170822112550.60311-29-ian@mnementh.co.uk> (sfid-20170822_134529_805526_68ED0AFA)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it more obvious that this code acually enables interrupts, and
provide nice definitions for the bits in the register.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 0cd081d732f9..75e9a70857e3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -148,7 +148,8 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		/* must configure SDIO_CCCR_IENx to enable irq */
 		data = brcmf_sdiod_func0_rb(sdiodev, SDIO_CCCR_IENx, &ret);
-		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
+		data |= SDIO_CCCR_IEN_FUNC1 | SDIO_CCCR_IEN_FUNC2 |
+			SDIO_CCCR_IEN_FUNC0;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 54a03036fccb..04661ecbf395 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -24,9 +24,6 @@
 /* Maximum number of I/O funcs */
 #define NUM_SDIO_FUNCS	3
 
-#define SDIO_FUNC_1		1
-#define SDIO_FUNC_2		2
-
 #define SDIOD_FBR_SIZE		0x100
 
 /* io_en */
@@ -52,6 +49,11 @@
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	BIT(2)
 #define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	BIT(3)
 
+/* Interrupt enable bits for each function */
+#define SDIO_CCCR_IEN_FUNC0			BIT(0)
+#define SDIO_CCCR_IEN_FUNC1			BIT(1)
+#define SDIO_CCCR_IEN_FUNC2			BIT(2)
+
 #define SDIO_CCCR_BRCM_CARDCTRL			0xf1
 #define SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	BIT(1)
 
-- 
2.11.0
