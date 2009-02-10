Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZBJUiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:38:20 -0500
Message-Id: <20090210202555.591186722@sipsolutions.net> (sfid-20090210_213823_071108_D3C9F772)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:52 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/27] mac80211: clean up BA session teardown
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sta_info pointer can very well be passed to
ieee80211_sta_tear_down_BA_sessions, this will
later allow us to pass it through even further.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ht.c          |    8 ++++----
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |    3 +--
 net/mac80211/mlme.c        |    2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/ht.c	2009-02-10 20:59:32.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-02-10 20:59:34.000000000 +0100
@@ -153,15 +153,15 @@ u32 ieee80211_enable_ht(struct ieee80211
 	return changed;
 }
 
-void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data *sdata, u8 *addr)
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_local *local = sta->local;
 	int i;
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
-		ieee80211_stop_tx_ba_session(&local->hw, addr, i,
+		ieee80211_stop_tx_ba_session(&local->hw, sta->sta.addr, i,
 					     WLAN_BACK_INITIATOR);
-		ieee80211_sta_stop_rx_ba_session(sdata, addr, i,
+		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr, i,
 						 WLAN_BACK_RECIPIENT,
 						 WLAN_REASON_QSTA_LEAVE_QBSS);
 	}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-10 20:59:32.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-10 20:59:34.000000000 +0100
@@ -990,7 +990,7 @@ void ieee80211_send_delba(struct ieee802
 
 void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
-void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data *sdata, u8 *addr);
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len);
--- wireless-testing.orig/net/mac80211/iface.c	2009-02-10 20:59:25.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-02-10 20:59:34.000000000 +0100
@@ -362,8 +362,7 @@ static int ieee80211_stop(struct net_dev
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sta->sdata == sdata)
-			ieee80211_sta_tear_down_BA_sessions(sdata,
-							    sta->sta.addr);
+			ieee80211_sta_tear_down_BA_sessions(sta);
 	}
 
 	rcu_read_unlock();
--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-10 20:59:25.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-10 20:59:34.000000000 +0100
@@ -924,7 +924,7 @@ static void ieee80211_set_disassoc(struc
 	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
-	ieee80211_sta_tear_down_BA_sessions(sdata, sta->sta.addr);
+	ieee80211_sta_tear_down_BA_sessions(sta);
 
 	if (self_disconnected) {
 		if (deauth)

-- 

