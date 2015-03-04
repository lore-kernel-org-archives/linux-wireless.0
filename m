Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933545AbbCDL36 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 06:29:58 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org, mcgrof@suse.com
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v10 3/3] cfg80211: Schedule timeout for all CRDA calls
Date: Wed,  4 Mar 2015 00:32:07 -0500
Message-Id: <1425447127-22958-3-git-send-email-ilan.peer@intel.com> (sfid-20150304_123010_213686_6805D308)
In-Reply-To: <1425447127-22958-1-git-send-email-ilan.peer@intel.com>
References: <1425447127-22958-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timeout was scheduled only in case CRDA was called due to user hints,
but was not scheduled for other cases. This can result in regulatory
hint processing getting stuck in case that there is no CRDA configured.

Change this by scheduling a timeout every time CRDA is called. In
addition, in restore_regulatory_settings() all pending requests are
restored (and not only the user ones).

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/reg.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4239dd4..d867103 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -552,6 +552,9 @@ reg_call_crda(struct regulatory_request *request)
 {
 	if (call_crda(request->alpha2))
 		return REG_REQ_IGNORE;
+
+	queue_delayed_work(system_power_efficient_wq,
+			   &reg_timeout, msecs_to_jiffies(3142));
 	return REG_REQ_OK;
 }
 
@@ -1791,8 +1794,7 @@ static void reg_set_request_processed(void)
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
-	if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
-		cancel_delayed_work(&reg_timeout);
+	cancel_delayed_work(&reg_timeout);
 
 	if (need_more_processing)
 		schedule_work(&reg_work);
@@ -2071,8 +2073,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		if (treatment == REG_REQ_IGNORE ||
 		    treatment == REG_REQ_ALREADY_SET)
 			return;
-		queue_delayed_work(system_power_efficient_wq,
-				   &reg_timeout, msecs_to_jiffies(3142));
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (!wiphy)
@@ -2496,7 +2496,6 @@ static void restore_regulatory_settings(bool reset_user)
 	char alpha2[2];
 	char world_alpha2[2];
 	struct reg_beacon *reg_beacon, *btmp;
-	struct regulatory_request *reg_request, *tmp;
 	LIST_HEAD(tmp_reg_req_list);
 	struct cfg80211_registered_device *rdev;
 
@@ -2524,11 +2523,7 @@ static void restore_regulatory_settings(bool reset_user)
 	 * settings.
 	 */
 	spin_lock(&reg_requests_lock);
-	list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
-		if (reg_request->initiator != NL80211_REGDOM_SET_BY_USER)
-			continue;
-		list_move_tail(&reg_request->list, &tmp_reg_req_list);
-	}
+	list_splice_tail_init(&reg_requests_list, &tmp_reg_req_list);
 	spin_unlock(&reg_requests_lock);
 
 	/* Clear beacon hints */
-- 
1.8.3.2

