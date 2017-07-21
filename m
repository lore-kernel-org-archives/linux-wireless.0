Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34420 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdGUEYw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:52 -0400
Received: by mail-oi0-f68.google.com with SMTP id v11so2343168oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:52 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 04/10] rtlwifi: Issue connection notification to phydm.
Date: Thu, 20 Jul 2017 23:24:34 -0500
Message-Id: <20170721042440.15839-5-Larry.Finger@lwfinger.net> (sfid-20170721_062506_463299_DFC535FD)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Phydm needs to know connection state, so we issue notification to indicate
reset_dm, pause_dig, or add/del sta.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 13 +++++++++++++
 drivers/net/wireless/realtek/rtlwifi/ps.c   |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index bb1425c3dc96..dc233bc146b0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -946,6 +946,9 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			"Add sta addr is %pM\n", sta->addr);
 		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0, true);
+
+		if (rtlpriv->phydm.ops)
+			rtlpriv->phydm.ops->phydm_add_sta(rtlpriv, sta);
 	}
 
 	return 0;
@@ -960,6 +963,10 @@ static int rtl_op_sta_remove(struct ieee80211_hw *hw,
 	if (sta) {
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			 "Remove sta addr is %pM\n", sta->addr);
+
+		if (rtlpriv->phydm.ops)
+			rtlpriv->phydm.ops->phydm_del_sta(rtlpriv, sta);
+
 		sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 		sta_entry->wireless_mode = 0;
 		sta_entry->ratr_index = 0;
@@ -1434,6 +1441,9 @@ static void rtl_op_sw_scan_start(struct ieee80211_hw *hw,
 		return;
 	}
 
+	if (rtlpriv->phydm.ops)
+		rtlpriv->phydm.ops->phydm_pause_dig(rtlpriv, 1);
+
 	if (rtlpriv->cfg->ops->get_btc_status())
 		rtlpriv->btcoexist.btc_ops->btc_scan_notify(rtlpriv, 1);
 
@@ -1491,6 +1501,9 @@ static void rtl_op_sw_scan_complete(struct ieee80211_hw *hw,
 	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_RESTORE);
 	if (rtlpriv->cfg->ops->get_btc_status())
 		rtlpriv->btcoexist.btc_ops->btc_scan_notify(rtlpriv, 0);
+
+	if (rtlpriv->phydm.ops)
+		rtlpriv->phydm.ops->phydm_pause_dig(rtlpriv, 0);
 }
 
 static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 07ee3096f50e..c64544158516 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -301,6 +301,8 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 			ppsc->in_powersavemode = false;
 			_rtl_ps_inactive_ps(hw);
 			/* call after RF on */
+			if (rtlpriv->phydm.ops)
+				rtlpriv->phydm.ops->phydm_reset_dm(rtlpriv);
 			if (rtlpriv->cfg->ops->get_btc_status())
 				rtlpriv->btcoexist.btc_ops->btc_ips_notify(rtlpriv,
 									ppsc->inactive_pwrstate);
-- 
2.12.3
