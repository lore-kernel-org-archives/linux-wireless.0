Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48655 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab1EaTQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:16:45 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/3] mac80211: create a STA entry for a WDS interface after receiving a beacon
Date: Tue, 31 May 2011 21:16:33 +0200
Message-Id: <1306869394-83047-2-git-send-email-nbd@openwrt.org> (sfid-20110531_211650_420423_E069A1B1)
In-Reply-To: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a STA entry is created too early, a lot of essential information
required for rate control is missing.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/iface.c |   92 +++++++++++++++++++++++++++++++++++++-------------
 net/mac80211/rx.c    |   10 ++++--
 2 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dee30ae..3c6af71 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -178,7 +178,6 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
 	u32 changed = 0;
 	int res;
 	u32 hw_reconf_flags = 0;
@@ -290,27 +289,6 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
 
-	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
-		/* Create STA entry for the WDS peer */
-		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
-				     GFP_KERNEL);
-		if (!sta) {
-			res = -ENOMEM;
-			goto err_del_interface;
-		}
-
-		/* no locking required since STA is not live yet */
-		sta->flags |= WLAN_STA_AUTHORIZED;
-
-		res = sta_info_insert(sta);
-		if (res) {
-			/* STA has been freed */
-			goto err_del_interface;
-		}
-
-		rate_control_rate_init(sta);
-	}
-
 	/*
 	 * set_multicast_list will be invoked by the networking core
 	 * which will check whether any increments here were done in
@@ -344,8 +322,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	netif_tx_start_all_queues(dev);
 
 	return 0;
- err_del_interface:
-	drv_remove_interface(local, &sdata->vif);
+
  err_stop:
 	if (!local->open_count)
 		drv_stop(local);
@@ -703,6 +680,70 @@ static void ieee80211_if_setup(struct net_device *dev)
 	dev->destructor = free_netdev;
 }
 
+static void ieee80211_wds_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+					 struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_rx_status *rx_status;
+	struct ieee802_11_elems elems;
+	struct ieee80211_mgmt *mgmt;
+	struct sta_info *sta;
+	size_t baselen;
+	u32 rates = 0;
+	u16 stype;
+	bool new = false;
+	enum ieee80211_band band = local->hw.conf.channel->band;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+
+	rx_status = IEEE80211_SKB_RXCB(skb);
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
+
+	if (stype != IEEE80211_STYPE_BEACON)
+		return;
+
+	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
+	if (baselen > skb->len)
+		return;
+
+	ieee802_11_parse_elems(mgmt->u.probe_resp.variable,
+			       skb->len - baselen, &elems);
+
+	rates = ieee80211_sta_get_rates(local, &elems, band);
+
+	rcu_read_lock();
+
+	sta = sta_info_get(sdata, sdata->u.wds.remote_addr);
+
+	if (!sta) {
+		rcu_read_unlock();
+		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
+				     GFP_KERNEL);
+		if (!sta)
+			return;
+
+		new = true;
+	}
+
+	sta->last_rx = jiffies;
+	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+
+	if (elems.ht_cap_elem)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+				elems.ht_cap_elem, &sta->sta.ht_cap);
+
+	if (elems.wmm_param)
+		set_sta_flags(sta, WLAN_STA_WME);
+
+	if (new) {
+		sta->flags = WLAN_STA_AUTHORIZED;
+		rate_control_rate_init(sta);
+		sta_info_insert_rcu(sta);
+	}
+
+	rcu_read_unlock();
+}
+
 static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -807,6 +848,9 @@ static void ieee80211_iface_work(struct work_struct *work)
 				break;
 			ieee80211_mesh_rx_queued_mgmt(sdata, skb);
 			break;
+		case NL80211_IFTYPE_WDS:
+			ieee80211_wds_rx_queued_mgmt(sdata, skb);
+			break;
 		default:
 			WARN(1, "frame for unexpected interface type");
 			break;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7fa8c6b..683a46b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2335,13 +2335,14 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 
 	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-	    sdata->vif.type != NL80211_IFTYPE_STATION)
+	    sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_WDS)
 		return RX_DROP_MONITOR;
 
 	switch (stype) {
 	case cpu_to_le16(IEEE80211_STYPE_BEACON):
 	case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
-		/* process for all: mesh, mlme, ibss */
+		/* process for all: mesh, mlme, ibss, wds */
 		break;
 	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
 	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
@@ -2680,7 +2681,10 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		}
 		break;
 	case NL80211_IFTYPE_WDS:
-		if (bssid || !ieee80211_is_data(hdr->frame_control))
+		if (bssid) {
+			if (!ieee80211_is_beacon(hdr->frame_control))
+				return 0;
+		} else if (!ieee80211_is_data(hdr->frame_control))
 			return 0;
 		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
-- 
1.7.3.2

