Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4490 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab2JVRgi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:38 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 05/14] brcmfmac: clean usb download code.
Date: Mon, 22 Oct 2012 10:36:18 -0700
Message-ID: <1350927387-25608-6-git-send-email-frankyl@broadcom.com> (sfid-20121022_193707_596630_56D55BBF)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

reuse ioctl waiting method.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   41 +++++--------------------
 1 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 7a6dfdc..484a6e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -42,7 +42,6 @@
 
 #define IOCTL_RESP_TIMEOUT  2000
 
-#define BRCMF_USB_SYNC_TIMEOUT		300	/* ms */
 #define BRCMF_USB_DLIMAGE_SPINWAIT	100	/* in unit of ms */
 #define BRCMF_USB_DLIMAGE_LIMIT		500	/* spinwait limit (ms) */
 
@@ -116,10 +115,6 @@ struct brcmf_usbdev_info {
 	u8 *image;	/* buffer for combine fw and nvram */
 	int image_len;
 
-	wait_queue_head_t wait;
-	bool waitdone;
-	int sync_urb_status;
-
 	struct usb_device *usbdev;
 	struct device *dev;
 
@@ -131,7 +126,6 @@ struct brcmf_usbdev_info {
 	int ctl_urb_status;
 	int ctl_completed;
 	wait_queue_head_t ioctl_resp_wait;
-	wait_queue_head_t ctrl_wait;
 	ulong ctl_op;
 
 	struct urb *bulk_urb; /* used for FW download */
@@ -754,34 +748,14 @@ static void brcmf_usb_down(struct device *dev)
 	brcmf_usb_free_q(&devinfo->rx_postq, true);
 }
 
-static int
-brcmf_usb_sync_wait(struct brcmf_usbdev_info *devinfo, u16 time)
-{
-	int ret;
-	int err = 0;
-	int ms = time;
-
-	ret = wait_event_interruptible_timeout(devinfo->wait,
-		devinfo->waitdone == true, (ms * HZ / 1000));
-
-	if ((devinfo->waitdone == false) || (devinfo->sync_urb_status)) {
-		brcmf_dbg(ERROR, "timeout(%d) or urb err=%d\n",
-			  ret, devinfo->sync_urb_status);
-		err = -EINVAL;
-	}
-	devinfo->waitdone = false;
-	return err;
-}
-
 static void
 brcmf_usb_sync_complete(struct urb *urb)
 {
 	struct brcmf_usbdev_info *devinfo =
 			(struct brcmf_usbdev_info *)urb->context;
 
-	devinfo->waitdone = true;
-	wake_up_interruptible(&devinfo->wait);
-	devinfo->sync_urb_status = urb->status;
+	devinfo->ctl_completed = true;
+	brcmf_usb_ioctl_resp_wake(devinfo);
 }
 
 static bool brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
@@ -813,6 +787,7 @@ static bool brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
 		(void *) tmpbuf, size,
 		(usb_complete_t)brcmf_usb_sync_complete, devinfo);
 
+	devinfo->ctl_completed = false;
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "usb_submit_urb failed %d\n", ret);
@@ -820,11 +795,11 @@ static bool brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
 		return false;
 	}
 
-	ret = brcmf_usb_sync_wait(devinfo, BRCMF_USB_SYNC_TIMEOUT);
+	ret = brcmf_usb_ioctl_resp_wait(devinfo);
 	memcpy(buffer, tmpbuf, buflen);
 	kfree(tmpbuf);
 
-	return (ret == 0);
+	return ret;
 }
 
 static bool
@@ -918,13 +893,14 @@ brcmf_usb_dl_send_bulk(struct brcmf_usbdev_info *devinfo, void *buffer, int len)
 
 	devinfo->bulk_urb->transfer_flags |= URB_ZERO_PACKET;
 
+	devinfo->ctl_completed = false;
 	ret = usb_submit_urb(devinfo->bulk_urb, GFP_ATOMIC);
 	if (ret) {
 		brcmf_dbg(ERROR, "usb_submit_urb failed %d\n", ret);
 		return ret;
 	}
-	ret = brcmf_usb_sync_wait(devinfo, BRCMF_USB_SYNC_TIMEOUT);
-	return ret;
+	ret = brcmf_usb_ioctl_resp_wait(devinfo);
+	return (ret == 0);
 }
 
 static int
@@ -1284,7 +1260,6 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 		goto error;
 	}
 
-	init_waitqueue_head(&devinfo->wait);
 	if (!brcmf_usb_dlneeded(devinfo))
 		return &devinfo->bus_pub;
 
-- 
1.7.6


