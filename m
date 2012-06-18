Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46897 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2FRK6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 06:58:05 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 2/5] mac80211: bind FIF_* parameters to interface.
Date: Mon, 18 Jun 2012 12:57:12 +0200
Message-ID: <1340017035-7657-3-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120618_125820_879325_497BFFAE)
In-Reply-To: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following flags:
	FIF_PROMISC_IN_BSS
	FIF_ALLMULTI
	FIF_FCSFAIL
	FIF_PLCPFAIL
	FIF_BCN_PRBRESP_PROMISC
	FIF_CONTROL
	FIF_OTHER_BSS
	FIF_PSPOLL
	FIF_PROBE_REQ
are now bound to ieee80211_sub_if_data, not to
ieee80211_local. Requested flags are stored in new
field of ieee80211_sub_if_data: req_filt_flags.

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 net/mac80211/cfg.c         |    4 +-
 net/mac80211/ieee80211_i.h |   10 +-----
 net/mac80211/iface.c       |   73 +++++++++----------------------------------
 net/mac80211/main.c        |   35 ++++++++-------------
 net/mac80211/mesh.c        |    8 ++--
 5 files changed, 37 insertions(+), 93 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d3ae0df..a4020bd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2494,9 +2494,9 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 		return;
 
 	if (reg)
-		local->probe_req_reg++;
+		sdata->req_filt_flags |= FIF_PROBE_REQ;
 	else
-		local->probe_req_reg--;
+		sdata->req_filt_flags &= ~FIF_PROBE_REQ;
 
 	ieee80211_queue_work(&local->hw, &sdata->reconfig_filter);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 78fc9cc..2dc7aa2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -730,6 +730,8 @@ struct ieee80211_sub_if_data {
 	/* used for uploading changed mc list */
 	struct work_struct reconfig_filter;
 
+	unsigned int filter_flags, req_filt_flags; /* FIF_* */
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
@@ -841,11 +843,6 @@ struct ieee80211_local {
 
 	int open_count;
 	int monitors, cooked_mntrs;
-	/* number of interfaces with corresponding FIF_ flags */
-	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll,
-	    fif_probe_req;
-	int probe_req_reg;
-	unsigned int filter_flags; /* FIF_* */
 
 	bool wiphy_ciphers_allocated;
 
@@ -923,9 +920,6 @@ struct ieee80211_local {
 
 	atomic_t agg_queue_stop[IEEE80211_MAX_QUEUES];
 
-	/* number of interfaces with corresponding IFF_ flags */
-	atomic_t iff_allmultis, iff_promiscs;
-
 	struct rate_control_ref *rate_ctrl;
 
 	struct crypto_cipher *wep_tx_tfm;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 059388b..8e6eebd 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -181,19 +181,22 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
 void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 				    const int offset)
 {
-	struct ieee80211_local *local = sdata->local;
-	u32 flags = sdata->u.mntr_flags;
+	u32 flags = sdata->u.mntr_flags, req_flags = 0;
 
-#define ADJUST(_f, _s)	do {					\
-	if (flags & MONITOR_FLAG_##_f)				\
-		local->fif_##_s += offset;			\
+#define ADJUST(_f, _s) do {\
+	if (flags & MONITOR_FLAG_##_f)\
+		req_flags |= _s;\
 	} while (0)
 
-	ADJUST(FCSFAIL, fcsfail);
-	ADJUST(PLCPFAIL, plcpfail);
-	ADJUST(CONTROL, control);
-	ADJUST(CONTROL, pspoll);
-	ADJUST(OTHER_BSS, other_bss);
+	ADJUST(PLCPFAIL, FIF_PLCPFAIL);
+	ADJUST(CONTROL, FIF_PSPOLL);
+	ADJUST(CONTROL, FIF_CONTROL);
+	ADJUST(FCSFAIL, FIF_FCSFAIL);
+	ADJUST(OTHER_BSS, FIF_OTHER_BSS);
+	if (offset > 0)
+		sdata->req_filt_flags |= req_flags;
+	else
+		sdata->req_filt_flags &= ~req_flags;
 
 #undef ADJUST
 }
@@ -402,12 +405,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		}
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP) {
-			local->fif_pspoll++;
-			local->fif_probe_req++;
-
 			ieee80211_configure_filter(sdata);
-		} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-			local->fif_probe_req++;
 		}
 
 		changed |= ieee80211_reset_erp_info(sdata);
@@ -452,17 +450,6 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		rate_control_rate_init(sta);
 	}
 
-	/*
-	 * set_multicast_list will be invoked by the networking core
-	 * which will check whether any increments here were done in
-	 * error and sync them down to the hardware as filter flags.
-	 */
-	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
-		atomic_inc(&local->iff_allmultis);
-
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
-		atomic_inc(&local->iff_promiscs);
-
 	mutex_lock(&local->mtx);
 	hw_reconf_flags |= __ieee80211_recalc_idle(local);
 	mutex_unlock(&local->mtx);
