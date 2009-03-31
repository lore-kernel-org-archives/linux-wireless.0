Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/9] atheros: introduce ath module containing common ath5k/ath9k/ar9170 code
Date: Mon, 30 Mar 2009 22:30:29 -0400
Message-Id: <1238466635-23280-4-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043048_306169_E26302F2)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

This change creates a new module, ath.ko, which includes code that can
be shared between ath5k, ath9k and ar9170. For now, extract most of the ath9k
regulatory code so it can also be used in ath5k.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig                      |    1 +
 drivers/net/wireless/Makefile                     |    1 +
 drivers/net/wireless/ath/Kconfig                  |    4 +
 drivers/net/wireless/ath/Makefile                 |    3 +
 drivers/net/wireless/{ath9k => ath}/regd.c        |  154 ++++++++++-----------
 drivers/net/wireless/{ath9k => ath}/regd.h        |   48 +++++--
 drivers/net/wireless/{ath9k => ath}/regd_common.h |    0
 drivers/net/wireless/ath9k/Kconfig                |    1 +
 drivers/net/wireless/ath9k/Makefile               |    1 -
 drivers/net/wireless/ath9k/eeprom.h               |    2 +
 drivers/net/wireless/ath9k/hw.c                   |   15 ++
 drivers/net/wireless/ath9k/hw.h                   |    5 +-
 drivers/net/wireless/ath9k/main.c                 |   31 +++--
 13 files changed, 155 insertions(+), 111 deletions(-)
 create mode 100644 drivers/net/wireless/ath/Kconfig
 create mode 100644 drivers/net/wireless/ath/Makefile
 rename drivers/net/wireless/{ath9k => ath}/regd.c (75%)
 rename drivers/net/wireless/{ath9k => ath}/regd.h (81%)
 rename drivers/net/wireless/{ath9k => ath}/regd_common.h (100%)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8a08235..9e2c7e2 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -483,6 +483,7 @@ config MWL8K
 	  will be called mwl8k.  If unsure, say N.
 
 source "drivers/net/wireless/p54/Kconfig"
+source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/ath5k/Kconfig"
 source "drivers/net/wireless/ath9k/Kconfig"
 source "drivers/net/wireless/ar9170/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 50e7fba..104639e 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_RT2X00)	+= rt2x00/
 
 obj-$(CONFIG_P54_COMMON)	+= p54/
 
+obj-$(CONFIG_ATH_COMMON)	+= ath/
 obj-$(CONFIG_ATH5K)	+= ath5k/
 obj-$(CONFIG_ATH9K)	+= ath9k/
 obj-$(CONFIG_AR9170_USB)	+= ar9170/
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
new file mode 100644
index 0000000..c2873a2
--- /dev/null
+++ b/drivers/net/wireless/ath/Kconfig
@@ -0,0 +1,4 @@
+config ATH_COMMON
+	tristate "Atheros Wireless Cards Shared Support"
+	depends on ATH5K || ATH9K
+
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
new file mode 100644
index 0000000..bc77646
--- /dev/null
+++ b/drivers/net/wireless/ath/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_ATH_COMMON)	+= ath.o
+ath-objs 		:= regd.o
+
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath/regd.c
similarity index 75%
rename from drivers/net/wireless/ath9k/regd.c
rename to drivers/net/wireless/ath/regd.c
index 7eaa59e..4d3935b 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -16,8 +16,10 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
 #include <net/wireless.h>
-#include "ath9k.h"
+#include "regd.h"
 #include "regd_common.h"
 
 /*
@@ -56,7 +58,7 @@
 
 /* Can be used for:
  * 0x60, 0x61, 0x62 */
