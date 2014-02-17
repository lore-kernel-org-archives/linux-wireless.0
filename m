Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:50280 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaBQNXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 08:23:18 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so6576015eaj.31
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 05:23:16 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de, Rostislav Lisovy <lisovy@gmail.com>
Subject: [RFC 3/4] mac80211: Add OCB (IEEE 802.11p) mode
Date: Mon, 17 Feb 2014 14:22:53 +0100
Message-Id: <1392643374-3545-4-git-send-email-lisovy@gmail.com> (sfid-20140217_142327_922760_6A66D6B1)
In-Reply-To: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
References: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
---
 include/net/cfg80211.h       |   2 +
 include/uapi/linux/nl80211.h |   7 +-
 net/mac80211/Kconfig         |  11 +++
 net/mac80211/Makefile        |   3 +-
 net/mac80211/cfg.c           |  43 ++++++++-
 net/mac80211/debug.h         |  10 ++
 net/mac80211/driver-ops.h    |   3 +-
 net/mac80211/ieee80211_i.h   |  46 +++++++++
 net/mac80211/iface.c         |  63 ++++++++++++-
 net/mac80211/main.c          |  12 ++-
 net/mac80211/ocb.c           | 219 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c            |  30 ++++++
 net/mac80211/tx.c            |  21 ++++-
 net/mac80211/util.c          |  72 ++++++++++++++
 net/mac80211/wme.c           |   4 +
 net/wireless/chan.c          |  19 +++-
 net/wireless/core.h          |   4 +
 net/wireless/nl80211.c       |   4 +
 net/wireless/rdev-ops.h      |  11 +++
 net/wireless/reg.c           |   2 +
 net/wireless/util.c          |   7 +-
 21 files changed, 578 insertions(+), 15 deletions(-)
 create mode 100644 net/mac80211/ocb.c

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 14f8cc1..7f85547 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2285,6 +2285,8 @@ struct cfg80211_ops {
 
 	int	(*set_monitor_channel)(struct wiphy *wiphy,
 				       struct cfg80211_chan_def *chandef);
+	int	(*set_ocb_channel)(struct wiphy *wiphy,
+				       struct cfg80211_chan_def *chandef);
 
 	int	(*scan)(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f2d3f67..a78990e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -852,7 +852,6 @@ enum nl80211_commands {
 	NL80211_CMD_SET_COALESCE,
 
 	NL80211_CMD_CHANNEL_SWITCH,
-
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1823,7 +1822,6 @@ enum nl80211_attrs {
 	NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES,
 
 	NL80211_ATTR_HANDLE_DFS,
-
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1898,6 +1896,8 @@ enum nl80211_attrs {
  *	and therefore can't be created in the normal ways, use the
  *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
  *	commands to create and destroy one
+ * @NL80211_IF_TYPE_OCB: outside context of a bss
+ *	this mode corresponds to the MIB variable dot11OCBActivated=true
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -1917,6 +1917,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
 	NL80211_IFTYPE_P2P_DEVICE,
+	NL80211_IFTYPE_OCB,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
@@ -2426,6 +2427,7 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_PTMP_ONLY: this is only for Point To Multi Point links
  * @NL80211_RRF_PASSIVE_SCAN: passive scan is required
  * @NL80211_RRF_NO_IBSS: no IBSS is allowed
+ * @NL80211_RRF_OCB_ONLY: no other than OCB is allowed
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2437,6 +2439,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_PTMP_ONLY		= 1<<6,
 	NL80211_RRF_PASSIVE_SCAN	= 1<<7,
 	NL80211_RRF_NO_IBSS		= 1<<8,
+	NL80211_RRF_OCB_ONLY		= 1<<11,
 };
 
 /**
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 97b5dca..c1d5d04 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -186,6 +186,17 @@ config MAC80211_HT_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_OCB_DEBUG
+	bool "Verbose OCB debugging"
+	depends on MAC80211_DEBUG_MENU
+	---help---
+	  Selecting this option causes mac80211 to print out
+	  very verbose OCB debugging messages. It should not
+	  be selected on production systems as those messages
+	  are remotely triggerable.
+
+	  Do not select this option.
+
 config MAC80211_IBSS_DEBUG
 	bool "Verbose IBSS debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 9d7d840..aee99a7 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -25,7 +25,8 @@ mac80211-y := \
 	wme.o \
 	event.o \
 	chan.o \
-	trace.o mlme.o
+	trace.o mlme.o \
+	ocb.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 364ce0c..13f69ee 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -806,6 +806,42 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+/* Copied from ieee80211_set_monitor_channel */
+static int ieee80211_set_ocb_channel(struct wiphy *wiphy,
+					 struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+	int ret = 0;
+
+
+	mutex_lock(&local->iflist_mtx);
+	//if (local->use_chanctx) {
+	//	sdata = rcu_dereference_protected(
+	//			local->monitor_sdata,
+	//			lockdep_is_held(&local->iflist_mtx));
+	//	if (sdata) {
+	//		ieee80211_vif_release_channel(sdata);
+	//		ret = ieee80211_vif_use_channel(sdata, chandef,
+	//				IEEE80211_CHANCTX_EXCLUSIVE);
+	//	}
+	//} else if (local->open_count == local->monitors) {
+	//	printk("%s: local->use_chanctx != TRUE\n", __func__);
+
+		/* FIXME
+		 * I know this is wrong but how do I obtain the sdata?
+		 */
+		local->_oper_chandef = *chandef;
+		ieee80211_hw_config(local, 0);
+	//}
+
+	//if (ret == 0)
+	//	local->monitor_chandef = *chandef;
+	mutex_unlock(&local->iflist_mtx);
+
+	return ret;
+}
+
 static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 					 struct cfg80211_chan_def *chandef)
 {
@@ -3771,9 +3807,11 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	if (chanctx_conf) {
 		*chandef = chanctx_conf->def;
 		ret = 0;
-	} else if (local->open_count > 0 &&
+	} else if ((local->open_count > 0 &&
 		   local->open_count == local->monitors &&
-		   sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+		   (sdata->vif.type == NL80211_IFTYPE_MONITOR))
+		    || sdata->vif.type == NL80211_IFTYPE_OCB)
+	{
 		if (local->use_chanctx)
 			*chandef = local->monitor_chandef;
 		else
@@ -3826,6 +3864,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_monitor_channel = ieee80211_set_monitor_channel,
+	.set_ocb_channel = ieee80211_set_ocb_channel,
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index 493d680..1956b31 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -2,6 +2,12 @@
 #define __MAC80211_DEBUG_H
 #include <net/cfg80211.h>
 
+#ifdef CONFIG_MAC80211_OCB_DEBUG
+#define MAC80211_OCB_DEBUG 1
+#else
+#define MAC80211_OCB_DEBUG 0
+#endif
+
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 #define MAC80211_IBSS_DEBUG 1
 #else
@@ -131,6 +137,10 @@ do {									\
 	_sdata_dbg(MAC80211_HT_DEBUG && net_ratelimit(),		\
 		   sdata, fmt, ##__VA_ARGS__)
 
+#define ocb_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_OCB_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
 #define ibss_dbg(sdata, fmt, ...)					\
 	_sdata_dbg(MAC80211_IBSS_DEBUG,					\
 		   sdata, fmt, ##__VA_ARGS__)
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5d03c47..396d2ef 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -212,7 +212,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 				    BSS_CHANGED_BEACON_ENABLED) &&
 			 sdata->vif.type != NL80211_IFTYPE_AP &&
 			 sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-			 sdata->vif.type != NL80211_IFTYPE_MESH_POINT))
+			 sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+			 sdata->vif.type != NL80211_IFTYPE_OCB))
 		return;
 
 	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4aea4e7..883ed31 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -527,6 +527,41 @@ struct ieee80211_if_ibss {
 };
 
 /**
+ * enum ocb_deferred_task_flags - mac80211 ocb deferred tasks
+ *
+ * @OCB_WORK_HOUSEKEEPING: run the periodic ocb housekeeping tasks
+ *  - expire station that has not been seen for long
+ */
+enum ocb_deferred_task_flags {
+	OCB_WORK_HOUSEKEEPING,
+};
+
+/**
+ * struct ieee80211_if_ocb - the specific struct for ocb-mode
+ *
+ * In this struct all ocb-specific information of an interface is stored.
+ *
+ * @timer: the timer used for all tasks in the ocb-code
+ * @work: holds the workqueue
+ * @skb_queue: holds all queued skb to be processed
+ * @wrkq_flags: bitmask telling what work is pending
+ * @timer_running: tells if the timer is running (true = not running!?)
+ * @bssid: holds the bssid (normally IEEE802.11p defines this to be
+ *         ff:ff:ff:ff:ff:ff - but this is more flexible)
+ */
+struct ieee80211_if_ocb {
+	struct timer_list timer;
+	struct work_struct work;
+
+	struct sk_buff_head skb_queue;
+
+	unsigned long wrkq_flags;
+
+	bool timer_running;
+	u8 bssid[ETH_ALEN];
+};
+
+/**
  * struct ieee80211_mesh_sync_ops - Extensible synchronization framework interface
  *
  * these declarations define the interface, which enables
@@ -771,6 +806,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_managed mgd;
 		struct ieee80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;
+		struct ieee80211_if_ocb ocb;
 		u32 mntr_flags;
 	} u;
 
@@ -963,6 +999,7 @@ struct ieee80211_local {
 
 	int open_count;
 	int monitors, cooked_mntrs;
+	int ocbs;
 	/* number of interfaces with corresponding FIF_ flags */
 	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll,
 	    fif_probe_req;
@@ -1364,6 +1401,13 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata);
 
+/* OCB code */
+void ieee80211_ocb_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+				  struct sk_buff *skb);
+struct sta_info *ieee80211_ocb_add_sta(struct ieee80211_sub_if_data *sdata,
+				       u8 *addr, u32 supp_rates);
+void ieee80211_ocb_setup_sdata(struct ieee80211_sub_if_data *sdata);
+
 /* mesh code */
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
@@ -1574,6 +1618,8 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify);
+void ieee80211_set_wmm_itsg5(struct ieee80211_sub_if_data *sdata,
+			      bool bss_notify);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		    enum ieee80211_band band);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a075791..73ab0a6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -109,7 +109,9 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local,
 
 	active = force_active ||
 		 !list_empty(&local->chanctx_list) ||
