Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3EJMIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 08:08:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/4] cfg80211/mac80211: use cfg80211 wdev mutex in mac80211
Date: Fri, 10 May 2013 14:08:09 +0200
Message-Id: <1368187689-29706-5-git-send-email-johannes@sipsolutions.net> (sfid-20130510_140829_813571_5B6C3A97)
In-Reply-To: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
References: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using separate locks in cfg80211 and mac80211 has always
caused issues, for example having to unlock in places in
mac80211 to call cfg80211, which even needed a framework
to make cfg80211 calls after some functions returned etc.

Additionally, I suspect some issues people have reported
with the cfg80211 state getting confused could be due to
such issues, when cfg80211 is asking mac80211 to change
state but mac80211 is in the process of telling cfg80211
that the state changed (in another way.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |   2 -
 include/net/cfg80211.h           |  41 ++---
 net/mac80211/cfg.c               |   4 +-
 net/mac80211/debugfs_netdev.c    |  10 +-
 net/mac80211/ht.c                |   4 +-
 net/mac80211/ibss.c              |  39 ++---
 net/mac80211/ieee80211_i.h       |  25 ++-
 net/mac80211/main.c              |   4 +-
 net/mac80211/mlme.c              | 332 ++++++++++++++-------------------------
 net/mac80211/util.c              |   4 +-
 net/wireless/mlme.c              |  48 +-----
 net/wireless/trace.h             |   4 +-
 12 files changed, 186 insertions(+), 331 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index 0f6a3ed..ebe8969 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -132,9 +132,7 @@
 !Finclude/net/cfg80211.h cfg80211_send_rx_assoc
 !Finclude/net/cfg80211.h cfg80211_send_assoc_timeout
 !Finclude/net/cfg80211.h cfg80211_send_deauth
-!Finclude/net/cfg80211.h __cfg80211_send_deauth
 !Finclude/net/cfg80211.h cfg80211_send_disassoc
-!Finclude/net/cfg80211.h __cfg80211_send_disassoc
 !Finclude/net/cfg80211.h cfg80211_ibss_joined
 !Finclude/net/cfg80211.h cfg80211_connect_result
 !Finclude/net/cfg80211.h cfg80211_roamed
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 085e5f7..0959fed 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2849,7 +2849,8 @@ struct cfg80211_cached_keys;
  *	by cfg80211 on change_interface
  * @mgmt_registrations: list of registrations for management frames
  * @mgmt_registrations_lock: lock for the list
- * @mtx: mutex used to lock data in this struct
+ * @mtx: mutex used to lock data in this struct, may be used by drivers
+ *	and some API functions require it held
  * @cleanup_work: work struct used for cleanup that can't be done directly
  * @beacon_interval: beacon interval used on this device for transmitting
  *	beacons, 0 when not valid
@@ -3413,7 +3414,8 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
  * This function is called whenever an authentication has been processed in
  * station mode. The driver is required to call either this function or
  * cfg80211_send_auth_timeout() to indicate the result of cfg80211_ops::auth()
- * call. This function may sleep.
+ * call. This function may sleep. The caller must hold the corresponding wdev's
+ * mutex.
  */
 void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 
@@ -3422,7 +3424,8 @@ void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
  * @dev: network device
  * @addr: The MAC address of the device with which the authentication timed out
  *
- * This function may sleep.
+ * This function may sleep. The caller must hold the corresponding wdev's
+ * mutex.
  */
 void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
 
@@ -3437,7 +3440,8 @@ void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
  * This function is called whenever a (re)association response has been
  * processed in station mode. The driver is required to call either this
  * function or cfg80211_send_assoc_timeout() to indicate the result of
- * cfg80211_ops::assoc() call. This function may sleep.
+ * cfg80211_ops::assoc() call. This function may sleep. The caller must hold
+ * the corresponding wdev's mutex.
  */
 void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
 			    const u8 *buf, size_t len);
@@ -3447,7 +3451,7 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
  * @dev: network device
  * @addr: The MAC address of the device with which the association timed out
  *
- * This function may sleep.
+ * This function may sleep. The caller must hold the corresponding wdev's mutex.
  */
 void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr);
 
@@ -3459,21 +3463,12 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr);
  *
  * This function is called whenever deauthentication has been processed in
  * station mode. This includes both received deauthentication frames and
- * locally generated ones. This function may sleep.
+ * locally generated ones. This function may sleep. The caller must hold the
+ * corresponding wdev's mutex.
  */
 void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
- * __cfg80211_send_deauth - notification of processed deauthentication
- * @dev: network device
- * @buf: deauthentication frame (header + body)
- * @len: length of the frame data
- *
- * Like cfg80211_send_deauth(), but doesn't take the wdev lock.
- */
-void __cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
-
-/**
  * cfg80211_send_disassoc - notification of processed disassociation
  * @dev: network device
  * @buf: disassociation response frame (header + body)
@@ -3481,22 +3476,12 @@ void __cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
  *
  * This function is called whenever disassociation has been processed in
  * station mode. This includes both received disassociation frames and locally
- * generated ones. This function may sleep.
+ * generated ones. This function may sleep. The caller must hold the
+ * corresponding wdev's mutex.
  */
 void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
- * __cfg80211_send_disassoc - notification of processed disassociation
- * @dev: network device
- * @buf: disassociation response frame (header + body)
- * @len: length of the frame data
- *
- * Like cfg80211_send_disassoc(), but doesn't take the wdev lock.
- */
-void __cfg80211_send_disassoc(struct net_device *dev, const u8 *buf,
-	size_t len);
-
-/**
  * cfg80211_send_unprot_deauth - notification of unprotected deauthentication
  * @dev: network device
  * @buf: deauthentication frame (header + body)
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6698945..a8e4ba1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2317,7 +2317,7 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_smps_mode old_req;
 	int err;
 
-	lockdep_assert_held(&sdata->u.mgd.mtx);
+	lockdep_assert_held(&sdata->wdev.mtx);
 
 	old_req = sdata->u.mgd.req_smps;
 	sdata->u.mgd.req_smps = smps_mode;
@@ -2374,9 +2374,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	local->dynamic_ps_forced_timeout = timeout;
 
 	/* no change, but if automatic follow powersave */
