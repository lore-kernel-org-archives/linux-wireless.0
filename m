Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34948 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbFDIoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 04:44:10 -0400
Received: by padjw17 with SMTP id jw17so25261892pad.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 01:44:10 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] rtlwifi: rtl8192cu: remove _InitBeaconParameters().
Date: Thu,  4 Jun 2015 17:43:36 +0900
Message-Id: <1433407416-752-3-git-send-email-ap420073@gmail.com> (sfid-20150604_104414_326292_559ED05C)
In-Reply-To: <1433407416-752-1-git-send-email-ap420073@gmail.com>
References: <1433407416-752-1-git-send-email-ap420073@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

_InitBeaconParameters() and rtl92cu_init_beacon_parameters() is
same routine. I remove both functions. then i add
_rtl92cu_init_beacon_parameters() in the hw.c.
_rtl92cu_init_beacon_parameters() is same routine with
_InitBeaconParameters().

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 43 ++++++++++++++--------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 15 ----------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |  3 --
 3 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 1898596..8a54468 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -840,6 +840,26 @@ static void _rtl92cu_init_wmac_setting(struct ieee80211_hw *hw)
 	rtl92c_set_data_filter(hw, value16);
 }
 
+static void _rtl92cu_init_beacon_parameters(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+
+	rtl_write_word(rtlpriv, REG_BCN_CTRL, 0x1010);
+
+	/* TODO: Remove these magic number */
+	rtl_write_word(rtlpriv, REG_TBTT_PROHIBIT, 0x6404);
+	rtl_write_byte(rtlpriv, REG_DRVERLYINT, DRIVER_EARLY_INT_TIME);
+	rtl_write_byte(rtlpriv, REG_BCNDMATIM, BCN_DMA_ATIME_INT_TIME);
+	/* Change beacon AIFS to the largest number
+	 * beacause test chip does not contension before sending beacon.
+	 */
+	if (IS_NORMAL_CHIP(rtlhal->version))
+		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x660F);
+	else
+		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x66FF);
+}
+
 static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -887,7 +907,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 	_rtl92cu_init_usb_aggregation(hw);
 	rtlpriv->cfg->ops->set_bw_mode(hw, NL80211_CHAN_HT20);
 	rtl92c_set_min_space(hw, IS_92C_SERIAL(rtlhal->version));
-	rtl92c_init_beacon_parameters(hw, rtlhal->version);
+	_rtl92cu_init_beacon_parameters(hw);
 	rtl92c_init_ampdu_aggregation(hw);
 	rtl92c_init_beacon_max_error(hw);
 	return err;
@@ -1451,25 +1471,6 @@ int rtl92cu_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 	return 0;
 }
 
-static void _InitBeaconParameters(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-
-	rtl_write_word(rtlpriv, REG_BCN_CTRL, 0x1010);
-
-	/* TODO: Remove these magic number */
-	rtl_write_word(rtlpriv, REG_TBTT_PROHIBIT, 0x6404);
-	rtl_write_byte(rtlpriv, REG_DRVERLYINT, DRIVER_EARLY_INT_TIME);
-	rtl_write_byte(rtlpriv, REG_BCNDMATIM, BCN_DMA_ATIME_INT_TIME);
-	/* Change beacon AIFS to the largest number
-	 * beacause test chip does not contension before sending beacon. */
-	if (IS_NORMAL_CHIP(rtlhal->version))
-		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x660F);
-	else
-		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x66FF);
-}
-
 static void _beacon_function_enable(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1490,7 +1491,7 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
 	atim_window = 2;	/*FIX MERGE */
 	rtl_write_word(rtlpriv, REG_ATIMWND, atim_window);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
-	_InitBeaconParameters(hw);
+	_rtl92cu_init_beacon_parameters(hw);
 	rtl_write_byte(rtlpriv, REG_SLOT, 0x09);
 	/*
 	 * Force beacon frame transmission even after receiving beacon frame
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index f3db6bc..490a7cf 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -641,21 +641,6 @@ void rtl92c_init_retry_function(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_ACKTO, 0x40);
 }
 
-void rtl92c_init_beacon_parameters(struct ieee80211_hw *hw,
-				   enum version_8192c version)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-
-	rtl_write_word(rtlpriv, REG_TBTT_PROHIBIT, 0x6404);/* ms */
-	rtl_write_byte(rtlpriv, REG_DRVERLYINT, DRIVER_EARLY_INT_TIME);/*ms*/
-	rtl_write_byte(rtlpriv, REG_BCNDMATIM, BCN_DMA_ATIME_INT_TIME);
-	if (IS_NORMAL_CHIP(rtlhal->version))
-		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x660F);
-	else
-		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x66FF);
-}
-
 void rtl92c_disable_fast_edca(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index 58548e8..e34f0f1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -70,9 +70,6 @@ void rtl92c_init_beacon_max_error(struct ieee80211_hw *hw);
 void rtl92c_init_rdg_setting(struct ieee80211_hw *hw);
 void rtl92c_init_retry_function(struct ieee80211_hw *hw);
 
-void rtl92c_init_beacon_parameters(struct ieee80211_hw *hw,
-				   enum version_8192c version);
-
 void rtl92c_disable_fast_edca(struct ieee80211_hw *hw);
 void rtl92c_set_min_space(struct ieee80211_hw *hw, bool is2T);
 
-- 
2.1.4

