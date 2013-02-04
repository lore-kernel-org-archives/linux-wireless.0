Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50797 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3BDMuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 07:50:12 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv8 1/3] nl80211/cfg80211: add radar detection command/event
Date: Mon,  4 Feb 2013 13:49:56 +0100
Message-Id: <1359982200-2321-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130204_135031_932736_3C31BC4F)
In-Reply-To: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new NL80211_CMD_RADAR_DETECT, which starts the Channel Availability
Check (CAC). This command will also notify the usermode about events
(CAC finished, CAC aborted, radar detected, NOP finished).
Once radar detection has started it should continuously
monitor for radars as long as the channel is active.

based on original patch by Victor Goldenshtein <victorg@ti.com>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---

Changes to PATCHv7:
 * initialize ieee80211_dfs_state enum with numbers
 * fix documentation for dfs_state_entered
 * move NL80211_DFS_MIN_CAC_TIME_MS/NL80211_DFS_MIN_NOP_TIME_MS to
   cfg80211.h
 * remove NL80211_FEATURE_DFS
 * fix cfg80211_chandef_get_width return value
 * beautify cfg80211_dfs_channels_update_work
 * fix nl80211_start_radar_detection return code for dfs_required
 * fix rdev->devlist_mtx for cac_started
 * add cac_started_time and use it for CAC
 * remove wrong check in nl80211_join_ibss()
 * add warning for not defined event in cfg80211_radar_event()
 * unexport cfg80211_chandef_dfs_required()
 * use wdev->channel instead of wdev->preset_chandef.chan for CAC
 * report dfs state and how long it is active to userspace
 * add event when NOP has been finished

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
 include/net/cfg80211.h       |   46 +++++++++++++++
 include/uapi/linux/nl80211.h |   58 +++++++++++++++++++
 net/wireless/chan.c          |  129 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/core.c          |    3 +
 net/wireless/core.h          |   18 ++++++
 net/wireless/mlme.c          |  127 +++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  115 ++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h       |    7 +++
 net/wireless/reg.c           |    3 +
 net/wireless/scan.c          |   10 ----
 net/wireless/trace.h         |   33 +++++++++++
 11 files changed, 534 insertions(+), 15 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 36e076e..33f0638 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -113,6 +113,9 @@ enum ieee80211_channel_flags {
 #define IEEE80211_CHAN_NO_HT40 \
 	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
 
+#define IEEE80211_DFS_MIN_CAC_TIME_MS		60000
+#define IEEE80211_DFS_MIN_NOP_TIME_MS		(30 * 60 * 1000)
+
 /**
  * struct ieee80211_channel - channel definition
  *
@@ -133,6 +136,9 @@ enum ieee80211_channel_flags {
  *	to enable this, this is useful only on 5 GHz band.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
+ * @dfs_state: current state of this channel. Only relevant if radar is required
+ *	on this channel.
+ * @dfs_state_entered: timestamp (jiffies) when the dfs state was entered.
  */
 struct ieee80211_channel {
 	enum ieee80211_band band;
@@ -145,6 +151,8 @@ struct ieee80211_channel {
 	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	enum nl80211_dfs_state dfs_state;
+	unsigned long dfs_state_entered;
 };
 
 /**
@@ -412,6 +420,16 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
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
@@ -568,6 +586,7 @@ struct cfg80211_acl_data {
  * @p2p_opp_ps: P2P opportunistic PS
  * @acl: ACL configuration used by the drivers which has support for
  *	MAC address based access control
+ * @radar_required: set if radar detection is required
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -585,6 +604,7 @@ struct cfg80211_ap_settings {
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
+	bool radar_required;
 };
 
 /**
@@ -1826,6 +1846,8 @@ struct cfg80211_gtk_rekey_data {
  *	this new list replaces the existing one. Driver has to clear its ACL
  *	when number of MAC addresses entries is passed as 0. Drivers which
  *	advertise the support for MAC based ACL have to implement this callback.
+ *
+ * @start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2049,6 +2071,10 @@ struct cfg80211_ops {
 
 	int	(*set_mac_acl)(struct wiphy *wiphy, struct net_device *dev,
 			       const struct cfg80211_acl_data *params);
+
+	int	(*start_radar_detection)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct cfg80211_chan_def *chandef);
 };
 
 /*
@@ -2621,6 +2647,8 @@ struct cfg80211_cached_keys;
  *	beacons, 0 when not valid
  * @address: The address for this device, valid only if @netdev is %NULL
  * @p2p_started: true if this is a P2P Device that has been started
+ * @cac_started: true if DFS channel availability check has been started
+ * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2672,6 +2700,9 @@ struct wireless_dev {
 
 	u32 ap_unexpected_nlportid;
 
+	bool cac_started;
+	unsigned long cac_start_time;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -3663,6 +3694,21 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      gfp_t gfp);
 
 /**
+ * cfg80211_radar_event - radar detection event
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
index 5b7dbc1..4c8159b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -597,6 +597,14 @@
  *	command is used in AP/P2P GO mode. Driver has to make sure to clear its
  *	ACL list during %NL80211_CMD_STOP_AP.
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
@@ -749,6 +757,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MAC_ACL,
 
+	NL80211_CMD_RADAR_DETECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1336,6 +1346,9 @@ enum nl80211_commands {
  *	number of MAC addresses that a device can support for MAC
  *	ACL.
  *
+ * @NL80211_ATTR_RADAR_EVENT: Type of radar event for notification to userspace,
+ *	contains a value of enum nl80211_radar_event (u32).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1614,6 +1627,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAC_ACL_MAX,
 
+	NL80211_ATTR_RADAR_EVENT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2014,6 +2029,7 @@ enum nl80211_band_attr {
  *	(100 * dBm).
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
+ * @NL80211_FREQUENCY_ATTR_DFS_STATE: current state for DFS
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_frequency_attr {
@@ -2024,6 +2040,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+	NL80211_FREQUENCY_ATTR_DFS_STATE,
+	NL80211_FREQUENCY_ATTR_DFS_TIME,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -3323,4 +3341,44 @@ enum nl80211_acl_policy {
 	NL80211_ACL_POLICY_DENY_UNLESS_LISTED,
 };
 
+/**
+ * enum nl80211_radar_event - type of radar event for DFS operation
+ *
+ * Type of event to be used with NL80211_ATTR_RADAR_EVENT to inform userspace
+ * about detected radars or success of the channel available check (CAC)
+ *
+ * @NL80211_RADAR_DETECTED: A radar pattern has been detected. The channel is
+ *	now unusable.
+ * @NL80211_RADAR_CAC_FINISHED: Channel Availability Check has been finished,
+ *	the channel is now available.
+ * @NL80211_RADAR_CAC_ABORTED: Channel Availability Check has been aborted, no
+ *	change to the channel status.
+ * @NL80211_RADAR_NOP_FINISHED: The Non-Occupancy Period for this channel is
+ *	over, channel becomes usable.
+ */
+enum nl80211_radar_event {
+	NL80211_RADAR_DETECTED,
+	NL80211_RADAR_CAC_FINISHED,
+	NL80211_RADAR_CAC_ABORTED,
+	NL80211_RADAR_NOP_FINISHED,
+};
+
+/**
+ * enum nl80211_dfs_state - DFS states for channels
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
+enum nl80211_dfs_state {
+	NL80211_DFS_USABLE	= 0,
+	NL80211_DFS_UNAVAILABLE	= 1,
+	NL80211_DFS_AVAILABLE	= 2,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 396373f..b7bc951 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -147,6 +147,32 @@ static void chandef_primary_freqs(const struct cfg80211_chan_def *c,
 	}
 }
 
+static inline int cfg80211_chandef_get_width(const struct cfg80211_chan_def *c)
+{
+	int width;
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
@@ -192,6 +218,93 @@ cfg80211_chandef_compatible(const struct cfg80211_chan_def *c1,
 }
 EXPORT_SYMBOL(cfg80211_chandef_compatible);
 
+static void cfg80211_set_chans_dfs_state(struct wiphy *wiphy, u32 center_freq,
+					 u32 bandwidth,
+					 enum nl80211_dfs_state dfs_state)
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
+			    enum nl80211_dfs_state dfs_state)
+{
+	int width;
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
+	int width;
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
+
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
 					u32 prohibited_flags)
@@ -203,7 +316,16 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 	     freq <= center_freq + bandwidth/2 - 10;
 	     freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
-		if (!c || c->flags & prohibited_flags)
+		if (!c)
+			return false;
+
+		/* check for radar flags */
+		if ((prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) &&
+		    (c->dfs_state != NL80211_DFS_AVAILABLE))
+			return false;
+
+		/* check for the other flags */
+		if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
 			return false;
 	}
 
@@ -344,7 +466,10 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		if (wdev->beacon_interval) {
+		if (wdev->cac_started) {
+			*chan = wdev->channel;
+			*chanmode = CHAN_MODE_SHARED;
+		} else if (wdev->beacon_interval) {
 			*chan = wdev->channel;
 			*chanmode = CHAN_MODE_SHARED;
 		}
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 40dbe37..d1d850f7 100644
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
@@ -695,6 +697,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->scan_done_wk);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
+	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 
 	if (rdev->wowlan && rdev->ops->set_wakeup)
 		rdev_set_wakeup(rdev, false);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 8396f76..cac722b 100644
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
+			    enum nl80211_dfs_state dfs_state);
+
+void cfg80211_dfs_channels_update_work(struct work_struct *work);
+
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
@@ -454,6 +462,16 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
 					    chan, chanmode, 0);
 }
 
