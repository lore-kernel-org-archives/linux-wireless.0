Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYDXIsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 04:48:05 -0400
Subject: [PATCH] mac80211: assign conf.beacon_control for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 23:35:09 +0200
Message-Id: <1208986509.3357.23.camel@johannes.berg> (sfid-20080424_104837_861254_94BCBCD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers can rightfully assume that they get a beacon_control
if the beacon is set.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    1 +
 1 file changed, 1 insertion(+)

--- everything.orig/net/mac80211/main.c	2008-04-23 23:26:56.000000000 +0200
+++ everything/net/mac80211/main.c	2008-04-23 23:27:10.000000000 +0200
@@ -976,6 +976,7 @@ static int __ieee80211_if_config(struct 
 		conf.ssid_len = sdata->u.sta.ssid_len;
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		conf.beacon = beacon;
+		conf.beacon_control = control;
 		ieee80211_start_mesh(dev);
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;


