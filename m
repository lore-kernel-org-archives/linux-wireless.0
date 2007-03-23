Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49003 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934316AbXCWUnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:45 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/19] mac80211: Prevent unregistering of unregistered hw
Message-Id: <20070323204501.3C36148593@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:45:01 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <ivdoorn@gmail.com>

At the moment it is possible to call ieee80211_unregister_hw()
for an unregistered hw structure. This will cause a big panic.
This patch will add a BUG_ON() line to warn about this situation.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

a6d266e59dd7d2f2c4bc439d47f21cf92d6df949
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index fb2ce3d..39468b8 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4732,6 +4732,9 @@ void ieee80211_unregister_hw(struct ieee
 	tasklet_kill(&local->tasklet);
 
 	rtnl_lock();
+
+	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
+
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
 	if (local->apdev)
 		ieee80211_if_del_mgmt(local);
-- 
1.3.0