-		 local->monitors;
+		 local->monitors ||
+		 local->ocbs;
+	printk(" ###  %s: active: %d; local->ocbs: %d\n", __func__, active, local->ocbs);
 
 	if (!local->ops->remain_on_channel) {
 		list_for_each_entry(roc, &local->roc_list, list) {
@@ -261,6 +263,15 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		if (nsdata != sdata && ieee80211_sdata_running(nsdata)) {
+			if ((sdata->vif.type == NL80211_IFTYPE_OCB
+			     && nsdata->vif.type != NL80211_IFTYPE_MONITOR)
+			    || (sdata->vif.type != NL80211_IFTYPE_MONITOR
+				&& nsdata->vif.type == NL80211_IFTYPE_OCB))
+			{
+				ocb_dbg(sdata, "only ocb- and monitor-mode may coexist!\n");
+				return -EBUSY;
+			}
+
 			/*
 			 * Allow only a single IBSS interface to be up at any
 			 * time. This is restricted because beacon distribution
@@ -508,6 +519,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_OCB:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -611,6 +623,32 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
 			changed |= ieee80211_reset_erp_info(sdata);
+
+		if (sdata->vif.type == NL80211_IFTYPE_OCB) {
+			local->ocbs++;
+
+			/* Disable beacons */
+			sdata->vif.bss_conf.enable_beacon = false;
+			changed |= BSS_CHANGED_BEACON;
+
+			/*
+			 * Disable idle -- when chanctx will be used,
+			 * this will be unnecessary
+			 */
+			sdata->vif.bss_conf.idle = false;
+			changed |= BSS_CHANGED_IDLE;
+
+			/* Receive all data frames */
+			local->fif_other_bss++;
+			ieee80211_configure_filter(local);
+
+			mutex_lock(&local->mtx);
+			ieee80211_recalc_idle(local);
+			mutex_unlock(&local->mtx);
+
+			netif_carrier_on(dev);
+		}
+
 		ieee80211_bss_info_change_notify(sdata, changed);
 
 		switch (sdata->vif.type) {
@@ -620,6 +658,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		case NL80211_IFTYPE_MESH_POINT:
 			netif_carrier_off(dev);
 			break;
+		case NL80211_IFTYPE_OCB:
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_P2P_DEVICE:
 			break;
@@ -633,7 +672,12 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		 * need to initialise the hardware if the hardware
 		 * doesn't start up with sane defaults
 		 */
-		ieee80211_set_wmm_default(sdata, true);
+		if (sdata->vif.type == NL80211_IFTYPE_OCB) {
+			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+			ieee80211_set_wmm_itsg5(sdata, true);
+		} else {
+			ieee80211_set_wmm_default(sdata, true);
+		}
 	}
 
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
@@ -878,6 +922,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
 		break;
+	case NL80211_IFTYPE_OCB:
+		local->ocbs--;
+		if (local->ocbs == 0) {
+			/* Do some cleaning */
+		}
+		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
 		rcu_assign_pointer(local->p2p_sdata, NULL);
@@ -1222,6 +1272,9 @@ static void ieee80211_iface_work(struct work_struct *work)
 				break;
 			ieee80211_mesh_rx_queued_mgmt(sdata, skb);
 			break;
+		case NL80211_IFTYPE_OCB:
+			ieee80211_ocb_rx_queued_mgmt(sdata, skb);
+			break;
 		default:
 			WARN(1, "frame for unexpected interface type");
 			break;
@@ -1309,6 +1362,10 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
 		ieee80211_sta_setup_sdata(sdata);
 		break;
+	case NL80211_IFTYPE_OCB:
+		ieee80211_ocb_setup_sdata(sdata);
+		sdata->vif.bss_conf.bssid = sdata->u.ocb.bssid;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 		ieee80211_ibss_setup_sdata(sdata);
@@ -1356,6 +1413,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could maybe also all others here?
 		 * Just not sure how that interacts
@@ -1371,6 +1429,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could probably support everything
 		 * but WDS here (WDS do_open can fail
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7d1c3ac..13c026e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -954,14 +954,18 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_rate;
 	}
 
+	/* add one default OCB interface if supported */
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_OCB)) {
+		result = ieee80211_if_add(local, "wlan%d", NULL,
+					  NL80211_IFTYPE_OCB, NULL);
 	/* add one default STA interface if supported */
-	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
+	} else if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,
 					  NL80211_IFTYPE_STATION, NULL);
