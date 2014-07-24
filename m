Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60339 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934416AbaGXUN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 16:13:58 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so4662459wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 13:13:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/8] staging: vt6656: Remove unsed macro DEVICE_FLAGS_OPENED
Date: Thu, 24 Jul 2014 21:13:15 +0100
Message-Id: <1406232800-3694-3-git-send-email-tvboxspy@gmail.com> (sfid-20140724_221404_380703_04523B88)
In-Reply-To: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
References: <1406232800-3694-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 3 ---
 drivers/staging/vt6656/main_usb.c | 4 ----
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 58fbaab..ac4c748 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -264,9 +264,6 @@ enum {
 /* flags for options */
 #define     DEVICE_FLAGS_UNPLUG          0x00000001UL
 
-/* flags for driver status */
-#define     DEVICE_FLAGS_OPENED          0x00010000UL
-
 struct vnt_private {
 	/* mac80211 */
 	struct ieee80211_hw *hw;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f887bc0..3cfbd31 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -562,8 +562,6 @@ static int vnt_start(struct ieee80211_hw *hw)
 
 	vnt_int_start_interrupt(priv);
 
-	priv->flags |= DEVICE_FLAGS_OPENED;
-
 	ieee80211_wake_queues(hw);
 
 	return 0;
@@ -604,8 +602,6 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	priv->cmd_running = false;
 
-	priv->flags &= ~DEVICE_FLAGS_OPENED;
-
 	device_free_tx_bufs(priv);
 	device_free_rx_bufs(priv);
 	device_free_int_bufs(priv);
-- 
2.0.1

