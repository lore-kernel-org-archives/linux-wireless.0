Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab2C1ORd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 10:17:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] mac80211: protect ->scanning by mutex in ieee80211_work_work()
Date: Wed, 28 Mar 2012 16:01:20 +0200
Message-Id: <1332943280-4693-2-git-send-email-sgruszka@redhat.com> (sfid-20120328_161736_263867_BF90B120)
In-Reply-To: <1332943280-4693-1-git-send-email-sgruszka@redhat.com>
References: <1332943280-4693-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/work.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 1f74af3..b2650a9 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -122,9 +122,6 @@ static void ieee80211_work_work(struct work_struct *work)
 	enum work_action rma;
 	bool remain_off_channel = false;
 
-	if (local->scanning)
-		return;
-
 	/*
 	 * ieee80211_queue_work() should have picked up most cases,
 	 * here we'll pick the rest.
@@ -134,6 +131,11 @@ static void ieee80211_work_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 
+	if (local->scanning) {
+		mutex_unlock(&local->mtx);
+		return;
+	}
+
 	ieee80211_recalc_idle(local);
 
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
-- 
1.7.1

