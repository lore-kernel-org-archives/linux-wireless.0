Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:55432 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932427AbdHVLlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:41:01 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 24/30] brcmfmac: Correctly handle accesses to SDIO func0
Date: Tue, 22 Aug 2017 12:25:44 +0100
Message-Id: <20170822112550.60311-25-ian@mnementh.co.uk> (sfid-20170822_134104_576404_D55840E4)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than workaround the restrictions on func0 addressing in the
driver, set MMC_QUIRK_LENIENT_FN0

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 ++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index eeddefeef9b9..5fa77f8c0abb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -992,6 +992,10 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(SDIO, "Function#: %d\n", func->num);
 
 	dev = &func->dev;
+
+	/* Set MMC_QUIRK_LENIENT_FN0 for this card */
+	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+
 	/* prohibit ACPI power management for this device */
 	brcmf_sdiod_acpi_set_power_manageable(dev, 0);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index ac5f814ff019..d113c7d814b6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -297,10 +297,10 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
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
2.11.0
