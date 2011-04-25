Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab1DYRxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:53:46 -0400
Date: Mon, 25 Apr 2011 12:53:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/18] rtlwifi: Convert regulatory domain routines for
 addition of rtl8192se and rtl8192de
Message-ID: <4db5b514.jgBJhBBHfDQrHZtL%Larry.Finger@lwfinger.net> (sfid-20110425_195355_323536_91A63DFA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Convert regulatory domain  routines for addition of RTL8192SE and
RTL8192DE code.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 regd.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 regd.h |    3 +
 2 files changed, 80 insertions(+), 21 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/regd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/regd.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/regd.c
@@ -66,31 +66,83 @@ static struct country_code_to_enum_rd al
 	NL80211_RRF_PASSIVE_SCAN | \
 	NL80211_RRF_NO_OFDM)
 
+/* 5G chan 36 - chan 64*/
+#define RTL819x_5GHZ_5150_5350	\
+	REG_RULE(5150-10, 5350+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+/* 5G chan 100 - chan 165*/
+#define RTL819x_5GHZ_5470_5850	\
+	REG_RULE(5470-10, 5850+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+/* 5G chan 149 - chan 165*/
+#define RTL819x_5GHZ_5725_5850	\
+	REG_RULE(5725-10, 5850+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+#define RTL819x_5GHZ_ALL	\
+	(RTL819x_5GHZ_5150_5350, RTL819x_5GHZ_5470_5850)
+
 static const struct ieee80211_regdomain rtl_regdom_11 = {
 	.n_reg_rules = 1,
 	.alpha2 = "99",
 	.reg_rules = {
 		      RTL819x_2GHZ_CH01_11,
-	}
+		      }
 };
 
-static const struct ieee80211_regdomain rtl_regdom_global = {
+static const struct ieee80211_regdomain rtl_regdom_12_13 = {
+	.n_reg_rules = 2,
+	.alpha2 = "99",
+	.reg_rules = {
+		      RTL819x_2GHZ_CH01_11,
+			  RTL819x_2GHZ_CH12_13,
+		      }
+};
+
+static const struct ieee80211_regdomain rtl_regdom_no_midband = {
 	.n_reg_rules = 3,
 	.alpha2 = "99",
 	.reg_rules = {
 		      RTL819x_2GHZ_CH01_11,
-		      RTL819x_2GHZ_CH12_13,
-		      RTL819x_2GHZ_CH14,
-	}
+			  RTL819x_5GHZ_5150_5350,
+			  RTL819x_5GHZ_5725_5850,
+		      }
 };
 
-static const struct ieee80211_regdomain rtl_regdom_world = {
-	.n_reg_rules = 2,
+static const struct ieee80211_regdomain rtl_regdom_60_64 = {
+	.n_reg_rules = 3,
 	.alpha2 = "99",
 	.reg_rules = {
 		      RTL819x_2GHZ_CH01_11,
-		      RTL819x_2GHZ_CH12_13,
-	}
+			  RTL819x_2GHZ_CH12_13,
+			  RTL819x_5GHZ_5725_5850,
+		      }
+};
+
+static const struct ieee80211_regdomain rtl_regdom_14_60_64 = {
+	.n_reg_rules = 4,
+	.alpha2 = "99",
+	.reg_rules = {
+		      RTL819x_2GHZ_CH01_11,
+			  RTL819x_2GHZ_CH12_13,
+			  RTL819x_2GHZ_CH14,
+			  RTL819x_5GHZ_5725_5850,
+		      }
+};
+
+static const struct ieee80211_regdomain rtl_regdom_14 = {
+	.n_reg_rules = 3,
+	.alpha2 = "99",
+	.reg_rules = {
+		      RTL819x_2GHZ_CH01_11,
+			  RTL819x_2GHZ_CH12_13,
+			  RTL819x_2GHZ_CH14,
+		      }
 };
 
 static bool _rtl_is_radar_freq(u16 center_freq)
@@ -162,6 +214,8 @@ static void _rtl_reg_apply_active_scan_f
 	u32 bandwidth = 0;
 	int r;
 
+	if (!wiphy->bands[IEEE80211_BAND_2GHZ])
+		return;
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
 
 	/*
@@ -292,25 +346,26 @@ static const struct ieee80211_regdomain
 {
 	switch (reg->country_code) {
 	case COUNTRY_CODE_FCC:
+		return &rtl_regdom_no_midband;
 	case COUNTRY_CODE_IC:
 		return &rtl_regdom_11;
 	case COUNTRY_CODE_ETSI:
+	case COUNTRY_CODE_TELEC_NETGEAR:
+		return &rtl_regdom_60_64;
 	case COUNTRY_CODE_SPAIN:
 	case COUNTRY_CODE_FRANCE:
 	case COUNTRY_CODE_ISRAEL:
-	case COUNTRY_CODE_TELEC_NETGEAR:
-		return &rtl_regdom_world;
+	case COUNTRY_CODE_WORLD_WIDE_13:
+		return &rtl_regdom_12_13;
 	case COUNTRY_CODE_MKK:
 	case COUNTRY_CODE_MKK1:
 	case COUNTRY_CODE_TELEC:
 	case COUNTRY_CODE_MIC:
-		return &rtl_regdom_global;
+		return &rtl_regdom_14_60_64;
 	case COUNTRY_CODE_GLOBAL_DOMAIN:
-		return &rtl_regdom_global;
-	case COUNTRY_CODE_WORLD_WIDE_13:
-		return &rtl_regdom_world;
+		return &rtl_regdom_14;
 	default:
-		return &rtl_regdom_world;
+		return &rtl_regdom_no_midband;
 	}
 }
 
@@ -323,9 +378,11 @@ static int _rtl_regd_init_wiphy(struct r
 	const struct ieee80211_regdomain *regd;
 
 	wiphy->reg_notifier = reg_notifier;
+
 	wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 	wiphy->flags &= ~WIPHY_FLAG_STRICT_REGULATORY;
 	wiphy->flags &= ~WIPHY_FLAG_DISABLE_BEACON_HINTS;
+
 	regd = _rtl_regdomain_select(reg);
 	wiphy_apply_custom_regulatory(wiphy, regd);
 	_rtl_reg_apply_radar_flags(wiphy);
@@ -355,8 +412,8 @@ int rtl_regd_init(struct ieee80211_hw *h
 	if (wiphy == NULL || &rtlpriv->regd == NULL)
 		return -EINVAL;
 
-	/* force the channel plan to world wide 13 */
-	rtlpriv->regd.country_code = COUNTRY_CODE_WORLD_WIDE_13;
+	/* init country_code from efuse channel plan */
+	rtlpriv->regd.country_code = rtlpriv->efuse.channel_plan;
 
 	RT_TRACE(rtlpriv, COMP_REGD, DBG_TRACE,
 		 (KERN_DEBUG "rtl: EEPROM regdomain: 0x%0x\n",
@@ -373,8 +430,8 @@ int rtl_regd_init(struct ieee80211_hw *h
 	country = _rtl_regd_find_country(rtlpriv->regd.country_code);
 
 	if (country) {
-		rtlpriv->regd.alpha2[0] = country->isoName[0];
-		rtlpriv->regd.alpha2[1] = country->isoName[1];
+		rtlpriv->regd.alpha2[0] = country->iso_name[0];
+		rtlpriv->regd.alpha2[1] = country->iso_name[1];
 	} else {
 		rtlpriv->regd.alpha2[0] = '0';
 		rtlpriv->regd.alpha2[1] = '0';
@@ -398,3 +455,4 @@ int rtl_reg_notifier(struct wiphy *wiphy
 
 	return _rtl_reg_notifier_apply(wiphy, request, &rtlpriv->regd);
 }
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/regd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/regd.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/regd.h
@@ -32,7 +32,7 @@
 
 struct country_code_to_enum_rd {
 	u16 countrycode;
-	const char *isoName;
+	const char *iso_name;
 };
 
 enum country_code_type_t {
@@ -59,3 +59,4 @@ int rtl_regd_init(struct ieee80211_hw *h
 				       struct regulatory_request *request));
 int rtl_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
 #endif
+
