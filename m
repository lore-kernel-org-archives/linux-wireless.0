Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42113 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1EWNyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 09:54:47 -0400
Received: by pzk9 with SMTP id 9so2573568pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 06:54:46 -0700 (PDT)
Message-ID: <4DDA6712.9090309@ring3k.org> (sfid-20110523_155453_007001_CF649577)
Date: Mon, 23 May 2011 22:54:26 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] rtlwifi: Don't block interrupts in spinlocks
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now power state transitions are not called from an
interrupt context, there's no need to block interrupts.

This code appears to block interrupts for too long,
causing my trackpad to lose sync occasionally.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/ps.c            |   44 ++++++++++---------------
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |   10 ++---
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |   10 ++---
 3 files changed, 26 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 5552b8c..447b458 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -86,7 +86,6 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 	enum rf_pwrstate rtstate;
 	bool actionallowed = false;
 	u16 rfwait_cnt = 0;
-	unsigned long flag;
 
 	/*protect_or_not = true; */
 
@@ -99,10 +98,9 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 	 *should wait to be executed.
 	 */
 	while (true) {
-		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+		spin_lock(&rtlpriv->locks.rf_ps_lock);
 		if (ppsc->rfchange_inprogress) {
-			spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock,
-					       flag);
+			spin_unlock(&rtlpriv->locks.rf_ps_lock);
 
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 				 ("RF Change in progress!"
@@ -123,8 +121,7 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			}
 		} else {
 			ppsc->rfchange_inprogress = true;
-			spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock,
-					       flag);
+			spin_unlock(&rtlpriv->locks.rf_ps_lock);
 			break;
 		}
 	}
@@ -174,9 +171,9 @@ no_protect:
 		rtlpriv->cfg->ops->set_rf_power_state(hw, state_toset);
 
 	if (!protect_or_not) {
-		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+		spin_lock(&rtlpriv->locks.rf_ps_lock);
 		ppsc->rfchange_inprogress = false;
-		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+		spin_unlock(&rtlpriv->locks.rf_ps_lock);
 	}
 
 	return actionallowed;
@@ -290,12 +287,11 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	enum rf_pwrstate rtstate;
-	unsigned long flags;
 
 	if (mac->opmode != NL80211_IFTYPE_STATION)
 		return;
 
-	spin_lock_irqsave(&rtlpriv->locks.ips_lock, flags);
+	spin_lock(&rtlpriv->locks.ips_lock);
 
 	if (ppsc->inactiveps) {
 		rtstate = ppsc->rfpwr_state;
@@ -311,7 +307,7 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 		}
 	}
 
-	spin_unlock_irqrestore(&rtlpriv->locks.ips_lock, flags);
+	spin_unlock(&rtlpriv->locks.ips_lock);
 }
 
 /*for FW LPS*/
@@ -429,7 +425,6 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	unsigned long flag;
 
 	if (!ppsc->fwctrl_lps)
 		return;
@@ -450,7 +445,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 	if (mac->link_state != MAC80211_LINKED)
 		return;
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	spin_lock(&rtlpriv->locks.lps_lock);
 
 	/* Idle for a while if we connect to AP a while ago. */
 	if (mac->cnt_after_linked >= 2) {
@@ -462,7 +457,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 		}
 	}
 
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	spin_unlock(&rtlpriv->locks.lps_lock);
 }
 
 /*Leave the leisure power save mode.*/
@@ -471,9 +466,8 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	unsigned long flag;
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	spin_lock(&rtlpriv->locks.lps_lock);
 
 	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
@@ -494,7 +488,7 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 			rtl_lps_set_psmode(hw, EACTIVE);
 		}
 	}
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	spin_unlock(&rtlpriv->locks.lps_lock);
 }
 
 /* For sw LPS*/
@@ -583,7 +577,6 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	unsigned long flag;
 
 	if (!rtlpriv->psc.swctrl_lps)
 		return;
