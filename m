Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0AZNPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 08:15:48 -0500
Subject: [PATCH] cfg80211: export cfg80211_find_ie
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 14:15:46 +0100
Message-ID: <1264511746.25642.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new function (previously a static function
called just "find_ie" can be used to find a
specific IE in a buffer of IEs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |   16 ++++++++++++++++
 net/wireless/scan.c    |   38 ++++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 18 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-01-26 08:40:45.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-01-26 08:46:44.000000000 +0100
@@ -1669,6 +1669,22 @@ void ieee80211_amsdu_to_8023s(struct sk_
  */
 unsigned int cfg80211_classify8021d(struct sk_buff *skb);
 
+/**
+ * cfg80211_find_ie - find information element in data
+ *
+ * @eid: element ID
+ * @ies: data consisting of IEs
+ * @len: length of data
+ *
+ * This function will return %NULL if the element ID could
+ * not be found or if the element is invalid (claims to be
+ * longer than the given data), or a pointer to the first byte
+ * of the requested element, that is the byte containing the
+ * element ID. There are no checks on the element length
+ * other than having to fit into the given data.
+ */
+const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len);
+
 /*
  * Regulatory helper functions for wiphys
  */
--- wireless-testing.orig/net/wireless/scan.c	2010-01-26 08:40:45.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2010-01-26 08:41:00.000000000 +0100
@@ -143,9 +143,9 @@ void cfg80211_bss_expire(struct cfg80211
 		dev->bss_generation++;
 }
 
-static u8 *find_ie(u8 num, u8 *ies, int len)
+const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
 {
-	while (len > 2 && ies[0] != num) {
+	while (len > 2 && ies[0] != eid) {
 		len -= ies[1] + 2;
 		ies += ies[1] + 2;
 	}
@@ -155,11 +155,12 @@ static u8 *find_ie(u8 num, u8 *ies, int 
 		return NULL;
 	return ies;
 }
+EXPORT_SYMBOL(cfg80211_find_ie);
 
 static int cmp_ies(u8 num, u8 *ies1, size_t len1, u8 *ies2, size_t len2)
 {
-	const u8 *ie1 = find_ie(num, ies1, len1);
-	const u8 *ie2 = find_ie(num, ies2, len2);
+	const u8 *ie1 = cfg80211_find_ie(num, ies1, len1);
+	const u8 *ie2 = cfg80211_find_ie(num, ies2, len2);
 	int r;
 
 	if (!ie1 && !ie2)
@@ -185,9 +186,9 @@ static bool is_bss(struct cfg80211_bss *
 	if (!ssid)
 		return true;
 
-	ssidie = find_ie(WLAN_EID_SSID,
-			 a->information_elements,
-			 a->len_information_elements);
+	ssidie = cfg80211_find_ie(WLAN_EID_SSID,
+				  a->information_elements,
+				  a->len_information_elements);
 	if (!ssidie)
 		return false;
 	if (ssidie[1] != ssid_len)
@@ -204,9 +205,9 @@ static bool is_mesh(struct cfg80211_bss 
 	if (!is_zero_ether_addr(a->bssid))
 		return false;
 
-	ie = find_ie(WLAN_EID_MESH_ID,
-		     a->information_elements,
-		     a->len_information_elements);
+	ie = cfg80211_find_ie(WLAN_EID_MESH_ID,
+			      a->information_elements,
+			      a->len_information_elements);
 	if (!ie)
 		return false;
 	if (ie[1] != meshidlen)
@@ -214,9 +215,9 @@ static bool is_mesh(struct cfg80211_bss 
 	if (memcmp(ie + 2, meshid, meshidlen))
 		return false;
 
-	ie = find_ie(WLAN_EID_MESH_CONFIG,
-		     a->information_elements,
-		     a->len_information_elements);
+	ie = cfg80211_find_ie(WLAN_EID_MESH_CONFIG,
+			      a->information_elements,
+			      a->len_information_elements);
 	if (!ie)
 		return false;
 	if (ie[1] != sizeof(struct ieee80211_meshconf_ie))
@@ -395,11 +396,12 @@ cfg80211_bss_update(struct cfg80211_regi
 
 	if (is_zero_ether_addr(res->pub.bssid)) {
 		/* must be mesh, verify */
-		meshid = find_ie(WLAN_EID_MESH_ID, res->pub.information_elements,
-				 res->pub.len_information_elements);
-		meshcfg = find_ie(WLAN_EID_MESH_CONFIG,
-				  res->pub.information_elements,
-				  res->pub.len_information_elements);
+		meshid = cfg80211_find_ie(WLAN_EID_MESH_ID,
+					  res->pub.information_elements,
+					  res->pub.len_information_elements);
+		meshcfg = cfg80211_find_ie(WLAN_EID_MESH_CONFIG,
+					   res->pub.information_elements,
+					   res->pub.len_information_elements);
 		if (!meshid || !meshcfg ||
 		    meshcfg[1] != sizeof(struct ieee80211_meshconf_ie)) {
 			/* bogus mesh */


