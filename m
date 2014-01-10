Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaAJNEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 08:04:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/13] mac80211_hwsim: restore regulatory testing functionality
Date: Fri, 10 Jan 2014 13:51:10 +0100
Message-Id: <1389358270-20901-14-git-send-email-johannes@sipsolutions.net> (sfid-20140110_140454_023835_E914C639)
In-Reply-To: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
References: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Restore the original regulatory testing functionality and also
make it more flexible by allowing the parameters to be specified
when creating a dynamic radio.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 218 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   7 ++
 2 files changed, 222 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 056dae7..dc7f72e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -57,6 +57,117 @@ static bool rctbl = false;
 module_param(rctbl, bool, 0444);
 MODULE_PARM_DESC(rctbl, "Handle rate control table");
 
+/**
+ * enum hwsim_regtest - the type of regulatory tests we offer
+ *
+ * These are the different values you can use for the regtest
+ * module parameter. This is useful to help test world roaming
+ * and the driver regulatory_hint() call and combinations of these.
+ * If you want to do specific alpha2 regulatory domain tests simply
+ * use the userspace regulatory request as that will be respected as
+ * well without the need of this module parameter. This is designed
+ * only for testing the driver regulatory request, world roaming
+ * and all possible combinations.
+ *
+ * @HWSIM_REGTEST_DISABLED: No regulatory tests are performed,
+ * 	this is the default value.
+ * @HWSIM_REGTEST_DRIVER_REG_FOLLOW: Used for testing the driver regulatory
+ *	hint, only one driver regulatory hint will be sent as such the
+ * 	secondary radios are expected to follow.
+ * @HWSIM_REGTEST_DRIVER_REG_ALL: Used for testing the driver regulatory
+ * 	request with all radios reporting the same regulatory domain.
+ * @HWSIM_REGTEST_DIFF_COUNTRY: Used for testing the drivers calling
+ * 	different regulatory domains requests. Expected behaviour is for
+ * 	an intersection to occur but each device will still use their
+ * 	respective regulatory requested domains. Subsequent radios will
+ * 	use the resulting intersection.
+ * @HWSIM_REGTEST_WORLD_ROAM: Used for testing the world roaming. We accomplish
+ *	this by using a custom beacon-capable regulatory domain for the first
+ *	radio. All other device world roam.
+ * @HWSIM_REGTEST_CUSTOM_WORLD: Used for testing the custom world regulatory
+ * 	domain requests. All radios will adhere to this custom world regulatory
+ * 	domain.
+ * @HWSIM_REGTEST_CUSTOM_WORLD_2: Used for testing 2 custom world regulatory
+ * 	domain requests. The first radio will adhere to the first custom world
+ * 	regulatory domain, the second one to the second custom world regulatory
+ * 	domain. All other devices will world roam.
+ * @HWSIM_REGTEST_STRICT_FOLLOW_: Used for testing strict regulatory domain
+ *	settings, only the first radio will send a regulatory domain request
+ *	and use strict settings. The rest of the radios are expected to follow.
+ * @HWSIM_REGTEST_STRICT_ALL: Used for testing strict regulatory domain
+ *	settings. All radios will adhere to this.
+ * @HWSIM_REGTEST_STRICT_AND_DRIVER_REG: Used for testing strict regulatory
+ *	domain settings, combined with secondary driver regulatory domain
+ *	settings. The first radio will get a strict regulatory domain setting
+ *	using the first driver regulatory request and the second radio will use
+ *	non-strict settings using the second driver regulatory request. All
+ *	other devices should follow the intersection created between the
+ *	first two.
+ * @HWSIM_REGTEST_ALL: Used for testing every possible mix. You will need
+ * 	at least 6 radios for a complete test. We will test in this order:
+ * 	1 - driver custom world regulatory domain
+ * 	2 - second custom world regulatory domain
+ * 	3 - first driver regulatory domain request
+ * 	4 - second driver regulatory domain request
+ * 	5 - strict regulatory domain settings using the third driver regulatory
+ * 	    domain request
+ * 	6 and on - should follow the intersection of the 3rd, 4rth and 5th radio
+ * 	           regulatory requests.
+ */
+enum hwsim_regtest {
+	HWSIM_REGTEST_DISABLED = 0,
+	HWSIM_REGTEST_DRIVER_REG_FOLLOW = 1,
+	HWSIM_REGTEST_DRIVER_REG_ALL = 2,
+	HWSIM_REGTEST_DIFF_COUNTRY = 3,
+	HWSIM_REGTEST_WORLD_ROAM = 4,
+	HWSIM_REGTEST_CUSTOM_WORLD = 5,
+	HWSIM_REGTEST_CUSTOM_WORLD_2 = 6,
+	HWSIM_REGTEST_STRICT_FOLLOW = 7,
+	HWSIM_REGTEST_STRICT_ALL = 8,
+	HWSIM_REGTEST_STRICT_AND_DRIVER_REG = 9,
+	HWSIM_REGTEST_ALL = 10,
+};
+
+/* Set to one of the HWSIM_REGTEST_* values above */
+static int regtest = HWSIM_REGTEST_DISABLED;
+module_param(regtest, int, 0444);
+MODULE_PARM_DESC(regtest, "The type of regulatory test we want to run");
+
+static const char *hwsim_alpha2s[] = {
+	"FI",
+	"AL",
+	"US",
+	"DE",
+	"JP",
+	"AL",
+};
+
+static const struct ieee80211_regdomain hwsim_world_regdom_custom_01 = {
+	.n_reg_rules = 4,
+	.alpha2 =  "99",
+	.reg_rules = {
+		REG_RULE(2412-10, 2462+10, 40, 0, 20, 0),
+		REG_RULE(2484-10, 2484+10, 40, 0, 20, 0),
+		REG_RULE(5150-10, 5240+10, 40, 0, 30, 0),
+		REG_RULE(5745-10, 5825+10, 40, 0, 30, 0),
+	}
+};
+
+static const struct ieee80211_regdomain hwsim_world_regdom_custom_02 = {
+	.n_reg_rules = 2,
+	.alpha2 =  "99",
+	.reg_rules = {
+		REG_RULE(2412-10, 2462+10, 40, 0, 20, 0),
+		REG_RULE(5725-10, 5850+10, 40, 0, 30,
+			 NL80211_RRF_NO_IR),
+	}
+};
+
+static const struct ieee80211_regdomain *hwsim_world_regdom_custom[] = {
+	&hwsim_world_regdom_custom_01,
+	&hwsim_world_regdom_custom_02,
+};
+
 struct hwsim_vif_priv {
 	u32 magic;
 	u8 bssid[ETH_ALEN];
@@ -354,6 +465,9 @@ static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
 	[HWSIM_ATTR_CHANNELS] = { .type = NLA_U32 },
 	[HWSIM_ATTR_RADIO_ID] = { .type = NLA_U32 },
+	[HWSIM_ATTR_REG_HINT_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+	[HWSIM_ATTR_REG_CUSTOM_REG] = { .type = NLA_U32 },
+	[HWSIM_ATTR_REG_STRICT_REG] = { .type = NLA_FLAG },
 };
 
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
@@ -1820,7 +1934,9 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
-static int mac80211_hwsim_create_radio(int channels)
+static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
+				       const struct ieee80211_regdomain *regd,
+				       bool reg_strict)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2000,6 +2116,15 @@ static int mac80211_hwsim_create_radio(int channels)
 	hw->max_rates = 4;
 	hw->max_rate_tries = 11;
 
