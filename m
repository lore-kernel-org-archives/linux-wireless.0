Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:33759 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYLQO5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 09:57:39 -0500
Received: by ti-out-0910.google.com with SMTP id b6so2411969tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 06:57:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18761.4838.509784.281821@localhost.localdomain> (sfid-20081217_155751_605014_21095C7F)
Date: Wed, 17 Dec 2008 20:25:34 +0530
To: linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net, mcgrof@gmail.com,
	jouni.malinen@atheros.com
Subject: [RFC] Handle Channel Switch Announcement
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an attempt to handle CSA elements from an AP and switch
to the specified channel.

Only mode 1 is handled, i.e, we just stop transmission on receiving a CSA element.
User space notification is not handled yet.

Please review.

diff --git a/include/net/wireless.h b/include/net/wireless.h
index aedefa5..701f597 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -44,6 +44,8 @@ enum ieee80211_band {
  * 	is not permitted.
  * @IEEE80211_CHAN_NO_FAT_BELOW: extension channel below this channel
  * 	is not permitted.
+ * @IEEE80211_CHAN_CSA_DISABLED: Disabled because a
+	Channel Switch Announcement was received on this channel.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -52,6 +54,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_RADAR		= 1<<3,
 	IEEE80211_CHAN_NO_FAT_ABOVE	= 1<<4,
 	IEEE80211_CHAN_NO_FAT_BELOW	= 1<<5,
+	IEEE80211_CHAN_CSA_DISABLED	= 1<<6
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7dabae..5ed227b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -282,6 +282,7 @@ enum ieee80211_sta_mlme_state {
 
 struct ieee80211_if_sta {
 	struct timer_list timer;
+	struct timer_list chswitch_timer;
 	struct work_struct work;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
@@ -951,6 +952,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
+void ieee80211_chswitch_timer(unsigned long data);
+void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_channel_sw_ie *sw_elem);
 
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5abbc3f..095ce36 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -441,6 +441,7 @@ static int ieee80211_stop(struct net_device *dev)
 						WLAN_REASON_DEAUTH_LEAVING);
 
 		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
+		del_timer_sync(&sdata->u.sta.chswitch_timer);
 		del_timer_sync(&sdata->u.sta.timer);
 		/*
 		 * If the timer fired while we waited for it, it will have
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9a06905..fe77046 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1592,6 +1592,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
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
 
@@ -2384,6 +2390,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifsta->work, ieee80211_sta_work);
 	setup_timer(&ifsta->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
+	setup_timer(&ifsta->chswitch_timer, ieee80211_chswitch_timer,
+		    (unsigned long) sdata);
 	skb_queue_head_init(&ifsta->skb_queue);
 
 	ifsta->capab = WLAN_CAPABILITY_ESS;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 91b7c9f..7c371fe 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1612,6 +1612,13 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
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
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f5c7c33..7a8b96b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -382,7 +382,8 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 
 	channel = ieee80211_get_channel(sdata->local->hw.wiphy, freq);
 
-	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+	if (!channel || channel->flags &
+	    (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_CSA_DISABLED))
 		return RX_DROP_MONITOR;
 
 	bss = ieee80211_bss_info_update(sdata->local, rx_status,
@@ -538,7 +539,8 @@ void ieee80211_scan_work(struct work_struct *work)
 		skip = 0;
 		chan = &sband->channels[local->scan_channel_idx];
 
-		if (chan->flags & IEEE80211_CHAN_DISABLED ||
+		if (chan->flags &
+		    (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_CSA_DISABLED) ||
 		    (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 		     chan->flags & IEEE80211_CHAN_NO_IBSS))
 			skip = 1;
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index f72bad6..e85387e 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -84,3 +84,85 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 			mgmt->sa, mgmt->bssid,
 			mgmt->u.action.u.measurement.dialog_token);
 }
+
+void ieee80211_chswitch_timer(unsigned long data)
+{
+	struct ieee80211_bss *bss;
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
+	printk("expire\n");
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
+	ieee80211_wake_queues(&sdata->local->hw);
+}
+
+void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_channel_sw_ie *sw_elem)
+{
+	struct ieee80211_bss *bss;
+	struct ieee80211_channel *new_ch, *cur_ch;
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
+	/* If the current channel has already been marked as CSA_DISABLED,
+	   disregard further beacons until the channel moves when the timer expires */
+
+	cur_ch = ieee80211_get_channel(sdata->local->hw.wiphy,
+			       sdata->local->hw.conf.channel->center_freq);
+	if (cur_ch && cur_ch->flags & IEEE80211_CHAN_CSA_DISABLED)
+		goto bss_put;
+	else
+		cur_ch->flags |= IEEE80211_CHAN_CSA_DISABLED;
+
+	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+		goto bss_put;
+
+	new_ch->flags &= ~IEEE80211_CHAN_CSA_DISABLED;
+	sdata->local->oper_channel = new_ch;
+
+	if (sw_elem->count <= 1) {
+		ret = ieee80211_hw_config(sdata->local,
+					  IEEE80211_CONF_CHANGE_CHANNEL);
+		if (!ret)
+			bss->freq = new_freq;
+	} else {
+		ieee80211_stop_queues(&sdata->local->hw);
+		exp = sw_elem->count * (1024 * bss->beacon_int / 1000 * HZ / 1000);
+		mod_timer(&ifsta->chswitch_timer, jiffies + exp);
+	}
+bss_put:
+	ieee80211_rx_bss_put(sdata->local, bss);
+}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 71a8391..b9693d8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -636,7 +636,8 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 
 	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
 
-	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
+	if (chan && !(chan->flags & (IEEE80211_CHAN_DISABLED |
+				     IEEE80211_CHAN_CSA_DISABLED))) {
 		if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 		    chan->flags & IEEE80211_CHAN_NO_IBSS)
 			return ret;
