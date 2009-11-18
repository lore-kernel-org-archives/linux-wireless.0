Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbZKSADj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 19:03:39 -0500
Message-Id: <20091118235737.440705166@sipsolutions.net>
Date: Thu, 19 Nov 2009 00:56:28 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: [PATCH 1/3] cfg80211: convert bools into flags
References: <20091118235627.209099206@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've accumulated a number of options for wiphys
which make more sense as flags as we keep adding
more. Convert the existing ones.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/regd.c             |    5 --
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 --
 drivers/net/wireless/mac80211_hwsim.c       |   18 ++++----
 drivers/net/wireless/p54/main.c             |    2 
 include/net/cfg80211.h                      |   62 +++++++++++++++-------------
 net/mac80211/main.c                         |    2 
 net/wireless/Kconfig                        |    6 --
 net/wireless/core.c                         |   13 ++++-
 net/wireless/nl80211.c                      |    2 
 net/wireless/reg.c                          |   13 +++--
 11 files changed, 70 insertions(+), 67 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-11-18 23:02:38.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-11-18 23:27:51.000000000 +0100
@@ -1108,27 +1108,45 @@ struct cfg80211_ops {
  */
 
 /**
- * struct wiphy - wireless hardware description
- * @idx: the wiphy index assigned to this item
- * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
- * @custom_regulatory: tells us the driver for this device
+ * enum wiphy_flags - wiphy capability flags
+ *
+ * @WIPHY_FLAG_CUSTOM_REGULATORY:  tells us the driver for this device
  * 	has its own custom regulatory domain and cannot identify the
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
  * 	we will disregard the first regulatory hint (when the
  * 	initiator is %REGDOM_SET_BY_CORE).
- * @strict_regulatory: tells us the driver for this device will ignore
- * 	regulatory domain settings until it gets its own regulatory domain
- * 	via its regulatory_hint(). After its gets its own regulatory domain
- * 	it will only allow further regulatory domain settings to further
- * 	enhance compliance. For example if channel 13 and 14 are disabled
- * 	by this regulatory domain no user regulatory domain can enable these
- * 	channels at a later time. This can be used for devices which do not
- * 	have calibration information gauranteed for frequencies or settings
- * 	outside of its regulatory domain.
- * @disable_beacon_hints: enable this if your driver needs to ensure that
- *	passive scan flags and beaconing flags may not be lifted by cfg80211
- *	due to regulatory beacon hints. For more information on beacon
+ * @WIPHY_FLAG_STRICT_REGULATORY: tells us the driver for this device will
+ *	ignore regulatory domain settings until it gets its own regulatory
+ *	domain via its regulatory_hint(). After its gets its own regulatory
+ *	domain it will only allow further regulatory domain settings to
+ *	further enhance compliance. For example if channel 13 and 14 are
+ *	disabled by this regulatory domain no user regulatory domain can
+ *	enable these channels at a later time. This can be used for devices
+ *	which do not have calibration information gauranteed for frequencies
+ *	or settings outside of its regulatory domain.
+ * @WIPHY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to ensure
+ *	that passive scan flags and beaconing flags may not be lifted by
+ *	cfg80211 due to regulatory beacon hints. For more information on beacon
  *	hints read the documenation for regulatory_hint_found_beacon()
+ * @WIPHY_FLAG_NETNS_OK: if not set, do not allow changing the netns of this
+ *	wiphy at all
+ * @WIPHY_FLAG_PS_ON_BY_DEFAULT: if set to true, powersave will be enabled
+ *	by default -- this flag will be set depending on the kernel's default
+ *	on wiphy_new(), but can be changed by the driver if it has a good
+ *	reason to override the default
+ */
+enum wiphy_flags {
+	WIPHY_FLAG_CUSTOM_REGULATORY	= BIT(0),
+	WIPHY_FLAG_STRICT_REGULATORY	= BIT(1),
+	WIPHY_FLAG_DISABLE_BEACON_HINTS	= BIT(2),
+	WIPHY_FLAG_NETNS_OK		= BIT(3),
+	WIPHY_FLAG_PS_ON_BY_DEFAULT	= BIT(4),
+};
+
+/**
+ * struct wiphy - wireless hardware description
+ * @idx: the wiphy index assigned to this item
+ * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
  * @reg_notifier: the driver's regulatory notification callback
  * @regd: the driver's regulatory domain, if one was requested via
  * 	the regulatory_hint() API. This can be used by the driver
@@ -1143,11 +1161,6 @@ struct cfg80211_ops {
  *	-1 = fragmentation disabled, only odd values >= 256 used
  * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
  * @net: the network namespace this wiphy currently lives in
- * @netnsok: if set to false, do not allow changing the netns of this
- *	wiphy at all
- * @ps_default: default for powersave, will be set depending on the
- *	kernel's default on wiphy_new(), but can be changed by the
- *	driver if it has a good reason to override the default
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1158,12 +1171,7 @@ struct wiphy {
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
 
-	bool custom_regulatory;
-	bool strict_regulatory;
-	bool disable_beacon_hints;
-
-	bool netnsok;
-	bool ps_default;
+	u32 flags;
 
 	enum cfg80211_signal_type signal_type;
 
--- wireless-testing.orig/net/wireless/Kconfig	2009-11-18 23:09:26.000000000 +0100
+++ wireless-testing/net/wireless/Kconfig	2009-11-18 23:10:12.000000000 +0100
@@ -74,12 +74,6 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
-config CFG80211_DEFAULT_PS_VALUE
-	int
-	default 1 if CFG80211_DEFAULT_PS
-	default 0
-	depends on CFG80211
-
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
--- wireless-testing.orig/net/wireless/core.c	2009-11-18 23:08:48.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2009-11-18 23:11:05.000000000 +0100
@@ -231,7 +231,7 @@ int cfg80211_switch_netns(struct cfg8021
 	struct wireless_dev *wdev;
 	int err = 0;
 
-	if (!rdev->wiphy.netnsok)
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK))
 		return -EOPNOTSUPP;
 
 	list_for_each_entry(wdev, &rdev->netdev_list, list) {
@@ -368,7 +368,9 @@ struct wiphy *wiphy_new(const struct cfg
 	rdev->wiphy.dev.class = &ieee80211_class;
 	rdev->wiphy.dev.platform_data = rdev;
 
-	rdev->wiphy.ps_default = CONFIG_CFG80211_DEFAULT_PS_VALUE;
+#ifdef CONFIG_CFG80211_DEFAULT_PS
+	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
+#endif
 
 	wiphy_net_set(&rdev->wiphy, &init_net);
 
@@ -483,7 +485,7 @@ int wiphy_register(struct wiphy *wiphy)
 	if (IS_ERR(rdev->wiphy.debugfsdir))
 		rdev->wiphy.debugfsdir = NULL;
 
-	if (wiphy->custom_regulatory) {
+	if (wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
 		struct regulatory_request request;
 
 		request.wiphy_idx = get_wiphy_idx(wiphy);
@@ -674,7 +676,10 @@ static int cfg80211_netdev_notifier_call
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-		wdev->wext.ps = wdev->wiphy->ps_default;
+		if (wdev->wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT)
+			wdev->wext.ps = true;
+		else
+			wdev->wext.ps = false;
 		wdev->wext.ps_timeout = 100;
 		if (rdev->ops->set_power_mgmt)
 			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
--- wireless-testing.orig/net/wireless/nl80211.c	2009-11-18 23:12:55.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-11-18 23:27:51.000000000 +0100
@@ -561,7 +561,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(deauth, DEAUTHENTICATE);
 	CMD(disassoc, DISASSOCIATE);
 	CMD(join_ibss, JOIN_IBSS);
-	if (dev->wiphy.netnsok) {
+	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
 	}
--- wireless-testing.orig/net/wireless/reg.c	2009-11-18 23:11:16.000000000 +0100
+++ wireless-testing/net/wireless/reg.c	2009-11-18 23:12:44.000000000 +0100
@@ -1008,7 +1008,7 @@ static void handle_channel(struct wiphy 
 
 	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
-	    request_wiphy->strict_regulatory) {
+	    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
 		/*
 		 * This gaurantees the driver's requested regulatory domain
 		 * will always be used as a base for further regulatory
@@ -1051,13 +1051,13 @@ static bool ignore_reg_update(struct wip
 	if (!last_request)
 		return true;
 	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
-		  wiphy->custom_regulatory)
+	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
 		return true;
 	/*
 	 * wiphy->regd will be set once the device has its own
 	 * desired regulatory domain set
 	 */
-	if (wiphy->strict_regulatory && !wiphy->regd &&
+	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
 	    !is_world_regdom(last_request->alpha2))
 		return true;
 	return false;
@@ -1093,7 +1093,7 @@ static void handle_reg_beacon(struct wip
 
 	chan->beacon_found = true;
 
-	if (wiphy->disable_beacon_hints)
+	if (wiphy->flags & WIPHY_FLAG_DISABLE_BEACON_HINTS)
 		return;
 
 	chan_before.center_freq = chan->center_freq;
@@ -1164,7 +1164,7 @@ static bool reg_is_world_roaming(struct 
 		return true;
 	if (last_request &&
 	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    wiphy->custom_regulatory)
+	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY)
 		return true;
 	return false;
 }
@@ -1591,7 +1591,8 @@ static void reg_process_hint(struct regu
 
 	r = __regulatory_hint(wiphy, reg_request);
 	/* This is required so that the orig_* parameters are saved */
-	if (r == -EALREADY && wiphy && wiphy->strict_regulatory)
+	if (r == -EALREADY && wiphy &&
+	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
 out:
 	mutex_unlock(&reg_mutex);
--- wireless-testing.orig/drivers/net/wireless/ath/regd.c	2009-11-18 23:15:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/regd.c	2009-11-18 23:23:56.000000000 +0100
@@ -450,7 +450,7 @@ ath_regd_init_wiphy(struct ath_regulator
 	const struct ieee80211_regdomain *regd;
 
 	wiphy->reg_notifier = reg_notifier;
-	wiphy->strict_regulatory = true;
+	wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
 
 	if (ath_is_world_regd(reg)) {
 		/*
@@ -458,8 +458,7 @@ ath_regd_init_wiphy(struct ath_regulator
 		 * saved on the wiphy orig_* parameters
 		 */
 		regd = ath_world_regdomain(reg);
-		wiphy->custom_regulatory = true;
-		wiphy->strict_regulatory = false;
+		wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 	} else {
 		/*
 		 * This gets applied in the case of the absense of CRDA,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-18 23:15:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-11-18 23:17:26.000000000 +0100
@@ -2401,16 +2401,14 @@ static int iwl_setup_mac(struct iwl_priv
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->custom_regulatory = true;
-
-	/* Firmware does not support this */
-	hw->wiphy->disable_beacon_hints = true;
+	hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY |
+			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
 
 	/*
 	 * For now, disable PS by default because it affects
 	 * RX performance significantly.
 	 */
-	hw->wiphy->ps_default = false;
+	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 	/* we create the 802.11 header and a zero-length SSID element */
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-11-18 23:15:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-11-18 23:17:38.000000000 +0100
@@ -3905,10 +3905,8 @@ static int iwl3945_setup_mac(struct iwl_
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->custom_regulatory = true;
-
-	/* Firmware does not support this */
-	hw->wiphy->disable_beacon_hints = true;
+	hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY |
+			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;
 	/* we create the 802.11 header and a zero-length SSID element */
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-11-18 23:15:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-11-18 23:16:25.000000000 +0100
@@ -1146,46 +1146,46 @@ static int __init init_mac80211_hwsim(vo
 			break;
 		case HWSIM_REGTEST_WORLD_ROAM:
 			if (i == 0) {
-				hw->wiphy->custom_regulatory = true;
+				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_01);
 			}
 			break;
 		case HWSIM_REGTEST_CUSTOM_WORLD:
-			hw->wiphy->custom_regulatory = true;
+			hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 			wiphy_apply_custom_regulatory(hw->wiphy,
 				&hwsim_world_regdom_custom_01);
 			break;
 		case HWSIM_REGTEST_CUSTOM_WORLD_2:
 			if (i == 0) {
-				hw->wiphy->custom_regulatory = true;
+				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_01);
 			} else if (i == 1) {
-				hw->wiphy->custom_regulatory = true;
+				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_02);
 			}
 			break;
 		case HWSIM_REGTEST_STRICT_ALL:
-			hw->wiphy->strict_regulatory = true;
+			hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
 			break;
 		case HWSIM_REGTEST_STRICT_FOLLOW:
 		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
 			if (i == 0)
-				hw->wiphy->strict_regulatory = true;
+				hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
 			break;
 		case HWSIM_REGTEST_ALL:
 			if (i == 0) {
-				hw->wiphy->custom_regulatory = true;
+				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_01);
 			} else if (i == 1) {
-				hw->wiphy->custom_regulatory = true;
+				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 				wiphy_apply_custom_regulatory(hw->wiphy,
 					&hwsim_world_regdom_custom_02);
 			} else if (i == 4)
-				hw->wiphy->strict_regulatory = true;
+				hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
 			break;
 		default:
 			break;
--- wireless-testing.orig/net/mac80211/main.c	2009-11-18 23:13:50.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-18 23:14:01.000000000 +0100
@@ -664,7 +664,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	if (!wiphy)
 		return NULL;
 
-	wiphy->netnsok = true;
+	wiphy->flags |= WIPHY_FLAG_NETNS_OK;
 	wiphy->privid = mac80211_wiphy_privid;
 
 	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
--- wireless-testing.orig/drivers/net/wireless/p54/main.c	2009-11-18 23:28:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/main.c	2009-11-18 23:28:19.000000000 +0100
@@ -579,7 +579,7 @@ struct ieee80211_hw *p54_init_common(siz
 	 * For now, disable PS by default because it affects
 	 * link stability significantly.
 	 */
-	dev->wiphy->ps_default = false;
+	dev->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	mutex_init(&priv->conf_mutex);
 	mutex_init(&priv->eeprom_mutex);


