Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10845 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbZG3BCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 21:02:01 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 18:02:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT] cfg80211: enable country IE support to all cfg80211 drivers
Date: Wed, 29 Jul 2009 18:01:59 -0700
Message-ID: <1248915719-6208-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the bss is always set now once we are connected, if the
bss has its own information element we refer to it and pass that
instead of relying on mac80211's parsing.

Now all cfg80211 drivers get country IE support, automatically.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Johill, I think this is what you wanted in the end, I tested it and
I get no country IE hint going through :( I could debug further but I'm
done for now and gotta work on some other stuff, not sure when I can
get back to this.

 include/net/cfg80211.h |   14 --------------
 net/mac80211/mlme.c    |    6 +-----
 net/wireless/reg.c     |    1 -
 net/wireless/reg.h     |   15 +++++++++++++++
 net/wireless/sme.c     |    5 +++++
 5 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1b9235..fa72997 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1514,20 +1514,6 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb);
 extern int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
 
 /**
- * regulatory_hint_11d - hints a country IE as a regulatory domain
- * @wiphy: the wireless device giving the hint (used only for reporting
- *	conflicts)
- * @country_ie: pointer to the country IE
- * @country_ie_len: length of the country IE
- *
- * We will intersect the rd with the what CRDA tells us should apply
- * for the alpha2 this country IE belongs to, this prevents APs from
- * sending us incorrect or outdated information against a country.
- */
-extern void regulatory_hint_11d(struct wiphy *wiphy,
-				u8 *country_ie,
-				u8 country_ie_len);
-/**
  * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
  * @wiphy: the wireless device we want to process the regulatory domain on
  * @regd: the custom regulatory domain to use for this wiphy
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0779ba1..5ff1496 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1846,12 +1846,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					       bssid, ap_ht_cap_flags);
 	}
 
+	/* Note: country IE parsing is done for us by cfg80211 */
 	if (elems.country_elem) {
-		/* Note we are only reviewing this on beacons
-		 * for the BSSID we are associated to */
-		regulatory_hint_11d(local->hw.wiphy,
-			elems.country_elem, elems.country_elem_len);
-
 		/* TODO: IBSS also needs this */
 		if (elems.pwr_constr_elem)
 			ieee80211_handle_pwr_constr(sdata,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 41c16fc..48158fc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1904,7 +1904,6 @@ free_rd_out:
 out:
 	spin_unlock(&reg_lock);
 }
-EXPORT_SYMBOL(regulatory_hint_11d);
 
 static bool freq_is_chan_12_13_14(u16 freq)
 {
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index e37829a..662a9da 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -36,4 +36,19 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 					struct ieee80211_channel *beacon_chan,
 					gfp_t gfp);
 
+/**
+ * regulatory_hint_11d - hints a country IE as a regulatory domain
+ * @wiphy: the wireless device giving the hint (used only for reporting
+ *	conflicts)
+ * @country_ie: pointer to the country IE
+ * @country_ie_len: length of the country IE
+ *
+ * We will intersect the rd with the what CRDA tells us should apply
+ * for the alpha2 this country IE belongs to, this prevents APs from
+ * sending us incorrect or outdated information against a country.
+ */
+void regulatory_hint_11d(struct wiphy *wiphy,
+			 u8 *country_ie,
+			 u8 country_ie_len);
+
 #endif  /* __NET_WIRELESS_REG_H */
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 3728d2b..c332c42 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -13,6 +13,7 @@
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
 #include "nl80211.h"
+#include "reg.h"
 
 struct cfg80211_conn {
 	struct cfg80211_connect_params params;
@@ -401,6 +402,10 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 
 	wdev->sme_state = CFG80211_SME_CONNECTED;
 	cfg80211_upload_connect_keys(wdev);
+
+	regulatory_hint_11d(wdev->wiphy,
+			    bss->information_elements,
+			    bss->len_information_elements);
 }
 
 void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
-- 
1.6.0.4

