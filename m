Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2469 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3JILo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 07:44:29 -0400
From: Sunil Dutt <c_duttus@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <j@w1.fi.com>, <linux-wireless@vger.kernel.org>,
	<c_duttus@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Pass station supported channel and oper class info to kernel
Date: Wed, 9 Oct 2013 17:13:31 +0530
Message-ID: <1381319011-7714-1-git-send-email-c_duttus@qti.qualcomm.com> (sfid-20131009_134433_116806_49336B91)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The information of the peer's supported channels and supported operating
classes are required for the driver to perform TDLS off channel
operations. This commit enhances the function nl80211_(new)set_station
to pass this information of the peer to the driver.
---
 include/net/cfg80211.h       |  8 ++++++++
 include/uapi/linux/nl80211.h |  9 +++++++++
 net/wireless/nl80211.c       | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cb71091..b1cfc93 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -735,6 +735,10 @@ enum station_parameters_apply_mask {
  * @capability: station capability
  * @ext_capab: extended capabilities of the station
  * @ext_capab_len: number of extended capabilities
+ * @supported_channels: supported channels in IEEE 802.11 format
+ * @supported_channels_len: number of supported channels
+ * @supported_oper_classes: supported oper classes in IEEE 802.11 format
+ * @supported_oper_classes_len: number of supported operating classes
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -754,6 +758,10 @@ struct station_parameters {
 	u16 capability;
 	const u8 *ext_capab;
 	u8 ext_capab_len;
+	const u8 *supported_channels;
+	u8 supported_channels_len;
+	const u8 *supported_oper_classes;
+	u8 supported_oper_classes_len;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..aec9a8a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1496,6 +1496,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
  *	As specified in the &enum nl80211_rxmgmt_flags.
  *
+ * @NL80211_ATTR_STA_SUPPORTED_CHANNELS: array of supported channels.
+ *
+ * @NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES: array of supported
+ *      supported operating classes.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1806,6 +1811,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RXMGMT_FLAGS,
 
+	NL80211_ATTR_STA_SUPPORTED_CHANNELS,
+
+	NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 626dc3b..c234836 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,6 +354,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
+	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 };
 
 /* policy for the key attributes */
@@ -3896,9 +3898,43 @@ static int nl80211_parse_sta_wme(struct genl_info *info,
 	return 0;
 }
 
+static int nl80211_parse_sta_channel_info(struct genl_info *info,
+				      struct station_parameters *params)
+{
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]) {
+		params->supported_channels =
+		     nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
+		params->supported_channels_len =
+		     nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
+		/*
+		 * Need to include at least One (first channel, number of
+		 * channels) tuple for each subband.Thus, reject any trailing
+		 * byte.
+		 */
+		if (params->supported_channels_len % 2)
+			params->supported_channels_len -= 1;
+	}
+
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]) {
+		params->supported_oper_classes =
+		 nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
+		params->supported_oper_classes_len =
+		  nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
+		/*
+		 * The value of the Length field of the Supported Operating
+		 * Classes element is between 2 and 253.
+		 */
+		if (params->supported_oper_classes_len < 2 ||
+		    params->supported_oper_classes_len > 253)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 static int nl80211_set_station_tdls(struct genl_info *info,
 				    struct station_parameters *params)
 {
+	int err;
 	/* Dummy STA entry gets updated once the peer capabilities are known */
 	if (info->attrs[NL80211_ATTR_PEER_AID])
 		params->aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
@@ -3909,6 +3945,10 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 		params->vht_capa =
 			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
 
+	err = nl80211_parse_sta_channel_info(info, params);
+	if (err)
+		return err;
+
 	return nl80211_parse_sta_wme(info, params);
 }
 
@@ -4089,6 +4129,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	err = nl80211_parse_sta_channel_info(info, &params);
+	if (err)
+		return err;
+
 	err = nl80211_parse_sta_wme(info, &params);
 	if (err)
 		return err;
-- 
1.8.2.1

