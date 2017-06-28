Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35681 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdF1H5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 03:57:16 -0400
Received: by mail-pf0-f196.google.com with SMTP id s66so8014854pfs.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jun 2017 00:57:16 -0700 (PDT)
Date: Wed, 28 Jun 2017 13:27:11 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: remove dummy function call
Message-ID: <20170628075711.GA8101@symbol-HP-ZBook-15> (sfid-20170628_095720_185162_BE26248E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

_rtl92cu_init_usb_aggregation() can be removed as it is dummy one

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 107c34e..ef8bd71 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -777,10 +777,6 @@ static void _rtl92cu_init_queue_priority(struct ieee80211_hw *hw,
 						   queue_sel);
 }

-static void _rtl92cu_init_usb_aggregation(struct ieee80211_hw *hw)
-{
-}
-
 static void _rtl92cu_init_wmac_setting(struct ieee80211_hw *hw)
 {
 	u16 value16;
@@ -863,7 +859,6 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 	rtl92c_init_edca(hw);
 	rtl92c_init_rate_fallback(hw);
 	rtl92c_init_retry_function(hw);
-	_rtl92cu_init_usb_aggregation(hw);
 	rtlpriv->cfg->ops->set_bw_mode(hw, NL80211_CHAN_HT20);
 	rtl92c_set_min_space(hw, IS_92C_SERIAL(rtlhal->version));
 	_rtl92cu_init_beacon_parameters(hw);
--
1.9.1
