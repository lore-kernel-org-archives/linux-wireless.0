Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:60541 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932097AbeAKHKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 02:10:00 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 04/10] rtlwifi: unlink bss when un-association
Date: Thu, 11 Jan 2018 15:09:26 +0800
Message-ID: <20180111070932.9929-5-pkshih@realtek.com> (sfid-20180111_081016_328053_0F58E757)
In-Reply-To: <20180111070932.9929-1-pkshih@realtek.com>
References: <20180111070932.9929-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tsang-Shian Lin <thlin@realtek.com>

When AP change bandwidth setting from 20M to 40M, STA may use old 20M AP
information to association with AP. Driver unlink bss in the
.bss_info_changed of ieee80211_ops to make sure that later scan can get
correct AP bandwidth capability.

Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index ec639fa8095e..6c698123ac07 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1171,6 +1171,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 				 "BSS_CHANGED_ASSOC\n");
 		} else {
+			struct cfg80211_bss *bss = NULL;
+
 			mstatus = RT_MEDIA_DISCONNECT;
 
 			if (mac->link_state == MAC80211_LINKED)
@@ -1178,6 +1180,22 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (ppsc->p2p_ps_info.p2p_ps_mode > P2P_PS_NONE)
 				rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
 			mac->link_state = MAC80211_NOLINK;
+
+			bss = cfg80211_get_bss(hw->wiphy, NULL,
+					       (u8 *)mac->bssid, NULL, 0,
+					       IEEE80211_BSS_TYPE_ESS,
+					       IEEE80211_PRIVACY_OFF);
+
+			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
+				 "bssid = %pMF\n", mac->bssid);
+
+			if (bss) {
+				cfg80211_unlink_bss(hw->wiphy, bss);
+				cfg80211_put_bss(hw->wiphy, bss);
+				RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
+					 "cfg80211_unlink !!\n");
+			}
+
 			eth_zero_addr(mac->bssid);
 			mac->vendor = PEER_UNKNOWN;
 			mac->mode = 0;
-- 
2.15.1
