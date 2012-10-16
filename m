Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:63715 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2JPGkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 02:40:00 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv3] nl/cfg80211: force scan using an AP vif if requested
Date: Tue, 16 Oct 2012 08:39:22 +0200
Message-Id: <1350369562-24733-1-git-send-email-ordex@autistici.org> (sfid-20121016_084006_252788_97662999)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the user wants to scan using a vif configured as AP, cfg80211 must give him a
chance to do it, even if this will disrupt the stations performance due to
off-channel scanning. To do so, this patch adds a 'force' flag to the
SCAN_TRIGGER command which tells cfg80211 to perform the scanning operation even
if the vif is an AP and the beaconing has already started.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

v2:
 - Rebased on latest mac80211-next/master
v3:
 - Introduced nl80211_feature flag to advertise this feature to the userspace
   and to allow drivers to do not support it


 include/linux/nl80211.h |  8 ++++++++
 net/mac80211/cfg.c      | 11 ++++++++++-
 net/mac80211/main.c     |  4 +++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0e6277a..617d0fb 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3050,6 +3050,7 @@ enum nl80211_ap_sme_features {
  *	mode
  * @NL80211_FEATURE_LOW_PRIORITY_SCAN: This driver supports low priority scan
  * @NL80211_FEATURE_SCAN_FLUSH: Scan flush is supported
+ * @NL80211_FEATURE_AP_SCAN: Support scanning using an AP vif
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3060,6 +3061,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_SAE				= 1 << 5,
 	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
 	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
+	NL80211_FEATURE_AP_SCAN				= 1 << 8,
 };
 
 /**
@@ -3103,10 +3105,16 @@ enum nl80211_connect_failed_reason {
  *
  * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
  * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
+ * @NL80211_SCAN_FLAG_AP: force a scan even if the interface is configured
+ *	as AP and the beaconing has already been configured. This attribute is
+ *	dangerous because will destroy stations performance as a lot of frames
+ *	will be lost while scanning off-channel, therefore it must be used only
+ *	when really needed
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
+	NL80211_SCAN_FLAG_AP				= 1<<2,
 };
 
 #endif /* __LINUX_NL80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed27988..c45c62e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1855,7 +1855,16 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		 * beaconing hasn't been configured yet
 		 */
 	case NL80211_IFTYPE_AP:
-		if (sdata->u.ap.beacon)
+		/*
+		 * If the scan has been forced (and the driver supports
+		 * forcing), don't care about being beaconing already.
+		 * This will create problems to the attached stations (e.g. all
+		 * the  frames sent while scanning on other channel will be
+		 * lost)
+		 */
+		if (sdata->u.ap.beacon &&
+		    (!(wiphy->features & NL80211_FEATURE_AP_SCAN) ||
+		     !(req->flags & NL80211_SCAN_FLAG_AP)))
 			return -EOPNOTSUPP;
 		break;
 	default:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ba5a232..c42094b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -603,7 +603,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			   NL80211_FEATURE_HT_IBSS;
 
 	if (!ops->hw_scan)
-		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN;
+		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
+				   NL80211_FEATURE_AP_SCAN;
+
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
-- 
1.7.12.3

