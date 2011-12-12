Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1LLLoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 06:44:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Mike McCormack <mikem@ring3k.org>
Subject: [PATCH 2/2] rtlwifi: merge ips,lps spinlocks into one mutex
Date: Mon, 12 Dec 2011 12:43:24 +0100
Message-Id: <1323690204-5124-2-git-send-email-sgruszka@redhat.com> (sfid-20111212_124418_282394_841BF408)
In-Reply-To: <1323690204-5124-1-git-send-email-sgruszka@redhat.com>
References: <1323690204-5124-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With previous patch "rtlwifi: use work for lps" we can now use mutex for
protecting ps mode changing critical sections. This fixes running system
with interrupts disabled for long time.

Merge ips_lock and lps_lock as they seems to protect the same data
structures (accessed in rtl_ps_set_rf_state() function).

Reported-by: Philipp Dreimann <philipp@dreimann.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mike McCormack <mikem@ring3k.org>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rtlwifi/base.c |    3 +--
 drivers/net/wireless/rtlwifi/ps.c   |   21 ++++++++++-----------
 drivers/net/wireless/rtlwifi/wifi.h |    3 +--
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index a13ecfc..d81a602 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -448,12 +448,11 @@ int rtl_init_core(struct ieee80211_hw *hw)
 
 	/* <4> locks */
 	mutex_init(&rtlpriv->locks.conf_mutex);
-	spin_lock_init(&rtlpriv->locks.ips_lock);
+	mutex_init(&rtlpriv->locks.ps_mutex);
 	spin_lock_init(&rtlpriv->locks.irq_th_lock);
 	spin_lock_init(&rtlpriv->locks.h2c_lock);
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
 	spin_lock_init(&rtlpriv->locks.rf_lock);
-	spin_lock_init(&rtlpriv->locks.lps_lock);
 	spin_lock_init(&rtlpriv->locks.waitq_lock);
 	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
 
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 55c8e50..a14a68b 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -241,7 +241,7 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 	if (mac->opmode != NL80211_IFTYPE_STATION)
 		return;
 
-	spin_lock(&rtlpriv->locks.ips_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 
 	if (ppsc->inactiveps) {
 		rtstate = ppsc->rfpwr_state;
@@ -257,7 +257,7 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 		}
 	}
 
-	spin_unlock(&rtlpriv->locks.ips_lock);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 }
 
 /*for FW LPS*/
@@ -395,7 +395,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 	if (mac->link_state != MAC80211_LINKED)
 		return;
 
-	spin_lock_irq(&rtlpriv->locks.lps_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 
 	/* Idle for a while if we connect to AP a while ago. */
 	if (mac->cnt_after_linked >= 2) {
@@ -407,7 +407,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 		}
 	}
 
-	spin_unlock_irq(&rtlpriv->locks.lps_lock);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 }
 
 /*Leave the leisure power save mode.*/
@@ -416,9 +416,8 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	unsigned long flags;
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flags);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 
 	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
@@ -439,7 +438,7 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 			rtl_lps_set_psmode(hw, EACTIVE);
 		}
 	}
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flags);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 }
 
 /* For sw LPS*/
@@ -540,9 +539,9 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 	}
 
-	spin_lock_irq(&rtlpriv->locks.lps_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS);
-	spin_unlock_irq(&rtlpriv->locks.lps_lock);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 }
 
 void rtl_swlps_rfon_wq_callback(void *data)
@@ -575,9 +574,9 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	if (rtlpriv->link_info.busytraffic)
 		return;
 
-	spin_lock_irq(&rtlpriv->locks.lps_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS);
-	spin_unlock_irq(&rtlpriv->locks.lps_lock);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
 		!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 6e6353b..085dccd 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1544,14 +1544,13 @@ struct rtl_hal_cfg {
 struct rtl_locks {
 	/* mutex */
 	struct mutex conf_mutex;
+	struct mutex ps_mutex;
 
 	/*spin lock */
-	spinlock_t ips_lock;
 	spinlock_t irq_th_lock;
 	spinlock_t h2c_lock;
 	spinlock_t rf_ps_lock;
 	spinlock_t rf_lock;
-	spinlock_t lps_lock;
 	spinlock_t waitq_lock;
 
 	/*Dual mac*/
-- 
1.7.1

