Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:38841 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbdGUEY4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:56 -0400
Received: by mail-oi0-f68.google.com with SMTP id p188so3925884oia.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:56 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/10] rtlwifi: Use mutex to replace spin_lock in cases of IPS and LPS
Date: Thu, 20 Jul 2017 23:24:38 -0500
Message-Id: <20170721042440.15839-9-Larry.Finger@lwfinger.net> (sfid-20170721_062512_550197_C20E66B8)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Enter/leavel IPS and LPS are large critical section, and they can't use sleep
function because running in atomic-context, which own a spin_lock.
In commit 460884ad ("rtlwifi: Fix enter/exit power_save"), it moves LPS
functions to thread-context, so this commit can simply change LPS's spin lock
to mutex.

Considering IPS functions, rtl_ips_nic_on() may be called by TX tasklet
(softirq-context) that check whether packet is auth frame. Fortunately,
current mac80211 will ask driver to leave IPS using op_config with changed flag
IEEE80211_CONF_CHANGE_IDLE, before issuing auth frame, so IPS functions can run
in thread-context and use mutex to protect critical section, too.
In addition to above conversion, this commit removes some useless spin locks.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c |  6 ++----
 drivers/net/wireless/realtek/rtlwifi/ps.c   | 24 ++++++++++--------------
 drivers/net/wireless/realtek/rtlwifi/usb.c  |  1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 10 ++--------
 4 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index c145cfe27216..d933392dfc04 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -552,7 +552,8 @@ int rtl_init_core(struct ieee80211_hw *hw)
 
 	/* <4> locks */
 	mutex_init(&rtlpriv->locks.conf_mutex);
-	spin_lock_init(&rtlpriv->locks.ips_lock);
+	mutex_init(&rtlpriv->locks.ips_mutex);
+	mutex_init(&rtlpriv->locks.lps_mutex);
 	spin_lock_init(&rtlpriv->locks.irq_th_lock);
 	spin_lock_init(&rtlpriv->locks.h2c_lock);
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
@@ -562,9 +563,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	spin_lock_init(&rtlpriv->locks.c2hcmd_lock);
 	spin_lock_init(&rtlpriv->locks.scan_list_lock);
 	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
-	spin_lock_init(&rtlpriv->locks.check_sendpkt_lock);
 	spin_lock_init(&rtlpriv->locks.fw_ps_lock);
-	spin_lock_init(&rtlpriv->locks.lps_lock);
 	spin_lock_init(&rtlpriv->locks.iqk_lock);
 	/* <5> init list */
 	INIT_LIST_HEAD(&rtlpriv->entry_list);
@@ -1230,7 +1229,6 @@ bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 	if (ieee80211_is_auth(fc)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, "MAC80211_LINKING\n");
-		rtl_ips_nic_on(hw);
 
 		mac->link_state = MAC80211_LINKING;
 		/* Dul mac */
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index c64544158516..972ed58f20d6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -289,7 +289,7 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 
 	cancel_delayed_work(&rtlpriv->works.ips_nic_off_wq);
 
-	spin_lock(&rtlpriv->locks.ips_lock);
+	mutex_lock(&rtlpriv->locks.ips_mutex);
 	if (ppsc->inactiveps) {
 		rtstate = ppsc->rfpwr_state;
 
@@ -308,7 +308,7 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 									ppsc->inactive_pwrstate);
 		}
 	}
-	spin_unlock(&rtlpriv->locks.ips_lock);
+	mutex_unlock(&rtlpriv->locks.ips_mutex);
 }
 EXPORT_SYMBOL_GPL(rtl_ips_nic_on);
 
@@ -417,7 +417,6 @@ static void rtl_lps_enter_core(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	unsigned long flag;
 
 	if (!ppsc->fwctrl_lps)
 		return;
@@ -438,7 +437,7 @@ static void rtl_lps_enter_core(struct ieee80211_hw *hw)
 	if (mac->link_state != MAC80211_LINKED)
 		return;
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	mutex_lock(&rtlpriv->locks.lps_mutex);
 
 	/* Don't need to check (ppsc->dot11_psmode == EACTIVE), because
 	 * bt_ccoexist may ask to enter lps.
@@ -448,7 +447,7 @@ static void rtl_lps_enter_core(struct ieee80211_hw *hw)
 		 "Enter 802.11 power save mode...\n");
 	rtl_lps_set_psmode(hw, EAUTOPS);
 
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	mutex_unlock(&rtlpriv->locks.lps_mutex);
 }
 
 /* Interrupt safe routine to leave the leisure power save mode.*/
@@ -457,9 +456,8 @@ static void rtl_lps_leave_core(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	unsigned long flag;
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	mutex_lock(&rtlpriv->locks.lps_mutex);
 
 	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
@@ -480,7 +478,7 @@ static void rtl_lps_leave_core(struct ieee80211_hw *hw)
 			rtl_lps_set_psmode(hw, EACTIVE);
 		}
 	}
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	mutex_unlock(&rtlpriv->locks.lps_mutex);
 }
 
 /* For sw LPS*/
@@ -570,7 +568,6 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	unsigned long flag;
 
 	if (!rtlpriv->psc.swctrl_lps)
 		return;
@@ -583,9 +580,9 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 	}
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	mutex_lock(&rtlpriv->locks.lps_mutex);
 	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS);
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	mutex_unlock(&rtlpriv->locks.lps_mutex);
 }
 
 void rtl_swlps_rfon_wq_callback(void *data)
@@ -602,7 +599,6 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	unsigned long flag;
 	u8 sleep_intv;
 
 	if (!rtlpriv->psc.sw_ps_enabled)
@@ -626,9 +622,9 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	}
 	spin_unlock(&rtlpriv->locks.rf_ps_lock);
 
-	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	mutex_lock(&rtlpriv->locks.lps_mutex);
 	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS);
-	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+	mutex_unlock(&rtlpriv->locks.lps_mutex);
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
 	    !RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 5590d07d0918..7a1cb69b6ec8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -967,7 +967,6 @@ static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw,
 	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	if (ieee80211_is_auth(fc)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, "MAC80211_LINKING\n");
-		rtl_ips_nic_on(hw);
 	}
 
 	if (rtlpriv->psc.sw_ps_enabled) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 597f12025e6b..6c261b16a17d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2336,17 +2336,14 @@ struct rtl_hal_cfg {
 struct rtl_locks {
 	/* mutex */
 	struct mutex conf_mutex;
-	struct mutex ps_mutex;
+	struct mutex ips_mutex;	/* mutex for enter/leave IPS */
+	struct mutex lps_mutex;	/* mutex for enter/leave LPS */
 
 	/*spin lock */
-	spinlock_t ips_lock;
 	spinlock_t irq_th_lock;
-	spinlock_t irq_pci_lock;
-	spinlock_t tx_lock;
 	spinlock_t h2c_lock;
 	spinlock_t rf_ps_lock;
 	spinlock_t rf_lock;
-	spinlock_t lps_lock;
 	spinlock_t waitq_lock;
 	spinlock_t entry_list_lock;
 	spinlock_t usb_lock;
@@ -2359,9 +2356,6 @@ struct rtl_locks {
 	/*Dual mac*/
 	spinlock_t cck_and_rw_pagea_lock;
 
-	/*Easy concurrent*/
-	spinlock_t check_sendpkt_lock;
-
 	spinlock_t iqk_lock;
 };
 
-- 
2.12.3
