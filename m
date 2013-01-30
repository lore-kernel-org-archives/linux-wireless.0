Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47943 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3A3UHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 15:07:37 -0500
Received: by mail-wi0-f174.google.com with SMTP id hj13so3357886wib.13
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 12:07:35 -0800 (PST)
Message-ID: <1359576449.5463.8.camel@canaries64> (sfid-20130130_210740_488624_8BACB697)
Subject: [PATCH] staging: vt6656: [BUG] Fix URB submitted while active
 warning.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 Jan 2013 20:07:29 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This error happens because PIPEnsControlOut and PIPEnsControlIn unlock the
spin lock for delay, letting in another thread.

The patch moves the current MP_SET_FLAG to before filling
of sUsbCtlRequest for pControlURB and clears it in event of failing.

Any thread calling either function while fMP_CONTROL_READS or fMP_CONTROL_WRITES
flags set will return STATUS_FAILURE.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # 3.8

---
 drivers/staging/vt6656/usbpipe.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 2a02067..22a3dde 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -126,6 +126,11 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
     if (pDevice->Flags & fMP_CONTROL_WRITES)
         return STATUS_FAILURE;
 
+	if (pDevice->Flags & fMP_CONTROL_READS)
+		return STATUS_FAILURE;
+
+	MP_SET_FLAG(pDevice, fMP_CONTROL_WRITES);
+
 	pDevice->sUsbCtlRequest.bRequestType = 0x40;
 	pDevice->sUsbCtlRequest.bRequest = byRequest;
 	pDevice->sUsbCtlRequest.wValue = cpu_to_le16p(&wValue);
@@ -140,12 +145,13 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 
 	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
 	if (ntStatus != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"control send request submission failed: %d\n", ntStatus);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"control send request submission failed: %d\n",
+				ntStatus);
+		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
 		return STATUS_FAILURE;
 	}
-	else {
-	    MP_SET_FLAG(pDevice, fMP_CONTROL_WRITES);
-	}
+
 	spin_unlock_irq(&pDevice->lock);
     for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
 
@@ -179,6 +185,11 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
     if (pDevice->Flags & fMP_CONTROL_READS)
 	return STATUS_FAILURE;
 
+	if (pDevice->Flags & fMP_CONTROL_WRITES)
+		return STATUS_FAILURE;
+
+	MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
+
 	pDevice->sUsbCtlRequest.bRequestType = 0xC0;
 	pDevice->sUsbCtlRequest.bRequest = byRequest;
 	pDevice->sUsbCtlRequest.wValue = cpu_to_le16p(&wValue);
@@ -192,10 +203,11 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 
 	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
 	if (ntStatus != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"control request submission failed: %d\n", ntStatus);
-	}else {
-		MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
-    }
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"control request submission failed: %d\n", ntStatus);
+		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
+		return STATUS_FAILURE;
+	}
 
 	spin_unlock_irq(&pDevice->lock);
     for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
-- 
1.8.0



