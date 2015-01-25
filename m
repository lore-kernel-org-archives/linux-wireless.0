Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:40587 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbbAYTbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:48 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/14] brcmfmac: do not load firmware when device is already running
Date: Sun, 25 Jan 2015 20:31:37 +0100
Message-ID: <1422214303-7816-9-git-send-email-arend@broadcom.com> (sfid-20150125_203238_680348_96603FE5)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_usb_probe_cb() the device is checked to determine whether
it is already running firmware. However, when no firmware download
is needed it still continues to request the firmware files. This
is fixed by returning after successful setup.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 7e0c9e2..1b95729 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1263,6 +1263,8 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 		ret = brcmf_usb_bus_setup(devinfo);
 		if (ret)
 			goto fail;
+		/* we are done */
+		return 0;
 	}
 	bus->chip = bus_pub->devid;
 	bus->chiprev = bus_pub->chiprev;
-- 
1.9.1

