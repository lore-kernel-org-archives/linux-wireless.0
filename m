Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50520 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1LUKLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 05:11:14 -0500
Received: by wgbds13 with SMTP id ds13so10309071wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 02:11:12 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: [PATCH v2 1/2] mac80211: mark stopped sched scan only after driver does
Date: Wed, 21 Dec 2011 12:11:01 +0200
Message-Id: <1324462262-10277-2-git-send-email-eyal@wizery.com> (sfid-20111221_111118_846711_4FB21B55)
In-Reply-To: <1324462262-10277-1-git-send-email-eyal@wizery.com>
References: <1324462262-10277-1-git-send-email-eyal@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change internal state in mac80211 only after the driver
reports that sched scan was actually stopped.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
v2: the driver should always call ieee80211_sched_scan_stopped
so a single kfree in the stopped flow is enough (Thanks Luca)

 net/mac80211/scan.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2c5041c..99a38df 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -875,7 +875,7 @@ out:
 int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	int ret = 0, i;
+	int ret = 0;
 
 	mutex_lock(&sdata->local->mtx);
 
@@ -884,13 +884,9 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 		goto out;
 	}
 
-	if (local->sched_scanning) {
-		for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-			kfree(local->sched_scan_ies.ie[i]);
-
+	if (local->sched_scanning)
 		drv_sched_scan_stop(local, sdata);
-		local->sched_scanning = false;
-	}
+
 out:
 	mutex_unlock(&sdata->local->mtx);
 
-- 
1.7.4.1

