Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32513 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZBNGmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 01:42:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 22:42:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] cfg80211: rename regdom_changed to regdom_changes() and use it
Date: Fri, 13 Feb 2009 22:41:42 -0800
Message-ID: <1234593702-19750-4-git-send-email-lrodriguez@atheros.com> (sfid-20090214_074234_514026_359EC535)
In-Reply-To: <1234593702-19750-1-git-send-email-lrodriguez@atheros.com>
References: <1234593702-19750-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We also add an assert_cfg80211_lock() as the cfg80211_regdomain
will be checked.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b32ee15..487f4ee 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -300,7 +300,7 @@ static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)
 	return false;
 }
 
-static bool regdom_changed(const char *alpha2)
+static bool regdom_changes(const char *alpha2)
 {
 	assert_cfg80211_lock();
 
@@ -1143,8 +1143,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 				 * intersect them, but that seems unlikely
 				 * to be correct. Reject second one for now.
 				 */
-				if (!alpha2_equal(alpha2,
-						  cfg80211_regdomain->alpha2))
+				if (regdom_changes(alpha2))
 					return -EOPNOTSUPP;
 				return -EALREADY;
 			}
@@ -1152,8 +1151,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			 * Two consecutive Country IE hints on the same wiphy.
 			 * This should be picked up early by the driver/stack
 			 */
-			if (WARN_ON(!alpha2_equal(cfg80211_regdomain->alpha2,
-				  alpha2)))
+			if (WARN_ON(regdom_changes(alpha2)))
 				return 0;
 			return -EALREADY;
 		}
@@ -1162,7 +1160,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		if (last_request->initiator == REGDOM_SET_BY_CORE) {
 			if (is_old_static_regdom(cfg80211_regdomain))
 				return 0;
-			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+			if (regdom_changes(alpha2))
 				return 0;
 			return -EALREADY;
 		}
@@ -1173,7 +1171,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		 * loaded card also agrees on the regulatory domain.
 		 */
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
-		    alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+		    !regdom_changes(alpha2))
 			return -EALREADY;
 
 		return REG_INTERSECT;
@@ -1194,13 +1192,12 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		if (last_request->initiator == REGDOM_SET_BY_CORE ||
 		    last_request->initiator == REGDOM_SET_BY_DRIVER ||
 		    last_request->initiator == REGDOM_SET_BY_USER) {
-			if (!alpha2_equal(last_request->alpha2,
-			    cfg80211_regdomain->alpha2))
+			if (regdom_changes(last_request->alpha2))
 				return -EAGAIN;
 		}
 
 		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+		    !regdom_changes(alpha2))
 			return -EALREADY;
 
 		return 0;
@@ -1632,10 +1629,12 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 * and the pending request came in from a country IE
 	 */
 	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE) {
-		/* If someone else asked us to change the rd lets only bother
-		 * checking if the alpha2 changes if CRDA was already called */
+		/*
+		 * If someone else asked us to change the rd lets only bother
+		 * checking if the alpha2 changes if CRDA was already called
+		 */
 		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changed(rd->alpha2))
+		    !regdom_changes(rd->alpha2))
 			return -EINVAL;
 	}
 
-- 
1.6.1.2.253.ga34a

