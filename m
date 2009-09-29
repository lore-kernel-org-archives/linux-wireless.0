Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZI2WDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 18:03:42 -0400
Subject: [PATCH] mac80211: remove bogus code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 00:03:14 +0200
Message-Id: <1254261794.30589.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not right to do something here when returning an
error, and hostapd should never have relied on it as
it only fixes up a small part of the problem anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |    7 -------
 1 file changed, 7 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-09-30 00:00:37.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-09-30 00:00:48.000000000 +0200
@@ -738,13 +738,6 @@ static int ieee80211_add_station(struct 
 
 	err = sta_info_insert(sta);
 	if (err) {
-		/* STA has been freed */
-		if (err == -EEXIST && layer2_update) {
-			/* Need to update layer 2 devices on reassociation */
-			sta = sta_info_get(local, mac);
-			if (sta)
-				ieee80211_send_layer2_update(sta);
-		}
 		rcu_read_unlock();
 		return err;
 	}


