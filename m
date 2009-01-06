Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63611 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZAFPWR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 10:22:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 07:22:17 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC 4/4] cfg80211: allow multiple driver regulatory_hints()
Date: Tue, 6 Jan 2009 07:22:02 -0800
Message-ID: <1231255322-13100-5-git-send-email-lrodriguez@atheros.com> (sfid-20090106_162220_670385_FE85E397)
In-Reply-To: <1231255322-13100-4-git-send-email-lrodriguez@atheros.com>
References: <1231255322-13100-1-git-send-email-lrodriguez@atheros.com>
 <1231255322-13100-2-git-send-email-lrodriguez@atheros.com>
 <1231255322-13100-3-git-send-email-lrodriguez@atheros.com>
 <1231255322-13100-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We handle conflicts by intersecting multiple regulatory domains,
each driver will stick to its own regulatory domain though unless
a country IE has been received and processed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   43 +++++++++++++++++++++++++++++--------------
 1 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 09ba97f..2ea95cf 100644
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
@@ -906,9 +919,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		}
 		return REG_INTERSECT;
 	case REGDOM_SET_BY_DRIVER:
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			return -EALREADY;
-		return 0;
+		return REG_INTERSECT;
 	case REGDOM_SET_BY_USER:
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 			return REG_INTERSECT;
@@ -1258,9 +1269,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		}
 
 		/* For a driver hint, lets copy the regulatory domain the
-		 * driver wanted to the wiphy to deal with conflicts or allow
-		 * the driver itself to decide whether or not it wants to ignore
-		 * specific user updates through the reg_notifier() */
+		 * driver wanted to the wiphy to deal with conflicts */
 
 		BUG_ON(last_request->wiphy->regd);
 
@@ -1285,8 +1294,14 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		if (!intersected_rd)
 			return -EINVAL;
 
-		/* We can trash what CRDA provided now */
-		kfree(rd);
+		/* We can trash what CRDA provided now.
+		 * However if a driver requested this specific regulatory domain we
+		 * keep it for its private use */
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
+			last_request->wiphy->regd = rd;
+		else
+			kfree(rd);
+
 		rd = NULL;
 
 		reset_regdomains();
-- 
1.6.1.rc3.51.g5832d

