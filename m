Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34643 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbdADR7g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 12:59:36 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V6 3/3] cfg80211: support ieee80211-freq-limit DT property
Date: Wed,  4 Jan 2017 18:58:31 +0100
Message-Id: <20170104175832.25996-3-zajec5@gmail.com> (sfid-20170104_190312_626736_E884F0DB)
In-Reply-To: <20170104175832.25996-1-zajec5@gmail.com>
References: <20170104175832.25996-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This patch adds a helper for reading that new property and applying
limitations of supported channels specified this way.
It is used with devices that normally support a wide wireless band but
in a given config are limited to some part of it (usually due to board
design). For example a dual-band chipset may be able to support one band
only because of used antennas.
It's also common that tri-band routers have separated radios for lower
and higher part of 5 GHz band and it may be impossible to say which is
which without a DT info.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Put main code in core.c as it isn't strictly part of regulatory - pointed
    by Arend.
    Update to support ieee80211-freq-limit (new property).
V3: Introduce separated wiphy_read_of_freq_limits function.
    Add extra sanity checks for DT data.
    Move code back to reg.c as suggested by Johannes.
V4: Move code to of.c
    Use one helper called at init time (no runtime hooks)
    Modify orig_flags
V5: Make wiphy_read_of_freq_limits return void as there isn't much point of
    handling errors.
V6: Set IEEE80211_CHAN_DISABLED in "flags" instead of "orig_flags" as they will
    be copied during wiphy_register. Also improve description & note that helper
    has to be called before wiphy_register.
---
 include/net/cfg80211.h |  28 ++++++++++
 net/wireless/Makefile  |   1 +
 net/wireless/of.c      | 138 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 167 insertions(+)
 create mode 100644 net/wireless/of.c

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ca2ac1c..30841a9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -311,6 +311,34 @@ struct ieee80211_supported_band {
 	struct ieee80211_sta_vht_cap vht_cap;
 };
 
+/**
+ * wiphy_read_of_freq_limits - read frequency limits from device tree
+ *
+ * @wiphy: the wireless device to get extra limits for
+ *
+ * Some devices may have extra limitations specified in DT. This may be useful
+ * for chipsets that normally support more bands but are limited due to board
+ * design (e.g. by antennas or external power amplifier).
+ *
+ * This function reads info from DT and uses it to *modify* channels (disable
+ * unavailable ones). It's usually a *bad* idea to use it in drivers with
+ * shared channel data as DT limitations are device specific. You should make
+ * sure to call it only if channels in wiphy are copied and can be modified
+ * without affecting other devices.
+ *
+ * As this function access device node it has to be called after set_wiphy_dev.
+ * It also modifies channels so they have to be set first.
+ * If using this helper, call it before wiphy_register.
+ */
+#ifdef CONFIG_OF
+void wiphy_read_of_freq_limits(struct wiphy *wiphy);
+#else /* CONFIG_OF */
+static inline void wiphy_read_of_freq_limits(struct wiphy *wiphy)
+{
+}
+#endif /* !CONFIG_OF */
+
+
 /*
  * Wireless hardware/device configuration structures and methods
  */
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 4c9e39f..95b4c09 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
 cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o ocb.o
+cfg80211-$(CONFIG_OF) += of.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
diff --git a/net/wireless/of.c b/net/wireless/of.c
new file mode 100644
index 0000000..de221f0
--- /dev/null
+++ b/net/wireless/of.c
@@ -0,0 +1,138 @@
+/*
+ * Copyright (C) 2017 Rafał Miłecki <rafal@milecki.pl>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/of.h>
+#include <net/cfg80211.h>
+#include "core.h"
+
+static bool wiphy_freq_limits_valid_chan(struct wiphy *wiphy,
+					 struct ieee80211_freq_range *freq_limits,
+					 unsigned int n_freq_limits,
+					 struct ieee80211_channel *chan)
+{
+	u32 bw = MHZ_TO_KHZ(20);
+	int i;
+
+	for (i = 0; i < n_freq_limits; i++) {
+		struct ieee80211_freq_range *limit = &freq_limits[i];
+
+		if (cfg80211_does_bw_fit_range(limit,
+					       MHZ_TO_KHZ(chan->center_freq),
+					       bw))
+			return true;
+	}
+
+	return false;
+}
+
+static void wiphy_freq_limits_apply(struct wiphy *wiphy,
+				    struct ieee80211_freq_range *freq_limits,
+				    unsigned int n_freq_limits)
+{
+	enum nl80211_band band;
+	int i;
+
+	if (WARN_ON(!n_freq_limits))
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
+			if (!wiphy_freq_limits_valid_chan(wiphy, freq_limits,
+							  n_freq_limits,
+							  chan)) {
+				pr_debug("Disabling freq %d MHz as it's out of OF limits\n",
+					 chan->center_freq);
+				chan->flags |= IEEE80211_CHAN_DISABLED;
+			}
+		}
+	}
+}
+
+void wiphy_read_of_freq_limits(struct wiphy *wiphy)
+{
+	struct device *dev = wiphy_dev(wiphy);
+	struct device_node *np;
+	struct property *prop;
+	struct ieee80211_freq_range *freq_limits;
+	unsigned int n_freq_limits;
+	const __be32 *p;
+	int len, i;
+	int err = 0;
+
+	if (!dev)
+		return;
+	np = dev_of_node(dev);
+	if (!np)
+		return;
+
+	prop = of_find_property(np, "ieee80211-freq-limit", &len);
+	if (!prop)
+		return;
+
+	if (!len || len % sizeof(u32) || len / sizeof(u32) % 2) {
+		dev_err(dev, "ieee80211-freq-limit wrong format");
+		return;
+	}
+	n_freq_limits = len / sizeof(u32) / 2;
+
+	freq_limits = kcalloc(n_freq_limits, sizeof(*freq_limits), GFP_KERNEL);
+	if (!freq_limits) {
+		err = -ENOMEM;
+		goto out_kfree;
+	}
+
+	p = NULL;
+	for (i = 0; i < n_freq_limits; i++) {
+		struct ieee80211_freq_range *limit = &freq_limits[i];
+
+		p = of_prop_next_u32(prop, p, &limit->start_freq_khz);
+		if (!p) {
+			err = -EINVAL;
+			goto out_kfree;
+		}
+
+		p = of_prop_next_u32(prop, p, &limit->end_freq_khz);
+		if (!p) {
+			err = -EINVAL;
+			goto out_kfree;
+		}
+
+		if (!limit->start_freq_khz ||
+		    !limit->end_freq_khz ||
+		    limit->start_freq_khz >= limit->end_freq_khz) {
+			err = -EINVAL;
+			goto out_kfree;
+		}
+	}
+
+	wiphy_freq_limits_apply(wiphy, freq_limits, n_freq_limits);
+
+out_kfree:
+	kfree(freq_limits);
+	if (err)
+		dev_err(dev, "Failed to get limits: %d\n", err);
+}
+EXPORT_SYMBOL(wiphy_read_of_freq_limits);
-- 
2.10.1
