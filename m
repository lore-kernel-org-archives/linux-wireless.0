Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34077 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbcKPQB0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 11:01:26 -0500
Received: by mail-wm0-f65.google.com with SMTP id g23so12578544wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 08:01:25 -0800 (PST)
From: Vishal Thanki <vishalthanki@gmail.com>
To: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Cc: Vishal Thanki <vishalthanki@gmail.com>
Subject: [PATCH] rt2x00: Fix incorrect usage of CONFIG_RT2X00_LIB_USB
Date: Wed, 16 Nov 2016 17:01:54 +0100
Message-Id: <1479312114-9389-1-git-send-email-vishalthanki@gmail.com> (sfid-20161116_170129_994091_BB990952)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In device removal routine, usage of "#ifdef CONFIG_RT2X00_LIB_USB"
will not cover the case when it is configured as module. This will
omit the entire if-block which does cleanup of URBs and cancellation
of pending work. Changing the #ifdef to #if IS_ENABLED() to fix it.

Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 17a0c1b..eb7b714 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1441,7 +1441,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_work_sync(&rt2x00dev->intf_work);
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	cancel_work_sync(&rt2x00dev->sleep_work);
-#ifdef CONFIG_RT2X00_LIB_USB
+#if IS_ENABLED(CONFIG_RT2X00_LIB_USB)
 	if (rt2x00_is_usb(rt2x00dev)) {
 		usb_kill_anchored_urbs(rt2x00dev->anchor);
 		hrtimer_cancel(&rt2x00dev->txstatus_timer);
-- 
2.4.11
