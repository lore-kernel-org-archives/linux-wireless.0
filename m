Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49404 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdGZUqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:46:33 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 30/34] brcmfmac: Correctly handle accesses to SDIO func0
Date: Wed, 26 Jul 2017 21:25:53 +0100
Message-Id: <20170726202557.15632-31-ian@mnementh.co.uk> (sfid-20170726_224636_963060_B5FCD275)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
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
index 26b39f0ffdd4..95149c686c5f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -994,6 +994,10 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(SDIO, "Function#: %d\n", func->num);
 
 	dev = &func->dev;
+
+	/* Set MMC_QUIRK_LENIENT_FN0 for this card */
+	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+
 	/* prohibit ACPI power management for this device */
 	brcmf_sdiod_acpi_set_power_manageable(dev, 0);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 1ab95011adb0..8a976c89cf63 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -297,10 +297,10 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
 /* SDIO device register access interface */
 /* Functions for accessing SDIO Function 0 */
 #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
-	sdio_readb((sdiodev)->func[0], (addr), (r))
+	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
 
 #define brcmf_sdiod_func0_wb(sdiodev, addr, v, ret) \
-	sdio_writeb((sdiodev)->func[0], (v), (addr), (ret))
+	sdio_f0_writeb((sdiodev)->func[0], (v), (addr), (ret))
 
 /* Functions for accessing SDIO Function 1 */
 #define brcmf_sdiod_readb(sdiodev, addr, r) \
-- 
2.11.0
