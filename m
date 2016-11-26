Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32906 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbcKZUnm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Nov 2016 15:43:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: Fix enter/exit power_save
Date: Sat, 26 Nov 2016 14:43:35 -0600
Message-Id: <20161126204335.12847-1-Larry.Finger@lwfinger.net> (sfid-20161126_214346_343193_A05C51BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit a5ffbe0a1993 ("rtlwifi: Fix scheduling while atomic bug") and
commit a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter()
to use work queue"), an error was introduced in the power-save routines
due to the fact that leaving PS was delayed by the use of a work queue.

This problem is fixed by detecting if the enter or leave routines are
in interrupt mode. If so, the workqueue is used to place the request.
If in normal mode, the enter or leave routines are called directly.

Fixes: a269913c52ad ("rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter() to use work queue")
Reported-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
Kalle,

Please push this patch to 4.10. It fixes a long-standing bug.

Thanks,

Larry
---
 drivers/net/wireless/realtek/rtlwifi/base.c |  8 +++----
 drivers/net/wireless/realtek/rtlwifi/core.c |  9 +++-----
 drivers/net/wireless/realtek/rtlwifi/pci.c  | 14 ++++-------
 drivers/net/wireless/realtek/rtlwifi/ps.c   | 36 ++++++++++++++++++++++-------
 4 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 264466f..4ac928b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1303,12 +1303,13 @@ EXPORT_SYMBOL_GPL(rtl_action_proc);
 
 static void setup_arp_tx(struct rtl_priv *rtlpriv, struct rtl_ps_ctl *ppsc)
 {
+	struct ieee80211_hw *hw = rtlpriv->hw;
+
 	rtlpriv->ra.is_special_data = true;
 	if (rtlpriv->cfg->ops->get_btc_status())
 		rtlpriv->btcoexist.btc_ops->btc_special_packet_notify(
 					rtlpriv, 1);
-	rtlpriv->enter_ps = false;
-	schedule_work(&rtlpriv->works.lps_change_work);
+	rtl_lps_leave(hw);
 	ppsc->last_delaylps_stamp_jiffies = jiffies;
 }
 
@@ -1381,8 +1382,7 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 
 		if (is_tx) {
 			rtlpriv->ra.is_special_data = true;
-			rtlpriv->enter_ps = false;
-			schedule_work(&rtlpriv->works.lps_change_work);
+			rtl_lps_leave(hw);
 			ppsc->last_delaylps_stamp_jiffies = jiffies;
 		}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index e89681d..2caa4ad 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1150,10 +1150,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		} else {
 			mstatus = RT_MEDIA_DISCONNECT;
 
-			if (mac->link_state == MAC80211_LINKED) {
-				rtlpriv->enter_ps = false;
-				schedule_work(&rtlpriv->works.lps_change_work);
-			}
+			if (mac->link_state == MAC80211_LINKED)
+				rtl_lps_leave(hw);
 			if (ppsc->p2p_ps_info.p2p_ps_mode > P2P_PS_NONE)
 				rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
 			mac->link_state = MAC80211_NOLINK;
@@ -1431,8 +1429,7 @@ static void rtl_op_sw_scan_start(struct ieee80211_hw *hw,
 	}
 
 	if (mac->link_state == MAC80211_LINKED) {
-		rtlpriv->enter_ps = false;
-		schedule_work(&rtlpriv->works.lps_change_work);
+		rtl_lps_leave(hw);
 		mac->link_state = MAC80211_LINKED_SCANNING;
 	} else {
 		rtl_ips_nic_on(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index d044b23..8bfe020 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -659,11 +659,9 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 	}
 
 	if (((rtlpriv->link_info.num_rx_inperiod +
-		rtlpriv->link_info.num_tx_inperiod) > 8) ||
-		(rtlpriv->link_info.num_rx_inperiod > 2)) {
-		rtlpriv->enter_ps = false;
-		schedule_work(&rtlpriv->works.lps_change_work);
-	}
+	      rtlpriv->link_info.num_tx_inperiod) > 8) ||
+	      (rtlpriv->link_info.num_rx_inperiod > 2))
+		rtl_lps_leave(hw);
 }
 
 static int _rtl_pci_init_one_rxdesc(struct ieee80211_hw *hw,
@@ -914,10 +912,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		}
 		if (((rtlpriv->link_info.num_rx_inperiod +
 		      rtlpriv->link_info.num_tx_inperiod) > 8) ||
-		      (rtlpriv->link_info.num_rx_inperiod > 2)) {
-			rtlpriv->enter_ps = false;
-			schedule_work(&rtlpriv->works.lps_change_work);
-		}
+		      (rtlpriv->link_info.num_rx_inperiod > 2))
+			rtl_lps_leave(hw);
 		skb = new_skb;
 no_new:
 		if (rtlpriv->use_new_trx_flow) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 18d979a..d0ffc4d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -407,8 +407,8 @@ void rtl_lps_set_psmode(struct ieee80211_hw *hw, u8 rt_psmode)
 	}
 }
 
-/*Enter the leisure power save mode.*/
-void rtl_lps_enter(struct ieee80211_hw *hw)
+/* Interrupt safe routine to enter the leisure power save mode.*/
+static void rtl_lps_enter_core(struct ieee80211_hw *hw)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -444,10 +444,9 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
-EXPORT_SYMBOL(rtl_lps_enter);
 
-/*Leave the leisure power save mode.*/
-void rtl_lps_leave(struct ieee80211_hw *hw)
+/* Interrupt safe routine to leave the leisure power save mode.*/
+static void rtl_lps_leave_core(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -477,7 +476,6 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
-EXPORT_SYMBOL(rtl_lps_leave);
 
 /* For sw LPS*/
 void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
@@ -670,12 +668,34 @@ void rtl_lps_change_work_callback(struct work_struct *work)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->enter_ps)
-		rtl_lps_enter(hw);
+		rtl_lps_enter_core(hw);
 	else
-		rtl_lps_leave(hw);
+		rtl_lps_leave_core(hw);
 }
 EXPORT_SYMBOL_GPL(rtl_lps_change_work_callback);
 
+void rtl_lps_enter(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (!in_interrupt())
+		return rtl_lps_enter_core(hw);
+	rtlpriv->enter_ps = true;
+	schedule_work(&rtlpriv->works.lps_change_work);
+}
+EXPORT_SYMBOL_GPL(rtl_lps_enter);
+
+void rtl_lps_leave(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (!in_interrupt())
+		return rtl_lps_leave_core(hw);
+	rtlpriv->enter_ps = false;
+	schedule_work(&rtlpriv->works.lps_change_work);
+}
+EXPORT_SYMBOL_GPL(rtl_lps_leave);
+
 void rtl_swlps_wq_callback(void *data)
 {
 	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
-- 
2.10.0
