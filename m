Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57900 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbaEQIwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:52:40 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so6010179wgg.9
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/22] staging: vt6656: usbpipe: get rid of in/out debug messages.
Date: Sat, 17 May 2014 09:50:19 +0100
Message-Id: <1400316639-4430-2-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105245_265776_847F3D08)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove all in/out debug messages.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 433edca..8d0705d 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -126,9 +126,6 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 {
 	int status = STATUS_FAILURE;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"---->s_nsStartInterruptUsbRead()\n");
-
 	if (priv->int_buf.in_use == true)
 		return STATUS_FAILURE;
 
@@ -150,9 +147,6 @@ int PIPEnsInterruptRead(struct vnt_private *priv)
 		priv->int_buf.in_use = false;
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"<----s_nsStartInterruptUsbRead Return(%x)\n", status);
-
 	return status;
 }
 
@@ -176,9 +170,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 	struct vnt_private *priv = urb->context;
 	int status;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"---->s_nsInterruptUsbIoCompleteRead\n");
-
 	switch (urb->status) {
 	case 0:
 	case -ETIMEDOUT:
@@ -194,9 +185,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 
 	status = urb->status;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"s_nsInterruptUsbIoCompleteRead Status %d\n", status);
-
 	if (status != STATUS_SUCCESS) {
 		priv->int_buf.in_use = false;
 
@@ -236,8 +224,6 @@ int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
 	int status = 0;
 	struct urb *urb;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsStartBulkInUsbRead\n");
-
 	if (priv->Flags & fMP_DISCONNECTED)
 		return STATUS_FAILURE;
 
@@ -290,8 +276,6 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 	unsigned long flags;
 	int re_alloc_skb = false;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
-
 	switch (urb->status) {
 	case 0:
 		break;
@@ -351,8 +335,6 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 
 	priv->bPWBitOn = false;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsSendBulkOut\n");
-
 	if (!(MP_IS_READY(priv) && priv->Flags & fMP_POST_WRITES)) {
 		context->in_use = false;
 		return STATUS_RESOURCES;
@@ -413,8 +395,6 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	struct vnt_private *priv = context->priv;
 	u8 context_type = context->type;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
-
 	switch (urb->status) {
 	case 0:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-- 
1.9.1

