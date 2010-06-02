Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57546 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757776Ab0FBKW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:22:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:22:26 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12588.699806.245206@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:53:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/8] ath9k_htc: Setup HT capabilites for 2-stream devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The supported MCS rate set has to be setup properly
for 2-stream devices.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index ff6c080..acd9cb9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -398,6 +398,10 @@ static const struct ath_bus_ops ath9k_usb_bus_ops = {
 static void setup_ht_cap(struct ath9k_htc_priv *priv,
 			 struct ieee80211_sta_ht_cap *ht_info)
 {
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	u8 tx_streams, rx_streams;
+	int i;
+
 	ht_info->ht_supported = true;
 	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 		       IEEE80211_HT_CAP_SM_PS |
@@ -413,7 +417,24 @@ static void setup_ht_cap(struct ath9k_htc_priv *priv,
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	ht_info->mcs.rx_mask[0] = 0xff;
+
+	/* ath9k_htc supports only 1 or 2 stream devices */
+	tx_streams = ath9k_cmn_count_streams(common->tx_chainmask, 2);
+	rx_streams = ath9k_cmn_count_streams(common->rx_chainmask, 2);
+
+	ath_print(common, ATH_DBG_CONFIG,
+		  "TX streams %d, RX streams: %d\n",
+		  tx_streams, rx_streams);
+
+	if (tx_streams != rx_streams) {
+		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
+					   IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
+	}
+
+	for (i = 0; i < rx_streams; i++)
+		ht_info->mcs.rx_mask[i] = 0xff;
+
 	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
 }
 
-- 
1.7.1

