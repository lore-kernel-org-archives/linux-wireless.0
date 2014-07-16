Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33871 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaGPVXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:30 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so6037655wiw.12
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/21] staging: vt6656: replace DBG_PRT error messages
Date: Wed, 16 Jul 2014 22:22:03 +0100
Message-Id: <1405545731-6082-13-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232334_934699_19ACBB09)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace with dev_err

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 021e892..ed56b60 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -61,9 +61,6 @@
 #include "channel.h"
 #include "int.h"
 
-/* static int msglevel = MSG_LEVEL_DEBUG; */
-static int msglevel = MSG_LEVEL_INFO;
-
 /*
  * define module options
  */
@@ -567,8 +564,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 		/* allocate URBs */
 		tx_context->urb = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!tx_context->urb) {
-			DBG_PRT(MSG_LEVEL_ERR,
-				KERN_ERR "alloc tx urb failed\n");
+			dev_err(&priv->usb->dev, "alloc tx urb failed\n");
 			goto free_tx;
 		}
 
@@ -590,15 +586,13 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 		/* allocate URBs */
 		rcb->pUrb = usb_alloc_urb(0, GFP_ATOMIC);
 		if (rcb->pUrb == NULL) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
-				" Failed to alloc rx urb\n");
+			dev_err(&priv->usb->dev, "Failed to alloc rx urb\n");
 			goto free_rx_tx;
 		}
 
 		rcb->skb = dev_alloc_skb(priv->rx_buf_sz);
 		if (rcb->skb == NULL) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
-						" Failed to alloc rx skb\n");
+			dev_err(&priv->usb->dev, "Failed to alloc rx skb\n");
 			goto free_rx_tx;
 		}
 
@@ -611,13 +605,13 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 
 	priv->pInterruptURB = usb_alloc_urb(0, GFP_ATOMIC);
 	if (priv->pInterruptURB == NULL) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR"Failed to alloc int urb\n");
+		dev_err(&priv->usb->dev, "Failed to alloc int urb\n");
 		goto free_rx_tx;
 	}
 
 	priv->int_buf.data_buf = kmalloc(MAX_INTERRUPT_SIZE, GFP_KERNEL);
 	if (priv->int_buf.data_buf == NULL) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR"Failed to alloc int buf\n");
+		dev_err(&priv->usb->dev, "Failed to alloc int buf\n");
 		usb_free_urb(priv->pInterruptURB);
 		goto free_rx_tx;
 	}
-- 
2.0.1

