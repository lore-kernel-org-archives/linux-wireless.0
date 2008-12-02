Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43902 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYLBUEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:04:16 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mB2K4CTo008554
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:13 +0200
Received: from [127.0.1.1] (essapo-nirac253161.europe.nokia.com [10.162.253.161])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mB2K461G027284
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:06 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v4 2/5] mac80211: implement dynamic power save
To: linux-wireless@vger.kernel.org
Date: Tue, 02 Dec 2008 22:04:06 +0200
Message-ID: <20081202200405.5507.54920.stgit@tikku> (sfid-20081202_210418_892841_CF9EA543)
In-Reply-To: <20081202200219.5507.83250.stgit@tikku>
References: <20081202200219.5507.83250.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements dynamic power save for mac80211. Basically it
means enabling power save mode after an idle period. Implementing it
dynamically gives a good compromise of low power consumption and low
latency. Some hardware have support for this in firmware, but some
require the host to do it.

The dynamic power save is implemented by adding an timeout to
ieee80211_subif_start_xmit(). The timeout can be enabled from userspace
with Wireless Extensions. For example, the command below enables the
dynamic power save and sets the time timeout to 500 ms:

iwconfig wlan0 power timeout 500m

Power save now only works with devices which handle power save in firmware.
It's also disabled by default and the heuristics when and how to enable is
considered as a policy decision and will be left for the userspace to handle.

Thanks to Johannes Berg for the help with the design.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |    9 ++++++++
 net/mac80211/main.c        |    7 ++++++
 net/mac80211/mlme.c        |   49 ++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/tx.c          |   11 ++++++++++
 net/mac80211/wext.c        |   29 +++++++++++++++++---------
 5 files changed, 93 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3f25955..83b4b08 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -688,7 +688,12 @@ struct ieee80211_local {
 				*/
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
+
 	bool powersave;
+	int dynamic_ps_timeout;
+	struct work_struct dynamic_ps_enable_work;
+	struct work_struct dynamic_ps_disable_work;
+	struct timer_list dynamic_ps_timer;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
@@ -973,6 +978,10 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
 
+void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
+void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
+void ieee80211_dynamic_ps_timer(unsigned long data);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index cec9b6d..bebdd48 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -701,6 +701,13 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
+	INIT_WORK(&local->dynamic_ps_enable_work,
+		  ieee80211_dynamic_ps_enable_work);
+	INIT_WORK(&local->dynamic_ps_disable_work,
+		  ieee80211_dynamic_ps_disable_work);
+	setup_timer(&local->dynamic_ps_timer,
+		    ieee80211_dynamic_ps_timer, (unsigned long) local);
+
 	sta_info_init(local);
 
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e7ade66..ee71b12 100644
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
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		config_changed |= IEEE80211_CONF_PS;
@@ -2608,3 +2617,39 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 		ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
 }
+
+void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local,
+			     dynamic_ps_disable_work);
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
+void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local,
+			     dynamic_ps_enable_work);
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
+	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
+}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0855cac..60cbc28 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1476,6 +1476,17 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
+	if (local->dynamic_ps_timeout > 0) {
+		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+			netif_tx_stop_all_queues(local->mdev);
+			queue_work(local->hw.workqueue,
+				   &local->dynamic_ps_disable_work);
+		}
+
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(local->dynamic_ps_timeout));
+	}
+
 	nh_pos = skb_network_header(skb) - skb->data;
 	h_pos = skb_transport_header(skb) - skb->data;
 
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index b095697..8815858 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -956,11 +956,12 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
-	int ret = 0;
+	int ret = 0, timeout = 0;
 	bool ps;
 
 	if (wrq->disabled) {
 		ps = false;
+		timeout = 0;
 		goto set;
 	}
 
@@ -970,25 +971,33 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 	case IW_POWER_ALL_R:    /* If explicitely state all */
 		ps = true;
 		break;
-	default:                /* Otherwise we don't support it */
-		return -EINVAL;
+	default:                /* Otherwise we ignore */
+		break;
 	}
 
-	if (ps == local->powersave)
-		return ret;
+	if (wrq->flags & IW_POWER_TIMEOUT)
+		timeout = wrq->value / 1000;
 
 set:
+	if (ps == local->powersave && timeout == local->dynamic_ps_timeout)
+		return ret;
+
 	local->powersave = ps;
+	local->dynamic_ps_timeout = timeout;
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return ret;
 
 	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
-		if (local->powersave)
-			conf->flags |= IEEE80211_CONF_PS;
-		else
-			conf->flags &= ~IEEE80211_CONF_PS;
-
+		if (local->dynamic_ps_timeout > 0)
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(local->dynamic_ps_timeout));
+		else {
+			if (local->powersave)
+				conf->flags |= IEEE80211_CONF_PS;
+			else
+				conf->flags &= ~IEEE80211_CONF_PS;
+		}
 		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 

