Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:43774 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752883AbdLHMKo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:10:44 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 05/10] brcmfmac: Tidy register definitions a little
Date: Fri,  8 Dec 2017 13:10:30 +0100
Message-Id: <1512735035-342-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171208_131059_737162_2FFF4309)
In-Reply-To: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Trivial tidy of register definitions.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  4 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 608c5f8..e0b201f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -153,9 +153,9 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
 
 		/* redirect, configure and enable io for interrupt signal */
-		data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
+		data = SDIO_CCCR_BRCM_SEPINT_MASK | SDIO_CCCR_BRCM_SEPINT_OE;
 		if (pdata->oob_irq_flags & IRQF_TRIGGER_HIGH)
-			data |= SDIO_SEPINT_ACT_HI;
+			data |= SDIO_CCCR_BRCM_SEPINT_ACT_HI;
 		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_BRCM_SEPINT,
 				     data, &ret);
 		sdio_release_host(sdiodev->func[1]);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 453213b..01def16 100644
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
1.9.1
