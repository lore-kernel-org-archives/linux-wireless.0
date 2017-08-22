Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60260 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932631AbdHVLpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:40 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 15/30] brcmfmac: Tidy register definitions a little
Date: Tue, 22 Aug 2017 12:25:35 +0100
Message-Id: <20170822112550.60311-16-ian@mnementh.co.uk> (sfid-20170822_134602_248356_F8EE8240)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial tidy of register definitions.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  4 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 50f207bb3dc6..721c7bd9478f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -152,9 +152,9 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
-		data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
+		data = SDIO_CCCR_BRCM_SEPINT_MASK | SDIO_CCCR_BRCM_SEPINT_OE;
 		if (pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
-			data |= SDIO_SEPINT_ACT_HI;
+			data |= SDIO_CCCR_BRCM_SEPINT_ACT_HI;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
 		sdio_release_host(sdiodev->func[1]);
 	} else {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 453213b071de..01def16cd236 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -52,16 +52,17 @@
 /* function 0 vendor specific CCCR registers */
 
 #define SDIO_CCCR_BRCM_CARDCAP			0xf0
-#define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
-#define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
-#define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	0x08
-#define SDIO_CCCR_BRCM_CARDCTRL		0xf1
-#define SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	0x02
-#define SDIO_CCCR_BRCM_SEPINT			0xf2
+#define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	BIT(1)
+#define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	BIT(2)
+#define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	BIT(3)
+
+#define SDIO_CCCR_BRCM_CARDCTRL			0xf1
+#define SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	BIT(1)
 
-#define  SDIO_SEPINT_MASK		0x01
-#define  SDIO_SEPINT_OE			0x02
-#define  SDIO_SEPINT_ACT_HI		0x04
+#define SDIO_CCCR_BRCM_SEPINT			0xf2
+#define SDIO_CCCR_BRCM_SEPINT_MASK		BIT(0)
+#define SDIO_CCCR_BRCM_SEPINT_OE		BIT(1)
+#define SDIO_CCCR_BRCM_SEPINT_ACT_HI		BIT(2)
 
 /* function 1 miscellaneous registers */
 
-- 
2.11.0
