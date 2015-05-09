Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33864 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbEIJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 05:16:11 -0400
Received: by pacyx8 with SMTP id yx8so69446222pac.1
        for <linux-wireless@vger.kernel.org>; Sat, 09 May 2015 02:16:10 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, kvalo@codeaurora.org
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] rtlwifi: rtl8192cu: Remove setting REG_BCN_MAX_ERR code in _rtl92cu_set_media_status().
Date: Sat,  9 May 2015 18:15:23 +0900
Message-Id: <1431162923-5037-1-git-send-email-ap420073@gmail.com> (sfid-20150509_111614_886841_31D39973)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialization routine set REG_BCN_MAX_ERR to 0xFF.
also _rtl92cu_set_media_status set REG_BCN_MAX_ERR to same value.
so i remove this code.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index d310d55..3c1639b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1323,7 +1323,6 @@ static int _rtl92cu_set_media_status(struct ieee80211_hw *hw,
 	enum led_ctl_mode ledaction = LED_CTL_NO_LINK;
 
 	bt_msr &= 0xfc;
-	rtl_write_byte(rtlpriv, REG_BCN_MAX_ERR, 0xFF);
 	if (type == NL80211_IFTYPE_UNSPECIFIED || type ==
 	    NL80211_IFTYPE_STATION) {
 		_rtl92cu_stop_tx_beacon(hw);
-- 
2.1.0

