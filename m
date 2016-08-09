Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62324 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbcHITyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 15:54:44 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Cc: kvalo@codeaurora.org, arnd@arndb.de, joe@perches.com,
	linux-wireless@vger.kernel.org,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] rtlwifi: rtl8723ae: Fix leak in _rtl8723e_read_adapter_info()
Date: Tue,  9 Aug 2016 21:54:12 +0200
Message-Id: <1470772452-24642-1-git-send-email-cengelma@gmx.at> (sfid-20160809_215448_643041_9EC7E355)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of (rtlhal->oem_id != RT_CID_DEFAULT), the function directly
returns and leaks the already allocated hwinfo memory. Go through the
correct exit path.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index b88c7ee72dbf..ba30efc2d195 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -1654,7 +1654,7 @@ static void _rtl8723e_read_adapter_info(struct ieee80211_hw *hw,
 			rtlefuse->autoload_failflag, hwinfo);
 
 	if (rtlhal->oem_id != RT_CID_DEFAULT)
-		return;
+		goto exit;
 
 	switch (rtlefuse->eeprom_oemid) {
 	case EEPROM_CID_DEFAULT:
-- 
2.7.4

