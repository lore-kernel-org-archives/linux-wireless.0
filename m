Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51245 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbcEQWqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 18:46:44 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] rtlwifi: rtl8723be: avoid undefined behavior
Date: Wed, 18 May 2016 00:46:23 +0200
Message-Id: <1463525183-11483-1-git-send-email-xypron.glpk@gmx.de> (sfid-20160518_004720_685380_7FDB78C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not return undefined value for transmission power
if the rate is invalid.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index 445f681..c5ca9df 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -1019,7 +1019,7 @@ static u8 _rtl8723be_get_txpower_index(struct ieee80211_hw *hw, u8 path,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 index = (channel - 1);
-	u8 txpower;
+	u8 txpower = 0;
 	u8 power_diff_byrate = 0;
 
 	if (channel > 14 || channel < 1) {
-- 
2.1.4

