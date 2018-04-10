Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:46852 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754333AbeDJPCA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:02:00 -0400
Received: by mail-pl0-f68.google.com with SMTP id 59-v6so7683696plc.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:02:00 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 7/7] rsi: advertise 5GHz support based on device capability
Date: Tue, 10 Apr 2018 20:34:17 +0530
Message-Id: <1523372657-6067-8-git-send-email-siva8118@gmail.com> (sfid-20180410_170210_548054_EE732AED)
In-Reply-To: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Currently 5GHz gets advertised even for the device which supports
only 2.4Ghz band. This patch fixes the issue

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index bb497bd..766d874 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1957,8 +1957,6 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	hw->max_tx_aggregation_subframes = RSI_MAX_TX_AGGR_FRMS;
 	hw->max_rx_aggregation_subframes = RSI_MAX_RX_AGGR_FRMS;
-	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
-	rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
 	hw->rate_control_algorithm = "AARF";
 
 	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
@@ -1979,10 +1977,15 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	wiphy->available_antennas_rx = 1;
 	wiphy->available_antennas_tx = 1;
+
+	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
 	wiphy->bands[NL80211_BAND_2GHZ] =
 		&adapter->sbands[NL80211_BAND_2GHZ];
-	wiphy->bands[NL80211_BAND_5GHZ] =
-		&adapter->sbands[NL80211_BAND_5GHZ];
+	if (common->num_supp_bands > 1) {
+		rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
+		wiphy->bands[NL80211_BAND_5GHZ] =
+			&adapter->sbands[NL80211_BAND_5GHZ];
+	}
 
 	/* AP Parameters */
 	wiphy->max_ap_assoc_sta = rsi_max_ap_stas[common->oper_mode - 1];
-- 
2.7.4
