Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:47612 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752675Ab0G0JsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 05:48:03 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-019774080
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 18:48:00 +0900 (JST)
Subject: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Date: Tue, 27 Jul 2010 18:48:00 +0900
Message-ID: <20100727094759.27186.79639.stgit@tt-desk>
In-Reply-To: <20100727094732.27186.30900.stgit@tt-desk>
References: <20100727094732.27186.30900.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting TX and RX antenna configuration via nl80211.

The antenna configuration is defined as a bitmap of allowed antennas to use for
either receiving or transmitting. Separate bitmaps are used for RX and TX to
allow configuring different antennas for receiving and transmitting. The bitmap
is 8 bit long, each bit representing one antenna, starting with antenna 1.

If multiple receive (RX) antennas are selected, the driver may use diversity or
multiple 802.11n RX chains, according to the chipset capabilities and
configuration.

If multiple transmit (TX) antennas are selected, the driver has to send on all
selected antennas, making this mode of operation only possible on 802.11n
chipsets with multiple TX chains. If the transmit antenna bitmap is set to the
special value zero (0) the driver should select the TX antenna based on the
antenna which was used for receiving (TX antenna follows RX diversity - this is
the usual mode of 'diversity') for pre 802.11n devices.

Using bitmaps has the benefit of allowing for a flexible configuration
interface which can support many different configurations. Drivers should
reject configurations they cannot support. While covering the standard modes
"fixed antenna 1", "fixed antenna 2" and "diversity" this API also allows more
rare - but useful - configurations as follows:

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
development where more than 2 antennas are available. It's good to keep the API
flexible.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/linux/nl80211.h |   17 +++++++++++++++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |   30 +++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2c87016..b9de53c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -731,6 +731,20 @@ enum nl80211_commands {
  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
  *      for non-automatic settings.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for transmitting.
+ *	Each bit represents one antenna, starting with antenna 1 at the first
+ *	bit. If the bitmap is zero (0), the TX antenna follows RX diversity.
+ *	If multiple antennas are selected all selected antennas have to be used
+ *	for transmitting (801.11n multiple TX chains).
+ *	Drivers may reject configurations they cannot support.
+ *
+ * @NL80211_ATTR_WIPHY_ANTENNA_RX: Bitmap of allowed antennas for receiving.
+ *	Each bit represents one antenna, starting with antenna 1 at the first
+ *	bit. If multiple antennas are selected in the bitmap, 802.11n devices
+ *	should use multiple RX chains on these antennas, while non-802.11n
+ *	drivers should use antenna diversity between these antennas.
+ *	Drivers may reject configurations they cannot support.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -891,6 +905,9 @@ enum nl80211_attrs {
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

