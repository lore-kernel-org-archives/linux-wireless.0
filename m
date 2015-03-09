Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41211 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbCIPHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 11:07:19 -0400
Received: by pdjy10 with SMTP id y10so25745792pdj.8
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 08:07:19 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Remove unnecessary parameter
Date: Tue, 10 Mar 2015 00:07:08 +0900
Message-Id: <1425913628-6415-1-git-send-email-ap420073@gmail.com> (sfid-20150309_160724_047995_1A8B648C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary parameter in rtl8192cu/hw.c

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 0c20dd7..43b2b20 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1471,8 +1471,7 @@ static void _InitBeaconParameters(struct ieee80211_hw *hw)
 		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x66FF);
 }
 
-static void _beacon_function_enable(struct ieee80211_hw *hw, bool Enable,
-				    bool Linked)
+static void _beacon_function_enable(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -1517,7 +1516,7 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_CCK, 0x50);
 		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_OFDM, 0x50);
 	}
-	_beacon_function_enable(hw, true, true);
+	_beacon_function_enable(hw);
 }
 
 void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw)
-- 
1.9.1