-	mutex_lock(&sdata->u.mgd.mtx);
 	__ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);
-	mutex_unlock(&sdata->u.mgd.mtx);
 
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 14abcf4..27d08ec 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -228,9 +228,9 @@ static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&sdata->u.mgd.mtx);
+	sdata_lock(sdata);
 	err = __ieee80211_request_smps(sdata, smps_mode);
-	mutex_unlock(&sdata->u.mgd.mtx);
+	sdata_unlock(sdata);
 
 	return err;
 }
@@ -313,16 +313,16 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 	case NL80211_IFTYPE_STATION:
 		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 		/* BSSID SA DA */
-		mutex_lock(&sdata->u.mgd.mtx);
+		sdata_lock(sdata);
 		if (!sdata->u.mgd.associated) {
-			mutex_unlock(&sdata->u.mgd.mtx);
+			sdata_unlock(sdata);
 			dev_kfree_skb(skb);
 			return -ENOTCONN;
 		}
 		memcpy(hdr->addr1, sdata->u.mgd.associated->bssid, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		memcpy(hdr->addr3, addr, ETH_ALEN);
-		mutex_unlock(&sdata->u.mgd.mtx);
+		sdata_unlock(sdata);
 		break;
 	default:
 		dev_kfree_skb(skb);
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index af8cee0..75dff33 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -429,9 +429,9 @@ void ieee80211_request_smps_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.request_smps_work);
 
-	mutex_lock(&sdata->u.mgd.mtx);
+	sdata_lock(sdata);
 	__ieee80211_request_smps(sdata, sdata->u.mgd.driver_smps_mode);
-	mutex_unlock(&sdata->u.mgd.mtx);
+	sdata_unlock(sdata);
 }
 
 void ieee80211_request_smps(struct ieee80211_vif *vif,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 170f9a7..3b305f3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -54,7 +54,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp;
 	int frame_len;
 
-	lockdep_assert_held(&ifibss->mtx);
+	sdata_assert_lock(sdata);
 
 	/* Reset own TSF to allow time synchronization work. */
 	drv_reset_tsf(local, sdata);
@@ -74,7 +74,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	}
 
 	presp = rcu_dereference_protected(ifibss->presp,
-					  lockdep_is_held(&ifibss->mtx));
+					  lockdep_is_held(&sdata->wdev.mtx));
 	rcu_assign_pointer(ifibss->presp, NULL);
 	if (presp)
 		kfree_rcu(presp, rcu_head);
@@ -263,7 +263,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	const struct cfg80211_bss_ies *ies;
 	u64 tsf;
 
-	lockdep_assert_held(&sdata->u.ibss.mtx);
+	sdata_assert_lock(sdata);
 
 	if (beacon_int < 10)
 		beacon_int = 10;
@@ -408,7 +408,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	u8 deauth_frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
-	lockdep_assert_held(&sdata->u.ibss.mtx);
+	sdata_assert_lock(sdata);
 
 	if (len < 24 + 6)
 		return;
@@ -673,7 +673,7 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 	int active = 0;
 	struct sta_info *sta;
 
-	lockdep_assert_held(&sdata->u.ibss.mtx);
+	sdata_assert_lock(sdata);
 
 	rcu_read_lock();
 
@@ -699,7 +699,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	lockdep_assert_held(&ifibss->mtx);
+	sdata_assert_lock(sdata);
 
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
@@ -730,7 +730,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 	u16 capability;
 	int i;
 
-	lockdep_assert_held(&ifibss->mtx);
+	sdata_assert_lock(sdata);
 
 	if (ifibss->fixed_bssid) {
 		memcpy(bssid, ifibss->bssid, ETH_ALEN);
@@ -773,7 +773,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	int active_ibss;
 	u16 capability;
 
-	lockdep_assert_held(&ifibss->mtx);
+	sdata_assert_lock(sdata);
 
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 	ibss_dbg(sdata, "sta_find_ibss (active_ibss=%d)\n", active_ibss);
@@ -843,10 +843,10 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp;
 	u8 *pos, *end;
 
-	lockdep_assert_held(&ifibss->mtx);
+	sdata_assert_lock(sdata);
 
 	presp = rcu_dereference_protected(ifibss->presp,
-					  lockdep_is_held(&ifibss->mtx));
+					  lockdep_is_held(&sdata->wdev.mtx));
 
 	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED ||
 	    len < 24 + 2 || !presp)
@@ -930,7 +930,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
-	mutex_lock(&sdata->u.ibss.mtx);
+	sdata_lock(sdata);
 
 	if (!sdata->u.ibss.ssid_len)
 		goto mgmt_out; /* not ready to merge yet */
@@ -953,7 +953,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	}
 
  mgmt_out:
-	mutex_unlock(&sdata->u.ibss.mtx);
+	sdata_unlock(sdata);
 }
 
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
@@ -961,7 +961,7 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct sta_info *sta;
 
-	mutex_lock(&ifibss->mtx);
+	sdata_lock(sdata);
 
 	/*
 	 * Work could be scheduled after scan or similar
@@ -997,7 +997,7 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 	}
 
  out:
-	mutex_unlock(&ifibss->mtx);
+	sdata_unlock(sdata);
 }
 
 static void ieee80211_ibss_timer(unsigned long data)
@@ -1014,7 +1014,6 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
-	mutex_init(&ifibss->mtx);
 	INIT_LIST_HEAD(&ifibss->incomplete_stations);
 	spin_lock_init(&ifibss->incomplete_lock);
 }
@@ -1041,8 +1040,6 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 {
 	u32 changed = 0;
 
-	mutex_lock(&sdata->u.ibss.mtx);
-
 	if (params->bssid) {
 		memcpy(sdata->u.ibss.bssid, params->bssid, ETH_ALEN);
 		sdata->u.ibss.fixed_bssid = true;
@@ -1075,8 +1072,6 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
-	mutex_unlock(&sdata->u.ibss.mtx);
-
 	/*
 	 * 802.11n-2009 9.13.3.1: In an IBSS, the HT Protection field is
 	 * reserved, but an HT STA shall protect HT transmissions as though
@@ -1112,8 +1107,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	struct sta_info *sta;
 	struct beacon_data *presp;
 
-	mutex_lock(&sdata->u.ibss.mtx);
-
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -1157,7 +1150,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	/* remove beacon */
 	kfree(sdata->u.ibss.ie);
 	presp = rcu_dereference_protected(ifibss->presp,
-					  lockdep_is_held(&sdata->u.ibss.mtx));
+					  lockdep_is_held(&sdata->wdev.mtx));
 	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
 	sdata->vif.bss_conf.ibss_joined = false;
 	sdata->vif.bss_conf.ibss_creator = false;
