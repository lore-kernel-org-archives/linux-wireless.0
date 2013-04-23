Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:55352 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3DWA6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 20:58:13 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik5so25966bkc.9
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 17:58:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: fix spurious use of rcu_dereference
Date: Tue, 23 Apr 2013 02:58:08 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	karl.beldan@gmail.com
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1366640083-1054-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201304230258.08359.chunkeey@googlemail.com> (sfid-20130423_025816_300351_8A6CDA0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following RCU debug splat:

===============================
[ INFO: suspicious RCU usage. ]
3.9.0-rc8-wl+ #31 Tainted: G           O
-------------------------------
net/mac80211/rate.c:691 suspicious rcu_dereference_check() usage!

other info that might help us debug this:
 
rcu_scheduler_active = 1, debug_locks = 1
 3 locks held by hostapd/9451:
 #0:  (genl_mutex){+.+.+.}, at: [<c1326365>] genl_lock+0xf/0x11
 #1:  (rtnl_mutex){+.+.+.}, at: [<c13133c4>] rtnl_lock+0xf/0x11
 #2:  (&rdev->mtx){+.+.+.}, at: [<f853395e>] nl80211_pre_doit+0x166/0x180 [cfg80211]

stack backtrace:
Pid: 9451, comm: hostapd Tainted: G           O 3.9.0-rc8-wl+ #31
Call Trace:
 [<c107da0b>] lockdep_rcu_suspicious+0xe6/0xee
 [<f8bf82ad>] rate_control_set_rates+0x43/0x5a [mac80211]
 [<f8c2cacb>] minstrel_update_rates+0xdc/0xe2 [mac80211]
 [<f8c2cfb0>] minstrel_rate_init+0x24c/0x33d [mac80211]
 [<f8c2d9d3>] minstrel_ht_update_caps+0x206/0x234 [mac80211]
 [<c1080a8d>] ? lock_release+0x1c9/0x226
 [<f8c2da25>] minstrel_ht_rate_init+0x10/0x14 [mac80211]
 [...]

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Actually, rcu_read_lock() might not be necessary in this special
case [the RC is not yet initialized, so nothing bad can happen].

But, since the rcu_read_lock() has a low overhead and
rate_control_set_rates mac80211.h doc does not mention
anything about locking, I think this is a viable way. 
---
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 0d51877..615d3a8 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -688,11 +688,15 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *pubsta,
 			   struct ieee80211_sta_rates *rates)
 {
-	struct ieee80211_sta_rates *old = rcu_dereference(pubsta->rates);
+	struct ieee80211_sta_rates *old;
+
+	rcu_read_lock();
+	old = rcu_dereference(pubsta->rates);
 
 	rcu_assign_pointer(pubsta->rates, rates);
 	if (old)
 		kfree_rcu(old, rcu_head);
+	rcu_read_unlock();
 
 	return 0;
 }
