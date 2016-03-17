Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:35962 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031499AbcCQSlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:20 -0400
Received: by mail-ob0-f194.google.com with SMTP id cf7so6685341obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 6/9] rtlwifi: rtl8192se: Fix Smatch warning
Date: Thu, 17 Mar 2016 13:41:01 -0500
Message-Id: <1458240064-31422-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194127_612889_078D4C71)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch lists the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c:648 rtl92s_phy_set_rf_power_state() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index 4b4612f..82d6375 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -645,7 +645,7 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				 rtlpriv->psc.state_inap);
 			ppsc->last_sleep_jiffies = jiffies;
 			_rtl92se_phy_set_rf_sleep(hw);
-	    break;
+			break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case not processed\n");
-- 
2.1.4