@@ -1173,7 +1166,5 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 
 	del_timer_sync(&sdata->u.ibss.timer);
 
-	mutex_unlock(&sdata->u.ibss.mtx);
-
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 44be28cfc..2e75459 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -394,7 +394,6 @@ struct ieee80211_if_managed {
 	bool nullfunc_failed;
 	bool connection_loss;
 
-	struct mutex mtx;
 	struct cfg80211_bss *associated;
 	struct ieee80211_mgd_auth_data *auth_data;
 	struct ieee80211_mgd_assoc_data *assoc_data;
@@ -488,8 +487,6 @@ struct ieee80211_if_managed {
 struct ieee80211_if_ibss {
 	struct timer_list timer;
 
-	struct mutex mtx;
-
 	unsigned long last_scan_completed;
 
 	u32 basic_rates;
@@ -580,8 +577,6 @@ struct ieee80211_if_mesh {
 	bool accepting_plinks;
 	int num_gates;
 	struct beacon_data __rcu *beacon;
-	/* just protects beacon updates for now */
-	struct mutex mtx;
 	const u8 *ie;
 	u8 ie_len;
 	enum {
@@ -778,6 +773,26 @@ struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
 	return container_of(p, struct ieee80211_sub_if_data, vif);
 }
 
+static inline void sdata_lock(struct ieee80211_sub_if_data *sdata)
+	__acquires(&sdata->wdev.mtx)
+{
+	mutex_lock(&sdata->wdev.mtx);
+	__acquire(&sdata->wdev.mtx);
+}
+
+static inline void sdata_unlock(struct ieee80211_sub_if_data *sdata)
+	__releases(&sdata->wdev.mtx)
+{
+	mutex_unlock(&sdata->wdev.mtx);
+	__release(&sdata->wdev.mtx);
+}
+
+static inline void
+sdata_assert_lock(struct ieee80211_sub_if_data *sdata)
+{
+	lockdep_assert_held(&sdata->wdev.mtx);
+}
+
 static inline enum ieee80211_band
 ieee80211_get_sdata_band(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8a7bfc4..1998f14 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -331,7 +331,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	ifmgd = &sdata->u.mgd;
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 
 	/* Copy the addresses to the bss_conf list */
 	ifa = idev->ifa_list;
@@ -349,7 +349,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 		ieee80211_bss_info_change_notify(sdata,
 						 BSS_CHANGED_ARP_FILTER);
 
-	mutex_unlock(&ifmgd->mtx);
+	sdata_unlock(sdata);
 
 	return NOTIFY_DONE;
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 07a3eb5..889d64b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -91,41 +91,6 @@ MODULE_PARM_DESC(probe_wait_ms,
 #define IEEE80211_SIGNAL_AVE_MIN_COUNT	4
 
 /*
- * All cfg80211 functions have to be called outside a locked
- * section so that they can acquire a lock themselves... This
- * is much simpler than queuing up things in cfg80211, but we
- * do need some indirection for that here.
- */
-enum rx_mgmt_action {
-	/* no action required */
-	RX_MGMT_NONE,
-
-	/* caller must call cfg80211_send_deauth() */
-	RX_MGMT_CFG80211_DEAUTH,
-
-	/* caller must call cfg80211_send_disassoc() */
-	RX_MGMT_CFG80211_DISASSOC,
-
-	/* caller must call cfg80211_send_rx_auth() */
-	RX_MGMT_CFG80211_RX_AUTH,
-
-	/* caller must call cfg80211_send_rx_assoc() */
-	RX_MGMT_CFG80211_RX_ASSOC,
-
-	/* caller must call cfg80211_send_assoc_timeout() */
-	RX_MGMT_CFG80211_ASSOC_TIMEOUT,
-
-	/* used when a processed beacon causes a deauth */
-	RX_MGMT_CFG80211_TX_DEAUTH,
-};
-
-/* utils */
-static inline void ASSERT_MGD_MTX(struct ieee80211_if_managed *ifmgd)
-{
-	lockdep_assert_held(&ifmgd->mtx);
-}
-
-/*
  * We can have multiple work items (and connection probing)
  * scheduling this timer, but we need to take care to only
  * reschedule it when it should fire _earlier_ than it was
@@ -135,13 +100,14 @@ static inline void ASSERT_MGD_MTX(struct ieee80211_if_managed *ifmgd)
  * has happened -- the work that runs from this timer will
  * do that.
  */
-static void run_again(struct ieee80211_if_managed *ifmgd, unsigned long timeout)
+static void run_again(struct ieee80211_sub_if_data *sdata,
+		      unsigned long timeout)
 {
-	ASSERT_MGD_MTX(ifmgd);
+	sdata_assert_lock(sdata);
 
-	if (!timer_pending(&ifmgd->timer) ||
-	    time_before(timeout, ifmgd->timer.expires))
-		mod_timer(&ifmgd->timer, timeout);
+	if (!timer_pending(&sdata->u.mgd.timer) ||
+	    time_before(timeout, sdata->u.mgd.timer.expires))
+		mod_timer(&sdata->u.mgd.timer, timeout);
 }
 
 void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
@@ -652,7 +618,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_channel *chan;
 	u32 rates = 0;
 
-	lockdep_assert_held(&ifmgd->mtx);
+	sdata_assert_lock(sdata);
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
@@ -962,7 +928,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 	if (!ifmgd->associated)
 		goto out;
 
@@ -985,7 +951,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 					IEEE80211_QUEUE_STOP_REASON_CSA);
  out:
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
-	mutex_unlock(&ifmgd->mtx);
+	sdata_unlock(sdata);
 }
 
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
@@ -1036,7 +1002,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	const struct ieee80211_ht_operation *ht_oper;
 	int secondary_channel_offset = -1;
 
-	ASSERT_MGD_MTX(ifmgd);
+	sdata_assert_lock(sdata);
 
 	if (!cbss)
 		return;
@@ -1845,7 +1811,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
 
-	ASSERT_MGD_MTX(ifmgd);
+	sdata_assert_lock(sdata);
 
 	if (WARN_ON_ONCE(tx && !frame_buf))
 		return;
@@ -2054,7 +2020,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	}
 
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
-	run_again(ifmgd, ifmgd->probe_timeout);
+	run_again(sdata, ifmgd->probe_timeout);
 	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
 		ieee80211_flush_queues(sdata->local, sdata);
 }
@@ -2068,7 +2034,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 
 	if (!ifmgd->associated)
 		goto out;
@@ -2122,7 +2088,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	ifmgd->probe_send_count = 0;
 	ieee80211_mgd_probe_ap_send(sdata);
  out:
-	mutex_unlock(&ifmgd->mtx);
+	sdata_unlock(sdata);
 }
 
 struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
@@ -2138,7 +2104,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return NULL;
 
-	ASSERT_MGD_MTX(ifmgd);
+	sdata_assert_lock(sdata);
 
 	if (ifmgd->associated)
 		cbss = ifmgd->associated;
@@ -2171,9 +2137,9 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 	if (!ifmgd->associated) {
-		mutex_unlock(&ifmgd->mtx);
+		sdata_unlock(sdata);
 		return;
 	}
 
@@ -2184,13 +2150,9 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-	mutex_unlock(&ifmgd->mtx);
 
-	/*
-	 * must be outside lock due to cfg80211,
-	 * but that's not a problem.
-	 */
 	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
+	sdata_unlock(sdata);
 }
 
 static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
