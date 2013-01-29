Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:41302 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3A2MYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 07:24:15 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv7 1/3] nl80211/cfg80211: add radar detection command/event
Date: Tue, 29 Jan 2013 13:21:58 +0100
Message-Id: <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130129_132423_244057_E14C1917)
In-Reply-To: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Add new NL80211_CMD_RADAR_DETECT, which starts the Channel Availability
Check (CAC). This command will also notify the usermode about events
(CAC finished, CAC aborted, radar detected).
Once radar detection has started it should continuously
monitor for radars as long as the channel is active.

Add new NL80211_FEATURE_DFS attribute which
indicates that driver/HW supports radar detection.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
[siwu@hrz.tu-chemnitz.de: change to chandef, add radar checking function
	to cfg80211, handle CAC and Non-Occupancy Period (NOP), add
	tracing, various fixes]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
Changes to PATCHv6:
 * use chandef in radar_detected_notify()
 * add channel states, and handle them in cfg80211
 * add Channel Switch Announcement (CAC) and Non-Occupancy Period (NOP)
   handling to cfg80211
 * add cfg80211_chandef_dfs_required function
 * add tracing for wireless event/functions

Changes to PATCHv5:
 * remove unused cac_type
 * fix doc for cac_started
 * remove dfs_nlportid
---
 include/net/cfg80211.h       |   57 ++++++++++++++++++
 include/uapi/linux/nl80211.h |   31 ++++++++++
 net/wireless/chan.c          |  130 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/core.c          |    3 +
 net/wireless/core.h          |    8 +++
 net/wireless/mlme.c          |  111 ++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  106 ++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |    7 +++
 net/wireless/reg.c           |    3 +
 net/wireless/trace.h         |   33 +++++++++++
 10 files changed, 487 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 970da44..2ee2eb6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -114,6 +114,24 @@ enum ieee80211_channel_flags {
 	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
 
 /**
+ * enum ieee80211_dfs_state - DFS states for channels
+ *
+ * Channel states used by the DFS code.
+ *
+ * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
+ *	check (CAC) must be performed before using it for AP or IBSS.
+ * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
+ *	is therefore marked as not available.
+ * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
+ */
+
+enum ieee80211_dfs_state {
+	IEEE80211_DFS_USABLE,
+	IEEE80211_DFS_UNAVAILABLE,
+	IEEE80211_DFS_AVAILABLE,
+};
+
+/**
  * struct ieee80211_channel - channel definition
  *
  * This structure describes a single channel for use
@@ -133,6 +151,9 @@ enum ieee80211_channel_flags {
  *	to enable this, this is useful only on 5 GHz band.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
+ * @dfs_state: current state of this channel. Only relevant if radar is required
+ *	on this channel.
+ * @dfs_state_entered: time when the dfs state was entered.
  */
 struct ieee80211_channel {
 	enum ieee80211_band band;
@@ -145,6 +166,8 @@ struct ieee80211_channel {
 	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	enum ieee80211_dfs_state dfs_state;
+	unsigned long dfs_state_entered;
 };
 
 /**
@@ -412,6 +435,16 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			     u32 prohibited_flags);
 
 /**
+ * cfg80211_chandef_dfs_required - checks if radar detection
+ *	is required on any of the channels
+ * @wiphy: the wiphy to validate against
+ * @chandef: the channel definition to check
+ * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
+ */
+int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
+				  const struct cfg80211_chan_def *c);
+
+/**
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
@@ -1796,6 +1829,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2016,6 +2051,10 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*start_radar_detection)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct cfg80211_chan_def *chandef);
 };
 
 /*
@@ -2587,6 +2626,7 @@ struct cfg80211_cached_keys;
  *	beacons, 0 when not valid
  * @address: The address for this device, valid only if @netdev is %NULL
  * @p2p_started: true if this is a P2P Device that has been started
+ * @cac_started: true if DFS channel availability check has been started
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2638,6 +2678,8 @@ struct wireless_dev {
 
 	u32 ap_unexpected_nlportid;
 
+	bool cac_started;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -3629,6 +3671,21 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      gfp_t gfp);
 
 /**
+ * cfg80211_radar - radar detection event
+ * @dev: network device
+ * @chandef: chandef for the current channel
+ * @event: type of event
+ * @gfp: context flags
+ *
+ * This function is called when a radar is detected or a CAC event occured
+ * on the current channel. This must be called to notify the completion of
+ * a CAC process, also by full-MAC drivers.
+ */
+void cfg80211_radar_event(struct net_device *dev,
+			  struct cfg80211_chan_def *chandef,
+			  enum nl80211_radar_event event, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e6eeb4b..6d27d413 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -586,6 +586,14 @@
  * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
  *	for IBSS or MESH vif.
  *
+ * @NL80211_CMD_RADAR_DETECT: Start a Channel availability check (CAC). Once
+ *	a radar is detected or the channel availability scan (CAC) has finished
+ *	or was aborted, or a radar was detected, usermode will be notified with
+ *	this event. This command is also used to notify userspace about radars
+ *	while operating on this channel.
+ *	%NL80211_ATTR_RADAR_EVENT is used to inform about the type of the
+ *	event.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -736,6 +744,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MCAST_RATE,
 
+	NL80211_CMD_RADAR_DETECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1313,6 +1323,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific power mode
  *	defined in &enum nl80211_mesh_power_mode.
  *
+ * @NL80211_ATTR_RADAR_EVENT: Type of radar event for notification to userspace,
+ *	contains a value of enum nl80211_radar_event (u8).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1585,6 +1598,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_LOCAL_MESH_POWER_MODE,
 
+	NL80211_ATTR_RADAR_EVENT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1640,6 +1655,9 @@ enum nl80211_attrs {
 
 #define NL80211_CQM_TXE_MAX_INTVL		1800
 
+#define NL80211_DFS_MIN_CAC_TIME_MS		60000
+#define NL80211_DFS_MIN_NOP_TIME_MS		(30 * 60 * 1000)
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
@@ -3205,6 +3223,7 @@ enum nl80211_ap_sme_features {
  *	Note that even for drivers that support this, the default is to add
  *	stations in authenticated/associated state, so to add unauthenticated
  *	stations the authenticated/associated bits have to be set in the mask.
+ * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3221,6 +3240,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
+	NL80211_FEATURE_DFS				= 1 << 14,
 };
 
 /**
@@ -3276,4 +3296,15 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 };
 
+/**
+ * enum nl80211_radar_event - type of radar event for DFS operation
+ *
+ * Type of event to be used with NL80211_ATTR_RADAR_EVENT to inform userspace
+ * about detected radars or success of the channel available check (CAC)
+ */
+enum nl80211_radar_event {
+	NL80211_RADAR_DETECTED,
+	NL80211_CAC_FINISHED,
+	NL80211_CAC_ABORTED,
+};
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 396373f..c95b142 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -147,6 +147,32 @@ static void chandef_primary_freqs(const struct cfg80211_chan_def *c,
 	}
 }
 
+static inline u32 cfg80211_chandef_get_width(const struct cfg80211_chan_def *c)
+{
+	u32 width;
+
+	switch (c->width) {
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		width = 20;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		width = 40;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_80:
+		width = 80;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		width = 160;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -1;
+	}
+	return width;
+}
+
 const struct cfg80211_chan_def *
 cfg80211_chandef_compatible(const struct cfg80211_chan_def *c1,
 			    const struct cfg80211_chan_def *c2)
@@ -192,6 +218,94 @@ cfg80211_chandef_compatible(const struct cfg80211_chan_def *c1,
 }
 EXPORT_SYMBOL(cfg80211_chandef_compatible);
 
+static void cfg80211_set_chans_dfs_state(struct wiphy *wiphy, u32 center_freq,
+					 u32 bandwidth,
+					 enum ieee80211_dfs_state dfs_state)
+{
+	struct ieee80211_channel *c;
+	u32 freq;
+
+	for (freq = center_freq - bandwidth/2 + 10;
+	     freq <= center_freq + bandwidth/2 - 10;
+	     freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c || !(c->flags & IEEE80211_CHAN_RADAR))
+			continue;
+
+		c->dfs_state = dfs_state;
+		c->dfs_state_entered = jiffies;
+	}
+}
+
+void cfg80211_set_dfs_state(struct wiphy *wiphy,
+			    const struct cfg80211_chan_def *chandef,
+			    enum ieee80211_dfs_state dfs_state)
+{
+	u32 width;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return;
+
+	width = cfg80211_chandef_get_width(chandef);
+	if (width < 0)
+		return;
+
+	cfg80211_set_chans_dfs_state(wiphy, chandef->center_freq1,
+				     width, dfs_state);
+
+	if (!chandef->center_freq2)
+		return;
+	cfg80211_set_chans_dfs_state(wiphy, chandef->center_freq2,
+				     width, dfs_state);
+}
+
+static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
+					    u32 center_freq,
+					    u32 bandwidth)
+{
+	struct ieee80211_channel *c;
+	u32 freq;
+
+	for (freq = center_freq - bandwidth/2 + 10;
+	     freq <= center_freq + bandwidth/2 - 10;
+	     freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			return -EINVAL;
+
+		if (c->flags & IEEE80211_CHAN_RADAR)
+			return 1;
+	}
+	return 0;
+}
+
+
+int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
+				  const struct cfg80211_chan_def *chandef)
+{
+	u32 width;
+	int r;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return -EINVAL;
+
+	width = cfg80211_chandef_get_width(chandef);
+	if (width < 0)
+		return -EINVAL;
+
+	r = cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq1,
+					    width);
+	if (r)
+		return r;
+
+	if (!chandef->center_freq2)
+		return 0;
+
+	return cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq2,
+					       width);
+}
+EXPORT_SYMBOL(cfg80211_chandef_dfs_required);
+
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
 					u32 prohibited_flags)
