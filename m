Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2LDOtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:49:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 14/18] regulatory: clarify locking rules and assertions
Date: Tue,  4 Dec 2012 15:48:56 +0100
Message-Id: <1354632540-21207-15-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154928_618062_C567160A)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Many places that currently check that cfg80211_
The function needs to hold the cfg80211_mutex as
it uses the global cfg80211_regdomain variable, so
add the lock assertion to it and fix one of the
callers that doesn't hold that mutex.

Also remove a whole bunch of pointless assertions
for the mutex that are in functions that don't use
anything protected by it but add some others where
they actually make sense.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1dc94da..e0a7312 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -94,14 +94,14 @@ static struct device_type reg_device_type = {
 /*
  * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
- * information to give us an alpha2
+ * information to give us an alpha2.
+ * Protected by the cfg80211_mutex.
  */
 const struct ieee80211_regdomain *cfg80211_regdomain;
 
 /*
  * Protects static reg.c components:
  *     - cfg80211_world_regdom
- *     - cfg80211_regdom
  *     - last_request
  *     - reg_num_devs_support_basehint
  */
@@ -186,6 +186,9 @@ MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
 static void reset_regdomains(bool full_reset)
 {
+	assert_cfg80211_lock();
+	assert_reg_lock();
+
 	/* avoid freeing static information or freeing something twice */
 	if (cfg80211_regdomain == cfg80211_world_regdom)
 		cfg80211_regdomain = NULL;
@@ -216,6 +219,9 @@ static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
 	WARN_ON(!last_request);
 
+	assert_cfg80211_lock();
+	assert_reg_lock();
+
 	reset_regdomains(false);
 
 	cfg80211_world_regdom = rd;
@@ -423,8 +429,6 @@ static int call_crda(const char *alpha2)
 /* Used by nl80211 before kmalloc'ing our regulatory domain */
 bool reg_is_valid_request(const char *alpha2)
 {
-	assert_cfg80211_lock();
-
 	if (!last_request)
 		return false;
 
@@ -924,8 +928,6 @@ bool reg_last_request_cell_base(void)
 {
 	bool val;
 
-	assert_cfg80211_lock();
-
 	mutex_lock(&reg_mutex);
 	val = reg_request_cell_base(last_request);
 	mutex_unlock(&reg_mutex);
@@ -1008,8 +1010,6 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 	bool channel_changed = false;
 	struct ieee80211_channel chan_before;
 
-	assert_cfg80211_lock();
-
 	sband = wiphy->bands[reg_beacon->chan.band];
 	chan = &sband->channels[chan_idx];
 
@@ -1051,8 +1051,6 @@ static void wiphy_update_new_beacon(struct wiphy *wiphy,
 	unsigned int i;
 	struct ieee80211_supported_band *sband;
 
-	assert_cfg80211_lock();
-
 	if (!wiphy->bands[reg_beacon->chan.band])
 		return;
 
@@ -1071,8 +1069,6 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 	struct ieee80211_supported_band *sband;
 	struct reg_beacon *reg_beacon;
 
-	assert_cfg80211_lock();
-
 	list_for_each_entry(reg_beacon, &reg_beacon_list, list) {
 		if (!wiphy->bands[reg_beacon->chan.band])
 			continue;
@@ -1084,6 +1080,8 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 
 static bool reg_is_world_roaming(struct wiphy *wiphy)
 {
+	assert_cfg80211_lock();
+
 	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
 	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
 		return true;
@@ -1125,8 +1123,6 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 	struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
 	unsigned int i;
 
-	assert_cfg80211_lock();
-
 	if (!is_ht40_allowed(channel)) {
 		channel->flags |= IEEE80211_CHAN_NO_HT40;
 		return;
@@ -1189,6 +1185,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 {
 	enum ieee80211_band band;
 
+	assert_cfg80211_lock();
 	assert_reg_lock();
 
 	if (ignore_reg_update(wiphy, initiator))
@@ -1308,8 +1305,6 @@ get_reg_request_treatment(struct wiphy *wiphy,
 {
 	struct wiphy *last_wiphy = NULL;
 
-	assert_cfg80211_lock();
-
 	/* All initial requests are respected */
 	if (!last_request)
 		return REG_REQ_OK;
@@ -2255,8 +2250,6 @@ int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
-	assert_cfg80211_lock();
-
 	mutex_lock(&reg_mutex);
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
@@ -2272,8 +2265,6 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 {
 	struct wiphy *request_wiphy = NULL;
 
-	assert_cfg80211_lock();
-
 	mutex_lock(&reg_mutex);
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
-- 
1.8.0

