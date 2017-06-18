Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33435 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753223AbdFRQND (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 12:13:03 -0400
Received: by mail-oi0-f65.google.com with SMTP id k145so7238478oih.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jun 2017 09:13:01 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/11] rtlwifi: Revise special packet notification to be readable format.
Date: Sun, 18 Jun 2017 11:12:45 -0500
Message-Id: <20170618161249.6146-8-Larry.Finger@lwfinger.net> (sfid-20170618_181312_303717_EACA24BF)
In-Reply-To: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
References: <20170618161249.6146-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We extend types of special packets to a enumeration from boolean value.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index f9d249f85177..897ec3cfa8c8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1313,14 +1313,15 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 }
 EXPORT_SYMBOL_GPL(rtl_action_proc);
 
-static void setup_arp_tx(struct rtl_priv *rtlpriv, struct rtl_ps_ctl *ppsc)
+static void setup_special_tx(struct rtl_priv *rtlpriv, struct rtl_ps_ctl *ppsc,
+			     int type)
 {
 	struct ieee80211_hw *hw = rtlpriv->hw;
 
 	rtlpriv->ra.is_special_data = true;
 	if (rtlpriv->cfg->ops->get_btc_status())
 		rtlpriv->btcoexist.btc_ops->btc_special_packet_notify(
-					rtlpriv, 1);
+					rtlpriv, type);
 	rtl_lps_leave(hw);
 	ppsc->last_delaylps_stamp_jiffies = jiffies;
 }
@@ -1390,13 +1391,15 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 					 (is_tx) ? "Tx" : "Rx");
 
 				if (is_tx)
-					setup_arp_tx(rtlpriv, ppsc);
+					setup_special_tx(rtlpriv, ppsc,
+							 PACKET_DHCP);
+
 				return true;
 			}
 		}
 	} else if (ETH_P_ARP == ether_type) {
 		if (is_tx)
-			setup_arp_tx(rtlpriv, ppsc);
+			setup_special_tx(rtlpriv, ppsc, PACKET_ARP);
 
 		return true;
 	} else if (ETH_P_PAE == ether_type) {
@@ -1407,6 +1410,8 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 			rtlpriv->ra.is_special_data = true;
 			rtl_lps_leave(hw);
 			ppsc->last_delaylps_stamp_jiffies = jiffies;
+
+			setup_special_tx(rtlpriv, ppsc, PACKET_EAPOL);
 		}
 
 		return true;
-- 
2.12.3
