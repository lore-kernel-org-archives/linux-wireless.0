Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:21992 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0CZKx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:53:57 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 03/24] wl1271: Add TX rate reporting
Date: Fri, 26 Mar 2010 12:53:12 +0200
Message-Id: <1269600813-32145-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add reporting of the used TX rate to mac80211 in the tx_status.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   27 +++++++++++++++------------
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 49779e5..8645030 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2127,6 +2127,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
 
 	wl->hw->queues = 4;
+	wl->hw->max_rates = 1;
 
 	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 6d109df..5712489 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -304,6 +304,8 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
 	int id = result->id;
+	int rate = -1;
+	u8 retries = 0;
 
 	/* check for id legality */
 	if (unlikely(id >= ACX_TX_DESCRIPTORS || wl->tx_frames[id] == NULL)) {
@@ -314,19 +316,22 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	skb = wl->tx_frames[id];
 	info = IEEE80211_SKB_CB(skb);
 
-	/* update packet status */
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		if (result->status == TX_SUCCESS)
+	/* update the TX status info */
+	if (result->status == TX_SUCCESS) {
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 			info->flags |= IEEE80211_TX_STAT_ACK;
-		if (result->status & TX_RETRY_EXCEEDED) {
-			/* FIXME */
-			/* info->status.excessive_retries = 1; */
-			wl->stats.excessive_retries++;
-		}
+		rate = wl1271_rate_to_idx(wl, result->rate_class_index);
+		retries = result->ack_failures;
+	} else if (result->status == TX_RETRY_EXCEEDED) {
+		wl->stats.excessive_retries++;
+		retries = result->ack_failures;
 	}
 
-	/* FIXME */
-	/* info->status.retry_count = result->ack_failures; */
+	info->status.rates[0].idx = rate;
+	info->status.rates[0].count = retries;
+	info->status.rates[0].flags = 0;
+	info->status.ack_signal = -1;
+
 	wl->stats.retry_count += result->ack_failures;
 
 	/* update security sequence number */
@@ -350,8 +355,6 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 		     result->id, skb, result->ack_failures,
 		     result->rate_class_index, result->status);
 
-	/* FIXME: do we need to tell the stack about the used rate? */
-
 	/* return the packet to the stack */
 	ieee80211_tx_status(wl->hw, skb);
 	wl->tx_frames[result->id] = NULL;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 5e6c27a..b03c95d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -159,5 +159,6 @@ static inline int wl1271_tx_ac_to_tid(int ac)
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
+u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate);
 
 #endif
-- 
1.6.3.3

