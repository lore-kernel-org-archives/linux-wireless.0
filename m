Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab1DYRxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:53:40 -0400
Date: Mon, 25 Apr 2011 12:53:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/18] rtlwifi: Convert ps routines for addition of
 rtl8192se and rtl8192de
Message-ID: <4db5b50a.cWHDl8lUaSJTDhLv%Larry.Finger@lwfinger.net> (sfid-20110425_195345_060705_B5C4B639)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Convert ps routines for addition of RTL8192SE and RTL8192DE code

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 ps.c |  276 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 ps.h |    2 
 2 files changed, 241 insertions(+), 37 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -36,7 +36,6 @@ bool rtl_ps_enable_nic(struct ieee80211_
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	bool init_status = true;
 
 	/*<1> reset trx ring */
 	if (rtlhal->interface == INTF_PCI)
@@ -49,7 +48,6 @@ bool rtl_ps_enable_nic(struct ieee80211_
 	/*<2> Enable Adapter */
 	rtlpriv->cfg->ops->hw_init(hw);
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
-	/*init_status = false; */
 
 	/*<3> Enable Interrupt */
 	rtlpriv->cfg->ops->enable_interrupt(hw);
@@ -57,7 +55,7 @@ bool rtl_ps_enable_nic(struct ieee80211_
 	/*<enable timer> */
 	rtl_watch_dog_timer_callback((unsigned long)hw);
 
-	return init_status;
+	return true;
 }
 EXPORT_SYMBOL(rtl_ps_enable_nic);
 
@@ -192,12 +190,13 @@ static void _rtl_ps_inactive_ps(struct i
 
 	ppsc->swrf_processing = true;
 
-	if (ppsc->inactive_pwrstate == ERFON && rtlhal->interface == INTF_PCI) {
+	if (ppsc->inactive_pwrstate == ERFOFF &&
+	    rtlhal->interface == INTF_PCI) {
 		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-		    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM) &&
+		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
 		    rtlhal->interface == INTF_PCI) {
 			rtlpriv->intf_ops->disable_aspm(hw);
-			RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
+			RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 		}
 	}
 
@@ -206,9 +205,10 @@ static void _rtl_ps_inactive_ps(struct i
 
 	if (ppsc->inactive_pwrstate == ERFOFF &&
 	    rtlhal->interface == INTF_PCI) {
-		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) {
+		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
+			!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
 			rtlpriv->intf_ops->enable_aspm(hw);
-			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
+			RT_SET_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 		}
 	}
 
@@ -232,6 +232,9 @@ void rtl_ips_nic_off_wq_callback(void *d
 		return;
 	}
 
+	if (mac->link_state > MAC80211_NOLINK)
+		return;
+
 	if (is_hal_stop(rtlhal))
 		return;
 
@@ -283,10 +286,14 @@ void rtl_ips_nic_off(struct ieee80211_hw
 void rtl_ips_nic_on(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	enum rf_pwrstate rtstate;
 	unsigned long flags;
 
+	if (mac->opmode != NL80211_IFTYPE_STATION)
+		return;
+
 	spin_lock_irqsave(&rtlpriv->locks.ips_lock, flags);
 
 	if (ppsc->inactiveps) {
@@ -369,8 +376,7 @@ static void rtl_lps_set_psmode(struct ie
 	 *   mode and set RPWM to turn RF on.
 	 */
 
-	if ((ppsc->fwctrl_lps) && (ppsc->leisure_ps) &&
-	     ppsc->report_linked) {
+	if ((ppsc->fwctrl_lps) && ppsc->report_linked) {
 		bool fw_current_inps;
 		if (ppsc->dot11_psmode == EACTIVE) {
 			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
@@ -416,22 +422,6 @@ static void rtl_lps_set_psmode(struct ie
 	}
 }
 
-void rtl_swlps_rfon_wq_callback(void *data)
-{
-}
-
-void rtl_swlps_wq_callback(void *data)
-{
-}
-
-void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
-{
-}
-
-void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
-{
-}
-
 /*Enter the leisure power save mode.*/
 void rtl_lps_enter(struct ieee80211_hw *hw)
 {
@@ -440,7 +430,7 @@ void rtl_lps_enter(struct ieee80211_hw *
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned long flag;
 
-	if (!(ppsc->fwctrl_lps && ppsc->leisure_ps))
+	if (!ppsc->fwctrl_lps)
 		return;
 
 	if (rtlpriv->sec.being_setkey)
@@ -461,17 +451,16 @@ void rtl_lps_enter(struct ieee80211_hw *
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->leisure_ps) {
-		/* Idle for a while if we connect to AP a while ago. */
-		if (mac->cnt_after_linked >= 2) {
-			if (ppsc->dot11_psmode == EACTIVE) {
-				RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+	/* Idle for a while if we connect to AP a while ago. */
+	if (mac->cnt_after_linked >= 2) {
+		if (ppsc->dot11_psmode == EACTIVE) {
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 					("Enter 802.11 power save mode...\n"));
 
-				rtl_lps_set_psmode(hw, EAUTOPS);
-			}
+			rtl_lps_set_psmode(hw, EAUTOPS);
 		}
 	}
+
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
 
@@ -485,17 +474,17 @@ void rtl_lps_leave(struct ieee80211_hw *
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->fwctrl_lps && ppsc->leisure_ps) {
+	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
 
 			/*FIX ME */
 			rtlpriv->cfg->ops->enable_interrupt(hw);
 
 			if (ppsc->reg_rfps_level & RT_RF_LPS_LEVEL_ASPM &&
-			    RT_IN_PS_LEVEL(ppsc, RT_RF_LPS_LEVEL_ASPM) &&
+			    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
 			    rtlhal->interface == INTF_PCI) {
 				rtlpriv->intf_ops->disable_aspm(hw);
-				RT_CLEAR_PS_LEVEL(ppsc, RT_RF_LPS_LEVEL_ASPM);
+				RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 			}
 
 			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
@@ -506,3 +495,216 @@ void rtl_lps_leave(struct ieee80211_hw *
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
+
+/* For sw LPS*/
+void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct ieee80211_hdr *hdr = (void *) data;
+	struct ieee80211_tim_ie *tim_ie;
+	u8 *tim;
+	u8 tim_len;
+	bool u_buffed;
+	bool m_buffed;
+
+	if (mac->opmode != NL80211_IFTYPE_STATION)
+		return;
+
+	if (!rtlpriv->psc.swctrl_lps)
+		return;
+
+	if (rtlpriv->mac80211.link_state != MAC80211_LINKED)
+		return;
+
+	if (!rtlpriv->psc.sw_ps_enabled)
+		return;
+
+	if (rtlpriv->psc.fwctrl_lps)
+		return;
+
+	if (likely(!(hw->conf.flags & IEEE80211_CONF_PS)))
+		return;
+
+	/* check if this really is a beacon */
+	if (!ieee80211_is_beacon(hdr->frame_control))
+		return;
+
+	/* min. beacon length + FCS_LEN */
+	if (len <= 40 + FCS_LEN)
+		return;
+
+	/* and only beacons from the associated BSSID, please */
+	if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
+		return;
+
+	rtlpriv->psc.last_beacon = jiffies;
+
+	tim = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_TIM);
+	if (!tim)
+		return;
+
+	if (tim[1] < sizeof(*tim_ie))
+		return;
+
+	tim_len = tim[1];
+	tim_ie = (struct ieee80211_tim_ie *) &tim[2];
+
+	if (!WARN_ON_ONCE(!hw->conf.ps_dtim_period))
+		rtlpriv->psc.dtim_counter = tim_ie->dtim_count;
+
+	/* Check whenever the PHY can be turned off again. */
+
+	/* 1. What about buffered unicast traffic for our AID? */
+	u_buffed = ieee80211_check_tim(tim_ie, tim_len,
+				       rtlpriv->mac80211.assoc_id);
+
+	/* 2. Maybe the AP wants to send multicast/broadcast data? */
+	m_buffed = tim_ie->bitmap_ctrl & 0x01;
+	rtlpriv->psc.multi_buffered = m_buffed;
+
+	/* unicast will process by mac80211 through
+	 * set ~IEEE80211_CONF_PS, So we just check
+	 * multicast frames here */
+	if (!m_buffed) {
+		/* back to low-power land. and delay is
+		 * prevent null power save frame tx fail */
+		queue_delayed_work(rtlpriv->works.rtl_wq,
+				&rtlpriv->works.ps_work, MSECS(5));
+	} else {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, ("u_bufferd: %x, "
+				"m_buffered: %x\n", u_buffed, m_buffed));
+	}
+}
+
+void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	unsigned long flag;
+
+	if (!rtlpriv->psc.swctrl_lps)
+		return;
+	if (mac->link_state != MAC80211_LINKED)
+		return;
+
+	if (ppsc->reg_rfps_level & RT_RF_LPS_LEVEL_ASPM &&
+		RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
+		rtlpriv->intf_ops->disable_aspm(hw);
+		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
+	}
+
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+}
+
+void rtl_swlps_rfon_wq_callback(void *data)
+{
+	struct rtl_works *rtlworks =
+	    container_of_dwork_rtl(data, struct rtl_works, ps_rfon_wq);
+	struct ieee80211_hw *hw = rtlworks->hw;
+
+	rtl_swlps_rf_awake(hw);
+}
+
+void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	unsigned long flag;
+	u8 sleep_intv;
+
+	if (!rtlpriv->psc.sw_ps_enabled)
+		return;
+
+	if ((rtlpriv->sec.being_setkey) ||
+	    (mac->opmode == NL80211_IFTYPE_ADHOC))
+		return;
+
+	/*sleep after linked 10s, to let DHCP and 4-way handshake ok enough!! */
+	if ((mac->link_state != MAC80211_LINKED) || (mac->cnt_after_linked < 5))
+		return;
+
+	if (rtlpriv->link_info.busytraffic)
+		return;
+
+	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+	if (rtlpriv->psc.rfchange_inprogress) {
+		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+		return;
+	}
+	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+
+	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
+		!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
+		rtlpriv->intf_ops->enable_aspm(hw);
+		RT_SET_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
+	}
+
+	/* here is power save alg, when this beacon is DTIM
+	 * we will set sleep time to dtim_period * n;
+	 * when this beacon is not DTIM, we will set sleep
+	 * time to sleep_intv = rtlpriv->psc.dtim_counter or
+	 * MAX_SW_LPS_SLEEP_INTV(default set to 5) */
+
+	if (rtlpriv->psc.dtim_counter == 0) {
+		if (hw->conf.ps_dtim_period == 1)
+			sleep_intv = hw->conf.ps_dtim_period * 2;
+		else
+			sleep_intv = hw->conf.ps_dtim_period;
+	} else {
+		sleep_intv = rtlpriv->psc.dtim_counter;
+	}
+
+	if (sleep_intv > MAX_SW_LPS_SLEEP_INTV)
+		sleep_intv = MAX_SW_LPS_SLEEP_INTV;
+
+	/* this print should always be dtim_conter = 0 &
+	 * sleep  = dtim_period, that meaons, we should
+	 * awake before every dtim */
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
+		 ("dtim_counter:%x will sleep :%d"
+		 " beacon_intv\n", rtlpriv->psc.dtim_counter, sleep_intv));
+
+	/* we tested that 40ms is enough for sw & hw sw delay */
+	queue_delayed_work(rtlpriv->works.rtl_wq, &rtlpriv->works.ps_rfon_wq,
+			MSECS(sleep_intv * mac->vif->bss_conf.beacon_int - 40));
+}
+
+
+void rtl_swlps_wq_callback(void *data)
+{
+	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
+				     struct rtl_works,
+				     ps_work);
+	struct ieee80211_hw *hw = rtlworks->hw;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	bool ps = false;
+
+	ps = (hw->conf.flags & IEEE80211_CONF_PS);
+
+	/* we can sleep after ps null send ok */
+	if (rtlpriv->psc.state_inap) {
+		rtl_swlps_rf_sleep(hw);
+
+		if (rtlpriv->psc.state && !ps) {
+			rtlpriv->psc.sleep_ms = jiffies_to_msecs(jiffies -
+					rtlpriv->psc.last_action);
+		}
+
+		if (ps)
+			rtlpriv->psc.last_slept = jiffies;
+
+		rtlpriv->psc.last_action = jiffies;
+		rtlpriv->psc.state = ps;
+	}
+}
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.h
@@ -30,6 +30,8 @@
 #ifndef __REALTEK_RTL_PCI_PS_H__
 #define __REALTEK_RTL_PCI_PS_H__
 
+#define MAX_SW_LPS_SLEEP_INTV	5
+
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			 enum rf_pwrstate state_toset, u32 changesource,
 			 bool protect_or_not);
