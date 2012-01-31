Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48217 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2AaPvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 10:51:18 -0500
Received: by wgbdt10 with SMTP id dt10so118881wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 07:51:15 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] wl12xx: Set IEEE80211_TX_RC_MCS on MCS rates on TX complete.
Date: Tue, 31 Jan 2012 17:54:40 +0200
Message-Id: <1328025283-22888-1-git-send-email-eliad@wizery.com> (sfid-20120131_165121_760692_6EA81A55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

IEEE80211_TX_RC_MCS was not set correctly leading to incorrect link
speed calculation.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/conf.h |    4 ++++
 drivers/net/wireless/wl12xx/tx.c   |   12 +++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index f29fbfd..a152713 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -91,6 +91,10 @@ enum {
 	CONF_HW_RXTX_RATE_UNSUPPORTED = 0xff
 };
 
+/* Rates between and including these are MCS rates */
+#define CONF_HW_RXTX_RATE_MCS_MIN CONF_HW_RXTX_RATE_MCS7
+#define CONF_HW_RXTX_RATE_MCS_MAX CONF_HW_RXTX_RATE_MCS0
+
 enum {
 	CONF_SG_DISABLE = 0,
 	CONF_SG_PROTECTIVE,
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 2bf43b8..f95112f 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -764,6 +764,14 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static u8 wl1271_tx_get_rate_flags(u8 rate_class_index)
+{
+	if (rate_class_index >= CONF_HW_RXTX_RATE_MCS_MIN &&
+	    rate_class_index <= CONF_HW_RXTX_RATE_MCS_MAX)
+		return IEEE80211_TX_RC_MCS;
+	return 0;
+}
+
 static void wl1271_tx_complete_packet(struct wl1271 *wl,
 				      struct wl1271_tx_hw_res_descr *result)
 {
@@ -773,6 +781,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	struct sk_buff *skb;
 	int id = result->id;
 	int rate = -1;
+	u8 rate_flags = 0;
 	u8 retries = 0;
 
 	/* check for id legality */
@@ -799,6 +808,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 			info->flags |= IEEE80211_TX_STAT_ACK;
 		rate = wl1271_rate_to_idx(result->rate_class_index,
 					  wlvif->band);
+		rate_flags = wl1271_tx_get_rate_flags(result->rate_class_index);
 		retries = result->ack_failures;
 	} else if (result->status == TX_RETRY_EXCEEDED) {
 		wl->stats.excessive_retries++;
@@ -807,7 +817,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 
 	info->status.rates[0].idx = rate;
 	info->status.rates[0].count = retries;
-	info->status.rates[0].flags = 0;
+	info->status.rates[0].flags = rate_flags;
 	info->status.ack_signal = -1;
 
 	wl->stats.retry_count += result->ack_failures;
-- 
1.7.6.401.g6a319

