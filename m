Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZCUDxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 23:53:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Quentin@armitage.org.uk,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/5] cfg80211: remove code about country IE support with OLD_REG
Date: Fri, 20 Mar 2009 23:53:07 -0400
Message-Id: <1237607588-6316-5-git-send-email-lrodriguez@atheros.com> (sfid-20090321_045325_222292_7783BC35)
In-Reply-To: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
References: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We had left in code to allow interested developers to add
support for parsing country IEs when OLD_REG was enabled.
This never happened and since we're going to remove OLD_REG
lets just remove these comments and code for it.

This code path was never being entered so this has no
functional change.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   39 +++++++++++----------------------------
 1 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ac048a1..6327e16 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1420,16 +1420,6 @@ new_request:
 		return r;
 	}
 
-	/*
-	 * Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
-	 * AND if CRDA is NOT present nothing will happen, if someone
-	 * wants to bother with 11d with OLD_REG you can add a timer.
-	 * If after x amount of time nothing happens you can call:
-	 *
-	 * return set_regdom(country_ie_regdomain);
-	 *
-	 * to intersect with the static rd
-	 */
 	return call_crda(last_request->alpha2);
 }
 
@@ -2033,28 +2023,21 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 */
 
 	BUG_ON(!country_ie_regdomain);
+	BUG_ON(rd == country_ie_regdomain);
 
-	if (rd != country_ie_regdomain) {
-		/*
-		 * Intersect what CRDA returned and our what we
-		 * had built from the Country IE received
-		 */
+	/*
+	 * Intersect what CRDA returned and our what we
+	 * had built from the Country IE received
+	 */
 
-		intersected_rd = regdom_intersect(rd, country_ie_regdomain);
+	intersected_rd = regdom_intersect(rd, country_ie_regdomain);
 
-		reg_country_ie_process_debug(rd, country_ie_regdomain,
-			intersected_rd);
+	reg_country_ie_process_debug(rd,
+				     country_ie_regdomain,
+				     intersected_rd);
 
-		kfree(country_ie_regdomain);
-		country_ie_regdomain = NULL;
-	} else {
-		/*
-		 * This would happen when CRDA was not present and
-		 * OLD_REGULATORY was enabled. We intersect our Country
-		 * IE rd and what was set on cfg80211 originally
-		 */
-		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
-	}
+	kfree(country_ie_regdomain);
+	country_ie_regdomain = NULL;
 
 	if (!intersected_rd)
 		return -EINVAL;
-- 
1.6.0.6