@@ -2257,7 +2219,7 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
 
-	lockdep_assert_held(&sdata->u.mgd.mtx);
+	sdata_assert_lock(sdata);
 
 	if (!assoc) {
 		sta_info_destroy_addr(sdata, auth_data->bss->bssid);
@@ -2298,27 +2260,26 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 			    auth_data->key_idx, tx_flags);
 }
 
-static enum rx_mgmt_action __must_check
-ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
-		       struct ieee80211_mgmt *mgmt, size_t len)
+static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 bssid[ETH_ALEN];
 	u16 auth_alg, auth_transaction, status_code;
 	struct sta_info *sta;
 
-	lockdep_assert_held(&ifmgd->mtx);
+	sdata_assert_lock(sdata);
 
 	if (len < 24 + 6)
-		return RX_MGMT_NONE;
+		return;
 
 	if (!ifmgd->auth_data || ifmgd->auth_data->done)
-		return RX_MGMT_NONE;
+		return;
 
 	memcpy(bssid, ifmgd->auth_data->bss->bssid, ETH_ALEN);
 
 	if (!ether_addr_equal(bssid, mgmt->bssid))
-		return RX_MGMT_NONE;
+		return;
 
 	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
@@ -2330,14 +2291,15 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 			   mgmt->sa, auth_alg, ifmgd->auth_data->algorithm,
 			   auth_transaction,
 			   ifmgd->auth_data->expected_transaction);
-		return RX_MGMT_NONE;
+		return;
 	}
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		sdata_info(sdata, "%pM denied authentication (status %d)\n",
 			   mgmt->sa, status_code);
 		ieee80211_destroy_auth_data(sdata, false);
-		return RX_MGMT_CFG80211_RX_AUTH;
+		cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, len);
+		return;
 	}
 
 	switch (ifmgd->auth_data->algorithm) {
@@ -2350,20 +2312,20 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		if (ifmgd->auth_data->expected_transaction != 4) {
 			ieee80211_auth_challenge(sdata, mgmt, len);
 			/* need another frame */
-			return RX_MGMT_NONE;
+			return;
 		}
 		break;
 	default:
 		WARN_ONCE(1, "invalid auth alg %d",
 			  ifmgd->auth_data->algorithm);
-		return RX_MGMT_NONE;
+		return;
 	}
 
 	sdata_info(sdata, "authenticated\n");
 	ifmgd->auth_data->done = true;
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
 	ifmgd->auth_data->timeout_started = true;
-	run_again(ifmgd, ifmgd->auth_data->timeout);
+	run_again(sdata, ifmgd->auth_data->timeout);
 
 	if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
 	    ifmgd->auth_data->expected_transaction != 2) {
@@ -2371,7 +2333,8 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		 * Report auth frame to user space for processing since another
 		 * round of Authentication frames is still needed.
 		 */
-		return RX_MGMT_CFG80211_RX_AUTH;
+		cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, len);
+		return;
 	}
 
 	/* move station state to auth */
@@ -2387,30 +2350,29 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&sdata->local->sta_mtx);
 
-	return RX_MGMT_CFG80211_RX_AUTH;
+	cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, len);
+	return;
  out_err:
 	mutex_unlock(&sdata->local->sta_mtx);
 	/* ignore frame -- wait for timeout */
-	return RX_MGMT_NONE;
 }
 
 
-static enum rx_mgmt_action __must_check
-ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
-			 struct ieee80211_mgmt *mgmt, size_t len)
+static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *bssid = NULL;
 	u16 reason_code;
 
-	lockdep_assert_held(&ifmgd->mtx);
+	sdata_assert_lock(sdata);
 
 	if (len < 24 + 2)
