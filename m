Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:19552 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbbDNSKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:10:51 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/10] brcmfmac: fix sdio suspend and resume
Date: Tue, 14 Apr 2015 20:10:30 +0200
Message-ID: <1429035033-14076-8-git-send-email-arend@broadcom.com> (sfid-20150414_201120_532226_CC2383B8)
In-Reply-To: <1429035033-14076-1-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
changed the behaviour by removing the MMC_PM_KEEP_POWER flag for
non-wowl scenario, which needs to be restored. Another necessary
change is to mark the card as being non-removable. With this in place
the suspend resume test passes successfully doing:

 # echo devices > /sys/power/pm_test
 # echo mem > /sys/power/state

Note that power may still be switched off when system is going
in S3 state.

Reported-by: Fu, Zhonghui <<zhonghui.fu@linux.intel.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9b508bd..8a69544 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1011,6 +1011,14 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
+static void brcmf_sdiod_host_fixup(struct mmc_host *host)
+{
+	/* runtime-pm powers off the device */
+	pm_runtime_forbid(host->parent);
+	/* avoid removal detection upon resume */
+	host->caps |= MMC_CAP_NONREMOVABLE;
+}
+
 static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
 	struct sdio_func *func;
@@ -1076,7 +1084,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		ret = -ENODEV;
 		goto out;
 	}
-	pm_runtime_forbid(host->parent);
+	brcmf_sdiod_host_fixup(host);
 out:
 	if (ret)
 		brcmf_sdiod_remove(sdiodev);
@@ -1246,15 +1254,15 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 	brcmf_sdiod_freezer_on(sdiodev);
 	brcmf_sdio_wd_timer(sdiodev->bus, 0);
 
+	sdio_flags = MMC_PM_KEEP_POWER;
 	if (sdiodev->wowl_enabled) {
-		sdio_flags = MMC_PM_KEEP_POWER;
 		if (sdiodev->pdata->oob_irq_supported)
 			enable_irq_wake(sdiodev->pdata->oob_irq_nr);
 		else
-			sdio_flags = MMC_PM_WAKE_SDIO_IRQ;
-		if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
-			brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
+			sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
 	}
+	if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
+		brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
 	return 0;
 }
 
-- 
1.9.1

