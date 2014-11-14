Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50549 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965288AbaKNQB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 11:01:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/3] cfg80211: allow survey data to return global data
Date: Fri, 14 Nov 2014 17:01:49 +0100
Message-Id: <1415980910-9105-2-git-send-email-johannes@sipsolutions.net> (sfid-20141114_170203_466794_028ACEAC)
In-Reply-To: <1415980910-9105-1-git-send-email-johannes@sipsolutions.net>
References: <1415980910-9105-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Not all devices are able to report survey data (particularly
time spent for various operations) per channel. As all these
statistics already exist in survey data, allow such devices
to report them (if userspace requested it)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  3 ++-
 include/uapi/linux/nl80211.h | 16 +++++++++++++---
 net/wireless/nl80211.c       | 21 +++++++++++++++------
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15c720c2962c..07fafce7dc83 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -542,7 +542,8 @@ enum survey_info_flags {
 /**
  * struct survey_info - channel survey response
  *
- * @channel: the channel this survey record reports, mandatory
+ * @channel: the channel this survey record reports, may be %NULL for a single
+ *	record to report global statistics
  * @filled: bitflag of flags from &enum survey_info_flags
  * @noise: channel noise in dBm. This and all following fields are
  *	optional
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2e484938e36f..92593e4e3c85 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1669,6 +1669,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
  *	&enum nl80211_smps_mode.
  *
+ * @NL80211_ATTR_SURVEY_RADIO_STATS: Request overall radio statistics to be
+ *	returned along with other survey data. If set, @NL80211_CMD_GET_SURVEY
+ *	may return a survey entry without a channel indicating global radio
+ *	statistics (only some values are valid and make sense.)
+ *	For devices that don't return such an entry even then, the information
+ *	should be contained in the result as the sum of the respective counters
+ *	over all channels.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -2021,6 +2029,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SMPS_MODE,
 
+	NL80211_ATTR_SURVEY_RADIO_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2747,15 +2757,15 @@ enum nl80211_user_reg_hint_type {
  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
  * @NL80211_SURVEY_INFO_IN_USE: channel is currently being used
  * @NL80211_SURVEY_INFO_TIME: amount of time (in ms) that the radio
- *	spent on this channel
+ *	was turned on (on channel or globally)
  * @NL80211_SURVEY_INFO_TIME_BUSY: amount of the time the primary
  *	channel was sensed busy (either due to activity or energy detect)
  * @NL80211_SURVEY_INFO_TIME_EXT_BUSY: amount of time the extension
  *	channel was sensed busy
  * @NL80211_SURVEY_INFO_TIME_RX: amount of time the radio spent
- *	receiving data
+ *	receiving data (on channel or globally)
  * @NL80211_SURVEY_INFO_TIME_TX: amount of time the radio spent
- *	transmitting data
+ *	transmitting data (on channel or globally)
  * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
  *	currently defined
  * @__NL80211_SURVEY_INFO_AFTER_LAST: internal use
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48e695cba4b0..6aba8de1e032 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6346,12 +6346,17 @@ static int nl80211_dump_scan(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
-				int flags, struct net_device *dev,
-				struct survey_info *survey)
+			       int flags, struct net_device *dev,
+			       bool allow_radio_stats,
+			       struct survey_info *survey)
 {
 	void *hdr;
 	struct nlattr *infoattr;
 
+	/* skip radio stats if userspace didn't request them */
+	if (!survey->channel && !allow_radio_stats)
+		return 0;
+
 	hdr = nl80211hdr_put(msg, portid, seq, flags,
 			     NL80211_CMD_NEW_SURVEY_RESULTS);
 	if (!hdr)
@@ -6364,7 +6369,8 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
 	if (!infoattr)
 		goto nla_put_failure;
 
-	if (nla_put_u32(msg, NL80211_SURVEY_INFO_FREQUENCY,
+	if (survey->channel &&
+	    nla_put_u32(msg, NL80211_SURVEY_INFO_FREQUENCY,
 			survey->channel->center_freq))
 		goto nla_put_failure;
 
@@ -6404,19 +6410,22 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
 	return -EMSGSIZE;
 }
 
-static int nl80211_dump_survey(struct sk_buff *skb,
-			struct netlink_callback *cb)
+static int nl80211_dump_survey(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct survey_info survey;
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 	int survey_idx = cb->args[2];
 	int res;
+	bool radio_stats;
 
 	res = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
 	if (res)
 		return res;
 
+	/* prepare_wdev_dump parsed the attributes */
+	radio_stats = nl80211_fam.attrbuf[NL80211_ATTR_SURVEY_RADIO_STATS];
+
 	if (!wdev->netdev) {
 		res = -EINVAL;
 		goto out_err;
@@ -6452,7 +6461,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 		if (nl80211_send_survey(skb,
 				NETLINK_CB(cb->skb).portid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				wdev->netdev, &survey) < 0)
+				wdev->netdev, radio_stats, &survey) < 0)
 			goto out;
 		survey_idx++;
 	}
-- 
2.1.1

