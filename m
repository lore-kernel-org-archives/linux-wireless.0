Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30604 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3H0FtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 01:49:05 -0400
From: Sunil Dutt <c_duttus@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <j@w1.fi>
Subject: [PATCH] cfg80211: Pass station supported channel and oper class info to kernel
Date: Tue, 27 Aug 2013 11:14:38 +0530
Message-ID: <1377582278-3768-1-git-send-email-c_duttus@qti.qualcomm.com> (sfid-20130827_074909_776037_7D285F8D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The information of the peer's supported channels and supported operating
classes are required for the driver to perform TDLS off channel
operations. This commit enhances the function nl80211_(new)set_station
to pass this information of the peer to the driver.

Signed-off-by: Sunil Dutt <c_duttus@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  8 ++++++++
 include/uapi/linux/nl80211.h |  9 +++++++++
 net/wireless/nl80211.c       | 30 ++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9ab7a06..81889ca 100644
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
index 1f42bc3..61a21a4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1493,6 +1493,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_CSA_C_OFF_PRESP: Offset of the channel switch counter
  *	field in the probe response (%NL80211_ATTR_PROBE_RESP).
  *
+ * @NL80211_ATTR_STA_SUPPORTED_CHANNELS: array of supported channels.
+ *
+ * @NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES: array of supported
+ *      supported operating classes.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1801,6 +1806,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_CSA_C_OFF_BEACON,
 	NL80211_ATTR_CSA_C_OFF_PRESP,
 
+	NL80211_ATTR_STA_SUPPORTED_CHANNELS,
+
+	NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 741368c..0765b9a 100644
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
@@ -3909,6 +3911,20 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 		params->vht_capa =
 			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]) {
+		params->supported_channels =
+		     nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
+		params->supported_channels_len =
+		     nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
+	}
+
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]) {
+		params->supported_oper_classes =
+		 nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
+		params->supported_oper_classes_len =
+		  nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
+	}
+
 	return nl80211_parse_sta_wme(info, params);
 }
 
@@ -4089,6 +4105,20 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]) {
+		params->supported_channels =
+		     nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
+		params->supported_channels_len =
+		     nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
+	}
+
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]) {
+		params->supported_oper_classes =
+		 nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
+		params->supported_oper_classes_len =
+		  nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
+	}
+
 	err = nl80211_parse_sta_wme(info, &params);
 	if (err)
 		return err;
-- 
1.8.2.1

