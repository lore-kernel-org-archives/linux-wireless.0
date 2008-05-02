Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362AbYEBW7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 18:59:51 -0400
Subject: [PATCH] mac80211: require four hardware queues for QoS/HT
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 May 2008 00:59:37 +0200
Message-Id: <1209769177.3608.27.camel@johannes.berg> (sfid-20080503_005928_397518_F9CE3ED1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mac80211 only announce QoS/HT support when
the underlying hardware has four (or more) queues.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Ron Rindjunksi <ron.rindjunksi@intel.com>
---
 net/mac80211/iface.c |    3 ++-
 net/mac80211/mlme.c  |   21 ++++++++++++++-------
 net/mac80211/tx.c    |    4 ++--
 3 files changed, 18 insertions(+), 10 deletions(-)

--- everything.orig/net/mac80211/iface.c	2008-05-03 00:29:07.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-05-03 00:31:01.000000000 +0200
@@ -157,9 +157,10 @@ void ieee80211_if_set_type(struct net_de
 		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
 			IEEE80211_AUTH_ALG_SHARED_KEY;
 		ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
-			IEEE80211_STA_WMM_ENABLED |
 			IEEE80211_STA_AUTO_BSSID_SEL |
 			IEEE80211_STA_AUTO_CHANNEL_SEL;
+		if (sdata->local->hw.queues >= 4)
+			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
--- everything.orig/net/mac80211/mlme.c	2008-05-03 00:29:07.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-05-03 00:31:01.000000000 +0200
@@ -272,6 +272,12 @@ static void ieee80211_sta_wmm_params(str
 	int count;
 	u8 *pos;
 
+	if (!(ifsta->flags & IEEE80211_STA_WMM_ENABLED))
+		return;
+
+	if (!wmm_param)
+		return;
+
 	if (wmm_param_len < 8 || wmm_param[5] /* version */ != 1)
 		return;
 	count = wmm_param[6] & 0x0f;
@@ -762,8 +768,10 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 1; /* WME ver */
 		*pos++ = 0;
 	}
+
 	/* wmm support is a must to HT */
-	if (wmm && sband->ht_info.ht_supported) {
+	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
+	    sband->ht_info.ht_supported) {
 		__le16 tmp = cpu_to_le16(sband->ht_info.cap);
 		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
 		*pos++ = WLAN_EID_HT_CAPABILITY;
@@ -2020,7 +2028,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param) {
+	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
+	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
 		struct ieee80211_ht_bss_info bss_info;
 		ieee80211_ht_cap_ie_to_ht_info(
 				(struct ieee80211_ht_cap *)
@@ -2033,7 +2042,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	rate_control_rate_init(sta, local);
 
-	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
+	if (elems.wmm_param) {
 		sta->flags |= WLAN_STA_WME;
 		rcu_read_unlock();
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
@@ -2816,10 +2825,8 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
-	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
-					 elems.wmm_param_len);
-	}
+	ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
+				 elems.wmm_param_len);
 
 	/* Do not send changes to driver if we are scanning. This removes
 	 * requirement that driver's bss_info_changed function needs to be
--- everything.orig/net/mac80211/tx.c	2008-05-02 22:50:29.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-03 00:31:01.000000000 +0200
@@ -1490,8 +1490,8 @@ int ieee80211_subif_start_xmit(struct sk
 		rcu_read_unlock();
 	}
 
-	/* receiver is QoS enabled, use a QoS type frame */
-	if (sta_flags & WLAN_STA_WME) {
+	/* receiver and we are QoS enabled, use a QoS type frame */
+	if (sta_flags & WLAN_STA_WME && local->hw.queues >= 4) {
 		fc |= IEEE80211_STYPE_QOS_DATA;
 		hdrlen += 2;
 	}


