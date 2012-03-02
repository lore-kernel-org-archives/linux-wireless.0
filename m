Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4366 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521Ab2CBV4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:17 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/7] brcm80211: fmac: remove unnecessary NULL pointer
 check
Date: Fri, 2 Mar 2012 22:55:45 +0100
Message-ID: <1330725351-3803-2-git-send-email-arend@broadcom.com> (sfid-20120302_225624_784326_B792304D)
In-Reply-To: <1330725351-3803-1-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_usb_up() the variable devinfo was checked for being
a NULL pointer, but this can not happen. Also the check was done
after dereferencing the pointer. This patch removes the check.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Kan Yan <kanyan@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index d4a9e8e..8616961 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -712,9 +712,6 @@ static int brcmf_usb_up(struct device *dev)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 	u16 ifnum;
 
-	if (devinfo == NULL)
-		return -EINVAL;
-
 	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_UP)
 		return 0;
 
-- 
1.7.5.4


