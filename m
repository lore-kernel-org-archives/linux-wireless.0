Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:48962 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965537AbaFTUTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 16:19:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.16] brcmfmac: assign chip id and rev in bus interface after brcmf_usb_dlneeded
Date: Fri, 20 Jun 2014 22:19:25 +0200
Message-ID: <1403295565-21827-1-git-send-email-arend@broadcom.com> (sfid-20140620_221938_786815_70E59544)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_usb_dlneeded() queries the device to obtain the chip
id and revision. So assigning these in bus interface before the call
resulted in chip id and revision being zero. This was introduced by:

   commit 5b8045d484d0ef77d6aa9444023220c5671fa3fe
   Author: Arend van Spriel <arend@broadcom.com>
   Date:   Tue May 27 12:56:23 2014 +0200

       brcmfmac: use asynchronous firmware request in USB

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Found this issue during testing, which was introduced in 3.16-rc1 merge
window. Hence this patch applies to wireless/master.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 6db51a6..d06fcb0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1184,8 +1184,6 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->bus_priv.usb = bus_pub;
 	dev_set_drvdata(dev, bus);
 	bus->ops = &brcmf_usb_bus_ops;
-	bus->chip = bus_pub->devid;
-	bus->chiprev = bus_pub->chiprev;
 	bus->proto_type = BRCMF_PROTO_BCDC;
 	bus->always_use_fws_queue = true;
 
@@ -1194,6 +1192,9 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 		if (ret)
 			goto fail;
 	}
+	bus->chip = bus_pub->devid;
+	bus->chiprev = bus_pub->chiprev;
+
 	/* request firmware here */
 	brcmf_fw_get_firmwares(dev, 0, brcmf_usb_get_fwname(devinfo), NULL,
 			       brcmf_usb_probe_phase2);
-- 
1.7.9.5

