Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYJNOje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 10:39:34 -0400
Subject: [PATCH] mac80211: add might_sleep to hw_config
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 16:38:55 +0200
Message-Id: <1223995135.10113.30.camel@johannes.berg> (sfid-20081014_163939_646888_FA37E485)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to catch bugs when changing mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- everything.orig/net/mac80211/main.c	2008-10-14 16:37:12.000000000 +0200
+++ everything/net/mac80211/main.c	2008-10-14 16:37:23.000000000 +0200
@@ -203,6 +203,8 @@ int ieee80211_hw_config(struct ieee80211
 	int ret = 0;
 	int power;
 
+	might_sleep();
+
 	if (local->sw_scanning)
 		chan = local->scan_channel;
 	else


