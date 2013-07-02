Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3GBNb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 09:31:27 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, David Spinadel <david.spinadel@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 1/3] [RFC] cfg80211: Add indoor only and GO concurrent channel attributes
Date: Tue,  2 Jul 2013 15:28:13 +0300
Message-Id: <1372768095-26053-2-git-send-email-ilan.peer@intel.com> (sfid-20130702_153130_312376_44DC1EB0)
In-Reply-To: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

The FCC are clarifying some soft configuration requirements,
which among other includes the following:

1. Concurrent GO operation, where devices may support WFD in
   bands where an authorized master (for example with DFS and
   DFS and radar detection capability in the UNII band) is operating.
2. Indoor operation, where in bands requiring indoor operation, the
   device must be programmed to detect indoor operation, or
   - Device must be connected to AC Power
   - Device must be under the control of a local master that is acting
     as an AP and is connected to AC Power.

See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122

Add support for advertising Indoor-only and Concurrent-GO channel
properties.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h       |    6 ++++++
 include/uapi/linux/nl80211.h |    7 +++++++
 net/wireless/nl80211.c       |    6 ++++++
 3 files changed, 19 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b0730a..f0badeb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -110,6 +110,10 @@ enum ieee80211_band {
  *	channel as the control or any of the secondary channels.
  *	This may be due to the driver or due to regulatory bandwidth
  *	restrictions.
+ * @IEEE80211_CHAN_INDOOR_ONLY: Only indoor use is permitted on this channel.
+ * @IEEE80211_CHAN_GO_CONCURRENT: GO operation is allowed on this channel if
+ *	it's connected concurrently to a BSS on the same channel on 2.4 or
+ *	to a channel in the same UNII band on 5.2.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -121,6 +125,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
 	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
+	IEEE80211_CHAN_INDOOR_ONLY	= 1<<9,
+	IEEE80211_CHAN_GO_CONCURRENT	= 1<<10,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 861e5eb..09a4f6b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2158,6 +2158,11 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_INDOOR_ONLY: Indoor only use is permitted
+ *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_GO_CONCURRENT: GO operation is allowed on this
+ *      channel if it's connected concurrently to a BSS on the same channel on
+ *      2.4 or to a channel in the same UNII band on 5.2.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2176,6 +2181,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_INDOOR_ONLY,
+	NL80211_FREQUENCY_ATTR_GO_CONCURRENT,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7dc3343..cf22b22 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -563,6 +563,12 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_INDOOR_ONLY) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_INDOOR_ONLY))
+			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_GO_CONCURRENT) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_GO_CONCURRENT))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-- 
1.7.10.4

