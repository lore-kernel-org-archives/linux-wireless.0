Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42528 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbZAVXGy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 09/12] cfg80211: pass more detailed regulatory request information on reg_notifier()
Date: Thu, 22 Jan 2009 15:05:51 -0800
Message-ID: <1232665554-26132-10-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000707_895453_E584E91C)
In-Reply-To: <1232665554-26132-9-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-5-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-6-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-7-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-8-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-9-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers may need more information than just who set the last regulatory domain,
as such lets just pass the last regulatory_request receipt. To do this we need
to move out to headers struct regulatory_request, and enum environment_cap. While
at it lets add documentation for enum environment_cap.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/net/wireless.h |    3 ++-
 net/wireless/reg.c     |   34 +---------------------------------
 net/wireless/reg.h     |    7 -------
 4 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f19c3e1..dd1fd51 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -357,6 +357,51 @@ enum reg_set_by {
 	REGDOM_SET_BY_COUNTRY_IE,
 };
 
+/**
+ * enum environment_cap - Environment parsed from country IE
+ * @ENVIRON_ANY: indicates country IE applies to both indoor and
+ * 	outdoor operation.
+ * @ENVIRON_INDOOR: indicates country IE applies only to indoor operation
+ * @ENVIRON_OUTDOOR: indicates country IE applies only to outdoor operation
+ */
+enum environment_cap {
+	ENVIRON_ANY,
+	ENVIRON_INDOOR,
+	ENVIRON_OUTDOOR,
+};
+
+/**
+ * struct regulatory_request - receipt of last regulatory request
+ *
+ * @wiphy: this is set if this request's initiator is
+ * 	%REGDOM_SET_BY_COUNTRY_IE or %REGDOM_SET_BY_DRIVER. This
+ * 	can be used by the wireless core to deal with conflicts
+ * 	and potentially inform users of which devices specifically
+ * 	cased the conflicts.
+ * @initiator: indicates who sent this request, could be any of
+ * 	of those set in reg_set_by, %REGDOM_SET_BY_*
+ * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
+ * 	regulatory domain. We have a few special codes:
+ * 	00 - World regulatory domain
+ * 	99 - built by driver but a specific alpha2 cannot be determined
+ * 	98 - result of an intersection between two regulatory domains
+ * @intersect: indicates whether the wireless core should intersect
+ * 	the requested regulatory domain with the presently set regulatory
+ * 	domain.
+ * @country_ie_checksum: checksum of the last processed and accepted
+ * 	country IE
+ * @country_ie_env: lets us know if the AP is telling us we are outdoor,
+ * 	indoor, or if it doesn't matter
+ */
+struct regulatory_request {
+	struct wiphy *wiphy;
+	enum reg_set_by initiator;
+	char alpha2[2];
+	bool intersect;
+	u32 country_ie_checksum;
+	enum environment_cap country_ie_env;
+};
+
 struct ieee80211_freq_range {
 	u32 start_freq_khz;
 	u32 end_freq_khz;
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 438cba9..fbe7341 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -213,7 +213,8 @@ struct wiphy {
 	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
 
 	/* Lets us get back the wiphy on the callback */
-	int (*reg_notifier)(struct wiphy *wiphy, enum reg_set_by setby);
+	int (*reg_notifier)(struct wiphy *wiphy,
+			    struct regulatory_request *request);
 
 	/* fields below are read-only, assigned by cfg80211 */
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a362c87..57a3fb4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -42,38 +42,6 @@
 #include "core.h"
 #include "reg.h"
 
-/**
- * struct regulatory_request - receipt of last regulatory request
- *
- * @wiphy: this is set if this request's initiator is
- * 	%REGDOM_SET_BY_COUNTRY_IE or %REGDOM_SET_BY_DRIVER. This
- * 	can be used by the wireless core to deal with conflicts
- * 	and potentially inform users of which devices specifically
- * 	cased the conflicts.
- * @initiator: indicates who sent this request, could be any of
- * 	of those set in reg_set_by, %REGDOM_SET_BY_*
- * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
- * 	regulatory domain. We have a few special codes:
- * 	00 - World regulatory domain
- * 	99 - built by driver but a specific alpha2 cannot be determined
- * 	98 - result of an intersection between two regulatory domains
- * @intersect: indicates whether the wireless core should intersect
- * 	the requested regulatory domain with the presently set regulatory
- * 	domain.
- * @country_ie_checksum: checksum of the last processed and accepted
- * 	country IE
- * @country_ie_env: lets us know if the AP is telling us we are outdoor,
- * 	indoor, or if it doesn't matter
- */
-struct regulatory_request {
-	struct wiphy *wiphy;
-	enum reg_set_by initiator;
-	char alpha2[2];
-	bool intersect;
-	u32 country_ie_checksum;
-	enum environment_cap country_ie_env;
-};
-
 /* Receipt of information from last regulatory request */
 static struct regulatory_request *last_request;
 
@@ -959,7 +927,7 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 			handle_band(wiphy, band);
 	}
 	if (wiphy->reg_notifier)
-		wiphy->reg_notifier(wiphy, setby);
+		wiphy->reg_notifier(wiphy, last_request);
 }
 
 static void handle_channel_custom(struct wiphy *wiphy,
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index a76ea3f..eb1dd5b 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -11,13 +11,6 @@ void regulatory_exit(void);
 
 int set_regdom(const struct ieee80211_regdomain *rd);
 
-enum environment_cap {
-	ENVIRON_ANY,
-	ENVIRON_INDOOR,
-	ENVIRON_OUTDOOR,
-};
-
-
 /**
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if the hint comes from country information from an AP, this
-- 
1.6.1.rc3.51.g5832d

