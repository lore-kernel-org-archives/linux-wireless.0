Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbZJEJQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2009 05:16:40 -0400
Subject: [PATCH] wext: let get_wireless_stats() sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Miles Lane <miles.lane@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 11:15:59 +0200
Message-Id: <1254734159.22426.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of drivers (recently including cfg80211-based ones)
assume that all wireless handlers, including statistics, can
sleep and they often also implicitly assume that the rtnl is
held around their invocation. This is almost always true now
except when reading from sysfs:

  BUG: sleeping function called from invalid context at kernel/mutex.c:280
  in_atomic(): 1, irqs_disabled(): 0, pid: 10450, name: head
  2 locks held by head/10450:
   #0:  (&buffer->mutex){+.+.+.}, at: [<c10ceb99>] sysfs_read_file+0x24/0xf4
   #1:  (dev_base_lock){++.?..}, at: [<c12844ee>] wireless_show+0x1a/0x4c
  Pid: 10450, comm: head Not tainted 2.6.32-rc3 #1
  Call Trace:
   [<c102301c>] __might_sleep+0xf0/0xf7
   [<c1324355>] mutex_lock_nested+0x1a/0x33
   [<f8cea53b>] wdev_lock+0xd/0xf [cfg80211]
   [<f8cea58f>] cfg80211_wireless_stats+0x45/0x12d [cfg80211]
   [<c13118d6>] get_wireless_stats+0x16/0x1c
   [<c12844fe>] wireless_show+0x2a/0x4c

Fix this by using the rtnl instead of dev_base_lock.

Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/core/net-sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/core/net-sysfs.c	2009-10-05 11:09:56.000000000 +0200
+++ wireless-testing/net/core/net-sysfs.c	2009-10-05 11:10:52.000000000 +0200
@@ -366,13 +366,13 @@ static ssize_t wireless_show(struct devi
 	const struct iw_statistics *iw;
 	ssize_t ret = -EINVAL;
 
-	read_lock(&dev_base_lock);
+	rtnl_lock();
 	if (dev_isalive(dev)) {
 		iw = get_wireless_stats(dev);
 		if (iw)
 			ret = (*format)(iw, buf);
 	}
-	read_unlock(&dev_base_lock);
+	rtnl_unlock();
 
 	return ret;
 }


