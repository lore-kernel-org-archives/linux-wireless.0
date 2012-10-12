Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:24288 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921Ab2JLR7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 13:59:00 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv2] nl/cfg80211: force scan using an AP vif if requested
Date: Fri, 12 Oct 2012 19:58:17 +0200
Message-Id: <1350064697-21838-1-git-send-email-ordex@autistici.org> (sfid-20121012_195905_137505_5D34E75B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the user wants to scan using a vif configured as AP, cfg80211 must give him a
chance to do it, even if this will disrupt the stations performance due to
off-channel scanning. To do so, this patch adds a 'force' flag to the
SCAN_TRIGGER command which tells cfg80211 to perform the scanning operation even
if the vif is an AP and the beaconing has already started.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

v2: rebased on top of latest mac80211-next/master, in particular this introduced
Bing's patchset on scan_flags


Cheers,

 include/linux/nl80211.h |  6 ++++++
 net/mac80211/cfg.c      | 10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0e6277a..b3c4a63 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3103,10 +3103,16 @@ enum nl80211_connect_failed_reason {
  *
  * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
  * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
+ * @NL80211_SCAN_FLAG_FORCE: force a scan even if the interface is configured
+ *	as AP and the beaconing has already been configured. This attribute is
+ *	dangerous because will destroy stations performance as a lot of frames
+ *	will be lost while scanning off-channel, therefore it must be used only
+ *	when really needed
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
+	NL80211_SCAN_FLAG_FORCE				= 1<<2,
 };
 
 #endif /* __LINUX_NL80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed27988..a801270 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1855,7 +1855,15 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		 * beaconing hasn't been configured yet
 		 */
 	case NL80211_IFTYPE_AP:
-		if (sdata->u.ap.beacon)
+		/*
+		 * If the scan has been forced, don't care about being beaconing
+		 * already.
+		 * This will create problems to the attached stations (e.g. all
+		 * the  frames sent while scanning on other channel will be
+		 * lost)
+		 */
+		if (sdata->u.ap.beacon &&
+		    !(req->flags & NL80211_SCAN_FLAG_FORCE))
 			return -EOPNOTSUPP;
 		break;
 	default:
-- 
1.7.12

