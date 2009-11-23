Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40110 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZKWVXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:23:03 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] wl1271: fix the inetdev notifier callback return values
Date: Mon, 23 Nov 2009 23:22:15 +0200
Message-Id: <1259011339-28149-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
References: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl1271_dev_notify() was returning 0 or -ENODEV, when it should return
NOTIFY_* instead.  Now we use NOTIFY_DONE when we didn't handle the event or
NOTIFY_OK when we have handled it.

For inetdev notifications, it doesn't matter whether we use NOTIFY_DONE or
NOTIFY_OK, because it ignores the return value of the call to
blocking_notifier_call_chain().  But the notify.h header says that
NOTIFY_DONE is "Don't care" and NOTIFY_OK is "Suits me", so that seems to be
the right way to do it.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 90916ed..c8652ee 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -815,15 +815,15 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 
 	wdev = dev->ieee80211_ptr;
 	if (wdev == NULL)
-		return -ENODEV;
+		return NOTIFY_DONE;
 
 	wiphy = wdev->wiphy;
 	if (wiphy == NULL)
-		return -ENODEV;
+		return NOTIFY_DONE;
 
 	hw = wiphy_priv(wiphy);
 	if (hw == NULL)
-		return -ENODEV;
+		return NOTIFY_DONE;
 
 	/* Check that the interface is one supported by this driver. */
 	wl_temp = hw->priv;
@@ -832,7 +832,7 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 			break;
 	}
 	if (wl == NULL)
-		return -ENODEV;
+		return NOTIFY_DONE;
 
 	/* Get the interface IP address for the device. "ifa" will become
 	   NULL if:
@@ -868,7 +868,7 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 out:
 	mutex_unlock(&wl->mutex);
 
-	return ret;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block wl1271_dev_notifier = {
-- 
1.6.3.3

