Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:65374 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934565AbaGXUOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:14:07 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so3221404wes.29
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:14:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/8] staging: vt6656: use test_bit to check flags status
Date: Thu, 24 Jul 2014 21:13:20 +0100
Message-Id: <1406232800-3694-8-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221417_117554_9F804A22)
In-Reply-To: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
References: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 drivers/staging/vt6656/usbpipe.c  | 6 +++---
 drivers/staging/vt6656/wcmd.c     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d729d94..fdc5c7b 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -591,7 +591,7 @@ static void vnt_stop(struct ieee80211_hw *hw)
 	/* clear all keys */
 	priv->key_entry_inuse = 0;
 
-	if ((priv->flags & DEVICE_FLAGS_UNPLUG) == false)
+	if (!test_bit(DEVICE_FLAGS_UNPLUG, &priv->flags))
 		vnt_mac_shutdown(priv);
 
 	ieee80211_stop_queues(hw);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index b2722b9..f1969fe 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -52,7 +52,7 @@ int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 {
 	int status = 0;
 
-	if (priv->flags & DEVICE_FLAGS_DISCONNECTED)
+	if (test_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags))
 		return STATUS_FAILURE;
 
 	mutex_lock(&priv->usb_lock);
@@ -80,7 +80,7 @@ int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 {
 	int status;
 
-	if (priv->flags & DEVICE_FLAGS_DISCONNECTED)
+	if (test_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags))
 		return STATUS_FAILURE;
 
 	mutex_lock(&priv->usb_lock);
@@ -289,7 +289,7 @@ int vnt_tx_context(struct vnt_private *priv,
 	int status;
 	struct urb *urb;
 
-	if (priv->flags & DEVICE_FLAGS_DISCONNECTED) {
+	if (test_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags)) {
 		context->in_use = false;
 		return STATUS_RESOURCES;
 	}
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index e5330e3..8f6417bc 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -97,7 +97,7 @@ void vnt_run_command(struct work_struct *work)
 	struct vnt_private *priv =
 		container_of(work, struct vnt_private, run_command_work.work);
 
-	if (priv->flags & DEVICE_FLAGS_DISCONNECTED)
+	if (test_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags))
 		return;
 
 	if (priv->cmd_running != true)
-- 
2.0.1

