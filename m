Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54286 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab1KUVpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 16:45:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtlwifi: squash warning in _usb_read_sync
Date: Mon, 21 Nov 2011 16:37:26 -0500
Message-Id: <1321911446-11564-1-git-send-email-linville@tuxdriver.com> (sfid-20111121_224542_100940_B1E08D22)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/rtlwifi/usb.c: In function ‘_usb_read_sync’:
drivers/net/wireless/rtlwifi/usb.c:102:6: warning: ‘status’ may be used uninitialized in this function
drivers/net/wireless/rtlwifi/usb.c:102:6: note: ‘status’ was declared here

My compiler is dumb, but better to eliminate the warning then to have
anyone waste time evaluating this again...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtlwifi/usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 79889b8..20f4403 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -107,7 +107,7 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
 	pipe = usb_rcvctrlpipe(udev, 0); /* read_in */
 	reqtype =  REALTEK_USB_VENQT_READ;
 
-	while (++vendorreq_times <= MAX_USBCTRL_VENDORREQ_TIMES) {
+	do {
 		status = usb_control_msg(udev, pipe, request, reqtype, value,
 					 index, pdata, len, 0); /*max. timeout*/
 		if (status < 0) {
@@ -118,7 +118,8 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
 		} else {
 			break;
 		}
-	}
+	} while (++vendorreq_times < MAX_USBCTRL_VENDORREQ_TIMES);
+
 	if (status < 0 && count++ < 4)
 		pr_err("reg 0x%x, usbctrl_vendorreq TimeOut! status:0x%x value=0x%x\n",
 		       value, status, le32_to_cpu(*(u32 *)pdata));
-- 
1.7.4.4

