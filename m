Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZDORS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 13:18:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Lu8kk-0002S7-88
	for linux-wireless@vger.kernel.org; Wed, 15 Apr 2009 19:18:26 +0200
Message-Id: <20090415171633.290542228@sipsolutions.net> (sfid-20090415_191832_146371_F295D803)
References: <20090415171046.336006351@sipsolutions.net>
Date: Wed, 15 Apr 2009 19:10:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/3] mac80211: improve powersave implementation
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When you have multiple virtual interfaces the current
implementation requires setting them up properly from
userspace, which is undesirable when we want to default
to power save mode. Keep track of powersave requested
from userspace per managed mode interface, and only
enable powersave globally when exactly one managed mode
interface is active and has powersave turned on.

Secondly, only start the dynPS timer when PS is turned
on, and properly turn it off when PS is turned off.

Finally, also reorder the code and refactor the code
that enables PS or the dynps timer instead of having
it copied in two places.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    5 
 net/mac80211/iface.c       |    4 
 net/mac80211/mlme.c        |  230 ++++++++++++++++++++++++++++-----------------
 net/mac80211/wext.c        |   43 +-------
 4 files changed, 163 insertions(+), 119 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-15 15:38:57.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-15 18:56:33.000000000 +0200
@@ -295,6 +295,8 @@ struct ieee80211_if_managed {
 	int auth_tries; /* retries for auth req */
 	int assoc_tries; /* retries for assoc req */
 
+	bool powersave; /* powersave requested for this iface */
+
 	unsigned long request;
 
 	unsigned long last_probe;
@@ -739,7 +741,7 @@ struct ieee80211_local {
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
-	bool powersave;
+	bool powersave; /* ps enabled -- only one mgd iface with ps on */
 	bool pspolling;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
@@ -932,6 +934,7 @@ int ieee80211_sta_deauthenticate(struct 
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
+void ieee80211_recalc_ps(struct ieee80211_local *local);
 
 /* IBSS code */
 int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata);
--- wireless-testing.orig/net/mac80211/iface.c	2009-04-15 15:38:47.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-04-15 18:56:33.000000000 +0200
@@ -317,6 +317,8 @@ static int ieee80211_open(struct net_dev
 		ieee80211_set_wmm_default(sdata);
 	}
 
+	ieee80211_recalc_ps(local);
+
 	/*
 	 * ieee80211_sta_work is disabled while network interface
 	 * is down. Therefore, some configuration changes may not
@@ -572,6 +574,8 @@ static int ieee80211_stop(struct net_dev
 		hw_reconf_flags = 0;
 	}
 
+	ieee80211_recalc_ps(local);
+
 	/* do after stop to avoid reconfiguring when we stop anyway */
 	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
--- wireless-testing.orig/net/mac80211/wext.c	2009-04-15 15:38:47.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-15 18:56:37.000000000 +0200
@@ -747,7 +747,7 @@ static int ieee80211_ioctl_siwpower(stru
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
-	int ret = 0, timeout = 0;
+	int timeout = 0;
 	bool ps;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
@@ -779,42 +779,19 @@ static int ieee80211_ioctl_siwpower(stru
 		timeout = wrq->value / 1000;
 
  set:
-	if (ps == local->powersave && timeout == conf->dynamic_ps_timeout)
-		return ret;
+	if (ps == sdata->u.mgd.powersave && timeout == conf->dynamic_ps_timeout)
+		return 0;
 
-	local->powersave = ps;
+	sdata->u.mgd.powersave = ps;
 	conf->dynamic_ps_timeout = timeout;
 
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
-		ret = ieee80211_hw_config(local,
-					  IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT);
+		ieee80211_hw_config(local,
+				    IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT);
 
-	if (!(sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED))
-		return ret;
+	ieee80211_recalc_ps(local);
 
-	if (conf->dynamic_ps_timeout > 0 &&
-	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
-		mod_timer(&local->dynamic_ps_timer, jiffies +
-			  msecs_to_jiffies(conf->dynamic_ps_timeout));
-	} else {
-		if (local->powersave) {
-			if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-				ieee80211_send_nullfunc(local, sdata, 1);
-			conf->flags |= IEEE80211_CONF_PS;
-			ret = ieee80211_hw_config(local,
-					IEEE80211_CONF_CHANGE_PS);
-		} else {
-			conf->flags &= ~IEEE80211_CONF_PS;
-			ret = ieee80211_hw_config(local,
-					IEEE80211_CONF_CHANGE_PS);
-			if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-				ieee80211_send_nullfunc(local, sdata, 0);
-			del_timer_sync(&local->dynamic_ps_timer);
-			cancel_work_sync(&local->dynamic_ps_enable_work);
-		}
-	}
-
-	return ret;
+	return 0;
 }
 
 static int ieee80211_ioctl_giwpower(struct net_device *dev,
@@ -822,9 +799,9 @@ static int ieee80211_ioctl_giwpower(stru
 				    union iwreq_data *wrqu,
 				    char *extra)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	wrqu->power.disabled = !local->powersave;
+	wrqu->power.disabled = !sdata->u.mgd.powersave;
 
 	return 0;
 }
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-15 15:38:47.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-15 18:56:33.000000000 +0200
@@ -446,6 +446,149 @@ void ieee80211_send_pspoll(struct ieee80
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
+void ieee80211_send_nullfunc(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata,
+			     int powersave)
+{
+	struct sk_buff *skb;
+	struct ieee80211_hdr *nullfunc;
+	__le16 fc;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
+		return;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
+	memset(nullfunc, 0, 24);
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
+			 IEEE80211_FCTL_TODS);
+	if (powersave)
+		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
+	nullfunc->frame_control = fc;
+	memcpy(nullfunc->addr1, sdata->u.mgd.bssid, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, sdata->u.mgd.bssid, ETH_ALEN);
+
+	ieee80211_tx_skb(sdata, skb, 0);
+}
+
+/* powersave */
+static void ieee80211_enable_ps(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	if (conf->dynamic_ps_timeout > 0 &&
+	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(conf->dynamic_ps_timeout));
+	} else {
+		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+			ieee80211_send_nullfunc(local, sdata, 1);
+		conf->flags |= IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+}
+
+static void ieee80211_change_ps(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	if (!(sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED))
+		return;
+
+	if (local->powersave) {
+		ieee80211_enable_ps(local, sdata);
+	} else if (conf->flags & IEEE80211_CONF_PS) {
+		conf->flags &= ~IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+			ieee80211_send_nullfunc(local, sdata, 0);
+		del_timer_sync(&local->dynamic_ps_timer);
+		cancel_work_sync(&local->dynamic_ps_enable_work);
+	}
+}
+
+/* need to hold RTNL or interface lock */
+void ieee80211_recalc_ps(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS)) {
+		local->powersave = false;
+		return;
+	}
+
+	if (local->open_count != 1) {
+		local->powersave = false;
+		return;
+	}
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+		/* can only hit once due to open count test */
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			if (sdata->u.mgd.powersave) {
+				local->powersave = true;
+				goto change;
+			}
+		}
+		break;
+	}
+
+	local->powersave = false;
+ change:
+	ieee80211_change_ps(local, sdata);
+}
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
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS)
+		return;
+
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		ieee80211_send_nullfunc(local, sdata, 1);
+
+	local->hw.conf.flags |= IEEE80211_CONF_PS;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+}
+
+void ieee80211_dynamic_ps_timer(unsigned long data)
+{
+	struct ieee80211_local *local = (void *) data;
+
+	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
+}
+
 /* MLME */
 static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				     struct ieee80211_if_managed *ifmgd,
