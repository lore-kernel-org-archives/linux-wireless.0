Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34124 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbFFK5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 06:57:25 -0400
Received: by pdbki1 with SMTP id ki1so69368003pdb.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jun 2015 03:57:24 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2 1/3] rtlwifi: rtl8192cu: remove duplicated routine in _rtl92c_phy_rf6052_config_parafile
Date: Sat,  6 Jun 2015 19:57:14 +0900
Message-Id: <1433588234-27248-1-git-send-email-ap420073@gmail.com> (sfid-20150606_125731_410987_591A7BD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in the _rtl92c_phy_rf6052_config_parafile(), cases
RF90_PATH_A and RF90_PATH_B call the same routine.
so i remove one of these routine. also the return
routine is duplicated. so i remove it.

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

