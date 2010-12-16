Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65345 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab0LPRKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 12:10:43 -0500
Date: Thu, 16 Dec 2010 11:10:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Switch ;ocking from semaphores to mutexes
Message-ID: <4d0a4810.D27sZkvOxusWnOXl%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This change was requested by Johannes.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -309,8 +309,8 @@ int rtl_init_core(struct ieee80211_hw *h
 	}
 
 	/* <4> locks */
-	sema_init(&rtlpriv->locks.ips_sem, 1);
-	sema_init(&rtlpriv->locks.conf_sem, 1);
+	mutex_init(&rtlpriv->locks.ips_mutex);
+	mutex_init(&rtlpriv->locks.conf_mutex);
 	spin_lock_init(&rtlpriv->locks.irq_th_lock);
 	spin_lock_init(&rtlpriv->locks.h2c_lock);
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c
@@ -43,13 +43,13 @@ static int rtl_op_start(struct ieee80211
 		return 0;
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		return 0;
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 	err = rtlpriv->intf_ops->adapter_start(hw);
 	if (err)
 		goto out;
 	rtl_watch_dog_timer_callback((unsigned long)hw);
 out:
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	return err;
 }
 
@@ -68,7 +68,7 @@ static void rtl_op_stop(struct ieee80211
 		mdelay(1);
 	}
 
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 
 	mac->link_state = MAC80211_NOLINK;
 	memset(mac->bssid, 0, 6);
@@ -79,7 +79,7 @@ static void rtl_op_stop(struct ieee80211
 	rtl_deinit_deferred_work(hw);
 	rtlpriv->intf_ops->adapter_stop(hw);
 
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
 static int rtl_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -119,7 +119,7 @@ static int rtl_op_add_interface(struct i
 
 	rtl_ips_nic_on(hw);
 
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		if (mac->beacon_enabled == 1) {
@@ -156,7 +156,7 @@ static int rtl_op_add_interface(struct i
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 
 out:
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	return err;
 }
 
@@ -166,7 +166,7 @@ static void rtl_op_remove_interface(stru
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 
 	/* Free beacon resources */
 	if ((mac->opmode == NL80211_IFTYPE_AP) ||
@@ -190,7 +190,7 @@ static void rtl_op_remove_interface(stru
 	mac->opmode = NL80211_IFTYPE_UNSPECIFIED;
 	rtlpriv->cfg->ops->set_network_type(hw, mac->opmode);
 
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
 
@@ -202,7 +202,7 @@ static int rtl_op_config(struct ieee8021
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct ieee80211_conf *conf = &hw->conf;
 
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {	/*BIT(2)*/
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 ("IEEE80211_CONF_CHANGE_LISTEN_INTERVAL\n"));
@@ -303,7 +303,7 @@ static int rtl_op_config(struct ieee8021
 					       hw->conf.channel_type);
 	}
 
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 
 	return 0;
 }
@@ -450,7 +450,7 @@ static void rtl_op_bss_info_changed(stru
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 
 	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
 	    (vif->type == NL80211_IFTYPE_AP) ||
@@ -700,7 +700,7 @@ static void rtl_op_bss_info_changed(stru
 	}
 
 out:
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
 static u64 rtl_op_get_tsf(struct ieee80211_hw *hw)
@@ -852,7 +852,7 @@ static int rtl_op_set_key(struct ieee802
 		  sta ? sta->addr : bcast_addr));
 	rtlpriv->sec.being_setkey = true;
 	rtl_ips_nic_on(hw);
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 	/* <1> get encryption alg */
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -970,7 +970,7 @@ static int rtl_op_set_key(struct ieee802
 			 ("cmd_err:%x!!!!:\n", cmd));
 	}
 out_unlock:
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	rtlpriv->sec.being_setkey = false;
 	return err;
 }
@@ -986,7 +986,7 @@ static void rtl_op_rfkill_poll(struct ie
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		return;
 
-	down(&rtlpriv->locks.conf_sem);
+	mutex_lock(&rtlpriv->locks.conf_mutex);
 
 	/*if Radio On return true here */
 	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
@@ -1004,7 +1004,7 @@ static void rtl_op_rfkill_poll(struct ie
 		}
 	}
 
-	up(&rtlpriv->locks.conf_sem);
+	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
 const struct ieee80211_ops rtl_ops = {
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -287,7 +287,7 @@ void rtl_ips_nic_on(struct ieee80211_hw
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	enum rf_pwrstate rtstate;
 
-	down(&rtlpriv->locks.ips_sem);
+	mutex_lock(&rtlpriv->locks.ips_mutex);
 
 	if (ppsc->b_inactiveps) {
 		rtstate = ppsc->rfpwr_state;
@@ -303,7 +303,7 @@ void rtl_ips_nic_on(struct ieee80211_hw
 		}
 	}
 
-	up(&rtlpriv->locks.ips_sem);
+	mutex_unlock(&rtlpriv->locks.ips_mutex);
 }
 
 /*for FW LPS*/
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1193,8 +1193,8 @@ struct rtl_hal_cfg {
 
 struct rtl_locks {
 	/*sem */
-	struct semaphore ips_sem;
-	struct semaphore conf_sem;
+	struct mutex ips_mutex;
+	struct mutex conf_mutex;
 
 	/*spin lock */
 	spinlock_t irq_th_lock;
