Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbXC1JMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:00 -0400
Subject: [PATCH] nl80211: update interface types
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 18:00:26 +0200
Message-Id: <1175011226.9282.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"secondary" type doesn't seem useful, no driver implements it and the
semantics aren't clear either. Hence, don't support that in nl80211 but
do support AP_VLAN type devices.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-03-27 16:33:42.773155480 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-03-27 16:33:45.543155480 +0200
@@ -224,16 +224,13 @@ enum nl80211_multicast_groups {
  * @NL80211_IFTYPE_ADHOC: independent BSS member
  * @NL80211_IFTYPE_STATION: managed BSS member
  * @NL80211_IFTYPE_AP: access point
+ * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
  * @NL80211_IFTYPE_WDS: wireless distribution interface
- * @NL80211_IFTYPE_SECONDARY: ???
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
  * @__NL80211_IFTYPE_AFTER_LAST: internal use
  *
  * These values are used with the NL80211_ATTR_IFTYPE
  * to set the type of an interface.
- * Note that these are intentionally compatible with
- * the IW_MODE_* constants except for the removal of
- * IW_MODE_AUTO.
  *
  */
 enum nl80211_iftype {
@@ -241,8 +238,8 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_ADHOC,
 	NL80211_IFTYPE_STATION,
 	NL80211_IFTYPE_AP,
+	NL80211_IFTYPE_AP_VLAN,
 	NL80211_IFTYPE_WDS,
-	NL80211_IFTYPE_SECONDARY,
 	NL80211_IFTYPE_MONITOR,
 
 	/* keep last */