+	if (reg_strict)
+		hw->wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
+	if (regd) {
+		hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+		wiphy_apply_custom_regulatory(hw->wiphy, regd);
+		/* give the regulatory workqueue a chance to run */
+		schedule_timeout_interruptible(1);
+	}
+
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
 		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
@@ -2009,6 +2134,9 @@ static int mac80211_hwsim_create_radio(int channels)
 
 	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
+	if (reg_alpha2)
+		regulatory_hint(hw->wiphy, reg_alpha2);
+
 	data->debugfs = debugfs_create_dir("hwsim", hw->wiphy->debugfsdir);
 	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
 	debugfs_create_file("group", 0666, data->debugfs, data,
@@ -2276,11 +2404,25 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	unsigned int chans = channels;
+	const char *alpha2 = NULL;
+	const struct ieee80211_regdomain *regd = NULL;
+	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
-	return mac80211_hwsim_create_radio(chans);
+	if (info->attrs[HWSIM_ATTR_REG_HINT_ALPHA2])
+		alpha2 = nla_data(info->attrs[HWSIM_ATTR_REG_HINT_ALPHA2]);
+
+	if (info->attrs[HWSIM_ATTR_REG_CUSTOM_REG]) {
+		u32 idx = nla_get_u32(info->attrs[HWSIM_ATTR_REG_CUSTOM_REG]);
+
+		if (idx >= ARRAY_SIZE(hwsim_world_regdom_custom))
+			return -EINVAL;
+		regd = hwsim_world_regdom_custom[idx];
+	}
+
+	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2428,7 +2570,77 @@ static int __init init_mac80211_hwsim(void)
 	}
 
 	for (i = 0; i < radios; i++) {
-		err = mac80211_hwsim_create_radio(channels);
+		const char *reg_alpha2 = NULL;
+		const struct ieee80211_regdomain *regd = NULL;
+		bool reg_strict = false;
+
+		switch (regtest) {
+		case HWSIM_REGTEST_DIFF_COUNTRY:
+			if (i < ARRAY_SIZE(hwsim_alpha2s))
+				reg_alpha2 = hwsim_alpha2s[i];
+			break;
+		case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
+			if (!i)
+				reg_alpha2 = hwsim_alpha2s[0];
+			break;
+		case HWSIM_REGTEST_STRICT_ALL:
+			reg_strict = true;
+		case HWSIM_REGTEST_DRIVER_REG_ALL:
+			reg_alpha2 = hwsim_alpha2s[0];
+			break;
+		case HWSIM_REGTEST_WORLD_ROAM:
+			if (i == 0)
+				regd = &hwsim_world_regdom_custom_01;
+			break;
+		case HWSIM_REGTEST_CUSTOM_WORLD:
+			regd = &hwsim_world_regdom_custom_01;
+			break;
+		case HWSIM_REGTEST_CUSTOM_WORLD_2:
+			if (i == 0)
+				regd = &hwsim_world_regdom_custom_01;
+			else if (i == 1)
+				regd = &hwsim_world_regdom_custom_02;
+			break;
+		case HWSIM_REGTEST_STRICT_FOLLOW:
+			if (i == 0) {
+				reg_strict = true;
+				reg_alpha2 = hwsim_alpha2s[0];
+			}
+			break;
+		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
+			if (i == 0) {
+				reg_strict = true;
+				reg_alpha2 = hwsim_alpha2s[0];
+			} else if (i == 1) {
+				reg_alpha2 = hwsim_alpha2s[1];
+			}
+			break;
+		case HWSIM_REGTEST_ALL:
+			switch (i) {
+			case 0:
+				regd = &hwsim_world_regdom_custom_01;
+				break;
+			case 1:
+				regd = &hwsim_world_regdom_custom_02;
+				break;
+			case 2:
+				reg_alpha2 = hwsim_alpha2s[0];
+				break;
+			case 3:
+				reg_alpha2 = hwsim_alpha2s[1];
+				break;
+			case 4:
+				reg_strict = true;
+				reg_alpha2 = hwsim_alpha2s[2];
+				break;
+			}
+			break;
+		default:
+			break;
+		}
+
+		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
+						  regd, reg_strict);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index fb9920a..2747cce 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -103,6 +103,10 @@ enum {
  *	command giving the number of channels supported by the new radio
  * @HWSIM_ATTR_RADIO_ID: u32 attribute used with %HWSIM_CMD_DESTROY_RADIO
  *	only to destroy a radio
+ * @HWSIM_ATTR_REG_HINT_ALPHA2: alpha2 for regulatoro driver hint
+ *	(nla string, length 2)
+ * @HWSIM_ATTR_REG_CUSTOM_REG: custom regulatory domain index (u32 attribute)
+ * @HWSIM_ATTR_REG_STRICT_REG: request REGULATORY_STRICT_REG (flag attribute)
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -119,6 +123,9 @@ enum {
 	HWSIM_ATTR_COOKIE,
 	HWSIM_ATTR_CHANNELS,
 	HWSIM_ATTR_RADIO_ID,
+	HWSIM_ATTR_REG_HINT_ALPHA2,
+	HWSIM_ATTR_REG_CUSTOM_REG,
+	HWSIM_ATTR_REG_STRICT_REG,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.8.5.1

