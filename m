Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53748 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZBCFCg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 00:02:36 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 21:02:36 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC 1/2] cfg80211/mac80211: add regulatory_hint_found_beacon() to make help world roaming
Date: Mon, 2 Feb 2009 21:01:52 -0800
Message-ID: <1233637313-16786-2-git-send-email-lrodriguez@atheros.com> (sfid-20090203_060240_876346_9CA7AB82)
In-Reply-To: <1233637313-16786-1-git-send-email-lrodriguez@atheros.com>
References: <1233637313-16786-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some initial intelligence to help world roaming. When we
are world roaming we have no idea what country we are in yet and
because of this our regulatory domain will be pretty restrictive.
Country information elements help and we have code to handle that already,
however, not many APs enable country IEs. We can help the situation
by adding checks on ours scans for beacons from APs, if we are world roaming
and an AP beacon is found on a channel we will make the bet that we can
also beacon and do active scanning -- when not on radar channels.

Since this goes in as part of cfg80211 all devices present will benefit
from any device's found beacons, this includes new devices connected or
when you disconnect and reconnect the same device.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |   20 +++++
 net/mac80211/mlme.c    |   35 +++++++++
 net/wireless/reg.c     |  181 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 235 insertions(+), 1 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index a42c156..74b0352 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -69,6 +69,9 @@ enum ieee80211_channel_flags {
  * @band: band this channel belongs to.
  * @max_antenna_gain: maximum antenna gain in dBi
  * @max_power: maximum transmission power (in dBm)
+ * @beacon_found: helper to regulatory code to indicate when a beacon
+ * 	has been found on this channel. Use regulatory_hint_found_beacon()
+ *	to enable this, this is is useful only on 5 GHz band.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
  */
@@ -80,6 +83,7 @@ struct ieee80211_channel {
 	u32 flags;
 	int max_antenna_gain;
 	int max_power;
+	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
 };
@@ -414,6 +418,22 @@ extern void regulatory_hint_11d(struct wiphy *wiphy,
 				u8 country_ie_len);
 
 /**
+ * regulatory_hint_found_beacon - hints a beacon was found on a channel
+ * @wiphy: the wireless device where the beacon was found on
+ * @beacon_chan: the channel on which the beacon was found on
+ *
+ * This informs the wireless core that a beacon from an AP was found on
+ * the channel provided. This allows the wireless core to make educated
+ * guesses on regulatory to help with world roaming. This is only used for
+ * world roaming -- when we do not know our current location. This is
+ * only useful on channels 12, 13 and 14 on the 2 GHz band as all other
+ * channels are already enabled by the world regulatory domain; and on
+ * non-radar 5 GHz channels.
+ */
+extern int regulatory_hint_found_beacon(struct wiphy *wiphy,
+					struct ieee80211_channel *beacon_chan);
+
+/**
  * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
  * @wiphy: the wireless device we want to process the regulatory domain on
  * @regd: the custom regulatory domain to use for this wiphy
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9d51e27..45905dc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2717,6 +2717,7 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_bss *bss;
 
 	if (sdata && sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		ifsta = &sdata->u.sta;
@@ -2731,6 +2732,40 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
 		ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
+
+	/* Send off hints to the wireless core about beacons found */
+	spin_lock_bh(&local->bss_lock);
+
+	sdata = local->scan_sdata;
+
+	list_for_each_entry(bss, &local->bss_list, list) {
+		struct wiphy *wiphy;
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_channel *chan;
+		unsigned int i;
+
+		if (!(bss->capability & WLAN_CAPABILITY_ESS))
+			continue;
+
+		wiphy = sdata->local->hw.wiphy;
+
+		if (WARN_ON(!wiphy->bands[bss->band]))
+			continue;
+
+		sband = wiphy->bands[bss->band];
+
+		for (i = 0; i < sband->n_channels; i++) {
+			chan = &sband->channels[i];
+
+			if (chan->center_freq != bss->freq)
+				continue;
+			if (regulatory_hint_found_beacon(wiphy, chan))
+				goto unlock_and_exit;
+		}
+	}
+
+unlock_and_exit:
+	spin_unlock_bh(&local->bss_lock);
 }
 
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2323644..656cad7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -54,6 +54,18 @@ static u32 supported_bandwidths[] = {
 	MHZ_TO_KHZ(20),
 };
 
+/*
+ * This list is used to help regulatory when devices are still
+ * world roaming.
+ */
+static LIST_HEAD(reg_beacon_list);
+
+/* Used to help world roaming, used on found beacons */
+struct reg_beacon {
+	struct list_head list;
+	struct ieee80211_channel chan;
+};
+
 /* Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
  * information to give us an alpha2 */
@@ -758,6 +770,141 @@ static u32 map_regdom_flags(u32 rd_flags)
 	return channel_flags;
 }
 