-		return RX_MGMT_NONE;
+		return;
 
 	if (!ifmgd->associated ||
 	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
-		return RX_MGMT_NONE;
+		return;
 
 	bssid = ifmgd->associated->bssid;
 
@@ -2421,25 +2383,24 @@ ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	return RX_MGMT_CFG80211_DEAUTH;
+	cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, len);
 }
 
 
-static enum rx_mgmt_action __must_check
-ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
-			   struct ieee80211_mgmt *mgmt, size_t len)
+static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u16 reason_code;
 
-	lockdep_assert_held(&ifmgd->mtx);
+	sdata_assert_lock(sdata);
 
 	if (len < 24 + 2)
-		return RX_MGMT_NONE;
+		return;
 
 	if (!ifmgd->associated ||
 	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
-		return RX_MGMT_NONE;
+		return;
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
@@ -2448,7 +2409,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	return RX_MGMT_CFG80211_DISASSOC;
+	cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, len);
 }
 
 static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
@@ -2498,7 +2459,7 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 
-	lockdep_assert_held(&sdata->u.mgd.mtx);
+	sdata_assert_lock(sdata);
 
 	if (!assoc) {
 		sta_info_destroy_addr(sdata, assoc_data->bss->bssid);
@@ -2679,10 +2640,9 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	return true;
 }
 
-static enum rx_mgmt_action __must_check
-ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_mgmt *mgmt, size_t len,
-			     struct cfg80211_bss **bss)
+static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_mgmt *mgmt,
+					 size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
@@ -2690,13 +2650,14 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	struct ieee802_11_elems elems;
 	u8 *pos;
 	bool reassoc;
+	struct cfg80211_bss *bss;
 
-	lockdep_assert_held(&ifmgd->mtx);
+	sdata_assert_lock(sdata);
 
 	if (!assoc_data)
-		return RX_MGMT_NONE;
+		return;
 	if (!ether_addr_equal(assoc_data->bss->bssid, mgmt->bssid))
-		return RX_MGMT_NONE;
+		return;
 
 	/*
 	 * AssocResp and ReassocResp have identical structure, so process both
@@ -2704,7 +2665,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	 */
 
 	if (len < 24 + 6)
-		return RX_MGMT_NONE;
+		return;
 
 	reassoc = ieee80211_is_reassoc_req(mgmt->frame_control);
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
@@ -2731,22 +2692,23 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		assoc_data->timeout = jiffies + msecs_to_jiffies(ms);
 		assoc_data->timeout_started = true;
 		if (ms > IEEE80211_ASSOC_TIMEOUT)
-			run_again(ifmgd, assoc_data->timeout);
-		return RX_MGMT_NONE;
+			run_again(sdata, assoc_data->timeout);
+		return;
 	}
 
-	*bss = assoc_data->bss;
+	bss = assoc_data->bss;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		sdata_info(sdata, "%pM denied association (code=%d)\n",
 			   mgmt->sa, status_code);
 		ieee80211_destroy_assoc_data(sdata, false);
 	} else {
-		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
+		if (!ieee80211_assoc_success(sdata, bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
 			ieee80211_destroy_assoc_data(sdata, false);
-			cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
-			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
+			cfg80211_put_bss(sdata->local->hw.wiphy, bss);
+			cfg80211_send_assoc_timeout(sdata->dev, mgmt->bssid);
+			return;
 		}
 		sdata_info(sdata, "associated\n");
 
@@ -2758,7 +2720,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		ieee80211_destroy_assoc_data(sdata, true);
 	}
 
-	return RX_MGMT_CFG80211_RX_ASSOC;
+	cfg80211_send_rx_assoc(sdata->dev, bss, (u8 *)mgmt, len);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -2772,7 +2734,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_channel *channel;
 	bool need_ps = false;
 
-	lockdep_assert_held(&sdata->u.mgd.mtx);
+	sdata_assert_lock(sdata);
 
 	if ((sdata->u.mgd.associated &&
 	     ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid)) ||
@@ -2831,7 +2793,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd = &sdata->u.mgd;
 
-	ASSERT_MGD_MTX(ifmgd);
+	sdata_assert_lock(sdata);
 
 	if (!ether_addr_equal(mgmt->da, sdata->vif.addr))
 		return; /* ignore ProbeResp to foreign address */
@@ -2856,7 +2818,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 		ifmgd->auth_data->tries = 0;
 		ifmgd->auth_data->timeout = jiffies;
 		ifmgd->auth_data->timeout_started = true;
-		run_again(ifmgd, ifmgd->auth_data->timeout);
+		run_again(sdata, ifmgd->auth_data->timeout);
 	}
 }
 
@@ -2881,10 +2843,10 @@ static const u64 care_about_ies =
 	(1ULL << WLAN_EID_HT_CAPABILITY) |
 	(1ULL << WLAN_EID_HT_OPERATION);
 
-static enum rx_mgmt_action
-ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
-			 struct ieee80211_mgmt *mgmt, size_t len,
-			 u8 *deauth_buf, struct ieee80211_rx_status *rx_status)
+static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgmt *mgmt, size_t len,
+				     u8 *deauth_buf,
+				     struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
@@ -2900,23 +2862,23 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	u32 ncrc;
 	u8 *bssid;
 
-	lockdep_assert_held(&ifmgd->mtx);
+	sdata_assert_lock(sdata);
 
 	/* Process beacon from the current BSS */
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
 	if (baselen > len)
-		return RX_MGMT_NONE;
+		return;
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (!chanctx_conf) {
 		rcu_read_unlock();
-		return RX_MGMT_NONE;
+		return;
 	}
 
 	if (rx_status->freq != chanctx_conf->def.chan->center_freq) {
 		rcu_read_unlock();
-		return RX_MGMT_NONE;
+		return;
 	}
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
@@ -2943,13 +2905,13 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
 		ifmgd->assoc_data->timeout_started = true;
