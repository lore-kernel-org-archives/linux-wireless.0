Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43893 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528AbaGXUOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:14:03 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so4575492wib.2
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:14:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/8] staging: vt6656: use set_bit to set flags
Date: Thu, 24 Jul 2014 21:13:17 +0100
Message-Id: <1406232800-3694-5-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221414_925985_16269291)
In-Reply-To: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
References: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing MP_SET_FLAG

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/main_usb.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index fd7105e..5ac80d8 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -402,7 +402,6 @@ struct vnt_private {
 		(uVar)++;				\
 }
 
-#define MP_SET_FLAG(_M, _F)             ((_M)->flags |= (_F))
 #define MP_CLEAR_FLAG(_M, _F)            ((_M)->flags &= ~(_F))
 #define MP_TEST_FLAGS(_M, _F)            (((_M)->flags & (_F)) == (_F))
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 87feba5..7798221 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -596,7 +596,7 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	ieee80211_stop_queues(hw);
 
-	MP_SET_FLAG(priv, DEVICE_FLAGS_DISCONNECTED);
+	set_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags);
 
 	cancel_delayed_work_sync(&priv->run_command_work);
 
@@ -1051,7 +1051,7 @@ static void vt6656_disconnect(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
 
-	priv->flags |= DEVICE_FLAGS_UNPLUG;
+	set_bit(DEVICE_FLAGS_UNPLUG, &priv->flags);
 
 	ieee80211_free_hw(priv->hw);
 }
-- 
2.0.1

