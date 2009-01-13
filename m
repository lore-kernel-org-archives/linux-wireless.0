Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19385 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZAMT6d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:33 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:33 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 05/12] cfg80211: add regulatory_set_custom_rd()
Date: Tue, 13 Jan 2009 11:57:48 -0800
Message-ID: <1231876675-20518-6-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205836_532727_36DA4906)
In-Reply-To: <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds regulatory_set_custom_rd() to allow drivers to apply custom
regulatory domains to their wireless device. This is required on drivers
that do not have a direct 1-1 mapping between a regugulatory domain and a
country. This applies to custom "world regulatory domains" which vendors
may use.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |   20 +++++++++++++++++++-
 net/wireless/reg.c     |   17 +++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index ea89958..16f020a 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -183,7 +183,8 @@ struct ieee80211_supported_band {
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
  * @ignore_country_ies: tells us the wireless core should ignore country IEs
  *	received by itself or by other wireless drivers. This will only
- *	apply if the driver has provided a regulatory_hint()
+ *	apply if the driver has provided its own regulatory domain via
+ *	regulatory_hint() or regulatory_set_custom_rd()
  * @fw_handles_regulatory: tells us the firmware for this device
  * 	has its own regulatory solution and cannot identify the
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
@@ -405,4 +406,21 @@ extern void regulatory_hint(struct wiphy *wiphy, const char *alpha2);
 extern void regulatory_hint_11d(struct wiphy *wiphy,
 				u8 *country_ie,
 				u8 country_ie_len);
+
+/**
+ * regulatory_set_custom_rd - apply a custom driver regulatory domain
+ * @wiphy: the wireless device we want to process the regulatory domain on
+ * @custom_regd: the custom regulatory domain to use for this wiphy
+ *
+ * Drivers can sometimes have custom regulatory domains which do not apply
+ * to a specific country. Drivers can use this to apply such custom regulatory
+ * domains. The custom regulatory domain will be copied into a new wiphy->regd
+ * for internal usage within cfg80211. The driver is in charge of freeing
+ * the passed regulatory domain if created using kmalloc(). This can be called
+ * after the wiphy has been registered with cfg80211.
+ */
+extern int regulatory_set_custom_rd(
+	struct wiphy *wiphy,
+	const struct ieee80211_regdomain *custom_regd);
+
 #endif /* __NET_WIRELESS_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 127bec2..b05df36 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1003,6 +1003,23 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 	return 0;
 }
 
+int regulatory_set_custom_rd(struct wiphy *wiphy,
+			       const struct ieee80211_regdomain *custom_regd)
+{
+	int r = 0;
+	mutex_lock(&cfg80211_drv_mutex);
+	r = reg_copy_regd(&wiphy->regd, custom_regd);
+	if (r)
+		goto unlock;
+	regd_update_regulatory(wiphy);
+	if (wiphy->reg_notifier)
+		wiphy->reg_notifier(wiphy, REGDOM_SET_BY_DRIVER);
+unlock:
+	mutex_unlock(&cfg80211_drv_mutex);
+	return r;
+}
+EXPORT_SYMBOL(regulatory_set_custom_rd);
+
 /* Return value which can be used by ignore_request() to indicate
  * it has been determined we should intersect two regulatory domains */
 #define REG_INTERSECT	1
-- 
1.6.1.rc3.51.g5832d

