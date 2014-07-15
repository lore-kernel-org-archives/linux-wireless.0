Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35262 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbaGOS4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:56:06 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so4595469wiv.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:56:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/12] staging: vt6656: rename s_nsBulkInUsbIoCompleteRead to vnt_submit_rx_urb_complete
Date: Tue, 15 Jul 2014 19:54:42 +0100
Message-Id: <1405450483-2875-11-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205610_838086_F479D9A4)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 97ad3b6..5fcfbf5 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -58,7 +58,7 @@
 #endif
 
 static void vnt_start_interrupt_urb_complete(struct urb *urb);
-static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
+static void vnt_submit_rx_urb_complete(struct urb *urb);
 static void vnt_tx_context_complete(struct urb *urb);
 
 int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
@@ -241,7 +241,7 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 		usb_rcvbulkpipe(priv->usb, 2),
 		skb_put(rcb->skb, skb_tailroom(rcb->skb)),
 		MAX_TOTAL_SIZE_WITH_ALL_HEADERS,
-		s_nsBulkInUsbIoCompleteRead,
+		vnt_submit_rx_urb_complete,
 		rcb);
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
@@ -271,7 +271,7 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
  *
  */
 
-static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
+static void vnt_submit_rx_urb_complete(struct urb *urb)
 {
 	struct vnt_rcb *rcb = urb->context;
 	struct vnt_private *priv = rcb->pDevice;
-- 
2.0.1

