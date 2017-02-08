Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39236 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932355AbdBHNAr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 08:00:47 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 15:00:34 +0200
Message-Id: <20170208130034.32007-1-luca@coelho.fi> (sfid-20170208_140111_654960_841DF533)
Subject: [PATCH] cfg80211: fix NAN bands definition
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The nl80211_nan_dual_band_conf enumeration doesn't make much sense.
The default value is assigned to a bit, which makes it weird if the
default bit and other bits are set at the same time.

To improve this, get rid of NL80211_NAN_BAND_DEFAULT and add a wiphy
configuration to let the drivers define which bands are supported.
This is exposed to the userspace, which then can make a decision on
which band(s) to use.  Additionally, rename all "dual_band" elements
to "bands", to make things clearer.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 18 ++++++++++----
 include/uapi/linux/nl80211.h | 57 ++++++++++++++++++++------------------------
 net/mac80211/cfg.c           |  4 ++--
 net/mac80211/trace.h         | 16 ++++++-------
 net/wireless/core.c          |  3 ++-
 net/wireless/nl80211.c       | 35 ++++++++++++++++++++-------
 net/wireless/trace.h         | 16 ++++++-------
 7 files changed, 86 insertions(+), 63 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a2c18b53e053..c92dc03c8528 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5,7 +5,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014 Intel Mobile Communications GmbH
