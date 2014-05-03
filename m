Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:40084 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaECOUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:20:00 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so4793174wes.2
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:19:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/13] staging: vt6656: lock changes: s_nsBulkInUsbIoCompleteRead.
Date: Sat,  3 May 2014 15:17:30 +0100
Message-Id: <1399126654-2663-9-git-send-email-tvboxspy@gmail.com> (sfid-20140503_162013_818700_58413566)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use spin_lock_irqsave/spin_unlock_irqrestore

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 934d0a9..b707470 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -474,6 +474,7 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 {
 	struct vnt_rcb *rcb = urb->context;
 	struct vnt_private *priv = rcb->pDevice;
+	unsigned long flags;
 	int re_alloc_skb = false;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkInUsbIoCompleteRead\n");
@@ -493,23 +494,23 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 	}
 
 	if (urb->actual_length) {
-		spin_lock(&priv->lock);
+		spin_lock_irqsave(&priv->lock, flags);
 
 		if (RXbBulkInProcessData(priv, rcb, urb->actual_length) == true)
 			re_alloc_skb = true;
 
-		spin_unlock(&priv->lock);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 	rcb->Ref--;
 	if (rcb->Ref == 0) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RxvFreeNormal %d\n",
 							priv->NumRecvFreeList);
-		spin_lock(&priv->lock);
+		spin_lock_irqsave(&priv->lock, flags);
 
 		RXvFreeRCB(rcb, re_alloc_skb);
 
-		spin_unlock(&priv->lock);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 	return;
-- 
1.9.1

