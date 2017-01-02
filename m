Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35490 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932325AbdABN2g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 08:28:36 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 3/3] cfg80211: support ieee80211-freq-limit DT property
Date: Mon,  2 Jan 2017 14:27:47 +0100
Message-Id: <20170102132747.3491-3-zajec5@gmail.com> (sfid-20170102_142840_023402_85AA083A)
In-Reply-To: <20170102132747.3491-1-zajec5@gmail.com>
References: <20170102132747.3491-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It allows specifying hardware limitations of supported channels. This
may be useful for specifying single band devices or devices that support
only some part of the whole band.
This can be useful for some tri-band routers that have separated radios
for lower and higher part of 5 GHz band.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Put main code in core.c as it isn't strictly part of regulatory - pointed
    by Arend.
    Update to support ieee80211-freq-limit (new property).
---
 include/net/cfg80211.h |   6 +++
 net/wireless/core.c    | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h    |   2 +
 net/wireless/reg.c     |   8 +++-
 net/wireless/reg.h     |   2 +
 5 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e952cca..6609c39 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3515,6 +3515,9 @@ struct wiphy_iftype_ext_capab {
  *	attribute indices defined in &enum nl80211_bss_select_attr.
  *
  * @cookie_counter: unique generic cookie counter, used to identify objects.
+ *
+ * @n_freq_limits: number of frequency limits
+ * @freq_limits: array of extra frequency limits
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3646,6 +3649,9 @@ struct wiphy {
 
 	u64 cookie_counter;
 
+	unsigned int n_freq_limits;
+	struct ieee80211_freq_range *freq_limits;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 398922a..c2a5c81 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -87,6 +87,113 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 	return &rdev->wiphy;
 }
 
+static int wiphy_freq_limits_init(struct wiphy *wiphy)
+{
+	struct device *dev = wiphy_dev(wiphy);
+	struct device_node *np;
+	struct property *prop;
+	const __be32 *p;
+	int i;
+	int err = 0;
+
+	if (wiphy->n_freq_limits)
+		return 0;
+
+	if (!dev)
+		return 0;
+	np = dev->of_node;
+	if (!np)
+		return 0;
+
+	prop = of_find_property(np, "ieee80211-freq-limit", &i);
+	if (!prop)
+		return 0;
+
+	i = i / sizeof(u32);
+	if (i % 2) {
+		dev_err(dev, "ieee80211-freq-limit wrong value");
+		return -EPROTO;
+	}
+	wiphy->n_freq_limits = i / 2;
+
+	wiphy->freq_limits = kzalloc(wiphy->n_freq_limits * sizeof(*wiphy->freq_limits),
+				     GFP_KERNEL);
+	if (!wiphy->freq_limits) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	p = NULL;
+	for (i = 0; i < wiphy->n_freq_limits; i++) {
+		struct ieee80211_freq_range *limit = &wiphy->freq_limits[i];
+
+		p = of_prop_next_u32(prop, p, &limit->start_freq_khz);
+		if (!p) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		p = of_prop_next_u32(prop, p, &limit->end_freq_khz);
+		if (!p) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	if (err) {
+		dev_err(dev, "Failed to get limits: %d\n", err);
+		kfree(wiphy->freq_limits);
+		wiphy->n_freq_limits = 0;
+	}
+	return err;
+}
+
+static bool wiphy_freq_limits_valid_chan(struct wiphy *wiphy,
+					 struct ieee80211_channel *chan)
+{
+	u32 bw = MHZ_TO_KHZ(20);
+	int i;
+
+	for (i = 0; i < wiphy->n_freq_limits; i++) {
+		struct ieee80211_freq_range *limit = &wiphy->freq_limits[i];
+
+		if (reg_does_bw_fit(limit, MHZ_TO_KHZ(chan->center_freq), bw))
+			return true;
+	}
+
+	return false;
+}
+
+void wiphy_freq_limits_apply(struct wiphy *wiphy)
+{
+	enum nl80211_band band;
+	int i;
+
+	if (!wiphy->n_freq_limits)
+		return;
+
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		struct ieee80211_supported_band *sband = wiphy->bands[band];
+
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_channels; i++) {
+			struct ieee80211_channel *chan = &sband->channels[i];
+
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			if (!wiphy_freq_limits_valid_chan(wiphy, chan)) {
+				pr_debug("Disabling freq %d MHz as it's out of OF limits\n",
+					 chan->center_freq);
+				chan->flags |= IEEE80211_CHAN_DISABLED;
+			}
+		}
+	}
+}
+
 static int cfg80211_dev_check_name(struct cfg80211_registered_device *rdev,
 				   const char *newname)
 {
@@ -481,6 +588,8 @@ struct wiphy *wiphy_new_nm(struct device *dev, const struct cfg80211_ops *ops,
 
 	init_waitqueue_head(&rdev->dev_wait);
 
+	wiphy_freq_limits_init(&rdev->wiphy);
+
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
 	 * Fragmentation and RTS threshold are disabled by default with the
@@ -942,6 +1051,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 
 void wiphy_free(struct wiphy *wiphy)
 {
+	kfree(wiphy->freq_limits);
 	put_device(&wiphy->dev);
 }
 EXPORT_SYMBOL(wiphy_free);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index af6e023..ce94f82 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -271,6 +271,8 @@ struct cfg80211_iface_destroy {
 	u32 nlportid;
 };
 
+void wiphy_freq_limits_apply(struct wiphy *wiphy);
+
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev);
 
 /* free object */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5dbac37..cb5a264 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -748,8 +748,8 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 	return true;
 }
 
-static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
-			    u32 center_freq_khz, u32 bw_khz)
+bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
+		     u32 center_freq_khz, u32 bw_khz)
 {
 	u32 start_freq_khz, end_freq_khz;
 
@@ -1693,6 +1693,8 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	for (band = 0; band < NUM_NL80211_BANDS; band++)
 		handle_band(wiphy, initiator, wiphy->bands[band]);
 
+	wiphy_freq_limits_apply(wiphy);
+
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
 	reg_call_notifier(wiphy, lr);
@@ -1800,6 +1802,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 		bands_set++;
 	}
 
+	wiphy_freq_limits_apply(wiphy);
+
 	/*
 	 * no point in calling this if it won't have any effect
 	 * on your device's supported bands.
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index f6ced31..90eddc3 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -25,6 +25,8 @@ extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
 bool reg_is_valid_request(const char *alpha2);
 bool is_world_regdom(const char *alpha2);
+bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
+		     u32 center_freq_khz, u32 bw_khz);
 bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region);
 enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy);
 
-- 
2.10.1
