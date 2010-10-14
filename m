Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41462 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab0JNFrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 01:47:11 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9E5kk2x008232
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 08:47:07 +0300
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH] wl1271: Fix warning about unsupported RX rate
Date: Thu, 14 Oct 2010 08:46:30 +0300
Message-Id: <1287035190-26392-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While scanning, it is possible that beacon and probe response frames are
received on other band than configured to the driver. In rx status
handling this has caused "Unsupported RX rate from HW" warnings. This
patch changes the wl1271_rate_to_index function to take the band of the
received frame as a parameter instead of using value configuret to
wl->band.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 +++---
 drivers/net/wireless/wl12xx/wl1271_rx.c   |   10 +++++++++-
 drivers/net/wireless/wl12xx/wl1271_rx.h   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index a99ad40..8d350cd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2269,18 +2269,18 @@ static const struct ieee80211_ops wl1271_ops = {
 };
 
 
-u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate)
+u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band)
 {
 	u8 idx;
 
-	BUG_ON(wl->band >= sizeof(wl1271_band_rate_to_idx)/sizeof(u8 *));
+	BUG_ON(band >= sizeof(wl1271_band_rate_to_idx)/sizeof(u8 *));
 
 	if (unlikely(rate >= CONF_HW_RXTX_RATE_MAX)) {
 		wl1271_error("Illegal RX rate from HW: %d", rate);
 		return 0;
 	}
 
-	idx = wl1271_band_rate_to_idx[wl->band][rate];
+	idx = wl1271_band_rate_to_idx[band][rate];
 	if (unlikely(idx == CONF_HW_RXTX_RATE_UNSUPPORTED)) {
 		wl1271_error("Unsupported RX rate from HW: %d", rate);
 		return 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 0478f29..64ce6ae 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -46,10 +46,18 @@ static void wl1271_rx_status(struct wl1271 *wl,
 			     struct ieee80211_rx_status *status,
 			     u8 beacon)
 {
+	enum ieee80211_band desc_band;
+
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
 	status->band = wl->band;
-	status->rate_idx = wl1271_rate_to_idx(wl, desc->rate);
+
+	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) == WL1271_RX_DESC_BAND_BG)
+		desc_band = IEEE80211_BAND_2GHZ;
+	else
+		desc_band = IEEE80211_BAND_5GHZ;
+
+	status->rate_idx = wl1271_rate_to_idx(desc->rate, desc_band);
 
 	status->signal = desc->rssi;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.h b/drivers/net/wireless/wl12xx/wl1271_rx.h
index b89be47..3968d37 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.h
@@ -116,6 +116,6 @@ struct wl1271_rx_descriptor {
 } __attribute__ ((packed));
 
 void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status);
-u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate);
+u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index e3dc13c..c97ba31 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -298,7 +298,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	if (result->status == TX_SUCCESS) {
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 			info->flags |= IEEE80211_TX_STAT_ACK;
-		rate = wl1271_rate_to_idx(wl, result->rate_class_index);
+		rate = wl1271_rate_to_idx(result->rate_class_index, wl->band);
 		retries = result->ack_failures;
 	} else if (result->status == TX_RETRY_EXCEEDED) {
 		wl->stats.excessive_retries++;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 8979085..a952022 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -143,7 +143,7 @@ void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_reset(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
-u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate);
+u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
 
 #endif
-- 
1.7.1

