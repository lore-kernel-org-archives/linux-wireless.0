Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:62591 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYL3K3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 05:29:06 -0500
Received: by ti-out-0910.google.com with SMTP id b6so8031726tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 02:29:04 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18777.63336.140527.717269@localhost.localdomain> (sfid-20081230_112924_118639_55BE400C)
Date: Tue, 30 Dec 2008 15:56:48 +0530
To: linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net, jouni.malinen@atheros.com
Subject: [RFC v2] mac80211: Add 802.11h CSA support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move to the advertised channel on reception of
a CSA element. This is needed for 802.11h compliance.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
v2
--
* Drivers might use a mutex in the config() callback, so use a
  workqueue to call ieee80211_hw_config().

Address initial review comments:

* Remove CSA_DISABLED channel flag
* Use new queue stop/wake helpers, with a new reason code

 net/mac80211/ieee80211_i.h |    8 ++++
 net/mac80211/iface.c       |    2 +
 net/mac80211/mlme.c        |    9 ++++
 net/mac80211/rx.c          |    7 +++
 net/mac80211/spectmgmt.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 117718b..3b5272d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -259,6 +259,7 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
 #define IEEE80211_STA_TKIP_WEP_USED	BIT(14)
+#define IEEE80211_STA_CSA_RECEIVED	BIT(15)
 /* flags for MLME request */
 #define IEEE80211_STA_REQ_SCAN 0
 #define IEEE80211_STA_REQ_DIRECT_PROBE 1
@@ -283,7 +284,9 @@ enum ieee80211_sta_mlme_state {
 
 struct ieee80211_if_sta {
 	struct timer_list timer;
+	struct timer_list chswitch_timer;
 	struct work_struct work;
+	struct work_struct chswitch_work;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	enum ieee80211_sta_mlme_state state;
@@ -542,6 +545,7 @@ enum {
 enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_DRIVER,
 	IEEE80211_QUEUE_STOP_REASON_PS,
+	IEEE80211_QUEUE_STOP_REASON_CSA
 };
 
 /* maximum number of hardware queues we support. */
@@ -964,6 +968,10 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
+void ieee80211_chswitch_timer(unsigned long data);
+void ieee80211_chswitch_work(struct work_struct *work);
+void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_channel_sw_ie *sw_elem);
 
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2c7a87d..f927641 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -443,6 +443,7 @@ static int ieee80211_stop(struct net_device *dev)
 						WLAN_REASON_DEAUTH_LEAVING);
 
 		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
+		del_timer_sync(&sdata->u.sta.chswitch_timer);
 		del_timer_sync(&sdata->u.sta.timer);
 		/*
 		 * If the timer fired while we waited for it, it will have
@@ -452,6 +453,7 @@ static int ieee80211_stop(struct net_device *dev)
 		 * it no longer is.
 		 */
 		cancel_work_sync(&sdata->u.sta.work);
+		cancel_work_sync(&sdata->u.sta.chswitch_work);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e317c6d..eea18ec 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1645,6 +1645,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (!bss)
 		return;
 
+	if (elems->ch_switch_elem && (elems->ch_switch_elem_len == 3)) {
+		struct ieee80211_channel_sw_ie *sw_elem =
+			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
+		ieee80211_process_chanswitch(sdata, sw_elem);
+	}
+
 	/* was just updated in ieee80211_bss_info_update */
 	beacon_timestamp = bss->timestamp;
 
@@ -2447,8 +2453,11 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 
 	ifsta = &sdata->u.sta;
 	INIT_WORK(&ifsta->work, ieee80211_sta_work);
+	INIT_WORK(&ifsta->chswitch_work, ieee80211_chswitch_work);
 	setup_timer(&ifsta->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
+	setup_timer(&ifsta->chswitch_timer, ieee80211_chswitch_timer,
+		    (unsigned long) sdata);
 	skb_queue_head_init(&ifsta->skb_queue);
 
 	ifsta->capab = WLAN_CAPABILITY_ESS;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 384cb3b..a44b109 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1613,6 +1613,13 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 				return RX_DROP_MONITOR;
 			ieee80211_process_measurement_req(sdata, mgmt, len);
 			break;
+		case WLAN_ACTION_SPCT_CHL_SWITCH:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.chan_switch)))
+				return RX_DROP_MONITOR;
+			ieee80211_process_chanswitch(sdata,
+				     &mgmt->u.action.u.chan_switch.sw_elem);
+			break;
 		}
 		break;
 	default:
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index f72bad6..3eec256 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -84,3 +84,91 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 			mgmt->sa, mgmt->bssid,
 			mgmt->u.action.u.measurement.dialog_token);
 }
+
+void ieee80211_chswitch_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
+	struct ieee80211_bss *bss;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
+	if (!netif_running(sdata->dev))
+		return;
+
+	bss = ieee80211_rx_bss_get(sdata->local, ifsta->bssid,
+				   sdata->local->hw.conf.channel->center_freq,
+				   ifsta->ssid, ifsta->ssid_len);
+	if (!bss)
+		goto exit;
+
+	if (!ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL))
+		bss->freq = sdata->local->oper_channel->center_freq;
+
+	ieee80211_rx_bss_put(sdata->local, bss);
+exit:
+	ifsta->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+}
+
+void ieee80211_chswitch_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
+	queue_work(sdata->local->hw.workqueue, &ifsta->chswitch_work);
+}
+
+void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_channel_sw_ie *sw_elem)
+{
+	struct ieee80211_bss *bss;
+	struct ieee80211_channel *new_ch;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	int ret, exp;
+	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num);
+
+	/* FIXME: Handle ADHOC later */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (ifsta->state != IEEE80211_STA_MLME_ASSOCIATED)
+		return;
+
+	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+		return;
+
+	/* Disregard subsequent beacons if we are already running a timer
+	   processing a CSA */
+
+	if (ifsta->flags & IEEE80211_STA_CSA_RECEIVED)
+		return;
+
+	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
+	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
+		return;
+
+	bss = ieee80211_rx_bss_get(sdata->local, ifsta->bssid,
+				   sdata->local->hw.conf.channel->center_freq,
+				   ifsta->ssid, ifsta->ssid_len);
+	if (!bss)
+		return;
+
+	sdata->local->oper_channel = new_ch;
+
+	if (sw_elem->count <= 1) {
+		ret = ieee80211_hw_config(sdata->local,
+					  IEEE80211_CONF_CHANGE_CHANNEL);
+		if (!ret)
+			bss->freq = new_freq;
+	} else {
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+						IEEE80211_QUEUE_STOP_REASON_CSA);
+		ifsta->flags |= IEEE80211_STA_CSA_RECEIVED;
+		exp = sw_elem->count * (1024 * bss->beacon_int / 1000 * HZ / 1000);
+		mod_timer(&ifsta->chswitch_timer, jiffies + exp);
+	}
+
+	ieee80211_rx_bss_put(sdata->local, bss);
+}
-- 
1.6.1

