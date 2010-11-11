Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54585 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932227Ab0KKCdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 21:33:49 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/5] ath9k: remove the unnecessary private xretry tx flag
Date: Thu, 11 Nov 2010 03:18:34 +0100
Message-Id: <1289441918-94905-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/rc.c   |    2 +-
 drivers/net/wireless/ath/ath9k/rc.h   |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c |    3 ---
 3 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 85c8e93..c052bd6 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1370,7 +1370,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		is_underrun = 1;
 	}
 
-	if (tx_info->pad[0] & ATH_TX_INFO_XRETRY)
+	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
 		tx_status = 1;
 
 	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 2f46a22..a1dce43 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -227,7 +227,6 @@ struct ath_rate_priv {
 
 #define ATH_TX_INFO_FRAME_TYPE_INTERNAL	(1 << 0)
 #define ATH_TX_INFO_FRAME_TYPE_PAUSE	(1 << 1)
-#define ATH_TX_INFO_XRETRY		(1 << 3)
 #define ATH_TX_INFO_UNDERRUN		(1 << 4)
 
 enum ath9k_internal_frame_type {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6380bbd..eaaeb93 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1993,9 +1993,6 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 			if (ts->ts_flags &
 			    (ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN))
 				tx_info->pad[0] |= ATH_TX_INFO_UNDERRUN;
-			if ((ts->ts_status & ATH9K_TXERR_XRETRY) ||
-			    (ts->ts_status & ATH9K_TXERR_FIFO))
-				tx_info->pad[0] |= ATH_TX_INFO_XRETRY;
 		}
 	}
 
-- 
1.7.2.2

