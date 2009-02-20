Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZBTGEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 01:04:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, kalle.valo@nokia.com, kyle@mcmartin.ca
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/5] cfg80211: Add AP beacon regulatory hints
Date: Fri, 20 Feb 2009 01:04:32 -0500
Message-Id: <1235109874-3966-4-git-send-email-lrodriguez@atheros.com> (sfid-20090220_070501_871345_3FA64C5A)
In-Reply-To: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
References: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When devices are world roaming they cannot beacon or do active scan
on 5 GHz or on channels 12, 13 and 14 on the 2 GHz band. Although
we have a good regulatory API some cards may _always_ world roam, this
is also true when a system does not have CRDA present. Devices doing world
roaming can still passive scan, if they find a beacon from an AP on
one of the world roaming frequencies we make the assumption we can do
the same and we also remove the passive scan requirement.

This adds support for providing beacon regulatory hints based on scans.
This works for devices that do either hardware or software scanning.
If a channel has not yet been marked as having had a beacon present
on it we queue the beacon hint processing into the workqueue.

All wireless devices will benefit from beacon regulatory hints from
any wireless device on a system including new devices connected to
the system at a later time.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |   21 +++++
 net/wireless/core.c    |    5 +-
 net/wireless/reg.c     |  226 +++++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/scan.c    |    3 +
 4 files changed, 252 insertions(+), 3 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index 1f4707d..13f7aef 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -69,6 +69,9 @@ enum ieee80211_channel_flags {
  * @band: band this channel belongs to.
  * @max_antenna_gain: maximum antenna gain in dBi
  * @max_power: maximum transmission power (in dBm)
+ * @beacon_found: helper to regulatory code to indicate when a beacon
+ *	has been found on this channel. Use regulatory_hint_found_beacon()
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
@@ -425,6 +429,23 @@ extern int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
 extern void regulatory_hint_11d(struct wiphy *wiphy,
 				u8 *country_ie,
 				u8 country_ie_len);
+/**
+ * regulatory_hint_found_beacon - hints a beacon was found on a channel
+ * @wiphy: the wireless device where the beacon was found on
+ * @beacon_chan: the channel on which the beacon was found on
+ * @gfp: context flags
+ *
+ * This informs the wireless core that a beacon from an AP was found on
+ * the channel provided. This allows the wireless core to make educated
+ * guesses on regulatory to help with world roaming. This is only used for
+ * world roaming -- when we do not know our current location. This is
+ * only useful on channels 12, 13 and 14 on the 2 GHz band as all other
+ * channels are already enabled by the world regulatory domain (channels
+ * 1-11); and on non-radar 5 GHz channels.
+ */
+extern int regulatory_hint_found_beacon(struct wiphy *wiphy,
+					struct ieee80211_channel *beacon_chan,
+					gfp_t gfp);
 
 /**
  * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
diff --git a/net/wireless/core.c b/net/wireless/core.c
index b1a354b..dd7f222 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -32,8 +32,9 @@ MODULE_DESCRIPTION("wireless configuration support");
 LIST_HEAD(cfg80211_drv_list);
 
 /*
- * This is used to protect the cfg80211_drv_list, cfg80211_regdomain, and
- * the last reguluatory request receipt in regd.c
+ * This is used to protect the cfg80211_drv_list, cfg80211_regdomain,
+ * country_ie_regdomain, the reg_beacon_list and the the last regulatory
+ * request receipt (last_request).
  */
 DEFINE_MUTEX(cfg80211_mutex);
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8e86505..67a193a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -68,9 +68,22 @@ const struct ieee80211_regdomain *cfg80211_regdomain;
  */
 static const struct ieee80211_regdomain *country_ie_regdomain;
 
+/* Used to queue up regulatory hints */
 static LIST_HEAD(reg_requests_list);
 static spinlock_t reg_requests_lock;
 
+/* Used to queue up beacon hints for review */
+static LIST_HEAD(reg_pending_beacons);
+static spinlock_t reg_pending_beacons_lock;
+
+/* Used to keep track of processed beacon hints */
+static LIST_HEAD(reg_beacon_list);
+
+struct reg_beacon {
+	struct list_head list;
+	struct ieee80211_channel chan;
+};
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 3,
@@ -1011,16 +1024,120 @@ static void update_all_wiphy_regulatory(enum reg_set_by setby)
 		wiphy_update_regulatory(&drv->wiphy, setby);
 }
 
+static void handle_reg_beacon(struct wiphy *wiphy,
+			      unsigned int chan_idx,
+			      struct reg_beacon *reg_beacon)
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
+	assert_cfg80211_lock();
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
+				    struct reg_beacon *reg_beacon)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	assert_cfg80211_lock();
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
+	assert_cfg80211_lock();
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
+out:
+	reg_process_beacons(wiphy);
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, last_request);
 }
@@ -1314,6 +1431,7 @@ out:
 	return r;
 }
 
