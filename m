Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945962Ab2LFQru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 16/24] regulatory: clarify locking rules and assertions
Date: Thu,  6 Dec 2012 17:47:40 +0100
Message-Id: <1354812468-15709-17-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174825_170424_4B6945B1)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Many places that currently check that cfg80211_mutex
is held don't actually use any data protected by it.
The functions that need to hold the cfg80211_mutex
are the ones using the cfg80211_regdomain variable,
so add the lock assertion to those and clarify this
in the comments.

The reason for this is that nl80211 uses the regdom
without being able to hold reg_mutex.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ab8740b..ea6f057 100644
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
 
@@ -916,8 +920,6 @@ bool reg_last_request_cell_base(void)
 {
 	bool val;
 
-	assert_cfg80211_lock();
-
 	mutex_lock(&reg_mutex);
 	val = reg_request_cell_base(last_request);
 	mutex_unlock(&reg_mutex);
@@ -1000,8 +1002,6 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 	bool channel_changed = false;
 	struct ieee80211_channel chan_before;
 
-	assert_cfg80211_lock();
-
 	sband = wiphy->bands[reg_beacon->chan.band];
 	chan = &sband->channels[chan_idx];
 
@@ -1043,8 +1043,6 @@ static void wiphy_update_new_beacon(struct wiphy *wiphy,
 	unsigned int i;
 	struct ieee80211_supported_band *sband;
 
-	assert_cfg80211_lock();
-
 	if (!wiphy->bands[reg_beacon->chan.band])
 		return;
 
@@ -1063,8 +1061,6 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 	struct ieee80211_supported_band *sband;
 	struct reg_beacon *reg_beacon;
 
-	assert_cfg80211_lock();
-
 	list_for_each_entry(reg_beacon, &reg_beacon_list, list) {
 		if (!wiphy->bands[reg_beacon->chan.band])
 			continue;
@@ -1076,6 +1072,8 @@ static void wiphy_update_beacon_reg(struct wiphy *wiphy)
 
 static bool reg_is_world_roaming(struct wiphy *wiphy)
 {
+	assert_cfg80211_lock();
+
 	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
 	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
 		return true;
@@ -1117,8 +1115,6 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 	struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
 	unsigned int i;
 
-	assert_cfg80211_lock();
-
 	if (!is_ht40_allowed(channel)) {
 		channel->flags |= IEEE80211_CHAN_NO_HT40;
 		return;
@@ -1181,6 +1177,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 {
 	enum ieee80211_band band;
 
+	assert_cfg80211_lock();
 	assert_reg_lock();
 
 	if (ignore_reg_update(wiphy, initiator))
@@ -1300,8 +1297,6 @@ get_reg_request_treatment(struct wiphy *wiphy,
 {
 	struct wiphy *last_wiphy = NULL;
 
-	assert_cfg80211_lock();
-
 	/* All initial requests are respected */
 	if (!last_request)
 		return REG_REQ_OK;
@@ -2247,8 +2242,6 @@ int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
-	assert_cfg80211_lock();
-
 	mutex_lock(&reg_mutex);
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
@@ -2264,8 +2257,6 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 {
 	struct wiphy *request_wiphy = NULL;
 
-	assert_cfg80211_lock();
-
 	mutex_lock(&reg_mutex);
 
 	if (!reg_dev_ignore_cell_hint(wiphy))
-- 
1.8.0

