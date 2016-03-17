Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:33410 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031512AbcCQSlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:21 -0400
Received: by mail-ob0-f196.google.com with SMTP id z10so5779647obg.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/9] rtlwifi: rtl8723ae: Fix Smatch warning
Date: Thu, 17 Mar 2016 13:41:02 -0500
Message-Id: <1458240064-31422-8-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194129_443756_E7FE894E)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c:137 rtl8723e_dm_bt_need_to_dec_bt_pwr() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
index 00a0531..44de695 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
@@ -134,9 +134,9 @@ static bool rtl8723e_dm_bt_need_to_dec_bt_pwr(struct ieee80211_hw *hw)
 	if (mgnt_link_status_query(hw) == RT_MEDIA_CONNECT) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
 			"Need to decrease bt power\n");
-			rtlpriv->btcoexist.cstate |=
-			BT_COEX_STATE_DEC_BT_POWER;
-			return true;
+		rtlpriv->btcoexist.cstate |=
+		BT_COEX_STATE_DEC_BT_POWER;
+		return true;
 	}
 
 	rtlpriv->btcoexist.cstate &= ~BT_COEX_STATE_DEC_BT_POWER;
-- 
2.1.4

