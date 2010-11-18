Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44625 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0KRFzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 00:55:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 21:54:52 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <mark@moxienet.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/4] cfg80211: Fix regulatory bug with multiple cards and delays
Date: Wed, 17 Nov 2010 21:55:02 -0800
Message-ID: <1290059702-2679-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When two cards are connected with the same regulatory domain
if CRDA had a delayed response then cfg80211's own set regulatory
domain would still be the world regulatory domain. There was a bug
on cfg80211's logic such that it assumed that once you pegged a
request as the last request it was already the currently set
regulatory domain. This would mean we would race setting a stale
regulatory domain to secondary cards which had the same regulatory
domain since the alpha2 would match.

We fix this by processing each regulatory request atomically,
and only move on to the next one once we get it fully processed.
In the case CRDA is not present we will simply world roam.

This issue is only present when you have a slow system and the
CRDA processing is delayed. Because of this it is not a known
regression.

Without this fix when a delay is present with CRDA the second card
would end up with an intersected regulatory domain and not allow it
to use the channels it really is designed for. When two cards with
two different regulatory domains were inserted you'd end up
rejecting the second card's regulatory domain request.
This fails with mac80211_hswim's regtest=2 (two requests, same alpha2)
and regtest=3 (two requests, different alpha2) module parameter
options.

This was reproduced and tested against mac80211_hwsim using this
CRDA delayer:

       #!/bin/bash
       echo $COUNTRY >> /tmp/log
       sleep 2
       /sbin/crda.orig

And these regulatory tests:

       modprobe mac80211_hwsim regtest=2
       modprobe mac80211_hwsim regtest=3

Cc: Mark Mentovai <mark@moxienet.com>
Reported-by: Mark Mentovai <mark@moxienet.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/regulatory.h |    7 ++++++
 net/wireless/reg.c       |   52 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 9e103a4..356d6e3 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -43,6 +43,12 @@ enum environment_cap {
  * @intersect: indicates whether the wireless core should intersect
  * 	the requested regulatory domain with the presently set regulatory
  * 	domain.
+ * @processed: indicates whether or not this requests has already been
+ *	processed. When the last request is processed it means that the
+ *	currently regulatory domain set on cfg80211 is updated from
+ *	CRDA and can be used by other regulatory requests. When a
+ *	the last request is not yet processed we must yield until it
+ *	is processed before processing any new requests.
  * @country_ie_checksum: checksum of the last processed and accepted
  * 	country IE
  * @country_ie_env: lets us know if the AP is telling us we are outdoor,
@@ -54,6 +60,7 @@ struct regulatory_request {
 	enum nl80211_reg_initiator initiator;
 	char alpha2[2];
 	bool intersect;
+	bool processed;
 	enum environment_cap country_ie_env;
 	struct list_head list;
 };
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b522c46..bc14caa 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1320,6 +1320,21 @@ static int ignore_request(struct wiphy *wiphy,
 	return -EINVAL;
 }
 
+static void reg_set_request_processed(void)
+{
+	bool need_more_processing = false;
+
+	last_request->processed = true;
+
+	spin_lock(&reg_requests_lock);
+	if (!list_empty(&reg_requests_list))
+		need_more_processing = true;
+	spin_unlock(&reg_requests_lock);
+
+	if (need_more_processing)
+		schedule_work(&reg_work);
+}
+
 /**
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if the hint comes from country information from an AP, this
@@ -1395,8 +1410,10 @@ new_request:
 		 * have applied the requested regulatory domain before we just
 		 * inform userspace we have processed the request
 		 */
-		if (r == -EALREADY)
+		if (r == -EALREADY) {
 			nl80211_send_reg_change_event(last_request);
+			reg_set_request_processed();
+		}
 		return r;
 	}
 
@@ -1428,7 +1445,11 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		wiphy_update_regulatory(wiphy, initiator);
 }
 
-/* Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_* */
+/*
+ * Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_*
+ * Regulatory hints come on a first come first serve basis and we
+ * must process each one atomically.
+ */
 static void reg_process_pending_hints(void)
 {
 	struct regulatory_request *reg_request;
@@ -1436,19 +1457,30 @@ static void reg_process_pending_hints(void)
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
+	/* When last_request->processed becomes true this will be rescheduled */
+	if (last_request && !last_request->processed) {
+		REG_DBG_PRINT("Pending regulatory request, waiting "
+			      "for it to be processed...");
+		goto out;
+	}
+
 	spin_lock(&reg_requests_lock);
-	while (!list_empty(&reg_requests_list)) {
-		reg_request = list_first_entry(&reg_requests_list,
-					       struct regulatory_request,
-					       list);
-		list_del_init(&reg_request->list);
 
+	if (list_empty(&reg_requests_list)) {
 		spin_unlock(&reg_requests_lock);
-		reg_process_hint(reg_request);
-		spin_lock(&reg_requests_lock);
+		goto out;
 	}
+
+	reg_request = list_first_entry(&reg_requests_list,
+				       struct regulatory_request,
+				       list);
+	list_del_init(&reg_request->list);
+
 	spin_unlock(&reg_requests_lock);
 
+	reg_process_hint(reg_request);
+
+out:
 	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 }
@@ -2057,6 +2089,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	nl80211_send_reg_change_event(last_request);
 
+	reg_set_request_processed();
+
 	mutex_unlock(&reg_mutex);
 
 	return r;
-- 
1.7.3.2.90.gd4c43

