Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:32818 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbaGOSz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:55:58 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so5295323wgh.20
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:55:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/12] staging: vt6656: usbpipe rename PIPEnsInterruptRead to vnt_start_interrupt_urb
Date: Tue, 15 Jul 2014 19:54:37 +0100
Message-Id: <1405450483-2875-6-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205601_782853_C4C3BCFA)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop Read and PIPE. The function starts the interrupt urb.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c     | 2 +-
 drivers/staging/vt6656/usbpipe.c | 2 +-
 drivers/staging/vt6656/usbpipe.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index e78720c..87ac6a1 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -62,7 +62,7 @@ void vnt_int_start_interrupt(struct vnt_private *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	status = PIPEnsInterruptRead(priv);
+	status = vnt_start_interrupt_urb(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 13b6852..a5c55f7 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -131,7 +131,7 @@ void vnt_control_in_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 *data)
  *
  */
 
-int PIPEnsInterruptRead(struct vnt_private *priv)
+int vnt_start_interrupt_urb(struct vnt_private *priv)
 {
 	int status = STATUS_FAILURE;
 
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index ea71782..94694fe 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -38,7 +38,7 @@ int vnt_control_in(struct vnt_private *, u8, u16, u16, u16,  u8 *);
 void vnt_control_out_u8(struct vnt_private *, u8, u8, u8);
 void vnt_control_in_u8(struct vnt_private *, u8, u8, u8 *);
 
-int PIPEnsInterruptRead(struct vnt_private *);
+int vnt_start_interrupt_urb(struct vnt_private *);
 int PIPEnsBulkInUsbRead(struct vnt_private *, struct vnt_rcb *pRCB);
 int PIPEnsSendBulkOut(struct vnt_private *,
 				struct vnt_usb_send_context *pContext);
-- 
2.0.1

