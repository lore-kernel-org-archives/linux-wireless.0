Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZBZCkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 21:40:00 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] cfg80211: move enums reg_set_by and environment_cap to nl80211.h
Date: Wed, 25 Feb 2009 21:39:48 -0500
Message-Id: <1235615989-1323-3-git-send-email-lrodriguez@atheros.com> (sfid-20090226_034008_917259_77C0FD76)
In-Reply-To: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
References: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do this so we can later inform userspace who set the
regulatory domain and provide details of the request.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    2 +-
 drivers/net/wireless/ath9k/regd.c |   31 +++++++------
 drivers/net/wireless/ath9k/regd.h |    3 +-
 include/linux/nl80211.h           |   34 ++++++++++++++
 include/net/cfg80211.h            |   37 +--------------
 net/wireless/core.c               |    2 +-
 net/wireless/core.h               |    5 +-
 net/wireless/reg.c                |   90 ++++++++++++++++++++-----------------
 8 files changed, 110 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index b85f6cf..2f3be17 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1653,7 +1653,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	}
 	wiphy_apply_custom_regulatory(hw->wiphy, regd);
 	ath9k_reg_apply_radar_flags(hw->wiphy);
-	ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_DRIVER);
+	ath9k_reg_apply_world_flags(hw->wiphy, NL80211_REGDOM_SET_BY_DRIVER);
 
 	error = ieee80211_register_hw(hw);
 
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 4f27cec..eb09ccd 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -168,8 +168,9 @@ static bool ath9k_is_radar_freq(u16 center_freq)
  *   received a beacon on a channel we can enable active scan and
  *   adhoc (or beaconing).
  */
-static void ath9k_reg_apply_beaconing_flags(struct wiphy *wiphy,
-					     enum reg_set_by setby)
+static void ath9k_reg_apply_beaconing_flags(
+	struct wiphy *wiphy,
+	enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -194,7 +195,7 @@ static void ath9k_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 
-			if (setby == REGDOM_SET_BY_COUNTRY_IE) {
+			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 				r = freq_reg_info(wiphy, ch->center_freq,
 					&bandwidth, &reg_rule);
 				if (r)
@@ -226,8 +227,9 @@ static void ath9k_reg_apply_beaconing_flags(struct wiphy *wiphy,
 }
 
 /* Allows active scan scan on Ch 12 and 13 */
-static void ath9k_reg_apply_active_scan_flags(struct wiphy *wiphy,
-					      enum reg_set_by setby)
+static void ath9k_reg_apply_active_scan_flags(
+	struct wiphy *wiphy,
+	enum nl80211_reg_initiator initiator)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
@@ -241,7 +243,7 @@ static void ath9k_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 * If no country IE has been received always enable active scan
 	 * on these channels. This is only done for specific regulatory SKUs
 	 */
-	if (setby != REGDOM_SET_BY_COUNTRY_IE) {
+	if (initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 		ch = &sband->channels[11]; /* CH 12 */
 		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
@@ -308,7 +310,8 @@ void ath9k_reg_apply_radar_flags(struct wiphy *wiphy)
 	}
 }
 
-void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby)
+void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
+				 enum nl80211_reg_initiator initiator)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath_softc *sc = hw->priv;
@@ -319,11 +322,11 @@ void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby)
 	case 0x63:
 	case 0x66:
 	case 0x67:
-		ath9k_reg_apply_beaconing_flags(wiphy, setby);
+		ath9k_reg_apply_beaconing_flags(wiphy, initiator);
 		break;
 	case 0x68:
-		ath9k_reg_apply_beaconing_flags(wiphy, setby);
-		ath9k_reg_apply_active_scan_flags(wiphy, setby);
+		ath9k_reg_apply_beaconing_flags(wiphy, initiator);
+		ath9k_reg_apply_active_scan_flags(wiphy, initiator);
 		break;
 	}
 	return;
