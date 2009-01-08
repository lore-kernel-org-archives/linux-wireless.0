Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41659 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbZAHBoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 20:44:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 17:44:03 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/6] cfg80211: allow multiple driver regulatory_hints()
Date: Wed, 7 Jan 2009 17:43:34 -0800
Message-ID: <1231379017-28363-4-git-send-email-lrodriguez@atheros.com> (sfid-20090108_024409_363517_C42054BD)
In-Reply-To: <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support for multiple drivers to provide a regulatory_hint()
on a system by adding a wiphy specific regulatory domain cache.
This allows drivers to keep around cache their own regulatory domain
structure queried from CRDA.

We handle conflicts by intersecting multiple regulatory domains,
each driver will stick to its own regulatory domain though unless
a country IE has been received and processed.

If the user already requested a regulatory domain and a driver
requests the same regulatory domain then simply copy to the
driver's regd the same regulatory domain and do not call
CRDA, do not collect $200.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |    6 +++
 net/wireless/reg.c     |  109 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 102 insertions(+), 13 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index aedefa5..f57f12f 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -187,6 +187,10 @@ struct ieee80211_supported_band {
  * 	we will disregard the first regulatory hint (when the
  * 	initiator is %REGDOM_SET_BY_CORE).
  * @reg_notifier: the driver's regulatory notification callback
+ * @regd: the driver's regulatory domain, if one was requested via
+ * 	the regulatory_hint() API. This can be used by the driver
+ *	on the reg_notifier() if it chooses to ignore future
+ *	regulatory domain changes caused by other drivers.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -213,6 +217,8 @@ struct wiphy {
 
 	/* fields below are read-only, assigned by cfg80211 */
 
+	const struct ieee80211_regdomain *regd;
+
 	/* the item in /sys/class/ieee80211/ points to this,
 	 * you need use set_wiphy_dev() (see below) */
 	struct device dev;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 87b3011..10a3b11 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -742,29 +742,42 @@ static u32 map_regdom_flags(u32 rd_flags)
 
 /**
  * freq_reg_info - get regulatory information for the given frequency
+ * @wiphy: the wiphy for which we want to process this rule for
  * @center_freq: Frequency in KHz for which we want regulatory information for
  * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
  * 	you can set this to 0. If this frequency is allowed we then set
  * 	this value to the maximum allowed bandwidth.
  * @reg_rule: the regulatory rule which we have for this frequency
  *
- * Use this function to get the regulatory rule for a specific frequency.
+ * Use this function to get the regulatory rule for a specific frequency on
+ * a given wireless device. If the device has a specific regulatory domain
+ * it wants to follow we respect that unless a country IE has been received
+ * and processed already.
  */
-static int freq_reg_info(u32 center_freq, u32 *bandwidth,
+static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 			 const struct ieee80211_reg_rule **reg_rule)
 {
 	int i;
+	const struct ieee80211_regdomain *regd;
 	u32 max_bandwidth = 0;
 
-	if (!cfg80211_regdomain)
+	regd = cfg80211_regdomain;
+
+	/* Follow the driver's regulatory domain, if present, unless a country
+	 * IE has been processed */
+	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
+	    wiphy->regd)
+		regd = wiphy->regd;
+
+	if (!regd)
 		return -EINVAL;
 
-	for (i = 0; i < cfg80211_regdomain->n_reg_rules; i++) {
+	for (i = 0; i < regd->n_reg_rules; i++) {
 		const struct ieee80211_reg_rule *rr;
 		const struct ieee80211_freq_range *fr = NULL;
 		const struct ieee80211_power_rule *pr = NULL;
 
-		rr = &cfg80211_regdomain->reg_rules[i];
+		rr = &regd->reg_rules[i];
 		fr = &rr->freq_range;
 		pr = &rr->power_rule;
 		max_bandwidth = freq_max_bandwidth(fr, center_freq);
@@ -795,7 +808,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 
 	flags = chan->orig_flags;
 
-	r = freq_reg_info(MHZ_TO_KHZ(chan->center_freq),
+	r = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
 		&max_bandwidth, &reg_rule);
 
 	if (r) {
@@ -859,6 +872,30 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 		wiphy->reg_notifier(wiphy, setby);
 }
 
+static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
+			 const struct ieee80211_regdomain *src_regd)
+{
+	struct ieee80211_regdomain *regd;
+	int size_of_regd = 0;
+	unsigned int i;
+
+	size_of_regd = sizeof(struct ieee80211_regdomain) +
+	  ((src_regd->n_reg_rules + 1) * sizeof(struct ieee80211_reg_rule));
+
+	regd = kzalloc(size_of_regd, GFP_KERNEL);
+	if (!regd)
+		return -ENOMEM;
+
+	memcpy(regd, src_regd, sizeof(struct ieee80211_regdomain));
+
+	for (i = 0; i < src_regd->n_reg_rules; i++)
+		memcpy(&regd->reg_rules[i], &src_regd->reg_rules[i],
+			sizeof(struct ieee80211_reg_rule));
+
+	*dst_regd = regd;
+	return 0;
+}
+
 /* Return value which can be used by ignore_request() to indicate
  * it has been determined we should intersect two regulatory domains */
 #define REG_INTERSECT	1
@@ -906,9 +943,9 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		}
 		return REG_INTERSECT;
 	case REGDOM_SET_BY_DRIVER:
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			return -EALREADY;
-		return 0;
+		if (last_request->initiator == REGDOM_SET_BY_CORE)
+			return 0;
+		return REG_INTERSECT;
 	case REGDOM_SET_BY_USER:
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 			return REG_INTERSECT;
@@ -935,11 +972,28 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 
 	r = ignore_request(wiphy, set_by, alpha2);
 
-	if (r == REG_INTERSECT)
+	if (r == REG_INTERSECT) {
+		if (set_by == REGDOM_SET_BY_DRIVER) {
+			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
+			if (r)
+				return r;
+		}
 		intersect = true;
-	else if (r)
+	} else if (r) {
+		/* If the regulatory domain being requested by the
+		 * driver has already been set just copy it to the
+		 * wiphy */
+		if (r == -EALREADY && set_by == REGDOM_SET_BY_DRIVER) {
+			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
+			if (r)
+				return r;
+			r = -EALREADY;
+			goto new_request;
+		}
 		return r;
+	}
 
+new_request:
 	request = kzalloc(sizeof(struct regulatory_request),
 			  GFP_KERNEL);
 	if (!request)
@@ -955,6 +1009,11 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 
 	kfree(last_request);
 	last_request = request;
+
+	/* When r == REG_INTERSECT we do need to call CRDA */
+	if (r < 0)
+		return r;
+
 	/*
 	 * Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
 	 * AND if CRDA is NOT present nothing will happen, if someone
@@ -1248,6 +1307,23 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	if (!last_request->intersect) {
+		int r;
+
+		if (last_request->initiator != REGDOM_SET_BY_DRIVER) {
+			reset_regdomains();
+			cfg80211_regdomain = rd;
+			return 0;
+		}
+
+		/* For a driver hint, lets copy the regulatory domain the
+		 * driver wanted to the wiphy to deal with conflicts */
+
+		BUG_ON(last_request->wiphy->regd);
+
+		r = reg_copy_regd(&last_request->wiphy->regd, rd);
+		if (r)
+			return r;
+
 		reset_regdomains();
 		cfg80211_regdomain = rd;
 		return 0;
@@ -1261,8 +1337,14 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		if (!intersected_rd)
 			return -EINVAL;
 
-		/* We can trash what CRDA provided now */
-		kfree(rd);
+		/* We can trash what CRDA provided now.
+		 * However if a driver requested this specific regulatory
+		 * domain we keep it for its private use */
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
+			last_request->wiphy->regd = rd;
+		else
+			kfree(rd);
+
 		rd = NULL;
 
 		reset_regdomains();
@@ -1346,6 +1428,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 /* Caller must hold cfg80211_drv_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
+	kfree(wiphy->regd);
 	if (!last_request || !last_request->wiphy)
 		return;
 	if (last_request->wiphy != wiphy)
-- 
1.6.1.rc3.51.g5832d

