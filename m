Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXFVIlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:41:00 -0400
Message-Id: <20070621221757.805759000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 06/14] mac80211: fix bug for per-sta stats
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pre_rx handlers can't really touch sta since for IBSS it might not be
assigned yet, it can create sta info structs on-the-fly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-06-21 21:40:59.028638003 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-06-21 21:43:01.838638003 +0200
@@ -28,6 +28,8 @@
 /* pre-rx handlers
  *
  * these don't have dev/sdata fields in the rx data
+ * The sta value should also not be used because it may
+ * be NULL even though a STA (in IBSS mode) will be added.
  */
 
 static ieee80211_txrx_result
@@ -57,12 +59,11 @@ ieee80211_rx_h_parse_qos(struct ieee8021
 		}
 		rx->u.rx.qos_control = 0;
 	}
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+
 	I802_DEBUG_INC(rx->local->wme_rx_queue[tid]);
-	if (rx->sta) {
+	/* only a debug counter, sta might not be assigned properly yet */
+	if (rx->sta)
 		I802_DEBUG_INC(rx->sta->wme_rx_queue[tid]);
-	}
-#endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
 	rx->u.rx.queue = tid;
 	rx->u.rx.is_agg_frame = is_agg_frame;
@@ -119,8 +120,6 @@ ieee80211_rx_h_load_stats(struct ieee802
 	/* Divide channel_use by 8 to avoid wrapping around the counter */
 	load >>= CHAN_UTIL_SHIFT;
 	local->channel_use_raw += load;
-	if (rx->sta)
-		rx->sta->channel_use_raw += load;
 	rx->u.rx.load = load;
 
 	return TXRX_CONTINUE;
@@ -140,6 +139,8 @@ ieee80211_rx_handler ieee80211_rx_pre_ha
 static ieee80211_txrx_result
 ieee80211_rx_h_if_stats(struct ieee80211_txrx_data *rx)
 {
+	if (rx->sta)
+		rx->sta->channel_use_raw += rx->u.rx.load;
 	rx->sdata->channel_use_raw += rx->u.rx.load;
 	return TXRX_CONTINUE;
 }

-- 

