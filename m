Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab2K0Gpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:43 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:43 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 20/20] wl18xx: set last Tx rate from FW status
Date: Tue, 27 Nov 2012 08:45:01 +0200
Message-Id: <1353998701-18171-21-git-send-email-arik@wizery.com> (sfid-20121127_074553_884863_ACBA3D2F)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obtain the last Tx rate from the FW status and translate it to
the mac80211 rate+flag format before sending it up via the Tx status.

Bump up the min FW version to the first FW that supports the rate byte.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/tx.c       |   56 +++++++++++++++++++++++++---
 drivers/net/wireless/ti/wlcore/conf.h     |   57 ++++++++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    5 ++-
 3 files changed, 98 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/tx.c b/drivers/net/wireless/ti/wl18xx/tx.c
index 5b1fb10..3c826d1 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.c
+++ b/drivers/net/wireless/ti/wl18xx/tx.c
@@ -28,6 +28,49 @@
 #include "wl18xx.h"
 #include "tx.h"
 
+static
+void wl18xx_get_last_tx_rate(struct wl1271 *wl, struct ieee80211_vif *vif,
+			     u8 *tx_rate, u8 *tx_rate_flags)
+{
+	u8 fw_rate = wl->fw_status_2->counters.tx_last_rate;
+
+	if (fw_rate > CONF_HW_RATE_INDEX_MAX) {
+		wl1271_error("last Tx rate invalid: %d", fw_rate);
+		*tx_rate = 0;
+		*tx_rate_flags = 0;
+		return;
+	}
+
+	if (fw_rate <= CONF_HW_RATE_INDEX_54MBPS) {
+		*tx_rate = fw_rate;
+		*tx_rate_flags = 0;
+	} else {
+		*tx_rate_flags = IEEE80211_TX_RC_MCS;
+		*tx_rate = fw_rate - CONF_HW_RATE_INDEX_MCS0;
+
+		/* SGI modifier is counted as a separate rate */
+		if (fw_rate >= CONF_HW_RATE_INDEX_MCS7_SGI)
+			(*tx_rate)--;
+		if (fw_rate == CONF_HW_RATE_INDEX_MCS15_SGI)
+			(*tx_rate)--;
+
+		/* this also covers the 40Mhz SGI case (= MCS15) */
+		if (fw_rate == CONF_HW_RATE_INDEX_MCS7_SGI ||
+		    fw_rate == CONF_HW_RATE_INDEX_MCS15_SGI)
+			*tx_rate_flags |= IEEE80211_TX_RC_SHORT_GI;
+
+		if (fw_rate > CONF_HW_RATE_INDEX_MCS7_SGI && vif) {
+			struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+			if (wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
+			    wlvif->channel_type == NL80211_CHAN_HT40PLUS) {
+				/* adjustment needed for range 0-7 */
+				*tx_rate -= 8;
+				*tx_rate_flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+			}
+		}
+	}
+}
+
 static void wl18xx_tx_complete_packet(struct wl1271 *wl, u8 tx_stat_byte)
 {
 	struct ieee80211_tx_info *info;
@@ -44,7 +87,6 @@ static void wl18xx_tx_complete_packet(struct wl1271 *wl, u8 tx_stat_byte)
 	/* a zero bit indicates Tx success */
 	tx_success = !(tx_stat_byte & BIT(WL18XX_TX_STATUS_STAT_BIT_IDX));
 
-
 	skb = wl->tx_frames[id];
 	info = IEEE80211_SKB_CB(skb);
 
@@ -56,11 +98,15 @@ static void wl18xx_tx_complete_packet(struct wl1271 *wl, u8 tx_stat_byte)
 	/* update the TX status info */
 	if (tx_success && !(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		info->flags |= IEEE80211_TX_STAT_ACK;
+	/*
+	 * first pass info->control.vif while it's valid, and then fill out
+	 * the info->status structures
+	 */
+	wl18xx_get_last_tx_rate(wl, info->control.vif,
+				&info->status.rates[0].idx,
+				&info->status.rates[0].flags);
 
-	/* no real data about Tx completion */
-	info->status.rates[0].idx = -1;
-	info->status.rates[0].count = 0;
-	info->status.rates[0].flags = 0;
+	info->status.rates[0].count = 1; /* no data about retries */
 	info->status.ack_signal = -1;
 
 	if (!tx_success)
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index e07d74d..ad15cae 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -57,20 +57,49 @@ enum {
 };
 
 enum {
-	CONF_HW_RATE_INDEX_1MBPS   = 0,
-	CONF_HW_RATE_INDEX_2MBPS   = 1,
-	CONF_HW_RATE_INDEX_5_5MBPS = 2,
-	CONF_HW_RATE_INDEX_6MBPS   = 3,
-	CONF_HW_RATE_INDEX_9MBPS   = 4,
-	CONF_HW_RATE_INDEX_11MBPS  = 5,
-	CONF_HW_RATE_INDEX_12MBPS  = 6,
-	CONF_HW_RATE_INDEX_18MBPS  = 7,
-	CONF_HW_RATE_INDEX_22MBPS  = 8,
-	CONF_HW_RATE_INDEX_24MBPS  = 9,
-	CONF_HW_RATE_INDEX_36MBPS  = 10,
-	CONF_HW_RATE_INDEX_48MBPS  = 11,
-	CONF_HW_RATE_INDEX_54MBPS  = 12,
-	CONF_HW_RATE_INDEX_MAX     = CONF_HW_RATE_INDEX_54MBPS,
+	CONF_HW_RATE_INDEX_1MBPS      = 0,
+	CONF_HW_RATE_INDEX_2MBPS      = 1,
+	CONF_HW_RATE_INDEX_5_5MBPS    = 2,
+	CONF_HW_RATE_INDEX_11MBPS     = 3,
+	CONF_HW_RATE_INDEX_6MBPS      = 4,
+	CONF_HW_RATE_INDEX_9MBPS      = 5,
+	CONF_HW_RATE_INDEX_12MBPS     = 6,
+	CONF_HW_RATE_INDEX_18MBPS     = 7,
+	CONF_HW_RATE_INDEX_24MBPS     = 8,
+	CONF_HW_RATE_INDEX_36MBPS     = 9,
+	CONF_HW_RATE_INDEX_48MBPS     = 10,
+	CONF_HW_RATE_INDEX_54MBPS     = 11,
+	CONF_HW_RATE_INDEX_MCS0       = 12,
+	CONF_HW_RATE_INDEX_MCS1       = 13,
+	CONF_HW_RATE_INDEX_MCS2       = 14,
+	CONF_HW_RATE_INDEX_MCS3       = 15,
+	CONF_HW_RATE_INDEX_MCS4       = 16,
+	CONF_HW_RATE_INDEX_MCS5       = 17,
+	CONF_HW_RATE_INDEX_MCS6       = 18,
+	CONF_HW_RATE_INDEX_MCS7       = 19,
+	CONF_HW_RATE_INDEX_MCS7_SGI   = 20,
+	CONF_HW_RATE_INDEX_MCS0_40MHZ = 21,
+	CONF_HW_RATE_INDEX_MCS1_40MHZ = 22,
+	CONF_HW_RATE_INDEX_MCS2_40MHZ = 23,
+	CONF_HW_RATE_INDEX_MCS3_40MHZ = 24,
+	CONF_HW_RATE_INDEX_MCS4_40MHZ = 25,
+	CONF_HW_RATE_INDEX_MCS5_40MHZ = 26,
+	CONF_HW_RATE_INDEX_MCS6_40MHZ = 27,
+	CONF_HW_RATE_INDEX_MCS7_40MHZ = 28,
+	CONF_HW_RATE_INDEX_MCS7_40MHZ_SGI = 29,
+
+	/* MCS8+ rates overlap with 40Mhz rates */
+	CONF_HW_RATE_INDEX_MCS8       = 21,
+	CONF_HW_RATE_INDEX_MCS9       = 22,
+	CONF_HW_RATE_INDEX_MCS10      = 23,
+	CONF_HW_RATE_INDEX_MCS11      = 24,
+	CONF_HW_RATE_INDEX_MCS12      = 25,
+	CONF_HW_RATE_INDEX_MCS13      = 26,
+	CONF_HW_RATE_INDEX_MCS14      = 27,
+	CONF_HW_RATE_INDEX_MCS15      = 28,
+	CONF_HW_RATE_INDEX_MCS15_SGI  = 29,
+
+	CONF_HW_RATE_INDEX_MAX        = CONF_HW_RATE_INDEX_MCS7_40MHZ_SGI,
 };
 
 #define CONF_HW_RXTX_RATE_UNSUPPORTED 0xff
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index e9fd879..a664662 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -141,7 +141,10 @@ struct wl_fw_packet_counters {
 	/* Cumulative counter of released Voice memory blocks */
 	u8 tx_voice_released_blks;
 
-	u8 padding[3];
+	/* Tx rate of the last transmitted packet */
+	u8 tx_last_rate;
+
+	u8 padding[2];
 } __packed;
 
 /* FW status registers */
-- 
1.7.9.5

