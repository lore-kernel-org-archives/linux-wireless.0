Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36417 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3IFNGM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 09:06:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/2] cfg80211: add support for configuring antenna gain
Date: Fri,  6 Sep 2013 15:06:02 +0200
Message-Id: <1378472763-36062-1-git-send-email-nbd@openwrt.org> (sfid-20130906_150617_347565_4460D537)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using high-gain antennas, transmit power needs to be reduced to
stay within legal EIRP limits.
This option only reduces transmit power as much as is necessary to
stay within the limit.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       | 17 +++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d530c54..6b73781 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2061,6 +2061,7 @@ struct cfg80211_update_ft_ies_params {
  *	(as advertised by the nl80211 feature flag.)
  * @get_tx_power: store the current TX power into the dbm variable;
  *	return 0 if successful
+ * @set_antenna_gain: set antenna gain to reduce maximum tx power if necessary
  *
  * @set_wds_peer: set the WDS peer for a WDS interface
  *
@@ -2283,6 +2284,7 @@ struct cfg80211_ops {
 				enum nl80211_tx_power_setting type, int mbm);
 	int	(*get_tx_power)(struct wiphy *wiphy, struct wireless_dev *wdev,
 				int *dbm);
+	int	(*set_antenna_gain)(struct wiphy *wiphy, int dbi);
 
 	int	(*set_wds_peer)(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *addr);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..14b8d50 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1496,6 +1496,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
  *	As specified in the &enum nl80211_rxmgmt_flags.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_GAIN: Configured antenna gain. Used to reduce
+ *	transmit power to stay within regulatory limits. u32, dBi.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1806,6 +1809,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RXMGMT_FLAGS,
 
+	NL80211_ATTR_WIPHY_ANTENNA_GAIN,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index af8d84a..a29ab58 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,6 +354,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_WIPHY_ANTENNA_GAIN] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -2033,6 +2034,22 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			goto bad_res;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_ANTENNA_GAIN]) {
+		int idx, dbi = 0;
+
+		if (!rdev->ops->set_antenna_gain) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		idx = NL80211_ATTR_WIPHY_ANTENNA_GAIN;
+		dbi = nla_get_u32(info->attrs[idx]);
+
+		result = rdev->ops->set_antenna_gain(&rdev->wiphy, dbi);
+		if (result)
+			goto bad_res;
+	}
+
 	if (info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
 	    info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
 		u32 tx_ant, rx_ant;
-- 
1.8.0.2

