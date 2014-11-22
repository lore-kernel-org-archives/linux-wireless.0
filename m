Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51940 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaKVLS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2014 06:18:29 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so8802778wgh.30
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2014 03:18:27 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: update RCR register in rtl_op_configure_filter()
Date: Sat, 22 Nov 2014 12:18:26 +0100
Message-Id: <1416655106-27067-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141122_121832_480456_2BF4EDF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reconfigure RCR register in rtl_op_configure_filter() in order to apply RX
filter configuration

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/rtlwifi/core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index af52f0b..5fc6f52 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -786,6 +786,7 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int changed_flags,
 				    unsigned int *new_flags, u64 multicast)
 {
+	bool update_rcr = false;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
@@ -806,6 +807,7 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 "Disable receive multicast frame\n");
 		}
+		update_rcr = true;
 	}
 
 	if (changed_flags & FIF_FCSFAIL) {
@@ -818,6 +820,8 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 "Disable receive FCS error frame\n");
 		}
+		if (!update_rcr)
+			update_rcr = true;
 	}
 
 	/* if ssid not set to hw don't check bssid
@@ -832,6 +836,8 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 				rtlpriv->cfg->ops->set_chk_bssid(hw, false);
 			else
 				rtlpriv->cfg->ops->set_chk_bssid(hw, true);
+			if (update_rcr)
+				update_rcr = false;
 		}
 	}
 
@@ -846,6 +852,8 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 "Disable receive control frame.\n");
 		}
+		if (!update_rcr)
+			update_rcr = true;
 	}
 
 	if (changed_flags & FIF_OTHER_BSS) {
@@ -858,7 +866,13 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 "Disable receive other BSS's frame.\n");
 		}
+		if (!update_rcr)
+			update_rcr = true;
 	}
+
+	if (update_rcr)
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
+					      (u8 *)(&mac->rx_conf));
 }
 static int rtl_op_sta_add(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
-- 
2.1.0