@@ -338,11 +341,11 @@ int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	ath9k_reg_apply_radar_flags(wiphy);
 
 	switch (request->initiator) {
-	case REGDOM_SET_BY_DRIVER:
-	case REGDOM_SET_BY_CORE:
-	case REGDOM_SET_BY_USER:
+	case NL80211_REGDOM_SET_BY_DRIVER:
+	case NL80211_REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_USER:
 		break;
-	case REGDOM_SET_BY_COUNTRY_IE:
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		if (ath9k_is_world_regd(sc->sc_ah))
 			ath9k_reg_apply_world_flags(wiphy, request->initiator);
 		break;
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index d48160d..8f885f3 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -236,7 +236,8 @@ enum CountryCode {
 bool ath9k_is_world_regd(struct ath_hw *ah);
 const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah);
 const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
-void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby);
+void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
+				 enum nl80211_reg_initiator initiator);
 void ath9k_reg_apply_radar_flags(struct wiphy *wiphy);
 int ath9k_regd_init(struct ath_hw *ah);
 bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah);
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2d7fcc1..989be40 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -698,6 +698,40 @@ enum nl80211_bitrate_attr {
 };
 
 /**
+ * enum nl80211_initiator - Indicates the initiator of a reg domain request
+ * @NL80211_REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world
+ * 	regulatory domain.
+ * @NL80211_REGDOM_SET_BY_USER: User asked the wireless core to set the
+ * 	regulatory domain.
+ * @NL80211_REGDOM_SET_BY_DRIVER: a wireless drivers has hinted to the
+ * 	wireless core it thinks its knows the regulatory domain we should be in.
+ * @NL80211_REGDOM_SET_BY_COUNTRY_IE: the wireless core has received an
+ * 	802.11 country information element with regulatory information it
+ * 	thinks we should consider.
+ */
+enum nl80211_reg_initiator {
+	NL80211_REGDOM_SET_BY_CORE,
+	NL80211_REGDOM_SET_BY_USER,
+	NL80211_REGDOM_SET_BY_DRIVER,
+	NL80211_REGDOM_SET_BY_COUNTRY_IE,
+};
+
+/**
+ * enum nl80211_environment_cap - Environment parsed from country IE
+ * @NL80211_ENVIRON_ANY: indicates country IE applies to both indoor and
+ * 	outdoor operation.
+ * @NL80211_ENVIRON_INDOOR: indicates country IE applies only to
+ * 	indoor operation
+ * @NL80211_ENVIRON_OUTDOOR: indicates country IE applies only to
+ * 	outdoor operation
+ */
+enum nl80211_environment_cap {
+	NL80211_ENVIRON_ANY,
+	NL80211_ENVIRON_INDOOR,
+	NL80211_ENVIRON_OUTDOOR,
+};
+
+/**
  * enum nl80211_reg_rule_attr - regulatory rule attributes
  * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
  * 	considerations for a given frequency range. These are the
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 142de14..5ac10bd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -349,37 +349,6 @@ struct bss_parameters {
 };
 
 /**
- * enum reg_set_by - Indicates who is trying to set the regulatory domain
- * @REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world regulatory domain.
- * @REGDOM_SET_BY_USER: User asked the wireless core to set the
- * 	regulatory domain.
- * @REGDOM_SET_BY_DRIVER: a wireless drivers has hinted to the wireless core
- *	it thinks its knows the regulatory domain we should be in.
- * @REGDOM_SET_BY_COUNTRY_IE: the wireless core has received an 802.11 country
- *	information element with regulatory information it thinks we
- *	should consider.
- */
-enum reg_set_by {
-	REGDOM_SET_BY_CORE,
-	REGDOM_SET_BY_USER,
-	REGDOM_SET_BY_DRIVER,
-	REGDOM_SET_BY_COUNTRY_IE,
-};
-
-/**
- * enum environment_cap - Environment parsed from country IE
- * @ENVIRON_ANY: indicates country IE applies to both indoor and
- * 	outdoor operation.
- * @ENVIRON_INDOOR: indicates country IE applies only to indoor operation
- * @ENVIRON_OUTDOOR: indicates country IE applies only to outdoor operation
- */
-enum environment_cap {
-	ENVIRON_ANY,
-	ENVIRON_INDOOR,
-	ENVIRON_OUTDOOR,
-};
-
-/**
  * struct regulatory_request - used to keep track of regulatory requests
  *
  * @wiphy_idx: this is set if this request's initiator is
@@ -388,7 +357,7 @@ enum environment_cap {
  * 	and potentially inform users of which devices specifically
  * 	cased the conflicts.
  * @initiator: indicates who sent this request, could be any of
- * 	of those set in reg_set_by, %REGDOM_SET_BY_*
+ * 	of those set in nl80211_reg_initiator, %REGDOM_SET_BY_*
  * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
  * 	regulatory domain. We have a few special codes:
  * 	00 - World regulatory domain
@@ -405,11 +374,11 @@ enum environment_cap {
  */
 struct regulatory_request {
 	int wiphy_idx;
-	enum reg_set_by initiator;
+	enum nl80211_reg_initiator initiator;
 	char alpha2[2];
 	bool intersect;
 	u32 country_ie_checksum;
-	enum environment_cap country_ie_env;
+	enum nl80211_environment_cap country_ie_env;
 	struct list_head list;
 };
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index dd7f222..c939f5e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -350,7 +350,7 @@ int wiphy_register(struct wiphy *wiphy)
 	mutex_lock(&cfg80211_mutex);
 
 	/* set up regulatory info */
