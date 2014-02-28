Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41973 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCAAAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 19:00:02 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so1124413wgh.3
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 16:00:00 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/9] staging: vt6656: clean up device_free_tx_bufs
Date: Fri, 28 Feb 2014 23:58:36 +0000
Message-Id: <1393631919-16182-6-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010013_293594_0F2C166D)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up white space and camel case.

Camel case changes
pDevice -> priv
pTxContext -> tx_context

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 58fb377..669e4f3 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -749,22 +749,23 @@ err_nomem:
 	return rc;
 }
 
-static void device_free_tx_bufs(struct vnt_private *pDevice)
+static void device_free_tx_bufs(struct vnt_private *priv)
 {
-	struct vnt_usb_send_context *pTxContext;
-    int ii;
+	struct vnt_usb_send_context *tx_context;
+	int ii;
 
-    for (ii = 0; ii < pDevice->cbTD; ii++) {
+	for (ii = 0; ii < priv->cbTD; ii++) {
+		tx_context = priv->apTD[ii];
+		/* deallocate URBs */
+		if (tx_context->pUrb) {
+			usb_kill_urb(tx_context->pUrb);
+			usb_free_urb(tx_context->pUrb);
+		}
 
-        pTxContext = pDevice->apTD[ii];
-	/* deallocate URBs */
-        if (pTxContext->pUrb) {
-            usb_kill_urb(pTxContext->pUrb);
-            usb_free_urb(pTxContext->pUrb);
-        }
-        kfree(pTxContext);
-    }
-    return;
+		kfree(tx_context);
+	}
+
+	return;
 }
 
 static void device_free_rx_bufs(struct vnt_private *priv)
-- 
1.9.0

