Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37520 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751412AbdE3MgK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 08:36:10 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFT 3/3] brcmfmac: unbind all devices upon failure in firmware callback
Date: Tue, 30 May 2017 13:35:54 +0100
Message-Id: <1496147754-2303-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170530_143620_972142_EF6DFEF2)
In-Reply-To: <1496147754-2303-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1496147754-2303-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_sdio_firmware_callback() we need to unbind the driver from
both sdio_func devices.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 270c0ad..a5b27a4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3988,14 +3988,14 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	u8 saveclk;
 
 	brcmf_dbg(TRACE, "Enter: dev=%s, err=%d\n", dev_name(dev), err);
+	bus_if = dev_get_drvdata(dev);
+	sdiodev = bus_if->bus_priv.sdio;
 	if (err)
 		goto fail;
 
-	bus_if = dev_get_drvdata(dev);
 	if (!bus_if->drvr)
 		return;
 
-	sdiodev = bus_if->bus_priv.sdio;
 	bus = sdiodev->bus;
 
 	/* try to download image and nvram to the dongle */
@@ -4084,6 +4084,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
 	device_release_driver(dev);
+	device_release_driver(&sdiodev->func[1]->dev);
 }
 
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
-- 
1.9.1
