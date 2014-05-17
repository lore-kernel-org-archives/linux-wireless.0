Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38204 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaEQIwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:52:53 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so2024756wiw.14
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/22] staging: vt6656: PIPEnsControlOut remove camel case.
Date: Sat, 17 May 2014 09:50:21 +0100
Message-Id: <1400316639-4430-4-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105302_060973_A808D3AE)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice, byRequest,  wValue, wIndex, wLength, pbyBuffer, ntStatus

->

priv, request, value, index, length, buffer, status

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 5a466653..76fa19e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -61,23 +61,23 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
 
-int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
-		u16 wIndex, u16 wLength, u8 *pbyBuffer)
+int PIPEnsControlOut(struct vnt_private *priv, u8 request, u16 value,
+		u16 index, u16 length, u8 *buffer)
 {
-	int ntStatus = 0;
+	int status = 0;
 
-	if (pDevice->Flags & fMP_DISCONNECTED)
+	if (priv->Flags & fMP_DISCONNECTED)
 		return STATUS_FAILURE;
 
-	mutex_lock(&pDevice->usb_lock);
+	mutex_lock(&priv->usb_lock);
 
-	ntStatus = usb_control_msg(pDevice->usb,
-		usb_sndctrlpipe(pDevice->usb, 0), byRequest, 0x40, wValue,
-			wIndex, pbyBuffer, wLength, USB_CTL_WAIT);
+	status = usb_control_msg(priv->usb,
+		usb_sndctrlpipe(priv->usb, 0), request, 0x40, value,
+			index, buffer, length, USB_CTL_WAIT);
 
-	mutex_unlock(&pDevice->usb_lock);
+	mutex_unlock(&priv->usb_lock);
 
-	if (ntStatus < (int)wLength)
+	if (status < (int)length)
 		return STATUS_FAILURE;
 
 	return STATUS_SUCCESS;
-- 
1.9.1

