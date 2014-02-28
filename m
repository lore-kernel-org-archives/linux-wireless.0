Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38329 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaB1X77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 18:59:59 -0500
Received: by mail-wg0-f46.google.com with SMTP id z12so1148739wgg.29
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 15:59:58 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/9] staging: vt6656: clean up device_free_rx_bufs.
Date: Fri, 28 Feb 2014 23:58:35 +0000
Message-Id: <1393631919-16182-5-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010006_737314_950308FC)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cleanup white space and camel case.

Camel case changes
pDevice -> priv
pRCB -> rcb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e991618..58fb377 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -767,26 +767,28 @@ static void device_free_tx_bufs(struct vnt_private *pDevice)
     return;
 }
 
-static void device_free_rx_bufs(struct vnt_private *pDevice)
+static void device_free_rx_bufs(struct vnt_private *priv)
 {
-	struct vnt_rcb *pRCB;
+	struct vnt_rcb *rcb;
 	int ii;
 
-    for (ii = 0; ii < pDevice->cbRD; ii++) {
+	for (ii = 0; ii < priv->cbRD; ii++) {
+		rcb = priv->apRCB[ii];
 
-        pRCB = pDevice->apRCB[ii];
-	/* deallocate URBs */
-        if (pRCB->pUrb) {
-            usb_kill_urb(pRCB->pUrb);
-            usb_free_urb(pRCB->pUrb);
-        }
-	/* deallocate skb */
-        if (pRCB->skb)
-            dev_kfree_skb(pRCB->skb);
-    }
-    kfree(pDevice->pRCBMem);
+		/* deallocate URBs */
+		if (rcb->pUrb) {
+			usb_kill_urb(rcb->pUrb);
+			usb_free_urb(rcb->pUrb);
+		}
 
-    return;
+		/* deallocate skb */
+		if (rcb->skb)
+			dev_kfree_skb(rcb->skb);
+	}
+
+	kfree(priv->pRCBMem);
+
+	return;
 }
 
 static void usb_device_reset(struct vnt_private *pDevice)
-- 
1.9.0

