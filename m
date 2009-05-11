Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZEKMnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 08:43:17 -0400
Subject: [PATCH v2] cfg80211: disallow interfering with stations on non-AP
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242045283.18637.1.camel@johannes.local>
References: <1242045283.18637.1.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 11 May 2009 14:43:13 +0200
Message-Id: <1242045793.26810.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On non-AP interfaces userspace has no business interfering with
the station management, this can confuse mac80211 (and other
drivers probably wouldn't support it anyway). Allow adding and
removing stations only on AP interfaces.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Oops.

 net/wireless/nl80211.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-05-11 14:30:25.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-05-11 14:42:05.000000000 +0200
@@ -1726,6 +1726,12 @@ static int nl80211_new_station(struct sk
 	if (err)
 		goto out_rtnl;
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
 	if (err)
 		goto out;
@@ -1769,6 +1775,12 @@ static int nl80211_del_station(struct sk
 	if (err)
 		goto out_rtnl;
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!drv->ops->del_station) {
 		err = -EOPNOTSUPP;
 		goto out;


