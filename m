Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35582 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1KQSPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 13:15:16 -0500
Received: by ggnb2 with SMTP id b2so1421463ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 10:15:16 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: George <george0505@realtek.com>, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/4] rtlwifi: rtl8192cu: Allow retries for USB I/O
Date: Thu, 17 Nov 2011 12:14:42 -0600
Message-Id: <1321553685-31154-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111117_191523_061051_3D6AA7DC)
In-Reply-To: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George <george0505@realtek.com>

The USB driver does not retry reads - allow 10 tries.

Signed-off-by: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                |   18 +++++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
index 3d5823c..fcc4032 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
@@ -32,7 +32,7 @@
 
 #define FW_8192C_SIZE				0x3000
 #define FW_8192C_START_ADDRESS			0x1000
-#define FW_8192C_END_ADDRESS			0x3FFF
+#define FW_8192C_END_ADDRESS			0x1FFF
 #define FW_8192C_PAGE_SIZE			4096
 #define FW_8192C_POLLING_DELAY			5
 #define FW_8192C_POLLING_TIMEOUT_COUNT		100
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 54cb8a6..add29e9 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -34,6 +34,7 @@
 #include "usb.h"
 #include "base.h"
 #include "ps.h"
+#include "rtl8192c/fw_common.h"
 
 #define	REALTEK_USB_VENQT_READ			0xC0
 #define	REALTEK_USB_VENQT_WRITE			0x40
@@ -41,6 +42,7 @@
 #define	REALTEK_USB_VENQT_CMD_IDX		0x00
 
 #define REALTEK_USB_VENQT_MAX_BUF_SIZE		254
+#define MAX_USBCTRL_VENDORREQ_TIMES		10
 
 static void usbctrl_async_callback(struct urb *urb)
 {
@@ -100,13 +102,23 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
 	unsigned int pipe;
 	int status;
 	u8 reqtype;
+	int vendorreq_times = 0;
 
 	pipe = usb_rcvctrlpipe(udev, 0); /* read_in */
 	reqtype =  REALTEK_USB_VENQT_READ;
 
-	status = usb_control_msg(udev, pipe, request, reqtype, value, index,
-				 pdata, len, 0); /* max. timeout */
-
+	while (++vendorreq_times <= MAX_USBCTRL_VENDORREQ_TIMES) {
+		status = usb_control_msg(udev, pipe, request, reqtype, value,
+					 index, pdata, len, 0); /*max. timeout*/
+		if (status < 0) {
+			/* firmware download is checksumed, don't retry */
+			if ((value >= FW_8192C_START_ADDRESS &&
+			    value <= FW_8192C_END_ADDRESS))
+				break;
+		} else {
+			break;
+		}
+	}
 	if (status < 0)
 		pr_err("reg 0x%x, usbctrl_vendorreq TimeOut! status:0x%x value=0x%x\n",
 		       value, status, *(u32 *)pdata);
-- 
1.7.7

