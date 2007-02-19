Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54733 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965104AbXBSWjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:21 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/12] d80211: Simplify channel & mode configuration
Message-Id: <20070219223950.D4058484AB@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:50 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch simplifies channel & mode setting while eliminating a race
between channel configuration and scanning. It also adds a call to
ieee80211_hw_config after ops->open.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211.c       |   45 +++++++++++-----
 net/d80211/ieee80211_i.h     |    9 +--
 net/d80211/ieee80211_ioctl.c |   14 ++---
 net/d80211/ieee80211_sta.c   |  117 +++++-------------------------------------
 4 files changed, 53 insertions(+), 132 deletions(-)

04622f694489ee966f3a87997b4a1a023393d861
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 03d4028..c83520e 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2005,8 +2005,24 @@ int ieee80211_if_config_beacon(struct ne
 int ieee80211_hw_config(struct ieee80211_local *local)
 {
 	struct ieee80211_hw_mode *mode;
+	struct ieee80211_channel *chan;
 	int ret = 0;
 
+	if (local->sta_scanning) {
+		chan = local->scan_channel;
+		mode = local->scan_hw_mode;
+	} else {
+		chan = local->oper_channel;
+		mode = local->oper_hw_mode;
+	}
+
+	local->hw.conf.channel = chan->chan;
+	local->hw.conf.channel_val = chan->val;
+	local->hw.conf.power_level = chan->power_level;
+	local->hw.conf.freq = chan->freq;
+	local->hw.conf.phymode = mode->mode;
+	local->hw.conf.antenna_max = chan->antenna_max;
+
 #ifdef CONFIG_D80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "HW CONFIG: channel=%d freq=%d "
 	       "phymode=%d\n", local->hw.conf.channel, local->hw.conf.freq,
@@ -2016,16 +2032,11 @@ #endif /* CONFIG_D80211_VERBOSE_DEBUG */
 	if (local->ops->config)
 		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
 
-	list_for_each_entry(mode, &local->modes_list, list) {
-		if (mode->mode == local->hw.conf.phymode) {
-			if (local->curr_rates != mode->rates)
-				rate_control_clear(local);
-			local->curr_rates = mode->rates;
-			local->num_curr_rates = mode->num_rates;
-			ieee80211_prepare_rates(local);
-			break;
-		}
-	}
+	if (local->curr_rates != mode->rates)
+		rate_control_clear(local);
+	local->curr_rates = mode->rates;
+	local->num_curr_rates = mode->num_rates;
+	ieee80211_prepare_rates(local);
 
 	return ret;
 }
@@ -2344,8 +2355,13 @@ static int ieee80211_open(struct net_dev
 			if (res) {
 				if (local->ops->stop)
 					local->ops->stop(local_to_hw(local));
-			} else if (local->apdev)
-				dev_open(local->apdev);
+			} else {
+				res = ieee80211_hw_config(local);
+				if (res && local->ops->stop)
+					local->ops->stop(local_to_hw(local));
+				else if (!res && local->apdev)
+					dev_open(local->apdev);
+			}
 		}
 		if (res) {
 			if (local->ops->remove_interface)
@@ -4711,12 +4727,11 @@ int ieee80211_register_hwmode(struct iee
 	if (!local->curr_rates) {
 		/* Default to this mode */
 		local->hw.conf.phymode = mode->mode;
+		local->oper_hw_mode = local->scan_hw_mode = mode;
+		local->oper_channel = local->scan_channel = &mode->channels[0];
 		local->curr_rates = mode->rates;
 		local->num_curr_rates = mode->num_rates;
 		ieee80211_prepare_rates(local);
-		local->hw.conf.freq = mode->channels[0].freq;
-		local->hw.conf.channel = mode->channels[0].chan;
-		local->hw.conf.channel_val = mode->channels[0].val;
 	}
 
 	ieee80211_init_client(local->mdev);
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 61bcdf0..8bccd25 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -435,18 +435,13 @@ #define IEEE80211_IRQSAFE_QUEUE_LIMIT 12
         spinlock_t sub_if_lock; /* mutex for STA data structures */
         struct list_head sub_if_list;
 	int sta_scanning;
-	struct ieee80211_hw_mode *scan_hw_mode;
 	int scan_channel_idx;
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
 	struct delayed_work scan_work;
 	struct net_device *scan_dev;
-	int scan_oper_channel;
-	int scan_oper_channel_val;
-	int scan_oper_power_level;
-	int scan_oper_freq;
-	int scan_oper_phymode;
-	int scan_oper_antenna_max;
+	struct ieee80211_channel *oper_channel, *scan_channel;
+	struct ieee80211_hw_mode *oper_hw_mode, *scan_hw_mode;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
 	struct list_head sta_bss_list;
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index 35d73f7..c7300cb 100644
--- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1828,20 +1828,18 @@ int ieee80211_ioctl_siwfreq(struct net_d
 				if (set && mode->mode != local->next_mode)
 					continue;
 
-				local->hw.conf.channel = chan->chan;
-				local->hw.conf.channel_val = chan->val;
-                                local->hw.conf.power_level = chan->power_level;
-				local->hw.conf.freq = chan->freq;
-				local->hw.conf.phymode = mode->mode;
-                                local->hw.conf.antenna_max = chan->antenna_max;
+				local->oper_channel = chan;
+				local->oper_hw_mode = mode;
 				set++;
 			}
 		}
 	}
 
 	if (set) {
-		local->sta_scanning = 0; /* Abort possible scan */
-		return ieee80211_hw_config(local);
+		if (local->sta_scanning)
+			return 0;
+		else
+			return ieee80211_hw_config(local);
 	}
 
 	return -EINVAL;
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 66e81d7..439206d 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -1401,19 +1401,12 @@ #endif /* CONFIG_D80211_IBSS_DEBUG */
 		struct ieee80211_rate *rates;
 		size_t num_rates;
 		u32 supp_rates, prev_rates;
