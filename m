Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:24292 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751674Ab0FGG6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 02:58:52 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0449273925
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 15:58:48 +0900 (JST)
Subject: [PATCH v3 1/3] cfg80211: Add nl80211 antenna configuration
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 15:58:58 +0900
Message-ID: <20100607065858.16060.38448.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting TX and RX antenna configuration via nl80211.

The antenna configuration is defined as a bitmap of allowed antennas to use for
either receiving or transmitting. Separate bitmaps are used for RX and TX to
allow using different antennas for receiving and transmitting. The bitmap is 8
bit, each bit representing one antenna.

If multiple receive antennas are selected, the driver may use diversity or
multiple 802.11 rx chains, according to the chipset capabilities.

If multiple transmit antennas are selected, the driver has to send on all
selected antennas, making this mode of operation only possible on 802.11n
chipsets with multiple tx chains. If the transmit antenna bitmap is set to the
special value zero (0) the driver should select the TX antenna based on the
antenna which was used for receiving (TX antenna follows RX diversity).

Drivers should reject configurations they cannot support.

While covering the standard modes "fixed antenna A", "fixed antenna B",
"diversity" this API allows for a more flexible antenna configuration, as
follows:

Send on antenna 1, receive on antenna 2 (or vice versa):

This can be used to have a low gain antenna for TX in order to keep within the
regulatory constraints and a high gain antenna for RX in order to receive
weaker signals ("speak softly, but listen harder"). This can be useful for
legal long-shot outdoor links. Another usage of this is: Having a low noise
preamp on antenna A and a power amplifier on the other antenna. This way
transmit noise is mostly kept out of the low noise receive channel. (This would
be bitmaps: tx 0b01 rx 0b10).

Another simiar setup would be: Use RX diversity on both antennas, but always
send on antenna A. Again that would allow us to benefit from a higher gain RX
antenna, while staying within the legal limits. (This would be tx 0 rx 0b11).

And finally there can be special experimental setups in research and
development where more than 2 antennas are available. It's good to keep the API
flexible.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/linux/nl80211.h |   22 +++++++++
 include/net/cfg80211.h  |    3 +
 net/wireless/nl80211.c  |  116 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 64fb32b..ace33de 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -341,6 +341,9 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_SET_ANTENNA: Set a bitmap of antennas to use.
+ * @NL80211_CMD_GET_ANTENNA: Get antenna configuration from driver.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -441,6 +444,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_CHANNEL,
 
+	NL80211_CMD_SET_ANTENNA,
+	NL80211_CMD_GET_ANTENNA,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -725,6 +731,19 @@ enum nl80211_commands {
  * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
  *	connected to this BSS.
  *
+ * @NL80211_ATTR_ANTENNA_TX: Bitmap of allowed antennas to use for transmitting.
+ *	Each bit represents one antenna, starting with antenna 1 at the first
+ *	bit. If the bitmap is zero (0), the TX antenna follows RX diversity.
+ *	If multiple antennas are selected all selected antennas have to be used
+ *	for transmitting (801.11n multiple tx chains).
+ *	Drivers may reject configurations they cannot support.
+ *
+ * @NL80211_ATTR_ANTENNA_RX: Bitmap of allowed antennas to use for receiving.
+ *	Each bit represents one antenna, starting with antenna 1 at the first
+ *	bit. If multiple antennas are selected in the bitmap, the driver should
+ *	use diversity or 802.11n multiple rx chains between these antennas.
+ *	Drivers may reject configurations they cannot support.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -882,6 +901,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AP_ISOLATE,
 
+	NL80211_ATTR_ANTENNA_TX,
+	NL80211_ATTR_ANTENNA_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0c3c214..f65bd6b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1177,6 +1177,9 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+
+	int	(*set_antenna)(struct wiphy *wiphy, u8 tx_ant, u8 rx_ant);
+	int	(*get_antenna)(struct wiphy *wiphy, u8 *tx_ant, u8 *rx_ant);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 90ab3c8..82f2785 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -153,6 +153,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
+	[NL80211_ATTR_ANTENNA_TX] = { .type = NLA_U8 },
+	[NL80211_ATTR_ANTENNA_RX] = { .type = NLA_U8 },
 };
 
 /* policy for the attributes */
@@ -590,6 +592,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
 	}
 	CMD(set_channel, SET_CHANNEL);
+	CMD(set_antenna, SET_ANTENNA);
+	CMD(get_antenna, GET_ANTENNA);
 
 #undef CMD
 
@@ -4968,6 +4972,106 @@ out:
 	return err;
 }
 
+static int nl80211_set_antenna(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	int res;
+	u8 rx_ant = 0, tx_ant = 0;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY] ||
+	    !info->attrs[NL80211_ATTR_ANTENNA_TX] ||
+	    !info->attrs[NL80211_ATTR_ANTENNA_RX]) {
+		return -EINVAL;
+	}
+
+	tx_ant = nla_get_u8(info->attrs[NL80211_ATTR_ANTENNA_TX]);
+	rx_ant = nla_get_u8(info->attrs[NL80211_ATTR_ANTENNA_RX]);
+
+	rtnl_lock();
+
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev)) {
+		res = -ENODEV;
+		goto unlock_rtnl;
+	}
+
+	if (!rdev->ops->set_antenna) {
+		res = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	res = rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+
+ unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+
+ unlock_rtnl:
+	rtnl_unlock();
+	return res;
+}
+
+static int nl80211_get_antenna(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct sk_buff *msg;
+	void *hdr;
+	int res;
+	u8 tx_ant, rx_ant;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev)) {
+		res = -ENODEV;
+		goto unlock_rtnl;
+	}
+
+	if (!rdev->ops->get_antenna) {
+		res = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		res = -ENOMEM;
+		goto unlock_rdev;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_ANTENNA);
+	if (!hdr) {
+		res = -ENOMEM;
+		goto free_msg;
+	}
+
+	res = rdev->ops->get_antenna(&rdev->wiphy, &tx_ant, &rx_ant);
+	if (res)
+		goto free_msg;
+
+	NLA_PUT_U8(msg, NL80211_ATTR_ANTENNA_TX, tx_ant);
+	NLA_PUT_U8(msg, NL80211_ATTR_ANTENNA_RX, rx_ant);
+
+	genlmsg_end(msg, hdr);
+	res = genlmsg_reply(msg, info);
+	goto unlock_rdev;
+
+ nla_put_failure:
+	res = -ENOBUFS;
+
+ free_msg:
+	nlmsg_free(msg);
+
+ unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+
+ unlock_rtnl:
+	rtnl_unlock();
+	return res;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -5284,6 +5388,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_ANTENNA,
+		.doit = nl80211_set_antenna,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_ANTENNA,
+		.doit = nl80211_get_antenna,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {

