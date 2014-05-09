Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53736 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaEIIFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 04:05:02 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so2379983eek.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 01:05:01 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] cfg80211: reg: track crda request
Date: Fri,  9 May 2014 10:04:50 +0200
Message-Id: <1399622690-7202-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140509_100519_791831_EAC4C4DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track CRDA request and handle timeout when no answer
from CRDA. This could happen when crda is not available
yet (not mounted fs), eg. during OS startup and cfg80211
built-in to the kernel or when CRDA is not available
at all in user mode.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
V2: added counter of crda calls without an answer. After
    get maximum tries print warning.

 include/net/regulatory.h |    2 ++
 net/wireless/reg.c       |   53 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 75fc1f5..30c34c4 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -72,6 +72,7 @@ enum environment_cap {
  * @country_ie_env: lets us know if the AP is telling us we are outdoor,
  *	indoor, or if it doesn't matter
  * @list: used to insert into the reg_requests_list linked list
+ * @crda_call_count: count of crda calls without an answer
  */
 struct regulatory_request {
 	struct rcu_head rcu_head;
@@ -84,6 +85,7 @@ struct regulatory_request {
 	bool processed;
 	enum environment_cap country_ie_env;
 	struct list_head list;
+	unsigned char crda_call_count;
 };
 
 /**
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f59aaac..11804e8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -479,6 +479,7 @@ static void reg_regdb_size_check(void)
 	WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
 }
 #else
+#define REG_CRDA_CALL_COUNT_MAX	5
 static inline void reg_regdb_size_check(void) {}
 static inline void reg_regdb_query(const char *alpha2) {}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
@@ -512,6 +513,10 @@ reg_call_crda(struct regulatory_request *request)
 {
 	if (call_crda(request->alpha2))
 		return REG_REQ_IGNORE;
+
+	/* Setup timeout to check regdb configuration */
+	queue_delayed_work(system_power_efficient_wq,
+			   &reg_timeout, msecs_to_jiffies(3142));
 	return REG_REQ_OK;
 }
 
@@ -1535,8 +1540,7 @@ static void reg_set_request_processed(void)
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
-	if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
-		cancel_delayed_work(&reg_timeout);
+	cancel_delayed_work(&reg_timeout);
 
 	if (need_more_processing)
 		schedule_work(&reg_work);
@@ -1803,6 +1807,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
 
+	REG_DBG_PRINT("Process regulatory hint called by %s\n",
+		      reg_initiator_name(reg_request->initiator));
+
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
@@ -1811,12 +1818,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		reg_process_hint_core(reg_request);
 		return;
 	case NL80211_REGDOM_SET_BY_USER:
-		treatment = reg_process_hint_user(reg_request);
-		if (treatment == REG_REQ_IGNORE ||
-		    treatment == REG_REQ_ALREADY_SET)
-			return;
-		queue_delayed_work(system_power_efficient_wq,
-				   &reg_timeout, msecs_to_jiffies(3142));
+		reg_process_hint_user(reg_request);
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (!wiphy)
@@ -2608,9 +2610,40 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 
 static void reg_timeout_work(struct work_struct *work)
 {
-	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
+	struct regulatory_request *lr;
+
 	rtnl_lock();
-	restore_regulatory_settings(true);
+
+	lr = get_last_request();
+	REG_DBG_PRINT("Timeout while waiting for CRDA to reply %s request\n",
+		      reg_initiator_name(lr->initiator));
+
+	switch (lr->initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_DRIVER:
+#ifdef CONFIG_CFG80211_INTERNAL_REGDB
+		pr_warn("invalid db.txt file, will use limited/restricted regulatory settings\n");
+		break;
+#else
+		if (lr->crda_call_count < REG_CRDA_CALL_COUNT_MAX) {
+			/* Call CRDA again for last request */
+			lr->crda_call_count++;
+			reg_process_hint(lr);
+		} else
+			pr_warn("CRDA not available, will use limited/restricted regulatory settings\n");
+
+		break;
+#endif /* CONFIG_CFG80211_INTERNAL_REGDB */
+	case NL80211_REGDOM_SET_BY_USER:
+		restore_regulatory_settings(true);
+		break;
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		restore_regulatory_settings(false);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
 	rtnl_unlock();
 }
 
-- 
1.7.9.5