@@ -203,7 +317,16 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 	     freq <= center_freq + bandwidth/2 - 10;
 	     freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
-		if (!c || c->flags & prohibited_flags)
+		if (!c)
+			return false;
+
+		/* check for radar flags */
+		if ((prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) &&
+		    (c->dfs_state != IEEE80211_DFS_AVAILABLE))
+			return false;
+
+		/* check for the other flags */
+		if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
 			return false;
 	}
 
@@ -344,7 +467,10 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		if (wdev->beacon_interval) {
+		if (wdev->cac_started) {
+			*chan = wdev->preset_chandef.chan;
+			*chanmode = CHAN_MODE_SHARED;
+		} else if (wdev->beacon_interval) {
 			*chan = wdev->channel;
 			*chanmode = CHAN_MODE_SHARED;
 		}
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9245729..2da47eb 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -324,6 +324,8 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
+	INIT_DELAYED_WORK(&rdev->dfs_update_channels_wk,
+			  cfg80211_dfs_channels_update_work);
 #ifdef CONFIG_CFG80211_WEXT
 	rdev->wiphy.wext = &cfg80211_wext_handler;
 #endif
@@ -690,6 +692,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->scan_done_wk);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
+	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 
 	if (rdev->wowlan && rdev->ops->set_wakeup)
 		rdev_set_wakeup(rdev, false);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 8396f76..fb5d630 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -87,6 +87,8 @@ struct cfg80211_registered_device {
 
 	struct cfg80211_wowlan *wowlan;
 
+	struct delayed_work dfs_update_channels_wk;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __aligned(NETDEV_ALIGN);
@@ -427,6 +429,12 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 struct ieee80211_channel *chan,
 				 enum cfg80211_chan_mode chanmode,
 				 u8 radar_detect);