-		run_again(ifmgd, ifmgd->assoc_data->timeout);
-		return RX_MGMT_NONE;
+		run_again(sdata, ifmgd->assoc_data->timeout);
+		return;
 	}
 
 	if (!ifmgd->associated ||
 	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
-		return RX_MGMT_NONE;
+		return;
 	bssid = ifmgd->associated->bssid;
 
 	/* Track average RSSI from the Beacon frames of the current AP */
@@ -3095,7 +3057,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
-		return RX_MGMT_NONE;
+		return;
 	ifmgd->beacon_crc = ncrc;
 	ifmgd->beacon_crc_valid = true;
 
@@ -3151,7 +3113,9 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DEAUTH_LEAVING,
 				       true, deauth_buf);
-		return RX_MGMT_CFG80211_TX_DEAUTH;
+		cfg80211_send_deauth(sdata->dev, deauth_buf,
+				     sizeof(deauth_buf));
+		return;
 	}
 
 	if (sta && elems.opmode_notif)
@@ -3168,18 +3132,13 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 						       elems.pwr_constr_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
-
-	return RX_MGMT_NONE;
 }
 
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
-	struct cfg80211_bss *bss = NULL;
-	enum rx_mgmt_action rma = RX_MGMT_NONE;
 	u8 deauth_buf[IEEE80211_DEAUTH_FRAME_LEN];
 	u16 fc;
 	struct ieee802_11_elems elems;
@@ -3189,28 +3148,28 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_BEACON:
-		rma = ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
-					       deauth_buf, rx_status);
+		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
+					 deauth_buf, rx_status);
 		break;
 	case IEEE80211_STYPE_PROBE_RESP:
 		ieee80211_rx_mgmt_probe_resp(sdata, skb);
 		break;
 	case IEEE80211_STYPE_AUTH:
-		rma = ieee80211_rx_mgmt_auth(sdata, mgmt, skb->len);
+		ieee80211_rx_mgmt_auth(sdata, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_DEAUTH:
-		rma = ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
+		ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_DISASSOC:
-		rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
+		ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
 	case IEEE80211_STYPE_REASSOC_RESP:
-		rma = ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, &bss);
+		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ACTION:
 		if (mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT) {
@@ -3256,34 +3215,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		}
 		break;
 	}
-	mutex_unlock(&ifmgd->mtx);
-
-	switch (rma) {
-	case RX_MGMT_NONE:
-		/* no action */
-		break;
-	case RX_MGMT_CFG80211_DEAUTH:
-		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
-		break;
-	case RX_MGMT_CFG80211_DISASSOC:
-		cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
-		break;
-	case RX_MGMT_CFG80211_RX_AUTH:
-		cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, skb->len);
-		break;
-	case RX_MGMT_CFG80211_RX_ASSOC:
-		cfg80211_send_rx_assoc(sdata->dev, bss, (u8 *)mgmt, skb->len);
-		break;
-	case RX_MGMT_CFG80211_ASSOC_TIMEOUT:
-		cfg80211_send_assoc_timeout(sdata->dev, mgmt->bssid);
-		break;
-	case RX_MGMT_CFG80211_TX_DEAUTH:
-		cfg80211_send_deauth(sdata->dev, deauth_buf,
-				     sizeof(deauth_buf));
-		break;
-	default:
-		WARN(1, "unexpected: %d", rma);
-	}
+	sdata_unlock(sdata);
 }
 
 static void ieee80211_sta_timer(unsigned long data)
@@ -3297,20 +3229,12 @@ static void ieee80211_sta_timer(unsigned long data)
 static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 					  u8 *bssid, u8 reason, bool tx)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
 			       tx, frame_buf);
-	mutex_unlock(&ifmgd->mtx);
 
-	/*
-	 * must be outside lock due to cfg80211,
-	 * but that's not a problem.
-	 */
 	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
-
-	mutex_lock(&ifmgd->mtx);
 }
 
 static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
@@ -3320,7 +3244,7 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_mgd_auth_data *auth_data = ifmgd->auth_data;
 	u32 tx_flags = 0;
 
-	lockdep_assert_held(&ifmgd->mtx);
+	sdata_assert_lock(sdata);
 
 	if (WARN_ON_ONCE(!auth_data))
 		return -EINVAL;
@@ -3393,7 +3317,7 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
 		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 		ifmgd->auth_data->timeout_started = true;
-		run_again(ifmgd, auth_data->timeout);
+		run_again(sdata, auth_data->timeout);
 	} else {
 		auth_data->timeout_started = false;
 	}
@@ -3406,7 +3330,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 	struct ieee80211_local *local = sdata->local;
 
-	lockdep_assert_held(&sdata->u.mgd.mtx);
+	sdata_assert_lock(sdata);
 
 	assoc_data->tries++;
 	if (assoc_data->tries > IEEE80211_ASSOC_MAX_TRIES) {
@@ -3430,7 +3354,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
 		assoc_data->timeout_started = true;
-		run_again(&sdata->u.mgd, assoc_data->timeout);
+		run_again(sdata, assoc_data->timeout);
 	} else {
 		assoc_data->timeout_started = false;
 	}
@@ -3455,7 +3379,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 
 	if (ifmgd->status_received) {
 		__le16 fc = ifmgd->status_fc;
@@ -3467,7 +3391,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			if (status_acked) {
 				ifmgd->auth_data->timeout =
 					jiffies + IEEE80211_AUTH_TIMEOUT_SHORT;
-				run_again(ifmgd, ifmgd->auth_data->timeout);
+				run_again(sdata, ifmgd->auth_data->timeout);
 			} else {
 				ifmgd->auth_data->timeout = jiffies - 1;
 			}
@@ -3478,7 +3402,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			if (status_acked) {
 				ifmgd->assoc_data->timeout =
 					jiffies + IEEE80211_ASSOC_TIMEOUT_SHORT;
-				run_again(ifmgd, ifmgd->assoc_data->timeout);
+				run_again(sdata, ifmgd->assoc_data->timeout);
 			} else {
 				ifmgd->assoc_data->timeout = jiffies - 1;
 			}
@@ -3501,12 +3425,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 			ieee80211_destroy_auth_data(sdata, false);
 
-			mutex_unlock(&ifmgd->mtx);
 			cfg80211_send_auth_timeout(sdata->dev, bssid);
-			mutex_lock(&ifmgd->mtx);
 		}
 	} else if (ifmgd->auth_data && ifmgd->auth_data->timeout_started)