@@ -546,25 +533,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	 */
 	sta_info_flush(local, sdata);
 
-	/*
-	 * Don't count this interface for promisc/allmulti while it
-	 * is down. dev_mc_unsync() will invoke set_multicast_list
-	 * on the master interface which will sync these down to the
-	 * hardware as filter flags.
-	 */
-	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
-		atomic_dec(&local->iff_allmultis);
-
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
-		atomic_dec(&local->iff_promiscs);
-
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		local->fif_pspoll--;
-		local->fif_probe_req--;
-	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		local->fif_probe_req--;
-	}
-
 	netif_addr_lock_bh(sdata->dev);
 	spin_lock_bh(&sdata->filter_lock);
 	__hw_addr_unsync(&local->mc_list, &sdata->dev->mc,
@@ -726,21 +694,12 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 	sdata_allmulti = !!(sdata->flags & IEEE80211_SDATA_ALLMULTI);
 	sdata_promisc = !!(sdata->flags & IEEE80211_SDATA_PROMISC);
 
-	if (allmulti != sdata_allmulti) {
-		if (dev->flags & IFF_ALLMULTI)
-			atomic_inc(&local->iff_allmultis);
-		else
-			atomic_dec(&local->iff_allmultis);
+	if (allmulti != sdata_allmulti)
 		sdata->flags ^= IEEE80211_SDATA_ALLMULTI;
-	}
 
-	if (promisc != sdata_promisc) {
-		if (dev->flags & IFF_PROMISC)
-			atomic_inc(&local->iff_promiscs);
-		else
-			atomic_dec(&local->iff_promiscs);
+	if (promisc != sdata_promisc)
 		sdata->flags ^= IEEE80211_SDATA_PROMISC;
-	}
+
 	spin_lock_bh(&sdata->filter_lock);
 	__hw_addr_sync(&local->mc_list, &dev->mc, dev->addr_len);
 	spin_unlock_bh(&sdata->filter_lock);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 14c990a..6adc1d2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -45,36 +45,27 @@ void ieee80211_configure_filter(struct ieee80211_sub_if_data *sdata)
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	if (atomic_read(&local->iff_promiscs))
-		new_flags |= FIF_PROMISC_IN_BSS;
-
-	if (atomic_read(&local->iff_allmultis))
+	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
 		new_flags |= FIF_ALLMULTI;
 
-	if (local->monitors || test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning))
+	if (sdata->flags & IEEE80211_SDATA_PROMISC)
+		new_flags |= FIF_PROMISC_IN_BSS;
+
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+			local->scan_sdata == sdata)
 		new_flags |= FIF_BCN_PRBRESP_PROMISC;
 
-	if (local->fif_probe_req || local->probe_req_reg)
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+			sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		new_flags |= FIF_PROBE_REQ;
 
-	if (local->fif_fcsfail)
-		new_flags |= FIF_FCSFAIL;
-
-	if (local->fif_plcpfail)
-		new_flags |= FIF_PLCPFAIL;
-
-	if (local->fif_control)
-		new_flags |= FIF_CONTROL;
-
-	if (local->fif_other_bss)
-		new_flags |= FIF_OTHER_BSS;
-
-	if (local->fif_pspoll)
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		new_flags |= FIF_PSPOLL;
 
+	new_flags |= sdata->req_filt_flags;
+
 	spin_lock_bh(&sdata->filter_lock);
-	changed_flags = local->filter_flags ^ new_flags;
+	changed_flags = sdata->filter_flags ^ new_flags;
 
 	mc = drv_prepare_multicast(local, &local->mc_list);
 	spin_unlock_bh(&sdata->filter_lock);
@@ -86,7 +77,7 @@ void ieee80211_configure_filter(struct ieee80211_sub_if_data *sdata)
 
 	WARN_ON(new_flags & (1<<31));
 
-	local->filter_flags = new_flags & ~(1<<31);
+	sdata->filter_flags = new_flags & ~(1<<31);
 }
 
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 94acc1c..28cc48d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -582,9 +582,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 
-	local->fif_other_bss++;
+	sdata->req_filt_flags |= FIF_OTHER_BSS;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
-	atomic_inc(&local->iff_allmultis);
+	sdata->flags |= IEEE80211_SDATA_ALLMULTI;
 	ieee80211_configure_filter(sdata);
 
 	ifmsh->mesh_cc_id = 0;	/* Disabled */
@@ -629,8 +629,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	 */
 	cancel_work_sync(&sdata->work);
 
-	local->fif_other_bss--;
-	atomic_dec(&local->iff_allmultis);
+	sdata->req_filt_flags &= ~(FIF_OTHER_BSS);
+	sdata->flags &= ~IEEE80211_SDATA_ALLMULTI;
 	ieee80211_configure_filter(sdata);
 }
 
-- 
1.7.0.4

