Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linuxhacker.ru ([217.76.32.60]:43224 "EHLO fiona.linuxhacker.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbcH0EJF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Aug 2016 00:09:05 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH] rtlwifi/rtl8192de: Fix print format string
Date: Fri, 26 Aug 2016 23:12:23 -0400
Message-Id: <1472267543-810602-1-git-send-email-green@linuxhacker.ru> (sfid-20160827_060909_282557_EDCCD9BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

%ul was likely meant as %lu to print an unsigned long,
not an unsigned with a letter l at the end.
But in fact the value printed is u32 anyway, so just drop
the l completely.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index d334d2a..2a4810d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -588,7 +588,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 				 * setting. */
 				udelay(1);
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					 "The Rtl819XAGCTAB_Array_Table[0] is %ul Rtl819XPHY_REGArray[1] is %ul\n",
+					 "The Rtl819XAGCTAB_Array_Table[0] is %u Rtl819XPHY_REGArray[1] is %u\n",
 					 agctab_array_table[i],
 					 agctab_array_table[i + 1]);
 			}
@@ -604,7 +604,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 					 * setting. */
 					udelay(1);
 					RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-						 "The Rtl819XAGCTAB_Array_Table[0] is %ul Rtl819XPHY_REGArray[1] is %ul\n",
+						 "The Rtl819XAGCTAB_Array_Table[0] is %u Rtl819XPHY_REGArray[1] is %u\n",
 						 agctab_array_table[i],
 						 agctab_array_table[i + 1]);
 				}
@@ -620,7 +620,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 					 * setting. */
 					udelay(1);
 					RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-						 "The Rtl819XAGCTAB_5GArray_Table[0] is %ul Rtl819XPHY_REGArray[1] is %ul\n",
+						 "The Rtl819XAGCTAB_5GArray_Table[0] is %u Rtl819XPHY_REGArray[1] is %u\n",
 						 agctab_5garray_table[i],
 						 agctab_5garray_table[i + 1]);
 				}
-- 
2.7.4
