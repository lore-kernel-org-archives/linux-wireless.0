Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53281 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbbCRMZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/8] brcmfmac: avoid runtime-pm for sdio host controller
Date: Wed, 18 Mar 2015 13:25:21 +0100
Message-ID: <1426681528-15831-2-git-send-email-arend@broadcom.com> (sfid-20150318_132545_555596_F0DB0B9E)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several host controllers supporting runtime-pm are causing issues
with our sdio wireless cards because they disable the sdio interrupt
upon going into runtime suspend. This patch avoids that by doing
a pm_runtime_forbid() call during the probe. Tested with Sony Vaio
Duo 13 which uses sdhci-acpi host controller.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 4399530..9667b6a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -29,6 +29,7 @@
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/brcmfmac-sdio.h>
+#include <linux/pm_runtime.h>
 #include <linux/suspend.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -1006,6 +1007,7 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	sg_free_table(&sdiodev->sgtable);
 	sdiodev->sbwad = 0;
 
+	pm_runtime_allow(sdiodev->func[1]->card->host->parent);
 	return 0;
 }
 
@@ -1074,7 +1076,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		ret = -ENODEV;
 		goto out;
 	}
-
+	pm_runtime_forbid(host->parent);
 out:
 	if (ret)
 		brcmf_sdiod_remove(sdiodev);
-- 
1.9.1

