Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15514 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbbBBU5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 15:57:07 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org, mcgrof@suse.com
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v4 2/2] cfg80211: Schedule timeout for all CRDA calls
Date: Mon,  2 Feb 2015 09:59:26 -0500
Message-Id: <1422889166-29386-2-git-send-email-ilan.peer@intel.com> (sfid-20150202_215714_260019_A550A86F)
In-Reply-To: <1422889166-29386-1-git-send-email-ilan.peer@intel.com>
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com>
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
index e96251f..a34a534 100644
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
 
@@ -1779,8 +1782,7 @@ static void reg_set_request_processed(void)
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
-	if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
-		cancel_delayed_work(&reg_timeout);
+	cancel_delayed_work(&reg_timeout);
 
 	if (need_more_processing)
 		schedule_work(&reg_work);
@@ -2059,8 +2061,6 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		if (treatment == REG_REQ_IGNORE ||
 		    treatment == REG_REQ_ALREADY_SET)
 			return;
-		queue_delayed_work(system_power_efficient_wq,
-				   &reg_timeout, msecs_to_jiffies(3142));
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (!wiphy)
@@ -2485,7 +2485,6 @@ static void restore_regulatory_settings(bool reset_user)
 	char alpha2[2];
 	char world_alpha2[2];
 	struct reg_beacon *reg_beacon, *btmp;
-	struct regulatory_request *reg_request, *tmp;
 	LIST_HEAD(tmp_reg_req_list);
 	struct cfg80211_registered_device *rdev;
 
@@ -2501,11 +2500,7 @@ static void restore_regulatory_settings(bool reset_user)
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

