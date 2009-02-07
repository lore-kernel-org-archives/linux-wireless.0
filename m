Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZBGPKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 10:10:13 -0500
Message-Id: <20090207150935.196151941@sipsolutions.net> (sfid-20090207_161019_680448_3778C4C0)
References: <20090207150846.951229208@sipsolutions.net>
Date: Sat, 07 Feb 2009 16:08:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] cfg80211: add more flexible BSS lookup
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a more flexible BSS lookup function so that mac80211 or
other drivers can actually use this for getting the BSS to
connect to.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |   12 +++++++++++-
 net/wireless/scan.c    |   10 ++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-02-07 15:40:54.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-02-07 15:41:28.000000000 +0100
@@ -785,7 +785,17 @@ cfg80211_inform_bss_frame(struct wiphy *
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
-				      const u8 *ssid, size_t ssid_len);
+				      const u8 *ssid, size_t ssid_len,
+				      u16 capa_mask, u16 capa_val);
+static inline struct cfg80211_bss *
+cfg80211_get_ibss(struct wiphy *wiphy,
+		  struct ieee80211_channel *channel,
+		  const u8 *ssid, size_t ssid_len)
+{
+	return cfg80211_get_bss(wiphy, channel, NULL, ssid, ssid_len,
+				WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+}
+
 struct cfg80211_bss *cfg80211_get_mesh(struct wiphy *wiphy,
 				       struct ieee80211_channel *channel,
 				       const u8 *meshid, size_t meshidlen,
--- wireless-testing.orig/net/wireless/scan.c	2009-02-07 15:40:54.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2009-02-07 15:41:28.000000000 +0100
@@ -116,9 +116,12 @@ static bool is_bss(struct cfg80211_bss *
 {
 	const u8 *ssidie;
 
-	if (compare_ether_addr(a->bssid, bssid))
+	if (bssid && compare_ether_addr(a->bssid, bssid))
 		return false;
 
+	if (!ssid)
+		return true;
+
 	ssidie = find_ie(WLAN_EID_SSID,
 			 a->information_elements,
 			 a->len_information_elements);
@@ -199,7 +202,8 @@ static int cmp_bss(struct cfg80211_bss *
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
-				      const u8 *ssid, size_t ssid_len)
+				      const u8 *ssid, size_t ssid_len,
+				      u16 capa_mask, u16 capa_val)
 {
 	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
@@ -207,6 +211,8 @@ struct cfg80211_bss *cfg80211_get_bss(st
 	spin_lock_bh(&dev->bss_lock);
 
 	list_for_each_entry(bss, &dev->bss_list, list) {
+		if ((bss->pub.capability & capa_mask) != capa_val)
+			continue;
 		if (channel && bss->pub.channel != channel)
 			continue;
 		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {

-- 

