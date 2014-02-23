Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16159 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaBWHKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 02:10:55 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, David Spinadel <david.spinadel@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v6 1/5] cfg80211: Add indoor only and GO concurrent channel attributes
Date: Sun, 23 Feb 2014 09:12:59 +0200
Message-Id: <1393139583-7249-2-git-send-email-ilan.peer@intel.com> (sfid-20140223_081117_168828_425BC38B)
In-Reply-To: <1393139583-7249-1-git-send-email-ilan.peer@intel.com>
References: <1393139583-7249-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

The FCC are clarifying some soft configuration requirements,
which among other include the following:

1. Indoor operation, where a device can use channels requiring indoor
   operation, subject to that it can guarantee indoor operation,
   i.e., the device is connected to AC Power or the device is under
   the control of a local master that is acting as an AP and is
   connected to AC Power.
2. Concurrent GO operation, where devices may instantiate a P2P GO
   while they are under the guidance of an authorized master. For example,
   on a channel on which a BSS is connected to an authorized master, i.e.,
   with DFS and radar detection capability in the UNII band.

See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122

Add support for advertising Indoor-only and GO-Concurrent channel
properties.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h       |    5 +++++
 include/uapi/linux/nl80211.h |   23 +++++++++++++++++++++++
 net/wireless/nl80211.c       |    6 ++++++
 net/wireless/reg.c           |    2 ++
 4 files changed, 36 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f90554..2ba017c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -109,6 +109,9 @@ enum ieee80211_band {
  *	channel as the control or any of the secondary channels.
  *	This may be due to the driver or due to regulatory bandwidth
  *	restrictions.
+ * @IEEE80211_CHAN_INDOOR_ONLY: see %NL80211_FREQUENCY_ATTR_INDOOR_ONLY
+ * @IEEE80211_CHAN_GO_CONCURRENT: see %NL80211_FREQUENCY_ATTR_GO_CONCURRENT
+ *
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -120,6 +123,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
 	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
+	IEEE80211_CHAN_INDOOR_ONLY	= 1<<9,
+	IEEE80211_CHAN_GO_CONCURRENT	= 1<<10,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a12e6ca..061f8d4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2329,9 +2329,30 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_INDOOR_ONLY: Only indoor use is permitted on this
+ *	channel. A channel that has the INDOOR_ONLY attribute can only be
+ *	used when there is a clear assessment that the device is operating in
+ *	an indoor surroundings, i.e., it is connected to AC power (and not
+ *	through portable DC inverters) or is under the control of a master
+ *	that is acting as an AP and is connected to AC power.
+ * @NL80211_FREQUENCY_ATTR_GO_CONCURRENT: GO operation is allowed on this
+ *	channel if it's connected concurrently to a BSS on the same channel on
+ *	the 2 GHz band or to a channel in the same UNII band (on the 5 GHz
+ *	band), and IEEE80211_CHAN_RADAR is not set. Instantiating a GO on a
+ *	channel that has the GO_CONCURRENT attribute set can be done when there
+ *	is a clear assessment that the device is operating under the guidance of
+ *	an authorized master, i.e., setting up a GO while the device is also
+ *	connected to an AP with DFS and radar detection on the UNII band (it is
+ *	up to user-space, i.e., wpa_supplicant to perform the required
+ *	verifications)
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
+ *
+ * See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122
+ * for more information on the FCC description of the relaxations allowed
+ * by NL80211_FREQUENCY_ATTR_INDOOR_ONLY and
+ * NL80211_FREQUENCY_ATTR_GO_CONCURRENT.
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -2347,6 +2368,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_INDOOR_ONLY,
+	NL80211_FREQUENCY_ATTR_GO_CONCURRENT,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8e6b6a2..95a8c72 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -608,6 +608,12 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
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
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index cb7ade9..6cdf3cc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -867,6 +867,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_RADAR;
 	if (rd_flags & NL80211_RRF_NO_OFDM)
 		channel_flags |= IEEE80211_CHAN_NO_OFDM;
+	if (rd_flags & NL80211_RRF_NO_OUTDOOR)
+		channel_flags |= IEEE80211_CHAN_INDOOR_ONLY;
 	return channel_flags;
 }
 
-- 
1.7.10.4

