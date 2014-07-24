Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:57743 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:13:50 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so3267894wes.35
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:13:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/8] staging: vt6656: Remove flags fMP_POST_READS and fMP_POST_WRITES
Date: Thu, 24 Jul 2014 21:13:13 +0100
Message-Id: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221354_227798_0AA6E7F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MP_IS_READY(fMP_DISCONNECTED) is used to block thread in vnt_tx_context

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 --
 drivers/staging/vt6656/main_usb.c | 4 ----
 drivers/staging/vt6656/usbpipe.c  | 2 +-
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 6b7bb8c..273c663 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -406,8 +406,6 @@ struct vnt_private {
 }
 
 #define fMP_DISCONNECTED                    0x00000002
-#define fMP_POST_READS                      0x00000100
-#define fMP_POST_WRITES                     0x00000200
 
 #define MP_SET_FLAG(_M, _F)             ((_M)->Flags |= (_F))
 #define MP_CLEAR_FLAG(_M, _F)            ((_M)->Flags &= ~(_F))
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b99def7..f887bc0 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -552,8 +552,6 @@ static int vnt_start(struct ieee80211_hw *hw)
 	}
 
 	MP_CLEAR_FLAG(priv, fMP_DISCONNECTED);
-	MP_SET_FLAG(priv, fMP_POST_READS);
-	MP_SET_FLAG(priv, fMP_POST_WRITES);
 
 	if (device_init_registers(priv) == false) {
 		dev_dbg(&priv->usb->dev, " init register fail\n");
@@ -601,8 +599,6 @@ static void vnt_stop(struct ieee80211_hw *hw)
 	ieee80211_stop_queues(hw);
 
 	MP_SET_FLAG(priv, fMP_DISCONNECTED);
-	MP_CLEAR_FLAG(priv, fMP_POST_WRITES);
-	MP_CLEAR_FLAG(priv, fMP_POST_READS);
 
 	cancel_delayed_work_sync(&priv->run_command_work);
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 7b050ba..c23a509 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -289,7 +289,7 @@ int vnt_tx_context(struct vnt_private *priv,
 	int status;
 	struct urb *urb;
 
-	if (!(MP_IS_READY(priv) && priv->Flags & fMP_POST_WRITES)) {
+	if (!(MP_IS_READY(priv))) {
 		context->in_use = false;
 		return STATUS_RESOURCES;
 	}
-- 
2.0.1