-		if (result)
-			wiphy_warn(local->hw.wiphy,
-				   "Failed to add default virtual iface\n");
 	}
+	if (result)
+		wiphy_warn(local->hw.wiphy, "Failed to add default virtual iface\n");
+
 
 	rtnl_unlock();
 
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
new file mode 100644
index 0000000..4e2aaee
--- /dev/null
+++ b/net/mac80211/ocb.c
@@ -0,0 +1,219 @@
+/*
+ * OCB mode implementation
+ * Copyright 2009, Robert Budde <robert.budde@tu-dortmund.de>
+ * Copyright 2014, Czech Technical University in Prague, Rostislav Lisovy
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/if_ether.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
+#include <net/mac80211.h>
+#include <asm/unaligned.h>
+
+#include "ieee80211_i.h"
+#include "driver-ops.h"
+#include "rate.h"
+
+#define IEEE80211_OCB_HOUSEKEEPING_INTERVAL		(10 * HZ)
+#define IEEE80211_OCB_PEER_INACTIVITY_LIMIT		(60 * HZ)
+#define IEEE80211_OCB_MAX_STA_ENTRIES			128
+
+/**
+ * ieee80211_ocb_add_sta - Adds a new OCB station
+ *
+ * @sdata: The &struct ieee80211_sub_if_data containing the interface data
+ * @addr: The stations mac-address
+ * @supp_rates: The supported rates of that station encoded in a bitmask
+ *
+ * This function adds a new OCB station to the station list. It is called by
+ * the mac80211 rx code whenever a new station appears (a frame is received).
+ *
+ * Returns: A pointer to the new station record.
+ */
+struct sta_info *ieee80211_ocb_add_sta(struct ieee80211_sub_if_data *sdata,
+					u8 *addr, u32 supp_rates)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_supported_band *sband;
+	enum nl80211_bss_scan_width scan_width;
+	struct sta_info *sta;
+	int band;
+
+	/*
+	 * XXX: Consider removing the least recently used entry and
+	 * 	allow new one to be added.
+	 */
+	if (local->num_sta >= IEEE80211_OCB_MAX_STA_ENTRIES) {
+		//if (net_ratelimit())
+			ocb_dbg(sdata, "No room for a new OCB STA entry %pM\n",
+				addr);
+		return NULL;
+	}
+
+	ocb_dbg(sdata, "Adding new OCB station %pM\n", addr);
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		band = local->_oper_chandef.chan->band;
+		scan_width = local->_oper_chandef.width;
+	} else {
+		band = chanctx_conf->def.chan->band;
+		scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
+	}
+	rcu_read_unlock();
+
+	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
+	if (!sta)
+		return NULL;
+
+	sta->last_rx = jiffies;
+
+	/* FIXME
+	 * We are skipping some states thus we cannot use
+	 * sta_info_move_state_checked() --
+	 * in this case set_sta_flag will invoke WARN_ON
+	 */
+	set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+
+	/* make sure mandatory rates are always added */
+	sband = local->hw.wiphy->bands[band];
+	sta->sta.supp_rates[band] = supp_rates |
+		ieee80211_mandatory_rates(sband, scan_width);
+	rate_control_rate_init(sta);
+
+	/* If it fails, maybe we raced another insertion? */
+	if (sta_info_insert(sta))
+		return sta_info_get(sdata, addr);
+	return sta;
+}
+
+/* This might be unnecessary at all */
+void ieee80211_ocb_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status;
+	struct ieee80211_mgmt *mgmt;
+	u16 fc;
+
+	rx_status = IEEE80211_SKB_RXCB(skb);
+	mgmt = (struct ieee80211_mgmt *)skb->data;
+	fc = le16_to_cpu(mgmt->frame_control);
+
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_ACTION:
+		ocb_dbg(sdata, "recv mgmt-frame of subtype ACTION\n");
+		break;
+	default:
+		ocb_dbg(sdata, "recv mgmt-frame of unknown subtype\n");
+		break;
+	}
+}
+
+/**
+ * ieee80211_ocb_housekeeping - Housekeeping function (expires stations)
+ *
+ * @sdata:
+ * @ifocb:
+ *
+ * This function is used for all periodical clean up work.
+ * It expires all stations that have not shown up for a given period of time.
+ * After all cleanups have been done it schedules the next run.
+ */
+static void ieee80211_ocb_housekeeping(struct ieee80211_sub_if_data *sdata,
+			   struct ieee80211_if_ocb *ifocb)
+{
+	ocb_dbg(sdata, "running ocb housekeeping\n");
+
+	ieee80211_sta_expire(sdata, IEEE80211_OCB_PEER_INACTIVITY_LIMIT);
+
+	mod_timer(&ifocb->timer,
+		  round_jiffies(jiffies + IEEE80211_OCB_HOUSEKEEPING_INTERVAL));
+}
+
+/**
+ * ieee80211_ocb_work - Workqueue function
+ *
+ * @work:
+ *
+ * This function is called once the interface is started and periodically
+ * by the timer function when the timer expires.
+ * It checks whether the interface is suspended, running, scanning and of
+ * the right type. After all queued skbs have been processed it checks what
+ * tasks are to be done and calls the corresponding functions.
+ */
+static void ieee80211_ocb_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.ocb.work);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+
+	if (WARN_ON(local->suspended))
+		return;
+
+	if (!netif_running(sdata->dev))
+		return;
+
+	if (local->scanning)
+		return;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_OCB))
+		return;
+
+	if (test_and_clear_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags))
+		ieee80211_ocb_housekeeping(sdata, ifocb);
+}
+
+/**
+ * ieee80211_ocb_timer - Timer function called when the timer expires
+ *
+ * @data:
+ *
+ * This function is called everytime the timer expires (periodically)
+ * To make sure the housekeeping is done it sets the corresponding bit and
+ * then calls the workqueue.
+ */
+static void ieee80211_ocb_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata = (void *)data;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+	if (local->quiescing) {
+		ifocb->timer_running = true;
+		return;
+	}
+
+	set_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags);
+	ieee80211_queue_work(&local->hw, &ifocb->work);
+}
+
+/**
+ * ieee80211_ocb_setup_sdata - Setups all the interface data
+ *
+ * @sdata:
+ *
+ * This needs to be called before the interface is brought up.
+ */
+void ieee80211_ocb_setup_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+	/* Wildcard BSSID */
+	memset(ifocb->bssid, 0xff, ETH_ALEN);
+
+	INIT_WORK(&ifocb->work, ieee80211_ocb_work);
+	setup_timer(&ifocb->timer, ieee80211_ocb_timer,
+		    (unsigned long) sdata);
+	skb_queue_head_init(&ifocb->skb_queue);
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2b0debb..9375c6e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1022,6 +1022,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
+		     rx->sdata->vif.type != NL80211_IFTYPE_OCB &&
 		     (!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_ASSOC)))) {
 		/*
 		 * accept port control frames from the AP even when it's not
@@ -1251,6 +1252,11 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 				sta->last_rx_rate_vht_nss = status->vht_nss;
 			}
 		}
+	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
+		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
+						NL80211_IFTYPE_OCB);
+		if (ieee80211_bssid_match(bssid, rx->sdata->u.ocb.bssid))
+			sta->last_rx = jiffies;
 	} else if (!is_multicast_ether_addr(hdr->addr1)) {
 		/*
 		 * Mesh beacons will update last_rx when if they are found to
@@ -2789,6 +2795,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 
 	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_OCB &&
 	    sdata->vif.type != NL80211_IFTYPE_STATION)
 		return RX_DROP_MONITOR;
 
@@ -3099,6 +3106,29 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 						 BIT(rate_idx));
 		}
 		break;
+	case NL80211_IFTYPE_OCB:
+		if (!bssid)
+			return 0;
+		if (ieee80211_is_beacon(hdr->frame_control)) {
+			return 0;
+		} else if (!ieee80211_bssid_match(bssid, sdata->u.ocb.bssid)) {
+			ocb_dbg(sdata, "BSSID mismatch in OCB -mode!\n");
+			return 0;
+		} else if (!multicast && compare_ether_addr(sdata->dev->dev_addr, hdr->addr1) != 0) {
+			// if we are in promisc mode we also accept packets not destined for us
+			if (!(sdata->dev->flags & IFF_PROMISC))
+				return 0;
+			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+		} else if (!rx->sta) {
+			int rate_idx;
+			if (status->flag & RX_FLAG_HT)
+				rate_idx = 0; /* TODO: HT rates */
+			else
+				rate_idx = status->rate_idx;
+			rx->sta = ieee80211_ocb_add_sta(sdata, hdr->addr2,
+				BIT(rate_idx));
+		}
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
 		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ca7fa7f..3344382 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -293,6 +293,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		 */
 		return TX_DROP;
 
