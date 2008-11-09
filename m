Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38839 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbYKIPoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 10:44:20 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA9FiBPK029197
	for <linux-wireless@vger.kernel.org>; Sun, 9 Nov 2008 09:44:19 -0600
Received: from localhost.localdomain (essapo-nirac252197.europe.nokia.com [10.162.252.197])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA9Fi1i7014022
	for <linux-wireless@vger.kernel.org>; Sun, 9 Nov 2008 17:44:11 +0200
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] mac80211: implement dynamic power save
Date: Sun,  9 Nov 2008 17:43:59 +0200
Message-Id: <1226245439-30329-3-git-send-email-kalle.valo@nokia.com> (sfid-20081109_164424_115149_4F11A949)
In-Reply-To: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable power save only after an idle transmit timeout. The timeout can
be enabled with:

iwconfig wlan0 power timeout 500m

Thanks to Johannes Berg for the help with the design.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/ieee80211_i.h |    9 +++++++++
 net/mac80211/main.c        |    5 +++++
 net/mac80211/mlme.c        |   43 +++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/tx.c          |   18 ++++++++++++++++++
 net/mac80211/wext.c        |    8 ++++++--
 5 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3f25955..ab0e2df 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -688,7 +688,12 @@ struct ieee80211_local {
 				*/
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
+
 	bool powersave;
+	int dynamic_ps_timeout;
+	struct work_struct ps_enable_work;
+	struct work_struct ps_disable_work;
+	struct timer_list dynamic_ps_timer;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
@@ -973,6 +978,10 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
 
+void ieee80211_ps_enable_work(struct work_struct *work);
+void ieee80211_ps_disable_work(struct work_struct *work);
+void ieee80211_dynamic_ps_timer(unsigned long data);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d631dc9..1336f24 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -701,6 +701,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
+	INIT_WORK(&local->ps_enable_work, ieee80211_ps_enable_work);
+	INIT_WORK(&local->ps_disable_work, ieee80211_ps_disable_work);
+	setup_timer(&local->dynamic_ps_timer,
+		    ieee80211_dynamic_ps_timer, (unsigned long) local);
+
 	sta_info_init(local);
 
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5a48b2b..c897723 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -748,8 +748,14 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	if (local->powersave) {
-		local->hw.conf.flags |= IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		if (local->dynamic_ps_timeout > 0)
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(local->dynamic_ps_timeout));
+		else {
+			conf->flags |= IEEE80211_CONF_PS;
+			ieee80211_hw_config(local,
+					    IEEE80211_CONF_CHANGE_PS);
+		}
 	}
 
 	netif_tx_start_all_queues(sdata->dev);
@@ -2620,3 +2626,36 @@ void ieee80211_notify_mac(struct ieee80211_hw *hw,
 	}
 }
 EXPORT_SYMBOL(ieee80211_notify_mac);
+
+void ieee80211_ps_enable_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, ps_enable_work);
+
+	if (local->hw.conf.flags && IEEE80211_CONF_PS)
+		return;
+
+	local->hw.conf.flags |= IEEE80211_CONF_PS;
+
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+}
+
+void ieee80211_ps_disable_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, ps_disable_work);
+
+	if (!(local->hw.conf.flags && IEEE80211_CONF_PS))
+		return;
+
+	local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+}
+
+void ieee80211_dynamic_ps_timer(unsigned long data)
+{
+	struct ieee80211_local *local = (void *) data;
+
+	queue_work(local->hw.workqueue, &local->ps_enable_work);
+}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0855cac..7a08b0f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -181,6 +181,23 @@ static int inline is_ieee80211_device(struct ieee80211_local *local,
 /* tx handlers */
 
 static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_local *local = tx->local;
+
+	if (local->dynamic_ps_timeout == 0)
+		return TX_CONTINUE;
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS)
+		queue_work(local->hw.workqueue, &local->ps_disable_work);
+
+	mod_timer(&local->dynamic_ps_timer, jiffies +
+		  msecs_to_jiffies(local->dynamic_ps_timeout));
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
 
@@ -1105,6 +1122,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 		goto txh_done;
 
 	CALL_TXH(ieee80211_tx_h_check_assoc)
+	CALL_TXH(ieee80211_tx_h_dynamic_ps)
 	CALL_TXH(ieee80211_tx_h_ps_buf)
 	CALL_TXH(ieee80211_tx_h_select_key)
 	CALL_TXH(ieee80211_tx_h_michael_mic_add)
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index febcd41..2814fef 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -954,6 +954,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 
 	if (wrq->disabled) {
 		ps = false;
+		local->dynamic_ps_timeout = 0;
 		goto set;
 	}
 
@@ -963,10 +964,13 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 	case IW_POWER_ALL_R:    /* If explicitely state all */
 		ps = true;
 		break;
-	default:                /* Otherwise we don't support it */
-		return -EINVAL;
+	default:                /* Otherwise we ignore */
+		break;
 	}
 
+	if (wrq->flags & IW_POWER_TIMEOUT)
+		local->dynamic_ps_timeout = wrq->value / 1000;
+
 	if (ps == local->powersave)
 		return ret;
 
-- 
1.5.6.5

