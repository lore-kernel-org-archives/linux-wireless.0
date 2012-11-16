Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56485 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPIqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 03:46:45 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so966729eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2012 00:46:43 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix invalid kfree on sched scan
Date: Fri, 16 Nov 2012 10:46:39 +0200
Message-Id: <1353055599-8332-1-git-send-email-eliad@wizery.com> (sfid-20121116_094648_574237_21D29BC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 30dd3ed ("mac80211: don't hang on to sched_scan_ies")
converted sched_scan_ies to a local variable.
However, since it wasn't initialized, in a case of
unsupported band, sched_scan_ies.ie[] was uninitialized,
and freeing it could corrupt the memory.

Fix it by simply initializing sched_scan_ies to 0.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 13d2329..8e9bb168 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -934,7 +934,7 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sched_scan_ies sched_scan_ies;
+	struct ieee80211_sched_scan_ies sched_scan_ies = {};
 	int ret, i;
 
 	mutex_lock(&local->mtx);
-- 
1.7.6.401.g6a319

