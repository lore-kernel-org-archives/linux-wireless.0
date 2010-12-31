Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59669 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0LaPTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Dec 2010 10:19:08 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 31 Dec 2010 07:18:51 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k : few rate control clean ups
Date: Fri, 31 Dec 2010 20:49:00 +0530
Message-ID: <1293808740-9127-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Remove some obvious looking dead code and rename few functions

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   16 ++++++++--------
 drivers/net/wireless/ath/ath9k/rc.h |    3 ---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 896d129..e451478 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -400,7 +400,7 @@ static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 	}
 }
 
-static void ath_rc_init_valid_txmask(struct ath_rate_priv *ath_rc_priv)
+static void ath_rc_init_valid_rate_idx(struct ath_rate_priv *ath_rc_priv)
 {
 	u8 i;
 
@@ -408,7 +408,7 @@ static void ath_rc_init_valid_txmask(struct ath_rate_priv *ath_rc_priv)
 		ath_rc_priv->valid_rate_index[i] = 0;
 }
 
-static inline void ath_rc_set_valid_txmask(struct ath_rate_priv *ath_rc_priv,
+static inline void ath_rc_set_valid_rate_idx(struct ath_rate_priv *ath_rc_priv,
 					   u8 index, int valid_tx_rate)
 {
 	BUG_ON(index > ath_rc_priv->rate_table_size);
@@ -489,7 +489,7 @@ static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv,
 
 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = i;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_txmask(ath_rc_priv, i, 1);
+			ath_rc_set_valid_rate_idx(ath_rc_priv, i, 1);
 			hi = i;
 		}
 	}
@@ -532,7 +532,7 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 				ath_rc_priv->valid_phy_rateidx[phy]
 					[valid_rate_count] = j;
 				ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-				ath_rc_set_valid_txmask(ath_rc_priv, j, 1);
+				ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
 				hi = A_MAX(hi, j);
 			}
 		}
@@ -568,7 +568,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 			ath_rc_priv->valid_phy_rateidx[phy]
 				[ath_rc_priv->valid_phy_ratecnt[phy]] = j;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_txmask(ath_rc_priv, j, 1);
+			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
 			hi = A_MAX(hi, j);
 		}
 	}
@@ -1210,7 +1210,7 @@ static void ath_rc_init(struct ath_softc *sc,
 	}
 
 	/* Determine the valid rates */
-	ath_rc_init_valid_txmask(ath_rc_priv);
+	ath_rc_init_valid_rate_idx(ath_rc_priv);
 
 	for (i = 0; i < WLAN_RC_PHY_MAX; i++) {
 		for (j = 0; j < MAX_TX_RATE_PHY; j++)
@@ -1321,7 +1321,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
-	int final_ts_idx = 0, tx_status = 0, is_underrun = 0;
+	int final_ts_idx = 0, tx_status = 0;
 	int long_retry = 0;
 	__le16 fc;
 	int i;
@@ -1358,7 +1358,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		tx_status = 1;
 
 	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
-			 (is_underrun) ? sc->hw->max_rate_tries : long_retry);
+			 long_retry);
 
 	/* Check if aggregation has to be enabled for this tid */
 	if (conf_is_ht(&sc->hw->conf) &&
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 31a004c..5d984b8 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -195,7 +195,6 @@ struct ath_rc_stats {
  * @rate_max_phy: phy index for the max rate
  * @per: PER for every valid rate in %
  * @probe_interval: interval for ratectrl to probe for other rates
- * @prev_data_rix: rate idx of last data frame
  * @ht_cap: HT capabilities
  * @neg_rates: Negotatied rates
  * @neg_ht_rates: Negotiated HT rates
@@ -214,10 +213,8 @@ struct ath_rate_priv {
 	u32 probe_time;
 	u32 per_down_time;
 	u32 probe_interval;
-	u32 prev_data_rix;
 	struct ath_rateset neg_rates;
 	struct ath_rateset neg_ht_rates;
-	struct ath_rate_softc *asc;
 	const struct ath_rate_table *rate_table;
 
 	struct dentry *debugfs_rcstats;
-- 
1.7.0.4