-		int i, j, oper_mode;
-
-		rates = local->curr_rates;
-		num_rates = local->num_curr_rates;
-		oper_mode = local->sta_scanning ? local->scan_oper_phymode :
-			local->hw.conf.phymode;
-		list_for_each_entry(mode, &local->modes_list, list) {
-			if (oper_mode == mode->mode) {
-				rates = mode->rates;
-				num_rates = mode->num_rates;
-				break;
-			}
-		}
+		int i, j;
+
+		mode = local->sta_scanning ?
+		       local->scan_hw_mode : local->oper_hw_mode;
+		rates = mode->rates;
+		num_rates = mode->num_rates;
 
 		supp_rates = 0;
 		for (i = 0; i < elems.supp_rates_len +
@@ -1426,7 +1419,7 @@ #endif /* CONFIG_D80211_IBSS_DEBUG */
 				rate = elems.ext_supp_rates
 					[i - elems.supp_rates_len];
 			own_rate = 5 * (rate & 0x7f);
-			if (oper_mode == MODE_ATHEROS_TURBO)
+			if (mode->mode == MODE_ATHEROS_TURBO)
 				own_rate *= 2;
 			for (j = 0; j < num_rates; j++)
 				if (rates[j].rate == own_rate)
@@ -2011,29 +2004,6 @@ static void ieee80211_sta_new_auth(struc
 }
 
 
-static int ieee80211_ibss_allowed(struct ieee80211_local *local)
-{
-	struct ieee80211_hw_mode *mode;
-	int c;
-
-	list_for_each_entry(mode, &local->modes_list, list) {
-		if (mode->mode != local->hw.conf.phymode)
-			continue;
-		for (c = 0; c < mode->num_channels; c++) {
-			struct ieee80211_channel *chan = &mode->channels[c];
-			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
-			    chan->chan == local->hw.conf.channel) {
-				if (chan->flag & IEEE80211_CHAN_W_IBSS)
-					return 1;
-				break;
-			}
-		}
-	}
-
-	return 0;
-}
-
-
 extern int ieee80211_ioctl_siwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra);