+	if (tx->sdata->vif.type == NL80211_IFTYPE_OCB)
+		return TX_CONTINUE;
+
 	if (tx->sdata->vif.type == NL80211_IFTYPE_WDS)
 		return TX_CONTINUE;
 
@@ -1728,7 +1731,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * monitor flag interfaces used for AP support.
 	 */
 	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
-			    IEEE80211_CHAN_PASSIVE_SCAN)))
+			    IEEE80211_CHAN_PASSIVE_SCAN))
+	    && (!(chan->flags & (IEEE80211_CHAN_OCB_ONLY))))
 		goto fail_rcu;
 
 	ieee80211_xmit(sdata, skb, chan->band);
@@ -1970,6 +1974,20 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto fail_rcu;
 		band = chanctx_conf->def.chan->band;
 		break;
+	case NL80211_IFTYPE_OCB:
+		/* DA SA BSSID */
+		memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+		memset(hdr.addr3, 0xff, ETH_ALEN);
+		hdrlen = 24;
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (!chanctx_conf) {
+			//goto fail_rcu;
+			band = local->_oper_chandef.chan->band;
+		} else {
+			band = chanctx_conf->def.chan->band;
+		}
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -2014,6 +2032,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * EAPOL frames from the local station.
 	 */
 	if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
