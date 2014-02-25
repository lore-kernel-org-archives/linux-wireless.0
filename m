Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39109 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaBYTaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:46 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/14] brcmfmac: reset suspend flag upon sdio suspend failure
Date: Tue, 25 Feb 2014 20:30:38 +0100
Message-ID: <1393356639-19169-15-git-send-email-arend@broadcom.com> (sfid-20140225_203053_317226_B803EA9B)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The suspend callback first sets the suspend flag used in the driver
but after that the actual suspend is done, which may fail. Reset the
flag upon suspend failure.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 3866209..2471e55 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1099,9 +1099,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	int ret = 0;
 
-	brcmf_dbg(SDIO, "\n");
-
-	atomic_set(&sdiodev->suspend, true);
+	brcmf_dbg(SDIO, "Enter\n");
 
 	sdio_flags = sdio_get_host_pm_caps(sdiodev->func[1]);
 	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
@@ -1109,9 +1107,12 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 		return -EINVAL;
 	}
 
+	atomic_set(&sdiodev->suspend, true);
+
 	ret = sdio_set_host_pm_flags(sdiodev->func[1], MMC_PM_KEEP_POWER);
 	if (ret) {
 		brcmf_err("Failed to set pm_flags\n");
+		atomic_set(&sdiodev->suspend, false);
 		return ret;
 	}
 
@@ -1125,6 +1126,7 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
+	brcmf_dbg(SDIO, "Enter\n");
 	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
 	atomic_set(&sdiodev->suspend, false);
 	return 0;
-- 
1.7.10.4