+/* Processes regulatory hints, this is all the REGDOM_SET_BY_* */
 static void reg_process_pending_hints(void)
 	{
 	struct regulatory_request *reg_request;
@@ -1344,9 +1462,44 @@ static void reg_process_pending_hints(void)
 	spin_unlock(&reg_requests_lock);
 }
 
+/* Processes beacon hints -- this has nothing to do with country IEs */
+static void reg_process_pending_beacon_hints(void)
+{
+	struct cfg80211_registered_device *drv;
+	struct reg_beacon *pending_beacon, *tmp;
+
+	mutex_lock(&cfg80211_mutex);
+
+	/* This goes through the _pending_ beacon list */
+	spin_lock_bh(&reg_pending_beacons_lock);
+
+	if (list_empty(&reg_pending_beacons)) {
+		spin_unlock_bh(&reg_pending_beacons_lock);
+		goto out;
+	}
+
+	list_for_each_entry_safe(pending_beacon, tmp,
+				 &reg_pending_beacons, list) {
+
+		list_del_init(&pending_beacon->list);
+
+		/* Applies the beacon hint to current wiphys */
+		list_for_each_entry(drv, &cfg80211_drv_list, list)
+			wiphy_update_new_beacon(&drv->wiphy, pending_beacon);
+
+		/* Remembers the beacon hint for new wiphys or reg changes */
+		list_add_tail(&pending_beacon->list, &reg_beacon_list);
+	}
+
+	spin_unlock_bh(&reg_pending_beacons_lock);
+out:
+	mutex_unlock(&cfg80211_mutex);
+}
+
 static void reg_todo(struct work_struct *work)
 {
 	reg_process_pending_hints();
+	reg_process_pending_beacon_hints();
 }
 
 static DECLARE_WORK(reg_work, reg_todo);
@@ -1587,6 +1740,57 @@ out:
 }
 EXPORT_SYMBOL(regulatory_hint_11d);
 
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
+				 struct ieee80211_channel *beacon_chan,
+				 gfp_t gfp)
+{
+	struct reg_beacon *reg_beacon;
+
+	if (likely((beacon_chan->beacon_found ||
+	    (beacon_chan->flags & IEEE80211_CHAN_RADAR) ||
+	    (beacon_chan->band == IEEE80211_BAND_2GHZ &&
+	     !freq_is_chan_12_13_14(beacon_chan->center_freq)))))
+		return 0;
+
+	reg_beacon = kzalloc(sizeof(struct reg_beacon), gfp);
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
+
+	/*
+	 * Since we can be called from BH or and non-BH context
+	 * we must use spin_lock_bh()
+	 */
+	spin_lock_bh(&reg_pending_beacons_lock);
+	list_add_tail(&reg_beacon->list, &reg_pending_beacons);
+	spin_unlock_bh(&reg_pending_beacons_lock);
+
+	schedule_work(&reg_work);
+
+	return 0;
+}
+EXPORT_SYMBOL(regulatory_hint_found_beacon);
+
+
 static void print_rd_rules(const struct ieee80211_regdomain *rd)
 {
 	unsigned int i;
@@ -1908,6 +2112,7 @@ int regulatory_init(void)
 		return PTR_ERR(reg_pdev);
 
 	spin_lock_init(&reg_requests_lock);
+	spin_lock_init(&reg_pending_beacons_lock);
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	cfg80211_regdomain = static_regdom(ieee80211_regdom);
@@ -1951,6 +2156,7 @@ int regulatory_init(void)
 void regulatory_exit(void)
 {
 	struct regulatory_request *reg_request, *tmp;
+	struct reg_beacon *reg_beacon, *btmp;
 
 	cancel_work_sync(&reg_work);
 
@@ -1965,6 +2171,24 @@ void regulatory_exit(void)
 
 	platform_device_unregister(reg_pdev);
 
+	spin_lock_bh(&reg_pending_beacons_lock);
+	if (!list_empty(&reg_pending_beacons)) {
+		list_for_each_entry_safe(reg_beacon, btmp,
+					 &reg_pending_beacons, list) {
+			list_del(&reg_beacon->list);
+			kfree(reg_beacon);
+		}
+	}
+	spin_unlock_bh(&reg_pending_beacons_lock);
+
+	if (!list_empty(&reg_beacon_list)) {
+		list_for_each_entry_safe(reg_beacon, btmp,
+					 &reg_beacon_list, list) {
+			list_del(&reg_beacon->list);
+			kfree(reg_beacon);
+		}
+	}
+
 	spin_lock(&reg_requests_lock);
 	if (!list_empty(&reg_requests_list)) {
 		list_for_each_entry_safe(reg_request, tmp,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6060065..280dbcd 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -430,6 +430,9 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	if (!res)
 		return NULL;
 
+	if (res->pub.capability & WLAN_CAPABILITY_ESS)
+		regulatory_hint_found_beacon(wiphy, channel, gfp);
+
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
-- 
1.6.0.3

