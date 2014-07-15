Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53409 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbaGOS4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:56:05 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so3945641wgh.22
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:56:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/12] staging: vt6656: rename PIPEnsBulkInUsbRead to vnt_submit_rx_urb
Date: Tue, 15 Jul 2014 19:54:41 +0100
Message-Id: <1405450483-2875-10-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205612_326993_3479113A)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function just submits to rx urbs.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 drivers/staging/vt6656/usbpipe.c  | 2 +-
 drivers/staging/vt6656/usbpipe.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9890f7d..b1da23c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -603,7 +603,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 		rcb->bBoolInUse = false;
 
 		/* submit rx urb */
-		if (PIPEnsBulkInUsbRead(priv, rcb))
+		if (vnt_submit_rx_urb(priv, rcb))
 			goto free_rx_tx;
 	}
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 54badfe..97ad3b6 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -225,7 +225,7 @@ static void vnt_start_interrupt_urb_complete(struct urb *urb)
  *
  */
 
-int PIPEnsBulkInUsbRead(struct vnt_private *priv, struct vnt_rcb *rcb)
+int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 {
 	int status = 0;
 	struct urb *urb;
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index 49c284f..e74aa08 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -39,7 +39,7 @@ void vnt_control_out_u8(struct vnt_private *, u8, u8, u8);
 void vnt_control_in_u8(struct vnt_private *, u8, u8, u8 *);
 
 int vnt_start_interrupt_urb(struct vnt_private *);
-int PIPEnsBulkInUsbRead(struct vnt_private *, struct vnt_rcb *pRCB);
+int vnt_submit_rx_urb(struct vnt_private *, struct vnt_rcb *);
 int vnt_tx_context(struct vnt_private *, struct vnt_usb_send_context *);
 
 #endif /* __USBPIPE_H__ */
-- 
2.0.1

