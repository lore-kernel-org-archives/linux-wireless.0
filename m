Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:36262 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2DESCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 14:02:41 -0400
Date: Thu, 5 Apr 2012 14:02:40 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Jingjun Wu <jingjun_wu@realsil.com.cn>
Subject: [PATCH v2 2/2] rtl8192de: Recognize 92D E-CUT version.
Message-ID: <20120405180240.GF21869@alittletooquiet.net> (sfid-20120405_200244_014341_892D47E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip version constant (0xCC33) was taken from version 0001.0105.2011
of the GPL vendor driver.  Note that this driver version also ships a
firmware update, but I am unsure if it is required for E-CUT chips to
function properly.

A nearby spelling error was also corrected.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
---
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 7d87712..2655448 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1743,9 +1743,13 @@ static void _rtl92de_efuse_update_chip_version(struct ieee80211_hw *hw)
 		chipver |= CHIP_92D_D_CUT;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "D-CUT!!!\n");
 		break;
+	case 0xCC33:
+		chipver |= CHIP_92D_E_CUT;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "E-CUT!!!\n");
+		break;
 	default:
 		chipver |= CHIP_92D_D_CUT;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unkown CUT!\n");
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unknown CUT!\n");
 		break;
 	}
 	rtlpriv->rtlhal.version = chipver;
-- 
1.7.0.4

-- 
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com
