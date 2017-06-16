Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:51827 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753025AbdFPIgi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 04:36:38 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] brcmfmac: fix uninitialized warning in brcmf_usb_probe_phase2()
Date: Fri, 16 Jun 2017 09:36:35 +0100
Message-Id: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170616_103641_930733_E20148CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the following warning:

  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function
  'brcmf_usb_probe_phase2':
  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1198:2:
  warning: 'devinfo' may be used uninitialized in this function
  [-Wmaybe-uninitialized]
    mutex_unlock(&devinfo->dev_init_lock);

Fixes: 6d0507a777fb ("brcmfmac: add parameter to pass error code in firmware callback")
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

Here it is. Was indeed a valid warning.

Thanks,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 9ce3b55..8b16387 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1164,14 +1164,13 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
 				   void *nvram, u32 nvlen)
 {
 	struct brcmf_bus *bus = dev_get_drvdata(dev);
-	struct brcmf_usbdev_info *devinfo;
+	struct brcmf_usbdev_info *devinfo = bus->bus_priv.usb->devinfo;;
 
 	if (ret)
 		goto error;
 
 	brcmf_dbg(USB, "Start fw downloading\n");
 
-	devinfo = bus->bus_priv.usb->devinfo;
 	ret = check_file(fw->data);
 	if (ret < 0) {
 		brcmf_err("invalid firmware\n");
-- 
1.9.1
