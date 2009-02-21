Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZBUFYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:24:18 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/4] cfg80211: pass the regulatory_request to ignore_request
Date: Sat, 21 Feb 2009 00:24:16 -0500
Message-Id: <1235193856-3524-5-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062431_314462_87FD4A34)
In-Reply-To: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
References: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6152a7a..ce66bfd 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1231,8 +1231,8 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 
 /* This has the logic which determines when a new request
  * should be ignored. */
-static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
-			  const char *alpha2)
+static int ignore_request(struct wiphy *wiphy,
+			  struct regulatory_request *pending_request)
 {
 	struct wiphy *last_wiphy = NULL;
 
@@ -1242,7 +1242,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	if (!last_request)
 		return 0;
 
-	switch (set_by) {
+	switch (pending_request->initiator) {
 	case REGDOM_SET_BY_INIT:
 		return -EINVAL;
 	case REGDOM_SET_BY_CORE:
@@ -1251,7 +1251,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 
 		last_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
-		if (unlikely(!is_an_alpha2(alpha2)))
+		if (unlikely(!is_an_alpha2(pending_request->alpha2)))
 			return -EINVAL;
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
 			if (last_wiphy != wiphy) {
@@ -1261,7 +1261,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 				 * intersect them, but that seems unlikely
 				 * to be correct. Reject second one for now.
 				 */
-				if (regdom_changes(alpha2))
+				if (regdom_changes(pending_request->alpha2))
 					return -EOPNOTSUPP;
 				return -EALREADY;
 			}
@@ -1269,7 +1269,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			 * Two consecutive Country IE hints on the same wiphy.
 			 * This should be picked up early by the driver/stack
 			 */
-			if (WARN_ON(regdom_changes(alpha2)))
+			if (WARN_ON(regdom_changes(pending_request->alpha2)))
 				return 0;
 			return -EALREADY;
 		}
@@ -1278,7 +1278,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		if (last_request->initiator == REGDOM_SET_BY_CORE) {
 			if (is_old_static_regdom(cfg80211_regdomain))
 				return 0;
-			if (regdom_changes(alpha2))
+			if (regdom_changes(pending_request->alpha2))
 				return 0;
 			return -EALREADY;
 		}
@@ -1289,7 +1289,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		 * loaded card also agrees on the regulatory domain.
 		 */
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
-		    !regdom_changes(alpha2))
+		    !regdom_changes(pending_request->alpha2))
 			return -EALREADY;
 
 		return REG_INTERSECT;
@@ -1315,7 +1315,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		}
 
 		if (!is_old_static_regdom(cfg80211_regdomain) &&
-		    !regdom_changes(alpha2))
+		    !regdom_changes(pending_request->alpha2))
 			return -EALREADY;
 
 		return 0;
@@ -1346,9 +1346,7 @@ static int __regulatory_hint(struct wiphy *wiphy,
 
 	assert_cfg80211_lock();
 
-	r = ignore_request(wiphy,
-			  pending_request->initiator,
-			  pending_request->alpha2);
+	r = ignore_request(wiphy, pending_request);
 
 	if (r == REG_INTERSECT) {
 		if (pending_request->initiator == REGDOM_SET_BY_DRIVER) {
-- 
1.6.0.3

