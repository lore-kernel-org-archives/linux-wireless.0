Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59653 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbcHITU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 15:20:56 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Cc: kvalo@codeaurora.org, arnd@arndb.de,
	linux-wireless@vger.kernel.org,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] rtlwifi: rtl8192de: Fix leak in _rtl92de_read_adapter_info()
Date: Tue,  9 Aug 2016 21:19:57 +0200
Message-Id: <1470770397-24390-1-git-send-email-cengelma@gmx.at> (sfid-20160809_212059_770660_15292A84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case rtl_get_hwinfo() fails, the function directly returns and leaks the
already allocated hwinfo memory. Go through the correct exit path.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index b0f632462335..57205514801c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -1757,7 +1757,7 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
 		return;
 
 	if (rtl_get_hwinfo(hw, rtlpriv, HWSET_MAX_SIZE, hwinfo, params))
-		return;
+		goto exit;
 
 	_rtl92de_efuse_update_chip_version(hw);
 	_rtl92de_read_macphymode_and_bandtype(hw, hwinfo);
@@ -1790,6 +1790,7 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
 		break;
 	}
 	rtlefuse->txpwr_fromeprom = true;
+exit:
 	kfree(hwinfo);
 }
 
-- 
2.7.4

