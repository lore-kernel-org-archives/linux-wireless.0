Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47488 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713Ab0CFQfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 11:35:19 -0500
Date: Sat, 6 Mar 2010 18:35:08 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix sta_mtx unlocking on insert STA failure path
Message-ID: <20100306163508.GA9236@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 34e895075e21be3e21e71d6317440d1ee7969ad0 introduced sta_mtx
locking into sta_info_insert() (now sta_info_insert_rcu), but forgot
to unlock this mutex on one of the error paths. Fix this by adding
the missing mutex_unlock() call for the case where STA insert fails
due to an entry existing already. This may happen at least in AP mode
when a STA roams between two BSSes (vifs).

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/sta_info.c |    1 +
 1 file changed, 1 insertion(+)

By the way, that roaming between two vifs did not work either, but
regardless, fixing missing mutex_unlock is of higher priority.. The STA
entry was not updated to point to the correct dev when the STA roamed
from one BSS to another one (both BSSes running on the same wiphy). To
be more exact, I think it was updated once, but not when roaming back to
the original BSS.

--- wireless-testing.orig/net/mac80211/sta_info.c	2010-03-06 17:53:12.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-03-06 17:54:04.000000000 +0200
@@ -434,6 +434,7 @@ int sta_info_insert_rcu(struct sta_info 
 	/* check if STA exists already */
 	if (sta_info_get_bss(sdata, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
+		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
 		err = -EEXIST;
 		goto out_free;

-- 
Jouni Malinen                                            PGP id EFC895FA
