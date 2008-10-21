Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJUIRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 04:17:36 -0400
Subject: [PATCH] wireless: get rid of pointless request list
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 10:17:29 +0200
Message-Id: <1224577049.27899.103.camel@johannes.berg> (sfid-20081021_101741_281960_2F5ACD69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We really only need to know the last request at each point in time.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |   70 +++++++++++++----------------------------------------
 1 file changed, 18 insertions(+), 52 deletions(-)

--- everything.orig/net/wireless/reg.c	2008-10-21 09:59:00.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-21 10:16:10.000000000 +0200
@@ -44,14 +44,13 @@
 
 /* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
 struct regulatory_request {
-	struct list_head list;
 	struct wiphy *wiphy;
 	int granted;
 	enum reg_set_by initiator;
 	char alpha2[2];
 };
 
-static LIST_HEAD(regulatory_requests);
+static struct regulatory_request *last_request;
 
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
@@ -201,7 +200,7 @@ static void reset_regdomains(void)
  * core upon initialization */
 static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
-	BUG_ON(list_empty(&regulatory_requests));
+	BUG_ON(!last_request);
 
 	reset_regdomains();
 
@@ -302,15 +301,10 @@ static int call_crda(const char *alpha2)
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	char *alpha2, struct ieee80211_regdomain *rd)
 {
-	struct regulatory_request *last_request = NULL;
-
 	/* All initial requests are respected */
-	if (list_empty(&regulatory_requests))
+	if (!last_request)
 		return 0;
 
-	last_request = list_first_entry(&regulatory_requests,
-		struct regulatory_request, list);
-
 	switch (set_by) {
 	case REGDOM_SET_BY_INIT:
 		return -EINVAL;
@@ -320,7 +314,7 @@ static int ignore_request(struct wiphy *
 		 * anyway */
 		return 0;
 	case REGDOM_SET_BY_COUNTRY_IE:
-		if (last_request->initiator == set_by) {
+		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
 			if (last_request->wiphy != wiphy) {
 				/* Two cards with two APs claiming different
 				 * different Country IE alpha2s!
@@ -350,7 +344,7 @@ static int ignore_request(struct wiphy *
 		return 1;
 	case REGDOM_SET_BY_DRIVER:
 		BUG_ON(!wiphy);
-		if (last_request->initiator == set_by) {
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER) {
 			/* Two separate drivers hinting different things,
 			 * this is possible if you have two devices present
 			 * on a system with different EEPROM regulatory
@@ -376,8 +370,8 @@ static int ignore_request(struct wiphy *
 			return 0;
 		return 0;
 	case REGDOM_SET_BY_USER:
-		if (last_request->initiator == set_by ||
-				last_request->initiator == REGDOM_SET_BY_CORE)
+		if (last_request->initiator == REGDOM_SET_BY_USER ||
+		    last_request->initiator == REGDOM_SET_BY_CORE)
 			return 0;
 		/* Drivers can use their wiphy's reg_notifier()
 		 * to override any information */
@@ -395,14 +389,12 @@ static int ignore_request(struct wiphy *
 static bool __reg_is_valid_request(const char *alpha2,
 	struct regulatory_request **request)
 {
-	struct regulatory_request *req;
-	if (list_empty(&regulatory_requests))
+	if (!last_request)
 		return false;
-	list_for_each_entry(req, &regulatory_requests, list) {
-		if (alpha2_equal(req->alpha2, alpha2)) {
-			*request = req;
-			return true;
-		}
+
+	if (alpha2_equal(last_request->alpha2, alpha2)) {
+		*request = last_request;
+		return true;
 	}
 	return false;
 }
@@ -607,7 +599,8 @@ int __regulatory_hint(struct wiphy *wiph
 		request->initiator = set_by;
 		request->wiphy = wiphy;
 
-		list_add_tail(&request->list, &regulatory_requests);
+		kfree(last_request);
+		last_request = request;
 		if (rd)
 			break;
 		r = call_crda(alpha2);
@@ -726,7 +719,7 @@ static int __set_regdom(const struct iee
 			!is_unknown_alpha2(rd->alpha2))
 		return -EINVAL;
 
-	if (list_empty(&regulatory_requests))
+	if (!last_request)
 		return -EINVAL;
 
 	/* allow overriding the static definitions if CRDA is present */
@@ -776,37 +769,14 @@ static int __set_regdom(const struct iee
  * the passed rd. Caller must hold cfg80211_drv_mutex */
 int set_regdom(const struct ieee80211_regdomain *rd)
 {
-	struct regulatory_request *this_request = NULL, *prev_request = NULL;
+	struct regulatory_request *this_request = NULL;
 	int r;
 
-	if (!list_empty(&regulatory_requests))
-		prev_request = list_first_entry(&regulatory_requests,
-			struct regulatory_request, list);
-
 	/* Note that this doesn't update the wiphys, this is done below */
 	r = __set_regdom(rd);
 	if (r)
 		return r;
 
-	BUG_ON((!__reg_is_valid_request(rd->alpha2, &this_request)));
-
-	/* The initial standard core update of the world regulatory domain, no
-	 * need to keep that request info around if it didn't fail. */
-	if (is_world_regdom(rd->alpha2) &&
-			this_request->initiator == REGDOM_SET_BY_CORE &&
-			this_request->granted) {
-		list_del(&this_request->list);
-		kfree(this_request);
-		this_request = NULL;
-	}
-
-	/* Remove old requests, we only leave behind the last one */
-	if (prev_request) {
-		list_del(&prev_request->list);
-		kfree(prev_request);
-		prev_request = NULL;
-	}
-
 	/* This would make this whole thing pointless */
 	BUG_ON(rd != cfg80211_regdomain);
 
@@ -853,16 +823,12 @@ int regulatory_init(void)
 
 void regulatory_exit(void)
 {
-	struct regulatory_request *req, *req_tmp;
-
 	mutex_lock(&cfg80211_drv_mutex);
 
 	reset_regdomains();
 
-	list_for_each_entry_safe(req, req_tmp, &regulatory_requests, list) {
-		list_del(&req->list);
-		kfree(req);
-	}
+	kfree(last_request);
+
 	platform_device_unregister(reg_pdev);
 
 	mutex_unlock(&cfg80211_drv_mutex);


