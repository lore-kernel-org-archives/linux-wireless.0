Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34282 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdAJQPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 11:15:32 -0500
Received: by mail-oi0-f67.google.com with SMTP id 3so70343598oih.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 08:15:32 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: rtl8192de: Remove a pointless goto
Date: Tue, 10 Jan 2017 10:15:26 -0600
Message-Id: <20170110161526.22255-1-Larry.Finger@lwfinger.net> (sfid-20170110_171538_747406_F4CA374A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit c93ac39da0064 ("rtlwifi: Remove some redundant code), a goto
statement was inadvertently left in the code.

Fixes: c93ac39da0064 ("rtlwifi: Remove some redundant code)
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index 8931bcd..88faeab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -271,7 +271,6 @@ int rtl92d_download_fw(struct ieee80211_hw *hw)
 	spin_unlock_irqrestore(&globalmutex_for_fwdownload, flags);
 	if (err)
 		pr_err("fw is not ready to run!\n");
-		goto exit;
 exit:
 	err = _rtl92d_fw_init(hw);
 	return err;
-- 
2.10.2