-	wiphy_update_regulatory(wiphy, REGDOM_SET_BY_CORE);
+	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
 	res = device_add(&drv->wiphy.dev);
 	if (res)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index cd8e6e3..46c83c7 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -35,7 +35,7 @@ struct cfg80211_registered_device {
 
 	/* If a Country IE has been received this tells us the environment
 	 * which its telling us its in. This defaults to ENVIRON_ANY */
-	enum environment_cap env;
+	enum nl80211_environment_cap env;
 
 	/* wiphy index, internal only */
 	int wiphy_idx;
@@ -136,7 +136,8 @@ extern int cfg80211_dev_rename(struct cfg80211_registered_device *drv,
 			       char *newname);
 
 void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
-void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby);
+void wiphy_update_regulatory(struct wiphy *wiphy,
+			     enum nl80211_reg_initiator setby);
 
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev);
 void cfg80211_bss_age(struct cfg80211_registered_device *dev,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a230d4b..c40e99e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -845,8 +845,8 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	 * Follow the driver's regulatory domain, if present, unless a country
 	 * IE has been processed or a user wants to help complaince further
 	 */
-	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
-	    last_request->initiator != REGDOM_SET_BY_USER &&
+	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    last_request->initiator != NL80211_REGDOM_SET_BY_USER &&
 	    wiphy->regd)
 		regd = wiphy->regd;
 
