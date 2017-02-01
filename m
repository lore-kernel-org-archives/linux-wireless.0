Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34919 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdBAVJU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 16:09:20 -0500
Received: by mail-ot0-f194.google.com with SMTP id 65so46779270otq.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 13:09:19 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/7] rtlwifi: rtl8821ae: Fix typo in symbol for bandwidth numbers
Date: Wed,  1 Feb 2017 15:08:51 -0600
Message-Id: <20170201210857.26516-2-Larry.Finger@lwfinger.net> (sfid-20170201_220926_440632_B0C0578E)
In-Reply-To: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
References: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In several places, "BANDWITH" is used when "BANDWIDTH" should have been
used.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 10 +++++-----
 drivers/net/wireless/realtek/rtlwifi/wifi.h          |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index c60f07a..8da874c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -988,7 +988,7 @@ static void _rtl8812ae_phy_cross_reference_ht_and_vht_txpower_limit(struct ieee8
 	s8 temp_pwrlmt = 0;
 
 	for (regulation = 0; regulation < MAX_REGULATION_NUM; ++regulation) {
-		for (bw = 0; bw < MAX_5G_BANDWITH_NUM; ++bw) {
+		for (bw = 0; bw < MAX_5G_BANDWIDTH_NUM; ++bw) {
 			for (channel = 0; channel < CHANNEL_MAX_NUMBER_5G; ++channel) {
 				for (rate_section = 0; rate_section < MAX_RATE_SECTION_NUM; ++rate_section) {
 					temp_pwrlmt = rtlphy->txpwr_limit_5g[regulation]
@@ -1163,7 +1163,7 @@ static void _rtl8812ae_phy_convert_txpower_limit_to_power_index(struct ieee80211
 	_rtl8812ae_phy_cross_reference_ht_and_vht_txpower_limit(hw);
 
 	for (regulation = 0; regulation < MAX_REGULATION_NUM; ++regulation) {
-		for (bw = 0; bw < MAX_2_4G_BANDWITH_NUM; ++bw) {
+		for (bw = 0; bw < MAX_2_4G_BANDWIDTH_NUM; ++bw) {
 			for (channel = 0; channel < CHANNEL_MAX_NUMBER_2G; ++channel) {
 				for (rate_section = 0; rate_section < MAX_RATE_SECTION_NUM; ++rate_section) {
 					/* obtain the base dBm values in 2.4G band
@@ -1219,7 +1219,7 @@ static void _rtl8812ae_phy_convert_txpower_limit_to_power_index(struct ieee80211
 		}
 	}
 	for (regulation = 0; regulation < MAX_REGULATION_NUM; ++regulation) {
-		for (bw = 0; bw < MAX_5G_BANDWITH_NUM; ++bw) {
+		for (bw = 0; bw < MAX_5G_BANDWIDTH_NUM; ++bw) {
 			for (channel = 0; channel < CHANNEL_MAX_NUMBER_5G; ++channel) {
 				for (rate_section = 0; rate_section < MAX_RATE_SECTION_NUM; ++rate_section) {
 					/* obtain the base dBm values in 5G band
@@ -1296,7 +1296,7 @@ static void _rtl8821ae_phy_init_txpower_limit(struct ieee80211_hw *hw)
 		 "=====> _rtl8821ae_phy_init_txpower_limit()!\n");
 
 	for (i = 0; i < MAX_REGULATION_NUM; ++i) {
-		for (j = 0; j < MAX_2_4G_BANDWITH_NUM; ++j)
+		for (j = 0; j < MAX_2_4G_BANDWIDTH_NUM; ++j)
 			for (k = 0; k < MAX_RATE_SECTION_NUM; ++k)
 				for (m = 0; m < CHANNEL_MAX_NUMBER_2G; ++m)
 					for (l = 0; l < MAX_RF_PATH_NUM; ++l)
@@ -1305,7 +1305,7 @@ static void _rtl8821ae_phy_init_txpower_limit(struct ieee80211_hw *hw)
 							= MAX_POWER_INDEX;
 	}
 	for (i = 0; i < MAX_REGULATION_NUM; ++i) {
-		for (j = 0; j < MAX_5G_BANDWITH_NUM; ++j)
+		for (j = 0; j < MAX_5G_BANDWIDTH_NUM; ++j)
 			for (k = 0; k < MAX_RATE_SECTION_NUM; ++k)
 				for (m = 0; m < CHANNEL_MAX_NUMBER_5G; ++m)
 					for (l = 0; l < MAX_RF_PATH_NUM; ++l)
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 1785100..826459f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -157,8 +157,8 @@ enum rtl8192c_h2c_cmd {
 #define MAX_REGULATION_NUM		4
 #define MAX_RF_PATH_NUM			4
 #define MAX_RATE_SECTION_NUM		6
-#define MAX_2_4G_BANDWITH_NUM		4
-#define MAX_5G_BANDWITH_NUM		4
+#define MAX_2_4G_BANDWIDTH_NUM		4
+#define MAX_5G_BANDWIDTH_NUM		4
 #define	MAX_RF_PATH			4
 #define	MAX_CHNL_GROUP_24G		6
 #define	MAX_CHNL_GROUP_5G		14
@@ -1265,12 +1265,12 @@ struct rtl_phy {
 	u8 cur_bw40_txpwridx;
 
 	s8 txpwr_limit_2_4g[MAX_REGULATION_NUM]
-			   [MAX_2_4G_BANDWITH_NUM]
+			   [MAX_2_4G_BANDWIDTH_NUM]
 			   [MAX_RATE_SECTION_NUM]
 			   [CHANNEL_MAX_NUMBER_2G]
 			   [MAX_RF_PATH_NUM];
 	s8 txpwr_limit_5g[MAX_REGULATION_NUM]
-			 [MAX_5G_BANDWITH_NUM]
+			 [MAX_5G_BANDWIDTH_NUM]
 			 [MAX_RATE_SECTION_NUM]
 			 [CHANNEL_MAX_NUMBER_5G]
 			 [MAX_RF_PATH_NUM];
-- 
2.10.2
