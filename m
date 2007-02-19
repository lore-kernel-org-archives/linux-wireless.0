Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54731 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965117AbXBSWjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:24 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/12] d80211: Fix wireless statistics reporting
Message-Id: <20070219223954.18983484AF@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:54 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This fixes statistics reporting. It allows drivers to specify what type of
values they support, makes scan results return correct statistics, and
generally fixes the brain damaged statistics reporting code.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 include/net/d80211.h         |    9 ++++++---
 net/d80211/ieee80211.c       |   18 +++++++++++++++---
 net/d80211/ieee80211_i.h     |    3 ++-
 net/d80211/ieee80211_ioctl.c |   42 ++++++++++++++++++------------------------
 net/d80211/ieee80211_sta.c   |   19 +++++++++++++++++++
 5 files changed, 60 insertions(+), 31 deletions(-)

91b48d9630e6319741206bb36314ecf1750d8f65
diff --git a/include/net/d80211.h b/include/net/d80211.h
index 0b7b963..25a4dca 100644
--- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -230,7 +230,7 @@ struct ieee80211_rx_status {
         int channel;
         int phymode;
         int ssi;
-	int signal;
+	int signal; /* used as qual in statistics reporting */
 	int noise;
         int antenna;
         int rate;
@@ -541,8 +541,11 @@ #define IEEE80211_HW_TKIP_REQ_PHASE2_KEY
         /* This is the time in us to change channels
          */
         int channel_change_time;
-	/* This is maximum value for rssi reported by this device */
-	int maxssi;
+	/* Maximum values for various statistics.
+	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */
+	char max_rssi;
+	char max_signal;
+	char max_noise;
 
 	/* Number of available hardware TX queues for data packets.
 	 * WMM requires at least four queues. */
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index c83520e..0e5f23f 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -3334,9 +3334,12 @@ ieee80211_rx_h_sta_process(struct ieee80
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = rx->u.rx.status->ssi;
-	sta->last_signal = rx->u.rx.status->signal;
-	sta->last_noise = rx->u.rx.status->noise;
+	sta->last_rssi = (sta->last_rssi * 15 +
+			  rx->u.rx.status->ssi) / 16;
+	sta->last_signal = (sta->last_signal * 15 +
+			    rx->u.rx.status->signal) / 16;
+	sta->last_noise = (sta->last_noise * 15 +
+			   rx->u.rx.status->noise) / 16;
 
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
 		/* Change STA power saving mode only in the end of a frame
@@ -4624,6 +4627,15 @@ int ieee80211_register_hw(struct ieee802
 
 	local->hw.conf.beacon_int = 1000;
 
+	local->wstats_flags |= local->hw.max_rssi ?
+			       IW_QUAL_LEVEL_UPDATED : IW_QUAL_LEVEL_INVALID;
+	local->wstats_flags |= local->hw.max_signal ?
+			       IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
+	local->wstats_flags |= local->hw.max_noise ?
+			       IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
+	if (local->hw.max_rssi < 0 || local->hw.max_noise < 0)
+		local->wstats_flags |= IW_QUAL_DBM;
+
 	result = sta_info_start(local);
 	if (result < 0)
 		goto fail_sta_info;
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index b1ed96f..0c3b054 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -83,7 +83,7 @@ struct ieee80211_sta_bss {
 	int hw_mode;
 	int channel;
 	int freq;
-	int rssi;
+	int rssi, signal, noise;
 	u8 *wpa_ie;
 	size_t wpa_ie_len;
 	u8 *rsn_ie;
@@ -355,6 +355,7 @@ struct ieee80211_local {
 	int open_count;
 	int monitors;
 	struct iw_statistics wstats;
+	u8 wstats_flags;
 
 	struct class_device class_dev;
 
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index fa85fb0..cad4d54 100644
--- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1578,6 +1578,7 @@ static int ieee80211_ioctl_giwrange(stru
 				 struct iw_request_info *info,
 				 struct iw_point *data, char *extra)
 {
+	struct ieee80211_local *local = dev->ieee80211_ptr;
 	struct iw_range *range = (struct iw_range *) extra;
 
 	data->length = sizeof(struct iw_range);
@@ -1594,15 +1595,15 @@ static int ieee80211_ioctl_giwrange(stru
 	range->min_frag = 256;
 	range->max_frag = 2346;
 
-	range->max_qual.qual = 100;
-	range->max_qual.level = 146;  /* set floor at -110 dBm (146 - 256) */
-	range->max_qual.noise = 146;
-	range->max_qual.updated = IW_QUAL_ALL_UPDATED;
+	range->max_qual.qual = local->hw.max_signal;
+	range->max_qual.level = local->hw.max_rssi;
+	range->max_qual.noise = local->hw.max_noise;
+	range->max_qual.updated = local->wstats_flags;
 
-	range->avg_qual.qual = 50;
+	range->avg_qual.qual = local->hw.max_signal/2;
 	range->avg_qual.level = 0;
 	range->avg_qual.noise = 0;
-	range->avg_qual.updated = IW_QUAL_ALL_UPDATED;
+	range->avg_qual.updated = local->wstats_flags;
 
 	return 0;
 }
@@ -3052,16 +3053,16 @@ static int ieee80211_ioctl_siwauth(struc
 }
 
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
-static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *net_dev)
+static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
-	struct ieee80211_local *local = net_dev->ieee80211_ptr;
-	struct iw_statistics * wstats = &local->wstats;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(net_dev);
-	struct sta_info *sta;
-	static int tmp_level = 0;
-	static int tmp_qual = 0;
+	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct iw_statistics *wstats = &local->wstats;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta = NULL;
 
