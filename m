Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYIIHdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 03:33:06 -0400
Subject: [PATCH 11/8] mac80211: remove useless 'ibss' parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080908154421.216772000@sipsolutions.net> (sfid-20080908_174606_739824_DD7A31F6)
References: <20080908154421.216772000@sipsolutions.net>
	 (sfid-20080908_174606_739824_DD7A31F6)
Content-Type: text/plain
Date: Tue, 09 Sep 2008 09:32:59 +0200
Message-Id: <1220945580.31304.103.camel@johannes.berg> (sfid-20080909_093310_986510_B3836DF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever since we refactored beaconing to not be controlled by a
fake queue this parameter to ieee80211_sta_def_wmm_params
has been unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-09 09:30:05.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 09:30:20.000000000 +0200
@@ -188,8 +188,7 @@ void ieee80211_send_probe_req(struct iee
 
 /* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_sta_bss *bss,
-					 int ibss)
+					 struct ieee80211_sta_bss *bss)
 {
 	struct ieee80211_local *local = sdata->local;
 	int i, have_higher_than_11mbit = 0;
@@ -1850,7 +1849,7 @@ static int ieee80211_sta_join_ibss(struc
 	}
 	ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
 
-	ieee80211_sta_def_wmm_params(sdata, bss, 1);
+	ieee80211_sta_def_wmm_params(sdata, bss);
 
 	ifsta->state = IEEE80211_STA_MLME_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
@@ -2933,7 +2932,7 @@ static int ieee80211_sta_config_auth(str
 			ieee80211_sta_set_ssid(sdata, selected->ssid,
 					       selected->ssid_len);
 		ieee80211_sta_set_bssid(sdata, selected->bssid);
-		ieee80211_sta_def_wmm_params(sdata, selected, 0);
+		ieee80211_sta_def_wmm_params(sdata, selected);
 
 		/* Send out direct probe if no probe resp was received or
 		 * the one we have is outdated