+static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
+{
+	unsigned long end = jiffies;
+
+	if (end >= start)
+		return jiffies_to_msecs(end - start);
+
+	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
+}
+
 void
 cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        struct ieee80211_channel **chan,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 461e692..a21c108 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -987,3 +987,130 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
+
+static void cfg80211_notify_nop_ended(struct cfg80211_registered_device *rdev,
+					struct ieee80211_channel *c)
+{
+	struct wireless_dev *wdev;
+	struct cfg80211_chan_def chandef;
+
+	cfg80211_chandef_create(&chandef, c, NL80211_CHAN_NO_HT);
+
+	mutex_lock(&rdev->devlist_mtx);
+	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
+		if (!netif_running(wdev->netdev))
+			continue;
+
+		nl80211_radar_notify(rdev, &chandef,
+				     NL80211_RADAR_NOP_FINISHED,
+				     wdev->netdev, GFP_ATOMIC);
+	}
+	mutex_unlock(&rdev->devlist_mtx);
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
+	unsigned long timeout, next_time = 0;
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
+			if (c->dfs_state != NL80211_DFS_UNAVAILABLE)
+				continue;
+
+			timeout = c->dfs_state_entered +
+				  IEEE80211_DFS_MIN_NOP_TIME_MS;
+
+			if (time_after_eq(jiffies, timeout)) {
+				c->dfs_state = NL80211_DFS_USABLE;
+				cfg80211_notify_nop_ended(rdev, c);
+				continue;
+			}
+
+			if (!check_again)
+				next_time = timeout - jiffies;
+			else
+				next_time = min(next_time, timeout - jiffies);
+			check_again = true;
+		}
+	}
+	mutex_unlock(&cfg80211_mutex);
+
+	/* reschedule if there are other channels waiting to be cleared again */
+	if (check_again)
+		queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk,
+				   next_time);
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
+				       NL80211_DFS_UNAVAILABLE);
+
+		timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_NOP_TIME_MS);
+		queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk,
+				   timeout);
+		break;
+	case NL80211_RADAR_CAC_FINISHED:
+		timeout = msecs_to_jiffies(wdev->cac_start_time +
+					   IEEE80211_DFS_MIN_CAC_TIME_MS);
+		WARN_ON(!time_after_eq(jiffies, timeout));
+		cfg80211_set_dfs_state(wiphy, chandef,
+				       NL80211_DFS_AVAILABLE);
+		break;
+	case NL80211_RADAR_CAC_ABORTED:
+		/* Shouldn't happen if CAC was never started before. */
+		WARN_ON(!wdev->cac_started);
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	wdev->cac_started = false;
+
+	nl80211_radar_notify(rdev, chandef, event, netdev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_radar_event);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5978ab..00e6599 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -531,9 +531,16 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IBSS))
 		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_RADAR) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