@@ -718,19 +861,8 @@ static void ieee80211_set_associated(str
 	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
-	if (local->powersave) {
-		if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) &&
-		    local->hw.conf.dynamic_ps_timeout > 0) {
-			mod_timer(&local->dynamic_ps_timer, jiffies +
-				  msecs_to_jiffies(
-					local->hw.conf.dynamic_ps_timeout));
-		} else {
-			if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-				ieee80211_send_nullfunc(local, sdata, 1);
-			conf->flags |= IEEE80211_CONF_PS;
-			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-		}
-	}
+	if (local->powersave)
+		ieee80211_enable_ps(local, sdata);
 
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
@@ -2176,75 +2308,3 @@ void ieee80211_mlme_notify_scan_complete
 		ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
 }
-
-void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
-			     dynamic_ps_disable_work);
-
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
-
-	ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_QUEUE_STOP_REASON_PS);
-}
-
-void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
-			     dynamic_ps_enable_work);
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-
-	if (local->hw.conf.flags & IEEE80211_CONF_PS)
-		return;
-
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-		ieee80211_send_nullfunc(local, sdata, 1);
-
-	local->hw.conf.flags |= IEEE80211_CONF_PS;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-}
-
-void ieee80211_dynamic_ps_timer(unsigned long data)
-{
-	struct ieee80211_local *local = (void *) data;
-
-	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
-}
-
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
-			     struct ieee80211_sub_if_data *sdata,
-			     int powersave)
-{
-	struct sk_buff *skb;
-	struct ieee80211_hdr *nullfunc;
-	__le16 fc;
-
-	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
-		return;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
-		       "frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
-	memset(nullfunc, 0, 24);
-	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
-			 IEEE80211_FCTL_TODS);
-	if (powersave)
-		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
-	nullfunc->frame_control = fc;
-	memcpy(nullfunc->addr1, sdata->u.mgd.bssid, ETH_ALEN);
-	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(nullfunc->addr3, sdata->u.mgd.bssid, ETH_ALEN);
-
-	ieee80211_tx_skb(sdata, skb, 0);
-}

-- 

