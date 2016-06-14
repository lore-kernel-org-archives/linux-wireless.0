Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36699 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbcFNRox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 13:44:53 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
	<arnagara@codeaurora.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH 1/2] cfg80211: Add support to set tx power for a station associated
Date: Tue, 14 Jun 2016 23:14:16 +0530
Message-ID: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160614_194457_479464_1DFBB7C4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to set transmit power setting type and transmit
power level attributes to NL80211_CMD_SET_STATION in order to facilitate
adjusting the transmit power level of a station associated to the AP.

The added attributes allow selection of automatic and limited transmit
power level, with the level defined in mBm format.

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  5 ++++
 include/uapi/linux/nl80211.h | 12 ++++++++++
 net/wireless/nl80211.c       | 54 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6392167..4bf761d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -797,6 +797,10 @@ enum station_parameters_apply_mask {
  * @opmode_notif: operating mode field from Operating Mode Notification
  * @opmode_notif_used: information if operating mode field is used
  * @support_p2p_ps: information if station supports P2P PS mechanism
+ * @txpwr: tx power (in mBm) to be used for sending data traffic. If tx power
+ *	is not provided, the default per-interface tx power setting will be
+ *	overriding. Driver should be picking up the lowest tx power, either tx
+ *	power per-interface or per-station.
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -823,6 +827,7 @@ struct station_parameters {
 	u8 opmode_notif;
 	bool opmode_notif_used;
 	int support_p2p_ps;
+	unsigned int txpwr;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e23d786..fe28006 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1819,6 +1819,15 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_PAD: attribute used for padding for 64-bit alignment
  *
+ * @NL80211_ATTR_STA_TX_POWER_SETTING: Transmit power setting type (u32) for
+ *	station associated with the AP. See &enum nl80211_tx_power_setting for
+ *	possible values.
+ * @NL80211_ATTR_STA_TX_POWER: Transmit power level (u32) in mBm units. This
+ *	allows to set Tx power for a station. If this attribute is not included,
+ *	the default per-interface tx power setting will be overriding. Driver
+ *	should be picking up the lowest tx power, either tx power per-interface
+ *	or per-station.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2201,6 +2210,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PAD,
 
+	NL80211_ATTR_STA_TX_POWER_SETTING,
+	NL80211_ATTR_STA_TX_POWER,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d759901..0ef7377 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -257,6 +257,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_STA_SUPPORTED_RATES] = { .type = NLA_BINARY,
 					       .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_STA_PLINK_ACTION] = { .type = NLA_U8 },
+	[NL80211_ATTR_STA_TX_POWER_SETTING] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_TX_POWER] = { .type = NLA_U32 },
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
@@ -4380,6 +4382,32 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.local_pm = pm;
 	}
 
+	if (info->attrs[NL80211_ATTR_STA_TX_POWER_SETTING]) {
+		enum nl80211_tx_power_setting type;
+		int idx;
+
+		if (!rdev->ops->set_tx_power)
+			return -EOPNOTSUPP;
+
+		idx = NL80211_ATTR_STA_TX_POWER_SETTING;
+		type = nla_get_u32(info->attrs[idx]);
+
+		if (!info->attrs[NL80211_ATTR_STA_TX_POWER] &&
+		    (type != NL80211_TX_POWER_AUTOMATIC))
+			return -EINVAL;
+
+		if (type != NL80211_TX_POWER_AUTOMATIC) {
+			if (type == NL80211_TX_POWER_LIMITED) {
+				idx = NL80211_ATTR_STA_TX_POWER;
+				params.txpwr = nla_get_u32(info->attrs[idx]);
+			} else {
+				return -EINVAL;
+			}
+		} else {
+			params.txpwr = 0;
+		}
+	}
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -4507,6 +4535,32 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_STA_TX_POWER_SETTING]) {
+		enum nl80211_tx_power_setting type;
+		int idx;
+
+		if (!rdev->ops->set_tx_power)
+			return -EOPNOTSUPP;
+
+		idx = NL80211_ATTR_STA_TX_POWER_SETTING;
+		type = nla_get_u32(info->attrs[idx]);
+
+		if (!info->attrs[NL80211_ATTR_STA_TX_POWER] &&
+		    (type != NL80211_TX_POWER_AUTOMATIC))
+			return -EINVAL;
+
+		if (type != NL80211_TX_POWER_AUTOMATIC) {
+			if (type == NL80211_TX_POWER_LIMITED) {
+				idx = NL80211_ATTR_STA_TX_POWER;
+				params.txpwr = nla_get_u32(info->attrs[idx]);
+			} else {
+				return -EINVAL;
+			}
+		} else {
+			params.txpwr = 0;
+		}
+	}
+
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;
-- 
1.9.1

