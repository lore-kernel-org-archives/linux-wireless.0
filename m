Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60874 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbcGaKap (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2016 06:30:45 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] rtlwifi: remove superfluous condition
Date: Sun, 31 Jul 2016 12:30:15 +0200
Message-Id: <1469961015-1888-1-git-send-email-xypron.glpk@gmx.de> (sfid-20160731_123108_879271_9FBE209C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If sta == NULL, the changed line will not be reached.
So no need to check if stat == NULL here.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 41f77f8..7aee5ebb1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1135,7 +1135,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 					mac->mode = WIRELESS_MODE_AC_24G;
 			}
 
-			if (vif->type == NL80211_IFTYPE_STATION && sta)
+			if (vif->type == NL80211_IFTYPE_STATION)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
 			rcu_read_unlock();
 
-- 
2.8.1

