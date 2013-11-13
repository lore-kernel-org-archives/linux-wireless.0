Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49139 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759595Ab3KMSNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:13:06 -0500
Received: by mail-wg0-f44.google.com with SMTP id k14so799919wgh.35
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 10:13:05 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory hint
Date: Wed, 13 Nov 2013 19:12:55 +0100
Message-Id: <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191313_235396_DAAC8CAF)
In-Reply-To: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This also records the wdev on the last regulatory request,
this can be used later to help quiesce wdev's at appropriate
times by the regulatory core.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/regulatory.h |  4 ++++
 net/wireless/reg.c       |  5 ++++-
 net/wireless/reg.h       | 13 +++++++------
 net/wireless/sme.c       |  2 +-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index ab0bee0..40df080 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -42,6 +42,9 @@ enum environment_cap {
  * 	can be used by the wireless core to deal with conflicts
  * 	and potentially inform users of which devices specifically
  * 	cased the conflicts.
+ * @wdev: this is set for %REGDOM_SET_BY_COUNTRY_IE to help avoid
+ * 	trying to quiesce the same wdev if the country IE was
+ * 	issued through it.
  * @initiator: indicates who sent this request, could be any of
  * 	of those set in nl80211_reg_initiator (%NL80211_REGDOM_SET_BY_*)
  * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
@@ -76,6 +79,7 @@ enum environment_cap {
 struct regulatory_request {
 	struct rcu_head rcu_head;
 	int wiphy_idx;
+	struct wireless_dev *wdev;
 	enum nl80211_reg_initiator initiator;
 	enum nl80211_user_reg_hint_type user_reg_hint_type;
 	char alpha2[2];
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4bfbeaa..e5935c2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1871,12 +1871,14 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
-void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
+void regulatory_hint_country_ie(struct wireless_dev *wdev,
+				enum ieee80211_band band,
 				const u8 *country_ie, u8 country_ie_len)
 {
 	char alpha2[2];
 	enum environment_cap env = ENVIRON_ANY;
 	struct regulatory_request *request = NULL, *lr;
+	struct wiphy *wiphy = wdev->wiphy;
 
 	/* IE len must be evenly divisible by 2 */
 	if (country_ie_len & 0x01)
@@ -1913,6 +1915,7 @@ void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
 		goto out;
 
 	request->wiphy_idx = get_wiphy_idx(wiphy);
+	request->wdev = wdev;
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_COUNTRY_IE;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 02bd8f4..3b1e352 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -61,8 +61,9 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 
 /**
  * regulatory_hint_country_ie - hints a country IE as a regulatory domain
- * @wiphy: the wireless device giving the hint (used only for reporting
- *	conflicts)
+ * @wdev: the wireless device giving the hint, used for reporting
+ * 	conflicts and to quiesce devices which may disagree with the
+ * 	regulatory domain update.
  * @band: the band on which the country IE was received on. This determines
  *	the band we'll process the country IE channel triplets for.
  * @country_ie: pointer to the country IE
@@ -80,10 +81,10 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
  * not observed. For this reason if a triplet is seen with channel
  * information for a band the BSS is not present in it will be ignored.
  */
-void regulatory_hint_country_ie(struct wiphy *wiphy,
-			 enum ieee80211_band band,
-			 const u8 *country_ie,
-			 u8 country_ie_len);
+void regulatory_hint_country_ie(struct wireless_dev *wdev,
+				enum ieee80211_band band,
+				const u8 *country_ie,
+				u8 country_ie_len);
 
 /**
  * regulatory_hint_disconnect - informs all devices have been disconneted
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 65f8008..0a5d304 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -682,7 +682,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	 * - country_ie + 2, the start of the country ie data, and
 	 * - and country_ie[1] which is the IE length
 	 */
-	regulatory_hint_country_ie(wdev->wiphy, bss->channel->band,
+	regulatory_hint_country_ie(wdev, bss->channel->band,
 				   country_ie + 2, country_ie[1]);
 	kfree(country_ie);
 }
-- 
1.8.4.rc3

