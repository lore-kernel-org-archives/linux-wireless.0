Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:33700 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab1EYAkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 20:40:04 -0400
Received: by pxi16 with SMTP id 16so4725369pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 17:40:04 -0700 (PDT)
Message-ID: <4DDC4FCB.8090807@ring3k.org> (sfid-20110525_024014_667106_140E82FB)
Date: Wed, 25 May 2011 09:39:39 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] rtlwifi: Run IPS leave work in a tasklet
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the need to use IRQ safe spinlocks in many places.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c  |   14 ++++++++++++--
 drivers/net/wireless/rtlwifi/ps.c   |    1 +
 drivers/net/wireless/rtlwifi/wifi.h |    1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 5eedb91..fd74396 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -622,7 +622,7 @@ tx_status_ok:
 	if (((rtlpriv->link_info.num_rx_inperiod +
 		rtlpriv->link_info.num_tx_inperiod) > 8) ||
 		(rtlpriv->link_info.num_rx_inperiod > 2)) {
-		rtl_lps_leave(hw);
+		tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
 	}
 }
 
@@ -756,7 +756,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			if (((rtlpriv->link_info.num_rx_inperiod +
 				rtlpriv->link_info.num_tx_inperiod) > 8) ||
 				(rtlpriv->link_info.num_rx_inperiod > 2)) {
-				rtl_lps_leave(hw);
+				tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
 			}
 
 			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
@@ -934,6 +934,11 @@ static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
 	_rtl_pci_tx_chk_waitq(hw);
 }
 
+static void _rtl_pci_ips_leave_tasklet(struct ieee80211_hw *hw)
+{
+	rtl_lps_leave(hw);
+}
+
 static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1032,6 +1037,9 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
 		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
 		     (unsigned long)hw);
+	tasklet_init(&rtlpriv->works.ips_leave_tasklet,
+		     (void (*)(unsigned long))_rtl_pci_ips_leave_tasklet,
+		     (unsigned long)hw);
 }
 
 static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
@@ -1494,6 +1502,7 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
+	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
 
 	flush_workqueue(rtlpriv->works.rtl_wq);
 	destroy_workqueue(rtlpriv->works.rtl_wq);
@@ -1568,6 +1577,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	set_hal_stop(rtlhal);
 
 	rtlpriv->cfg->ops->disable_interrupt(hw);
+	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
 
 	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flags);
 	while (ppsc->rfchange_inprogress) {
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 39b0297..5552b8c 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -68,6 +68,7 @@ bool rtl_ps_disable_nic(struct ieee80211_hw *hw)
 
 	/*<2> Disable Interrupt */
 	rtlpriv->cfg->ops->disable_interrupt(hw);
+	tasklet_kill(&rtlpriv->works.irq_tasklet);
 
 	/*<3> Disable Adapter */
 	rtlpriv->cfg->ops->hw_disable(hw);
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 0321328..9d003e0 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1535,6 +1535,7 @@ struct rtl_works {
 	/* For SW LPS */
 	struct delayed_work ps_work;
 	struct delayed_work ps_rfon_wq;
+	struct tasklet_struct ips_leave_tasklet;
 };
 
 struct rtl_debug {
-- 
1.7.4.1


