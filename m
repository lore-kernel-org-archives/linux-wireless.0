Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZBUFYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:24:19 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] cfg80211: pass the regulatory_request struct in __regulatory_hint()
Date: Sat, 21 Feb 2009 00:24:14 -0500
Message-Id: <1235193856-3524-3-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062427_749436_6C0C611A)
In-Reply-To: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
References: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were passing value by value, lets just pass the struct.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   45 ++++++++++++++++++---------------------------
 1 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0253d01..6e17337 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1328,26 +1328,18 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if the hint comes from country information from an AP, this
  *	is required to be set to the wiphy that received the information
- * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
- *	should be in.
- * @country_ie_checksum: checksum of processed country IE, set this to 0
- * 	if the hint did not come from a country IE
- * @country_ie_env: the environment the IE told us we are in, %ENVIRON_*
+ * @pending_request: the regulatory request currently being processed
  *
  * The Wireless subsystem can use this function to hint to the wireless core
- * what it believes should be the current regulatory domain by giving it an
- * ISO/IEC 3166 alpha2 country code it knows its regulatory domain should be
- * in.
+ * what it believes should be the current regulatory domain.
  *
  * Returns zero if all went fine, %-EALREADY if a regulatory domain had
  * already been set or other standard error codes.
  *
  * Caller must hold &cfg80211_mutex
  */
-static int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-			const char *alpha2,
-			u32 country_ie_checksum,
-			enum environment_cap env)
+static int __regulatory_hint(struct wiphy *wiphy,
+			     struct regulatory_request *pending_request)
 {
 	struct regulatory_request *request;
 	bool intersect = false;
@@ -1355,10 +1347,12 @@ static int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 
 	assert_cfg80211_lock();
 
-	r = ignore_request(wiphy, set_by, alpha2);
+	r = ignore_request(wiphy,
+			  pending_request->initiator,
+			  pending_request->alpha2);
 
 	if (r == REG_INTERSECT) {
-		if (set_by == REGDOM_SET_BY_DRIVER) {
+		if (pending_request->initiator == REGDOM_SET_BY_DRIVER) {
 			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
 			if (r)
 				return r;
@@ -1370,7 +1364,8 @@ static int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		 * driver has already been set just copy it to the
 		 * wiphy
 		 */
-		if (r == -EALREADY && set_by == REGDOM_SET_BY_DRIVER) {
+		if (r == -EALREADY &&
+		    pending_request->initiator == REGDOM_SET_BY_DRIVER) {
 			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
 			if (r)
 				return r;
@@ -1386,13 +1381,13 @@ new_request:
 	if (!request)
 		return -ENOMEM;
 
-	request->alpha2[0] = alpha2[0];
-	request->alpha2[1] = alpha2[1];
-	request->initiator = set_by;
-	request->wiphy_idx = get_wiphy_idx(wiphy);
+	request->alpha2[0] = pending_request->alpha2[0];
+	request->alpha2[1] = pending_request->alpha2[1];
+	request->initiator = pending_request->initiator;
+	request->wiphy_idx = pending_request->wiphy_idx;
 	request->intersect = intersect;
-	request->country_ie_checksum = country_ie_checksum;
-	request->country_ie_env = env;
+	request->country_ie_checksum = pending_request->country_ie_checksum;
+	request->country_ie_env = pending_request->country_ie_env;
 
 	kfree(last_request);
 	last_request = request;
@@ -1411,7 +1406,7 @@ new_request:
 	 *
 	 * to intersect with the static rd
 	 */
-	return call_crda(alpha2);
+	return call_crda(request->alpha2);
 }
 
 /* This currently only processes user and driver regulatory hints */
@@ -1433,11 +1428,7 @@ static int reg_process_hint(struct regulatory_request *reg_request)
 		goto out;
 	}
 
-	r = __regulatory_hint(wiphy,
-			      reg_request->initiator,
-			      reg_request->alpha2,
-			      reg_request->country_ie_checksum,
-			      reg_request->country_ie_env);
+	r = __regulatory_hint(wiphy, reg_request);
 	/* This is required so that the orig_* parameters are saved */
 	if (r == -EALREADY && wiphy && wiphy->strict_regulatory)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
-- 
1.6.0.3

