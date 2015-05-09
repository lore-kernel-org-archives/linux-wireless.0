Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33740 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbbEIJRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 05:17:34 -0400
Received: by pdbnk13 with SMTP id nk13so107167564pdb.0
        for <linux-wireless@vger.kernel.org>; Sat, 09 May 2015 02:17:34 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, kvalo@codeaurora.org
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] rtlwifi: rtl8192cu: Remove rtl92c_init_beacon_max_error's parameter
Date: Sat,  9 May 2015 18:16:51 +0900
Message-Id: <1431163011-5212-1-git-send-email-ap420073@gmail.com> (sfid-20150509_111737_203037_879FD563)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

parameter "infra_mode" of rtl92c_init_beacon_max_error() is not used.
so i remove this.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 3c1639b..1898596 100644
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

