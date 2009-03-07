Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45330 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZCGDNi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 22:13:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 19:13:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <j@w1.fi>, <j@w1.fi>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211_hwsim: add regulatory testing options
Date: Fri, 6 Mar 2009 19:12:55 -0800
Message-ID: <1236395575-28930-1-git-send-email-lrodriguez@atheros.com> (sfid-20090307_041342_233792_4ADA0458)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the static regulatory hint and actually moves
it to a module parameter. While at it we allow for different
regulatory testing options. If you want to test different
alpha2s just use the userspace regulatory request, this
module parameter is designed specifically to help driver
specific regulatory requests and also to help test world
roaming without any hardware.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  214 ++++++++++++++++++++++++++++++++-
 1 files changed, 209 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 395f13d..6e883d9 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -30,6 +30,112 @@ static int radios = 2;
 module_param(radios, int, 0444);
 MODULE_PARM_DESC(radios, "Number of simulated radios");
 
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
+ * @HWSIM_REGTEST_DRIVER_REG_FOLLOW: Used for testing the driver regulatory hint,
+ * 	only one driver regulatory hint will be sent as such the
+ * 	secondary radios are expected to follow.
+ * @HWSIM_REGTEST_DRIVER_REG_ALL: Used for testing the driver regulatory
+ * 	request with all radios reporting the same regulatory domain.
+ * @HWSIM_REGTEST_DIFF_COUNTRY: Used for testing the drivers calling
+ * 	different regulatory domains requests. Expected behaviour is for
+ * 	an intersection to occur but each device will still use their
+ * 	respective regulatory requested domains. Subsequent radios will
+ * 	use the resulting intersection.
+ * @HWSIM_REGTEST_WORLD_ROAM: Used for testing the world roaming. We acomplish
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
+ * @HWSIM_REGTEST_STRICT_ALL: Used for testing strict regulatory domain settings.
+ * 	All radios will adhere to this.
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
+			NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+	}
+};
+
 struct hwsim_vif_priv {
 	u32 magic;
 	u8 bssid[ETH_ALEN];
@@ -871,6 +977,64 @@ static int __init init_mac80211_hwsim(void)
 			hw->wiphy->bands[band] = sband;
 		}
 
+		/* Work to be done prior to ieee80211_register_hw() */
+		switch (regtest) {
+		case HWSIM_REGTEST_DISABLED:
+		case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
+		case HWSIM_REGTEST_DRIVER_REG_ALL:
+		case HWSIM_REGTEST_DIFF_COUNTRY:
+			/*
+			 * Nothing to be done for driver regulatory domain
+			 * hints prior to ieee80211_register_hw()
+			 */
+			break;
+		case HWSIM_REGTEST_WORLD_ROAM:
+			if (i == 0) {
+				hw->wiphy->custom_regulatory = true;
+				wiphy_apply_custom_regulatory(hw->wiphy,
+					&hwsim_world_regdom_custom_01);
+			}
+			break;
+		case HWSIM_REGTEST_CUSTOM_WORLD:
+			hw->wiphy->custom_regulatory = true;
+			wiphy_apply_custom_regulatory(hw->wiphy,
+				&hwsim_world_regdom_custom_01);
+			break;
+		case HWSIM_REGTEST_CUSTOM_WORLD_2:
+			if (i == 0) {
+				hw->wiphy->custom_regulatory = true;
+				wiphy_apply_custom_regulatory(hw->wiphy,
+					&hwsim_world_regdom_custom_01);
+			} else if (i == 1) {
+				hw->wiphy->custom_regulatory = true;
+				wiphy_apply_custom_regulatory(hw->wiphy,
+					&hwsim_world_regdom_custom_02);
+			}
+			break;
+		case HWSIM_REGTEST_STRICT_ALL:
+			hw->wiphy->strict_regulatory = true;
+			break;
+		case HWSIM_REGTEST_STRICT_FOLLOW:
+		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
+			if (i == 0)
+				hw->wiphy->strict_regulatory = true;
+			break;
+		case HWSIM_REGTEST_ALL:
+			if (i == 0) {
+				hw->wiphy->custom_regulatory = true;
+				wiphy_apply_custom_regulatory(hw->wiphy,
+					&hwsim_world_regdom_custom_01);
+			} else if (i == 1) {
+				hw->wiphy->custom_regulatory = true;
+				wiphy_apply_custom_regulatory(hw->wiphy,
+					&hwsim_world_regdom_custom_02);
+			} else if (i == 4)
+				hw->wiphy->strict_regulatory = true;
+			break;
+		default:
+			break;
+		}
+
 		err = ieee80211_register_hw(hw);
 		if (err < 0) {
 			printk(KERN_DEBUG "mac80211_hwsim: "
@@ -878,11 +1042,51 @@ static int __init init_mac80211_hwsim(void)
 			goto failed_hw;
 		}
 
-		/*
-		 * We have no EEPROM but we know ACME Inc. only sells
-		 * these in Finland.
-		 */
-		regulatory_hint(hw->wiphy, "FI");
+		/* Work to be done after to ieee80211_register_hw() */
+		switch (regtest) {
+		case HWSIM_REGTEST_WORLD_ROAM:
+		case HWSIM_REGTEST_DISABLED:
+			break;
+		case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
+			if (!i)
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+			break;
+		case HWSIM_REGTEST_DRIVER_REG_ALL:
+		case HWSIM_REGTEST_STRICT_ALL:
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+			break;
+		case HWSIM_REGTEST_DIFF_COUNTRY:
+			if (i < ARRAY_SIZE(hwsim_alpha2s))
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[i]);
+			break;
+		case HWSIM_REGTEST_CUSTOM_WORLD:
+		case HWSIM_REGTEST_CUSTOM_WORLD_2:
+			/*
+			 * Nothing to be done for custom world regulatory
+			 * domains after to ieee80211_register_hw
+			 */
+			break;
+		case HWSIM_REGTEST_STRICT_FOLLOW:
+			if (i == 0)
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+			break;
+		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
+			if (i == 0)
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+			else if (i == 1)
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[1]);
+			break;
+		case HWSIM_REGTEST_ALL:
+			if (i == 2)
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+			else if (i == 3)
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[1]);
+			else if (i == 4)
+				regulatory_hint(hw->wiphy, hwsim_alpha2s[2]);
+			break;
+		default:
+			break;
+		}
 
 		printk(KERN_DEBUG "%s: hwaddr %pM registered\n",
 		       wiphy_name(hw->wiphy),
-- 
1.6.1.2.253.ga34a

