Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33278 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934527AbaGXUOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:14:01 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so3343270wgg.16
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:13:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/8] staging: vt6656: struct vnt_private merge flag and macros
Date: Thu, 24 Jul 2014 21:13:16 +0100
Message-Id: <1406232800-3694-4-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221407_243243_EA370CCF)
In-Reply-To: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
References: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

merge u32 flag into unsigned long Flags

Replacing fMP_DISCONNECTED with DEVICE_FLAGS_DISCONNECTED

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 14 ++++++--------
 drivers/staging/vt6656/main_usb.c |  6 +++---
 drivers/staging/vt6656/usbpipe.c  |  6 +++---
 drivers/staging/vt6656/wcmd.c     |  2 +-
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ac4c748..fd7105e 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -262,7 +262,8 @@ enum {
 };
 
 /* flags for options */
-#define     DEVICE_FLAGS_UNPLUG          0x00000001UL
+#define DEVICE_FLAGS_UNPLUG		BIT(0)
+#define DEVICE_FLAGS_DISCONNECTED	BIT(1)
 
 struct vnt_private {
 	/* mac80211 */
@@ -281,8 +282,7 @@ struct vnt_private {
 	spinlock_t lock;
 	struct mutex usb_lock;
 
-	u32 flags;
-	unsigned long Flags;
+	unsigned long flags;
 
 	/* USB */
 	struct urb *interrupt_urb;
@@ -402,11 +402,9 @@ struct vnt_private {
 		(uVar)++;				\
 }
 
-#define fMP_DISCONNECTED                    0x00000002
-
-#define MP_SET_FLAG(_M, _F)             ((_M)->Flags |= (_F))
-#define MP_CLEAR_FLAG(_M, _F)            ((_M)->Flags &= ~(_F))
-#define MP_TEST_FLAGS(_M, _F)            (((_M)->Flags & (_F)) == (_F))
+#define MP_SET_FLAG(_M, _F)             ((_M)->flags |= (_F))
+#define MP_CLEAR_FLAG(_M, _F)            ((_M)->flags &= ~(_F))
+#define MP_TEST_FLAGS(_M, _F)            (((_M)->flags & (_F)) == (_F))
 
 int vnt_init(struct vnt_private *priv);
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3cfbd31..87feba5 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -551,7 +551,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 		return -ENOMEM;
 	}
 
-	MP_CLEAR_FLAG(priv, fMP_DISCONNECTED);
+	MP_CLEAR_FLAG(priv, DEVICE_FLAGS_DISCONNECTED);
 
 	if (device_init_registers(priv) == false) {
 		dev_dbg(&priv->usb->dev, " init register fail\n");
@@ -596,7 +596,7 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	ieee80211_stop_queues(hw);
 
-	MP_SET_FLAG(priv, fMP_DISCONNECTED);
+	MP_SET_FLAG(priv, DEVICE_FLAGS_DISCONNECTED);
 
 	cancel_delayed_work_sync(&priv->run_command_work);
 
@@ -1025,7 +1025,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	usb_device_reset(priv);
 
-	MP_CLEAR_FLAG(priv, fMP_DISCONNECTED);
+	MP_CLEAR_FLAG(priv, DEVICE_FLAGS_DISCONNECTED);
 	vnt_reset_command_timer(priv);
 
 	vnt_schedule_command(priv, WLAN_CMD_INIT_MAC80211);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index ab95a07..b2722b9 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -52,7 +52,7 @@ int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 {
 	int status = 0;
 
-	if (priv->Flags & fMP_DISCONNECTED)
+	if (priv->flags & DEVICE_FLAGS_DISCONNECTED)
 		return STATUS_FAILURE;
 
 	mutex_lock(&priv->usb_lock);
@@ -80,7 +80,7 @@ int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 {
 	int status;
 
-	if (priv->Flags & fMP_DISCONNECTED)
+	if (priv->flags & DEVICE_FLAGS_DISCONNECTED)
 		return STATUS_FAILURE;
 
 	mutex_lock(&priv->usb_lock);
@@ -289,7 +289,7 @@ int vnt_tx_context(struct vnt_private *priv,
 	int status;
 	struct urb *urb;
 
-	if (priv->Flags & fMP_DISCONNECTED) {
+	if (priv->flags & DEVICE_FLAGS_DISCONNECTED) {
 		context->in_use = false;
 		return STATUS_RESOURCES;
 	}
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index e4a5e2b..e5330e3 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -97,7 +97,7 @@ void vnt_run_command(struct work_struct *work)
 	struct vnt_private *priv =
 		container_of(work, struct vnt_private, run_command_work.work);
 
-	if (priv->Flags & fMP_DISCONNECTED)
+	if (priv->flags & DEVICE_FLAGS_DISCONNECTED)
 		return;
 
 	if (priv->cmd_running != true)
-- 
2.0.1