-	sta = sta_info_get(local, sdata->u.sta.bssid);
+	if (sdata->type == IEEE80211_IF_TYPE_STA ||
+	    sdata->type == IEEE80211_IF_TYPE_IBSS)
+		sta = sta_info_get(local, sdata->u.sta.bssid);
 	if (!sta) {
 		wstats->discard.fragment = 0;
 		wstats->discard.misc = 0;
@@ -3070,17 +3071,10 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.noise = 0;
 		wstats->qual.updated = IW_QUAL_ALL_INVALID;
 	} else {
-		if (!tmp_level) {	/* get initial values */
-			tmp_level = sta->last_signal;
-			tmp_qual = sta->last_rssi;
-		} else {		/* smooth results */
-			tmp_level = (15 * tmp_level + sta->last_signal)/16;
-			tmp_qual = (15 * tmp_qual + sta->last_rssi)/16;
-		}
-		wstats->qual.level = tmp_level;
-		wstats->qual.qual = 100*tmp_qual/local->hw.maxssi;
+		wstats->qual.level = sta->last_rssi;
+		wstats->qual.qual = sta->last_signal;
 		wstats->qual.noise = sta->last_noise;
-		wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
+		wstats->qual.updated = local->wstats_flags;
 		sta_info_put(sta);
 	}
 	return wstats;
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 1cb33cf..f5dd80f 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -1176,12 +1176,20 @@ static void ieee80211_rx_mgmt_assoc_resp
 	/* Add STA entry for the AP */
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
+		struct ieee80211_sta_bss *bss;
 		sta = sta_info_add(local, dev, ifsta->bssid, GFP_ATOMIC);
 		if (!sta) {
 			printk(KERN_DEBUG "%s: failed to add STA entry for the"
 			       " AP\n", dev->name);
 			return;
 		}
+		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
+		if (bss) {
+			sta->last_rssi = bss->rssi;
+			sta->last_signal = bss->signal;
+			sta->last_noise = bss->noise;
+			ieee80211_rx_bss_put(dev, bss);
+		}
 	}
 
 	sta->dev = dev;
@@ -1567,6 +1575,8 @@ #endif
 	bss->timestamp = timestamp;
 	bss->last_update = jiffies;
 	bss->rssi = rx_status->ssi;
+	bss->signal = rx_status->signal;
+	bss->noise = rx_status->noise;
 	if (!beacon)
 		bss->probe_resp++;
 	ieee80211_rx_bss_put(dev, bss);
@@ -2753,6 +2763,15 @@ ieee80211_sta_scan_result(struct net_dev
 					  IW_EV_FREQ_LEN);
 
 	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = IWEVQUAL;
+	iwe.u.qual.qual = bss->signal;
+	iwe.u.qual.level = bss->rssi;
+	iwe.u.qual.noise = bss->noise;
+	iwe.u.qual.updated = local->wstats_flags;
+	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
+					  IW_EV_QUAL_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWENCODE;
 	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-- 
1.3.0

