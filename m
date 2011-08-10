Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22558 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1HJUxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:53:37 -0400
Date: Wed, 10 Aug 2011 23:53:31 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] nl80211/cfg80211: Allow SSID to be specified in new
 beacon command
Message-ID: <20110810205331.GA2911@jouni.qca.qualcomm.com> (sfid-20110810_225344_906762_02EB0821)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier for drivers that generate Beacon and Probe Response
frames internally (in firmware most likely) in AP mode.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/nl80211.h |   24 ++++++++++++++++++++++++
 include/net/cfg80211.h  |    7 +++++++
 net/wireless/nl80211.c  |   29 +++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8ad70dc..227ee9a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -161,6 +161,9 @@
  * @NL80211_CMD_SET_BEACON: set the beacon on an access point interface
  *	using the %NL80211_ATTR_BEACON_INTERVAL, %NL80211_ATTR_DTIM_PERIOD,
  *	%NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL attributes.
+ *	Following attributes are provided for drivers that generate full Beacon
+ *	and Probe Response frames internally: %NL80211_ATTR_SSID,
+ *	%NL80211_ATTR_HIDDEN_SSID.
  * @NL80211_CMD_NEW_BEACON: add a new beacon to an access point interface,
  *	parameters are like for %NL80211_CMD_SET_BEACON.
  * @NL80211_CMD_DEL_BEACON: remove the beacon, stop sending it
@@ -1019,6 +1022,10 @@ enum nl80211_commands {
  *	being a list of supported rates as defined by IEEE 802.11 7.3.2.2 but
  *	without the length restriction (at most %NL80211_MAX_SUPP_RATES).
  *
+ * @NL80211_ATTR_HIDDEN_SSID: indicates whether SSID is to be hidden from Beacon
+ *	and Probe Response (when response to wildcard Probe Request); see
+ *	&enum nl80211_hidden_ssid, represented as a u32
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1224,6 +1231,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_SUPP_RATES,
 
+	NL80211_ATTR_HIDDEN_SSID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2430,4 +2439,19 @@ enum nl80211_rekey_data {
 	MAX_NL80211_REKEY_DATA = NUM_NL80211_REKEY_DATA - 1
 };
 
+/**
+ * enum nl80211_hidden_ssid - values for %NL80211_ATTR_HIDDEN_SSID
+ * @NL80211_HIDDEN_SSID_NOT_IN_USE: do not hide SSID (i.e., broadcast it in
+ *	Beacon frames)
+ * @NL80211_HIDDEN_SSID_ZERO_LEN: hide SSID by using zero-length SSID element
+ *	in Beacon frames
+ * @NL80211_HIDDEN_SSID_ZERO_CONTENTS: hide SSID by using correct length of SSID
+ *	element in Beacon frames but zero out each byte in the SSID
+ */
+enum nl80211_hidden_ssid {
+	NL80211_HIDDEN_SSID_NOT_IN_USE,
+	NL80211_HIDDEN_SSID_ZERO_LEN,
+	NL80211_HIDDEN_SSID_ZERO_CONTENTS
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 779e300..27c5eec 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -346,11 +346,18 @@ struct survey_info {
  * @dtim_period: DTIM period or zero if not changed
  * @head_len: length of @head
  * @tail_len: length of @tail
+ * @ssid: SSID to be used in the BSS (note: may be %NULL if not provided from
+ *	user space)
+ * @ssid_len: length of @ssid
+ * @hidden_ssid: whether to hide the SSID in Beacon/Probe Response frames
  */
 struct beacon_parameters {
 	u8 *head, *tail;
 	int interval, dtim_period;
 	int head_len, tail_len;
+	const u8 *ssid;
+	size_t ssid_len;
+	enum nl80211_hidden_ssid hidden_ssid;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ca76977..c2d7a9a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -178,6 +178,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_REKEY_DATA] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SCAN_SUPP_RATES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_HIDDEN_SSID] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -2010,6 +2011,34 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
 		if (err)
 			return err;
 
+		/*
+		 * In theory, some of these attributes could be required for
+		 * NEW_BEACON, but since they were not used when the command was
+		 * originally added, keep them optional for old user space
+		 * programs to work with drivers that do not need the additional
+		 * information.
+		 */
+		if (info->attrs[NL80211_ATTR_SSID]) {
+			params.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+			params.ssid_len =
+				nla_len(info->attrs[NL80211_ATTR_SSID]);
+			if (params.ssid_len == 0 ||
+			    params.ssid_len > IEEE80211_MAX_SSID_LEN)
+				return -EINVAL;
+		}
+
+		if (info->attrs[NL80211_ATTR_HIDDEN_SSID]) {
+			params.hidden_ssid = nla_get_u32(
+				info->attrs[NL80211_ATTR_HIDDEN_SSID]);
+			if (params.hidden_ssid !=
+			    NL80211_HIDDEN_SSID_NOT_IN_USE &&
+			    params.hidden_ssid !=
+			    NL80211_HIDDEN_SSID_ZERO_LEN &&
+			    params.hidden_ssid !=
+			    NL80211_HIDDEN_SSID_ZERO_CONTENTS)
+				return -EINVAL;
+		}
+
 		call = rdev->ops->add_beacon;
 		break;
 	case NL80211_CMD_SET_BEACON:
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
