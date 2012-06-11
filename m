Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2FKJfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:35:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Se12A-0004pF-8y
	for linux-wireless@vger.kernel.org; Mon, 11 Jun 2012 11:35:38 +0200
Message-ID: <1339407337.4520.19.camel@jlt3.sipsolutions.net> (sfid-20120611_113542_950658_1B800CC2)
Subject: [PATCH] mac80211: remove unneeded ieee80211_run_deferred_scan()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 11 Jun 2012 11:35:37 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Ilan pointed out to me that ieee80211_start_next_roc()
already calls ieee80211_run_deferred_scan() if the list
of ROC items is empty, so there's no need to call it
again after calling ieee80211_start_next_roc().

Reported-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index abb226d..fcb01ee 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -379,7 +379,6 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		ieee80211_recalc_idle(local);
 
 		ieee80211_start_next_roc(local);
-		ieee80211_run_deferred_scan(local);
 	}
 
  out_unlock:
@@ -410,9 +409,6 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 	/* if there's another roc, start it now */
 	ieee80211_start_next_roc(local);
 
-	/* or scan maybe */
-	ieee80211_run_deferred_scan(local);
-
  out_unlock:
 	mutex_unlock(&local->mtx);
 }
@@ -455,7 +451,6 @@ void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
 	}
 
 	ieee80211_start_next_roc(local);
-	ieee80211_run_deferred_scan(local);
 	mutex_unlock(&local->mtx);
 
 	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {
-- 
1.7.10



