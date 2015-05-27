Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:39635 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbbE0Rbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 13:31:51 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	"Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Subject: [PATCH] brcmfmac: fix invalid access to struct acpi_device fields
Date: Wed, 27 May 2015 19:31:41 +0200
Message-ID: <1432747901-8472-1-git-send-email-arend@broadcom.com> (sfid-20150527_193155_106073_789E2FC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fields of struct acpi_device are only known when CONFIG_ACPI is
defined. Fix this by using a helper function. This will resolve the
issue found in linux-next:

 ../brcmfmac/bcmsdh.c: In function 'brcmf_ops_sdio_probe':
 ../brcmfmac/bcmsdh.c:1139:7: error: dereferencing pointer to incomplete type
   adev->flags.power_manageable = 0;
       ^

Fixes: commit f0992ace680c ("brcmfmac: prohibit ACPI power management ...")
Cc: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index b0d0ff5..71779b9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1117,6 +1117,18 @@ MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 static struct brcmfmac_sdio_platform_data *brcmfmac_sdio_pdata;
 
 
+static void brcmf_sdiod_acpi_set_power_manageable(struct device *dev,
+						  int val)
+{
+#if IS_ENABLED(CONFIG_ACPI)
+	struct acpi_device *adev;
+
+	adev = ACPI_COMPANION(dev);
+	if (adev)
+		adev->flags.power_manageable = 0;
+#endif
+}
+
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
 				const struct sdio_device_id *id)
 {
@@ -1124,7 +1136,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
 	struct device *dev;
-	struct acpi_device *adev;
 
 	brcmf_dbg(SDIO, "Enter\n");
 	brcmf_dbg(SDIO, "Class=%x\n", func->class);
@@ -1132,11 +1143,9 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(SDIO, "sdio device ID: 0x%04x\n", func->device);
 	brcmf_dbg(SDIO, "Function#: %d\n", func->num);
 
-	/* prohibit ACPI power management for this device */
 	dev = &func->dev;
-	adev = ACPI_COMPANION(dev);
-	if (adev)
-		adev->flags.power_manageable = 0;
+	/* prohibit ACPI power management for this device */
+	brcmf_sdiod_acpi_set_power_manageable(dev, 0);
 
 	/* Consume func num 1 but dont do anything with it. */
 	if (func->num == 1)
-- 
1.9.1

