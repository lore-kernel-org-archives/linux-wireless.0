Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60335 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3LPWBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:07 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so5737609oag.16
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:06 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 2/8] mac80211: Add per-interface powersave states and parameters
Date: Mon, 16 Dec 2013 16:00:54 -0600
Message-Id: <1387231260-2849-3-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230126_684068_EB22D5CF)
In-Reply-To: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for managing powersave states on a per-interface
basis, add powersave states and parameters to the interface-
specific data structures. Also add a change_ps driver callback
to notify drivers about changes to interface powersave states.

The new members and callback are unused here but will be
utilized by subsequent commits.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 include/net/mac80211.h    | 43 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 13 +++++++++++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3cd408b..03e4a63 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1103,6 +1103,26 @@ enum ieee80211_vif_flags {
 };
 
 /**
+ * enum ieee80211_vif_ps_mode - virtual interface power save mode
+ *
+ * Ordered in terms of increasing wakefulness.
+ *
+ * @IEEE80211_VIF_PS_INACTIVE: the interface is not currently open
+ * @IEEE80211_VIF_PS_DOZE: the interface is in a low-power mode and may
+ *	not be able to transmit or receive frames
+ * @IEEE80211_VIF_PS_AWAKE_PM: the interface is awake and able to transmit
+ *	and receive frames but PM may be set in frame control
+ * @IEEE80211_VIF_PS_AWAKE: the interface is fully awake and able to
+ *	transmit and receive frames
+ */
+enum ieee80211_vif_ps_mode {
+	IEEE80211_VIF_PS_INACTIVE,
+	IEEE80211_VIF_PS_DOZE,
+	IEEE80211_VIF_PS_AWAKE_PM,
+	IEEE80211_VIF_PS_AWAKE,
+};
+
+/**
  * struct ieee80211_vif - per-interface data
  *
  * Data in this structure is continually present for driver
@@ -1129,6 +1149,19 @@ enum ieee80211_vif_flags {
  * @debugfs_dir: debugfs dentry, can be used by drivers to create own per
  *	interface debug files. Note that it will be NULL for the virtual
  *	monitor interface (if that is requested.)
+ * @ps_mode: power save mode of this vif
+ * @dynamic_ps_active: indicates whether dynamic PS is active for this vif
+ * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
+ *	powersave documentation below. This variable is valid only when
+ *	the interface is in the doze state.
+ * @max_sleep_period: the maximum number of beacon intervals to sleep for
+ *	before checking the beacon for a TIM bit (managed mode only); this
+ *	value will be only achievable between DTIM frames, the hardware
+ *	needs to check for the multicast traffic bit in DTIM beacons.
+ *	This variable is valid only when the interface is in the doze state.
+ * @ps_dtim_period: The DTIM period of the AP we're connected to, for use
+ *	in power saving. Power saving will not be enabled until a beacon
+ *	has been received and the DTIM period is known.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -1144,6 +1177,11 @@ struct ieee80211_vif {
 
 	struct ieee80211_chanctx_conf __rcu *chanctx_conf;
 
+	enum ieee80211_vif_ps_mode ps_mode;
+	bool dynamic_ps_active;
+	int dynamic_ps_timeout, max_sleep_period;
+	u8 ps_dtim_period;
+
 	u32 driver_flags;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -2390,6 +2428,10 @@ enum ieee80211_roc_type {
  *	of the bss parameters has changed when a call is made. The callback
  *	can sleep.
  *
+ * @change_ps: Change the power save mode or parameters for the given virtual
+ *	interface. @next_tbtt is required for mesh powersave but is currently
+ *	unused. This callback is optional and may sleep.
+ *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
  *	to configure_filter(). This callback must be atomic.
@@ -2754,6 +2796,7 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
+	void (*change_ps)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 
 	int (*start_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*stop_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5d03c47..8e708bd7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -227,6 +227,19 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_change_ps(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+
+	check_sdata_in_driver(sdata);
+
+	trace_drv_change_ps(local, sdata);
+	if (local->ops->change_ps)
+		local->ops->change_ps(&local->hw, &sdata->vif);
+	trace_drv_return_void(local);
+}
+
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e9ccf22..fcc9ac5 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -422,6 +422,33 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
+TRACE_EVENT(drv_change_ps,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(local, sdata),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(int, ps_mode)
+		__field(bool, dynamic_ps_active)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->ps_mode = sdata->vif.ps_mode;
+		__entry->dynamic_ps_active = sdata->vif.dynamic_ps_active;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT "mode:%d dynamic_ps:%sactive",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->ps_mode,
+		__entry->dynamic_ps_active ? "" : "in"
+	)
+);
+
 TRACE_EVENT(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count),
 
-- 
1.8.3.2