+		     (sdata->vif.type != NL80211_IFTYPE_OCB) &&
 		     !multicast && !authorized &&
 		     (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
 		      !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9f9b9bd..3b34385 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -991,6 +991,9 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	if (!local->ops->conf_tx)
 		return;
 
+	/* this function should never be used in ocb-mode */
+	BUG_ON(sdata->vif.type == NL80211_IFTYPE_OCB);
+
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		return;
 
@@ -1077,6 +1080,71 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+/**
+ * ieee80211_set_wmm_itsg5 - sets up the WMM queue parameters for ITS-G5
+ *
+ * Sets up the WMM queue parameters for each queue according to ITS-G5.
+ *
+ * @sdata:
+ * @bss_notify:
+ */
+void ieee80211_set_wmm_itsg5(struct ieee80211_sub_if_data *sdata, bool bss_notify)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_queue_params qparam;
+	int ac;
+	int aCWmin, aCWmax;
+
+	if (!local->ops->conf_tx)
+		return;
+
+	ocb_dbg(sdata, "setting wmm-params up for ocb-mode\n");
+
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		return;
+
+	memset(&qparam, 0, sizeof(qparam));
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		/* Set defaults according to 802.11-2007 Table 7-37 and 802.11p 7-37a */
+		aCWmax = 1023;
+		aCWmin = 15;
+
+		switch (ac) {
+		case IEEE80211_AC_BK:
+			qparam.cw_min = aCWmin;
+			qparam.cw_max = aCWmax;
+			qparam.aifs = 9;
+			qparam.txop = 0;
+			break;
+		case IEEE80211_AC_BE:
+			qparam.cw_min = aCWmin;
+			qparam.cw_max = aCWmax;
+			qparam.aifs = 6;
+			qparam.txop = 0;
+			break;
+		case IEEE80211_AC_VI:
+			qparam.cw_min = (aCWmin + 1) / 2 - 1;
+			qparam.cw_max = aCWmin;
+			qparam.aifs = 3;
+			qparam.txop = 0;
+			break;
+		case IEEE80211_AC_VO:
+			qparam.cw_min = (aCWmin + 1) / 4 - 1;
+			qparam.cw_max = (aCWmin + 1) / 2 - 1;
+			qparam.aifs = 2;
+			qparam.txop = 0;
+			break;
+		}
+
+		sdata->tx_conf[ac] = qparam;
+		drv_conf_tx(local, sdata, ac, &qparam);
+	}
+	sdata->vif.bss_conf.qos = true;
+	if (bss_notify)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
+}
+
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *da,
@@ -1614,6 +1682,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			ieee80211_bss_info_change_notify(sdata, changed);
 			sdata_unlock(sdata);
 			break;
