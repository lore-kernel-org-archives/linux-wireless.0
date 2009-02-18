Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47432 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZBRJsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 04:48:11 -0500
Subject: [PATCH] nl80211: remove admin requirement from station get
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 10:48:07 +0100
Message-Id: <1234950487.4149.24.camel@johannes.local> (sfid-20090218_104815_827252_BF9BBE6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no particular reason to not let untrusted users see
this information -- it's just the stations we're talking to,
packet counters for them and possibly some mesh things.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-02-18 10:46:30.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-02-18 10:46:39.000000000 +0100
@@ -2592,7 +2592,6 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_get_station,
 		.dumpit = nl80211_dump_station,
 		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NL80211_CMD_SET_STATION,


