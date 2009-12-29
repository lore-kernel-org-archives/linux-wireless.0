Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59193 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743AbZL2K74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 05:59:56 -0500
Date: Tue, 29 Dec 2009 12:59:45 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 3/3] nl80211: New command for setting TX rate mask for rate
 control
Message-ID: <20091229105945.GD18493@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new NL80211_CMD_SET_TX_BITRATE_MASK command and related
attributes to provide support for setting TX rate mask for rate
control. This uses the existing cfg80211 set_bitrate_mask operation
that was previously used only with WEXT compat code (SIOCSIWRATE). The
nl80211 command allows more generic configuration of allowed rates as
a mask instead of fixed/max rate.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h |   44 +++++++++++++++++++
 include/net/cfg80211.h  |    4 -
 net/wireless/nl80211.c  |  111 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-12-29 10:50:56.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-12-29 10:56:42.000000000 +0200
@@ -295,6 +295,10 @@
  *	This command is also used as an event to notify when a requested
  *	remain-on-channel duration has expired.
  *
+ * @NL80211_CMD_SET_TX_BITRATE_MASK: Set the mask of rates to be used in TX
+ *	rate selection. %NL80211_ATTR_IFINDEX is used to specify the interface
+ *	and @NL80211_ATTR_TX_RATES the set of allowed rates.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -381,6 +385,8 @@ enum nl80211_commands {
 	NL80211_CMD_REMAIN_ON_CHANNEL,
 	NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
 
+	NL80211_CMD_SET_TX_BITRATE_MASK,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -638,6 +644,13 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_COOKIE: Generic 64-bit cookie to identify objects.
  *
+ * @NL80211_ATTR_TX_RATES: Nested set of attributes
+ *	(enum nl80211_tx_rate_attributes) describing TX rates per band. The
+ *	enum nl80211_band value is used as the index (nla_type() of the nested
+ *	data. If a band is not included, it will be configured to allow all
+ *	rates based on negotiated supported rates information. This attribute
+ *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -779,6 +792,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_COOKIE,
 
+	NL80211_ATTR_TX_RATES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1478,4 +1493,33 @@ enum nl80211_key_attributes {
 	NL80211_KEY_MAX = __NL80211_KEY_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_tx_rate_attributes - TX rate set attributes
+ * @__NL80211_TXRATE_INVALID: invalid
+ * @NL80211_TXRATE_LEGACY: Legacy (non-MCS) rates allowed for TX rate selection
+ *	in an array of rates as defined in IEEE 802.11 7.3.2.2 (u8 values with
+ *	1 = 500 kbps) but without the IE length restriction (at most
+ *	%NL80211_MAX_SUPP_RATES in a single array).
+ * @__NL80211_TXRATE_AFTER_LAST: internal
+ * @NL80211_TXRATE_MAX: highest TX rate attribute
+ */
+enum nl80211_tx_rate_attributes {
+	__NL80211_TXRATE_INVALID,
+	NL80211_TXRATE_LEGACY,
+
+	/* keep last */
+	__NL80211_TXRATE_AFTER_LAST,
+	NL80211_TXRATE_MAX = __NL80211_TXRATE_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_band - Frequency band
+ * @NL80211_BAND_2GHZ - 2.4 GHz ISM band
+ * @NL80211_BAND_5GHZ - around 5 GHz band (4.9 - 5.7 GHz)
+ */
+enum nl80211_band {
+	NL80211_BAND_2GHZ,
+	NL80211_BAND_5GHZ,
+};
+
 #endif /* __LINUX_NL80211_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-12-29 10:50:57.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-12-29 10:57:37.000000000 +0200
@@ -143,6 +143,7 @@ static struct nla_policy nl80211_policy[
 				 .len = WLAN_PMKID_LEN },
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
+	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
 };
 
 /* policy for the attributes */
@@ -572,6 +573,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(del_pmksa, DEL_PMKSA);
 	CMD(flush_pmksa, FLUSH_PMKSA);
 	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
+	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
 	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
@@ -4423,6 +4425,109 @@ static int nl80211_cancel_remain_on_chan
 	return err;
 }
 
+static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
+			   u8 *rates, u8 rates_len)
+{
+	u8 i;
+	u32 mask = 0;
+
+	for (i = 0; i < rates_len; i++) {
+		int rate = (rates[i] & 0x7f) * 5;
+		int ridx;
+		for (ridx = 0; ridx < sband->n_bitrates; ridx++) {
+			struct ieee80211_rate *srate =
+				&sband->bitrates[ridx];
+			if (rate == srate->bitrate) {
+				mask |= 1 << ridx;
+				break;
+			}
+		}
+		if (ridx == sband->n_bitrates)
+			return 0; /* rate not found */
+	}
+
+	return mask;
+}
+
+static struct nla_policy
+nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] __read_mostly = {
+	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
+				    .len = NL80211_MAX_SUPP_RATES },
+};
+
+static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_TXRATE_MAX + 1];
+	struct cfg80211_registered_device *rdev;
+	struct cfg80211_bitrate_mask mask;
+	int err, rem, i;
+	struct net_device *dev;
+	struct nlattr *tx_rates;
+	struct ieee80211_supported_band *sband;
+
+	if (info->attrs[NL80211_ATTR_TX_RATES] == NULL)
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!rdev->ops->set_bitrate_mask) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	memset(&mask, 0, sizeof(mask));
+	/* Default to all rates enabled */
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		sband = rdev->wiphy.bands[i];
+		mask.control[i].legacy =
+			sband ? (1 << sband->n_bitrates) - 1 : 0;
+	}
+
+	/*
+	 * The nested attribute uses enum nl80211_band as the index. This maps
+	 * directly to the enum ieee80211_band values used in cfg80211.
+	 */
+	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem)
+	{
+		enum ieee80211_band band = nla_type(tx_rates);
+		if (band < 0 || band >= IEEE80211_NUM_BANDS) {
+			err = -EINVAL;
+			goto unlock;
+		}
+		sband = rdev->wiphy.bands[band];
+		if (sband == NULL) {
+			err = -EINVAL;
+			goto unlock;
+		}
+		nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
+			  nla_len(tx_rates), nl80211_txattr_policy);
+		if (tb[NL80211_TXRATE_LEGACY]) {
+			mask.control[band].legacy = rateset_to_mask(
+				sband,
+				nla_data(tb[NL80211_TXRATE_LEGACY]),
+				nla_len(tb[NL80211_TXRATE_LEGACY]));
+			if (mask.control[band].legacy == 0) {
+				err = -EINVAL;
+				goto unlock;
+			}
+		}
+	}
+
+	err = rdev->ops->set_bitrate_mask(&rdev->wiphy, dev, NULL, &mask);
+
+ unlock:
+	dev_put(dev);
+	cfg80211_unlock_rdev(rdev);
+ unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -4697,6 +4802,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_TX_BITRATE_MASK,
+		.doit = nl80211_set_tx_bitrate_mask,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
--- wireless-testing.orig/include/net/cfg80211.h	2009-12-29 10:54:29.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-12-29 10:55:52.000000000 +0200
@@ -39,8 +39,8 @@
  * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
  */
 enum ieee80211_band {
-	IEEE80211_BAND_2GHZ,
-	IEEE80211_BAND_5GHZ,
+	IEEE80211_BAND_2GHZ = NL80211_BAND_2GHZ,
+	IEEE80211_BAND_5GHZ = NL80211_BAND_5GHZ,
 
 	/* keep last */
 	IEEE80211_NUM_BANDS

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
