Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:51778 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3LLK7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:16 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/18] brcmfmac: remove brcmf_sdio_wdtimer_enable() function
Date: Thu, 12 Dec 2013 11:58:57 +0100
Message-ID: <1386845946-9859-10-git-send-email-arend@broadcom.com> (sfid-20131212_122500_874346_B18EDD68)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using the brcmf_sdio_wdtimer_enable() function
call brcmf_sdbrcm_wd_timer() directly.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index a56a779..2decb41 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1122,14 +1122,6 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static void brcmf_sdio_wdtmr_enable(struct brcmf_sdio_dev *sdiodev, bool enable)
-{
-	if (enable)
-		brcmf_sdbrcm_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
-	else
-		brcmf_sdbrcm_wd_timer(sdiodev->bus, 0);
-}
-
 static int brcmf_sdio_suspend(struct device *dev)
 {
 	mmc_pm_flag_t sdio_flags;
@@ -1153,7 +1145,7 @@ static int brcmf_sdio_suspend(struct device *dev)
 		return ret;
 	}
 
-	brcmf_sdio_wdtmr_enable(sdiodev, false);
+	brcmf_sdbrcm_wd_timer(sdiodev->bus, 0);
 
 	return ret;
 }
@@ -1163,7 +1155,7 @@ static int brcmf_sdio_resume(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
-	brcmf_sdio_wdtmr_enable(sdiodev, true);
+	brcmf_sdbrcm_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
 	atomic_set(&sdiodev->suspend, false);
 	return 0;
 }
-- 
1.7.10.4

