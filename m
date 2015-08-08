Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36355 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992459AbbHHQxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 12:53:48 -0400
Received: by oiev193 with SMTP id v193so39427621oie.3
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2015 09:53:48 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, timlee <timlee@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V3 NEXT 1/7] rtlwifi: rtl8821ae: Remove unsupported 5G channels
Date: Sat,  8 Aug 2015 11:53:33 -0500
Message-Id: <1439052819-30196-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150808_185353_981633_1E9D4AFF)
In-Reply-To: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: timlee <timlee@realtek.com>

The 5G channel list contains channels that are not supported. Previously
there were two copies of the 5G channel arrays, one in hw.c and one in
phy.c. These have been renamed to prevent namespace pollution, and made
global. Now any further changes will only need to be in a single location.

Signed-off-by: timlee <timlee@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - unchanged
V3 - One such channel list was missed in V1. In addition, the 5G channel
     arrays are renames, made global, and combined so that only a
     single copy is needed.
---
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c  | 25 +++++++++++++------------
 drivers/net/wireless/rtlwifi/rtl8821ae/phy.c | 22 +++++++---------------
 drivers/net/wireless/rtlwifi/rtl8821ae/phy.h |  3 +++
 3 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
index b7f18e21..54ab4fd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
@@ -43,6 +43,17 @@
 
 #define LLT_CONFIG	5
 
+u8 rtl_channel5g[CHANNEL_MAX_NUMBER_5G] = {
+	36, 38, 40, 42, 44, 46, 48,		/* Band 1 */
+	52, 54, 56, 58, 60, 62, 64,		/* Band 2 */
+	100, 102, 104, 106, 108, 110, 112,	/* Band 3 */
+	116, 118, 120, 122, 124, 126, 128,	/* Band 3 */
+	132, 134, 136, 138, 140, 142, 144,	/* Band 3 */
+	149, 151, 153, 155, 157, 159, 161,	/* Band 4 */
+	165, 167, 169, 171, 173, 175, 177};	/* Band 4 */
+u8 rtl_channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {
+	42, 58, 106, 122, 138, 155, 171};
+
 static void _rtl8821ae_return_beacon_queue_skb(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -2855,16 +2866,6 @@ static void _rtl8821ae_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
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
 
@@ -2889,13 +2890,13 @@ static void _rtl8821ae_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 		}
 
 		for (i = 0; i < CHANNEL_MAX_NUMBER_5G; i++) {
-			index = _rtl8821ae_get_chnl_group(channel5g[i]);
+			index = _rtl8821ae_get_chnl_group(rtl_channel5g[i]);
 			rtlefuse->txpwr_5g_bw40base[rf_path][i] =
 				pwrinfo5g.index_bw40_base[rf_path][index];
 		}
 		for (i = 0; i < CHANNEL_MAX_NUMBER_5G_80M; i++) {
 			u8 upper, lower;
-			index = _rtl8821ae_get_chnl_group(channel5g_80m[i]);
+			index = _rtl8821ae_get_chnl_group(rtl_channel5g_80m[i]);
 			upper = pwrinfo5g.index_bw40_base[rf_path][index];
 			lower = pwrinfo5g.index_bw40_base[rf_path][index + 1];
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/rtlwifi/rtl8821ae/phy.c
index 9b4d8a6..b4ad455 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/phy.c
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
+		for (i = 0; i < sizeof(rtl_channel5g)/sizeof(u8); ++i) {
+			if (rtl_channel5g[i] == channel)
 				channel_index = i;
 		}
 	} else
@@ -2240,7 +2235,7 @@ void rtl8821ae_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel)
 
 static bool _rtl8821ae_phy_get_chnl_index(u8 channel, u8 *chnl_index)
 {
-	u8 channel_5g[CHANNEL_MAX_NUMBER_5G] = {
+	u8 rtl_channel5g[CHANNEL_MAX_NUMBER_5G] = {
 		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62,
 		64, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118,
 		120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140,
@@ -2257,7 +2252,7 @@ static bool _rtl8821ae_phy_get_chnl_index(u8 channel, u8 *chnl_index)
 		in_24g = false;
 
 		for (i = 0; i < CHANNEL_MAX_NUMBER_5G; ++i) {
-			if (channel_5g[i] == channel) {
+			if (rtl_channel5g[i] == channel) {
 				*chnl_index = i;
 				return in_24g;
 			}
@@ -2728,13 +2723,10 @@ static u8 _rtl8821ae_get_txpower_index(struct ieee80211_hw *hw, u8 path,
 			     rate <= DESC_RATEVHT2SS_MCS9))
 				txpower += rtlefuse->txpwr_5g_bw40diff[path][TX_2S];
 		} else if (bandwidth == HT_CHANNEL_WIDTH_80) {
-			u8 channel_5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {
-				42, 58, 106, 122, 138, 155, 171
-			};
 			u8 i;
 
-			for (i = 0; i < sizeof(channel_5g_80m) / sizeof(u8); ++i)
-				if (channel_5g_80m[i] == channel)
+			for (i = 0; i < sizeof(rtl_channel5g_80m) / sizeof(u8); ++i)
+				if (rtl_channel5g_80m[i] == channel)
 					index = i;
 
 			if ((DESC_RATEMCS0 <= rate && rate <= DESC_RATEMCS15) ||
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/phy.h b/drivers/net/wireless/rtlwifi/rtl8821ae/phy.h
index c411f0a..d4f53ea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/phy.h
@@ -205,6 +205,9 @@ enum _ANT_DIV_TYPE {
 
 };
 
+extern u8 rtl_channel5g[CHANNEL_MAX_NUMBER_5G];
+extern u8 rtl_channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M];
+
 u32 rtl8821ae_phy_query_bb_reg(struct ieee80211_hw *hw,
 			       u32 regaddr, u32 bitmask);
 void rtl8821ae_phy_set_bb_reg(struct ieee80211_hw *hw,
-- 
2.1.4

