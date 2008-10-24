Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYJXSeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:34:37 -0400
Message-Id: <20081024183323.955480000@sipsolutions.net> (sfid-20081024_203446_345359_1CAEBAC8)
References: <20081024183219.735241000@sipsolutions.net>
Date: Fri, 24 Oct 2008 20:32:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] wireless regulatory: move ignore_request
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is only used once, move it closer to its caller.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |  126 ++++++++++++++++++++++++++---------------------------
 1 file changed, 63 insertions(+), 63 deletions(-)

--- everything.orig/net/wireless/reg.c	2008-10-24 11:09:16.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-24 11:15:33.000000000 +0200
@@ -298,69 +298,6 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
 }
 
-/* This has the logic which determines when a new request
- * should be ignored. */
-static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
-			  const char *alpha2)
-{
-	/* All initial requests are respected */
-	if (!last_request)
-		return 0;
-
-	switch (set_by) {
-	case REGDOM_SET_BY_INIT:
-		return -EINVAL;
-	case REGDOM_SET_BY_CORE:
-		/*
-		 * Always respect new wireless core hints, should only happen
-		 * when updating the world regulatory domain at init.
-		 */
-		return 0;
-	case REGDOM_SET_BY_COUNTRY_IE:
-		if (unlikely(!is_an_alpha2(alpha2)))
-			return -EINVAL;
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
-			if (last_request->wiphy != wiphy) {
-				/*
-				 * Two cards with two APs claiming different
-				 * different Country IE alpha2s. We could
-				 * intersect them, but that seems unlikely
-				 * to be correct. Reject second one for now.
-				 */
-				if (!alpha2_equal(alpha2,
-						  cfg80211_regdomain->alpha2))
-					return -EOPNOTSUPP;
-				return -EALREADY;
-			}
-			/* Two consecutive Country IE hints on the same wiphy */
-			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
-				return 0;
-			return -EALREADY;
-		}
-		/*
-		 * Ignore Country IE hints for now, need to think about
-		 * what we need to do to support multi-domain operation.
-		 */
-		return -EOPNOTSUPP;
-	case REGDOM_SET_BY_DRIVER:
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			return -EALREADY;
-		return 0;
-	case REGDOM_SET_BY_USER:
-		/*
-		 * If the user wants to override the AP's hint, we may
-		 * need to follow both and use the intersection. For now,
-		 * reject any such attempt (but we don't support country
-		 * IEs right now anyway.)
-		 */
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
-			return -EOPNOTSUPP;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 /* Used by nl80211 before kmalloc'ing our regulatory domain */
 bool reg_is_valid_request(const char *alpha2)
 {
@@ -531,6 +468,69 @@ void wiphy_update_regulatory(struct wiph
 	}
 }
 
+/* This has the logic which determines when a new request
+ * should be ignored. */
+static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
+			  const char *alpha2)
+{
+	/* All initial requests are respected */
+	if (!last_request)
+		return 0;
+
+	switch (set_by) {
+	case REGDOM_SET_BY_INIT:
+		return -EINVAL;
+	case REGDOM_SET_BY_CORE:
+		/*
+		 * Always respect new wireless core hints, should only happen
+		 * when updating the world regulatory domain at init.
+		 */
+		return 0;
+	case REGDOM_SET_BY_COUNTRY_IE:
+		if (unlikely(!is_an_alpha2(alpha2)))
+			return -EINVAL;
+		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
+			if (last_request->wiphy != wiphy) {
+				/*
+				 * Two cards with two APs claiming different
+				 * different Country IE alpha2s. We could
+				 * intersect them, but that seems unlikely
+				 * to be correct. Reject second one for now.
+				 */
+				if (!alpha2_equal(alpha2,
+						  cfg80211_regdomain->alpha2))
+					return -EOPNOTSUPP;
+				return -EALREADY;
+			}
+			/* Two consecutive Country IE hints on the same wiphy */
+			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+				return 0;
+			return -EALREADY;
+		}
+		/*
+		 * Ignore Country IE hints for now, need to think about
+		 * what we need to do to support multi-domain operation.
+		 */
+		return -EOPNOTSUPP;
+	case REGDOM_SET_BY_DRIVER:
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
+			return -EALREADY;
+		return 0;
+	case REGDOM_SET_BY_USER:
+		/*
+		 * If the user wants to override the AP's hint, we may
+		 * need to follow both and use the intersection. For now,
+		 * reject any such attempt (but we don't support country
+		 * IEs right now anyway.)
+		 */
+		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 /* Caller must hold &cfg80211_drv_mutex */
 int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		      const char *alpha2)

-- 

