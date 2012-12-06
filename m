Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945963Ab2LFQr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/24] regulatory: clean up regdom_intersect
Date: Thu,  6 Dec 2012 17:47:27 +0100
Message-Id: <1354812468-15709-4-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174758_687657_F3325805)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the dummy_rule (also renamed from irule) is only
used for output by the reg_rules_intersect() function
there's no need to clear it at all, remove that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 70255c9..0f25a1a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -609,12 +609,7 @@ static struct ieee80211_regdomain *regdom_intersect(
 	struct ieee80211_reg_rule *intersected_rule;
 	struct ieee80211_regdomain *rd;
 	/* This is just a dummy holder to help us count */
-	struct ieee80211_reg_rule irule;
-
-	/* Uses the stack temporarily for counter arithmetic */
-	intersected_rule = &irule;
-
-	memset(intersected_rule, 0, sizeof(struct ieee80211_reg_rule));
+	struct ieee80211_reg_rule dummy_rule;
 
 	if (!rd1 || !rd2)
 		return NULL;
@@ -631,11 +626,8 @@ static struct ieee80211_regdomain *regdom_intersect(
 		rule1 = &rd1->reg_rules[x];
 		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
-			if (!reg_rules_intersect(rule1, rule2,
-					intersected_rule))
+			if (!reg_rules_intersect(rule1, rule2, &dummy_rule))
 				num_rules++;
-			memset(intersected_rule, 0,
-					sizeof(struct ieee80211_reg_rule));
 		}
 	}
 
-- 
1.8.0

