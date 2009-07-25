Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZGYIyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 04:54:13 -0400
Subject: [PATCH] cfg80211: fix circular lock dependency (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 10:54:13 +0200
Message-Id: <1248512053.32151.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis reported this lockdep complaint, that he had also
reported earlier but when trying to analyse I had been
locking at the wrong code, and never saw the problem:

(slightly abridged)
=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-rc4-wl #6
-------------------------------------------------------
wpa_supplicant/3799 is trying to acquire lock:
 (cfg80211_mutex){+.+.+.}, at: [<ffffffffa009246a>] cfg80211_get_dev_from_ifindex+0x1a/0x90 [cfg80211]

but task is already holding lock:
 (rtnl_mutex){+.+.+.}, at: [<ffffffff81400ff2>] rtnl_lock+0x12/0x20

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (rtnl_mutex){+.+.+.}:
       [<ffffffff810857b6>] __lock_acquire+0xd76/0x12b0
       [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
       [<ffffffff814ee7a4>] mutex_lock_nested+0x44/0x350
       [<ffffffff81400ff2>] rtnl_lock+0x12/0x20 
       [<ffffffffa009f6a5>] nl80211_send_reg_change_event+0x1f5/0x2a0 [cfg80211]
       [<ffffffffa009529e>] set_regdom+0x28e/0x4c0 [cfg80211]

-> #0 (cfg80211_mutex){+.+.+.}:
       [<ffffffff8108587b>] __lock_acquire+0xe3b/0x12b0
       [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
       [<ffffffff814ee7a4>] mutex_lock_nested+0x44/0x350
       [<ffffffffa009246a>] cfg80211_get_dev_from_ifindex+0x1a/0x90 [cfg80211]
       [<ffffffffa009813f>] get_rdev_dev_by_info_ifindex+0x6f/0xa0 [cfg80211]
       [<ffffffffa009b12b>] nl80211_set_interface+0x3b/0x260 [cfg80211]


When looking at the correct code, the problem is quite
obvious. I'm not entirely sure which code paths lead
here, so until I can analyse it better let's just use
RCU to avoid the problem.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-25 10:49:13.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-25 10:49:24.000000000 +0200
@@ -4517,10 +4517,10 @@ void nl80211_send_reg_change_event(struc
 		return;
 	}
 
-	rtnl_lock();
+	rcu_read_lock();
 	genlmsg_multicast_allns(msg, 0, nl80211_regulatory_mcgrp.id,
-				GFP_KERNEL);
-	rtnl_unlock();
+				GFP_ATOMIC);
+	rcu_read_unlock();
 
 	return;
 


