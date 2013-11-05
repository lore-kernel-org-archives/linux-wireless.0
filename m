Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59285 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3KERRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:16 -0500
Received: by mail-bk0-f42.google.com with SMTP id w16so1265478bkz.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:15 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 02/19] cfg80211: force WIPHY_FLAG_CUSTOM_REGULATORY on wiphy_apply_custom_regulatory()
Date: Tue,  5 Nov 2013 09:18:00 -0800
Message-Id: <1383671897-7746-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181721_592190_C41B8C9D)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wiphy_apply_custom_regulatory() implies WIPHY_FLAG_CUSTOM_REGULATORY
but we never enforced it, do that now and warn if the driver
didn't set it. All drivers should be following this today already.

Having WIPHY_FLAG_CUSTOM_REGULATORY does not however mean you will
use wiphy_apply_custom_regulatory() though, you may have your own
_orig value set up tools / helpers. The intel drivers are examples
of this type of driver.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/cfg80211.h | 7 ++++++-
 net/wireless/reg.c     | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b5cee04..638fd67 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2433,7 +2433,9 @@ struct cfg80211_ops {
  * 	has its own custom regulatory domain and cannot identify the
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
  * 	we will disregard the first regulatory hint (when the
- * 	initiator is %REGDOM_SET_BY_CORE).
+ * 	initiator is %REGDOM_SET_BY_CORE). Drivers that use
+ * 	wiphy_apply_custom_regulatory() should have this flag set
+ * 	or the regulatory core will set it for wiphy.
  * @WIPHY_FLAG_STRICT_REGULATORY: tells us the driver for this device will
  *	ignore regulatory domain settings until it gets its own regulatory
  *	domain via its regulatory_hint() unless the regulatory hint is
@@ -3461,6 +3463,9 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
  * custom regulatory domain will be trusted completely and as such previous
  * default channel settings will be disregarded. If no rule is found for a
  * channel on the regulatory domain the channel will be disabled.
+ * Drivers using this for a wiphy should also set the wiphy flag
+ * WIPHY_FLAG_CUSTOM_REGULATORY or cfg80211 will set it for the wiphy
+ * that called this helper.
  */
 void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 				   const struct ieee80211_regdomain *regd);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 999b4bb7..6183c90 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1303,6 +1303,10 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	enum ieee80211_band band;
 	unsigned int bands_set = 0;
 
+	WARN(!(wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY),
+	     "wiphy should have WIPHY_FLAG_CUSTOM_REGULATORY\n");
+	wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
-- 
1.8.4.rc3

