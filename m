Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZBUFYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:24:19 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] cfg80211: make __regulatory_hint() static
Date: Sat, 21 Feb 2009 00:24:13 -0500
Message-Id: <1235193856-3524-2-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062428_993864_99D32875)
In-Reply-To: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
References: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   23 +++++++++++++++++++++--
 net/wireless/reg.h |   23 -----------------------
 2 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e5e432d..0253d01 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1324,8 +1324,27 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	return -EINVAL;
 }
 
-/* Caller must hold &cfg80211_mutex */
-int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
+/**
+ * __regulatory_hint - hint to the wireless core a regulatory domain
+ * @wiphy: if the hint comes from country information from an AP, this
+ *	is required to be set to the wiphy that received the information
+ * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
+ *	should be in.
+ * @country_ie_checksum: checksum of processed country IE, set this to 0
+ * 	if the hint did not come from a country IE
+ * @country_ie_env: the environment the IE told us we are in, %ENVIRON_*
+ *
+ * The Wireless subsystem can use this function to hint to the wireless core
+ * what it believes should be the current regulatory domain by giving it an
+ * ISO/IEC 3166 alpha2 country code it knows its regulatory domain should be
+ * in.
+ *
+ * Returns zero if all went fine, %-EALREADY if a regulatory domain had
+ * already been set or other standard error codes.
+ *
+ * Caller must hold &cfg80211_mutex
+ */
+static int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 			const char *alpha2,
 			u32 country_ie_checksum,
 			enum environment_cap env)
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 65bfd05..e37829a 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -16,29 +16,6 @@ void regulatory_exit(void);
 int set_regdom(const struct ieee80211_regdomain *rd);
 
 /**
- * __regulatory_hint - hint to the wireless core a regulatory domain
- * @wiphy: if the hint comes from country information from an AP, this
- *	is required to be set to the wiphy that received the information
- * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
- *	should be in.
- * @country_ie_checksum: checksum of processed country IE, set this to 0
- * 	if the hint did not come from a country IE
- * @country_ie_env: the environment the IE told us we are in, %ENVIRON_*
- *
- * The Wireless subsystem can use this function to hint to the wireless core
- * what it believes should be the current regulatory domain by giving it an
- * ISO/IEC 3166 alpha2 country code it knows its regulatory domain should be
- * in.
- *
- * Returns zero if all went fine, %-EALREADY if a regulatory domain had
- * already been set or other standard error codes.
- *
- */
-extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-			     const char *alpha2, u32 country_ie_checksum,
-			     enum environment_cap country_ie_env);
-
-/**
  * regulatory_hint_found_beacon - hints a beacon was found on a channel
  * @wiphy: the wireless device where the beacon was found on
  * @beacon_chan: the channel on which the beacon was found on
-- 
1.6.0.3

