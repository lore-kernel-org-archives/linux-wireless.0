Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1FOXXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 19:23:43 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so700898pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 16:23:43 -0700 (PDT)
Message-ID: <4DF93ED6.4000208@ring3k.org> (sfid-20110616_012346_931783_098356B3)
Date: Thu, 16 Jun 2011 08:23:02 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] rtlwifi: rtl8192cu: Remove unused parameter
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl_ps_set_rf_state's protect_or_not parameter is not set to
true anywhere, except for commented out code.

It enables some legacy locking code, which is no longer used,
so delete the parameter and the old locking code.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/ps.c           |   63 ++-------------------------
 drivers/net/wireless/rtlwifi/ps.h           |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c |    3 +-
 3 files changed, 7 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index d14c13d..3eb039a 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -79,53 +79,12 @@ EXPORT_SYMBOL(rtl_ps_disable_nic);
 
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			 enum rf_pwrstate state_toset,
-			 u32 changesource, bool protect_or_not)
+			 u32 changesource)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool actionallowed = false;
-	u16 rfwait_cnt = 0;
 
-	/*protect_or_not = true; */
-
-	if (protect_or_not)
-		goto no_protect;
-
-	/*
-	 *Only one thread can change
-	 *the RF state at one time, and others
-	 *should wait to be executed.
-	 */
-	while (true) {
-		spin_lock(&rtlpriv->locks.rf_ps_lock);
-		if (ppsc->rfchange_inprogress) {
-			spin_unlock(&rtlpriv->locks.rf_ps_lock);
-
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-				 ("RF Change in progress!"
-				  "Wait to set..state_toset(%d).\n",
-				  state_toset));
-
-			/* Set RF after the previous action is done.  */
-			while (ppsc->rfchange_inprogress) {
-				rfwait_cnt++;
-				mdelay(1);
-
-				/*
-				 *Wait too long, return false to avoid
-				 *to be stuck here.
-				 */
-				if (rfwait_cnt > 100)
-					return false;
-			}
-		} else {
-			ppsc->rfchange_inprogress = true;
-			spin_unlock(&rtlpriv->locks.rf_ps_lock);
-			break;
-		}
-	}
-
-no_protect:
 	switch (state_toset) {
 	case ERFON:
 		ppsc->rfoff_reason &= (~changesource);
@@ -167,12 +126,6 @@ no_protect:
 	if (actionallowed)
 		rtlpriv->cfg->ops->set_rf_power_state(hw, state_toset);
 
-	if (!protect_or_not) {
-		spin_lock(&rtlpriv->locks.rf_ps_lock);
-		ppsc->rfchange_inprogress = false;
-		spin_unlock(&rtlpriv->locks.rf_ps_lock);
-	}
-
 	return actionallowed;
 }
 EXPORT_SYMBOL(rtl_ps_set_rf_state);
@@ -195,8 +148,7 @@ static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
 		}
 	}
 
-	rtl_ps_set_rf_state(hw, ppsc->inactive_pwrstate,
-			    RF_CHANGE_BY_IPS, false);
+	rtl_ps_set_rf_state(hw, ppsc->inactive_pwrstate, RF_CHANGE_BY_IPS);
 
 	if (ppsc->inactive_pwrstate == ERFOFF &&
 	    rtlhal->interface == INTF_PCI) {
@@ -587,7 +539,7 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 	}
 
 	spin_lock(&rtlpriv->locks.lps_lock);
-	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS, false);
+	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS);
 	spin_unlock(&rtlpriv->locks.lps_lock);
 }
 
@@ -621,15 +573,8 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	if (rtlpriv->link_info.busytraffic)
 		return;
 
-	spin_lock(&rtlpriv->locks.rf_ps_lock);
-	if (rtlpriv->psc.rfchange_inprogress) {
-		spin_unlock(&rtlpriv->locks.rf_ps_lock);
-		return;
-	}
-	spin_unlock(&rtlpriv->locks.rf_ps_lock);
-
 	spin_lock(&rtlpriv->locks.lps_lock);
-	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS, false);
+	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS);
 	spin_unlock(&rtlpriv->locks.lps_lock);
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
diff --git a/drivers/net/wireless/rtlwifi/ps.h b/drivers/net/wireless/rtlwifi/ps.h
index e3bf898..84628e60 100644
--- a/drivers/net/wireless/rtlwifi/ps.h
+++ b/drivers/net/wireless/rtlwifi/ps.h
@@ -33,8 +33,7 @@
 #define MAX_SW_LPS_SLEEP_INTV	5
 
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
-			 enum rf_pwrstate state_toset, u32 changesource,
-			 bool protect_or_not);
+			 enum rf_pwrstate state_toset, u32 changesource);
 bool rtl_ps_enable_nic(struct ieee80211_hw *hw);
 bool rtl_ps_disable_nic(struct ieee80211_hw *hw);
 void rtl_ips_nic_off(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 1b82684..f2d67be 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -994,7 +994,8 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 		rtlpriv->psc.rfoff_reason = RF_CHANGE_BY_INIT;
 		rtlpriv->psc.rfpwr_state = ERFON;
-		rtl_ps_set_rf_state(hw, ERFOFF, rfoffreason, true);
+		/* FIXME: check spinlocks if this block is uncommented */
+		rtl_ps_set_rf_state(hw, ERFOFF, rfoffreason);
 	} else {
 		/* gpio radio on/off is out of adapter start */
 		if (rtlpriv->psc.hwradiooff == false) {
-- 
1.7.4.1


