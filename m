Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40926 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759990Ab0JIAjg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 20:39:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: lrodriguez@atheros.com, br1@einfach.org
Subject: [PATCH 1/3] cfg80211: add channel utilization stats to the survey command
Date: Sat,  9 Oct 2010 02:39:29 +0200
Message-Id: <1286584771-76663-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using these, user space can calculate a relative channel utilization
with arbitrary intervals by regularly taking snapshots of the survey
results.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/nl80211.h |   15 +++++++++++++++
 include/net/cfg80211.h  |   20 ++++++++++++++++++++
 net/wireless/nl80211.c  |   15 +++++++++++++++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index c08709f..0edb256 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1413,6 +1413,16 @@ enum nl80211_reg_rule_flags {
  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
  * @NL80211_SURVEY_INFO_IN_USE: channel is currently being used
+ * @NL80211_SURVEY_INFO_CHANNEL_TIME: amount of time (in ms) that the radio
+ *	spent on this channel
+ * @NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY: amount of the time the primary
+ *	channel was sensed busy (either due to activity or energy detect)
+ * @NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY: amount of time the extension
+ *	channel was sensed busy
+ * @NL80211_SURVEY_INFO_CHANNEL_TIME_RX: amount of time the radio spent
+ *	receiving data
+ * @NL80211_SURVEY_INFO_CHANNEL_TIME_TX: amount of time the radio spent
+ *	transmitting data
  * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
  *	currently defined
  * @__NL80211_SURVEY_INFO_AFTER_LAST: internal use
@@ -1422,6 +1432,11 @@ enum nl80211_survey_info {
 	NL80211_SURVEY_INFO_FREQUENCY,
 	NL80211_SURVEY_INFO_NOISE,
 	NL80211_SURVEY_INFO_IN_USE,
+	NL80211_SURVEY_INFO_CHANNEL_TIME,
+	NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY,
+	NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY,
+	NL80211_SURVEY_INFO_CHANNEL_TIME_RX,
+	NL80211_SURVEY_INFO_CHANNEL_TIME_TX,
 
 	/* keep last */
 	__NL80211_SURVEY_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0778d04..a2cf04f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -294,6 +294,11 @@ struct key_params {
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
  * @SURVEY_INFO_IN_USE: channel is currently being used
+ * @SURVEY_INFO_CHANNEL_TIME: channel active time (in ms) was filled in
+ * @SURVEY_INFO_CHANNEL_TIME_BUSY: channel busy time was filled in
+ * @SURVEY_INFO_CHANNEL_TIME_EXT_BUSY: extension channel busy time was filled in
+ * @SURVEY_INFO_CHANNEL_TIME_RX: channel receive time was filled in
+ * @SURVEY_INFO_CHANNEL_TIME_TX: channel transmit time was filled in
  *
  * Used by the driver to indicate which info in &struct survey_info
  * it has filled in during the get_survey().
@@ -301,6 +306,11 @@ struct key_params {
 enum survey_info_flags {
 	SURVEY_INFO_NOISE_DBM = 1<<0,
 	SURVEY_INFO_IN_USE = 1<<1,
+	SURVEY_INFO_CHANNEL_TIME = 1<<2,
+	SURVEY_INFO_CHANNEL_TIME_BUSY = 1<<3,
+	SURVEY_INFO_CHANNEL_TIME_EXT_BUSY = 1<<4,
+	SURVEY_INFO_CHANNEL_TIME_RX = 1<<5,
+	SURVEY_INFO_CHANNEL_TIME_TX = 1<<6,
 };
 
 /**
@@ -310,6 +320,11 @@ enum survey_info_flags {
  * @filled: bitflag of flags from &enum survey_info_flags
  * @noise: channel noise in dBm. This and all following fields are
  *     optional
+ * @channel_time: amount of time in ms the radio spent on the channel
+ * @channel_time_busy: amount of time the primary channel was sensed busy
+ * @channel_time_ext_busy: amount of time the extension channel was sensed busy
+ * @channel_time_rx: amount of time the radio spent receiving data
+ * @channel_time_tx: amount of time the radio spent transmitting data
  *
  * Used by dump_survey() to report back per-channel survey information.
  *
@@ -318,6 +333,11 @@ enum survey_info_flags {
  */
 struct survey_info {
 	struct ieee80211_channel *channel;
+	u64 channel_time;
+	u64 channel_time_busy;
+	u64 channel_time_ext_busy;
+	u64 channel_time_rx;
+	u64 channel_time_tx;
 	u32 filled;
 	s8 noise;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 882dc92..c506241 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3153,6 +3153,21 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 pid, u32 seq,
 			    survey->noise);
 	if (survey->filled & SURVEY_INFO_IN_USE)
 		NLA_PUT_FLAG(msg, NL80211_SURVEY_INFO_IN_USE);
+	if (survey->filled & SURVEY_INFO_CHANNEL_TIME)
+		NLA_PUT_U64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME,
+			    survey->channel_time);
+	if (survey->filled & SURVEY_INFO_CHANNEL_TIME_BUSY)
+		NLA_PUT_U64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY,
+			    survey->channel_time_busy);
+	if (survey->filled & SURVEY_INFO_CHANNEL_TIME_EXT_BUSY)
+		NLA_PUT_U64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY,
+			    survey->channel_time_ext_busy);
+	if (survey->filled & SURVEY_INFO_CHANNEL_TIME_RX)
+		NLA_PUT_U64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_RX,
+			    survey->channel_time_rx);
+	if (survey->filled & SURVEY_INFO_CHANNEL_TIME_TX)
+		NLA_PUT_U64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_TX,
+			    survey->channel_time_tx);
 
 	nla_nest_end(msg, infoattr);
 
-- 
1.7.2.2

