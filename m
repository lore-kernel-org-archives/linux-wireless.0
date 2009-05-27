Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbZE0IgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 04:36:02 -0400
Subject: [PATCH v2 resend] cfg80211: disallow interfering with stations on
 non-AP
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242045793.26810.0.camel@johannes.local>
References: <1242045283.18637.1.camel@johannes.local>
	 <1242045793.26810.0.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 27 May 2009 10:35:29 +0200
Message-Id: <1243413329.26933.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On non-AP interfaces userspace has no business interfering with
the station management, this can confuse mac80211 (and other
drivers probably wouldn't support it anyway). Allow adding and
removing stations only on AP interfaces.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-05-26 10:01:42.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-05-26 10:01:44.000000000 +0200
@@ -1687,6 +1687,12 @@ static int nl80211_set_station(struct sk
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
@@ -1811,6 +1817,12 @@ static int nl80211_del_station(struct sk
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!drv->ops->del_station) {
 		err = -EOPNOTSUPP;
 		goto out;


