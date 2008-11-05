Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64260 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbYKECuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 21:50:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 18:50:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] cfg80211: separate intersection section in __set_regdom()
Date: Tue, 4 Nov 2008 18:50:03 -0800
Message-ID: <1225853406-16322-5-git-send-email-lrodriguez@atheros.com> (sfid-20081105_035024_561209_2C3E6FC6)
In-Reply-To: <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
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

