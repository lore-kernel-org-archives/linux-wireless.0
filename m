Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15598 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbE1G0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 02:26:24 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 1/2] nl80211: Add support to configure low ack threshold
Date: Thu, 28 May 2015 11:55:54 +0530
Message-ID: <1432794355-3639-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150528_082630_889060_A48B167F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new nl80211 attribute to configure low ack threshold (number of
consecutive frames) not being acked by station. This threshold is used
to kickout station by driver through low ack event. This allows user to
tune the parameter to improve robustness under noisy environment.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h |  9 +++++++++
 net/wireless/nl80211.c       | 13 +++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f8d6813..4e42b09 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -812,6 +812,8 @@ enum station_parameters_apply_mask {
  * @supported_oper_classes_len: number of supported operating classes
  * @opmode_notif: operating mode field from Operating Mode Notification
  * @opmode_notif_used: information if operating mode field is used
+ * @low_ack_threshold: number of consecutive frames not being ACKed by
+ *	station, used to trigger low_ack event.
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -837,6 +839,7 @@ struct station_parameters {
 	u8 supported_oper_classes_len;
 	u8 opmode_notif;
 	bool opmode_notif_used;
+	u16 low_ack_threshold;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 241220c..9ab3b01 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1761,6 +1761,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
  *      is operating in an indoor environment.
  *
+ * @NL80211_ATTR_STA_LOW_ACK_THRESH: number of consecutive frames that are not
+ *	ACKed by station. This threshold is used to generate low ack event
+ *	by driver.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2130,6 +2134,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_REG_INDOOR,
 
+	NL80211_ATTR_STA_LOW_ACK_THRESH,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4585,4 +4591,7 @@ enum nl80211_tdls_peer_capability {
 	NL80211_TDLS_PEER_WMM = 1<<2,
 };
 
+/* Default low ack threshold for station kickout event */
+#define NL80211_DEFAULT_LOW_ACK_THRESH    50
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dd78445..9ca2c18 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -400,6 +400,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_STA_LOW_ACK_THRESH] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -4281,6 +4282,12 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.local_pm = pm;
 	}
 
+	if (info->attrs[NL80211_ATTR_STA_LOW_ACK_THRESH])
+		params.low_ack_threshold = nla_get_u16(
+			info->attrs[NL80211_ATTR_STA_LOW_ACK_THRESH]);
+	else
+		params.low_ack_threshold = NL80211_DEFAULT_LOW_ACK_THRESH;
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -4389,6 +4396,12 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_STA_LOW_ACK_THRESH])
+		params.low_ack_threshold = nla_get_u16(
+			info->attrs[NL80211_ATTR_STA_LOW_ACK_THRESH]);
+	else
+		params.low_ack_threshold = NL80211_DEFAULT_LOW_ACK_THRESH;
+
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;
-- 
2.4.1