@@ -2076,7 +2046,7 @@ static int ieee80211_sta_join_ibss(struc
 	rq.e = 1;
 	res = ieee80211_ioctl_siwfreq(dev, NULL, &rq, NULL);
 
-	if (!ieee80211_ibss_allowed(local)) {
+	if (!(local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)) {
 		printk(KERN_DEBUG "%s: IBSS not allowed on channel %d "
 		       "(%d MHz)\n", dev->name, local->hw.conf.channel,
 		       local->hw.conf.freq);
@@ -2323,7 +2293,7 @@ #endif /* CONFIG_D80211_IBSS_DEBUG */
 		if (time_after(jiffies, ifsta->ibss_join_req +
 			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
 			if (ifsta->create_ibss &&
-			    ieee80211_ibss_allowed(local))
+			    local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)
 				return ieee80211_sta_create_ibss(dev, ifsta);
 			if (ifsta->create_ibss) {
 				printk(KERN_DEBUG "%s: IBSS not allowed on the"
@@ -2445,54 +2415,6 @@ int ieee80211_sta_set_bssid(struct net_d
 }
 
 
-static void ieee80211_sta_save_oper_chan(struct net_device *dev)
-{
-	struct ieee80211_local *local = dev->ieee80211_ptr;
-	local->scan_oper_channel = local->hw.conf.channel;
-	local->scan_oper_channel_val = local->hw.conf.channel_val;
-	local->scan_oper_power_level = local->hw.conf.power_level;
-	local->scan_oper_freq = local->hw.conf.freq;
-	local->scan_oper_phymode = local->hw.conf.phymode;
-	local->scan_oper_antenna_max = local->hw.conf.antenna_max;
-}
-
-
-static int ieee80211_sta_restore_oper_chan(struct net_device *dev)
-{
-	struct ieee80211_local *local = dev->ieee80211_ptr;
-	local->hw.conf.channel = local->scan_oper_channel;
-	local->hw.conf.channel_val = local->scan_oper_channel_val;
-	local->hw.conf.power_level = local->scan_oper_power_level;
-	local->hw.conf.freq = local->scan_oper_freq;
-	local->hw.conf.phymode = local->scan_oper_phymode;
-	local->hw.conf.antenna_max = local->scan_oper_antenna_max;
-	return ieee80211_hw_config(local);
-}
-
-
-static int ieee80211_active_scan(struct ieee80211_local *local)
-{
-	struct ieee80211_hw_mode *mode;
-	int c;
-
-	list_for_each_entry(mode, &local->modes_list, list) {
-		if (mode->mode != local->hw.conf.phymode)
-			continue;
-		for (c = 0; c < mode->num_channels; c++) {
-			struct ieee80211_channel *chan = &mode->channels[c];
-			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
-			    chan->chan == local->hw.conf.channel) {
-				if (chan->flag & IEEE80211_CHAN_W_ACTIVE_SCAN)
-					return 1;
-				break;
-			}
-		}
-	}
-
-	return 0;
-}
-
-
 void ieee80211_scan_completed(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -2505,6 +2427,10 @@ void ieee80211_scan_completed(struct iee
 	wmb();
 	local->sta_scanning = 0;
 
+	if (ieee80211_hw_config(local))
+		printk(KERN_DEBUG "%s: failed to restore operational"
+		       "channel after scan\n", dev->name);
+
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
 
@@ -2539,12 +2465,6 @@ void ieee80211_sta_scan_work(struct work
 		mode = local->scan_hw_mode;
 		if (local->scan_hw_mode->list.next == &local->modes_list &&
 		    local->scan_channel_idx >= mode->num_channels) {
-			if (ieee80211_sta_restore_oper_chan(dev)) {
-				printk(KERN_DEBUG "%s: failed to restore "
-				       "operational channel after scan\n",
-				       dev->name);
-			}
-
 			ieee80211_scan_completed(local_to_hw(local));
 			return;
 		}
@@ -2563,12 +2483,7 @@ #if 0
 			       dev->name, chan->chan, chan->freq);
 #endif
 
-			local->hw.conf.channel = chan->chan;
-			local->hw.conf.channel_val = chan->val;
-			local->hw.conf.power_level = chan->power_level;
-			local->hw.conf.freq = chan->freq;
-			local->hw.conf.phymode = mode->mode;
-			local->hw.conf.antenna_max = chan->antenna_max;
+			local->scan_channel = chan;
 			if (ieee80211_hw_config(local)) {
 				printk(KERN_DEBUG "%s: failed to set channel "
 				       "%d (%d MHz) for scan\n", dev->name,
@@ -2595,7 +2510,7 @@ #endif
 		local->scan_state = SCAN_SEND_PROBE;
 		break;
 	case SCAN_SEND_PROBE:
-		if (ieee80211_active_scan(local)) {
+		if (local->scan_channel->flag & IEEE80211_CHAN_W_ACTIVE_SCAN) {
 			ieee80211_send_probe_req(dev, NULL, local->scan_ssid,
 						 local->scan_ssid_len);
 			next_delay = IEEE80211_CHANNEL_TIME;
@@ -2656,8 +2571,6 @@ static int ieee80211_sta_start_scan(stru
 		return rc;
 	}
 
-	ieee80211_sta_save_oper_chan(dev);
-
 	local->sta_scanning = 1;
 	/* TODO: stop TX queue? */
 
-- 
1.3.0

