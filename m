Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34401 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbcBKQ41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 11:56:27 -0500
Received: by mail-ob0-f180.google.com with SMTP id wb13so83150794obb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2016 08:56:27 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: rtl8821ae: Silence useless log output
Date: Thu, 11 Feb 2016 10:56:22 -0600
Message-Id: <1455209782-12985-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160211_175633_387939_6C5229D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When driver rtl8821ae is loaded but not connected to any AP, it logs
a "firmware not ready to run" message roughly once a minute. To
eliminate logging this massage under normal debug conditions, the
degug level needed to print this message is increased.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

This patch is intended for kernel 4.6.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 525eb23..a4fc70e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -271,7 +271,7 @@ int rtl8821ae_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 
 	err = _rtl8821ae_fw_free_to_go(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 			 "Firmware is not ready to run!\n");
 	} else {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
-- 
2.1.4

