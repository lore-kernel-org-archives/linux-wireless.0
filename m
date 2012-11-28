Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2K1Vjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 16:39:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix whitespace in scan handling
Date: Wed, 28 Nov 2012 22:40:07 +0100
Message-Id: <1354138807-22761-1-git-send-email-johannes@sipsolutions.net> (sfid-20121128_223946_720275_59EF73D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix a number of indentation and similar issues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 5af431f..9233910 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -238,9 +238,8 @@ void cfg80211_bss_age(struct cfg80211_registered_device *dev,
 	struct cfg80211_internal_bss *bss;
 	unsigned long age_jiffies = msecs_to_jiffies(age_secs * MSEC_PER_SEC);
 
-	list_for_each_entry(bss, &dev->bss_list, list) {
+	list_for_each_entry(bss, &dev->bss_list, list)
 		bss->ts -= age_jiffies;
-	}
 }
 
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
@@ -309,8 +308,7 @@ static int cmp_ies(u8 num, u8 *ies1, size_t len1, u8 *ies2, size_t len2)
 	return memcmp(ie1 + 2, ie2 + 2, ie1[1]);
 }
 
-static bool is_bss(struct cfg80211_bss *a,
-		   const u8 *bssid,
+static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
 		   const u8 *ssid, size_t ssid_len)
 {
 	const u8 *ssidie;
@@ -386,11 +384,10 @@ static bool is_mesh(struct cfg80211_bss *a,
 	 * part in the same mesh.
 	 */
 	return memcmp(ie + 2, meshcfg,
-	    sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
+		      sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
 }
 
-static int cmp_bss_core(struct cfg80211_bss *a,
-			struct cfg80211_bss *b)
+static int cmp_bss_core(struct cfg80211_bss *a, struct cfg80211_bss *b)
 {
 	int r;
 
@@ -435,8 +432,7 @@ static int cmp_bss(struct cfg80211_bss *a,
 		       b->len_information_elements);
 }
 
-static int cmp_hidden_bss(struct cfg80211_bss *a,
-		   struct cfg80211_bss *b)
+static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
 {
 	const u8 *ie1;
 	const u8 *ie2;
@@ -448,11 +444,11 @@ static int cmp_hidden_bss(struct cfg80211_bss *a,
 		return r;
 
 	ie1 = cfg80211_find_ie(WLAN_EID_SSID,
-			a->information_elements,
-			a->len_information_elements);
+			       a->information_elements,
+			       a->len_information_elements);
 	ie2 = cfg80211_find_ie(WLAN_EID_SSID,
-			b->information_elements,
-			b->len_information_elements);
+			       b->information_elements,
+			       b->len_information_elements);
 
 	/* Key comparator must use same algorithm in any rb-tree
 	 * search function (order is important), otherwise ordering
@@ -602,7 +598,7 @@ rb_find_bss(struct cfg80211_registered_device *dev,
 
 static struct cfg80211_internal_bss *
 rb_find_hidden_bss(struct cfg80211_registered_device *dev,
-	    struct cfg80211_internal_bss *res)
+		   struct cfg80211_internal_bss *res)
 {
 	struct rb_node *n = dev->bss_tree.rb_node;
 	struct cfg80211_internal_bss *bss;
@@ -625,7 +621,7 @@ rb_find_hidden_bss(struct cfg80211_registered_device *dev,
 
 static void
 copy_hidden_ies(struct cfg80211_internal_bss *res,
-		 struct cfg80211_internal_bss *hidden)
+		struct cfg80211_internal_bss *hidden)
 {
 	if (unlikely(res->pub.beacon_ies))
 		return;
@@ -639,7 +635,7 @@ copy_hidden_ies(struct cfg80211_internal_bss *res,
 	res->beacon_ies_allocated = true;
 	res->pub.len_beacon_ies = hidden->pub.len_beacon_ies;
 	memcpy(res->pub.beacon_ies, hidden->pub.beacon_ies,
-			res->pub.len_beacon_ies);
+	       res->pub.len_beacon_ies);
 }
 
 static struct cfg80211_internal_bss *
@@ -704,6 +700,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 			found->pub.len_information_elements =
 				found->pub.len_proberesp_ies;
 		}
+
 		if (res->pub.beacon_ies) {
 			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
 			size_t ielen = res->pub.len_beacon_ies;
-- 
1.8.0

