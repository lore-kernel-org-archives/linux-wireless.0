Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60608 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JEBHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 21:07:31 -0400
Received: by mail-ie0-f177.google.com with SMTP id qd12so10942858ieb.36
        for <linux-wireless@vger.kernel.org>; Fri, 04 Oct 2013 18:07:31 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] cfg80211: rename regulatory_hint_11d() to regulatory_hint_country_ie()
Date: Fri,  4 Oct 2013 18:07:24 -0700
Message-Id: <1380935244-22612-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131005_030746_756491_ABE67434)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is incorrect to refer to this as 11d as 802.11d was just a
proposed ammendment, 802.11d was merged to the standard so
use proper terminology.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/uapi/linux/nl80211.h | 2 +-
 net/wireless/reg.c           | 4 ++--
 net/wireless/reg.h           | 4 ++--
 net/wireless/sme.c           | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..71b519f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -988,7 +988,7 @@ enum nl80211_commands {
  * 	to query the CRDA to retrieve one regulatory domain. This attribute can
  * 	also be used by userspace to query the kernel for the currently set
  * 	regulatory domain. We chose an alpha2 as that is also used by the
- * 	IEEE-802.11d country information element to identify a country.
+ * 	IEEE-802.11 country information element to identify a country.
  * 	Users can also simply ask the wireless core to set regulatory domain
  * 	to a specific alpha2.
  * @NL80211_ATTR_REG_RULES: a nested array of regulatory domain regulatory
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ec3d45e..16c93ec 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1703,8 +1703,8 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
-void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
-			 const u8 *country_ie, u8 country_ie_len)
+void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
+				const u8 *country_ie, u8 country_ie_len)
 {
 	char alpha2[2];
 	enum environment_cap env = ENVIRON_ANY;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index af2d5f8..9677e3c 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -58,7 +58,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 				 gfp_t gfp);
 
 /**
- * regulatory_hint_11d - hints a country IE as a regulatory domain
+ * regulatory_hint_country_ie - hints a country IE as a regulatory domain
  * @wiphy: the wireless device giving the hint (used only for reporting
  *	conflicts)
  * @band: the band on which the country IE was received on. This determines
@@ -78,7 +78,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
  * not observed. For this reason if a triplet is seen with channel
  * information for a band the BSS is not present in it will be ignored.
  */
-void regulatory_hint_11d(struct wiphy *wiphy,
+void regulatory_hint_country_ie(struct wiphy *wiphy,
 			 enum ieee80211_band band,
 			 const u8 *country_ie,
 			 u8 country_ie_len);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 20e86a9..65f8008 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -682,8 +682,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	 * - country_ie + 2, the start of the country ie data, and
 	 * - and country_ie[1] which is the IE length
 	 */
-	regulatory_hint_11d(wdev->wiphy, bss->channel->band,
-			    country_ie + 2, country_ie[1]);
+	regulatory_hint_country_ie(wdev->wiphy, bss->channel->band,
+				   country_ie + 2, country_ie[1]);
 	kfree(country_ie);
 }
 
-- 
1.8.4.rc3

