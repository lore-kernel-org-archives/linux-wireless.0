Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYIHJhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:37:11 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809080232n42d6caefs6c3a1f5afef46cb4@mail.gmail.com> (sfid-20080908_113216_032675_8751A8F4)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220863139.31304.33.camel@johannes.berg>
	 <1ba2fa240809080146o93200eetcf8e142f6ef4a2b1@mail.gmail.com>
	 <1220864314.31304.38.camel@johannes.berg>
	 <1ba2fa240809080206u42908ef6yc6641435d747155a@mail.gmail.com>
	 <1220865843.31304.48.camel@johannes.berg>
	 <1ba2fa240809080232n42d6caefs6c3a1f5afef46cb4@mail.gmail.com>
	 (sfid-20080908_113216_032675_8751A8F4)
Content-Type: text/plain
Date: Mon, 08 Sep 2008 11:37:03 +0200
Message-Id: <1220866623.31304.53.camel@johannes.berg> (sfid-20080908_113715_870373_9B03E042)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-08 at 12:32 +0300, Tomas Winkler wrote:

> I want to test your stopping queue stuff in my environment  but I get
> to the lab only very late today.

Ok, sure, works for me. I decided to do the stopping in a separate patch
as I have verified that it was already "wrong" before your changes,
patch inlined below (it's more a cosmetic thing, but still wrong).

Subject: mac80211: stop queues before carrier off

During testing of the disassociation fixes, Tomas noticed that it
was possible to run into a situation where you'd suddenly get a
few "wlan0: dropped frame to <AP> (unauthorized port)" messages
and I found this to be due to the AP's sta_info having been
removed but netif_carrier_off not having removed/stopped traffic
yet. To avoid that, stop the queue for the interface (and avoid
bringing them up when another vif scans when they weren't up.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 11:27:39.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 11:30:41.000000000 +0200
@@ -574,6 +574,7 @@ static void ieee80211_set_associated(str
 	sdata->bss_conf.assoc = 1;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
 
 	ieee80211_sta_send_apinfo(sdata, ifsta);
@@ -995,6 +996,7 @@ static void ieee80211_set_disassoc(struc
 	ifsta->assoc_scan_tries = 0;
 	ifsta->assoc_tries = 0;
 
+	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
 	ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
@@ -3413,6 +3415,7 @@ static void ieee80211_sta_reset_auth(str
 	ifsta->direct_probe_tries = 0;
 	ifsta->auth_tries = 0;
 	ifsta->assoc_tries = 0;
+	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 }
 
@@ -3889,13 +3892,15 @@ void ieee80211_scan_completed(struct iee
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		/* Tell AP we're back */
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
-		    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
-			ieee80211_send_nullfunc(local, sdata, 0);
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+				ieee80211_send_nullfunc(local, sdata, 0);
+				netif_tx_wake_all_queues(sdata->dev);
+			}
+		} else
+			netif_tx_wake_all_queues(sdata->dev);
 
 		ieee80211_restart_sta_timer(sdata);
-
-		netif_wake_queue(sdata->dev);
 	}
 	rcu_read_unlock();
 
@@ -4053,10 +4058,13 @@ static int ieee80211_sta_start_scan(stru
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		netif_stop_queue(sdata->dev);
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
-		    (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED))
-			ieee80211_send_nullfunc(local, sdata, 1);
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+				netif_tx_stop_all_queues(sdata->dev);
+				ieee80211_send_nullfunc(local, sdata, 1);
+			}
+		} else
+			netif_tx_stop_all_queues(sdata->dev);
 	}
 	rcu_read_unlock();
 


