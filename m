Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38968 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbYLRVRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:17:19 -0500
Received: from esebh107.NOE.Nokia.com (esebh107.ntc.nokia.com [172.21.143.143])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mBILHEun028754
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 15:17:15 -0600
Received: from [127.0.1.1] (essapo-nirac25252.europe.nokia.com [10.162.252.52])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mBILHCoq008888
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 23:17:12 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v5 3/3] mac80211: implement dynamic power save
To: linux-wireless@vger.kernel.org
Date: Thu, 18 Dec 2008 23:17:12 +0200
Message-ID: <20081218211712.6842.98402.stgit@tikku> (sfid-20081218_221727_688611_C7676A25)
In-Reply-To: <20081218211532.6842.88104.stgit@tikku>
References: <20081218211532.6842.88104.stgit@tikku>
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
In case the firmware has support for this, drivers can disable this feature
with IEEE80211_HW_NO_STACK_DYNAMIC_PS.

Big thanks to Johannes Berg for the help with the design and code.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/mac80211.h     |    6 +++++
 net/mac80211/ieee80211_i.h |   10 +++++++++
 net/mac80211/main.c        |    7 ++++++
 net/mac80211/mlme.c        |   49 ++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/tx.c          |   13 ++++++++++++
 net/mac80211/wext.c        |   30 ++++++++++++++++++---------
 6 files changed, 103 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9428d3e..b3bd00a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -854,6 +854,11 @@ enum ieee80211_tkip_key_type {
  *
  * @IEEE80211_HW_AMPDU_AGGREGATION:
  *	Hardware supports 11n A-MPDU aggregation.
+ *
+ * @IEEE80211_HW_NO_STACK_DYNAMIC_PS:
+ *	Hardware which has dynamic power save support, meaning
+ *	that power save is enabled in idle periods, and don't need support
+ *	from stack.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -866,6 +871,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_NOISE_DBM				= 1<<8,
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
+	IEEE80211_HW_NO_STACK_DYNAMIC_PS		= 1<<11,
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a74d673..f3eec98 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -540,6 +540,7 @@ enum {
 
 enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_DRIVER,
+	IEEE80211_QUEUE_STOP_REASON_PS,
 };
 
 /* maximum number of hardware queues we support. */
@@ -693,7 +694,12 @@ struct ieee80211_local {
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
@@ -977,6 +983,10 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
 
+void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
+void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
+void ieee80211_dynamic_ps_timer(unsigned long data);
+
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7c6e90a..a4f413e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -728,6 +728,13 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
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
index 96493e2..b63b934 100644
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
@@ -872,6 +878,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	config_changed |= IEEE80211_CONF_CHANGE_HT;
 
+	del_timer_sync(&local->dynamic_ps_timer);
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		config_changed |= IEEE80211_CONF_PS;
@@ -2620,3 +2629,39 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
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
+	ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_QUEUE_STOP_REASON_PS);
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
index 22702e7..27474cf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1475,6 +1475,19 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
+	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
+	    local->dynamic_ps_timeout > 0) {
+		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+			ieee80211_stop_queues_by_reason(&local->hw,
+							IEEE80211_QUEUE_STOP_REASON_PS);
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
index f6640d0..7162d58 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -833,7 +833,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
-	int ret = 0;
+	int ret = 0, timeout = 0;
 	bool ps;
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
@@ -841,6 +841,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 
 	if (wrq->disabled) {
 		ps = false;
+		timeout = 0;
 		goto set;
 	}
 
@@ -850,22 +851,31 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
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
 
 	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
-		if (local->powersave)
-			conf->flags |= IEEE80211_CONF_PS;
-		else
-			conf->flags &= ~IEEE80211_CONF_PS;
-
+		if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
+		    local->dynamic_ps_timeout > 0)
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
 

