Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYIFT1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 15:27:04 -0400
Subject: [PATCH] mac80211: move some RCU locking into an if branch
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 21:27:01 +0200
Message-Id: <1220729221.10102.11.camel@johannes.berg> (sfid-20080906_212710_980262_40A207AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The if itself doesn't need to be protected, so move in the RCU
locking to avoid doing anything at all when the condition isn't
true.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-06 20:41:07.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-06 21:22:36.000000000 +0200
@@ -2440,13 +2440,12 @@ static void ieee80211_rx_bss_info(struct
 				      mesh_peer_accepts_plinks(elems));
 	}
 
-	rcu_read_lock();
-
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems->supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
-
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
+		rcu_read_lock();
+
 		sta = sta_info_get(local, mgmt->sa);
 		if (sta) {
 			u64 prev_rates;
@@ -2470,9 +2469,9 @@ static void ieee80211_rx_bss_info(struct
 			ieee80211_ibss_add_sta(sdata, NULL, mgmt->bssid,
 					       mgmt->sa, supp_rates);
 		}
-	}
 
-	rcu_read_unlock();
+		rcu_read_unlock();
+	}
 
 	if (elems->ds_params && elems->ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);


