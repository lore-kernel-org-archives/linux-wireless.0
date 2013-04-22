Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53672 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab3DVO3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 2/2] mac80211: add support for per-chain signal strength reporting
Date: Mon, 22 Apr 2013 16:29:31 +0200
Message-Id: <1366640971-12872-2-git-send-email-nbd@openwrt.org> (sfid-20130422_162957_148736_87EDDABB)
In-Reply-To: <1366640971-12872-1-git-send-email-nbd@openwrt.org>
References: <1366640971-12872-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h  |  5 +++++
 net/mac80211/cfg.c      | 13 ++++++++++++-
 net/mac80211/rx.c       | 14 ++++++++++++++
 net/mac80211/sta_info.c |  2 ++
 net/mac80211/sta_info.h |  5 +++++
 5 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4ecff78..aeb4a5c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -848,6 +848,9 @@ enum mac80211_rx_flags {
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
  *	unspecified depending on the hardware capabilities flags
  *	@IEEE80211_HW_SIGNAL_*
+ * @chains: bitmask of receive chains for which separate signal strength
+ *	values were filled.
+ * @chain_signal: per-chain signal strength, same format as @signal
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
@@ -879,6 +882,8 @@ struct ieee80211_rx_status {
 	u8 band;
 	u8 antenna;
 	s8 signal;
+	u8 chains;
+	s8 chain_signal[IEEE80211_MAX_CHAINS];
 	u8 ampdu_delimiter_crc;
 	u8 vendor_radiotap_align;
 	u8 vendor_radiotap_oui[3];
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 490990e..b1b8841 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -444,7 +444,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	struct ieee80211_local *local = sdata->local;
 	struct timespec uptime;
 	u64 packets = 0;
-	int ac;
+	int i, ac;
 
 	sinfo->generation = sdata->local->sta_generation;
 
@@ -488,6 +488,17 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			sinfo->signal = (s8)sta->last_signal;
 		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
 	}
+	if (sta->chains) {
+		sinfo->filled |= STATION_INFO_CHAIN_SIGNAL |
+				 STATION_INFO_CHAIN_SIGNAL_AVG;
+
+		sinfo->chains = sta->chains;
+		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
+			sinfo->chain_signal[i] = sta->chain_signal_last[i];
+			sinfo->chain_signal_avg[i] =
+				(s8) -ewma_read(&sta->chain_signal_avg[i]);
+		}
+	}
 
 	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
 	sta_set_rate_info_rx(sta, &sinfo->rxrate);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4ffff07..ce33b56 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1372,6 +1372,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	int i;
 
 	if (!sta)
 		return RX_CONTINUE;
@@ -1422,6 +1423,19 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		ewma_add(&sta->avg_signal, -status->signal);
 	}
 
+	if (status->chains) {
+		sta->chains = status->chains;
+		for (i = 0; i < ARRAY_SIZE(status->chain_signal); i++) {
+			int signal = status->chain_signal[i];
+
+			if (!(status->chains & BIT(i)))
+				continue;
+
+			sta->chain_signal_last[i] = signal;
+			ewma_add(&sta->chain_signal_avg[i], -signal);
+		}
+	}
+
 	/*
 	 * Change STA power saving mode only at the end of a frame
 	 * exchange sequence.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 11216bc..a04c5671 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -358,6 +358,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	do_posix_clock_monotonic_gettime(&uptime);
 	sta->last_connected = uptime.tv_sec;
 	ewma_init(&sta->avg_signal, 1024, 8);
+	for (i = 0; i < ARRAY_SIZE(sta->chain_signal_avg); i++)
+		ewma_init(&sta->chain_signal_avg[i], 1024, 8);
 
 	if (sta_prepare_rate_control(local, sta, gfp)) {
 		kfree(sta);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 876dd3f..fa1aa8a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -342,6 +342,11 @@ struct sta_info {
 	int last_signal;
 	struct ewma avg_signal;
 	int last_ack_signal;
+
+	u8 chains;
+	s8 chain_signal_last[IEEE80211_MAX_CHAINS];
+	struct ewma chain_signal_avg[IEEE80211_MAX_CHAINS];
+
 	/* Plus 1 for non-QoS frames */
 	__le16 last_seq_ctrl[IEEE80211_NUM_TIDS + 1];
 
-- 
1.8.0.2

