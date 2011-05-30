Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54174 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1E3Xt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 19:49:29 -0400
Received: by pwi15 with SMTP id 15so1804309pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 16:49:28 -0700 (PDT)
Message-ID: <4DE42D03.4050407@ring3k.org> (sfid-20110531_014933_003836_B6D95301)
Date: Tue, 31 May 2011 08:49:23 +0900
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
index b44de0d..6c1b9df 100644
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
 
@@ -766,7 +766,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			if (((rtlpriv->link_info.num_rx_inperiod +
 				rtlpriv->link_info.num_tx_inperiod) > 8) ||
 				(rtlpriv->link_info.num_rx_inperiod > 2)) {
-				rtl_lps_leave(hw);
+				tasklet_schedule(&rtlpriv->works.ips_leave_tasklet);
 			}
 
 			skb = new_skb;
@@ -936,6 +936,11 @@ static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
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
@@ -1034,6 +1039,9 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
 		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
 		     (unsigned long)hw);
+	tasklet_init(&rtlpriv->works.ips_leave_tasklet,
+		     (void (*)(unsigned long))_rtl_pci_ips_leave_tasklet,
+		     (unsigned long)hw);
 }
 
 static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
@@ -1503,6 +1511,7 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
+	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
 
 	flush_workqueue(rtlpriv->works.rtl_wq);
 	destroy_workqueue(rtlpriv->works.rtl_wq);
@@ -1577,6 +1586,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
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


