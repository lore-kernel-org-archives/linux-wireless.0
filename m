Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35330 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933373AbdABQc2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 11:32:28 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 2/2] cfg80211: support ieee80211-freq-limit DT property
Date: Mon,  2 Jan 2017 17:32:08 +0100
Message-Id: <20170102163209.2445-2-zajec5@gmail.com> (sfid-20170102_173243_583405_1F996B17)
In-Reply-To: <20170102163209.2445-1-zajec5@gmail.com>
References: <20170102163209.2445-1-zajec5@gmail.com>
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
V3: Introduce separated wiphy_read_of_freq_limits function.
    Add extra sanity checks for DT data.
    Move code back to reg.c as suggested by Johannes.
---
 include/net/cfg80211.h |  23 ++++++++++
 net/wireless/core.c    |   1 +
 net/wireless/reg.c     | 118 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ca2ac1c..5002625 100644
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
 
@@ -4278,6 +4284,23 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
  */
 
 /**
+ * wiphy_read_of_freq_limits - read frequency limits from device tree
+ *
+ * @wiphy: the wireless device to get extra limits for
+ *
+ * Some devices may have extra limitations specified in DT. This may be useful
+ * for chipsets that normally support more bands but are limited due to board
+ * design (e.g. by antennas or extermal power amplifier).
+ *
+ * This function reads info from DT and uses it to *modify* channels (disable
+ * unavailable ones) in a regulary code. It's usually a *bad* idea to use it in
+ * drivers with *shared* channel data as DT limitations are device specific.
+ *
+ * As this function access device node it has to be called after set_wiphy_dev.
+ */
+int wiphy_read_of_freq_limits(struct wiphy *wiphy);
+
+/**
  * regulatory_hint - driver hint to the wireless core a regulatory domain
  * @wiphy: the wireless device giving the hint (used only for reporting
  *	conflicts)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 158c59e..c1b5fc7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -940,6 +940,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 
 void wiphy_free(struct wiphy *wiphy)
 {
+	kfree(wiphy->freq_limits);
 	put_device(&wiphy->dev);
 }
 EXPORT_SYMBOL(wiphy_free);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5dbac37..e00fd5b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1158,6 +1158,120 @@ static uint32_t reg_rule_to_chan_bw_flags(const struct ieee80211_regdomain *regd
 	return bw_flags;
 }
 
+int wiphy_read_of_freq_limits(struct wiphy *wiphy)
+{
+	struct device *dev = wiphy_dev(wiphy);
+	struct device_node *np;
+	struct property *prop;
+	const __be32 *p;
+	int len, i, err;
+
+	if (wiphy->n_freq_limits)
+		return 0;
+
+	if (!dev)
+		return 0;
+	np = dev_of_node(dev);
+	if (!np)
+		return 0;
+
+	prop = of_find_property(np, "ieee80211-freq-limit", &len);
+	if (!prop)
+		return 0;
+
+	if (!len || len % sizeof(u32) || len / sizeof(u32) % 2) {
+		dev_err(dev, "ieee80211-freq-limit wrong format");
+		return -EPROTO;
+	}
+	wiphy->n_freq_limits = len / sizeof(u32) / 2;
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
+
+		if (!limit->start_freq_khz ||
+		    !limit->end_freq_khz ||
+		    limit->start_freq_khz >= limit->end_freq_khz) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return 0;
+
+out:
+	dev_err(dev, "Failed to get limits: %d\n", err);
+	kfree(wiphy->freq_limits);
+	wiphy->n_freq_limits = 0;
+
+	return err;
+}
+EXPORT_SYMBOL(wiphy_read_of_freq_limits);
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
+static void wiphy_freq_limits_apply(struct wiphy *wiphy)
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
 /*
  * Note that right now we assume the desired channel bandwidth
  * is always 20 MHz for each individual channel (HT40 uses 20 MHz
@@ -1693,6 +1807,8 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	for (band = 0; band < NUM_NL80211_BANDS; band++)
 		handle_band(wiphy, initiator, wiphy->bands[band]);
 
+	wiphy_freq_limits_apply(wiphy);
+
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
 	reg_call_notifier(wiphy, lr);
@@ -1800,6 +1916,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 		bands_set++;
 	}
 
+	wiphy_freq_limits_apply(wiphy);
+
 	/*
 	 * no point in calling this if it won't have any effect
 	 * on your device's supported bands.
-- 
2.10.1