+		case NL80211_IFTYPE_OCB:
+			changed |= BSS_CHANGED_IBSS | BSS_CHANGED_BEACON_ENABLED;
+			ieee80211_bss_info_change_notify(sdata, changed);
+			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index afba19c..ab3e970 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -137,6 +137,10 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_ADHOC:
 		ra = skb->data;
 		break;
+	case NL80211_IFTYPE_OCB:
+		/* all stations are required to support WME */
+		qos = true;
+		break;
 	default:
 		break;
 	}
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 729a30c..8c325f4 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -477,13 +477,29 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 				      IEEE80211_CHAN_DISABLED |
 				      IEEE80211_CHAN_PASSIVE_SCAN |
 				      IEEE80211_CHAN_NO_IBSS |
-				      IEEE80211_CHAN_RADAR);
+				      IEEE80211_CHAN_RADAR |
+				      IEEE80211_CHAN_OCB_ONLY);
+	/* Is this correct?
+	 * IEEE80211_CHAN_OCB_ONLY flag prohibited
+	 * when enabling beacons
+	 */
 
 	trace_cfg80211_return_bool(res);
 	return res;
 }
 EXPORT_SYMBOL(cfg80211_reg_can_beacon);
 
+int cfg80211_set_ocb_channel(struct cfg80211_registered_device *rdev,
+			     struct wireless_dev *wdev,
+			     struct cfg80211_chan_def *chandef)
+{
+	if (!rdev->ops->set_ocb_channel)
+		return -EOPNOTSUPP;
+
+
+	return rdev_set_ocb_channel(rdev, chandef);
+}
+
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 struct cfg80211_chan_def *chandef)
 {
@@ -542,6 +558,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chanmode = CHAN_MODE_SHARED;
 		}
 		return;
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index af10e59..873ebf8 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -436,6 +436,10 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 struct cfg80211_chan_def *chandef);
 
