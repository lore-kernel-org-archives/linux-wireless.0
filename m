Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54480 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2CNOUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 10:20:45 -0400
Received: by wibhq7 with SMTP id hq7so2681340wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2012 07:20:44 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: add NULL terminator to debugfs_netdev write buf
Date: Wed, 14 Mar 2012 16:15:02 +0200
Message-Id: <1331734503-22049-1-git-send-email-eliad@wizery.com> (sfid-20120314_152049_554526_D2548185)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some debugfs write functions call kstrto* functions, which
assume the string is null-terminated. Make it valid by changing
ieee80211_if_write() to use static buffer instead of allocating
one, and set the last char to NULL.

(The write functions try to parse some integer/mac address,
so 64 bytes buffer should be enough)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/debugfs_netdev.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index f6de8a6..ef5cf26 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -49,16 +49,15 @@ static ssize_t ieee80211_if_write(
 	size_t count, loff_t *ppos,
 	ssize_t (*write)(struct ieee80211_sub_if_data *, const char *, int))
 {
-	u8 *buf;
+	char buf[64];
 	ssize_t ret;
 
-	buf = kmalloc(count, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	if (count >= sizeof(buf))
+		return -E2BIG;
 
-	ret = -EFAULT;
 	if (copy_from_user(buf, userbuf, count))
-		goto freebuf;
+		return -EFAULT;
+	buf[count] = '\0';
 
 	ret = -ENODEV;
 	rtnl_lock();
@@ -66,8 +65,6 @@ static ssize_t ieee80211_if_write(
 		ret = (*write)(sdata, buf, count);
 	rtnl_unlock();
 
-freebuf:
-	kfree(buf);
 	return ret;
 }
 
-- 
1.7.6.401.g6a319

