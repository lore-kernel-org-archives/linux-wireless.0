Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38095 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1LUADV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 19:03:21 -0500
Received: by wgbdr13 with SMTP id dr13so13329204wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 16:03:20 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: [PATCH 1/2] mac80211: mark stopped sched scan only after driver does
Date: Wed, 21 Dec 2011 02:03:09 +0200
Message-Id: <1324425790-3030-2-git-send-email-eyal@wizery.com> (sfid-20111221_010333_318480_F521B783)
In-Reply-To: <1324425790-3030-1-git-send-email-eyal@wizery.com>
References: <1324425790-3030-1-git-send-email-eyal@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change internal state in mac80211 only after the driver
reports that sched scan was actually stopped.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 net/mac80211/scan.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2c5041c..33ca4d8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -885,11 +885,12 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (local->sched_scanning) {
-		for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 			kfree(local->sched_scan_ies.ie[i]);
+			local->sched_scan_ies.ie[i] = NULL;
+		}
 
 		drv_sched_scan_stop(local, sdata);
-		local->sched_scanning = false;
 	}
 out:
 	mutex_unlock(&sdata->local->mtx);
@@ -921,8 +922,10 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 		return;
 	}
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		kfree(local->sched_scan_ies.ie[i]);
+		local->sched_scan_ies.ie[i] = NULL;
+	}
 
 	local->sched_scanning = false;
 
-- 
1.7.4.1

