Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:35959 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbcBKQxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 11:53:32 -0500
Received: by mail-ob0-f195.google.com with SMTP id wg8so6134346obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2016 08:53:32 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/4] rtlwifi: rtl8821ae: Convert driver to use common 5G channel table
Date: Thu, 11 Feb 2016 10:53:12 -0600
Message-Id: <1455209592-12882-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160211_175340_624273_16F64ED5)
In-Reply-To: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several copies of the 5G channel tables in this driver. These
are removed so that the tables in the core will be used. This change
also removes a useless message of "Channel 163 in Group not found".

The number of possible 5G channels was reduced from 54 to a better
value of 49 during the conversion.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

This material is for kernel 4.6.

Larry

 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    | 18 ---------------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 27 +++++-----------------
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  2 +-
 3 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index bbb789f..5da9bd0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -2786,14 +2786,6 @@ static void _rtl8812ae_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct txpower_info_2g pwrinfo24g;
 	struct txpower_info_5g pwrinfo5g;
-	u8 channel5g[CHANNEL_MAX_NUMBER_5G] = {
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54,
-		56, 58, 60, 62, 64, 100, 102, 104, 106,
-		108, 110, 112, 114, 116, 118, 120, 122,
-		124, 126, 128, 130, 132, 134, 136, 138,
-		140, 142, 144, 149, 151, 153, 155, 157,
-		159, 161, 163, 165, 167, 168, 169, 171, 173, 175, 177};
-	u8 channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {42, 58, 106, 122, 138, 155, 171};
 	u8 rf_path, index;
 	u8 i;
 
@@ -2872,16 +2864,6 @@ static void _rtl8821ae_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct txpower_info_2g pwrinfo24g;
 	struct txpower_info_5g pwrinfo5g;
-	u8 channel5g[CHANNEL_MAX_NUMBER_5G] = {
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54,
-		56, 58, 60, 62, 64, 100, 102, 104, 106,
-		108, 110, 112, 114, 116, 118, 120, 122,
-		124, 126, 128, 130, 132, 134, 136, 138,
-		140, 142, 144, 149, 151, 153, 155, 157,
-		159, 161, 163, 165, 167, 168, 169, 171,
-		173, 175, 177};
-	u8 channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {
-		42, 58, 106, 122, 138, 155, 171};
 	u8 rf_path, index;
 	u8 i;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 9b4d8a6..74165b3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1472,18 +1472,13 @@ static char _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	char channel_index = -1;
-	u8 channel_5g[CHANNEL_MAX_NUMBER_5G] = {
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64,
-		100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122,
-		124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 149,
-		151, 153, 155, 157, 159, 161, 163, 165, 167, 168, 169, 171,
-		173, 175, 177};
 	u8  i = 0;
+
 	if (band == BAND_ON_2_4G)
 		channel_index = channel - 1;
 	else if (band == BAND_ON_5G) {
-		for (i = 0; i < sizeof(channel_5g)/sizeof(u8); ++i) {
-			if (channel_5g[i] == channel)
+		for (i = 0; i < sizeof(channel5g)/sizeof(u8); ++i) {
+			if (channel5g[i] == channel)
 				channel_index = i;
 		}
 	} else
@@ -2240,13 +2235,6 @@ void rtl8821ae_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel)
 
 static bool _rtl8821ae_phy_get_chnl_index(u8 channel, u8 *chnl_index)
 {
-	u8 channel_5g[CHANNEL_MAX_NUMBER_5G] = {
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62,
-		64, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118,
-		120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140,
-		142, 144, 149, 151, 153, 155, 157, 159, 161, 163, 165,
-		167, 168, 169, 171, 173, 175, 177
-	};
 	u8 i = 0;
 	bool in_24g = true;
 
@@ -2257,7 +2245,7 @@ static bool _rtl8821ae_phy_get_chnl_index(u8 channel, u8 *chnl_index)
 		in_24g = false;
 
 		for (i = 0; i < CHANNEL_MAX_NUMBER_5G; ++i) {
-			if (channel_5g[i] == channel) {
+			if (channel5g[i] == channel) {
 				*chnl_index = i;
 				return in_24g;
 			}
@@ -2728,13 +2716,10 @@ static u8 _rtl8821ae_get_txpower_index(struct ieee80211_hw *hw, u8 path,
 			     rate <= DESC_RATEVHT2SS_MCS9))
 				txpower += rtlefuse->txpwr_5g_bw40diff[path][TX_2S];
 		} else if (bandwidth == HT_CHANNEL_WIDTH_80) {
-			u8 channel_5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {
-				42, 58, 106, 122, 138, 155, 171
-			};
 			u8 i;
 
-			for (i = 0; i < sizeof(channel_5g_80m) / sizeof(u8); ++i)
-				if (channel_5g_80m[i] == channel)
+			for (i = 0; i < sizeof(channel5g_80m) / sizeof(u8); ++i)
+				if (channel5g_80m[i] == channel)
 					index = i;
 
 			if ((DESC_RATEMCS0 <= rate && rate <= DESC_RATEMCS15) ||
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index e603819..9e3cdd7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -116,7 +116,7 @@
 
 #define CHANNEL_MAX_NUMBER	(14 + 24 + 21)	/* 14 is the max channel no */
 #define CHANNEL_MAX_NUMBER_2G		14
-#define CHANNEL_MAX_NUMBER_5G		54 /* Please refer to
+#define CHANNEL_MAX_NUMBER_5G		49 /* Please refer to
 					    *"phy_GetChnlGroup8812A" and
 					    * "Hal_ReadTxPowerInfo8812A"
 					    */
-- 
2.1.4

