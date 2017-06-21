Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36518 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdFURPq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 13:15:46 -0400
Received: by mail-oi0-f67.google.com with SMTP id g14so16355866oib.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 10:15:45 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 1/8] rtlwifi: Fix a2dp choppy while BT RSSI stays on threshold.
Date: Wed, 21 Jun 2017 12:15:31 -0500
Message-Id: <20170621171538.4462-2-Larry.Finger@lwfinger.net> (sfid-20170621_191550_076028_5364E7D4)
In-Reply-To: <20170621171538.4462-1-Larry.Finger@lwfinger.net>
References: <20170621171538.4462-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

In this case, BTC asks to enter/leave PS mode frequently to cause A2DP
choppy.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c           | 14 ++++++++------
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c | 10 ++++++++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c |  8 ++++++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c | 10 ++++++++--
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 0d152877d969..07ee3096f50e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -356,7 +356,7 @@ void rtl_lps_set_psmode(struct ieee80211_hw *hw, u8 rt_psmode)
 	if (mac->link_state != MAC80211_LINKED)
 		return;
 
-	if (ppsc->dot11_psmode == rt_psmode)
+	if (ppsc->dot11_psmode == rt_psmode && rt_psmode == EACTIVE)
 		return;
 
 	/* Update power save mode configured. */
@@ -438,11 +438,13 @@ static void rtl_lps_enter_core(struct ieee80211_hw *hw)
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->dot11_psmode == EACTIVE) {
-		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
-			 "Enter 802.11 power save mode...\n");
-		rtl_lps_set_psmode(hw, EAUTOPS);
-	}
+	/* Don't need to check (ppsc->dot11_psmode == EACTIVE), because
+	 * bt_ccoexist may ask to enter lps.
+	 * In normal case, this constraint move to rtl_lps_set_psmode().
+	 */
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+		 "Enter 802.11 power save mode...\n");
+	rtl_lps_set_psmode(hw, EAUTOPS);
 
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 2ba9e613a7f6..f4ee7906eb20 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -427,6 +427,11 @@ void rtl92ee_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
 	bool bt_ctrl_lps = (rtlpriv->cfg->ops->get_btc_status() ?
 			    btc_ops->btc_is_bt_ctrl_lps(rtlpriv) : false);
+	bool bt_lps_on = (rtlpriv->cfg->ops->get_btc_status() ?
+			  btc_ops->btc_is_bt_lps_on(rtlpriv) : false);
+
+	if (bt_ctrl_lps)
+		mode = (bt_lps_on ? FW_PS_MIN_MODE : FW_PS_ACTIVE_MODE);
 
 	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, "FW LPS mode = %d (coex:%d)\n",
 		 mode, bt_ctrl_lps);
@@ -482,8 +487,9 @@ void rtl92ee_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
 	SET_H2CCMD_PWRMODE_PARM_RLBM(u1_h2c_set_pwrmode, rlbm);
 	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode,
-					 (rtlpriv->mac80211.p2p) ?
-					 ppsc->smart_ps : 1);
+					 bt_ctrl_lps ? 0 :
+					 ((rtlpriv->mac80211.p2p) ?
+					  ppsc->smart_ps : 1));
 	SET_H2CCMD_PWRMODE_PARM_AWAKE_INTERVAL(u1_h2c_set_pwrmode,
 					       awake_intvl);
 	SET_H2CCMD_PWRMODE_PARM_ALL_QUEUE_UAPSD(u1_h2c_set_pwrmode, 0);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index a37eb27cefe6..95b2e9a87d20 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -245,6 +245,11 @@ void rtl8723be_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
 	bool bt_ctrl_lps = (rtlpriv->cfg->ops->get_btc_status() ?
 			    btc_ops->btc_is_bt_ctrl_lps(rtlpriv) : false);
+	bool bt_lps_on = (rtlpriv->cfg->ops->get_btc_status() ?
+			  btc_ops->btc_is_bt_lps_on(rtlpriv) : false);
+
+	if (bt_ctrl_lps)
+		mode = (bt_lps_on ? FW_PS_MIN_MODE : FW_PS_ACTIVE_MODE);
 
 	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, "FW LPS mode = %d (coex:%d)\n",
 		 mode, bt_ctrl_lps);
@@ -300,8 +305,7 @@ void rtl8723be_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
 	SET_H2CCMD_PWRMODE_PARM_RLBM(u1_h2c_set_pwrmode, rlbm);
 	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode,
-					 (rtlpriv->mac80211.p2p) ?
-					  ppsc->smart_ps : 1);
+					 bt_ctrl_lps ? 0 : ppsc->smart_ps);
 	SET_H2CCMD_PWRMODE_PARM_AWAKE_INTERVAL(u1_h2c_set_pwrmode,
 					       awake_intvl);
 	SET_H2CCMD_PWRMODE_PARM_ALL_QUEUE_UAPSD(u1_h2c_set_pwrmode, 0);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index cc03f9813824..97401aa4dacb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -494,6 +494,11 @@ void rtl8821ae_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
 	bool bt_ctrl_lps = (rtlpriv->cfg->ops->get_btc_status() ?
 			    btc_ops->btc_is_bt_ctrl_lps(rtlpriv) : false);
+	bool bt_lps_on = (rtlpriv->cfg->ops->get_btc_status() ?
+			  btc_ops->btc_is_bt_lps_on(rtlpriv) : false);
+
+	if (bt_ctrl_lps)
+		mode = (bt_lps_on ? FW_PS_MIN_MODE : FW_PS_ACTIVE_MODE);
 
 	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, "FW LPS mode = %d (coex:%d)\n",
 		 mode, bt_ctrl_lps);
@@ -549,8 +554,9 @@ void rtl8821ae_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
 	SET_H2CCMD_PWRMODE_PARM_RLBM(u1_h2c_set_pwrmode, rlbm);
 	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode,
-					 (rtlpriv->mac80211.p2p) ?
-					 ppsc->smart_ps : 1);
+					 bt_ctrl_lps ? 0 :
+					 ((rtlpriv->mac80211.p2p) ?
+					  ppsc->smart_ps : 1));
 	SET_H2CCMD_PWRMODE_PARM_AWAKE_INTERVAL(u1_h2c_set_pwrmode,
 					       awake_intvl);
 	SET_H2CCMD_PWRMODE_PARM_ALL_QUEUE_UAPSD(u1_h2c_set_pwrmode, 0);
-- 
2.12.3