@@ -931,7 +931,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		 * http://tinyurl.com/11d-clarification
 		 */
 		if (r == -ERANGE &&
-		    last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
+		    last_request->initiator ==
+		    NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 #ifdef CONFIG_CFG80211_REG_DEBUG
 			printk(KERN_DEBUG "cfg80211: Leaving channel %d MHz "
 				"intact on %s - no rule found in band on "
@@ -944,7 +945,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		 * for the band so we respect its band definitions
 		 */
 #ifdef CONFIG_CFG80211_REG_DEBUG
-			if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
+			if (last_request->initiator ==
+			    NL80211_REGDOM_SET_BY_COUNTRY_IE)
 				printk(KERN_DEBUG "cfg80211: Disabling "
 					"channel %d MHz on %s due to "
 					"Country IE\n",
@@ -958,7 +960,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 
 	power_rule = &reg_rule->power_rule;
 
-	if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
+	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
 	    request_wiphy->strict_regulatory) {
 		/*
@@ -999,11 +1001,12 @@ static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
 		handle_channel(wiphy, band, i);
 }
 
-static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
+static bool ignore_reg_update(struct wiphy *wiphy,
+			      enum nl80211_reg_initiator initiator)
 {
 	if (!last_request)
 		return true;
-	if (setby == REGDOM_SET_BY_CORE &&
+	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
 		  wiphy->custom_regulatory)
 		return true;
 	/*
@@ -1016,12 +1019,12 @@ static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
 	return false;
 }
 
-static void update_all_wiphy_regulatory(enum reg_set_by setby)
+static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 {
 	struct cfg80211_registered_device *drv;
 
 	list_for_each_entry(drv, &cfg80211_drv_list, list)
-		wiphy_update_regulatory(&drv->wiphy, setby);
+		wiphy_update_regulatory(&drv->wiphy, initiator);
 }
 
 static void handle_reg_beacon(struct wiphy *wiphy,
@@ -1112,7 +1115,7 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
 	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
 		return true;
-	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
+	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    wiphy->custom_regulatory)
 		return true;
 	return false;
@@ -1126,11 +1129,12 @@ static void reg_process_beacons(struct wiphy *wiphy)
 	wiphy_update_beacon_reg(wiphy);
 }
 
-void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
+void wiphy_update_regulatory(struct wiphy *wiphy,
+			     enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
 
-	if (ignore_reg_update(wiphy, setby))
+	if (ignore_reg_update(wiphy, initiator))
 		goto out;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
@@ -1243,15 +1247,16 @@ static int ignore_request(struct wiphy *wiphy,
 		return 0;
 
 	switch (pending_request->initiator) {
-	case REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_CORE:
 		return -EINVAL;
-	case REGDOM_SET_BY_COUNTRY_IE:
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 
 		last_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
 		if (unlikely(!is_an_alpha2(pending_request->alpha2)))
 			return -EINVAL;
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
+		if (last_request->initiator ==
+		    NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 			if (last_wiphy != wiphy) {
 				/*
 				 * Two cards with two APs claiming different
@@ -1272,8 +1277,8 @@ static int ignore_request(struct wiphy *wiphy,
 			return -EALREADY;
 		}
 		return REG_INTERSECT;
-	case REGDOM_SET_BY_DRIVER:
-		if (last_request->initiator == REGDOM_SET_BY_CORE) {
+	case NL80211_REGDOM_SET_BY_DRIVER:
+		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
 			if (is_old_static_regdom(cfg80211_regdomain))
 				return 0;
 			if (regdom_changes(pending_request->alpha2))
@@ -1286,28 +1291,28 @@ static int ignore_request(struct wiphy *wiphy,
 		 * back in or if you add a new device for which the previously
 		 * loaded card also agrees on the regulatory domain.
 		 */
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
+		if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 		    !regdom_changes(pending_request->alpha2))
 			return -EALREADY;
 
 		return REG_INTERSECT;
-	case REGDOM_SET_BY_USER:
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
+	case NL80211_REGDOM_SET_BY_USER:
+		if (last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
 			return REG_INTERSECT;
 		/*
 		 * If the user knows better the user should set the regdom
 		 * to their country before the IE is picked up
 		 */
-		if (last_request->initiator == REGDOM_SET_BY_USER &&
+		if (last_request->initiator == NL80211_REGDOM_SET_BY_USER &&
 			  last_request->intersect)
 			return -EOPNOTSUPP;
 		/*
 		 * Process user requests only after previous user/driver/core
 		 * requests have been processed
 		 */
-		if (last_request->initiator == REGDOM_SET_BY_CORE ||
-		    last_request->initiator == REGDOM_SET_BY_DRIVER ||
-		    last_request->initiator == REGDOM_SET_BY_USER) {
+		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE ||
+		    last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
+		    last_request->initiator == NL80211_REGDOM_SET_BY_USER) {
 			if (regdom_changes(last_request->alpha2))
 				return -EAGAIN;
 		}
@@ -1347,7 +1352,8 @@ static int __regulatory_hint(struct wiphy *wiphy,
 	r = ignore_request(wiphy, pending_request);
 
 	if (r == REG_INTERSECT) {
-		if (pending_request->initiator == REGDOM_SET_BY_DRIVER) {
+		if (pending_request->initiator ==
+		    NL80211_REGDOM_SET_BY_DRIVER) {
 			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
 			if (r) {
 				kfree(pending_request);
@@ -1362,7 +1368,8 @@ static int __regulatory_hint(struct wiphy *wiphy,
 		 * wiphy
 		 */
 		if (r == -EALREADY &&
-		    pending_request->initiator == REGDOM_SET_BY_DRIVER) {
+		    pending_request->initiator ==
+		    NL80211_REGDOM_SET_BY_DRIVER) {
 			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
 			if (r) {
 				kfree(pending_request);
@@ -1413,7 +1420,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	if (wiphy_idx_valid(reg_request->wiphy_idx))
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	if (reg_request->initiator == REGDOM_SET_BY_DRIVER &&
+	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    !wiphy) {
 		kfree(reg_request);
 		goto out;
@@ -1427,7 +1434,7 @@ out:
 	mutex_unlock(&cfg80211_mutex);
 }
 
-/* Processes regulatory hints, this is all the REGDOM_SET_BY_* */
+/* Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_* */
 static void reg_process_pending_hints(void)
 	{
 	struct regulatory_request *reg_request;
@@ -1511,7 +1518,7 @@ static int regulatory_hint_core(const char *alpha2)
 
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
-	request->initiator = REGDOM_SET_BY_CORE;
+	request->initiator = NL80211_REGDOM_SET_BY_CORE;
 
 	queue_regulatory_request(request);
 
@@ -1532,7 +1539,7 @@ int regulatory_hint_user(const char *alpha2)
 	request->wiphy_idx = WIPHY_IDX_STALE;
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
-	request->initiator = REGDOM_SET_BY_USER,
+	request->initiator = NL80211_REGDOM_SET_BY_USER,
 
 	queue_regulatory_request(request);
 
@@ -1558,7 +1565,7 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
-	request->initiator = REGDOM_SET_BY_DRIVER;
+	request->initiator = NL80211_REGDOM_SET_BY_DRIVER;
 
 	queue_regulatory_request(request);
 
@@ -1597,7 +1604,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	struct ieee80211_regdomain *rd = NULL;
 	char alpha2[2];
 	u32 checksum = 0;
-	enum environment_cap env = ENVIRON_ANY;
+	enum nl80211_environment_cap env = NL80211_ENVIRON_ANY;
 	struct regulatory_request *request;
 
 	mutex_lock(&cfg80211_mutex);
@@ -1626,9 +1633,9 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	alpha2[1] = country_ie[1];
 
 	if (country_ie[2] == 'I')
-		env = ENVIRON_INDOOR;
+		env = NL80211_ENVIRON_INDOOR;
 	else if (country_ie[2] == 'O')
-		env = ENVIRON_OUTDOOR;
+		env = NL80211_ENVIRON_OUTDOOR;
 
 	/*
 	 * We will run this for *every* beacon processed for the BSSID, so
@@ -1707,7 +1714,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	request->wiphy_idx = get_wiphy_idx(wiphy);
 	request->alpha2[0] = rd->alpha2[0];
 	request->alpha2[1] = rd->alpha2[1];
-	request->initiator = REGDOM_SET_BY_COUNTRY_IE;
+	request->initiator = NL80211_REGDOM_SET_BY_COUNTRY_IE;
 	request->country_ie_checksum = checksum;
 	request->country_ie_env = env;
 
@@ -1815,7 +1822,8 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 
 	if (is_intersected_alpha2(rd->alpha2)) {
 
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
+		if (last_request->initiator ==
+		    NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 			struct cfg80211_registered_device *drv;
 			drv = cfg80211_drv_by_wiphy_idx(
 				last_request->wiphy_idx);
@@ -1907,7 +1915,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 * rd is non static (it means CRDA was present and was used last)
 	 * and the pending request came in from a country IE
 	 */
-	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE) {
+	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 		/*
 		 * If someone else asked us to change the rd lets only bother
 		 * checking if the alpha2 changes if CRDA was already called
@@ -1939,7 +1947,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (!last_request->intersect) {
 		int r;
 
-		if (last_request->initiator != REGDOM_SET_BY_DRIVER) {
+		if (last_request->initiator != NL80211_REGDOM_SET_BY_DRIVER) {
 			reset_regdomains();
 			cfg80211_regdomain = rd;
 			return 0;
@@ -1963,7 +1971,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 	/* Intersection requires a bit more work */
 
-	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE) {
+	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 
 		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
 		if (!intersected_rd)
@@ -1974,7 +1982,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * However if a driver requested this specific regulatory
 		 * domain we keep it for its private use
 		 */
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
+		if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER)
 			request_wiphy->regd = rd;
 		else
 			kfree(rd);
@@ -2082,7 +2090,7 @@ void reg_device_remove(struct wiphy *wiphy)
 	if (request_wiphy != wiphy)
 		return;
 	last_request->wiphy_idx = WIPHY_IDX_STALE;
-	last_request->country_ie_env = ENVIRON_ANY;
+	last_request->country_ie_env = NL80211_ENVIRON_ANY;
 }
 
 int regulatory_init(void)
-- 
1.6.0.3

