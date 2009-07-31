Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56235 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZGaAj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 20:39:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 17:40:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 2/4] cfg80211: do not iterate over rdev list on country IE hint
Date: Thu, 30 Jul 2009 17:38:07 -0700
Message-ID: <1249000689-14970-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249000689-14970-1-git-send-email-lrodriguez@atheros.com>
References: <1249000689-14970-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify the country IE hint code by just bailing out if
a previous country IE has been issued. We currently just trust
the first AP we connect to on any card. The idea was to perform
conflict resolution within this routine but since we can no longer
iterate over the registered device list here we leave conflict
resolution to be dealt with at a later time on the workqueue.

This code has no functional changes other than saving us an
interation over the registered device list when a second card
is connected, or you unplug and connect the same one, and a
country IE is received. This would have been done upon every
beacon received.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   51 +++++++++------------------------------------------
 1 files changed, 9 insertions(+), 42 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2d1d183..f386981 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1762,6 +1762,10 @@ static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 	return false;
 }
 
+/*
+ * We hold wdev_lock() here so we cannot hold cfg80211_mutex() and
+ * therefore cannot iterate over the rdev list here.
+ */
 void regulatory_hint_11d(struct wiphy *wiphy,
 			u8 *country_ie,
 			u8 country_ie_len)
@@ -1804,51 +1808,14 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	 * We will run this for *every* beacon processed for the BSSID, so
 	 * we optimize an early check to exit out early if we don't have to
 	 * do anything
+	 *
+	 * We leave conflict resolution to the workqueue, where can hold
+	 * cfg80211_mutex.
 	 */
 	if (likely(last_request->initiator ==
 	    NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    wiphy_idx_valid(last_request->wiphy_idx))) {
-		struct cfg80211_registered_device *rdev_last_ie;
-
-		rdev_last_ie =
-			cfg80211_rdev_by_wiphy_idx(last_request->wiphy_idx);
-
-		/*
-		 * Lets keep this simple -- we trust the first AP
-		 * after we intersect with CRDA
-		 */
-		if (likely(&rdev_last_ie->wiphy == wiphy)) {
-			/*
-			 * Ignore IEs coming in on this wiphy with
-			 * the same alpha2 and environment cap
-			 */
-			if (likely(alpha2_equal(rdev_last_ie->country_ie_alpha2,
-				  alpha2) &&
-				  env == rdev_last_ie->env)) {
-				goto out;
-			}
-			/*
-			 * the wiphy moved on to another BSSID or the AP
-			 * was reconfigured. XXX: We need to deal with the
-			 * case where the user suspends and goes to goes
-			 * to another country, and then gets IEs from an
-			 * AP with different settings
-			 */
-			goto out;
-		} else {
-			/*
-			 * Ignore IEs coming in on two separate wiphys with
-			 * the same alpha2 and environment cap
-			 */
-			if (likely(alpha2_equal(rdev_last_ie->country_ie_alpha2,
-				  alpha2) &&
-				  env == rdev_last_ie->env)) {
-				goto out;
-			}
-			/* We could potentially intersect though */
-			goto out;
-		}
-	}
+	    wiphy_idx_valid(last_request->wiphy_idx)))
+		goto out;
 
 	rd = country_ie_2_rd(country_ie, country_ie_len, &checksum);
 	if (!rd)
-- 
1.6.3.3

