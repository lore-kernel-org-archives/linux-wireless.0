Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35081 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967246AbdLSMra (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:30 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 04/11] brcmfmac: Correctly handle accesses to SDIO func0
Date: Tue, 19 Dec 2017 13:47:10 +0100
Message-Id: <1513687637-5555-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171219_134748_949999_DC058D73)
In-Reply-To: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Rather than workaround the restrictions on func0 addressing in the
driver, set MMC_QUIRK_LENIENT_FN0

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 ++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 29a2d1e..b6d0757 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -995,6 +995,10 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(SDIO, "Function#: %d\n", func->num);
 
 	dev = &func->dev;
+
+	/* Set MMC_QUIRK_LENIENT_FN0 for this card */
+	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+
 	/* prohibit ACPI power management for this device */
 	brcmf_sdiod_acpi_set_power_manageable(dev, 0);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index ac5f814..d113c7d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -297,10 +297,10 @@ struct sdpcmd_regs {
 /* SDIO device register access interface */
 /* Accessors for SDIO Function 0 */
 #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
-	sdio_readb((sdiodev)->func[0], (addr), (r))
+	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
 
 #define brcmf_sdiod_func0_wb(sdiodev, addr, v, ret) \
-	sdio_writeb((sdiodev)->func[0], (v), (addr), (ret))
+	sdio_f0_writeb((sdiodev)->func[0], (v), (addr), (ret))
 
 /* Accessors for SDIO Function 1 */
 #define brcmf_sdiod_readb(sdiodev, addr, r) \
-- 
1.9.1
