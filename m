Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57890 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759625Ab3KMSNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:13:14 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so5065748wgh.5
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 10:13:13 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 4/5] cfg80211: add DFS region capability support
Date: Wed, 13 Nov 2013 19:12:58 +0100
Message-Id: <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191318_788089_24C21AD5)
In-Reply-To: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets drivers explicitly enable specific DFS regions
and sends these to userspace when at least one is set.
This is to be used for modes of operation that require
DFS to be implemented in kernel space. cfg80211 will
only send the DFS regions to userspace for the wiphy
if the DFS region for the device agrees with the central
cfg80211 regulatory domain DFS region. In case of
regulatory updates the regulatory core already takes
care of quiescing devices when required. Userspace
should always query the support DFS region prior to
enabling usage of a DFS channel for a mode of operation
that requires DFS support in kernel.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/cfg80211.h       | 57 ++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 21 +++++++++++++++-
 net/wireless/core.c          | 39 ++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 10 ++++++++
 4 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 817d813..0f43eb3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2701,6 +2701,19 @@ struct wiphy_coalesce_support {
  * @flags: wiphy flags, see &enum wiphy_flags
  * @regulatory_flags: wiphy regulatory flags, see
  * 	&enum ieee80211_regulatory_flags
+ * @dfs_regions: bitmask of the supported DFS regions that this device has
+ * 	support for on the driver. Having DFS region support means the
+ * 	device driver is capable of supporting radar detection as per that
+ * 	DFS region's rules. Radar detection is required prior to initiating
+ * 	radiation on channels that have the IEEE80211_CHAN_RADAR flag set.
+ * 	Modes of operation that require DFS support in kernel must ensure
+ * 	that initiating radiation will not happen if there is a mismatch
+ * 	of the supported DFS regions with wiphy_core_dfs_region_usable().
+ * 	Device drivers that have DFS support should pass each supported
+ * 	&enum nl80211_dfs_regions with wiphy_enable_dfs_region(). This will
+ * 	set the respective bitmask on dfs_regions. IBSS mode of operation
+ * 	that enables %NL80211_ATTR_HANDLE_DFS need not set the supported
+ * 	DFS regions, but should ensure it supports the core's set DFS region.
  * @features: features advertised to nl80211, see &enum nl80211_feature_flags.
  * @bss_priv_size: each BSS struct has private data allocated with it,
  *	this variable determines its size
@@ -2790,6 +2803,7 @@ struct wiphy {
 	u16 max_acl_mac_addrs;
 
 	u32 flags, regulatory_flags, features;
+	u32 dfs_regions;
 
 	u32 ap_sme_capa;
 
@@ -2988,6 +3002,49 @@ void wiphy_unregister(struct wiphy *wiphy);
  */
 void wiphy_free(struct wiphy *wiphy);
 
+/**
+ * wiphy_enable_dfs_region - enable a DFS region
+ *
+ * @wiphy: the wiphy to set the supported DFS regions for
+ * @dfs_region: an DFS region specified by an &enum nl80211_dfs_regions
+ * 	representing the DFS region to enable support on the wiphy for.
+ *
+ * This can be used to indicate to cfg80211 that the wiphy has DFS driver
+ * support for the specified DFS region for modes of operation that require
+ * DFS on the driver.
+ */
+void wiphy_enable_dfs_region(struct wiphy *wiphy,
+			     enum nl80211_dfs_regions dfs_region);
+
+/**
+ * wiphy_dfs_region_supported - checks if a DFS region is supported
+ *
+ * @wiphy: the wiphy to check the DFS region for
+ * @dfs_region: the DFS region we want to check support for
+ *
+ * This can be used to query if the wiphy's a specific DFS region.
+ * This should be checked before for initiating radiation on
+ * DFS channels for modes of operation that require DFS on the driver.
+ *
+ * Return: true if the dfs_region is supported by the device, returns
+ * false otherwise.
+ */
+bool wiphy_dfs_region_supported(struct wiphy *wiphy,
+				enum nl80211_dfs_regions dfs_region);
+
+/**
+ * wiphy_core_dfs_region_usable - checks if the current DFS region can be used
+ *
+ * @wiphy: the wiphy to check the DFS region against
+ *
+ * This can be used to query if the wiphy can use the currently set
+ * DFS region on the regulatory core.
+ *
+ * Return: true if the core's dfs_region is supported and usable by the device,
+ * returns false otherwise.
+ */
+bool wiphy_core_dfs_region_usable(struct wiphy *wiphy);
+
 /* internal structs */
 struct cfg80211_conn;
 struct cfg80211_internal_bss;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7e25164..ecb3d88 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1513,7 +1513,23 @@ enum nl80211_commands {
  *	%NL80211_CMD_JOIN_IBSS request, the driver will allow use of DFS
  *	channels and reports radar events to userspace. Userspace is required
  *	to react to radar events, e.g. initiate a channel switch or leave the
- *	IBSS network.
+ *	IBSS network. Userspace is also required to verify that the currently
+ *	programmed DFS region is supported by userspace and monitor it in case
+ *	of changes.
+ *
+ * @NL80211_ATTR_DFS_REGIONS: bitmask of all supported, tested, and
+ * 	certified &enum nl80211_dfs_regions that a wiphy has been declared to
+ *	support and that agrees with what is programmed currently on cfg80211.
+ *	This is used for modes of operation that require DFS support on the
+ *	driver. If %NL80211_ATTR_HANDLE_DFS is set userspace need not check
+ *	for this for IBSS as it will support DFS in userspace for IBSS.
+ *	Userspace can rely on %NL80211_ATTR_DFS_REGIONS to enable support for
+ *	modes of operation on channels flagged with %NL80211_RRF_DFS, the
+ *	kernel / driver will take care of DFS operation. If
+ *	%NL80211_ATTR_DFS_REGIONS is not set DFS is not supported or
+ *	does not match the DFS region currently set on cfg80211 and
+ *	userspace must not enable operation on channels with
+ *	%NL80211_RRF_DFS set.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1831,6 +1847,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HANDLE_DFS,
 
+	NL80211_ATTR_DFS_REGIONS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1866,6 +1884,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
 #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
+#define NL80211_ATTR_DFS_REGIONS NL80211_ATTR_DFS_REGIONS
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 818871e..abd39c3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -361,6 +361,45 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 }
 EXPORT_SYMBOL(wiphy_new);
 
+void wiphy_enable_dfs_region(struct wiphy *wiphy,
+			     enum nl80211_dfs_regions dfs_region)
+{
+	if (!config_enabled(CONFIG_CFG80211_CERTIFICATION_ONUS))
+		return;
+	if (!reg_supported_dfs_region(dfs_region))
+		return;
+
+	wiphy->dfs_regions |= BIT(dfs_region);
+}
+EXPORT_SYMBOL_GPL(wiphy_enable_dfs_region);
+
+bool wiphy_dfs_region_supported(struct wiphy *wiphy,
+				enum nl80211_dfs_regions dfs_region)
+{
+	if (!config_enabled(CONFIG_CFG80211_CERTIFICATION_ONUS))
+		return false;
+	if (!reg_supported_dfs_region(dfs_region))
+		return false;
+	if (dfs_region == NL80211_DFS_UNSET)
+		return false;
+	if (BIT(dfs_region) & wiphy->dfs_regions)
+		return true;
+	return false;
+}
+
+bool wiphy_core_dfs_region_usable(struct wiphy *wiphy)
+{
+	enum nl80211_dfs_regions cfg80211_dfs_region;
+
+	ASSERT_RTNL();
+
+	cfg80211_dfs_region = reg_get_dfs_region(wiphy);
+	if (!wiphy_dfs_region_supported(wiphy, cfg80211_dfs_region))
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(wiphy_core_dfs_region_usable);
+
 static int wiphy_verify_combinations(struct wiphy *wiphy)
 {
 	const struct ieee80211_iface_combination *c;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c33b374..dcbc083 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -357,6 +357,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DFS_REGIONS] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -1559,6 +1560,15 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	case 10:
 		if (nl80211_send_coalesce(msg, dev))
 			goto nla_put_failure;
+		state->split_start++;
+		break;
+	case 11:
+		if (wiphy_core_dfs_region_usable(&dev->wiphy) &&
+		    dev->wiphy.dfs_regions &&
+		    nla_put_u32(msg,
+				NL80211_ATTR_DFS_REGIONS,
+				dev->wiphy.dfs_regions))
+			goto nla_put_failure;
 
 		/* done */
 		state->split_start = 0;
-- 
1.8.4.rc3

