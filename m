Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYHGPW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:22:28 -0400
Subject: [RFC] cfg80211: keep track of supported interface modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:21:35 +0200
Message-Id: <1218122495.3630.2.camel@johannes.berg> (sfid-20080807_172231_222655_987FC5C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is obviously good for userspace to know up front which interface modes
a given piece of hardware might support (even if adding such an interface
might fail later because of concurrency issues), so let's make cfg80211
aware of that. For good measure, disallow adding interfaces in all other
modes so drivers don't forget to announce support for one mode when they
add it.

This patch is incomplete as it doesn't modify all drivers. The driver
modifications should be straight-forward, I'm hoping somebody else
can pick it up and collect the necessary driver changes. Included is a
b43 change because I tested it with that. I have also pushed an iw
change to print out this information.

It's a bit ugly that it requires drivers to use nl80211 constants, but
if anything mac80211 should migrate to using those completely instead
of translating them to its own versions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c |   17 ++++++++++++-----
 include/linux/nl80211.h         |    6 ++++++
 include/net/wireless.h          |    3 +++
 net/mac80211/main.c             |    7 +++++++
 net/wireless/core.c             |    9 ++++++++-
 net/wireless/nl80211.c          |   22 ++++++++++++++++++++--
 6 files changed, 56 insertions(+), 8 deletions(-)

--- everything.orig/include/linux/nl80211.h	2008-08-07 16:26:44.000000000 +0200
+++ everything/include/linux/nl80211.h	2008-08-07 16:39:03.000000000 +0200
@@ -192,6 +192,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_MNTR_FLAGS: flags, nested element with NLA_FLAG attributes of
  *      &enum nl80211_mntr_flags.
  *
+ * @NL80211_ATTR_SUPPORTED_IFTYPES: nested attribute containing all
+ *	supported interface types, each a flag attribute with the number
+ *	of the interface mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -235,6 +239,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MPATH_NEXT_HOP,
 	NL80211_ATTR_MPATH_INFO,
 
+	NL80211_ATTR_SUPPORTED_IFTYPES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- everything.orig/include/net/wireless.h	2008-08-07 16:26:33.000000000 +0200
+++ everything/include/net/wireless.h	2008-08-07 16:28:20.000000000 +0200
@@ -185,6 +185,9 @@ struct wiphy {
 	/* permanent MAC address */
 	u8 perm_addr[ETH_ALEN];
 
+	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
+	u16 interface_modes;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
--- everything.orig/net/wireless/core.c	2008-08-07 16:32:27.000000000 +0200
+++ everything/net/wireless/core.c	2008-08-07 16:47:11.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * This is the linux wireless configuration interface.
  *
- * Copyright 2006, 2007		Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2008		Johannes Berg <johannes@sipsolutions.net>
  */
 
 #include <linux/if.h>
@@ -259,6 +259,13 @@ int wiphy_register(struct wiphy *wiphy)
 	struct ieee80211_supported_band *sband;
 	bool have_band = false;
 	int i;
+	u16 ifmodes = wiphy->interface_modes;
+
+	/* sanity check ifmodes */
+	WARN_ON(!ifmodes);
+	ifmodes &= ((1 << __NL80211_IFTYPE_AFTER_LAST) - 1) & ~1;
+	if (WARN_ON(ifmodes != wiphy->interface_modes))
+		wiphy->interface_modes = ifmodes;
 
 	/* sanity check supported bands/channels */
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
--- everything.orig/net/wireless/nl80211.c	2008-08-07 16:35:22.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-08-07 16:42:24.000000000 +0200
@@ -106,10 +106,12 @@ static int nl80211_send_wiphy(struct sk_
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_rates, *nl_rate;
+	struct nlattr *nl_modes;
 	enum ieee80211_band band;
 	struct ieee80211_channel *chan;
 	struct ieee80211_rate *rate;
 	int i;
+	u16 ifmodes = dev->wiphy.interface_modes;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
@@ -118,6 +120,20 @@ static int nl80211_send_wiphy(struct sk_
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
 
+	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
+	if (!nl_modes)
+		goto nla_put_failure;
+
+	i = 0;
+	while (ifmodes) {
+		if (ifmodes & 1)
+			NLA_PUT_FLAG(msg, i);
+		ifmodes >>= 1;
+		i++;
+	}
+
+	nla_nest_end(msg, nl_modes);
+
 	nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 	if (!nl_bands)
 		goto nla_put_failure;
@@ -408,7 +424,8 @@ static int nl80211_set_interface(struct 
 	ifindex = dev->ifindex;
 	dev_put(dev);
 
-	if (!drv->ops->change_virtual_intf) {
+	if (!drv->ops->change_virtual_intf ||
+	    !(drv->wiphy.interface_modes & (1 << type))) {
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -455,7 +472,8 @@ static int nl80211_new_interface(struct 
 	if (IS_ERR(drv))
 		return PTR_ERR(drv);
 
-	if (!drv->ops->add_virtual_intf) {
+	if (!drv->ops->add_virtual_intf ||
+	    !(drv->wiphy.interface_modes & (1 << type))) {
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
--- everything.orig/drivers/net/wireless/b43/main.c	2008-08-07 16:49:57.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-08-07 16:57:12.000000000 +0200
@@ -4165,11 +4165,11 @@ static int b43_op_add_interface(struct i
 
 	/* TODO: allow WDS/AP devices to coexist */
 
-	if (conf->type != IEEE80211_IF_TYPE_AP &&
-	    conf->type != IEEE80211_IF_TYPE_MESH_POINT &&
-	    conf->type != IEEE80211_IF_TYPE_STA &&
-	    conf->type != IEEE80211_IF_TYPE_WDS &&
-	    conf->type != IEEE80211_IF_TYPE_IBSS)
+	if (WARN_ON(conf->type != IEEE80211_IF_TYPE_AP &&
+		    conf->type != IEEE80211_IF_TYPE_MESH_POINT &&
+		    conf->type != IEEE80211_IF_TYPE_STA &&
+		    conf->type != IEEE80211_IF_TYPE_WDS &&
+		    conf->type != IEEE80211_IF_TYPE_IBSS))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
@@ -4649,6 +4649,13 @@ static int b43_wireless_init(struct ssb_
 		    IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
 
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_WDS) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	hw->queues = b43_modparam_qos ? 4 : 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
--- everything.orig/net/mac80211/main.c	2008-08-07 16:42:32.000000000 +0200
+++ everything/net/mac80211/main.c	2008-08-07 16:59:05.000000000 +0200
@@ -1263,6 +1263,13 @@ int ieee80211_register_hw(struct ieee802
 		}
 	}
 
+	/* if low-level driver supports AP, we also support VLAN */
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP))
+		local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+
+	/* mac80211 always supports monitor */
+	local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		return result;


