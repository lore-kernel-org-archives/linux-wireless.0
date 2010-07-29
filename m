Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:38090 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751838Ab0G2D60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 23:58:26 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0948555904
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 12:58:25 +0900 (JST)
Subject: [PATCH v5] cfg80211: Add nl80211 antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, mcgrof@gmail.com, linux-wireless@vger.kernel.org
Date: Thu, 29 Jul 2010 12:58:38 +0900
Message-ID: <20100729035820.5930.29864.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting of TX and RX antenna configuration via nl80211.

The antenna configuration is defined as a bitmap of allowed antennas to use.
This API can be used to mask out antennas which are not attached or should not
be used for other reasons like regulatory concerns or special setups.

Separate bitmaps are used for RX and TX to allow configuring different antennas
for receiving and transmitting. The bitmap is 8 bit long, each bit representing
one antenna, starting with antenna 1 at the first bit. If an antenna bit is
set, this means the driver is allowed to use this antenna for RX or TX
respectively; if the bit is not set the hardware is not allowed to use this
antenna.

Using bitmaps has the benefit of allowing for a flexible configuration
interface which can support many different configurations and which can be used
for 802.11n as well as non-802.11n devices. Instead of relying on some hardware
specific assumptions, drivers can use this information to know which antennas
are actually attached to the system and derive their capabilities based on
that.

802.11n devices should enable or disable chains, based on which antennas are
present (If all antennas belonging to a particular chain are disabled, the
entire chain should be disabled). HT capabilities (like STBC, TX Beamforming,
Antenna selection) should be calculated based on the available chains after
applying the antenna masks. Should a 802.11n device have diversity antennas
attached to one of their chains, diversity can be enabled or disabled based on
the antenna information.

Non-802.11n drivers can use the antenna masks to enable or disable antenna
diversity.

While covering chainmasks for 802.11n and the standard "legacy" modes "fixed
antenna 1", "fixed antenna 2" and "diversity" this API also allows more rare,
but useful configurations as follows:

1) Send on antenna 1, receive on antenna 2 (or vice versa). This can be used to
have a low gain antenna for TX in order to keep within the regulatory
constraints and a high gain antenna for RX in order to receive weaker signals
("speak softly, but listen harder"). This can be useful for building long-shot
outdoor links. Another usage of this setup is having a low-noise pre-amplifier
on antenna 1 and a power amplifier on the other antenna. This way transmit
noise is mostly kept out of the low noise receive channel.
(This would be bitmaps: tx 1 rx 2).

2) Another similar setup is: Use RX diversity on both antennas, but always send
on antenna 1. Again that would allow us to benefit from a higher gain RX
antenna, while staying within the legal limits.
(This would be: tx 0 rx 3).

3) And finally there can be special experimental setups in research and
development even with pre 802.11n hardware where more than 2 antennas are
available. It's good to keep the API simple, yet flexible.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

v5: Removed the special casing of "0" for diversity. I hope i made the
descriptions more clear and incorportated all comments concerning 802.11n. If
we can agree on this i will re-send the whole series.

---
 include/linux/nl80211.h |   25 +++++++++++++++++++++++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |   30 +++++++++++++++++++++++++++++-
 3 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2c87016..8a88921 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -731,6 +731,28 @@ enum nl80211_commands {
  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
  *      for non-automatic settings.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for transmitting.
+ *	This can be used to mask out antennas which are not attached or should
+ *	not be used for transmitting. If an antenna is not selected in this
+ *	bitmap the hardware is not allowed to transmit on this antenna.
+ *
+ *	Each bit represents one antenna, starting with antenna 1 at the first
+ *	bit. Depending on which antennas are selected in the bitmap, 802.11n
+ *	drivers can derive which chainmasks to use (if all antennas belonging to
+ *	a particular chain are disabled this chain should be disabled) and if
+ *	a chain has diversity antennas wether diversity should be used or not.
+ *	HT capabilities (STBC, TX Beamforming, Antenna selection) can be
+ *	derived from the available chains after applying the antenna mask.
+ *	Non-802.11n drivers can derive wether to use diversity or not.
+ *	Drivers may reject configurations or RX/TX mask combinations they cannot
+ *	support by returning -EINVAL.
+ *
+ * @NL80211_ATTR_WIPHY_ANTENNA_RX: Bitmap of allowed antennas for receiving.
+ *	This can be used to mask out antennas which are not attached or should
+ *	not be used for receiving. If an antenna is not selected in this bitmap
+ *	the hardware should not be configured to receive on this antenna.
+ *	For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -891,6 +913,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_TX_POWER_SETTING,
 	NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
 
+	NL80211_ATTR_WIPHY_ANTENNA_TX,
+	NL80211_ATTR_WIPHY_ANTENNA_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f68ae54..7dc0e8d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1184,6 +1184,9 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+
+	int	(*set_antenna)(struct wiphy *wiphy, u8 tx_ant, u8 rx_ant);
+	int	(*get_antenna)(struct wiphy *wiphy, u8 *tx_ant, u8 *rx_ant);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cea595e..62fc5fe 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -156,6 +156,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 
 	[NL80211_ATTR_WIPHY_TX_POWER_SETTING] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_WIPHY_ANTENNA_TX] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_ANTENNA_RX] = { .type = NLA_U8 },
 };
 
 /* policy for the attributes */
@@ -458,7 +461,6 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		    dev->wiphy.rts_threshold);
 	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
 		    dev->wiphy.coverage_class);
-
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 		   dev->wiphy.max_scan_ssids);
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
@@ -471,6 +473,16 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_PMKIDS,
 		   dev->wiphy.max_num_pmkids);
 
+	if (dev->ops->get_antenna) {
+		u8 tx_ant = 0, rx_ant = 0;
+		int res;
+		res = dev->ops->get_antenna(&dev->wiphy, &tx_ant, &rx_ant);
+		if (!res) {
+			NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_ANTENNA_TX, tx_ant);
+			NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_ANTENNA_RX, rx_ant);
+		}
+	}
+
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
 	if (!nl_modes)
 		goto nla_put_failure;
@@ -900,6 +912,22 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			goto bad_res;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
+	    info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
+		u8 tx_ant, rx_ant;
+		if (!rdev->ops->set_antenna) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		tx_ant = nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_ANTENNA_TX]);
+		rx_ant = nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_ANTENNA_RX]);
+
+		result = rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+		if (result)
+			goto bad_res;
+	}
+
 	changed = 0;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]) {

