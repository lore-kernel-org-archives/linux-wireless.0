Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47580 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYKTSx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 13:53:28 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 10:53:28 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>
Subject: [PATCH] ath9k: Dont update rate control for every AMPDU
Date: Thu, 20 Nov 2008 11:51:18 +0530
Message-ID: <1227162078-6042-1-git-send-email-vasanth@atheros.com> (sfid-20081120_195334_811665_2F57A3B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the rate control only with the tx status of first
AMPDU of an aggregation. This patch fixes frequent drops
in throughput.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c   |    3 ++-
 drivers/net/wireless/ath9k/rc.h   |    1 +
 drivers/net/wireless/ath9k/xmit.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index e118824..7d1913d 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1413,7 +1413,8 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	an = (struct ath_node *)sta->drv_priv;
 	final_ts_idx = tx_info_priv->tx.ts_rateindex;
 
-	if (!an || !priv_sta || !ieee80211_is_data(fc))
+	if (!an || !priv_sta || !ieee80211_is_data(fc) ||
+	    !tx_info_priv->update_rc)
 		goto exit;
 
 	if (tx_info_priv->tx.ts_status & ATH9K_TXERR_FILT)
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 297dff9..97c60d1 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -188,6 +188,7 @@ struct ath_tx_info_priv {
 	struct ath_tx_status tx;
 	int n_frames;
 	int n_bad_frames;
+	bool update_rc;
 };
 
 #define ATH_TX_INFO_PRIV(tx_info) \
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 50d4105..dad81a9 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -950,6 +950,7 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 
+	tx_info_priv->update_rc = false;
 	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 
@@ -960,6 +961,7 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
 			       sizeof(tx_info_priv->tx));
 			tx_info_priv->n_frames = bf->bf_nframes;
 			tx_info_priv->n_bad_frames = nbad;
+			tx_info_priv->update_rc = true;
 		}
 	}
 }
-- 
1.5.5.1

