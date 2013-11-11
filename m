Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40773 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3KKVPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:15:39 -0500
Received: by mail-wi0-f177.google.com with SMTP id hq4so2386134wib.16
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 13:15:37 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Mihir Shete <smihir@qti.qualcomm.com>,
	Henri Bahini <hbahini@qca.qualcomm.com>,
	Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Subject: [PATCH 1/3] cfg80211: move regulatory flags to their own variable
Date: Mon, 11 Nov 2013 22:15:29 +0100
Message-Id: <1384204531-10025-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131111_221554_888390_5AA27BD9)
In-Reply-To: <1384204531-10025-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384204531-10025-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We'll expand this later, this will make it easier to
classify and review what things are related to regulatory
or not.

Coccinelle only missed 4 hits, which I had to do manually,
supplying the SmPL in case of merge conflicts.

@@
struct wiphy *wiphy;
@@
-wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY
+wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG
@@
expression e;
@@
-e->flags |= WIPHY_FLAG_CUSTOM_REGULATORY
+e->regulatory_flags |= REGULATORY_CUSTOM_REG
@@
struct wiphy *wiphy;
@@
-wiphy->flags &= ~WIPHY_FLAG_CUSTOM_REGULATORY
+wiphy->regulatory_flags &= ~REGULATORY_CUSTOM_REG
@@
struct wiphy *wiphy;
@@
-wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY
+wiphy->regulatory_flags & REGULATORY_CUSTOM_REG

@@
struct wiphy *wiphy;
@@
-wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY
+wiphy->regulatory_flags |= REGULATORY_STRICT_REG
@@
expression e;
@@
-e->flags |= WIPHY_FLAG_STRICT_REGULATORY
+e->regulatory_flags |= REGULATORY_STRICT_REG
@@
struct wiphy *wiphy;
@@
-wiphy->flags &= ~WIPHY_FLAG_STRICT_REGULATORY
+wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG
@@
struct wiphy *wiphy;
@@
-wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY
+wiphy->regulatory_flags & REGULATORY_STRICT_REG

@@
struct wiphy *wiphy;
@@
-wiphy->flags |= WIPHY_FLAG_DISABLE_BEACON_HINTS
+wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS
@@
expression e;
@@
-e->flags |= WIPHY_FLAG_DISABLE_BEACON_HINTS
+e->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS
@@
struct wiphy *wiphy;
@@
-wiphy->flags &= ~WIPHY_FLAG_DISABLE_BEACON_HINTS
+wiphy->regulatory_flags &= ~REGULATORY_DISABLE_BEACON_HINTS
@@
struct wiphy *wiphy;
@@
-wiphy->flags & WIPHY_FLAG_DISABLE_BEACON_HINTS
+wiphy->regulatory_flags & REGULATORY_DISABLE_BEACON_HINTS

Generated-by: Coccinelle SmPL
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mihir Shete <smihir@qti.qualcomm.com>
Cc: Henri Bahini <hbahini@qca.qualcomm.com>
Cc: Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c                    |  4 +--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  2 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |  4 +--
 drivers/net/wireless/iwlegacy/3945-mac.c           |  6 ++--
 drivers/net/wireless/iwlegacy/4965-mac.c           |  6 ++--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  6 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  6 ++--
 drivers/net/wireless/mac80211_hwsim.c              | 18 ++++++------
 drivers/net/wireless/mwifiex/cfg80211.c            |  5 ++--
 drivers/net/wireless/rtlwifi/regd.c                |  6 ++--
 include/net/cfg80211.h                             | 33 ++++------------------
 include/net/regulatory.h                           | 33 ++++++++++++++++++++++
 net/wireless/core.c                                |  2 +-
 net/wireless/reg.c                                 | 32 ++++++++++-----------
 14 files changed, 88 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index f629271..e557e57 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -497,7 +497,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 	const struct ieee80211_regdomain *regd;
 
 	wiphy->reg_notifier = reg_notifier;
