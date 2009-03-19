Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbZCSFyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 01:54:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 6/6] cfg80211: send to userspace if HT40-/+ is allowed on each channel
Date: Thu, 19 Mar 2009 01:54:40 -0400
Message-Id: <1237442080-27509-7-git-send-email-lrodriguez@atheros.com> (sfid-20090319_065451_460707_CA66AF1E)
In-Reply-To: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   15 +++++++++++++++
 net/wireless/nl80211.c  |    6 ++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3924fe4..f00ebff 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -671,6 +671,15 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
  *	(100 * dBm).
  * @NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH: max bandwidth allowed, given in MHz
+ * @NL80211_FREQUENCY_ATTR_NOHT40: HT40 operation is not permitted on
+ * 	this channel, this is would indicate the regulatory domain did
+ * 	not allow for HT40 operation.
+ * @NL80211_FREQUENCY_ATTR_NO_HT40MINUS: HT40- operation is not permitted on
+ * 	this channel. This could be due to regulatory domain restrictions or
+ * 	when the channel is on a band edge, towards the beginning.
+ * @NL80211_FREQUENCY_ATTR_NO_HT40PLUS: HT40+ operation is not permitted on
+ * 	this channel. This could be due to regulatory domain restrictions or
+ * 	when the channel is on a band edge, towards the end.
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -681,6 +690,9 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 	NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH,
+	NL80211_FREQUENCY_ATTR_NO_HT40,
+	NL80211_FREQUENCY_ATTR_NO_HT40MINUS,
+	NL80211_FREQUENCY_ATTR_NO_HT40PLUS,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -689,6 +701,9 @@ enum nl80211_frequency_attr {
 
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
 #define NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH
+#define NL80211_FREQUENCY_ATTR_NO_HT40 NL80211_FREQUENCY_ATTR_NO_HT40
+#define NL80211_FREQUENCY_ATTR_NO_HT40MINUS NL80211_FREQUENCY_ATTR_NO_HT40MINUS
+#define NL80211_FREQUENCY_ATTR_NO_HT40PLUS NL80211_FREQUENCY_ATTR_NO_HT40PLUS
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e2727ee..108e1ee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -208,6 +208,12 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
 			if (chan->flags & IEEE80211_CHAN_RADAR)
 				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
+			if (chan->flags & IEEE80211_CHAN_NO_HT40)
+				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_HT40);
+			if (chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_HT40MINUS);
+			if (chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_HT40PLUS);
 			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 				    DBM_TO_MBM(chan->max_power));
 			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH,
-- 
1.6.0.6