-		goto nla_put_failure;
+	if ((chan->flags & IEEE80211_CHAN_RADAR)) {
+		u32 time = elapsed_jiffies_msecs(chan->dfs_state_entered);
+		if (nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
+			goto nla_put_failure;
+		if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_STATE,
+				chan->dfs_state))
+			goto nla_put_failure;
+		if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_TIME, time))
+			goto nla_put_failure;
+	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 			DBM_TO_MBM(chan->max_power)))
@@ -4977,6 +4984,54 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
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
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
+
+	if (wdev->cac_started)
+		return -EBUSY;
+
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
+	if (err < 0)
+		return err;
+
+	if (err == 0)
+		return -EINVAL;
+
+	if (chandef.chan->dfs_state != NL80211_DFS_USABLE)
+		return -EINVAL;
+
+	if (!rdev->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   chandef.chan, CHAN_MODE_SHARED,
+					   BIT(chandef.width));
+	if (err)
+		goto err_locked;
+
+	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
+	if (!err) {
+		wdev->channel = chandef.chan;
+		wdev->cac_started = true;
+		wdev->cac_start_time = jiffies;
+	}
+err_locked:
+	mutex_unlock(&rdev->devlist_mtx);
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7992,6 +8047,14 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -9189,6 +9252,52 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
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
+	if (nla_put_u32(msg, NL80211_ATTR_RADAR_EVENT, event))
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
index de02d63..7abf6b9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -884,6 +884,9 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
+	chan->dfs_state = NL80211_DFS_USABLE;
+	chan->dfs_state_entered = jiffies;
+
 	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain =
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 45f1618..85ce680 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1155,16 +1155,6 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
 	}
 }
 
-static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
-{
-	unsigned long end = jiffies;
-
-	if (end >= start)
-		return jiffies_to_msecs(end - start);
-
-	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
-}
-
 static char *
 ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 	      struct cfg80211_internal_bss *bss, char *current_ev,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8bc5531..a106ea8 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2051,6 +2051,21 @@ TRACE_EVENT(cfg80211_reg_can_beacon,
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
@@ -2067,6 +2082,24 @@ TRACE_EVENT(cfg80211_ch_switch_notify,
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

