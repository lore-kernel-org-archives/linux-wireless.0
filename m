Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:54215 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbdI2TsN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 15:48:13 -0400
Received: by mail-oi0-f66.google.com with SMTP id j126so1071524oia.10
        for <linux-wireless@vger.kernel.org>; Fri, 29 Sep 2017 12:48:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/10] rtlwifi: Add TX/RX throughput statistics in period
Date: Fri, 29 Sep 2017 14:47:56 -0500
Message-Id: <20170929194800.15617-7-Larry.Finger@lwfinger.net> (sfid-20170929_214828_074616_3B6BA38B)
In-Reply-To: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
References: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The statistic variables use u64 to get higher precision.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 16 ++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 15 +++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 081b9507e02e..e28261bc2c27 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1998,6 +1998,22 @@ void rtl_watchdog_wq_callback(void *data)
 	rtlpriv->link_info.tx_busy_traffic = tx_busy_traffic;
 	rtlpriv->link_info.higher_busyrxtraffic = higher_busyrxtraffic;
 
+	rtlpriv->stats.txbytesunicast_inperiod =
+		rtlpriv->stats.txbytesunicast -
+		rtlpriv->stats.txbytesunicast_last;
+	rtlpriv->stats.rxbytesunicast_inperiod =
+		rtlpriv->stats.rxbytesunicast -
+		rtlpriv->stats.rxbytesunicast_last;
+	rtlpriv->stats.txbytesunicast_last = rtlpriv->stats.txbytesunicast;
+	rtlpriv->stats.rxbytesunicast_last = rtlpriv->stats.rxbytesunicast;
+
+	rtlpriv->stats.txbytesunicast_inperiod_tp =
+		(u32)(rtlpriv->stats.txbytesunicast_inperiod * 8 / 2 /
+		1024 / 1024);
+	rtlpriv->stats.rxbytesunicast_inperiod_tp =
+		(u32)(rtlpriv->stats.rxbytesunicast_inperiod * 8 / 2 /
+		1024 / 1024);
+
 	/* <3> DM */
 	if (!rtlpriv->cfg->mod_params->disable_watchdog)
 		rtlpriv->cfg->ops->dm_watchdog(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 809648d28f52..ceeca79acc56 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1013,10 +1013,17 @@ struct init_gain {
 };
 
 struct wireless_stats {
-	unsigned long txbytesunicast;
-	unsigned long txbytesmulticast;
-	unsigned long txbytesbroadcast;
-	unsigned long rxbytesunicast;
+	u64 txbytesunicast;
+	u64 txbytesmulticast;
+	u64 txbytesbroadcast;
+	u64 rxbytesunicast;
+
+	u64 txbytesunicast_inperiod;
+	u64 rxbytesunicast_inperiod;
+	u32 txbytesunicast_inperiod_tp;
+	u32 rxbytesunicast_inperiod_tp;
+	u64 txbytesunicast_last;
+	u64 rxbytesunicast_last;
 
 	long rx_snr_db[4];
 	/*Correct smoothed ss in Dbm, only used
-- 
2.13.5
