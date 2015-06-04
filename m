Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36503 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbFDAsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 20:48:24 -0400
Received: by pdjm12 with SMTP id m12so18510168pdj.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 17:48:23 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Fix performance issue.
Date: Thu,  4 Jun 2015 09:47:42 +0900
Message-Id: <1433378862-2064-1-git-send-email-ap420073@gmail.com> (sfid-20150604_024905_662054_25AB2F15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After physical reconnect, the rtl8192cu chipset shows low
transmission rates.It cause is that variable "iqk_initialized"
do not de-initialized. So I add this code.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 1898596..6a4ef05 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -987,7 +987,6 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	int err = 0;
-	static bool iqk_initialized;
 	unsigned long flags;
 
 	/* As this function can take a very long time (up to 350 ms)
@@ -1038,11 +1037,11 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 	if (ppsc->rfpwr_state == ERFON) {
 		rtl92c_phy_set_rfpath_switch(hw, 1);
-		if (iqk_initialized) {
+		if (rtlphy->iqk_initialized) {
 			rtl92c_phy_iq_calibrate(hw, true);
 		} else {
 			rtl92c_phy_iq_calibrate(hw, false);
-			iqk_initialized = true;
+			rtlphy->iqk_initialized = true;
 		}
 		rtl92c_dm_check_txpower_tracking(hw);
 		rtl92c_phy_lc_calibrate(hw);
@@ -1391,6 +1390,9 @@ void rtl92cu_card_disable(struct ieee80211_hw *hw)
 		_CardDisableHWSM(hw);
 	else
 		_CardDisableWithoutHWSM(hw);
+
+	/* after power off we should do iqk again */
+	rtlpriv->phy.iqk_initialized = false;
 }
 
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
-- 
2.1.4

