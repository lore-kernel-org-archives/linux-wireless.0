Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:46531 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:13:53 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so3221154wes.29
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:13:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/8] staging: vt6656: remove macro MP_IS_READY
Date: Thu, 24 Jul 2014 21:13:14 +0100
Message-Id: <1406232800-3694-2-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221357_198692_C8137558)
In-Reply-To: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
References: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just test FLag and remove not.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h  | 2 --
 drivers/staging/vt6656/usbpipe.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 273c663..58fbaab 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -411,8 +411,6 @@ struct vnt_private {
 #define MP_CLEAR_FLAG(_M, _F)            ((_M)->Flags &= ~(_F))
 #define MP_TEST_FLAGS(_M, _F)            (((_M)->Flags & (_F)) == (_F))
 
-#define MP_IS_READY(_M)        (((_M)->Flags & fMP_DISCONNECTED) == 0)
-
 int vnt_init(struct vnt_private *priv);
 
 #endif
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index c23a509..ab95a07 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -289,7 +289,7 @@ int vnt_tx_context(struct vnt_private *priv,
 	int status;
 	struct urb *urb;
 
-	if (!(MP_IS_READY(priv))) {
+	if (priv->Flags & fMP_DISCONNECTED) {
 		context->in_use = false;
 		return STATUS_RESOURCES;
 	}
-- 
2.0.1

