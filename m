Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43545 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab2IGOyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 10:54:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: prevent work queueing while quiescing on suspend
Date: Fri,  7 Sep 2012 16:54:16 +0200
Message-Id: <1347029656-41430-2-git-send-email-nbd@openwrt.org> (sfid-20120907_165428_858686_0687F223)
In-Reply-To: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not emit a warning in that case, since there is nothing else in mac80211
that would effectively prevent more work from being queued.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/util.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 471fb05..5891741 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -585,6 +585,9 @@ EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
  */
 static bool ieee80211_can_queue_work(struct ieee80211_local *local)
 {
+	if (local->quiescing)
+		return false;
+
 	if (WARN(local->suspended && !local->resuming,
 		 "queueing ieee80211 work while going to suspend\n"))
 		return false;
-- 
1.7.9.6 (Apple Git-31.1)