+static void handle_reg_beacon(struct wiphy *wiphy,
+			       unsigned int chan_idx,
+			       struct reg_beacon *reg_beacon)
+{
+#ifdef CONFIG_CFG80211_REG_DEBUG
+#define REG_DEBUG_BEACON_FLAG(desc) \
+	printk(KERN_DEBUG "cfg80211: Enabling " desc " on " \
+		"frequency: %d MHz (Ch %d) on %s\n", \
+		reg_beacon->chan.center_freq, \
+		ieee80211_frequency_to_channel(reg_beacon->chan.center_freq), \
+		wiphy_name(wiphy));
+#else
+#define REG_DEBUG_BEACON_FLAG(desc) do {} while (0)
+#endif
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+
+	sband = wiphy->bands[reg_beacon->chan.band];
+	chan = &sband->channels[chan_idx];
+
+	if (likely(chan->center_freq != reg_beacon->chan.center_freq))
+		return;
+
+	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) {
+		chan->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		REG_DEBUG_BEACON_FLAG("active scanning");
+	}
+
+	if (chan->flags & IEEE80211_CHAN_NO_IBSS) {
+		chan->flags &= ~IEEE80211_CHAN_NO_IBSS;
+		REG_DEBUG_BEACON_FLAG("beaconing");
+	}
+
+	chan->beacon_found = true;
+#undef REG_DEBUG_BEACON_FLAG
+}
+
+/*
+ * Called when a scan on a wiphy finds a beacon on
+ * new channel
+ */
+static void wiphy_update_new_beacon(struct wiphy *wiphy,
+				     struct reg_beacon *reg_beacon)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	if (!wiphy->bands[reg_beacon->chan.band])
+		return;
+
+	sband = wiphy->bands[reg_beacon->chan.band];
+
+	for (i = 0; i < sband->n_channels; i++)
+		handle_reg_beacon(wiphy, i, reg_beacon);
+}
+
+/*
+ * Called upon reg changes or a new wiphy is added
+ */
+static void wiphy_update_beacon_reg(struct wiphy *wiphy)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+	struct reg_beacon *reg_beacon;
+
+	if (list_empty(&reg_beacon_list))
+		return;
+
+	list_for_each_entry(reg_beacon, &reg_beacon_list, list) {
+		if (!wiphy->bands[reg_beacon->chan.band])
+			continue;
+		sband = wiphy->bands[reg_beacon->chan.band];
+		for (i = 0; i < sband->n_channels; i++)
+			handle_reg_beacon(wiphy, i, reg_beacon);
+	}
+}
+
+static bool freq_is_chan_12_13_14(u16 freq)
+{
+	if (freq == ieee80211_channel_to_frequency(12) ||
+	    freq == ieee80211_channel_to_frequency(13) ||
+	    freq == ieee80211_channel_to_frequency(14))
+		return true;
+	return false;
+}
+
+int regulatory_hint_found_beacon(struct wiphy *wiphy,
+				 struct ieee80211_channel *beacon_chan)
+{
+	struct cfg80211_registered_device *drv;
+	struct reg_beacon *reg_beacon, *beacon;
+
+	if (beacon_chan->beacon_found ||
+	    (beacon_chan->flags & IEEE80211_CHAN_RADAR) ||
+	    (beacon_chan->band == IEEE80211_BAND_2GHZ &&
+	     !freq_is_chan_12_13_14(beacon_chan->center_freq)))
+		return 0;
+
+	reg_beacon = kzalloc(sizeof(struct reg_beacon), GFP_KERNEL);
+	if (!reg_beacon)
+		return -ENOMEM;
+
+#ifdef CONFIG_CFG80211_REG_DEBUG
+	printk(KERN_DEBUG "cfg80211: Found new beacon on "
+		"frequency: %d MHz (Ch %d) on %s\n",
+		beacon_chan->center_freq,
+		ieee80211_frequency_to_channel(beacon_chan->center_freq),
+		wiphy_name(wiphy));
+#endif
+	memcpy(&reg_beacon->chan, beacon_chan,
+		sizeof(struct ieee80211_channel));
+
+	mutex_lock(&cfg80211_drv_mutex);
+
+	list_for_each_entry(drv, &cfg80211_drv_list, list)
+		wiphy_update_new_beacon(&drv->wiphy, reg_beacon);
+
+	/*
+	 * If this happens it means our beacon_found flag isn't
+	 * working as intended.
+	 */
+	list_for_each_entry(beacon, &reg_beacon_list, list) {
+		if (WARN_ON(beacon->chan.center_freq ==
+		    reg_beacon->chan.center_freq))
+			goto unlock;
+	}
+
+	list_add_tail(&reg_beacon->list, &reg_beacon_list);
+
+unlock:
+	mutex_unlock(&cfg80211_drv_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(regulatory_hint_found_beacon);
+
 static int freq_reg_info_regd(struct wiphy *wiphy,
 			      u32 center_freq,
 			      u32 *bandwidth,
@@ -938,16 +1085,38 @@ static void update_all_wiphy_regulatory(enum reg_set_by setby)
 		wiphy_update_regulatory(&drv->wiphy, setby);
 }
 
+static bool reg_is_world_roaming(struct wiphy *wiphy)
+{
+	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
+	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
+		return true;
+	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
+	    wiphy->custom_regulatory)
+		return true;
+	return false;
+}
+
+/* Reap the advantages of previously found beacons */
+static void reg_process_beacons(struct wiphy *wiphy)
+{
+	if (!reg_is_world_roaming(wiphy))
+		return;
+	wiphy_update_beacon_reg(wiphy);
+}
+
 void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 {
 	enum ieee80211_band band;
 
 	if (ignore_reg_update(wiphy, setby))
-		return;
+		goto out;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band);
 	}
+
+out:
+	reg_process_beacons(wiphy);
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, last_request);
 }
@@ -1633,6 +1802,8 @@ int regulatory_init(void)
 
 void regulatory_exit(void)
 {
+	struct reg_beacon *reg_beacon, *reg_tmp;
+
 	mutex_lock(&cfg80211_drv_mutex);
 
 	reset_regdomains();
@@ -1644,5 +1815,13 @@ void regulatory_exit(void)
 
 	platform_device_unregister(reg_pdev);
 
+	if (!list_empty(&reg_beacon_list)) {
+		list_for_each_entry_safe(reg_beacon, reg_tmp,
+		  &reg_beacon_list, list) {
+			list_del(&reg_beacon->list);
+			kfree(reg_beacon);
+		}
+	}
+
 	mutex_unlock(&cfg80211_drv_mutex);
 }
-- 
1.6.1.2.253.ga34a

