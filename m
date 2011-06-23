Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48992 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933753Ab1FWUtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 16:49:24 -0400
Received: by fxm17 with SMTP id 17so1499758fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 13:49:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Jun 2011 16:49:23 -0400
Message-ID: <BANLkTimfrcrqVxNXj_5qDYYJoz6Exnzw+w@mail.gmail.com> (sfid-20110623_224928_637415_4258C2EA)
Subject: [PATCH] chan.c: fix chan.c to return channel number when in monitor
 mode and on a fixed channel.
From: Nicholas Hockey <nhockey@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(sorry if this is not right, its been nearly 10 years since i
submitted a kernel patch)

Fixes: When monitoring a fixed channel, chan.c does not report what
channel it is on.

Signed-off-by: Nicholas Hockey <nhockey@gmail.com>
---
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 17cd0c0..261ee32 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -82,10 +82,12 @@ int cfg80211_set_freq(struct
cfg80211_registered_device *rdev,
 {
        struct ieee80211_channel *chan;
        int result;
+    struct wireless_dev *mon_dev = NULL;

-       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
+       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
+        mon_dev = wdev;
                wdev = NULL;
-
+    }
        if (wdev) {
                ASSERT_WDEV_LOCK(wdev);

@@ -131,5 +133,8 @@ int cfg80211_set_freq(struct
cfg80211_registered_device *rdev,
        if (wdev)
                wdev->channel = chan;

+    if (mon_dev)
+        mon_dev->channel = chan;
+
        return 0;
 }
