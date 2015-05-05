Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33756 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993489AbbEEP7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 11:59:55 -0400
Received: by pacwv17 with SMTP id wv17so197630789pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2015 08:59:54 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Modify REG_BCN_MAX_ERR related code.
Date: Wed,  6 May 2015 00:58:38 +0900
Message-Id: <1430841518-3932-1-git-send-email-ap420073@gmail.com> (sfid-20150505_194340_679475_231C5669)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1. Remove setting REG_BCN_MAX_ERR code in _rtl92cu_set_media_status().
Initialization routine set REG_BCN_MAX_ERR to 0xFF.
also _rtl92cu_set_media_status set REG_BCN_MAX_ERR to same value.
so i remove this code.

2. Remove rtl92c_init_beacon_max_error's parameter.
because parameter "infra_mode" is not used.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 3 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index d310d55..1898596 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -889,7 +889,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 	rtl92c_set_min_space(hw, IS_92C_SERIAL(rtlhal->version));
 	rtl92c_init_beacon_parameters(hw, rtlhal->version);
 	rtl92c_init_ampdu_aggregation(hw);
-	rtl92c_init_beacon_max_error(hw, true);
+	rtl92c_init_beacon_max_error(hw);
 	return err;
 }
 
@@ -1323,7 +1323,6 @@ static int _rtl92cu_set_media_status(struct ieee80211_hw *hw,
 	enum led_ctl_mode ledaction = LED_CTL_NO_LINK;
 
 	bt_msr &= 0xfc;
-	rtl_write_byte(rtlpriv, REG_BCN_MAX_ERR, 0xFF);
 	if (type == NL80211_IFTYPE_UNSPECIFIED || type ==
 	    NL80211_IFTYPE_STATION) {
 		_rtl92cu_stop_tx_beacon(hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index adb8107..f3db6bc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -613,7 +613,7 @@ void rtl92c_init_ampdu_aggregation(struct ieee80211_hw *hw)
 	rtl_write_word(rtlpriv, 0x4CA, 0x0708);
 }
 
-void rtl92c_init_beacon_max_error(struct ieee80211_hw *hw, bool infra_mode)
+void rtl92c_init_beacon_max_error(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index bf53652..58548e8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -66,7 +66,7 @@ void rtl92c_init_edca_param(struct ieee80211_hw *hw,
 
 void rtl92c_init_edca(struct ieee80211_hw *hw);
 void rtl92c_init_ampdu_aggregation(struct ieee80211_hw *hw);
-void rtl92c_init_beacon_max_error(struct ieee80211_hw *hw, bool infra_mode);
+void rtl92c_init_beacon_max_error(struct ieee80211_hw *hw);
 void rtl92c_init_rdg_setting(struct ieee80211_hw *hw);
 void rtl92c_init_retry_function(struct ieee80211_hw *hw);
 
-- 
2.1.0

