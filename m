Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab0LRBg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 20:36:28 -0500
Date: Fri, 17 Dec 2010 19:36:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix use of mutex in interrupt code
Message-ID: <4d0c1019.Ojk0z75BV563kcjY%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A previous conversion from semaphoreto mutexes missed the fact that one
of the semaphores was used in interrupt code. Fixed by changing to
a spinlock.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -309,8 +309,8 @@ int rtl_init_core(struct ieee80211_hw *h
 	}
 
 	/* <4> locks */
-	mutex_init(&rtlpriv->locks.ips_mutex);
 	mutex_init(&rtlpriv->locks.conf_mutex);
+	spin_lock_init(&rtlpriv->locks.ips_lock);
 	spin_lock_init(&rtlpriv->locks.irq_th_lock);
 	spin_lock_init(&rtlpriv->locks.h2c_lock);
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -286,8 +286,9 @@ void rtl_ips_nic_on(struct ieee80211_hw
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	enum rf_pwrstate rtstate;
+	unsigned long flags;
 
-	mutex_lock(&rtlpriv->locks.ips_mutex);
+	spin_lock_irqsave(&rtlpriv->locks.ips_lock, flags);
 
 	if (ppsc->b_inactiveps) {
 		rtstate = ppsc->rfpwr_state;
@@ -303,7 +304,7 @@ void rtl_ips_nic_on(struct ieee80211_hw
 		}
 	}
 
-	mutex_unlock(&rtlpriv->locks.ips_mutex);
+	spin_unlock_irqrestore(&rtlpriv->locks.ips_lock, flags);
 }
 
 /*for FW LPS*/
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1192,11 +1192,11 @@ struct rtl_hal_cfg {
 };
 
 struct rtl_locks {
-	/*sem */
-	struct mutex ips_mutex;
+	/* mutex */
 	struct mutex conf_mutex;
 
 	/*spin lock */
+	spinlock_t ips_lock;
 	spinlock_t irq_th_lock;
 	spinlock_t h2c_lock;
 	spinlock_t rf_ps_lock;
