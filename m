Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab1LHJwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:52:25 -0500
Date: Thu, 8 Dec 2011 10:52:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Philipp Dreimann <philipp@dreimann.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, mikem@ring3k.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rtlwifi, rtl8192se bug soft-lockup
Message-ID: <20111208095212.GB2402@redhat.com> (sfid-20111208_105231_145126_04BC145B)
References: <CADYPuQ7W2B9HjR_TiV=dhD3vW-3pR4Y+s_9oJzTC-CdL+hr=9w@mail.gmail.com>
 <4ED44089.7010102@lwfinger.net>
 <CADYPuQ61D997MA2JCw1WD_xOosaKvaWK-_RHeBkLtabydDj2iw@mail.gmail.com>
 <4EDFA124.7010804@lwfinger.net>
 <CADYPuQ5io_nKkzqwY3uM5bre-bfUvrmH080MBpwqYpNeot5yHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <CADYPuQ5io_nKkzqwY3uM5bre-bfUvrmH080MBpwqYpNeot5yHA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2011 at 06:47:58PM -0200, Philipp Dreimann wrote:
> No, this was not posted so far. I will try to debug the loop issue
> soonish. The outlined idea above only prevents the issue without
> knowing what is happening.

I looked at it a bit more and realized that we can replace spinlock
by mutex. This should fix remaining problems here, and hopefully do
not introduce any others. Could you test two attached patches, and
if they do not crash intermediately :-) retest again with
CONFIG_LOCKDEP ?

Thanks
Stanislaw

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-rtlwifi-use-work-for-lps.patch"

>From ed41f99b001b31066f44d36898ff3e30642567c0 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 8 Dec 2011 10:34:41 +0100
Subject: [PATCH 1/2] rtlwifi: use work for lps

---
 drivers/net/wireless/rtlwifi/pci.c  |   26 ++++++++++++++------------
 drivers/net/wireless/rtlwifi/wifi.h |    3 ++-
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index b6683a2..c1ac2a9 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -610,7 +610,7 @@ tx_status_ok:
 	if (((rtlpriv->link_info.num_rx_inperiod +
 		rtlpriv->link_info.num_tx_inperiod) > 8) ||
 		(rtlpriv->link_info.num_rx_inperiod > 2)) {
-		tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
+		schedule_work(&rtlpriv->works.lps_leave_work);
 	}
 }
 
@@ -736,7 +736,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		if (((rtlpriv->link_info.num_rx_inperiod +
 			rtlpriv->link_info.num_tx_inperiod) > 8) ||
 			(rtlpriv->link_info.num_rx_inperiod > 2)) {
-			tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
+			schedule_work(&rtlpriv->works.lps_leave_work);
 		}
 
 		dev_kfree_skb_any(skb);
@@ -900,11 +900,6 @@ static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
 	_rtl_pci_tx_chk_waitq(hw);
 }
 
-static void _rtl_pci_ips_leave_tasklet(struct ieee80211_hw *hw)
-{
-	rtl_lps_leave(hw);
-}
-
 static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -942,6 +937,15 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 	return;
 }
 
+static void rtl_lps_leave_work_callback(struct work_struct *work)
+{
+	struct rtl_works *rtlworks =
+	    container_of(work, struct rtl_works, lps_leave_work);
+	struct ieee80211_hw *hw = rtlworks->hw;
+
+	rtl_lps_leave(hw);
+}
+
 static void _rtl_pci_init_trx_var(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1003,9 +1007,7 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
 		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
 		     (unsigned long)hw);
-	tasklet_init(&rtlpriv->works.ips_leave_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_ips_leave_tasklet,
-		     (unsigned long)hw);
+	INIT_WORK(&rtlpriv->works.lps_leave_work, rtl_lps_leave_work_callback);
 }
 
 static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
@@ -1475,7 +1477,7 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
-	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
+	cancel_work_sync(&rtlpriv->works.lps_leave_work);
 
 	flush_workqueue(rtlpriv->works.rtl_wq);
 	destroy_workqueue(rtlpriv->works.rtl_wq);
@@ -1550,7 +1552,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	set_hal_stop(rtlhal);
 
 	rtlpriv->cfg->ops->disable_interrupt(hw);
-	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
+	cancel_work_sync(&rtlpriv->works.lps_leave_work);
 
 	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flags);
 	while (ppsc->rfchange_inprogress) {
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index f3c132b..6e6353b 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1576,7 +1576,8 @@ struct rtl_works {
 	/* For SW LPS */
 	struct delayed_work ps_work;
 	struct delayed_work ps_rfon_wq;
-	struct tasklet_struct ips_leave_tasklet;
+
+	struct work_struct lps_leave_work;
 };
 
 struct rtl_debug {
-- 
1.7.1


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-rtlwifi-merge-ips-lps-spinlocks-into-one-mutex.patch"

>From 8d2a9ff16d466d6dff638393095029e670625301 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 8 Dec 2011 10:48:09 +0100
Subject: [PATCH 2/2] rtlwifi: merge ips,lps spinlocks into one mutex

---
 drivers/net/wireless/rtlwifi/base.c |    3 +--
 drivers/net/wireless/rtlwifi/ps.c   |   20 ++++++++++----------
 drivers/net/wireless/rtlwifi/wifi.h |    3 +--
 3 files changed, 12 insertions(+), 14 deletions(-)

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
index db52628..a14a68b 100644
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
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 
 	/* Idle for a while if we connect to AP a while ago. */
 	if (mac->cnt_after_linked >= 2) {
@@ -407,7 +407,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 		}
 	}
 
-	spin_unlock(&rtlpriv->locks.lps_lock);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 }
 
 /*Leave the leisure power save mode.*/
@@ -417,7 +417,7 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 
 	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
@@ -438,7 +438,7 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 			rtl_lps_set_psmode(hw, EACTIVE);
 		}
 	}
-	spin_unlock(&rtlpriv->locks.lps_lock);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 }
 
 /* For sw LPS*/
@@ -539,9 +539,9 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 	}
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS);
-	spin_unlock(&rtlpriv->locks.lps_lock);
+	mutex_unlock(&rtlpriv->locks.ps_mutex);
 }
 
 void rtl_swlps_rfon_wq_callback(void *data)
@@ -574,9 +574,9 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	if (rtlpriv->link_info.busytraffic)
 		return;
 
-	spin_lock(&rtlpriv->locks.lps_lock);
+	mutex_lock(&rtlpriv->locks.ps_mutex);
 	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS);
-	spin_unlock(&rtlpriv->locks.lps_lock);
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


--J/dobhs11T7y2rNN--
