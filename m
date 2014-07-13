Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34533 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaGMJnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:47 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so1189403wib.4
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/13] staging: vt6656: rename vResetCommandTimer to vnt_reset_command_timer
Date: Sun, 13 Jul 2014 10:42:51 +0100
Message-Id: <1405244573-10978-11-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114410_108882_48C85196)
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
index ceef9ef..dffd0c7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1135,7 +1135,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	usb_device_reset(priv);
 
 	MP_CLEAR_FLAG(priv, fMP_DISCONNECTED);
-	vResetCommandTimer(priv);
+	vnt_reset_command_timer(priv);
 
 	vnt_schedule_command(priv, WLAN_CMD_INIT_MAC80211);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index b217efb..bb9500f 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -202,7 +202,7 @@ int vnt_schedule_command(struct vnt_private *priv, enum vnt_cmd command)
 
 }
 
-void vResetCommandTimer(struct vnt_private *priv)
+void vnt_reset_command_timer(struct vnt_private *priv)
 {
 	priv->free_cmd_queue = CMD_Q_SIZE;
 	priv->cmd_dequeue_idx = 0;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 3248c95..0fc2c40 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -59,7 +59,7 @@ enum vnt_cmd_state {
 
 struct vnt_private;
 
-void vResetCommandTimer(struct vnt_private *);
+void vnt_reset_command_timer(struct vnt_private *);
 
 int vnt_schedule_command(struct vnt_private *, enum vnt_cmd);
 
-- 
1.9.1

