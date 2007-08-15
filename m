Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXHOKpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:45:14 -0400
Subject: [PATCH] nl80211: remove VLAN type
From: Johannes Berg <johannes@sipsolutions.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 11:18:37 +0200
Message-Id: <1187169518.3960.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point in trying to handle source MAC address based VLANs in
the wireless stack, something like "smacvlan" modeled after macvlan
should be sufficient.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
We could just not keep the hole as well since people can't really be
using that header yet, but the version we have in previous kernels could
still be shipped somewhere so I think it should be kept compatible.

 include/linux/nl80211.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-08-15 00:43:06.290200043 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-08-15 00:45:51.860200043 +0200
@@ -207,7 +207,6 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_ADHOC: independent BSS member
  * @NL80211_IFTYPE_STATION: managed BSS member
  * @NL80211_IFTYPE_AP: access point
- * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
  * @__NL80211_IFTYPE_AFTER_LAST: internal use
@@ -217,13 +216,17 @@ enum nl80211_attrs {
  *
  */
 enum nl80211_iftype {
-	NL80211_IFTYPE_UNSPECIFIED,
-	NL80211_IFTYPE_ADHOC,
-	NL80211_IFTYPE_STATION,
-	NL80211_IFTYPE_AP,
-	NL80211_IFTYPE_AP_VLAN,
-	NL80211_IFTYPE_WDS,
-	NL80211_IFTYPE_MONITOR,
+	NL80211_IFTYPE_UNSPECIFIED = 0,
+	NL80211_IFTYPE_ADHOC = 1,
+	NL80211_IFTYPE_STATION = 2,
+	NL80211_IFTYPE_AP = 3,
+	/*
+	 * there was AP_VLAN here but it was never used
+	 * keep the number unallocated for the benefit
+	 * of those people using old headers
+	 */
+	NL80211_IFTYPE_WDS = 5,
+	NL80211_IFTYPE_MONITOR = 6,
 
 	/* keep last */
 	__NL80211_IFTYPE_AFTER_LAST


