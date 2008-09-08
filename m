Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYIHPhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:37:17 -0400
Message-Id: <20080908153509.678840000@sipsolutions.net> (sfid-20080908_173723_548051_5B228CD9)
References: <20080908153336.891710000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:33:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, tomasw@gmail.com,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/4] mac80211: remove disassociation code from
	ieee80211_set_associated
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves disassociation code from ieee80211_set_associated
to ieee80211_set_disassoc. To reduce code duplication, it introduces
the ieee80211_sta_send_apinfo function. Additionally, it fixes a lapse
where BSS_CHANGED_HT wasn't set when notifying the driver of changes
due to disassociation.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |  102 ++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 46 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 16:39:57.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 16:39:59.000000000 +0200
@@ -352,6 +352,17 @@ int ieee80211_ht_addt_info_ie_to_ht_bss_
 	return 0;
 }
 
+static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_if_sta *ifsta)
+{
+	union iwreq_data wrqu;
+	memset(&wrqu, 0, sizeof(wrqu));
+	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
+		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
+}
+
 static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_if_sta *ifsta)
 {
@@ -374,68 +385,53 @@ static void ieee80211_sta_send_associnfo
 
 
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta,
-				     bool assoc)
+				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
-	union iwreq_data wrqu;
 	u32 changed = BSS_CHANGED_ASSOC;
 
-	if (assoc) {
-		struct ieee80211_sta_bss *bss;
-
-		ifsta->flags |= IEEE80211_STA_ASSOCIATED;
+	struct ieee80211_sta_bss *bss;
 
-		if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
-			return;
+	ifsta->flags |= IEEE80211_STA_ASSOCIATED;
 
-		bss = ieee80211_rx_bss_get(local, ifsta->bssid,
-					   conf->channel->center_freq,
-					   ifsta->ssid, ifsta->ssid_len);
-		if (bss) {
-			/* set timing information */
-			sdata->bss_conf.beacon_int = bss->beacon_int;
-			sdata->bss_conf.timestamp = bss->timestamp;
-			sdata->bss_conf.dtim_period = bss->dtim_period;
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+		return;
 
-			changed |= ieee80211_handle_bss_capability(sdata, bss);
+	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+				   conf->channel->center_freq,
+				   ifsta->ssid, ifsta->ssid_len);
+	if (bss) {
+		/* set timing information */
+		sdata->bss_conf.beacon_int = bss->beacon_int;
+		sdata->bss_conf.timestamp = bss->timestamp;
+		sdata->bss_conf.dtim_period = bss->dtim_period;
 
-			ieee80211_rx_bss_put(local, bss);
-		}
+		changed |= ieee80211_handle_bss_capability(sdata, bss);
 
-		if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
-			changed |= BSS_CHANGED_HT;
-			sdata->bss_conf.assoc_ht = 1;
-			sdata->bss_conf.ht_conf = &conf->ht_conf;
-			sdata->bss_conf.ht_bss_conf = &conf->ht_bss_conf;
-		}
+		ieee80211_rx_bss_put(local, bss);
+	}
 
-		ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
-		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
-		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
-		ieee80211_sta_send_associnfo(sdata, ifsta);
-	} else {
-		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
-		changed |= ieee80211_reset_erp_info(sdata);
+	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
+		changed |= BSS_CHANGED_HT;
+		sdata->bss_conf.assoc_ht = 1;
+		sdata->bss_conf.ht_conf = &conf->ht_conf;
+		sdata->bss_conf.ht_bss_conf = &conf->ht_bss_conf;
+	}
 
-		sdata->bss_conf.assoc_ht = 0;
-		sdata->bss_conf.ht_conf = NULL;
-		sdata->bss_conf.ht_bss_conf = NULL;
+	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
+	memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
+	ieee80211_sta_send_associnfo(sdata, ifsta);
 
-		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
-	}
 	ifsta->last_probe = jiffies;
-	ieee80211_led_assoc(local, assoc);
+	ieee80211_led_assoc(local, 1);
 
-	sdata->bss_conf.assoc = assoc;
+	sdata->bss_conf.assoc = 1;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	if (assoc)
-		netif_carrier_on(sdata->dev);
+	netif_carrier_on(sdata->dev);
 
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
+	ieee80211_sta_send_apinfo(sdata, ifsta);
 }
 
 void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
@@ -837,6 +833,7 @@ static void ieee80211_set_disassoc(struc
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	u32 changed = BSS_CHANGED_ASSOC;
 
 	rcu_read_lock();
 
@@ -864,7 +861,20 @@ static void ieee80211_set_disassoc(struc
 			ieee80211_send_disassoc(sdata, ifsta, reason);
 	}
 
-	ieee80211_set_associated(sdata, ifsta, 0);
+	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
+	changed |= ieee80211_reset_erp_info(sdata);
+
+	if (sdata->bss_conf.assoc_ht)
+		changed |= BSS_CHANGED_HT;
+
+	sdata->bss_conf.assoc_ht = 0;
+	sdata->bss_conf.ht_conf = NULL;
+	sdata->bss_conf.ht_bss_conf = NULL;
+
+	ieee80211_led_assoc(local, 0);
+	sdata->bss_conf.assoc = 0;
+
+	ieee80211_sta_send_apinfo(sdata, ifsta);
 
 	if (self_disconnected)
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
@@ -2082,7 +2092,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(sdata, ifsta, 1);
+	ieee80211_set_associated(sdata, ifsta);
 
 	ieee80211_associated(sdata, ifsta);
 }

-- 