+void cfg80211_set_dfs_state(struct wiphy *wiphy,
+			    const struct cfg80211_chan_def *chandef,
+			    enum ieee80211_dfs_state dfs_state);
+
+void cfg80211_dfs_channels_update_work(struct work_struct *work);
+
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 461e692..17753f0 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -987,3 +987,114 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
+
+static inline void __cfg80211_dfs_clear_channel(struct ieee80211_channel *c,
+						bool *check_again,
+						unsigned long *check_again_time)
+{
+	unsigned long timeout;
+
+	if (c->dfs_state == IEEE80211_DFS_UNAVAILABLE) {
+		timeout = c->dfs_state_entered + NL80211_DFS_MIN_NOP_TIME_MS;
+		if (time_after_eq(jiffies, timeout)) {
+			/* TODO: we could notify userspace about that change */
+			c->dfs_state = IEEE80211_DFS_USABLE;
+		} else {
+			if (!*check_again)
+				*check_again_time = timeout - jiffies;
+			else
+				*check_again_time = min(*check_again_time,
+							timeout - jiffies);
+			*check_again = true;
+		}
+	}
+}
+
+void cfg80211_dfs_channels_update_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work;
+	struct cfg80211_registered_device *rdev;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *c;
+	struct wiphy *wiphy;
+	bool check_again = false;
+	unsigned long check_again_time = 0;
+	int bandid, i;
+
+	delayed_work = container_of(work, struct delayed_work, work);
+	rdev = container_of(delayed_work, struct cfg80211_registered_device,
+			    dfs_update_channels_wk);
+	wiphy = &rdev->wiphy;
+
+	mutex_lock(&cfg80211_mutex);
+	for (bandid = 0; bandid < IEEE80211_NUM_BANDS; bandid++) {
+		sband = wiphy->bands[bandid];
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_channels; i++) {
+			c = &sband->channels[i];
+
+			__cfg80211_dfs_clear_channel(c, &check_again,
+						     &check_again_time);
+		}
+	}
+	mutex_unlock(&cfg80211_mutex);
+
+	/* reschedule if there are other channels waiting to be cleared again */
+	if (check_again)
+		queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk,
+				   check_again_time);
+}
+
+
+void cfg80211_radar_event(struct net_device *netdev,
+			  struct cfg80211_chan_def *chandef,
+			  enum nl80211_radar_event event,
+			  gfp_t gfp)
+{
+	struct wireless_dev *wdev = netdev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	unsigned long timeout;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return;
+
+	trace_cfg80211_radar_event(netdev, chandef, event);
+
+	switch (event) {
+	case NL80211_RADAR_DETECTED:
+		/*
+		 * only set the chandef supplied channel to unavailable, in
+		 * case the radar is detected on only one of multiple channels
+		 * spanned by the chandef.
+		 */
+		cfg80211_set_dfs_state(wiphy, chandef,
+				       IEEE80211_DFS_UNAVAILABLE);
+
+		timeout = msecs_to_jiffies(NL80211_DFS_MIN_NOP_TIME_MS);
+		queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk,
+				   timeout);
+		break;
+	case NL80211_CAC_FINISHED:
+		timeout = wdev->preset_chandef.chan->dfs_state_entered;
+		timeout = msecs_to_jiffies(timeout +
+					   NL80211_DFS_MIN_CAC_TIME_MS);
+		WARN_ON(!time_after_eq(jiffies, timeout));
+		cfg80211_set_dfs_state(wiphy, &wdev->preset_chandef,
+				       IEEE80211_DFS_AVAILABLE);
+		break;
+	case NL80211_CAC_ABORTED:
+		/* Shouldn't happen if CAC was never started before. */
+		WARN_ON(!wdev->cac_started);
+		break;
+	default:
+		break;
+	}
+
+	wdev->cac_started = false;
+
+	nl80211_radar_notify(rdev, &wdev->preset_chandef, event, netdev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_radar_event);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33de803..2e0216a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4869,6 +4869,54 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_start_radar_detection(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_chan_def chandef;
+	int err;
+
+	if (!(rdev->wiphy.features & NL80211_FEATURE_DFS))
+		return -EOPNOTSUPP;
+
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
+
+	if (wdev->cac_started)
+		return -EBUSY;
+
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
+	if (err < 1)
+		return err;
+
+	if (chandef.chan->dfs_state != IEEE80211_DFS_USABLE)
+		return -EINVAL;
+
+	if (!rdev->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   chandef.chan, CHAN_MODE_SHARED,
+					   BIT(chandef.width));
+	mutex_unlock(&rdev->devlist_mtx);
+
+	if (err)
+		return err;
+
+	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
+	if (!err) {
+		wdev->preset_chandef = chandef;
+		wdev->cac_started = true;
+		chandef.chan->dfs_state_entered = jiffies;
+	}
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -5575,6 +5623,10 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
 		return -EINVAL;
 
+	if (cfg80211_chandef_usable(&rdev->wiphy, &ibss.chandef,
+				    IEEE80211_CHAN_NO_IBSS))
+		return -EINVAL;
+
 	if (ibss.chandef.width > NL80211_CHAN_WIDTH_40)
 		return -EINVAL;
 	if (ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
@@ -7876,6 +7928,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_RADAR_DETECT,
+		.doit = nl80211_start_radar_detection,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -9073,6 +9133,52 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
 }
 
 void
+nl80211_radar_notify(struct cfg80211_registered_device *rdev,
+		     struct cfg80211_chan_def *chandef,
+		     enum nl80211_radar_event event,
+		     struct net_device *netdev, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct wireless_dev *wdev = netdev->ieee80211_ptr;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_RADAR_DETECT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+		goto nla_put_failure;
+
+	/* reason is unspecified, just notify that CAC has failed. */
+	if (nla_put_u8(msg, NL80211_ATTR_RADAR_EVENT, event))
+		goto nla_put_failure;
+
+	if (nl80211_send_chandef(msg, chandef))
+		goto nla_put_failure;
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 2acba84..b061da4 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -108,6 +108,13 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev,
 			     enum nl80211_cqm_rssi_threshold_event rssi_event,
 			     gfp_t gfp);
+
+void
+nl80211_radar_notify(struct cfg80211_registered_device *rdev,
+		     struct cfg80211_chan_def *chandef,
+		     enum nl80211_radar_event event,
+		     struct net_device *netdev, gfp_t gfp);
+
 void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index de02d63..2c441dc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -884,6 +884,9 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
+	chan->dfs_state = IEEE80211_DFS_USABLE;
+	chan->dfs_state_entered = jiffies;
+
 	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain =
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2134576..3eadb34 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2033,6 +2033,21 @@ TRACE_EVENT(cfg80211_reg_can_beacon,
 		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
+TRACE_EVENT(cfg80211_chandef_dfs_required,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
+	TP_ARGS(wiphy, chandef),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_DEF_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+	),
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT,
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
+);
+
 TRACE_EVENT(cfg80211_ch_switch_notify,
 	TP_PROTO(struct net_device *netdev,
 		 struct cfg80211_chan_def *chandef),
@@ -2049,6 +2064,24 @@ TRACE_EVENT(cfg80211_ch_switch_notify,
 		  NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
+TRACE_EVENT(cfg80211_radar_event,
+	TP_PROTO(struct net_device *netdev, struct cfg80211_chan_def *chandef,
+		 enum nl80211_radar_event evt),
+	TP_ARGS(netdev, chandef, evt),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+		__field(enum nl80211_radar_event, evt)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+		__entry->evt = evt;
+	),
+	TP_printk(NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT " event: %d",
+		  NETDEV_PR_ARG, CHAN_DEF_PR_ARG, __entry->evt)
+);
+
 DECLARE_EVENT_CLASS(cfg80211_rx_evt,
 	TP_PROTO(struct net_device *netdev, const u8 *addr),
 	TP_ARGS(netdev, addr),
-- 
1.7.10.4

