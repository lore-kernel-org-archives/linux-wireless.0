Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42835 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaEQIwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:52:55 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so2009327wib.12
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/22] staging: vt6656: PIPEnsControlIn remove camel case.
Date: Sat, 17 May 2014 09:50:22 +0100
Message-Id: <1400316639-4430-5-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105301_427097_CE71A02B)
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
index 76fa19e..2dfa16e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -83,23 +83,23 @@ int PIPEnsControlOut(struct vnt_private *priv, u8 request, u16 value,
 	return STATUS_SUCCESS;
 }
 
-int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
-	u16 wIndex, u16 wLength, u8 *pbyBuffer)
+int PIPEnsControlIn(struct vnt_private *priv, u8 request, u16 value,
+		u16 index, u16 length, u8 *buffer)
 {
-	int ntStatus;
+	int status;
 
-	if (pDevice->Flags & fMP_DISCONNECTED)
+	if (priv->Flags & fMP_DISCONNECTED)
 		return STATUS_FAILURE;
 
-	mutex_lock(&pDevice->usb_lock);
+	mutex_lock(&priv->usb_lock);
 
-	ntStatus = usb_control_msg(pDevice->usb,
-		usb_rcvctrlpipe(pDevice->usb, 0), byRequest, 0xc0, wValue,
-			wIndex, pbyBuffer, wLength, USB_CTL_WAIT);
+	status = usb_control_msg(priv->usb,
+		usb_rcvctrlpipe(priv->usb, 0), request, 0xc0, value,
+			index, buffer, length, USB_CTL_WAIT);
 
-	mutex_unlock(&pDevice->usb_lock);
+	mutex_unlock(&priv->usb_lock);
 
-	if (ntStatus < (int)wLength)
+	if (status < (int)length)
 		return STATUS_FAILURE;
 
 	return STATUS_SUCCESS;
-- 
1.9.1