-static const struct ieee80211_regdomain ath9k_world_regdom_60_61_62 = {
+static const struct ieee80211_regdomain ath_world_regdom_60_61_62 = {
 	.n_reg_rules = 5,
 	.alpha2 =  "99",
 	.reg_rules = {
@@ -66,7 +68,7 @@ static const struct ieee80211_regdomain ath9k_world_regdom_60_61_62 = {
 };
 
 /* Can be used by 0x63 and 0x65 */
-static const struct ieee80211_regdomain ath9k_world_regdom_63_65 = {
+static const struct ieee80211_regdomain ath_world_regdom_63_65 = {
 	.n_reg_rules = 4,
 	.alpha2 =  "99",
 	.reg_rules = {
@@ -77,7 +79,7 @@ static const struct ieee80211_regdomain ath9k_world_regdom_63_65 = {
 };
 
 /* Can be used by 0x64 only */
-static const struct ieee80211_regdomain ath9k_world_regdom_64 = {
+static const struct ieee80211_regdomain ath_world_regdom_64 = {
 	.n_reg_rules = 3,
 	.alpha2 =  "99",
 	.reg_rules = {
@@ -87,7 +89,7 @@ static const struct ieee80211_regdomain ath9k_world_regdom_64 = {
 };
 
 /* Can be used by 0x66 and 0x69 */
-static const struct ieee80211_regdomain ath9k_world_regdom_66_69 = {
+static const struct ieee80211_regdomain ath_world_regdom_66_69 = {
 	.n_reg_rules = 3,
 	.alpha2 =  "99",
 	.reg_rules = {
@@ -97,7 +99,7 @@ static const struct ieee80211_regdomain ath9k_world_regdom_66_69 = {
 };
 
 /* Can be used by 0x67, 0x6A and 0x68 */
-static const struct ieee80211_regdomain ath9k_world_regdom_67_68_6A = {
+static const struct ieee80211_regdomain ath_world_regdom_67_68_6A = {
 	.n_reg_rules = 4,
 	.alpha2 =  "99",
 	.reg_rules = {
@@ -113,50 +115,53 @@ static inline bool is_wwr_sku(u16 regd)
 		(regd == WORLD);
 }
 
-static u16 ath9k_regd_get_eepromRD(struct ath9k_regulatory *reg)
+static u16 ath_regd_get_eepromRD(struct ath_regulatory *reg)
 {
 	return reg->current_rd & ~WORLDWIDE_ROAMING_FLAG;
 }
 
-bool ath9k_is_world_regd(struct ath9k_regulatory *reg)
+bool ath_is_world_regd(struct ath_regulatory *reg)
 {
-	return is_wwr_sku(ath9k_regd_get_eepromRD(reg));
+	return is_wwr_sku(ath_regd_get_eepromRD(reg));
 }
+EXPORT_SYMBOL(ath_is_world_regd);
 
-const struct ieee80211_regdomain *ath9k_default_world_regdomain(void)
+const struct ieee80211_regdomain *ath_default_world_regdomain(void)
 {
 	/* this is the most restrictive */
-	return &ath9k_world_regdom_64;
+	return &ath_world_regdom_64;
 }
+EXPORT_SYMBOL(ath_default_world_regdomain);
 
 const struct
-ieee80211_regdomain *ath9k_world_regdomain(struct ath9k_regulatory *reg)
+ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg)
 {
 	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
 	case 0x61:
 	case 0x62:
-		return &ath9k_world_regdom_60_61_62;
+		return &ath_world_regdom_60_61_62;
 	case 0x63:
 	case 0x65:
-		return &ath9k_world_regdom_63_65;
+		return &ath_world_regdom_63_65;
 	case 0x64:
-		return &ath9k_world_regdom_64;
+		return &ath_world_regdom_64;
 	case 0x66:
 	case 0x69:
-		return &ath9k_world_regdom_66_69;
+		return &ath_world_regdom_66_69;
 	case 0x67:
 	case 0x68:
 	case 0x6A:
-		return &ath9k_world_regdom_67_68_6A;
+		return &ath_world_regdom_67_68_6A;
 	default:
 		WARN_ON(1);
-		return ath9k_default_world_regdomain();
+		return ath_default_world_regdomain();
 	}
 }
+EXPORT_SYMBOL(ath_world_regdomain);
 
 /* Frequency is one where radar detection is required */
-static bool ath9k_is_radar_freq(u16 center_freq)
+static bool ath_is_radar_freq(u16 center_freq)
 {
 	return (center_freq >= 5260 && center_freq <= 5700);
 }
@@ -170,7 +175,7 @@ static bool ath9k_is_radar_freq(u16 center_freq)
  *   received a beacon on a channel we can enable active scan and
  *   adhoc (or beaconing).
  */
-static void ath9k_reg_apply_beaconing_flags(
+static void ath_reg_apply_beaconing_flags(
 	struct wiphy *wiphy,
 	enum nl80211_reg_initiator initiator)
 {
@@ -193,7 +198,7 @@ static void ath9k_reg_apply_beaconing_flags(
 
 			ch = &sband->channels[i];
 
-			if (ath9k_is_radar_freq(ch->center_freq) ||
+			if (ath_is_radar_freq(ch->center_freq) ||
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 
@@ -229,7 +234,7 @@ static void ath9k_reg_apply_beaconing_flags(
 }
 
 /* Allows active scan scan on Ch 12 and 13 */
-static void ath9k_reg_apply_active_scan_flags(
+static void ath_reg_apply_active_scan_flags(
 	struct wiphy *wiphy,
 	enum nl80211_reg_initiator initiator)
 {
@@ -280,7 +285,7 @@ static void ath9k_reg_apply_active_scan_flags(
 }
 
 /* Always apply Radar/DFS rules on freq range 5260 MHz - 5700 MHz */
-void ath9k_reg_apply_radar_flags(struct wiphy *wiphy)
+void ath_reg_apply_radar_flags(struct wiphy *wiphy)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
@@ -293,7 +298,7 @@ void ath9k_reg_apply_radar_flags(struct wiphy *wiphy)
 
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
-		if (!ath9k_is_radar_freq(ch->center_freq))
+		if (!ath_is_radar_freq(ch->center_freq))
 			continue;
 		/* We always enable radar detection/DFS on this
 		 * frequency range. Additionally we also apply on
@@ -311,31 +316,33 @@ void ath9k_reg_apply_radar_flags(struct wiphy *wiphy)
 				     IEEE80211_CHAN_PASSIVE_SCAN;
 	}
 }
+EXPORT_SYMBOL(ath_reg_apply_radar_flags);
 
-void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
-				 enum nl80211_reg_initiator initiator,
-				 struct ath9k_regulatory *reg)
+void ath_reg_apply_world_flags(struct wiphy *wiphy,
+			       enum nl80211_reg_initiator initiator,
+			       struct ath_regulatory *reg)
 {
 	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
 	case 0x63:
 	case 0x66:
 	case 0x67:
-		ath9k_reg_apply_beaconing_flags(wiphy, initiator);
+		ath_reg_apply_beaconing_flags(wiphy, initiator);
 		break;
 	case 0x68:
-		ath9k_reg_apply_beaconing_flags(wiphy, initiator);
-		ath9k_reg_apply_active_scan_flags(wiphy, initiator);
+		ath_reg_apply_beaconing_flags(wiphy, initiator);
+		ath_reg_apply_active_scan_flags(wiphy, initiator);
 		break;
 	}
 	return;
 }
+EXPORT_SYMBOL(ath_reg_apply_world_flags);
 
-static int ath9k_reg_notifier_apply(struct wiphy *wiphy,
-	struct regulatory_request *request, struct ath9k_regulatory *reg)
+int ath_reg_notifier_apply(struct wiphy *wiphy,
+	struct regulatory_request *request, struct ath_regulatory *reg)
 {
 	/* We always apply this */
-	ath9k_reg_apply_radar_flags(wiphy);
+	ath_reg_apply_radar_flags(wiphy);
 
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_DRIVER:
@@ -343,28 +350,19 @@ static int ath9k_reg_notifier_apply(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_USER:
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		if (ath9k_is_world_regd(reg))
-			ath9k_reg_apply_world_flags(wiphy, request->initiator,
-						    reg);
+		if (ath_is_world_regd(reg))
+			ath_reg_apply_world_flags(wiphy, request->initiator,
+						  reg);
 		break;
 	}
 
 	return 0;
 }
+EXPORT_SYMBOL(ath_reg_notifier_apply);
 
-int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg)
 {
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath9k_regulatory *reg = &sc->sc_ah->regulatory;
-
-	return ath9k_reg_notifier_apply(wiphy, request, reg);
-}
-
-bool ath9k_regd_is_eeprom_valid(struct ath9k_regulatory *reg)
-{
-	 u16 rd = ath9k_regd_get_eepromRD(reg);
+	 u16 rd = ath_regd_get_eepromRD(reg);
 	int i;
 
 	if (rd & COUNTRY_ERD_FLAG) {
@@ -380,13 +378,14 @@ bool ath9k_regd_is_eeprom_valid(struct ath9k_regulatory *reg)
 				return true;
 	}
 	printk(KERN_DEBUG
-		 "ath9k: invalid regulatory domain/country code 0x%x\n", rd);
+		 "ath: invalid regulatory domain/country code 0x%x\n", rd);
 	return false;
 }
+EXPORT_SYMBOL(ath_regd_is_eeprom_valid);
 
 /* EEPROM country code to regpair mapping */
 static struct country_code_to_enum_rd*
-ath9k_regd_find_country(u16 countryCode)
+ath_regd_find_country(u16 countryCode)
 {
 	int i;
 
@@ -399,7 +398,7 @@ ath9k_regd_find_country(u16 countryCode)
 
 /* EEPROM rd code to regpair mapping */
 static struct country_code_to_enum_rd*
-ath9k_regd_find_country_by_rd(int regdmn)
+ath_regd_find_country_by_rd(int regdmn)
 {
 	int i;
 
@@ -411,13 +410,13 @@ ath9k_regd_find_country_by_rd(int regdmn)
 }
 
 /* Returns the map of the EEPROM set RD to a country code */
-static u16 ath9k_regd_get_default_country(u16 rd)
+static u16 ath_regd_get_default_country(u16 rd)
 {
 	if (rd & COUNTRY_ERD_FLAG) {
 		struct country_code_to_enum_rd *country = NULL;
 		u16 cc = rd & ~COUNTRY_ERD_FLAG;
 
-		country = ath9k_regd_find_country(cc);
+		country = ath_regd_find_country(cc);
 		if (country != NULL)
 			return cc;
 	}
@@ -426,7 +425,7 @@ static u16 ath9k_regd_get_default_country(u16 rd)
 }
 
 static struct reg_dmn_pair_mapping*
-ath9k_get_regpair(int regdmn)
+ath_get_regpair(int regdmn)
 {
 	int i;
 
@@ -439,18 +438,18 @@ ath9k_get_regpair(int regdmn)
 	return NULL;
 }
 
-int ath9k_regd_init(struct ath9k_regulatory *reg)
+int ath_regd_init(struct ath_regulatory *reg)
 {
 	struct country_code_to_enum_rd *country = NULL;
 	u16 regdmn;
 
-	if (!ath9k_regd_is_eeprom_valid(reg)) {
-		printk(KERN_DEBUG "ath9k: Invalid EEPROM contents\n");
+	if (!ath_regd_is_eeprom_valid(reg)) {
+		printk(KERN_DEBUG "ath: Invalid EEPROM contents\n");
 		return -EINVAL;
 	}
 
-	regdmn = ath9k_regd_get_eepromRD(reg);
-	reg->country_code = ath9k_regd_get_default_country(regdmn);
+	regdmn = ath_regd_get_eepromRD(reg);
+	reg->country_code = ath_regd_get_default_country(regdmn);
 
 	if (reg->country_code == CTRY_DEFAULT &&
 	    regdmn == CTRY_DEFAULT)
@@ -459,26 +458,26 @@ int ath9k_regd_init(struct ath9k_regulatory *reg)
 	if (reg->country_code == CTRY_DEFAULT) {
 		country = NULL;
 	} else {
-		country = ath9k_regd_find_country(reg->country_code);
+		country = ath_regd_find_country(reg->country_code);
 		if (country == NULL) {
 			printk(KERN_DEBUG
-				"ath9k: Country is NULL!!!!, cc= %d\n",
+				"ath: Country is NULL!!!!, cc= %d\n",
 				reg->country_code);
 			return -EINVAL;
 		} else
 			regdmn = country->regDmnEnum;
 	}
 
-	reg->regpair = ath9k_get_regpair(regdmn);
+	reg->regpair = ath_get_regpair(regdmn);
 
 	if (!reg->regpair) {
-		printk(KERN_DEBUG "ath9k: "
+		printk(KERN_DEBUG "ath: "
 			"No regulatory domain pair found, cannot continue\n");
 		return -EINVAL;
 	}
 
 	if (!country)
-		country = ath9k_regd_find_country_by_rd(regdmn);
+		country = ath_regd_find_country_by_rd(regdmn);
 
 	if (country) {
 		reg->alpha2[0] = country->isoName[0];
@@ -488,21 +487,21 @@ int ath9k_regd_init(struct ath9k_regulatory *reg)
 		reg->alpha2[1] = '0';
 	}
 
-	printk(KERN_DEBUG "ath9k: Country alpha2 being used: %c%c\n",
+	printk(KERN_DEBUG "ath: Country alpha2 being used: %c%c\n",
 		reg->alpha2[0], reg->alpha2[1]);
-	printk(KERN_DEBUG "ath9k: Regpair detected: 0x%0x\n",
+	printk(KERN_DEBUG "ath: Regpair detected: 0x%0x\n",
 		reg->regpair->regDmnEnum);
 
 	return 0;
 }
+EXPORT_SYMBOL(ath_regd_init);
 
-static
-u32 ath9k_regd_get_band_ctl(struct ath9k_regulatory *reg,
-	enum ieee80211_band band)
+u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
+			  enum ieee80211_band band)
 {
 	if (!reg->regpair ||
 	    (reg->country_code == CTRY_DEFAULT &&
-	     is_wwr_sku(ath9k_regd_get_eepromRD(reg)))) {
+	     is_wwr_sku(ath_regd_get_eepromRD(reg)))) {
 		return SD_NO_CTL;
 	}
 
@@ -517,17 +516,4 @@ u32 ath9k_regd_get_band_ctl(struct ath9k_regulatory *reg,
 
 	return NO_CTL;
 }
-
-u32 ath9k_regd_get_ctl(struct ath9k_regulatory *reg, struct ath9k_channel *chan)
-{
-	u32 ctl = ath9k_regd_get_band_ctl(reg, chan->chan->band);
-
-	if (IS_CHAN_B(chan))
-		ctl |= CTL_11B;
-	else if (IS_CHAN_G(chan))
-		ctl |= CTL_11G;
-	else
-		ctl |= CTL_11A;
-
-	return ctl;
-}
+EXPORT_SYMBOL(ath_regd_get_band_ctl);
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath/regd.h
similarity index 81%
rename from drivers/net/wireless/ath9k/regd.h
rename to drivers/net/wireless/ath/regd.h
index 61fa42e..981f5cf 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -19,6 +19,24 @@
 
 #include <linux/nl80211.h>
 
+#include <net/cfg80211.h>
+#include <net/wireless.h>
+
+#define NO_CTL 0xff
+#define SD_NO_CTL               0xE0
+#define NO_CTL                  0xff
+#define CTL_MODE_M              7
+#define CTL_11A                 0
+#define CTL_11B                 1
+#define CTL_11G                 2
+#define CTL_2GHT20              5
+#define CTL_5GHT20              6
+#define CTL_2GHT40              7
+#define CTL_5GHT40              8
+
+#define CTRY_DEBUG 0x1ff
+#define CTRY_DEFAULT 0
+
 #define COUNTRY_ERD_FLAG        0x8000
 #define WORLDWIDE_ROAMING_FLAG  0x4000
 
@@ -42,7 +60,7 @@ struct country_code_to_enum_rd {
 	const char *isoName;
 };
 
-struct ath9k_regulatory {
+struct ath_regulatory {
 	char alpha2[2];
 	u16 country_code;
 	u16 max_power_level;
@@ -235,18 +253,20 @@ enum CountryCode {
 	CTRY_BELGIUM2 = 5002
 };
 
-bool ath9k_is_world_regd(struct ath9k_regulatory *reg);
-const struct ieee80211_regdomain *ath9k_world_regdomain(
-				 struct ath9k_regulatory *reg);
-const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
-void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
-				 enum nl80211_reg_initiator,
-				 struct ath9k_regulatory *reg);
-void ath9k_reg_apply_radar_flags(struct wiphy *wiphy);
-int ath9k_regd_init(struct ath9k_regulatory *reg);
-bool ath9k_regd_is_eeprom_valid(struct ath9k_regulatory *reg);
-u32 ath9k_regd_get_ctl(struct ath9k_regulatory *reg,
-		       struct ath9k_channel *chan);
-int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
+bool ath_is_world_regd(struct ath_regulatory *reg);
+const
+struct ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg);
+const struct ieee80211_regdomain *ath_default_world_regdomain(void);
+void ath_reg_apply_world_flags(struct wiphy *wiphy,
+			       enum nl80211_reg_initiator,
+			       struct ath_regulatory *reg);
+void ath_reg_apply_radar_flags(struct wiphy *wiphy);
+int ath_regd_init(struct ath_regulatory *reg);
+bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg);
+u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
+			  enum ieee80211_band band);
+int ath_reg_notifier_apply(struct wiphy *wiphy,
+			   struct regulatory_request *request,
+			   struct ath_regulatory *reg);
 
 #endif
diff --git a/drivers/net/wireless/ath9k/regd_common.h b/drivers/net/wireless/ath/regd_common.h
similarity index 100%
rename from drivers/net/wireless/ath9k/regd_common.h
rename to drivers/net/wireless/ath/regd_common.h
diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
index 90a8dd8..0ed1ac3 100644
--- a/drivers/net/wireless/ath9k/Kconfig
+++ b/drivers/net/wireless/ath9k/Kconfig
@@ -2,6 +2,7 @@ config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
 	depends on RFKILL || RFKILL=n
+	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/ath9k/Makefile b/drivers/net/wireless/ath9k/Makefile
index 1a4d4ea..783bc39 100644
--- a/drivers/net/wireless/ath9k/Makefile
+++ b/drivers/net/wireless/ath9k/Makefile
@@ -4,7 +4,6 @@ ath9k-y +=	hw.o \
 		calib.o \
 		ani.o \
 		phy.o \
-		regd.o \
 		beacon.o \
 		main.o \
 		recv.o \
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 25b68c8..9a7715d 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -17,6 +17,8 @@
 #ifndef EEPROM_H
 #define EEPROM_H
 
+#include <net/wireless.h>
+
 #define AH_USE_EEPROM   0x1
 
 #ifdef __BIG_ENDIAN
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index a8465bb..24299e6 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1220,6 +1220,21 @@ static void ath9k_olc_init(struct ath_hw *ah)
 	ah->PDADCdelta = 0;
 }
 
+static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
+			      struct ath9k_channel *chan)
+{
+	u32 ctl = ath_regd_get_band_ctl(reg, chan->chan->band);
+
+	if (IS_CHAN_B(chan))
+		ctl |= CTL_11B;
+	else if (IS_CHAN_G(chan))
+		ctl |= CTL_11G;
+	else
+		ctl |= CTL_11A;
+
+	return ctl;
+}
+
 static int ath9k_hw_process_ini(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				enum ath9k_ht_macmode macmode)
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 5a1128d..984ac7d 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -25,10 +25,11 @@
 #include "ani.h"
 #include "eeprom.h"
 #include "calib.h"
-#include "regd.h"
 #include "reg.h"
 #include "phy.h"
 
+#include "../ath/regd.h"
+
 #define ATHEROS_VENDOR_ID	0x168c
 #define AR5416_DEVID_PCI	0x0023
 #define AR5416_DEVID_PCIE	0x0024
@@ -404,7 +405,7 @@ struct ath_hw {
 	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config config;
 	struct ath9k_hw_capabilities caps;
-	struct ath9k_regulatory regulatory;
+	struct ath_regulatory regulatory;
 	struct ath9k_channel channels[38];
 	struct ath9k_channel *curchan;
 
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index aef033b..4cc82ec 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1407,7 +1407,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (ath9k_regd_init(&sc->sc_ah->regulatory))
+	if (ath_regd_init(&sc->sc_ah->regulatory))
 		goto bad;
 
 	/* default to MONITOR mode */
@@ -1571,6 +1571,17 @@ bad:
 	return error;
 }
 
+static int ath9k_reg_notifier(struct wiphy *wiphy,
+			      struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_regulatory *reg = &sc->sc_ah->regulatory;
+
+	return ath_reg_notifier_apply(wiphy, request, reg);
+}
+
 void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
@@ -1615,7 +1626,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	struct ieee80211_hw *hw = sc->hw;
 	const struct ieee80211_regdomain *regd;
 	int error = 0, i;
-	struct ath9k_regulatory *reg;
+	struct ath_regulatory *reg;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
 
@@ -1657,23 +1668,23 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 		goto error_attach;
 #endif
 
-	if (ath9k_is_world_regd(reg)) {
+	if (ath_is_world_regd(reg)) {
 		/* Anything applied here (prior to wiphy registration) gets
 		 * saved on the wiphy orig_* parameters */
-		regd = ath9k_world_regdomain(reg);
+		regd = ath_world_regdomain(reg);
 		hw->wiphy->custom_regulatory = true;
 		hw->wiphy->strict_regulatory = false;
 	} else {
 		/* This gets applied in the case of the absense of CRDA,
 		 * it's our own custom world regulatory domain, similar to
 		 * cfg80211's but we enable passive scanning */
-		regd = ath9k_default_world_regdomain();
+		regd = ath_default_world_regdomain();
 	}
 	wiphy_apply_custom_regulatory(hw->wiphy, regd);
-	ath9k_reg_apply_radar_flags(hw->wiphy);
-	ath9k_reg_apply_world_flags(hw->wiphy,
-				    NL80211_REGDOM_SET_BY_DRIVER,
-				    reg);
+	ath_reg_apply_radar_flags(hw->wiphy);
+	ath_reg_apply_world_flags(hw->wiphy,
+				  NL80211_REGDOM_SET_BY_DRIVER,
+				  reg);
 
 	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
 	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
@@ -1681,7 +1692,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	error = ieee80211_register_hw(hw);
 
-	if (!ath9k_is_world_regd(reg)) {
+	if (!ath_is_world_regd(reg)) {
 		error = regulatory_hint(hw->wiphy, reg->alpha2);
 		if (error)
 			goto error_attach;
-- 
1.6.0.6

