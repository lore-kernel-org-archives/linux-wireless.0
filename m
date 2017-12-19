Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35059 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967265AbdLSMr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:27 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 08/11] brcmfmac: Clean up interrupt macros
Date: Tue, 19 Dec 2017 13:47:14 +0100
Message-Id: <1513687637-5555-9-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171219_134800_928094_01BA29A7)
In-Reply-To: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Make it more obvious that this code acually enables interrupts, and
provide nice definitions for the bits in the register.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d357c5c..e3366ab 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -149,7 +149,8 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		/* must configure SDIO_CCCR_IENx to enable irq */
 		data = brcmf_sdiod_func0_rb(sdiodev, SDIO_CCCR_IENx, &ret);
-		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
+		data |= SDIO_CCCR_IEN_FUNC1 | SDIO_CCCR_IEN_FUNC2 |
+			SDIO_CCCR_IEN_FUNC0;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 54a0303..04661ec 100644
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
1.9.1
