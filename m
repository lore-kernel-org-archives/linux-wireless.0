Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13731 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbYKLWWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:22:11 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 04/10] cfg80211: separate intersection section in __set_regdom()
Date: Wed, 12 Nov 2008 14:21:58 -0800
Message-ID: <1226528524-32678-5-git-send-email-lrodriguez@atheros.com> (sfid-20081112_232217_495504_27711B0D)
In-Reply-To: <1226528524-32678-4-git-send-email-lrodriguez@atheros.com>
References: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-2-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-3-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far the __set_regdom() code is pretty generic as the
intersection case is fairly straight forward; this will however
change when 802.11d support is added so lets separate intersection
code for now in preparation for 802.11d support.

This patch only has slight functional changes.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 290ecec..845e2d3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -826,10 +826,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (WARN_ON(!reg_is_valid_request(rd->alpha2)))
 		return -EINVAL;
 
-	reset_regdomains();
-
-	/* Country IE parsing coming soon */
-
 	if (!is_valid_rd(rd)) {
 		printk(KERN_ERR "cfg80211: Invalid "
 			"regulatory domain detected:\n");
@@ -837,16 +833,33 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 	}
 
-	if (unlikely(last_request->intersect)) {
+	if (!last_request->intersect) {
+		reset_regdomains();
+		cfg80211_regdomain = rd;
+		return 0;
+	}
+
+	/* Intersection requires a bit more work */
+
+	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE) {
+
 		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
 		if (!intersected_rd)
 			return -EINVAL;
+
+		/* We can trash what CRDA provided now */
 		kfree(rd);
-		rd = intersected_rd;
+		rd = NULL;
+
+		reset_regdomains();
+		cfg80211_regdomain = intersected_rd;
+
+		return 0;
 	}
 
-	/* Tada! */
-	cfg80211_regdomain = rd;
+	/* Country IE parsing coming soon */
+	reset_regdomains();
+	WARN_ON(1);
 
 	return 0;
 }
-- 
1.5.6.3