-	wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+	wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
 
 	if (ath_is_world_regd(reg)) {
 		/*
@@ -505,7 +505,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 		 * saved on the wiphy orig_* parameters
 		 */
 		regd = ath_world_regdomain(reg);
-		wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+		wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 	} else {
 		/*
 		 * This gets applied in the case of the absence of CRDA,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b6a09f9..1850efa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4341,7 +4341,7 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	wiphy->max_remain_on_channel_duration = 5000;
 	brcmf_wiphy_pno_params(wiphy);
 	brcmf_dbg(INFO, "Registering custom regulatory\n");
-	wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
 	err = wiphy_register(wiphy);
 	if (err < 0) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 7d8f3fd..ef05df0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -766,8 +766,8 @@ void brcms_c_regd_init(struct brcms_c_info *wlc)
 	}
 
 	wlc->wiphy->reg_notifier = brcms_reg_notifier;
-	wlc->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
-			     WIPHY_FLAG_STRICT_REGULATORY;
+	wlc->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+					REGULATORY_STRICT_REG;
 	wiphy_apply_custom_regulatory(wlc->wiphy, regd->regdomain);
 	brcms_reg_apply_beaconing_flags(wiphy, NL80211_REGDOM_SET_BY_DRIVER);
 }
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index b5fc6e7..3d09981 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3575,9 +3575,9 @@ il3945_setup_mac(struct il_priv *il)
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->flags |=
-	    WIPHY_FLAG_CUSTOM_REGULATORY | WIPHY_FLAG_DISABLE_BEACON_HINTS |
-	    WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+				       REGULATORY_DISABLE_BEACON_HINTS;
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 451f597..3b731fd 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5778,9 +5778,9 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->flags |=
-	    WIPHY_FLAG_CUSTOM_REGULATORY | WIPHY_FLAG_DISABLE_BEACON_HINTS |
-	    WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+				       REGULATORY_DISABLE_BEACON_HINTS;
 
 	/*
 	 * For now, disable PS by default because it affects
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index cae4d31..217f1ca 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -155,9 +155,9 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			ARRAY_SIZE(iwlagn_iface_combinations_dualmode);
 	}
 
-	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
-			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
-			    WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+				       REGULATORY_DISABLE_BEACON_HINTS;
 
 #ifdef CONFIG_PM_SLEEP
 	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9833cdf..9cea453 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -181,9 +181,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_DEVICE);
 
-	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
-			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
-			    WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+				       REGULATORY_DISABLE_BEACON_HINTS;
 
 	hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
 	hw->wiphy->n_iface_combinations =
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8c7f4ab..6102abe 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2456,46 +2456,46 @@ static int __init init_mac80211_hwsim(void)
 			break;
 		case HWSIM_REGTEST_WORLD_ROAM:
 			if (i == 0) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+				hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_01);
 			}
 			break;
 		case HWSIM_REGTEST_CUSTOM_WORLD:
-			hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+			hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 			wiphy_apply_custom_regulatory(hw->wiphy,
 				&hwsim_world_regdom_custom_01);
 			break;
 		case HWSIM_REGTEST_CUSTOM_WORLD_2:
 			if (i == 0) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+				hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_01);
 			} else if (i == 1) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+				hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_02);
 			}
 			break;
 		case HWSIM_REGTEST_STRICT_ALL:
-			hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+			hw->wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
 			break;
 		case HWSIM_REGTEST_STRICT_FOLLOW:
 		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
 			if (i == 0)
-				hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+				hw->wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
 			break;
 		case HWSIM_REGTEST_ALL:
 			if (i == 0) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+				hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_01);
 			} else if (i == 1) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+				hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_02);
 			} else if (i == 4)
-				hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+				hw->wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
 			break;
 		default:
 			break;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7f68943..d6d1d91 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2687,9 +2687,10 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
-			WIPHY_FLAG_CUSTOM_REGULATORY |
-			WIPHY_FLAG_STRICT_REGULATORY |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	wiphy->regulatory_flags |=
+			REGULATORY_CUSTOM_REG |
+			REGULATORY_STRICT_REG;
 
 	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
 
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index 8453c53..89e3656 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -344,9 +344,9 @@ static int _rtl_regd_init_wiphy(struct rtl_regulatory *reg,
 
 	wiphy->reg_notifier = reg_notifier;
 
-	wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
-	wiphy->flags &= ~WIPHY_FLAG_STRICT_REGULATORY;
-	wiphy->flags &= ~WIPHY_FLAG_DISABLE_BEACON_HINTS;
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_DISABLE_BEACON_HINTS;
 
 	regd = _rtl_regdomain_select(reg);
 	wiphy_apply_custom_regulatory(wiphy, regd);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 968f2ad..817d813 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2437,29 +2437,6 @@ struct cfg80211_ops {
 /**
  * enum wiphy_flags - wiphy capability flags
  *
- * @WIPHY_FLAG_CUSTOM_REGULATORY:  tells us the driver for this device
- * 	has its own custom regulatory domain and cannot identify the
- * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
- * 	we will disregard the first regulatory hint (when the
- * 	initiator is %REGDOM_SET_BY_CORE). Drivers that use
- * 	wiphy_apply_custom_regulatory() should have this flag set
- * 	or the regulatory core will set it for wiphy.
- * @WIPHY_FLAG_STRICT_REGULATORY: tells us the driver for this device will
- *	ignore regulatory domain settings until it gets its own regulatory
- *	domain via its regulatory_hint() unless the regulatory hint is
- *	from a country IE. After its gets its own regulatory domain it will
- *	only allow further regulatory domain settings to further enhance
- *	compliance. For example if channel 13 and 14 are disabled by this
- *	regulatory domain no user regulatory domain can enable these channels
- *	at a later time. This can be used for devices which do not have
- *	calibration information guaranteed for frequencies or settings
- *	outside of its regulatory domain. If used in combination with
- *	WIPHY_FLAG_CUSTOM_REGULATORY the inspected country IE power settings
- *	will be followed.
- * @WIPHY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to ensure
- *	that passive scan flags and beaconing flags may not be lifted by
- *	cfg80211 due to regulatory beacon hints. For more information on beacon
- *	hints read the documenation for regulatory_hint_found_beacon()
  * @WIPHY_FLAG_NETNS_OK: if not set, do not allow changing the netns of this
  *	wiphy at all
  * @WIPHY_FLAG_PS_ON_BY_DEFAULT: if set to true, powersave will be enabled
@@ -2498,9 +2475,9 @@ struct cfg80211_ops {
  *	beaconing mode (AP, IBSS, Mesh, ...).
  */
 enum wiphy_flags {
-	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
-	WIPHY_FLAG_STRICT_REGULATORY		= BIT(1),
-	WIPHY_FLAG_DISABLE_BEACON_HINTS		= BIT(2),
+	/* use hole at 0 */
+	/* use hole at 1 */
+	/* use hole at 2 */
 	WIPHY_FLAG_NETNS_OK			= BIT(3),
 	WIPHY_FLAG_PS_ON_BY_DEFAULT		= BIT(4),
 	WIPHY_FLAG_4ADDR_AP			= BIT(5),
@@ -2722,6 +2699,8 @@ struct wiphy_coalesce_support {
  * @software_iftypes: bitmask of software interface types, these are not
  *	subject to any restrictions since they are purely managed in SW.
  * @flags: wiphy flags, see &enum wiphy_flags
+ * @regulatory_flags: wiphy regulatory flags, see
+ * 	&enum ieee80211_regulatory_flags
  * @features: features advertised to nl80211, see &enum nl80211_feature_flags.
  * @bss_priv_size: each BSS struct has private data allocated with it,
  *	this variable determines its size
@@ -2810,7 +2789,7 @@ struct wiphy {
 
 	u16 max_acl_mac_addrs;
 
-	u32 flags, features;
+	u32 flags, regulatory_flags, features;
 
 	u32 ap_sme_capa;
 
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index f17ed59..a77368c 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -86,6 +86,39 @@ struct regulatory_request {
 	struct list_head list;
 };
 
+/**
+ * enum ieee80211_regulatory_flags - device regulatory flags
+ *
+ * @REGULATORY_FLAG_CUSTOM_REG: tells us the driver for this device
+ * 	has its own custom regulatory domain and cannot identify the
+ * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
+ * 	we will disregard the first regulatory hint (when the
+ * 	initiator is %REGDOM_SET_BY_CORE). Drivers that use
+ * 	wiphy_apply_custom_regulatory() should have this flag set
+ * 	or the regulatory core will set it for the wiphy.
+ * @REGULATORY_FLAG_STRICT_REG: tells us the driver for this device will
+ *	ignore regulatory domain settings until it gets its own regulatory
+ *	domain via its regulatory_hint() unless the regulatory hint is
+ *	from a country IE. After its gets its own regulatory domain it will
+ *	only allow further regulatory domain settings to further enhance
+ *	compliance. For example if channel 13 and 14 are disabled by this
+ *	regulatory domain no user regulatory domain can enable these channels
+ *	at a later time. This can be used for devices which do not have
+ *	calibration information guaranteed for frequencies or settings
+ *	outside of its regulatory domain. If used in combination with
+ *	REGULATORY_FLAG_CUSTOM_REG the inspected country IE power settings
+ *	will be followed.
+ * @REGULATORY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to
+ *	ensure that passive scan flags and beaconing flags may not be lifted by
+ *	cfg80211 due to regulatory beacon hints. For more information on beacon
+ *	hints read the documenation for regulatory_hint_found_beacon()
+ */
+enum ieee80211_regulatory_flags {
+	REGULATORY_CUSTOM_REG			= BIT(0),
+	REGULATORY_STRICT_REG			= BIT(1),
+	REGULATORY_DISABLE_BEACON_HINTS		= BIT(2),
+};
+
 struct ieee80211_freq_range {
 	u32 start_freq_khz;
 	u32 end_freq_khz;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 93d367c..5d53e49 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -590,7 +590,7 @@ int wiphy_register(struct wiphy *wiphy)
 	if (IS_ERR(rdev->wiphy.debugfsdir))
 		rdev->wiphy.debugfsdir = NULL;
 
-	if (wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
+	if (wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
 		struct regulatory_request request;
 
 		request.wiphy_idx = get_wiphy_idx(wiphy);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a75c5ed..e44b4bb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -868,7 +868,7 @@ static void handle_channel(struct wiphy *wiphy,
 
 		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 		    request_wiphy && request_wiphy == wiphy &&
-		    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
+		    request_wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
 			REG_DBG_PRINT("Disabling freq %d MHz for good\n",
 				      chan->center_freq);
 			chan->orig_flags |= IEEE80211_CHAN_DISABLED;
@@ -895,7 +895,7 @@ static void handle_channel(struct wiphy *wiphy,
 
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
-	    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
+	    request_wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
 		/*
 		 * This guarantees the driver's requested regulatory domain
 		 * will always be used as a base for further regulatory
@@ -922,12 +922,12 @@ static void handle_channel(struct wiphy *wiphy,
 	if (chan->orig_mpwr) {
 		/*
 		 * Devices that have their own custom regulatory domain
-		 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
+		 * but also use REGULATORY_STRICT_REG will follow the
 		 * passed country IE power settings.
 		 */
 		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
-		    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+		    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG &&
+		    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
 			chan->max_power = chan->max_reg_power;
 		else
 			chan->max_power = min(chan->orig_mpwr,
@@ -997,8 +997,8 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 
 static bool wiphy_strict_alpha2_regd(struct wiphy *wiphy)
 {
-	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY &&
-	    !(wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY))
+	if (wiphy->regulatory_flags & REGULATORY_STRICT_REG &&
+	    !(wiphy->regulatory_flags & REGULATORY_CUSTOM_REG))
 		return true;
 	return false;
 }
@@ -1016,7 +1016,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	}
 
 	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
-	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
+	    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
 		REG_DBG_PRINT("Ignoring regulatory request set by %s "
 			      "since the driver uses its own custom "
 			      "regulatory domain\n",
@@ -1054,7 +1054,7 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 		return true;
 
 	if (lr && lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
+	    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG)
 		return true;
 
 	return false;
@@ -1082,7 +1082,7 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 	if (!reg_is_world_roaming(wiphy))
 		return;
 
-	if (wiphy->flags & WIPHY_FLAG_DISABLE_BEACON_HINTS)
+	if (wiphy->regulatory_flags & REGULATORY_DISABLE_BEACON_HINTS)
 		return;
 
 	chan_before.center_freq = chan->center_freq;
@@ -1242,7 +1242,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 		 * as some drivers used this to restore its orig_* reg domain.
 		 */
 		if (initiator == NL80211_REGDOM_SET_BY_CORE &&
-		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
+		    wiphy->regulatory_flags & REGULATORY_CUSTOM_REG)
 			reg_call_notifier(wiphy, lr);
 		return;
 	}
@@ -1328,9 +1328,9 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	enum ieee80211_band band;
 	unsigned int bands_set = 0;
 
-	WARN(!(wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY),
-	     "wiphy should have WIPHY_FLAG_CUSTOM_REGULATORY\n");
-	wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+	WARN(!(wiphy->regulatory_flags & REGULATORY_CUSTOM_REG),
+	     "wiphy should have REGULATORY_CUSTOM_REG\n");
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (!wiphy->bands[band])
@@ -1659,7 +1659,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 
 	/* This is required so that the orig_* parameters are saved */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
-	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+	    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
 }
 
@@ -1986,7 +1986,7 @@ static void restore_regulatory_settings(bool reset_user)
 	world_alpha2[1] = cfg80211_world_regdom->alpha2[1];
 
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
-		if (rdev->wiphy.flags & WIPHY_FLAG_CUSTOM_REGULATORY)
+		if (rdev->wiphy.regulatory_flags & REGULATORY_CUSTOM_REG)
 			restore_custom_reg_settings(&rdev->wiphy);
 	}
 
-- 
1.8.4.rc3

