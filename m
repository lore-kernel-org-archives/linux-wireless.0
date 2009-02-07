Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZBGOOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 09:14:41 -0500
Subject: [PATCH v2] mac80211: disable IBSS beacon before join
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <498C5005.8060806@lwfinger.net>
References: <1233930586.4175.11.camel@johannes.local>
	 <498C5005.8060806@lwfinger.net>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 15:14:34 +0100
Message-Id: <1234016074.4175.104.camel@johannes.local> (sfid-20090207_151445_980190_0D426AB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before we have a probe response frame (which is used as the
beacon too) there's no need to ask drivers to beacon, they
will not get a beacon anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/main.c	2009-02-06 14:36:09.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-06 14:45:25.000000000 +0100
@@ -210,6 +210,8 @@ int ieee80211_if_config(struct ieee80211
 					!!rcu_dereference(sdata->u.ap.beacon);
 				break;
 			case NL80211_IFTYPE_ADHOC:
+				conf.enable_beacon = !!sdata->u.sta.probe_resp;
+				break;
 			case NL80211_IFTYPE_MESH_POINT:
 				conf.enable_beacon = true;
 				break;