- * Copyright 2015-2016	Intel Deutschland GmbH
+ * Copyright 2015-2017	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2416,11 +2416,13 @@ struct cfg80211_qos_map {
  * This struct defines NAN configuration parameters
  *
  * @master_pref: master preference (1 - 255)
- * @dual: dual band operation mode, see &enum nl80211_nan_dual_band_conf
+ * @bands: operating bands, a bitmap of &enum nl80211_band values.
+ *	For instance, for NL80211_BAND_2GHZ, bit 0 would be set
+ *	(i.e. BIT(NL80211_BAND_2GHZ)).
  */
 struct cfg80211_nan_conf {
 	u8 master_pref;
-	u8 dual;
+	u8 bands;
 };
 
 /**
@@ -2428,11 +2430,11 @@ struct cfg80211_nan_conf {
  * configuration
  *
  * @CFG80211_NAN_CONF_CHANGED_PREF: master preference
- * @CFG80211_NAN_CONF_CHANGED_DUAL: dual band operation
+ * @CFG80211_NAN_CONF_CHANGED_BANDS: operating bands
  */
 enum cfg80211_nan_conf_changes {
 	CFG80211_NAN_CONF_CHANGED_PREF = BIT(0),
-	CFG80211_NAN_CONF_CHANGED_DUAL = BIT(1),
+	CFG80211_NAN_CONF_CHANGED_BANDS = BIT(1),
 };
 
 /**
@@ -3596,6 +3598,10 @@ struct wiphy_iftype_ext_capab {
  *	attribute indices defined in &enum nl80211_bss_select_attr.
  *
  * @cookie_counter: unique generic cookie counter, used to identify objects.
+ * @nan_supported_bands: bands supported by the device in NAN mode, a
+ *	bitmap of &enum nl80211_band values.  For instance, for
+ *	NL80211_BAND_2GHZ, bit 0 would be set
+ *	(i.e. BIT(NL80211_BAND_2GHZ)).
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3727,6 +3733,8 @@ struct wiphy {
 
 	u64 cookie_counter;
 
+	u8 nan_supported_bands;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cd547b864595..5ed257c4cd4e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -10,7 +10,7 @@
  * Copyright 2008, 2009 Luis R. Rodriguez <lrodriguez@atheros.com>
  * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
  * Copyright 2008 Colin McCabe <colin@cozybit.com>
- * Copyright 2015	Intel Deutschland GmbH
+ * Copyright 2015-2017	Intel Deutschland GmbH
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -854,12 +854,15 @@
  *	cfg80211_scan_done().
  *
  * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
- *	%NL80211_ATTR_WDEV interface. This interface must have been previously
- *	created with %NL80211_CMD_NEW_INTERFACE. After it has been started, the
- *	NAN interface will create or join a cluster. This command must have a
- *	valid %NL80211_ATTR_NAN_MASTER_PREF attribute and optional
- *	%NL80211_ATTR_NAN_DUAL attributes.
- *	After this command NAN functions can be added.
+ *	%NL80211_ATTR_WDEV interface. This interface must have been
+ *	previously created with %NL80211_CMD_NEW_INTERFACE. After it
+ *	has been started, the NAN interface will create or join a
+ *	cluster. This command must have a valid
+ *	%NL80211_ATTR_NAN_MASTER_PREF attribute and optional
+ *	%NL80211_ATTR_BANDS attributes.  If %NL80211_ATTR_BANDS is
+ *	omitted or set to 0, it means don't-care and the device will
+ *	decide what to use.  After this command NAN functions can be
+ *	added.
  * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
  *	its %NL80211_ATTR_WDEV interface.
  * @NL80211_CMD_ADD_NAN_FUNCTION: Add a NAN function. The function is defined
@@ -880,10 +883,14 @@
  *	This command is also used as a notification sent when a NAN function is
  *	terminated. This will contain a %NL80211_ATTR_NAN_FUNC_INST_ID
  *	and %NL80211_ATTR_COOKIE attributes.
- * @NL80211_CMD_CHANGE_NAN_CONFIG: Change current NAN configuration. NAN
- *	must be operational (%NL80211_CMD_START_NAN was executed).
- *	It must contain at least one of the following attributes:
- *	%NL80211_ATTR_NAN_MASTER_PREF, %NL80211_ATTR_NAN_DUAL.
+ * @NL80211_CMD_CHANGE_NAN_CONFIG: Change current NAN
+ *	configuration. NAN must be operational (%NL80211_CMD_START_NAN
+ *	was executed).  It must contain at least one of the following
+ *	attributes: %NL80211_ATTR_NAN_MASTER_PREF,
+ *	%NL80211_ATTR_BANDS.  If %NL80211_ATTR_BANDS is omitted, the
+ *	current configuration is not changed.  If it is present but
+ *	set to zero, the configuration is changed to don't-care
+ *	(i.e. the device can decide what to do).
  * @NL80211_CMD_NAN_FUNC_MATCH: Notification sent when a match is reported.
  *	This will contain a %NL80211_ATTR_NAN_MATCH nested attribute and
  *	%NL80211_ATTR_COOKIE.
@@ -1963,10 +1970,13 @@ enum nl80211_commands {
  *	%NL80211_CMD_CHANGE_NAN_CONFIG. Its type is u8 and it can't be 0.
  *	Also, values 1 and 255 are reserved for certification purposes and
  *	should not be used during a normal device operation.
- * @NL80211_ATTR_NAN_DUAL: NAN dual band operation config (see
- *	&enum nl80211_nan_dual_band_conf). This attribute is used with
- *	%NL80211_CMD_START_NAN and optionally with
- *	%NL80211_CMD_CHANGE_NAN_CONFIG.
+ * @NL80211_ATTR_BANDS: operating bands configuration.  This is a u32
+ *	bitmask of BIT(NL80211_BAND_*) as described in %enum
+ *	nl80211_band.  For instance, for NL80211_BAND_2GHZ, bit 0
+ *	would be set.  This attribute is used with
+ *	%NL80211_CMD_START_NAN and %NL80211_CMD_CHANGE_NAN_CONFIG, and
+ *	it is optional.  If no bands are set, it means don't-care and
+ *	the device will decide what to use.
  * @NL80211_ATTR_NAN_FUNC: a function that can be added to NAN. See
  *	&enum nl80211_nan_func_attributes for description of this nested
  *	attribute.
@@ -2397,7 +2407,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_MESH_PEER_AID,
 
 	NL80211_ATTR_NAN_MASTER_PREF,
-	NL80211_ATTR_NAN_DUAL,
+	NL80211_ATTR_BANDS,
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_MATCH,
 
@@ -5071,21 +5081,6 @@ enum nl80211_bss_select_attr {
 };
 
 /**
- * enum nl80211_nan_dual_band_conf - NAN dual band configuration
- *
- * Defines the NAN dual band mode of operation
- *
- * @NL80211_NAN_BAND_DEFAULT: device default mode
- * @NL80211_NAN_BAND_2GHZ: 2.4GHz mode
- * @NL80211_NAN_BAND_5GHZ: 5GHz mode
-  */
-enum nl80211_nan_dual_band_conf {
-	NL80211_NAN_BAND_DEFAULT	= 1 << 0,
-	NL80211_NAN_BAND_2GHZ		= 1 << 1,
-	NL80211_NAN_BAND_5GHZ		= 1 << 2,
-};
-
-/**
  * enum nl80211_nan_function_type - NAN function type
  *
  * Defines the function type of a NAN function
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a0be2f6cd121..ac879bb17870 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -208,8 +208,8 @@ static int ieee80211_nan_change_conf(struct wiphy *wiphy,
 	if (changes & CFG80211_NAN_CONF_CHANGED_PREF)
 		new_conf.master_pref = conf->master_pref;
 
-	if (changes & CFG80211_NAN_CONF_CHANGED_DUAL)
-		new_conf.dual = conf->dual;
+	if (changes & CFG80211_NAN_CONF_CHANGED_BANDS)
+		new_conf.bands = conf->bands;
 
 	ret = drv_nan_change_conf(sdata->local, sdata, &new_conf, changes);
 	if (!ret)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index f78d9f4f8711..0d645bc148d0 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1736,21 +1736,21 @@ TRACE_EVENT(drv_start_nan,
 		LOCAL_ENTRY
 		VIF_ENTRY
 		__field(u8, master_pref)
-		__field(u8, dual)
+		__field(u8, bands)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		__entry->master_pref = conf->master_pref;
-		__entry->dual = conf->dual;
+		__entry->bands = conf->bands;
 	),
 
 	TP_printk(
 		LOCAL_PR_FMT  VIF_PR_FMT
-		", master preference: %u, dual: %d",
+		", master preference: %u, bands: 0x%0x",
 		LOCAL_PR_ARG, VIF_PR_ARG, __entry->master_pref,
-		__entry->dual
+		__entry->bands
 	)
 );
 
@@ -1787,7 +1787,7 @@ TRACE_EVENT(drv_nan_change_conf,
 		LOCAL_ENTRY
 		VIF_ENTRY
 		__field(u8, master_pref)
-		__field(u8, dual)
+		__field(u8, bands)
 		__field(u32, changes)
 	),
 
@@ -1795,15 +1795,15 @@ TRACE_EVENT(drv_nan_change_conf,
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		__entry->master_pref = conf->master_pref;
-		__entry->dual = conf->dual;
+		__entry->bands = conf->bands;
 		__entry->changes = changes;
 	),
 
 	TP_printk(
 		LOCAL_PR_FMT  VIF_PR_FMT
-		", master preference: %u, dual: %d, changes: 0x%x",
+		", master preference: %u, bands: 0x%0x, changes: 0x%x",
 		LOCAL_PR_ARG, VIF_PR_ARG, __entry->master_pref,
-		__entry->dual, __entry->changes
+		__entry->bands, __entry->changes
 	)
 );
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 903fc419217a..e55e05bc4805 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -626,7 +626,8 @@ int wiphy_register(struct wiphy *wiphy)
 
 	if (WARN_ON((wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN)) &&
 		    (!rdev->ops->start_nan || !rdev->ops->stop_nan ||
-		     !rdev->ops->add_nan_func || !rdev->ops->del_nan_func)))
+		     !rdev->ops->add_nan_func || !rdev->ops->del_nan_func ||
+		     !(wiphy->nan_supported_bands & BIT(NL80211_BAND_2GHZ)))))
 		return -EINVAL;
 
 #ifndef CONFIG_WIRELESS_WDS
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9d738f75bd4e..b5f755b3ac5d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -398,7 +398,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	},
 	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
 	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
-	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
+	[NL80211_ATTR_BANDS] = { .type = NLA_U32 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
 	[NL80211_ATTR_FILS_KEK] = { .type = NLA_BINARY,
 				    .len = FILS_MAX_KEK_LEN },
@@ -1886,6 +1886,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			}
 		}
 
+		if (nla_put_u32(msg, NL80211_ATTR_BANDS,
+				rdev->wiphy.nan_supported_bands))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -10777,15 +10781,22 @@ static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_NAN_MASTER_PREF])
 		return -EINVAL;
 
-	if (!info->attrs[NL80211_ATTR_NAN_DUAL])
-		return -EINVAL;
-
 	conf.master_pref =
 		nla_get_u8(info->attrs[NL80211_ATTR_NAN_MASTER_PREF]);
 	if (!conf.master_pref)
 		return -EINVAL;
 
-	conf.dual = nla_get_u8(info->attrs[NL80211_ATTR_NAN_DUAL]);
+	if (info->attrs[NL80211_ATTR_BANDS]) {
+		u32 bands = nla_get_u32(info->attrs[NL80211_ATTR_BANDS]);
+
+		if (bands & ~(u32)wdev->wiphy->nan_supported_bands)
+			return -EOPNOTSUPP;
+
+		if (bands && !(bands & BIT(NL80211_BAND_2GHZ)))
+			return -EINVAL;
+
+		conf.bands = bands;
+	}
 
 	err = rdev_start_nan(rdev, wdev, &conf);
 	if (err)
@@ -11150,9 +11161,17 @@ static int nl80211_nan_change_config(struct sk_buff *skb,
 		changed |= CFG80211_NAN_CONF_CHANGED_PREF;
 	}
 
-	if (info->attrs[NL80211_ATTR_NAN_DUAL]) {
-		conf.dual = nla_get_u8(info->attrs[NL80211_ATTR_NAN_DUAL]);
-		changed |= CFG80211_NAN_CONF_CHANGED_DUAL;
+	if (info->attrs[NL80211_ATTR_BANDS]) {
+		u32 bands = nla_get_u32(info->attrs[NL80211_ATTR_BANDS]);
+
+		if (bands & ~(u32)wdev->wiphy->nan_supported_bands)
+			return -EOPNOTSUPP;
+
+		if (bands && !(bands & BIT(NL80211_BAND_2GHZ)))
+			return -EINVAL;
+
+		conf.bands = bands;
+		changed |= CFG80211_NAN_CONF_CHANGED_BANDS;
 	}
 
 	if (!changed)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2419c390f150..776e80cef9b4 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1915,18 +1915,18 @@ TRACE_EVENT(rdev_start_nan,
 		WIPHY_ENTRY
 		WDEV_ENTRY
 		__field(u8, master_pref)
-		__field(u8, dual);
+		__field(u8, bands);
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		WDEV_ASSIGN;
 		__entry->master_pref = conf->master_pref;
-		__entry->dual = conf->dual;
+		__entry->bands = conf->bands;
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
-		  ", master preference: %u, dual: %d",
+		  ", master preference: %u, bands: 0x%0x",
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref,
-		  __entry->dual)
+		  __entry->bands)
 );
 
 TRACE_EVENT(rdev_nan_change_conf,
@@ -1937,20 +1937,20 @@ TRACE_EVENT(rdev_nan_change_conf,
 		WIPHY_ENTRY
 		WDEV_ENTRY
 		__field(u8, master_pref)
-		__field(u8, dual);
+		__field(u8, bands);
 		__field(u32, changes);
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		WDEV_ASSIGN;
 		__entry->master_pref = conf->master_pref;
-		__entry->dual = conf->dual;
+		__entry->bands = conf->bands;
 		__entry->changes = changes;
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
-		  ", master preference: %u, dual: %d, changes: %x",
+		  ", master preference: %u, bands: 0x%0x, changes: %x",
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref,
-		  __entry->dual, __entry->changes)
+		  __entry->bands, __entry->changes)
 );
 
 DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_nan,
-- 
2.11.0