-		run_again(ifmgd, ifmgd->auth_data->timeout);
+		run_again(sdata, ifmgd->auth_data->timeout);
 
 	if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started &&
 	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
@@ -3519,12 +3441,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 			ieee80211_destroy_assoc_data(sdata, false);
 
-			mutex_unlock(&ifmgd->mtx);
 			cfg80211_send_assoc_timeout(sdata->dev, bssid);
-			mutex_lock(&ifmgd->mtx);
 		}
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
-		run_again(ifmgd, ifmgd->assoc_data->timeout);
+		run_again(sdata, ifmgd->assoc_data->timeout);
 
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL) &&
@@ -3558,7 +3478,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 					false);
 			}
 		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
-			run_again(ifmgd, ifmgd->probe_timeout);
+			run_again(sdata, ifmgd->probe_timeout);
 		else if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
 			mlme_dbg(sdata,
 				 "Failed to send nullfunc to AP %pM after %dms, disconnecting\n",
@@ -3587,7 +3507,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
-	mutex_unlock(&ifmgd->mtx);
+	sdata_unlock(sdata);
 }
 
 static void ieee80211_sta_bcn_mon_timer(unsigned long data)
@@ -3648,9 +3568,9 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 	if (!ifmgd->associated) {
-		mutex_unlock(&ifmgd->mtx);
+		sdata_unlock(sdata);
 		return;
 	}
 
@@ -3661,10 +3581,10 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 					      ifmgd->associated->bssid,
 					      WLAN_REASON_UNSPECIFIED,
 					      true);
-		mutex_unlock(&ifmgd->mtx);
+		sdata_unlock(sdata);
 		return;
 	}
-	mutex_unlock(&ifmgd->mtx);
+	sdata_unlock(sdata);
 }
 #endif
 
@@ -3696,8 +3616,6 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmgd->uapsd_max_sp_len = sdata->local->hw.uapsd_max_sp_len;
 	ifmgd->p2p_noa_index = -1;
 
-	mutex_init(&ifmgd->mtx);
-
 	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
 		ifmgd->req_smps = IEEE80211_SMPS_AUTOMATIC;
 	else
@@ -4053,8 +3971,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 
 	/* try to authenticate/probe */
 
-	mutex_lock(&ifmgd->mtx);
-
 	if ((ifmgd->auth_data && !ifmgd->auth_data->done) ||
 	    ifmgd->assoc_data) {
 		err = -EBUSY;
@@ -4084,8 +4000,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 
 	/* hold our own reference */
 	cfg80211_ref_bss(local->hw.wiphy, auth_data->bss);
-	err = 0;
-	goto out_unlock;
+	return 0;
 
  err_clear:
 	memset(ifmgd->bssid, 0, ETH_ALEN);
@@ -4093,9 +4008,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	ifmgd->auth_data = NULL;
  err_free:
 	kfree(auth_data);
- out_unlock:
-	mutex_unlock(&ifmgd->mtx);
-
 	return err;
 }
 
@@ -4126,8 +4038,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	assoc_data->ssid_len = ssidie[1];
 	rcu_read_unlock();
 
-	mutex_lock(&ifmgd->mtx);
-
 	if (ifmgd->associated)
 		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
@@ -4322,7 +4232,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 	rcu_read_unlock();
 
-	run_again(ifmgd, assoc_data->timeout);
+	run_again(sdata, assoc_data->timeout);
 
 	if (bss->corrupt_data) {
 		char *corrupt_type = "data";
@@ -4338,17 +4248,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			   corrupt_type);
 	}
 
-	err = 0;
-	goto out;
+	return 0;
  err_clear:
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->assoc_data = NULL;
  err_free:
 	kfree(assoc_data);
- out:
-	mutex_unlock(&ifmgd->mtx);
-
 	return err;
 }
 
@@ -4360,8 +4266,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	bool tx = !req->local_state_change;
 	bool sent_frame = false;
 
-	mutex_lock(&ifmgd->mtx);
-
 	sdata_info(sdata,
 		   "deauthenticating from %pM by local choice (reason=%d)\n",
 		   req->bssid, req->reason_code);
@@ -4373,7 +4277,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 					       req->reason_code, tx,
 					       frame_buf);
 		ieee80211_destroy_auth_data(sdata, false);
-		mutex_unlock(&ifmgd->mtx);
+		sdata_unlock(sdata);
 
 		sent_frame = tx;
 		goto out;
@@ -4385,12 +4289,11 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 				       req->reason_code, tx, frame_buf);
 		sent_frame = tx;
 	}
-	mutex_unlock(&ifmgd->mtx);
 
  out:
 	if (sent_frame)
-		__cfg80211_send_deauth(sdata->dev, frame_buf,
-				       IEEE80211_DEAUTH_FRAME_LEN);
+		cfg80211_send_deauth(sdata->dev, frame_buf,
+				     IEEE80211_DEAUTH_FRAME_LEN);
 
 	return 0;
 }
@@ -4402,8 +4305,6 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 	u8 bssid[ETH_ALEN];
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
-	mutex_lock(&ifmgd->mtx);
-
 	/*
 	 * cfg80211 should catch this ... but it's racy since
 	 * we can receive a disassoc frame, process it, hand it
@@ -4411,7 +4312,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 	 * trying to tell us that the user wants to disconnect.
 	 */
 	if (ifmgd->associated != req->bss) {
-		mutex_unlock(&ifmgd->mtx);
+		sdata_unlock(sdata);
 		return -ENOLINK;
 	}
 
@@ -4423,10 +4324,9 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DISASSOC,
 			       req->reason_code, !req->local_state_change,
 			       frame_buf);
-	mutex_unlock(&ifmgd->mtx);
 
