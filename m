Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:45090 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbXDNSNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 14:13:06 -0400
Date: Sat, 14 Apr 2007 13:14:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: Convert mac80211 to new statistics variable names
Message-ID: <462119ef.lAQ+Tavshbt8KWl2%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 2/4: Convert mac80211 routines to use the new stats variable names.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c
+++ wireless-dev/net/mac80211/ieee80211.c
@@ -2854,7 +2854,7 @@ ieee80211_fill_frame_info(struct ieee802
 		fi->antenna = htonl(status->antenna);
 		fi->priority = 0xffffffff; /* no clue */
 		fi->ssi_type = htonl(ieee80211_ssi_raw);
-		fi->ssi_signal = htonl(status->ssi);
+		fi->ssi_signal = htonl(status->level);
 		fi->ssi_noise = 0x00000000;
 		fi->encoding = 0;
 	} else {
@@ -3501,10 +3501,10 @@ ieee80211_rx_h_sta_process(struct ieee80
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = (sta->last_rssi * 15 +
-			  rx->u.rx.status->ssi) / 16;
-	sta->last_signal = (sta->last_signal * 15 +
-			    rx->u.rx.status->signal) / 16;
+	sta->last_level = (sta->last_level * 15 +
+			  rx->u.rx.status->level) / 16;
+	sta->last_qual = (sta->last_qual * 15 +
+			    rx->u.rx.status->qual) / 16;
 	sta->last_noise = (sta->last_noise * 15 +
 			   rx->u.rx.status->noise) / 16;
 
@@ -4800,13 +4800,13 @@ int ieee80211_register_hw(struct ieee802
 
 	local->hw.conf.beacon_int = 1000;
 
-	local->wstats_flags |= local->hw.max_rssi ?
+	local->wstats_flags |= local->hw.max_level ?
 			       IW_QUAL_LEVEL_UPDATED : IW_QUAL_LEVEL_INVALID;
-	local->wstats_flags |= local->hw.max_signal ?
+	local->wstats_flags |= local->hw.max_qual ?
 			       IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
 	local->wstats_flags |= local->hw.max_noise ?
 			       IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
-	if (local->hw.max_rssi < 0 || local->hw.max_noise < 0)
+	if (local->hw.max_level < 0 || local->hw.max_noise < 0)
 		local->wstats_flags |= IW_QUAL_DBM;
 
 	result = sta_info_start(local);
Index: wireless-dev/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c
+++ wireless-dev/net/mac80211/ieee80211_sta.c
@@ -1219,8 +1219,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
 		if (bss) {
-			sta->last_rssi = bss->rssi;
-			sta->last_signal = bss->signal;
+			sta->last_level = bss->level;
+			sta->last_qual = bss->qual;
 			sta->last_noise = bss->noise;
 			ieee80211_rx_bss_put(dev, bss);
 		}
@@ -1641,8 +1641,8 @@ static void ieee80211_rx_bss_info(struct
 	}
 	bss->timestamp = timestamp;
 	bss->last_update = jiffies;
-	bss->rssi = rx_status->ssi;
-	bss->signal = rx_status->signal;
+	bss->level = rx_status->level;
+	bss->qual = rx_status->qual;
 	bss->noise = rx_status->noise;
 	if (!beacon)
 		bss->probe_resp++;
@@ -2219,7 +2219,7 @@ static int ieee80211_sta_config_auth(str
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_sta_bss *bss, *selected = NULL;
-	int top_rssi = 0, freq;
+	int top_level = 0, freq;
 
 	if (!ifsta->auto_channel_sel && !ifsta->auto_bssid_sel &&
 	    !ifsta->auto_ssid_sel) {
@@ -2249,9 +2249,9 @@ static int ieee80211_sta_config_auth(str
 		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
 			continue;
 
-		if (top_rssi < bss->rssi) {
+		if (top_level < bss->level) {
 			selected = bss;
-			top_rssi = bss->rssi;
+			top_level = bss->level;
 		}
 	}
 	if (selected)
@@ -2981,8 +2981,8 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual = bss->signal;
-	iwe.u.qual.level = bss->rssi;
+	iwe.u.qual.qual = bss->qual;
+	iwe.u.qual.level = bss->level;
 	iwe.u.qual.noise = bss->noise;
 	iwe.u.qual.updated = local->wstats_flags;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c
@@ -443,7 +443,7 @@ static int ieee80211_ioctl_get_info_sta(
 		skb_queue_len(&sta->ps_tx_buf);
 	param->u.get_info_sta.tx_retry_failed = sta->tx_retry_failed;
 	param->u.get_info_sta.tx_retry_count = sta->tx_retry_count;
-	param->u.get_info_sta.last_rssi = sta->last_rssi;
+	param->u.get_info_sta.last_rssi = sta->last_level;
 	param->u.get_info_sta.last_ack_rssi = sta->last_ack_rssi[2];
 
 	sta_info_put(sta);
@@ -1590,12 +1590,12 @@ static int ieee80211_ioctl_giwrange(stru
 	range->num_encoding_sizes = 2;
 	range->max_encoding_tokens = NUM_DEFAULT_KEYS;
 
-	range->max_qual.qual = local->hw.max_signal;
+	range->max_qual.qual = local->hw.max_qual;
 	range->max_qual.level = local->hw.max_rssi;
 	range->max_qual.noise = local->hw.max_noise;
 	range->max_qual.updated = local->wstats_flags;
 
-	range->avg_qual.qual = local->hw.max_signal/2;
+	range->avg_qual.qual = local->hw.max_qual/2;
 	range->avg_qual.level = 0;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = local->wstats_flags;
@@ -3091,8 +3091,8 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.noise = 0;
 		wstats->qual.updated = IW_QUAL_ALL_INVALID;
 	} else {
-		wstats->qual.level = sta->last_rssi;
-		wstats->qual.qual = sta->last_signal;
+		wstats->qual.level = sta->last_level;
+		wstats->qual.qual = sta->last_qual;
 		wstats->qual.noise = sta->last_noise;
 		wstats->qual.updated = local->wstats_flags;
 		sta_info_put(sta);
Index: wireless-dev/net/mac80211/debugfs_sta.c
===================================================================
--- wireless-dev.orig/net/mac80211/debugfs_sta.c
+++ wireless-dev/net/mac80211/debugfs_sta.c
@@ -76,8 +76,8 @@ STA_FILE(txrate, txrate, RATE);
 STA_FILE(last_txrate, last_txrate, RATE);
 STA_FILE(tx_retry_failed, tx_retry_failed, LU);
 STA_FILE(tx_retry_count, tx_retry_count, LU);
-STA_FILE(last_rssi, last_rssi, D);
-STA_FILE(last_signal, last_signal, D);
+STA_FILE(last_level, last_level, D);
+STA_FILE(last_qual, last_qual, D);
 STA_FILE(last_noise, last_noise, D);
 STA_FILE(channel_use, channel_use, D);
 STA_FILE(wep_weak_iv_count, wep_weak_iv_count, D);
