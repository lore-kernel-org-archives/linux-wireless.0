Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48812 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab0CAMcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 07:32:21 -0500
Message-ID: <4B8BB3CB.7070601@openwrt.org>
Date: Mon, 01 Mar 2010 13:32:11 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix rate control tx status handling for A-MPDU
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the rate control tx status update gets called for every
subframe of an A-MPDU, and ath9k marks the frame with the relevant
status update with an internal flag. This not suitable for rate control
algorithms using the standard mac80211 rate control API, so fix this by
using IEEE80211_TX_STAT_AMPDU for marking the correct frames that
should be processed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1947,10 +1947,10 @@ static void ath_tx_rc_status(struct ath_
 	tx_rateindex = ds->ds_txstat.ts_rateindex;
 	WARN_ON(tx_rateindex >= hw->max_rates);
 
-	if (update_rc)
-		tx_info->pad[0] |= ATH_TX_INFO_UPDATE_RC;
 	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && update_rc)
+		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 
 	if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0 && update_rc) {
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -172,7 +172,6 @@ struct ath_rate_priv {
 
 #define ATH_TX_INFO_FRAME_TYPE_INTERNAL	(1 << 0)
 #define ATH_TX_INFO_FRAME_TYPE_PAUSE	(1 << 1)
-#define ATH_TX_INFO_UPDATE_RC		(1 << 2)
 #define ATH_TX_INFO_XRETRY		(1 << 3)
 #define ATH_TX_INFO_UNDERRUN		(1 << 4)
 
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1226,8 +1226,12 @@ static void ath_tx_status(void *priv, st
 		long_retry = rate->count - 1;
 	}
 
-	if (!priv_sta || !ieee80211_is_data(fc) ||
-	    !(tx_info->pad[0] & ATH_TX_INFO_UPDATE_RC))
+	if (!priv_sta || !ieee80211_is_data(fc))
+		return;
+
+	/* This packet was aggregated but doesn't carry status info */
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	    !(tx_info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
