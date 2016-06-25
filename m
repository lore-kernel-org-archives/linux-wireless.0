Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33481 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcFYSiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 14:38:15 -0400
Received: by mail-oi0-f68.google.com with SMTP id w141so24017342oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 11:38:15 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Andrianov <andrianov@ispras.ru>
Subject: [PATCH 1/6] rtlwifi: Remove unused parameter from rtl_ps_set_rf_state()
Date: Sat, 25 Jun 2016 13:37:42 -0500
Message-Id: <1466879867-2499-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_203823_975160_1A710B65)
In-Reply-To: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 4b9d8d67b44a ("rtlwifi: rtl8192cu: Remove unused parameter") reworked
this routine. Those changes were later reverted by commit d3feae41a347
("rtlwifi: Update power-save routines for 062814 driver").

There were two changes in commit 4b9d8d67b44a. The first of these removed
a parameter from rtl_ps_set_rf_state() that was always false. This is the
change that is restored in the current patch. A second change that reworked
the locking is still being analyzed.

In addition to removing the unused parameter, there is no need for
rtl_ps_set_rf_state() to be exported.

Reported-by: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pavel Andrianov <andrianov@ispras.ru>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 25 +++++++++----------------
 drivers/net/wireless/realtek/rtlwifi/ps.h |  3 ---
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 93579ca..9a64f9b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -76,9 +76,9 @@ bool rtl_ps_disable_nic(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(rtl_ps_disable_nic);
 
-bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
-			 enum rf_pwrstate state_toset,
-			 u32 changesource, bool protect_or_not)
+static bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
+				enum rf_pwrstate state_toset,
+				u32 changesource)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -86,9 +86,6 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 	bool actionallowed = false;
 	u16 rfwait_cnt = 0;
 
-	if (protect_or_not)
-		goto no_protect;
-
 	/*Only one thread can change
 	 *the RF state at one time, and others
 	 *should wait to be executed.
@@ -119,7 +116,6 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 		}
 	}
 
-no_protect:
 	rtstate = ppsc->rfpwr_state;
 
 	switch (state_toset) {
@@ -162,15 +158,12 @@ no_protect:
 	if (actionallowed)
 		rtlpriv->cfg->ops->set_rf_power_state(hw, state_toset);
 
-	if (!protect_or_not) {
-		spin_lock(&rtlpriv->locks.rf_ps_lock);
-		ppsc->rfchange_inprogress = false;
-		spin_unlock(&rtlpriv->locks.rf_ps_lock);
-	}
+	spin_lock(&rtlpriv->locks.rf_ps_lock);
+	ppsc->rfchange_inprogress = false;
+	spin_unlock(&rtlpriv->locks.rf_ps_lock);
 
 	return actionallowed;
 }
-EXPORT_SYMBOL(rtl_ps_set_rf_state);
 
 static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
 {
@@ -191,7 +184,7 @@ static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
 	}
 
 	rtl_ps_set_rf_state(hw, ppsc->inactive_pwrstate,
-			    RF_CHANGE_BY_IPS, false);
+			    RF_CHANGE_BY_IPS);
 
 	if (ppsc->inactive_pwrstate == ERFOFF &&
 	    rtlhal->interface == INTF_PCI) {
@@ -587,7 +580,7 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 	}
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
-	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS, false);
+	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS);
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
 
@@ -630,7 +623,7 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	spin_unlock(&rtlpriv->locks.rf_ps_lock);
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
-	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS , false);
+	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS);
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.h b/drivers/net/wireless/realtek/rtlwifi/ps.h
index 29dfc51..0df2b52 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.h
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.h
@@ -28,9 +28,6 @@
 
 #define MAX_SW_LPS_SLEEP_INTV	5
 
-bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
-			 enum rf_pwrstate state_toset, u32 changesource,
-			 bool protect_or_not);
 bool rtl_ps_enable_nic(struct ieee80211_hw *hw);
 bool rtl_ps_disable_nic(struct ieee80211_hw *hw);
 void rtl_ips_nic_off(struct ieee80211_hw *hw);
-- 
2.1.4

