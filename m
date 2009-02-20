Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZBTFne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 00:43:34 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 15/15] cfg80211: rename regdom_changed to regdom_changes() and use it
Date: Fri, 20 Feb 2009 00:42:50 -0500
Message-Id: <1235108570-17652-16-git-send-email-lrodriguez@atheros.com> (sfid-20090220_065322_732923_BD327A1E)
In-Reply-To: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
References: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0a8244e..605299f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -291,7 +291,7 @@ static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)
 	return false;
 }
 
-static bool regdom_changed(const char *alpha2)
+static bool regdom_changes(const char *alpha2)
 {
 	assert_cfg80211_lock();
 
@@ -1134,8 +1134,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 				 * intersect them, but that seems unlikely
 				 * to be correct. Reject second one for now.
 				 */
-				if (!alpha2_equal(alpha2,
-						  cfg80211_regdomain->alpha2))
+				if (regdom_changes(alpha2))
 					return -EOPNOTSUPP;
 				return -EALREADY;
 			}
@@ -1143,8 +1142,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			 * Two consecutive Country IE hints on the same wiphy.
 			 * This should be picked up early by the driver/stack
 			 */
-			if (WARN_ON(!alpha2_equal(cfg80211_regdomain->alpha2,
-				  alpha2)))
+			if (WARN_ON(regdom_changes(alpha2)))
 				return 0;
 			return -EALREADY;
 		}
@@ -1153,7 +1151,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		if (last_request->initiator == REGDOM_SET_BY_CORE) {
 			if (is_old_static_regdom(cfg80211_regdomain))
 				return 0;
-			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+			if (regdom_changes(alpha2))
 				return 0;
 			return -EALREADY;
 		}
@@ -1164,7 +1162,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		 * loaded card also agrees on the regulatory domain.
 		 */
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
-		    alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+		    !regdom_changes(alpha2))
 			return -EALREADY;
 
 		return REG_INTERSECT;
@@ -1185,13 +1183,12 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
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
@@ -1720,7 +1717,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * checking if the alpha2 changes if CRDA was already called
 		 */
 		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changed(rd->alpha2))
+		    !regdom_changes(rd->alpha2))
 			return -EINVAL;
 	}
 
-- 
1.6.0.3

