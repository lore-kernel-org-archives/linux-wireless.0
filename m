Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57123 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1JRSiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 14:38:16 -0400
Received: by bkbzt19 with SMTP id zt19so1105327bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 11:38:15 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH V2] Set IEEE80211_TX_RC_MCS on MCS rates on TX complete.
Date: Tue, 18 Oct 2011 20:38:02 +0200
Message-Id: <1318963082-31888-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20111018_203820_136993_203448FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_TX_RC_MCS was not set correctly leading to incorrect link
speed calculation.

Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
Version 2: Added missing sign-off.

 drivers/net/wireless/wl12xx/conf.h |    4 ++++
 drivers/net/wireless/wl12xx/tx.c   |   12 +++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 04bb8fb..b3f9592 100644
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
index c7ad4f5..40c5669 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -798,6 +798,14 @@ out:
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
@@ -807,6 +815,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	struct sk_buff *skb;
 	int id = result->id;
 	int rate = -1;
+	u8 rate_flags = 0;
 	u8 retries = 0;
 
 	/* check for id legality */
@@ -833,6 +842,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 			info->flags |= IEEE80211_TX_STAT_ACK;
 		rate = wl1271_rate_to_idx(result->rate_class_index,
 					  wlvif->band);
+		rate_flags = wl1271_tx_get_rate_flags(result->rate_class_index);
 		retries = result->ack_failures;
 	} else if (result->status == TX_RETRY_EXCEEDED) {
 		wl->stats.excessive_retries++;
@@ -841,7 +851,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 
 	info->status.rates[0].idx = rate;
 	info->status.rates[0].count = retries;
-	info->status.rates[0].flags = 0;
+	info->status.rates[0].flags = rate_flags;
 	info->status.ack_signal = -1;
 
 	wl->stats.retry_count += result->ack_failures;
-- 
1.7.4.1

