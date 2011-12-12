Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab1LLLnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 06:43:55 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Mike McCormack <mikem@ring3k.org>
Subject: [PATCH 1/2] rtlwifi: use work for lps
Date: Mon, 12 Dec 2011 12:43:23 +0100
Message-Id: <1323690204-5124-1-git-send-email-sgruszka@redhat.com> (sfid-20111212_124359_456417_91ADAFB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Leaving leisure power save mode can take some time, so it's better to
perform that action in process context with interrupts enabled. This
patch changes lps_leave tasklet to work.

Reported-by: Philipp Dreimann <philipp@dreimann.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mike McCormack <mikem@ring3k.org>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rtlwifi/pci.c  |   26 ++++++++++++++------------
 drivers/net/wireless/rtlwifi/wifi.h |    3 ++-
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 91f0525..0d4d242 100644
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
@@ -903,11 +903,6 @@ static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
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
@@ -945,6 +940,15 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
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
@@ -1006,9 +1010,7 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
 		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
 		     (unsigned long)hw);
-	tasklet_init(&rtlpriv->works.ips_leave_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_ips_leave_tasklet,
-		     (unsigned long)hw);
+	INIT_WORK(&rtlpriv->works.lps_leave_work, rtl_lps_leave_work_callback);
 }
 
 static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
@@ -1478,7 +1480,7 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
-	tasklet_kill(&rtlpriv->works.ips_leave_tasklet);
+	cancel_work_sync(&rtlpriv->works.lps_leave_work);
 
 	flush_workqueue(rtlpriv->works.rtl_wq);
 	destroy_workqueue(rtlpriv->works.rtl_wq);
@@ -1553,7 +1555,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
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

