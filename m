Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:22529 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab1AQQUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:04 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 09:31:03 +0100
Subject: [PATCH 1/5] mac80211: add DFS related channel flags
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161133.66B54207E@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before a radar channel can be used, a full CAC has be done, the
IEEE80211_CHAN_RADAR_CLEAR flags indicates that this has been done. If either
during CAC or in-service monitoring interference is detected, the channel is
added to NOL and marked with IEEE80211_CHAN_RADAR_INTERFERENCE.
---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |   18 ++++++++++++------
 net/wireless/nl80211.c  |    4 ++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e3c9ec7..acb3c33 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1371,6 +1371,10 @@ enum nl80211_band_attr {
  *	(100 * dBm).
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
+ * @NL80211_FREQUENCY_ATTR_RADAR_CLEAR: during a full CAC no interference has
+ *	been detected
+ * @NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE: either during a CAC or
+ *	in-service monitoring radar interference was detected
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_frequency_attr {
@@ -1381,6 +1385,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+	NL80211_FREQUENCY_ATTR_RADAR_CLEAR,
+	NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1322695..1e9a052 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -98,14 +98,20 @@ enum ieee80211_band {
  * 	is not permitted.
  * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
  * 	is not permitted.
+ * @IEEE80211_CHAN_RADAR_CLEAR: during a full CAC no interference has
+ *	been detected
+ * @IEEE80211_CHAN_RADAR_INTERFERENCE: either during a CAC or
+ *	in-service monitoring radar interference was detected
  */
 enum ieee80211_channel_flags {
-	IEEE80211_CHAN_DISABLED		= 1<<0,
-	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
-	IEEE80211_CHAN_NO_IBSS		= 1<<2,
-	IEEE80211_CHAN_RADAR		= 1<<3,
-	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
-	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
+	IEEE80211_CHAN_DISABLED			= 1<<0,
+	IEEE80211_CHAN_PASSIVE_SCAN		= 1<<1,
+	IEEE80211_CHAN_NO_IBSS			= 1<<2,
+	IEEE80211_CHAN_RADAR			= 1<<3,
+	IEEE80211_CHAN_NO_HT40PLUS		= 1<<4,
+	IEEE80211_CHAN_NO_HT40MINUS		= 1<<5,
+	IEEE80211_CHAN_RADAR_CLEAR		= 1<<6,
+	IEEE80211_CHAN_RADAR_INTERFERENCE	= 1<<7,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f4eb3ea..0524423 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -307,6 +307,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
 	if (chan->flags & IEEE80211_CHAN_RADAR)
 		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
+	if (chan->flags & IEEE80211_CHAN_RADAR_CLEAR)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_CLEAR);
+	if (chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE);
 
 	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 		    DBM_TO_MBM(chan->max_power));
-- 
1.5.6.5

