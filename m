Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:40844 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750819AbdKYUjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 15:39:44 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.15] brcmfmac: change driver unbind order of the sdio function devices
Date: Sat, 25 Nov 2017 21:39:25 +0100
Message-Id: <1511642376-16279-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171125_213948_571840_07F0E1A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the function brcmf_sdio_firmware_callback() the driver is
unbound from the sdio function devices in the error path.
However, the order in which it is done resulted in a use-after-free
issue (see brcmf_ops_sdio_remove() in bcmsdh.c). Hence change
the order and first unbind sdio function #2 device and then
unbind sdio function #1 device.

Cc: stable@vger.kernel.org # v4.12.x
Fixes: 7a51461fc2da ("brcmfmac: unbind all devices upon failure in firmware callback")
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index e3495ea..3108f7ee 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4121,8 +4121,8 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	sdio_release_host(sdiodev->func[1]);
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
-	device_release_driver(dev);
 	device_release_driver(&sdiodev->func[2]->dev);
+	device_release_driver(dev);
 }
 
 struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
-- 
1.9.1
