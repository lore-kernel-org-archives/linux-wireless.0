Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbYCSTav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] mac80211: tear down of block ack sessions
Date: Tue, 18 Mar 2008 15:00:32 -0700
Message-Id: <1205877632-11680-4-git-send-email-reinette.chatre@intel.com> (sfid-20080319_193129_144932_13F08AC4)
In-Reply-To: <1205877632-11680-3-git-send-email-reinette.chatre@intel.com>
References: <1205877632-11680-1-git-send-email-reinette.chatre@intel.com>
 <1205877632-11680-2-git-send-email-reinette.chatre@intel.com>
 <1205877632-11680-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds a clean tear down for all block ack sessions if interface
goes down or if a deauthentication is done.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211.c     |    7 +------
 net/mac80211/ieee80211_i.h   |    2 ++
 net/mac80211/ieee80211_sta.c |   15 ++++++++++++++-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 55b6371..616ce10 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -386,7 +386,6 @@ static int ieee80211_stop(struct net_device *dev)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
-	int i;
 
 	/*
 	 * Stop TX on this interface first.
@@ -400,11 +399,7 @@ static int ieee80211_stop(struct net_device *dev)
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sta->sdata == sdata)
-			for (i = 0; i <  STA_TID_NUM; i++)
-				ieee80211_sta_stop_rx_ba_session(sdata->dev,
-						sta->addr, i,
-						WLAN_BACK_RECIPIENT,
-						WLAN_REASON_QSTA_LEAVE_QBSS);
+			ieee80211_sta_tear_down_BA_sessions(dev, sta->addr);
 	}
 
 	rcu_read_unlock();
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5c7b8e2..d4c5f65 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -930,10 +930,12 @@ void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
 				  u16 agg_size, u16 timeout);
 void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
 				u16 initiator, u16 reason_code);
+
 void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
 void sta_rx_agg_session_timer_expired(unsigned long data);
 void sta_addba_resp_timer_expired(unsigned long data);
+void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8 *addr);
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 8006c28..4255ec4 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -467,8 +467,8 @@ static void ieee80211_set_associated(struct net_device *dev,
 		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
 		ieee80211_sta_send_associnfo(dev, ifsta);
 	} else {
+		ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
 		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
-
 		netif_carrier_off(dev);
 		ieee80211_reset_erp_info(dev);
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
@@ -1518,6 +1518,19 @@ void sta_rx_agg_session_timer_expired(unsigned long data)
 					 WLAN_REASON_QSTA_TIMEOUT);
 }
 
+void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8 *addr)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	int i;
+
+	for (i = 0; i <  STA_TID_NUM; i++) {
+		ieee80211_stop_tx_ba_session(&local->hw, addr, i,
+					     WLAN_BACK_INITIATOR);
+		ieee80211_sta_stop_rx_ba_session(dev, addr, i,
+						 WLAN_BACK_RECIPIENT,
+						 WLAN_REASON_QSTA_LEAVE_QBSS);
+	}
+}
 
 static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
-- 
1.5.3.4

