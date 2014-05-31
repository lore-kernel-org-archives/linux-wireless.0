Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:36980 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaEaKv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:26 -0400
Received: by mail-we0-f180.google.com with SMTP id q58so3078994wes.25
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/14] staging: vt6656: rename MACbShutdown to vnt_mac_shutdown
Date: Sat, 31 May 2014 11:50:37 +0100
Message-Id: <1401533449-2972-2-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125135_744520_5EC499DF)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c      | 2 +-
 drivers/staging/vt6656/mac.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 8c73f36..5ee5376 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -69,7 +69,7 @@ void vnt_mac_set_filter(struct vnt_private *priv, u64 mc_filter)
  *
  *
  */
-void MACbShutdown(struct vnt_private *priv)
+void vnt_mac_shutdown(struct vnt_private *priv)
 {
 	vnt_control_out(priv, MESSAGE_TYPE_MACSHUTDOWN, 0, 0, 0, NULL);
 }
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index b0e5d49..9eee6d7 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -415,7 +415,7 @@ struct vnt_mac_set_key {
 } __packed;
 
 void vnt_mac_set_filter(struct vnt_private *, u64);
-void MACbShutdown(struct vnt_private *);
+void vnt_mac_shutdown(struct vnt_private *);
 void MACvSetBBType(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u8);
 void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b297f3a..11738dc 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1002,9 +1002,9 @@ static int device_close(struct net_device *dev)
 	for (uu = 0; uu < MAX_KEY_TABLE; uu++)
                 MACvDisableKeyEntry(pDevice,uu);
 
-    if ((pDevice->flags & DEVICE_FLAGS_UNPLUG) == false) {
-        MACbShutdown(pDevice);
-    }
+	if ((pDevice->flags & DEVICE_FLAGS_UNPLUG) == false)
+		vnt_mac_shutdown(pDevice);
+
     netif_stop_queue(pDevice->dev);
     MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
     MP_CLEAR_FLAG(pDevice, fMP_POST_WRITES);
-- 
1.9.1

