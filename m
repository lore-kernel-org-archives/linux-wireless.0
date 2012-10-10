Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3419 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab2JJSNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:25 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 1/7] brcmfmac: handle all exceptions as an error.
Date: Wed, 10 Oct 2012 11:13:06 -0700
Message-ID: <1349892792-4792-2-git-send-email-frankyl@broadcom.com> (sfid-20121010_201330_972958_4D2CAFEB)
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

in brcmf_usb_probe_cb only return code ENOLINK was seen as an
error. This is wrong, all error codes should be returned to usb
subsystem.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index a2b4b1e..7a6dfdc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1339,7 +1339,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo,
 	}
 
 	ret = brcmf_bus_start(dev);
-	if (ret == -ENOLINK) {
+	if (ret) {
 		brcmf_dbg(ERROR, "dongle is not responding\n");
 		brcmf_detach(dev);
 		goto fail;
-- 
1.7.9.5


