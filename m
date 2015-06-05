Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33967 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422727AbbFEOBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 10:01:47 -0400
Received: by payr10 with SMTP id r10so51499775pay.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 07:01:47 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] rtlwifi: rtl8192cu: remove duplicated routine in _rtl92c_phy_rf6052_config_parafile
Date: Fri,  5 Jun 2015 23:01:36 +0900
Message-Id: <1433512898-30137-1-git-send-email-ap420073@gmail.com> (sfid-20150605_160159_882096_64234633)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in the _rtl92c_phy_rf6052_config_parafile(), RF90_PATH_A and
RF90_PATH_B are same routine. so i remove one of these routine.
also the return routine is duplicated. so i remove it.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index b878d56..8ce055c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -452,9 +452,6 @@ static bool _rtl92c_phy_rf6052_config_parafile(struct ieee80211_hw *hw)
 		udelay(1);
 		switch (rfpath) {
 		case RF90_PATH_A:
-			rtstatus = rtl92cu_phy_config_rf_with_headerfile(hw,
-					(enum radio_path) rfpath);
-			break;
 		case RF90_PATH_B:
 			rtstatus = rtl92cu_phy_config_rf_with_headerfile(hw,
 					(enum radio_path) rfpath);
@@ -483,7 +480,6 @@ static bool _rtl92c_phy_rf6052_config_parafile(struct ieee80211_hw *hw)
 		}
 	}
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "<---\n");
-	return rtstatus;
 phy_rf_cfg_fail:
 	return rtstatus;
 }
-- 
2.1.4

