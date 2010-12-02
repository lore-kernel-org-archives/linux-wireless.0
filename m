Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44898 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845Ab0LBUBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 15:01:14 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: speed up AP probing using nullfunc frames
Date: Thu,  2 Dec 2010 21:01:08 +0100
Message-Id: <1291320068-63275-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1291320068-63275-1-git-send-email-nbd@openwrt.org>
References: <1291320068-63275-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the nullfunc frame used to probe the AP was not acked, there is no point
in waiting for the probe timeout, so advance to the next try (or disconnect)
immediately.
If we do reach the probe timeout without having received a tx status, the
connection is probably really bad and worth disconnecting.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/ieee80211_i.h |    3 +-
 net/mac80211/mlme.c        |   93 ++++++++++++++++++++++++++++++++------------
 net/mac80211/status.c      |   18 ++++----
 3 files changed, 79 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 66b0b52..e7c8807 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -357,6 +357,7 @@ struct ieee80211_if_managed {
 	unsigned long beacon_timeout;
 	unsigned long probe_timeout;
 	int probe_send_count;
+	bool nullfunc_failed;
 
 	struct mutex mtx;
 	struct cfg80211_bss *associated;
@@ -1271,7 +1272,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_hdr *hdr);
+			     struct ieee80211_hdr *hdr, bool ack);
 void ieee80211_beacon_connection_loss_work(struct work_struct *work);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f570801..3a1dde3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1065,16 +1065,20 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 }
 
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_hdr *hdr)
+			     struct ieee80211_hdr *hdr, bool ack)
 {
 	if (!ieee80211_is_data(hdr->frame_control))
 	    return;
 
-	ieee80211_sta_reset_conn_monitor(sdata);
+	if (ack)
+		ieee80211_sta_reset_conn_monitor(sdata);
 
 	if (ieee80211_is_nullfunc(hdr->frame_control) &&
 	    sdata->u.mgd.probe_send_count > 0) {
-		sdata->u.mgd.probe_send_count = 0;
+		if (ack)
+			sdata->u.mgd.probe_send_count = 0;
+		else
+			sdata->u.mgd.nullfunc_failed = true;
 		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
 }
@@ -1101,9 +1105,10 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	 * anymore. The timeout will be reset if the frame is ACKed by
 	 * the AP.
 	 */
-	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		ifmgd->nullfunc_failed = false;
 		ieee80211_send_nullfunc(sdata->local, sdata, 0);
-	else {
+	} else {
 		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
 		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0);
 	}
@@ -1912,6 +1917,31 @@ static void ieee80211_sta_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
+static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
+					  u8 *bssid)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
+			  IEEE80211_STA_BEACON_POLL);
+
+	ieee80211_set_disassoc(sdata, true, true);
+	mutex_unlock(&ifmgd->mtx);
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(local);
+	mutex_unlock(&local->mtx);
+	/*
+	 * must be outside lock due to cfg80211,
+	 * but that's not a problem.
+	 */
+	ieee80211_send_deauth_disassoc(sdata, bssid,
+			IEEE80211_STYPE_DEAUTH,
+			WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+			NULL, true);
+	mutex_lock(&ifmgd->mtx);
+}
+
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1936,11 +1966,38 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 		/* ACK received for nullfunc probing frame */
 		if (!ifmgd->probe_send_count)
 			ieee80211_reset_ap_probe(sdata);
-
-		else if (time_is_after_jiffies(ifmgd->probe_timeout))
+		else if (ifmgd->nullfunc_failed) {
+			if (ifmgd->probe_send_count < max_tries) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+				wiphy_debug(local->hw.wiphy,
+					    "%s: No ack for nullfunc frame to"
+					    " AP %pM, try %d\n",
+					    sdata->name, bssid,
+					    ifmgd->probe_send_count);
+#endif
+				ieee80211_mgd_probe_ap_send(sdata);
+			} else {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+				wiphy_debug(local->hw.wiphy,
+					    "%s: No ack for nullfunc frame to"
+					    " AP %pM, disconnecting.\n",
+					    sdata->name, bssid,
+					    ifmgd->probe_send_count);
+#endif
+				ieee80211_sta_connection_lost(sdata, bssid);
+			}
+		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
-
-		else if (ifmgd->probe_send_count < max_tries) {
+		else if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+			wiphy_debug(local->hw.wiphy,
+				    "%s: Failed to send nullfunc to AP %pM"
+				    " after %dms, disconnecting.\n",
+				    sdata->name,
+				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
+#endif
+			ieee80211_sta_connection_lost(sdata, bssid);
+		} else if (ifmgd->probe_send_count < max_tries) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			wiphy_debug(local->hw.wiphy,
 				    "%s: No probe response from AP %pM"
@@ -1955,27 +2012,13 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 * We actually lost the connection ... or did we?
 			 * Let's make sure!
 			 */
-			ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-					  IEEE80211_STA_BEACON_POLL);
 			wiphy_debug(local->hw.wiphy,
 				    "%s: No probe response from AP %pM"
 				    " after %dms, disconnecting.\n",
 				    sdata->name,
 				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
-			ieee80211_set_disassoc(sdata, true, true);
-			mutex_unlock(&ifmgd->mtx);
-			mutex_lock(&local->mtx);
-			ieee80211_recalc_idle(local);
-			mutex_unlock(&local->mtx);
-			/*
-			 * must be outside lock due to cfg80211,
-			 * but that's not a problem.
-			 */
-			ieee80211_send_deauth_disassoc(sdata, bssid,
-					IEEE80211_STYPE_DEAUTH,
-					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-					NULL, true);
-			mutex_lock(&ifmgd->mtx);
+
+			ieee80211_sta_connection_lost(sdata, bssid);
 		}
 	}
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4958710..38a7972 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -155,10 +155,6 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 
 		ieee80211_queue_work(&local->hw, &local->recalc_smps);
 	}
-
-	if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
-	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
-		ieee80211_sta_tx_notify(sdata, (void *) skb->data);
 }
 
 /*
@@ -186,6 +182,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	int retry_count = -1, i;
 	int rates_idx = -1;
 	bool send_to_cooked;
+	bool acked;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		/* the HW cannot have attempted that rate */
@@ -211,8 +208,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
 			continue;
 
-		if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
-		    test_sta_flags(sta, WLAN_STA_PS_STA)) {
+		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
+		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*
 			 * The STA is in power save mode, so assume
 			 * that this TX packet failed because of that.
@@ -244,7 +241,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			rcu_read_unlock();
 			return;
 		} else {
-			if (!(info->flags & IEEE80211_TX_STAT_ACK))
+			if (!acked)
 				sta->tx_retry_failed++;
 			sta->tx_retry_count += retry_count;
 		}
@@ -253,10 +250,13 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
 			ieee80211s_update_metric(local, sta, skb);
 
-		if (!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-		    (info->flags & IEEE80211_TX_STAT_ACK))
+		if (!(info->flags & IEEE80211_TX_CTL_INJECTED) && acked)
 			ieee80211_frame_acked(sta, skb);
 
+		if ((sta->sdata->vif.type == NL80211_IFTYPE_STATION) &&
+		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
+			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data, acked);
+
 		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
 				if (sta->lost_packets)
-- 
1.7.3.2

