Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48407 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbbLAWWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 17:22:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: reject zero cookie in mgmt-tx/roc cancel
Date: Tue,  1 Dec 2015 23:22:34 +0100
Message-Id: <1449008554-8907-1-git-send-email-johannes@sipsolutions.net> (sfid-20151201_232241_197441_88BDF9D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When cancelling, you can cancel "any" (first in list) mgmt-tx
or remain-on-channel operation by using the value 0 for the
cookie along with the *opposite* operation, i.e.
 * cancel the first mgmt-tx by cancelling roc with 0 cookie
 * cancel the first roc by cancelling mgmt-tx with 0 cookie

This isn't really that bad since userspace should only pass
cookies that we gave it, but could lead to hard-to-debug
issues so better prevent it and reject zero values since we
never hand those out.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index cfd3356e26fd..6719b27aad66 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -697,6 +697,9 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 	struct ieee80211_roc_work *roc, *tmp, *found = NULL;
 	int ret;
 
+	if (!cookie)
+		return -ENOENT;
+
 	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
 		if (!mgmt_tx && roc->cookie != cookie)
-- 
2.6.2

