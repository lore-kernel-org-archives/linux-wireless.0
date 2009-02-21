Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZBUFYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:24:19 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] cfg80211: do not kzalloc() again for a new request on __regulatory_hint
Date: Sat, 21 Feb 2009 00:24:15 -0500
Message-Id: <1235193856-3524-4-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062424_375093_B91D35F8)
In-Reply-To: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
References: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we already have a regulatory request from the workqueue use that
and avoid a new kzalloc()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   54 +++++++++++++++------------------------------------
 1 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6e17337..6152a7a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1341,7 +1341,6 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 static int __regulatory_hint(struct wiphy *wiphy,
 			     struct regulatory_request *pending_request)
 {
-	struct regulatory_request *request;
 	bool intersect = false;
 	int r = 0;
 
@@ -1354,8 +1353,10 @@ static int __regulatory_hint(struct wiphy *wiphy,
 	if (r == REG_INTERSECT) {
 		if (pending_request->initiator == REGDOM_SET_BY_DRIVER) {
 			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
-			if (r)
+			if (r) {
+				kfree(pending_request);
 				return r;
+			}
 		}
 		intersect = true;
 	} else if (r) {
@@ -1367,30 +1368,24 @@ static int __regulatory_hint(struct wiphy *wiphy,
 		if (r == -EALREADY &&
 		    pending_request->initiator == REGDOM_SET_BY_DRIVER) {
 			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
-			if (r)
+			if (r) {
+				kfree(pending_request);
 				return r;
+			}
 			r = -EALREADY;
 			goto new_request;
 		}
+		kfree(pending_request);
 		return r;
 	}
 
 new_request:
-	request = kzalloc(sizeof(struct regulatory_request),
-			  GFP_KERNEL);
-	if (!request)
-		return -ENOMEM;
+	kfree(last_request);
 
-	request->alpha2[0] = pending_request->alpha2[0];
-	request->alpha2[1] = pending_request->alpha2[1];
-	request->initiator = pending_request->initiator;
-	request->wiphy_idx = pending_request->wiphy_idx;
-	request->intersect = intersect;
-	request->country_ie_checksum = pending_request->country_ie_checksum;
-	request->country_ie_env = pending_request->country_ie_env;
+	last_request = pending_request;
+	last_request->intersect = intersect;
 
-	kfree(last_request);
-	last_request = request;
+	pending_request = NULL;
 
 	/* When r == REG_INTERSECT we do need to call CRDA */
 	if (r < 0)
@@ -1406,11 +1401,11 @@ new_request:
 	 *
 	 * to intersect with the static rd
 	 */
-	return call_crda(request->alpha2);
+	return call_crda(last_request->alpha2);
 }
 
 /* This currently only processes user and driver regulatory hints */
-static int reg_process_hint(struct regulatory_request *reg_request)
+static void reg_process_hint(struct regulatory_request *reg_request)
 {
 	int r = 0;
 	struct wiphy *wiphy = NULL;
@@ -1424,7 +1419,7 @@ static int reg_process_hint(struct regulatory_request *reg_request)
 
 	if (reg_request->initiator == REGDOM_SET_BY_DRIVER &&
 	    !wiphy) {
-		r = -ENODEV;
+		kfree(reg_request);
 		goto out;
 	}
 
@@ -1434,18 +1429,12 @@ static int reg_process_hint(struct regulatory_request *reg_request)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
 out:
 	mutex_unlock(&cfg80211_mutex);
-
-	if (r == -EALREADY)
-		r = 0;
-
-	return r;
 }
 
 /* Processes regulatory hints, this is all the REGDOM_SET_BY_* */
 static void reg_process_pending_hints(void)
 	{
 	struct regulatory_request *reg_request;
-	int r;
 
 	spin_lock(&reg_requests_lock);
 	while (!list_empty(&reg_requests_list)) {
@@ -1453,20 +1442,9 @@ static void reg_process_pending_hints(void)
 					       struct regulatory_request,
 					       list);
 		list_del_init(&reg_request->list);
-		spin_unlock(&reg_requests_lock);
 
-		r = reg_process_hint(reg_request);
-#ifdef CONFIG_CFG80211_REG_DEBUG
-		if (r && (reg_request->initiator == REGDOM_SET_BY_DRIVER ||
-		    reg_request->initiator == REGDOM_SET_BY_COUNTRY_IE))
-			printk(KERN_ERR "cfg80211: wiphy_idx %d sent a "
-				"regulatory hint for %c%c but now has "
-				"gone fishing, ignoring request\n",
-				reg_request->wiphy_idx,
-				reg_request->alpha2[0],
-				reg_request->alpha2[1]);
-#endif
-		kfree(reg_request);
+		spin_unlock(&reg_requests_lock);
+		reg_process_hint(reg_request);
 		spin_lock(&reg_requests_lock);
 	}
 	spin_unlock(&reg_requests_lock);
-- 
1.6.0.3

