Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57107 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210AbaGOS4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:56:02 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so77479wiv.7
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:56:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/12] staging: vt6656: rename PIPEnsSendBulkOut to vnt_tx_context.
Date: Tue, 15 Jul 2014 19:54:39 +0100
Message-Id: <1405450483-2875-8-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205613_020203_011CD11B)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are just tx the context

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c    | 4 ++--
 drivers/staging/vt6656/usbpipe.c | 2 +-
 drivers/staging/vt6656/usbpipe.h | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1f1ec04..76b7f17 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -928,7 +928,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (PIPEnsSendBulkOut(priv, tx_context) != STATUS_PENDING) {
+	if (vnt_tx_context(priv, tx_context) != STATUS_PENDING) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return -EIO;
 	}
@@ -1022,7 +1022,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (PIPEnsSendBulkOut(priv, context) != STATUS_PENDING)
+	if (vnt_tx_context(priv, context) != STATUS_PENDING)
 		ieee80211_free_txskb(priv->hw, context->skb);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index e7239d6..db1bc1a 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -337,7 +337,7 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
  *
  */
 
-int PIPEnsSendBulkOut(struct vnt_private *priv,
+int vnt_tx_context(struct vnt_private *priv,
 				struct vnt_usb_send_context *context)
 {
 	int status;
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index 94694fe..49c284f 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -40,7 +40,6 @@ void vnt_control_in_u8(struct vnt_private *, u8, u8, u8 *);
 
 int vnt_start_interrupt_urb(struct vnt_private *);
 int PIPEnsBulkInUsbRead(struct vnt_private *, struct vnt_rcb *pRCB);
-int PIPEnsSendBulkOut(struct vnt_private *,
-				struct vnt_usb_send_context *pContext);
+int vnt_tx_context(struct vnt_private *, struct vnt_usb_send_context *);
 
 #endif /* __USBPIPE_H__ */
-- 
2.0.1

