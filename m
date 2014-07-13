Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53840 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaGMJno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:44 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so774756wgh.10
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/13] staging: vt6656: rename vRunCommand to vnt_run_command
Date: Sun, 13 Jul 2014 10:42:49 +0100
Message-Id: <1405244573-10978-9-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114356_108869_C907EEDC)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 drivers/staging/vt6656/wcmd.c     | 2 +-
 drivers/staging/vt6656/wcmd.h     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 34b6148..d9b5210 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1111,7 +1111,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	spin_lock_init(&priv->lock);
 	mutex_init(&priv->usb_lock);
 
-	INIT_DELAYED_WORK(&priv->run_command_work, vRunCommand);
+	INIT_DELAYED_WORK(&priv->run_command_work, vnt_run_command);
 
 	usb_set_intfdata(intf, priv);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 87e682d..864d5e5 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -104,7 +104,7 @@ static int vnt_cmd_complete(struct vnt_private *priv)
 	return true;
 }
 
-void vRunCommand(struct work_struct *work)
+void vnt_run_command(struct work_struct *work)
 {
 	struct vnt_private *priv =
 		container_of(work, struct vnt_private, run_command_work.work);
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index a2943ab..783d6c9 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -63,6 +63,6 @@ void vResetCommandTimer(struct vnt_private *);
 
 int bScheduleCommand(struct vnt_private *, enum vnt_cmd, u8 *);
 
-void vRunCommand(struct work_struct *work);
+void vnt_run_command(struct work_struct *work);
 
 #endif /* __WCMD_H__ */
-- 
1.9.1

