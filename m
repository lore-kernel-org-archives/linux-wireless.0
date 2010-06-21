Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:48337 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab0FUKje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 06:39:34 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o5LAd8x3023271
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 13:39:31 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o5LAdQNT023572
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 13:39:27 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv2 2/2] nl80211: Add option to adjust transmit power
Date: Mon, 21 Jun 2010 13:39:26 +0300
Message-Id: <1277116766-4764-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1277116766-4764-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1277116766-4764-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds transmit power setting type and transmit power level attributes
to NL80211_CMD_SET_WIPHY in order to facilitate adjusting of the transmit power
level of the device.

The added attributes allow selection of automatic, limited or fixed transmit
power level, with the level definable in signed mBm format.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/linux/nl80211.h |    9 +++++++++
 net/wireless/nl80211.c  |   31 +++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 07aa046..2c87016 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -725,6 +725,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
  *	connected to this BSS.
  *
+ * @NL80211_ATTR_WIPHY_TX_POWER_SETTING: Transmit power setting type. See
+ *      &enum nl80211_tx_power_setting for possible values.
+ * @NL80211_ATTR_WIPHY_TX_POWER_LEVEL: Transmit power level in signed mBm units.
+ *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
+ *      for non-automatic settings.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -882,6 +888,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AP_ISOLATE,
 
+	NL80211_ATTR_WIPHY_TX_POWER_SETTING,
+	NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 41529ac..a999fc1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -153,6 +153,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
+
+	[NL80211_ATTR_WIPHY_TX_POWER_SETTING] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -869,6 +872,34 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			goto bad_res;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_TX_POWER_SETTING]) {
+		enum nl80211_tx_power_setting type;
+		int idx, mbm = 0;
+
+		if (!rdev->ops->set_tx_power) {
+			return -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		idx = NL80211_ATTR_WIPHY_TX_POWER_SETTING;
+		type = nla_get_u32(info->attrs[idx]);
+
+		if (!info->attrs[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] &&
+		    (type != NL80211_TX_POWER_AUTOMATIC)) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+
+		if (type != NL80211_TX_POWER_AUTOMATIC) {
+			idx = NL80211_ATTR_WIPHY_TX_POWER_LEVEL;
+			mbm = nla_get_u32(info->attrs[idx]);
+		}
+
+		result = rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
+		if (result)
+			goto bad_res;
+	}
+
 	changed = 0;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]) {
-- 
1.6.3.3

