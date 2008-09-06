Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYIFWO2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:14:28 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [RFC PATCH 3/3] mac80211: remove disassociation code from ieee80211_set_associated
Date: Sun,  7 Sep 2008 01:14:19 +0300
Message-Id: <1220739259-16918-4-git-send-email-tomas.winkler@intel.com> (sfid-20080907_001431_071808_4E76629D)
In-Reply-To: <1220739259-16918-3-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
 <1220739259-16918-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves disassociation code from ieee80211_set_associated
to ieee80211_set_disassoc for this it also  introduces
ieee80211_sta_send_apinfo function to reduce code duplication.
In addition it marks bss_info_change BSS_CHANGED_HT also
in disassociation flow

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |  102 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 56 insertions(+), 46 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index aa5367e..2564553 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -497,6 +497,17 @@ int ieee80211_ht_addt_info_ie_to_ht_bss_info(
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
@@ -519,68 +530,53 @@ static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata,
 
 
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
@@ -982,6 +978,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	u32 changed = BSS_CHANGED_ASSOC;
 
 	rcu_read_lock();
 
@@ -1009,7 +1006,20 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
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
@@ -2227,7 +2237,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(sdata, ifsta, 1);
+	ieee80211_set_associated(sdata, ifsta);
 
 	ieee80211_associated(sdata, ifsta);
 }
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

