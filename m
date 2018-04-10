Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:33263 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754085AbeDJPBx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:01:53 -0400
Received: by mail-pl0-f66.google.com with SMTP id s10-v6so7700447plp.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:01:52 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 4/7] rsi: increase max supported aggregation subframes
Date: Tue, 10 Apr 2018 20:34:14 +0530
Message-Id: <1523372657-6067-5-git-send-email-siva8118@gmail.com> (sfid-20180410_170159_242789_F04F7934)
In-Reply-To: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Maximum number of supported aggregation subframes has been increased
to 8. This is the optimal number for the driver.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 3 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 77aa3bb..2a77743 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1955,7 +1955,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	hw->uapsd_queues = RSI_IEEE80211_UAPSD_QUEUES;
 	hw->uapsd_max_sp_len = IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL;
 
-	hw->max_tx_aggregation_subframes = 6;
+	hw->max_tx_aggregation_subframes = RSI_MAX_TX_AGGR_FRMS;
+	hw->max_rx_aggregation_subframes = RSI_MAX_RX_AGGR_FRMS;
 	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
 	rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
 	hw->rate_control_algorithm = "AARF";
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 5f946f3..1462093 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -225,6 +225,9 @@
 #define RSI_WOW_DISCONNECT		BIT(5)
 #endif
 
+#define RSI_MAX_TX_AGGR_FRMS		8
+#define RSI_MAX_RX_AGGR_FRMS		8
+
 enum opmode {
 	RSI_OPMODE_UNSUPPORTED = -1,
 	RSI_OPMODE_AP = 0,
-- 
2.7.4
