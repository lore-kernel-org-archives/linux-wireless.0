Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18565 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYK1Tt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 14:49:57 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mASJne8l025373
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 13:49:54 -0600
Received: from localhost.localdomain (essapo-nirac25338.europe.nokia.com [10.162.253.38])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mASJnjSi003187
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 21:49:48 +0200
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC v3 2/4] mac80211: implement dynamic power save
Date: Fri, 28 Nov 2008 21:49:42 +0200
Message-Id: <1227901784-5325-3-git-send-email-kalle.valo@nokia.com> (sfid-20081128_205007_402908_98B496DF)
In-Reply-To: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements dynamic power save for mac80211. Basically it
means enabling power save mode after an idle period. Implementing it
dynamically gives a good compromise of low power consumption and low
latency. Some hardware have support for this in firmware, but some
require the host to do it.

The dynamic power save is implemented by adding an timeout to
ieee80211_subif_start_xmit(). The timeout can be enabled from user space
with Wireless Extensions. For example, the command below enables the
dynamic power save and sets the time timeout to 500 ms:

iwconfig wlan0 power timeout 500m

Thanks to Johannes Berg for the help with the design.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/ieee80211_i.h |    9 ++++++++
 net/mac80211/main.c        |    5 ++++
 net/mac80211/mlme.c        |   47 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/tx.c          |   11 ++++++++++
 net/mac80211/wext.c        |   27 ++++++++++++++++--------
 5 files changed, 88 insertions(+), 11 deletions(-)

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
index cec9b6d..b35bd74 100644
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
index e7ade66..1d3c72b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -747,8 +747,14 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
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
@@ -875,6 +881,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	local->hw.conf.ht.enabled = false;
 	config_changed |= IEEE80211_CONF_CHANGE_HT;
 
+	del_timer_sync(&local->dynamic_ps_timer);
+	cancel_work_sync(&local->ps_enable_work);
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		config_changed |= IEEE80211_CONF_PS;
@@ -2608,3 +2617,37 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 		ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
 }
+
+void ieee80211_ps_disable_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, ps_disable_work);
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+
+	/* always wake queues to avoid having them stopped forever */
+	netif_tx_wake_all_queues(local->mdev);
+}
+
+void ieee80211_ps_enable_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, ps_enable_work);
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS)
+		return;
+
+	local->hw.conf.flags |= IEEE80211_CONF_PS;
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
index 0855cac..25d4a86 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1476,6 +1476,17 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
+	if (local->dynamic_ps_timeout > 0) {
+		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+			netif_tx_stop_all_queues(local->mdev);
+			queue_work(local->hw.workqueue,
+				   &local->ps_disable_work);
+		}
+
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(local->dynamic_ps_timeout));
+	}
+
 	nh_pos = skb_network_header(skb) - skb->data;
 	h_pos = skb_transport_header(skb) - skb->data;
 
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 8329de2..b3ee0dc 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -962,6 +962,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 
 	if (wrq->disabled) {
 		ps = false;
+		local->dynamic_ps_timeout = 0;
 		goto set;
 	}
 
@@ -971,23 +972,31 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
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
 
 set:
 	local->powersave = ps;
 
-	if (ifsta->flags && IEEE80211_STA_ASSOCIATED) {
-		if (local->powersave)
-			conf->flags |= IEEE80211_CONF_PS;
-		else
-			conf->flags &= ~IEEE80211_CONF_PS;
-
-		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	if (ifsta->flags & IEEE80211_STA_ASSOCIATED) {
+		if (local->dynamic_ps_timeout > 0)
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(local->dynamic_ps_timeout));
+		else {
+			if (local->powersave)
+				conf->flags |= IEEE80211_CONF_PS;
+			else
+				conf->flags &= ~IEEE80211_CONF_PS;
+			ret = ieee80211_hw_config(local,
+						  IEEE80211_CONF_CHANGE_PS);
+		}
 	}
 
 	return ret;
-- 
1.5.6.5

