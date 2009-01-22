Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42531 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758350AbZAVXG5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 10/12] cfg80211: Allow for strict regulatory settings
Date: Thu, 22 Jan 2009 15:05:52 -0800
Message-ID: <1232665554-26132-11-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000708_636206_89917296)
In-Reply-To: <1232665554-26132-10-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-5-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-6-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-7-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-8-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-9-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-10-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to request strict regulatory settings to
be applied to its devices. This is desirable for devices where
proper calibration and compliance can only be gauranteed for
for the device's programmed regulatory domain. Regulatory
domain settings will be ignored until the device's own
regulatory domain is properly configured. If no regulatory
domain is received only the world regulatory domain will be
applied -- if OLD_REG (default to "US") is not enabled. If
OLD_REG behaviour is not acceptable to drivers they must
update their wiphy with a custom reuglatory prior to wiphy
registration.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |   10 ++++++++++
 net/wireless/reg.c     |   28 +++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index fbe7341..f2af156 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -186,6 +186,15 @@ struct ieee80211_supported_band {
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
  * 	we will disregard the first regulatory hint (when the
  * 	initiator is %REGDOM_SET_BY_CORE).
+ * @strict_regulatory: tells us the driver for this device will ignore
+ * 	regulatory domain settings until it gets its own regulatory domain
+ * 	via its regulatory_hint(). After its gets its own regulatory domain
+ * 	it will only allow further regulatory domain settings to further
+ * 	enhance compliance. For example if channel 13 and 14 are disabled
+ * 	by this regulatory domain no user regulatory domain can enable these
+ * 	channels at a later time. This can be used for devices which do not
+ * 	have calibration information gauranteed for frequencies or settings
+ * 	outside of its regulatory domain.
  * @reg_notifier: the driver's regulatory notification callback
  * @regd: the driver's regulatory domain, if one was requested via
  * 	the regulatory_hint() API. This can be used by the driver
@@ -202,6 +211,7 @@ struct wiphy {
 	u16 interface_modes;
 
 	bool custom_regulatory;
+	bool strict_regulatory;
 
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 57a3fb4..2da5427 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -875,6 +875,22 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 
 	power_rule = &reg_rule->power_rule;
 
+	if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
+	    last_request->wiphy && last_request->wiphy == wiphy &&
+	    last_request->wiphy->strict_regulatory) {
+		/* This gaurantees the driver's requested regulatory domain
+		 * will always be used as a base for further regulatory
+		 * settings */
+		chan->flags = chan->orig_flags =
+			map_regdom_flags(reg_rule->flags);
+		chan->max_antenna_gain = chan->orig_mag =
+			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
+		chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
+		chan->max_power = chan->orig_mpwr =
+			(int) MBM_TO_DBM(power_rule->max_eirp);
+		return;
+	}
+
 	chan->flags = flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
@@ -905,6 +921,11 @@ static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
 	if (setby == REGDOM_SET_BY_CORE &&
 		  wiphy->custom_regulatory)
 		return true;
+	/* wiphy->regd will be set once the device has its own
+	 * desired regulatory domain set */
+	if (wiphy->strict_regulatory && !wiphy->regd &&
+	    !is_world_regdom(last_request->alpha2))
+		return true;
 	return false;
 }
 
@@ -1163,10 +1184,15 @@ new_request:
 
 void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 {
+	int r;
 	BUG_ON(!alpha2);
 
 	mutex_lock(&cfg80211_drv_mutex);
-	__regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, 0, ENVIRON_ANY);
+	r = __regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER,
+		alpha2, 0, ENVIRON_ANY);
+	/* This is required so that the orig_* parameters are saved */
+	if (r == -EALREADY && wiphy->strict_regulatory)
+		wiphy_update_regulatory(wiphy, REGDOM_SET_BY_DRIVER);
 	mutex_unlock(&cfg80211_drv_mutex);
 }
 EXPORT_SYMBOL(regulatory_hint);
-- 
1.6.1.rc3.51.g5832d

