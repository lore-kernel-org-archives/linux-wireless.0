Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:54660 "EHLO plaes.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751734AbbCVNgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 09:36:05 -0400
From: Priit Laes <plaes@plaes.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Joe Perches <joe@perches.com>, Priit Laes <plaes@plaes.org>
Subject: [PATCH v2 1/4] rtlwifi: Use common rtl_evm_db_to_percentage
Date: Sun, 22 Mar 2015 15:35:17 +0200
Message-Id: <1427031320-10913-2-git-send-email-plaes@plaes.org> (sfid-20150322_143627_488702_997582DC)
In-Reply-To: <1427031320-10913-1-git-send-email-plaes@plaes.org>
References: <1427031320-10913-1-git-send-email-plaes@plaes.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c | 22 +---------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 18 +-----------------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c | 17 +----------------
 3 files changed, 3 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 84ddd4d..f6cf05e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -59,26 +59,6 @@ static u8 _rtl92c_query_rxpwrpercentage(char antpower)
 		return 100 + antpower;
 }
 
-static u8 _rtl92c_evm_db_to_percentage(char value)
-{
-	char ret_val;
-	ret_val = value;
-
-	if (ret_val >= 0)
-		ret_val = 0;
-
-	if (ret_val <= -33)
-		ret_val = -33;
-
-	ret_val = 0 - ret_val;
-	ret_val *= 3;
-
-	if (ret_val == 99)
-		ret_val = 100;
-
-	return ret_val;
-}
-
 static long _rtl92ce_signal_scale_mapping(struct ieee80211_hw *hw,
 		long currsig)
 {
@@ -264,7 +244,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 			max_spatial_stream = 1;
 
 		for (i = 0; i < max_spatial_stream; i++) {
-			evm = _rtl92c_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+			evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 
 			if (packet_match_bssid) {
 				/* Fill value in RFD, Get the first
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 133e395..40e5a84 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -724,22 +724,6 @@ static u8 _rtl92c_query_rxpwrpercentage(char antpower)
 		return 100 + antpower;
 }
 
-static u8 _rtl92c_evm_db_to_percentage(char value)
-{
-	char ret_val;
-
-	ret_val = value;
-	if (ret_val >= 0)
-		ret_val = 0;
-	if (ret_val <= -33)
-		ret_val = -33;
-	ret_val = 0 - ret_val;
-	ret_val *= 3;
-	if (ret_val == 99)
-		ret_val = 100;
-	return ret_val;
-}
-
 static long _rtl92c_signal_scale_mapping(struct ieee80211_hw *hw,
 		long currsig)
 {
@@ -886,7 +870,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 		else
 			max_spatial_stream = 1;
 		for (i = 0; i < max_spatial_stream; i++) {
-			evm = _rtl92c_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+			evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 			if (packet_match_bssid) {
 				if (i == 0)
 					pstats->signalquality =
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 1feaa62..7a621f9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -58,21 +58,6 @@ static u8 _rtl92d_query_rxpwrpercentage(char antpower)
 		return 100 + antpower;
 }
 
-static u8 _rtl92d_evm_db_to_percentage(char value)
-{
-	char ret_val = value;
-
-	if (ret_val >= 0)
-		ret_val = 0;
-	if (ret_val <= -33)
-		ret_val = -33;
-	ret_val = 0 - ret_val;
-	ret_val *= 3;
-	if (ret_val == 99)
-		ret_val = 100;
-	return ret_val;
-}
-
 static long _rtl92de_translate_todbm(struct ieee80211_hw *hw,
 				     u8 signal_strength_index)
 {
@@ -241,7 +226,7 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 		else
 			max_spatial_stream = 1;
 		for (i = 0; i < max_spatial_stream; i++) {
-			evm = _rtl92d_evm_db_to_percentage(p_drvinfo->rxevm[i]);
+			evm = rtl_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 			if (packet_match_bssid) {
 				if (i == 0)
 					pstats->signalquality =
-- 
2.3.3

