Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33603 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdFVLRA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 07:17:00 -0400
Received: by mail-pg0-f67.google.com with SMTP id u62so2022791pgb.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 04:16:59 -0700 (PDT)
Date: Thu, 22 Jun 2017 16:46:55 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Remove unnecessary conditions
Message-ID: <20170622111655.GA4891@symbol-HP-ZBook-15> (sfid-20170622_131709_847990_F548BEDD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As wmm_enable is initialized to false, hence the else condition never
execute and boundary is assigned with TX_PAGE_BOUNDARY. So the if-else
condition can be removed and boundary will be assigned with TX_PAGE_BOUNDARY.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index f95a645..e9c5f6a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -845,13 +845,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 		pr_err("Failed to init power on!\n");
 		return err;
 	}
-	if (!wmm_enable) {
 		boundary = TX_PAGE_BOUNDARY;
-	} else { /* for WMM */
-		boundary = (IS_NORMAL_CHIP(rtlhal->version))
-					? WMM_CHIP_B_TX_PAGE_BOUNDARY
-					: WMM_CHIP_A_TX_PAGE_BOUNDARY;
-	}
 	if (false == rtl92c_init_llt_table(hw, boundary)) {
 		pr_err("Failed to init LLT Table!\n");
 		return -EINVAL;
--
1.9.1
