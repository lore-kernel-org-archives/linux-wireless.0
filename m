Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19414 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbZBDNBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 08:01:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 05:01:39 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Free current bss information in few places where we don't need it any more
Date: Wed, 4 Feb 2009 18:28:48 +0530
Message-ID: <1233752328-6918-1-git-send-email-vasanth@atheros.com> (sfid-20090204_140151_903327_6BB0743D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |   38 +++++++++++++++++++++-----------------
 net/mac80211/scan.c        |   13 +++++++++++++
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index eaf3603..5a1f19a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -955,6 +955,8 @@ ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
+void ieee80211_rx_bss_remove(struct ieee80211_sub_if_data *sdata, u8 *bssid,
+			     int freq, u8 *ssid, u8 ssid_len);
 
 /* interface handling */
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57967d3..91c9a5a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -840,6 +840,14 @@ static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
 		       sdata->dev->name, ifsta->bssid);
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_sta_send_apinfo(sdata, ifsta);
+
+		/*
+		 * Most likely AP is not in the range so remove the
+		 * bss information associated to the AP
+		 */
+		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+				sdata->local->hw.conf.channel->center_freq,
+				ifsta->ssid, ifsta->ssid_len);
 		return;
 	}
 
@@ -871,6 +879,9 @@ static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
 		       sdata->dev->name, ifsta->bssid);
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_sta_send_apinfo(sdata, ifsta);
+		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+				sdata->local->hw.conf.channel->center_freq,
+				ifsta->ssid, ifsta->ssid_len);
 		return;
 	}
 
@@ -933,8 +944,12 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_sta_send_apinfo(sdata, ifsta);
 
-	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT)
+	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT) {
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+				sdata->local->hw.conf.channel->center_freq,
+				ifsta->ssid, ifsta->ssid_len);
+	}
 
 	rcu_read_unlock();
 
@@ -1017,6 +1032,9 @@ static void ieee80211_associate(struct ieee80211_sub_if_data *sdata,
 		       sdata->dev->name, ifsta->bssid);
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_sta_send_apinfo(sdata, ifsta);
+		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+				sdata->local->hw.conf.channel->center_freq,
+				ifsta->ssid, ifsta->ssid_len);
 		return;
 	}
 
@@ -1042,7 +1060,6 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int disassoc;
-	bool remove_bss = false;
 
 	/* TODO: start monitoring current AP signal quality and number of
 	 * missed beacons. Scan other channels every now and then and search
@@ -1068,7 +1085,6 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 				       "range\n",
 				       sdata->dev->name, ifsta->bssid);
 				disassoc = 1;
-				remove_bss = true;
 			} else
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 ifsta->ssid,
@@ -1088,24 +1104,12 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_unlock();
 
-	if (disassoc) {
+	if (disassoc)
 		ieee80211_set_disassoc(sdata, ifsta, true, true,
 					WLAN_REASON_PREV_AUTH_NOT_VALID);
-		if (remove_bss) {
-			struct ieee80211_bss *bss;
-
-			bss = ieee80211_rx_bss_get(local, ifsta->bssid,
-					local->hw.conf.channel->center_freq,
-					ifsta->ssid, ifsta->ssid_len);
-			if (bss) {
-				atomic_dec(&bss->users);
-				ieee80211_rx_bss_put(local, bss);
-			}
-		}
-	} else {
+	else
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);
-	}
 }
 
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 282e6a0..50719ea 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -327,6 +327,19 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	return bss;
 }
 
+void ieee80211_rx_bss_remove(struct ieee80211_sub_if_data *sdata, u8 *bssid,
+			     int freq, u8 *ssid, u8 ssid_len)
+{
+	struct ieee80211_bss *bss;
+	struct ieee80211_local *local = sdata->local;
+
+	bss = ieee80211_rx_bss_get(local, bssid, freq, ssid, ssid_len);
+	if (bss) {
+		atomic_dec(&bss->users);
+		ieee80211_rx_bss_put(local, bss);
+	}
+}
+
 ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		  struct ieee80211_rx_status *rx_status)
-- 
1.5.5.1

