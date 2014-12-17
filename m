Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36818 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLQN6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/9] cfg80211: allow survey data to return global data
Date: Wed, 17 Dec 2014 14:57:52 +0100
Message-Id: <1418824679-31530-3-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145824_499407_85AFE6C3)
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Not all devices are able to report survey data (particularly
time spent for various operations) per channel. As all these
statistics already exist in survey data, allow such devices
to report them (if userspace requested it)

Change-Id: I90795632de9427e62a740c7910536149d37058cb
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  3 ++-
 include/uapi/linux/nl80211.h | 16 +++++++++++++---
 net/wireless/nl80211.c       | 31 ++++++++++++++++++-------------
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 27117a78656e..3db6a9990ebd 100644
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
index 4bf0805ba419..35242ad7be0b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1710,6 +1710,14 @@ enum nl80211_commands {
  *	obtained from it is coming from the device's wiphy and not the global
  *	cfg80211 regdomain.
  *
+ * @NL80211_ATTR_SURVEY_RADIO_STATS: Request overall radio statistics to be
+ *	returned along with other survey data. If set, @NL80211_CMD_GET_SURVEY
+ *	may return a survey entry without a channel indicating global radio
+ *	statistics (only some values are valid and make sense.)
+ *	For devices that don't return such an entry even then, the information
+ *	should be contained in the result as the sum of the respective counters
+ *	over all channels.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2069,6 +2077,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
 
+	NL80211_ATTR_SURVEY_RADIO_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2797,15 +2807,15 @@ enum nl80211_user_reg_hint_type {
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
index 40e0b33941ce..22085e0cd70a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6602,12 +6602,17 @@ static int nl80211_dump_scan(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -6620,7 +6625,8 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
 	if (!infoattr)
 		goto nla_put_failure;
 
-	if (nla_put_u32(msg, NL80211_SURVEY_INFO_FREQUENCY,
+	if (survey->channel &&
+	    nla_put_u32(msg, NL80211_SURVEY_INFO_FREQUENCY,
 			survey->channel->center_freq))
 		goto nla_put_failure;
 
@@ -6660,19 +6666,22 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
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
@@ -6690,13 +6699,9 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 		if (res)
 			goto out_err;
 
-		/* Survey without a channel doesn't make sense */
-		if (!survey.channel) {
-			res = -EINVAL;
-			goto out;
-		}
-
-		if (survey.channel->flags & IEEE80211_CHAN_DISABLED) {
+		/* don't send disabled channels, but do send non-channel data */
+		if (survey.channel &&
+		    survey.channel->flags & IEEE80211_CHAN_DISABLED) {
 			survey_idx++;
 			continue;
 		}
@@ -6704,7 +6709,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
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

