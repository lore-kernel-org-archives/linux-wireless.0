Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZBFO3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 09:29:50 -0500
Subject: [PATCH] mac80211: disable IBSS beacon before join
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 15:29:46 +0100
Message-Id: <1233930586.4175.11.camel@johannes.local> (sfid-20090206_152954_009303_DC373B16)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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


