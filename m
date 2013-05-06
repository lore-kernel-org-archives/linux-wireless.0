Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:49891 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EFTOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 15:14:10 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 2/4] nl80211/cfg80211: add channel switch command
Date: Mon,  6 May 2013 21:13:53 +0200
Message-Id: <1367867635-3459-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130506_211416_612967_EC387FFA)
In-Reply-To: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To allow channel switch announcements within beacons, add
the channel switch command to nl80211/cfg80211. This is
implementation is intended for AP and (later) IBSS mode.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/cfg80211.h       |    4 +++
 include/uapi/linux/nl80211.h |   20 +++++++++++
 net/wireless/nl80211.c       |   76 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f46ac71..d7afb1f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2257,6 +2257,10 @@ struct cfg80211_ops {
 				    u16 duration);
 	void	(*crit_proto_stop)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+	int	(*channel_switch)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_chan_def *chandef,
+				  bool block_tx, u32 count);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b484307..f9b168b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -648,6 +648,16 @@
  * @NL80211_CMD_CRIT_PROTOCOL_STOP: Indicates the connection reliability can
  *	return back to normal.
  *
+ * @NL80211_CMD_CHANNEL_SWITCH: Perform a channel switch by announcing the
+ *	the new channel information (Channel Switch Announcement - CSA)
+ *	in the beacon for some time (as defined in the
+ *	%NL80211_ATTR_CH_SWITCH_COUNT parameter) and then change to the
+ *	new channel. Userspace provides the new channel information (using
+ *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel
+ *	width). %NL80211_ATTR_CH_SWITCH_BLOCK_TX may be supplied to inform
+ *	other station that transmission must be blocked until the channel
+ *	switch is complete.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -810,6 +820,7 @@ enum nl80211_commands {
 	NL80211_CMD_CRIT_PROTOCOL_START,
 	NL80211_CMD_CRIT_PROTOCOL_STOP,
 
+	NL80211_CMD_CHANNEL_SWITCH,
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1431,6 +1442,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_MAX_CRIT_PROT_DURATION: duration in milliseconds in which
  *      the connection should have increased reliability (u16).
  *
+ * @NL80211_ATTR_CH_SWITCH_COUNT: u32 attribute specifying the number of TBTT's
+ *	until the channel switch event.
+ * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: flag attribute specifying that transmission
+ *	must be blocked on the current channel (before the channel switch
+ *	operation).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1729,6 +1746,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_CRIT_PROT_ID,
 	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9cdcd9e..63920db 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -378,6 +378,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5598,6 +5600,70 @@ err_locked:
 	return err;
 }
 
+static int nl80211_channel_switch(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_chan_def chandef;
+	bool block_tx = false;
+	u8 radar_detect_width = 0;
+	u32 count;
+	int err;
+
+	if (!rdev->ops->channel_switch)
+		return -EOPNOTSUPP;
+
+	/* may add IBSS support later */
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] ||
+	    !info->attrs[NL80211_ATTR_CH_SWITCH_COUNT])
+		return -EINVAL;
+
+	/* useless if AP is not running */
+	if (!wdev->beacon_interval)
+		return -EINVAL;
+
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
+
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef))
+		return -EINVAL;
+
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
+	if (err < 0)
+		return err;
+
+	if (err)
+		radar_detect_width = BIT(chandef.width);
+	else
+		radar_detect_width = 0;
+
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   chandef.chan,
+					   CHAN_MODE_SHARED,
+					   radar_detect_width);
+	mutex_unlock(&rdev->devlist_mtx);
+	if (err)
+		return err;
+
+	count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
+		block_tx = true;
+
+	err = rdev->ops->channel_switch(&rdev->wiphy, dev, &chandef,
+					block_tx, count);
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -9020,7 +9086,15 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
-	}
+	},
+	{
+		.cmd = NL80211_CMD_CHANNEL_SWITCH,
+		.doit = nl80211_channel_switch,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.10.4

