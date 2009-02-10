Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZBJUa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:30:57 -0500
Message-Id: <20090210202552.887470598@sipsolutions.net> (sfid-20090210_213059_885718_8F05444B)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/27] mac80211: disable IBSS beacon before join
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

--- wireless-testing.orig/net/mac80211/main.c	2009-02-10 20:59:28.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-10 20:59:29.000000000 +0100
@@ -210,6 +210,8 @@ int ieee80211_if_config(struct ieee80211
 					!!rcu_dereference(sdata->u.ap.beacon);
 				break;
 			case NL80211_IFTYPE_ADHOC:
+				conf.enable_beacon = !!sdata->u.sta.probe_resp;
+				break;
 			case NL80211_IFTYPE_MESH_POINT:
 				conf.enable_beacon = true;
 				break;

-- 