-	__cfg80211_send_disassoc(sdata->dev, frame_buf,
-				 IEEE80211_DEAUTH_FRAME_LEN);
+	cfg80211_send_disassoc(sdata->dev, frame_buf,
+			       IEEE80211_DEAUTH_FRAME_LEN);
 
 	return 0;
 }
@@ -4446,13 +4346,13 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	cancel_work_sync(&ifmgd->csa_connection_drop_work);
 	cancel_work_sync(&ifmgd->chswitch_work);
 
-	mutex_lock(&ifmgd->mtx);
+	sdata_lock(sdata);
 	if (ifmgd->assoc_data)
 		ieee80211_destroy_assoc_data(sdata, false);
 	if (ifmgd->auth_data)
 		ieee80211_destroy_auth_data(sdata, false);
 	del_timer_sync(&ifmgd->timer);
-	mutex_unlock(&ifmgd->mtx);
+	sdata_unlock(sdata);
 }
 
 void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 27e0715..16366b3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1607,9 +1607,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			if (sdata->u.mgd.dtim_period)
 				changed |= BSS_CHANGED_DTIM_PERIOD;
 
-			mutex_lock(&sdata->u.mgd.mtx);
+			sdata_lock(sdata);
 			ieee80211_bss_info_change_notify(sdata, changed);
-			mutex_unlock(&sdata->u.mgd.mtx);
+			sdata_unlock(sdata);
 			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 2f9d20c..06e982d 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -25,12 +25,9 @@ void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
 	trace_cfg80211_send_rx_auth(dev);
-	wdev_lock(wdev);
 
 	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
 	cfg80211_sme_rx_auth(dev, buf, len);
-
-	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_auth);
 
@@ -46,7 +43,6 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
 	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
 
 	trace_cfg80211_send_rx_assoc(dev, bss);
-	wdev_lock(wdev);
 
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
@@ -59,7 +55,7 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
 	if (status_code != WLAN_STATUS_SUCCESS && wdev->conn &&
 	    cfg80211_sme_failed_reassoc(wdev)) {
 		cfg80211_put_bss(wiphy, bss);
-		goto out;
+		return;
 	}
 
 	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL);
@@ -71,7 +67,7 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
 		 * sme will schedule work that does it later.
 		 */
 		cfg80211_put_bss(wiphy, bss);
-		goto out;
+		return;
 	}
 
 	if (!wdev->conn && wdev->sme_state == CFG80211_SME_IDLE) {
@@ -87,13 +83,11 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
 	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
 				  status_code,
 				  status_code == WLAN_STATUS_SUCCESS, bss);
- out:
-	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
-void __cfg80211_send_deauth(struct net_device *dev,
-				   const u8 *buf, size_t len)
+void cfg80211_send_deauth(struct net_device *dev,
+			  const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -102,7 +96,7 @@ void __cfg80211_send_deauth(struct net_device *dev,
 	const u8 *bssid = mgmt->bssid;
 	bool was_current = false;
 
-	trace___cfg80211_send_deauth(dev);
+	trace_cfg80211_send_deauth(dev);
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (wdev->current_bss &&
@@ -129,20 +123,10 @@ void __cfg80211_send_deauth(struct net_device *dev,
 					  false, NULL);
 	}
 }
-EXPORT_SYMBOL(__cfg80211_send_deauth);
-
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-
-	wdev_lock(wdev);
-	__cfg80211_send_deauth(dev, buf, len);
-	wdev_unlock(wdev);
-}
 EXPORT_SYMBOL(cfg80211_send_deauth);
 
-void __cfg80211_send_disassoc(struct net_device *dev,
-				     const u8 *buf, size_t len)
+void cfg80211_send_disassoc(struct net_device *dev,
+			    const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -152,7 +136,7 @@ void __cfg80211_send_disassoc(struct net_device *dev,
 	u16 reason_code;
 	bool from_ap;
 
-	trace___cfg80211_send_disassoc(dev);
+	trace_cfg80211_send_disassoc(dev);
 	ASSERT_WDEV_LOCK(wdev);
 
 	nl80211_send_disassoc(rdev, dev, buf, len, GFP_KERNEL);
@@ -175,16 +159,6 @@ void __cfg80211_send_disassoc(struct net_device *dev,
 	from_ap = !ether_addr_equal(mgmt->sa, dev->dev_addr);
 	__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 }
-EXPORT_SYMBOL(__cfg80211_send_disassoc);
-
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-
-	wdev_lock(wdev);
-	__cfg80211_send_disassoc(dev, buf, len);
-	wdev_unlock(wdev);
-}
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
 void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
@@ -194,15 +168,12 @@ void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
 	trace_cfg80211_send_auth_timeout(dev, addr);
-	wdev_lock(wdev);
 
 	nl80211_send_auth_timeout(rdev, dev, addr, GFP_KERNEL);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
 					  false, NULL);
-
-	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_auth_timeout);
 
@@ -213,15 +184,12 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
 	trace_cfg80211_send_assoc_timeout(dev, addr);
-	wdev_lock(wdev);
 
 	nl80211_send_assoc_timeout(rdev, dev, addr, GFP_KERNEL);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
 					  false, NULL);
-
-	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5755bc1..23fafea 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1911,12 +1911,12 @@ TRACE_EVENT(cfg80211_send_rx_assoc,
 		  NETDEV_PR_ARG, MAC_PR_ARG(bssid), CHAN_PR_ARG)
 );
 
-DEFINE_EVENT(netdev_evt_only, __cfg80211_send_deauth,
+DEFINE_EVENT(netdev_evt_only, cfg80211_send_deauth,
 	TP_PROTO(struct net_device *netdev),
 	TP_ARGS(netdev)
 );
 
-DEFINE_EVENT(netdev_evt_only, __cfg80211_send_disassoc,
+DEFINE_EVENT(netdev_evt_only, cfg80211_send_disassoc,
 	TP_PROTO(struct net_device *netdev),
 	TP_ARGS(netdev)
 );
-- 
1.8.0