+int cfg80211_set_ocb_channel(struct cfg80211_registered_device *rdev,
+			     struct wireless_dev *wdev,
+			     struct cfg80211_chan_def *chandef);
+
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
 			   u32 *mask);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a62d716..d4e1431 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1777,6 +1777,7 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 	 * operation to set the monitor channel if possible.
 	 */
 	return !wdev ||
+		wdev->iftype == NL80211_IFTYPE_OCB ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
 		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
 		wdev->iftype == NL80211_IFTYPE_MONITOR ||
@@ -1888,6 +1889,9 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	case NL80211_IFTYPE_MONITOR:
 		result = cfg80211_set_monitor_channel(rdev, &chandef);
 		break;
+	case NL80211_IFTYPE_OCB:
+		result = cfg80211_set_ocb_channel(rdev, wdev, &chandef);
+		break;
 	default:
 		result = -EINVAL;
 	}
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 37ce9fd..eeb963e 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -359,6 +359,17 @@ rdev_libertas_set_mesh_channel(struct cfg80211_registered_device *rdev,
 }
 
 static inline int
+rdev_set_ocb_channel(struct cfg80211_registered_device *rdev,
+		     struct cfg80211_chan_def *chandef)
+{
+	int ret;
+	//trace_rdev_set_ocb_channel(&rdev->wiphy, chandef);
+	ret = rdev->ops->set_ocb_channel(&rdev->wiphy, chandef);
+	//trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
 rdev_set_monitor_channel(struct cfg80211_registered_device *rdev,
 			 struct cfg80211_chan_def *chandef)
 {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 992432c..48fb075 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -706,6 +706,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_RADAR;
 	if (rd_flags & NL80211_RRF_NO_OFDM)
 		channel_flags |= IEEE80211_CHAN_NO_OFDM;
+	if (rd_flags & NL80211_RRF_OCB_ONLY)
+		channel_flags |= IEEE80211_CHAN_OCB_ONLY;
 	return channel_flags;
 }
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 935dea9..7bb5bf8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -440,7 +440,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		break;
 	case cpu_to_le16(0):
 		if (iftype != NL80211_IFTYPE_ADHOC &&
-		    iftype != NL80211_IFTYPE_STATION)
+		    iftype != NL80211_IFTYPE_STATION &&
+		    iftype != NL80211_IFTYPE_OCB)
 				return -1;
 		break;
 	}
@@ -516,6 +517,7 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		hdrlen = 24;
 		break;
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -902,6 +904,8 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			if (dev->ieee80211_ptr->use_4addr)
 				break;
 			/* fall through */
+		case NL80211_IFTYPE_OCB:
+			/* fall through */
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_ADHOC:
 			dev->priv_flags |= IFF_DONT_BRIDGE;
@@ -1274,6 +1278,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		}
 		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
 		break;
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_DEVICE:
-- 
1.8.5.1

