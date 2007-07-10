Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.240]:45704 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbXGJXGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 19:06:55 -0400
Received: by ag-out-0708.google.com with SMTP id 35so1044413aga
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2007 16:06:54 -0700 (PDT)
To: jbenc@suse.cz, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org
Cc: ben.m.cahill@intel.com
Subject: [PATCH 1/1] mac80211: Replace overly "sticky" averaging filters for rssi, signal, noise.
Date: Tue, 10 Jul 2007 19:05:05 -0400
Message-Id: <11841087052370-git-send-email-ben.m.cahill@intel.com>
From: benmcahill@gmail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Replace overly "sticky" averaging filters for rssi, signal, noise ...

In old filter, once initial values were set, it took a large deviation (16)
in new input values in order to nudge the filter output.  This made signal
quality displays appear frozen, with (probably) inaccurate data.

The new filter keeps high-precision (16x) running averages, then quantizes
them to create the output value.  Each new input value nudges the running
average a bit, and displays appear reassuringly alive, with accurate data.

Update comments.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
---
 net/mac80211/ieee80211.c     |   20 ++++++++++++++------
 net/mac80211/ieee80211_sta.c |    7 +++++++
 net/mac80211/sta_info.h      |    9 ++++++---
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 873ccb0..b838d9c 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -3603,12 +3603,20 @@ ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = (sta->last_rssi * 15 +
-			  rx->u.rx.status->ssi) / 16;
-	sta->last_signal = (sta->last_signal * 15 +
-			    rx->u.rx.status->signal) / 16;
-	sta->last_noise = (sta->last_noise * 15 +
-			   rx->u.rx.status->noise) / 16;
+
+	/* Low pass filter:  15/16 current avg + new.
+	 * Accumulated values here are 16x values sent from driver. */
+	sta->accum_rssi = sta->accum_rssi - (sta->accum_rssi >> 4) +
+			  rx->u.rx.status->ssi;
+	sta->accum_signal = sta->accum_signal - (sta->accum_signal >> 4) +
+			  rx->u.rx.status->signal;
+	sta->accum_noise = sta->accum_noise - (sta->accum_noise >> 4) +
+			  rx->u.rx.status->noise;
+
+	/* Quantize the averages (divide by 16) */
+	sta->last_rssi = sta->accum_rssi >> 4;
+	sta->last_signal = sta->accum_signal >> 4;
+	sta->last_noise = sta->accum_noise >> 4;
 
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
 		/* Change STA power saving mode only in the end of a frame
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index b003912..5986183 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1223,9 +1223,16 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
 		if (bss) {
+			/* Init signal values from beacon or probe response. */
 			sta->last_rssi = bss->rssi;
 			sta->last_signal = bss->signal;
 			sta->last_noise = bss->noise;
+
+			/* Init averaging filter accumulators to 16x values. */
+			sta->accum_rssi = bss->rssi << 4;
+			sta->accum_signal = bss->signal << 4;
+			sta->accum_noise = bss->noise << 4;
+
 			ieee80211_rx_bss_put(dev, bss);
 		}
 	}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6a067a0..0ee9212 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -83,9 +83,12 @@ struct sta_info {
 	unsigned long rx_fragments; /* number of received MPDUs */
 	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */
 
-	int last_rssi; /* RSSI of last received frame from this STA */
-	int last_signal; /* signal of last received frame from this STA */
-	int last_noise; /* noise of last received frame from this STA */
+	int accum_rssi; /* hi-precision running average (rssi * 16) */
+	int accum_signal; /* hi-precision average (signal-quality * 16) */
+	int accum_noise; /* hi-precision running average (noise * 16) */
+	int last_rssi; /* average RSSI of recent frames from this STA */
+	int last_signal; /* average sig-qual of recent frames from this STA */
+	int last_noise; /* average noise of recent frames from this STA */
 	int last_ack_rssi[3]; /* RSSI of last received ACKs from this STA */
 	unsigned long last_ack;
 	int channel_use;
-- 
1.5.2

