Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3071 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/13] brcmfmac: remove unused usb bmac model code.
Date: Wed, 19 Sep 2012 22:21:14 +0200
Message-ID: <1348086078-19183-10-git-send-email-arend@broadcom.com> (sfid-20120919_222151_586545_8650F367)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

clean up code.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index edb4311..246d06b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -134,8 +134,6 @@ struct brcmf_usbdev_info {
 	wait_queue_head_t ctrl_wait;
 	ulong ctl_op;
 
-	bool rxctl_deferrespok;
-
 	struct urb *bulk_urb; /* used for FW download */
 	struct urb *intr_urb; /* URB for interrupt endpoint */
 	int intr_size;          /* Size of interrupt message */
@@ -301,17 +299,9 @@ brcmf_usb_recv_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 	devinfo->ctl_read.wLength = cpu_to_le16p(&size);
 	devinfo->ctl_urb->transfer_buffer_length = size;
 
-	if (devinfo->rxctl_deferrespok) {
-		/* BMAC model */
-		devinfo->ctl_read.bRequestType = USB_DIR_IN
-			| USB_TYPE_VENDOR | USB_RECIP_INTERFACE;
-		devinfo->ctl_read.bRequest = DL_DEFER_RESP_OK;
-	} else {
-		/* full dongle model */
-		devinfo->ctl_read.bRequestType = USB_DIR_IN
-			| USB_TYPE_CLASS | USB_RECIP_INTERFACE;
-		devinfo->ctl_read.bRequest = 1;
-	}
+	devinfo->ctl_read.bRequestType = USB_DIR_IN
+		| USB_TYPE_CLASS | USB_RECIP_INTERFACE;
+	devinfo->ctl_read.bRequest = 1;
 
 	usb_fill_control_urb(devinfo->ctl_urb,
 		devinfo->usbdev,
@@ -1312,8 +1302,6 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 		brcmf_dbg(ERROR, "usb_alloc_urb (ctl) failed\n");
 		goto error;
 	}
-	devinfo->rxctl_deferrespok = 0;
-
 	devinfo->bulk_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!devinfo->bulk_urb) {
 		brcmf_dbg(ERROR, "usb_alloc_urb (bulk) failed\n");
-- 
1.7.9.5


