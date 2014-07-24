Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61610 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934533AbaGXUOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:14:03 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so3276425wgh.29
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:14:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/8] staging: vt6656: use clear_bit to remove device flag
Date: Thu, 24 Jul 2014 21:13:18 +0100
Message-Id: <1406232800-3694-6-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221410_211407_667F4863)
In-Reply-To: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
References: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing MP_CLEAR_FLAG

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/main_usb.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 5ac80d8..21f810e 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -402,7 +402,6 @@ struct vnt_private {
 		(uVar)++;				\
 }
 
-#define MP_CLEAR_FLAG(_M, _F)            ((_M)->flags &= ~(_F))
 #define MP_TEST_FLAGS(_M, _F)            (((_M)->flags & (_F)) == (_F))
 
 int vnt_init(struct vnt_private *priv);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7798221..d729d94 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -551,7 +551,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 		return -ENOMEM;
 	}
 
-	MP_CLEAR_FLAG(priv, DEVICE_FLAGS_DISCONNECTED);
+	clear_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags);
 
 	if (device_init_registers(priv) == false) {
 		dev_dbg(&priv->usb->dev, " init register fail\n");
@@ -1025,7 +1025,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	usb_device_reset(priv);
 
-	MP_CLEAR_FLAG(priv, DEVICE_FLAGS_DISCONNECTED);
+	clear_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags);
 	vnt_reset_command_timer(priv);
 
 	vnt_schedule_command(priv, WLAN_CMD_INIT_MAC80211);
-- 
2.0.1