@@ -596,9 +589,9 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 	}
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	spin_lock(&rtlpriv->locks.lps_lock);
 	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS, false);
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	spin_unlock(&rtlpriv->locks.lps_lock);
 }
 
 void rtl_swlps_rfon_wq_callback(void *data)
@@ -615,7 +608,6 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	unsigned long flag;
 	u8 sleep_intv;
 
 	if (!rtlpriv->psc.sw_ps_enabled)
@@ -632,16 +624,16 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	if (rtlpriv->link_info.busytraffic)
 		return;
 
-	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+	spin_lock(&rtlpriv->locks.rf_ps_lock);
 	if (rtlpriv->psc.rfchange_inprogress) {
-		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+		spin_unlock(&rtlpriv->locks.rf_ps_lock);
 		return;
 	}
-	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+	spin_unlock(&rtlpriv->locks.rf_ps_lock);
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	spin_lock(&rtlpriv->locks.lps_lock);
 	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS, false);
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	spin_unlock(&rtlpriv->locks.lps_lock);
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
 		!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 544e0b7..220a738 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -46,13 +46,12 @@ u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 original_value, readback_value, bitshift;
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	unsigned long flags;
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), "
 					       "rfpath(%#x), bitmask(%#x)\n",
 					       regaddr, rfpath, bitmask));
 
-	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
+	spin_lock(&rtlpriv->locks.rf_lock);
 
 	if (rtlphy->rf_mode != RF_OP_BY_FW) {
 		original_value = _rtl92c_phy_rf_serial_read(hw,
@@ -65,7 +64,7 @@ u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
-	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
+	spin_unlock(&rtlpriv->locks.rf_lock);
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 ("regaddr(%#x), rfpath(%#x), "
@@ -120,13 +119,12 @@ void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	u32 original_value, bitshift;
-	unsigned long flags;
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 ("regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
 		  regaddr, bitmask, data, rfpath));
 
-	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
+	spin_lock(&rtlpriv->locks.rf_lock);
 
 	if (rtlphy->rf_mode != RF_OP_BY_FW) {
 		if (bitmask != RFREG_OFFSET_MASK) {
@@ -153,7 +151,7 @@ void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 		_rtl92c_phy_fw_rf_serial_write(hw, rfpath, regaddr, data);
 	}
 
-	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
+	spin_unlock(&rtlpriv->locks.rf_lock);
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), "
 					       "bitmask(%#x), data(%#x), "
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index 2ad51b0..e5b1535 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -180,19 +180,18 @@ u32 rtl92s_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 original_value, readback_value, bitshift;
-	unsigned long flags;
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), rfpath(%#x), "
 		 "bitmask(%#x)\n", regaddr, rfpath, bitmask));
 
-	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
+	spin_lock(&rtlpriv->locks.rf_lock);
 
 	original_value = _rtl92s_phy_rf_serial_read(hw, rfpath, regaddr);
 
 	bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
-	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
+	spin_unlock(&rtlpriv->locks.rf_lock);
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), rfpath(%#x), "
 		 "bitmask(%#x), original_value(%#x)\n", regaddr, rfpath,
@@ -207,7 +206,6 @@ void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	u32 original_value, bitshift;
-	unsigned long flags;
 
 	if (!((rtlphy->rf_pathmap >> rfpath) & 0x1))
 		return;
@@ -215,7 +213,7 @@ void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), bitmask(%#x),"
 		 " data(%#x), rfpath(%#x)\n", regaddr, bitmask, data, rfpath));
 
-	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
+	spin_lock(&rtlpriv->locks.rf_lock);
 
 	if (bitmask != RFREG_OFFSET_MASK) {
 		original_value = _rtl92s_phy_rf_serial_read(hw, rfpath,
@@ -226,7 +224,7 @@ void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 
 	_rtl92s_phy_rf_serial_write(hw, rfpath, regaddr, data);
 
-	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
+	spin_unlock(&rtlpriv->locks.rf_lock);
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), bitmask(%#x), "
 		 "data(%#x), rfpath(%#x)\n", regaddr, bitmask, data, rfpath));
-- 
1.7.4.1


