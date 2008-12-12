Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59244 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756645AbYLLPIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 10:08:44 -0500
Date: Fri, 12 Dec 2008 17:08:31 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Send Layer 2 Update frame on reassociation
Message-ID: <20081212150831.GA16586@jm.kir.nu> (sfid-20081212_160852_171436_95AECB3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a STA roams back to the same AP before the previous STA entry has
expired, a new STA entry is not added in mac80211. However, a Layer 2
Update frame still needs to be transmitted to update layer 2 devices
about the new location for the STA. Without this, switches may
continue to forward frames to the previous (now incorrect) port when
STA roams between APs.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 net/mac80211/cfg.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2008-12-12 16:39:39.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2008-12-12 17:06:27.000000000 +0200
@@ -663,6 +663,7 @@ static int ieee80211_add_station(struct 
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
+	int layer2_update;
 
 	/* Prevent a race with changing the rate control algorithm */
 	if (!netif_running(dev))
@@ -693,17 +694,25 @@ static int ieee80211_add_station(struct 
 
 	rate_control_rate_init(sta);
 
+	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		sdata->vif.type == NL80211_IFTYPE_AP;
+
 	rcu_read_lock();
 
 	err = sta_info_insert(sta);
 	if (err) {
 		/* STA has been freed */
+		if (err == -EEXIST && layer2_update) {
+			/* Need to update layer 2 devices on reassociation */
+			sta = sta_info_get(local, mac);
+			if (sta)
+				ieee80211_send_layer2_update(sta);
+		}
 		rcu_read_unlock();
 		return err;
 	}
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-	    sdata->vif.type == NL80211_IFTYPE_AP)
+	if (layer2_update)
 		ieee80211_send_layer2_update(sta);
 
 	rcu_read_unlock();

-- 
Jouni Malinen                                            PGP id EFC895FA
