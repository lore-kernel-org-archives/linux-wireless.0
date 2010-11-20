Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36197 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab0KTByc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 20:54:32 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH v3 1/2] mac80211: use nullfunc instead of probe request for connection monitoring
Date: Sat, 20 Nov 2010 02:54:28 +0100
Message-Id: <1290218069-85434-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nullfunc frames are better for connection monitoring, because probe requests
are answered even if the AP has already dropped the connection, whereas
nullfunc frames from an unassociated station will trigger a disassoc/deauth
frame from the AP (WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA), which allows
the station to reconnect immediately instead of waiting until it attempts to
transmit the next unicast frame.

This only works on hardware with reliable tx ACK reporting, any other hardware
needs to fall back to the probe request method.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/mlme.c        |   88 +++++++++++++++++++++++++++++++------------
 net/mac80211/status.c      |    4 ++
 3 files changed, 69 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3598abf..7bb9a62 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1264,6 +1264,8 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     int powersave);
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
+void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_hdr *hdr);
 void ieee80211_beacon_connection_loss_work(struct work_struct *work);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dfc4a31..18c0e42 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1026,6 +1026,50 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
+static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	if (!(ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+			      IEEE80211_STA_CONNECTION_POLL)))
+	    return;
+
+	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
+			  IEEE80211_STA_BEACON_POLL);
+	mutex_lock(&sdata->local->iflist_mtx);
+	ieee80211_recalc_ps(sdata->local, -1);
+	mutex_unlock(&sdata->local->iflist_mtx);
+
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		return;
+
+	/*
+	 * We've received a probe response, but are not sure whether
+	 * we have or will be receiving any beacons or data, so let's
+	 * schedule the timers again, just in case.
+	 */
+	ieee80211_sta_reset_beacon_monitor(sdata);
+
+	mod_timer(&ifmgd->conn_mon_timer,
+		  round_jiffies_up(jiffies +
+				   IEEE80211_CONNECTION_IDLE_TIME));
+}
+
+void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_hdr *hdr)
+{
+	if (!ieee80211_is_data(hdr->frame_control) &&
+	    !ieee80211_is_nullfunc(hdr->frame_control))
+	    return;
+
+	ieee80211_sta_reset_conn_monitor(sdata);
+
+	if (ieee80211_is_nullfunc(hdr->frame_control)) {
+		sdata->u.mgd.probe_send_count = 0;
+		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	}
+}
+
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1041,8 +1085,19 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	if (ifmgd->probe_send_count >= unicast_limit)
 		dst = NULL;
 
-	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
-	ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0);
+	/*
+	 * When the hardware reports an accurate Tx ACK status, it's
+	 * better to send a nullfunc frame instead of a probe request,
+	 * as it will kick us off the AP quickly if we aren't associated
+	 * anymore. The timeout will be reset if the frame is ACKed by
+	 * the AP.
+	 */
+	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		ieee80211_send_nullfunc(sdata->local, sdata, 0);
+	else {
+		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
+		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0);
+	}
 
 	ifmgd->probe_send_count++;
 	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
@@ -1509,29 +1564,8 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
 
 	if (ifmgd->associated &&
-	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN) == 0 &&
-	    ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			    IEEE80211_STA_CONNECTION_POLL)) {
-		ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-				  IEEE80211_STA_BEACON_POLL);
-		mutex_lock(&sdata->local->iflist_mtx);
-		ieee80211_recalc_ps(sdata->local, -1);
-		mutex_unlock(&sdata->local->iflist_mtx);
-
-		if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-			return;
-
-		/*
-		 * We've received a probe response, but are not sure whether
-		 * we have or will be receiving any beacons or data, so let's
-		 * schedule the timers again, just in case.
-		 */
-		ieee80211_sta_reset_beacon_monitor(sdata);
-
-		mod_timer(&ifmgd->conn_mon_timer,
-			  round_jiffies_up(jiffies +
-					   IEEE80211_CONNECTION_IDLE_TIME));
-	}
+	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN) == 0)
+		ieee80211_reset_ap_probe(sdata);
 }
 
 /*
@@ -1882,6 +1916,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	    ifmgd->associated) {
 		u8 bssid[ETH_ALEN];
 
+		/* ACK received for nullfunc probing frame */
+		if (!ifmgd->probe_send_count)
+			ieee80211_reset_ap_probe(sdata);
+
 		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 		if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 3153c19..8695cd1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -155,6 +155,10 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 
 		ieee80211_queue_work(&local->hw, &local->recalc_smps);
 	}
+
+	if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
+	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
+		ieee80211_sta_tx_notify(sdata, (void *) skb->data);
 }
 
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
-- 
1.7.3.2

