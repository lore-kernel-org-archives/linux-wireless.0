Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbZJ3Osl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 10:48:41 -0400
Subject: [PATCH resend] mac80211: remove bogus code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1254261794.30589.24.camel@johannes.local>
References: <1254261794.30589.24.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 15:48:43 +0100
Message-ID: <1256914123.3555.57.camel@johannes.local>
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

--- wireless-testing.orig/net/mac80211/cfg.c	2009-10-27 09:06:22.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-10-27 09:42:05.000000000 +0100
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


