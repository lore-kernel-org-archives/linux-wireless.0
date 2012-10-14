Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34488 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab2JNO4A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 10:56:00 -0400
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v4 3/6] nl80211/cfg80211: add ability to enable TX on op-channel
Date: Sun, 14 Oct 2012 16:48:54 +0200
Message-ID: <1350226137-13704-4-git-send-email-victorg@ti.com> (sfid-20121014_165617_836269_2533EC60)
In-Reply-To: <1350226137-13704-1-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The dfs master device should monitor radar channels
for potential radar interference for a minimum of
CAC (channel availability check) time, during this
period no tx can occur. If no radar interference
is detected the dfs master may initiate the tx with
new NL80211_CMD_DFS_ENABLE_TX command.

If this command is invoked prior performing a CAC or
the time passed since the beginning of the CAC is
less than min CAC time (60 sec), -EPERM is returned.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |   11 +++++++++++
 include/net/cfg80211.h  |    5 +++++
 net/wireless/nl80211.c  |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ba4c697..ee3336c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -581,6 +581,15 @@
  * @NL80211_CMD_RADAR_DETECT: Start radar detection in the driver/HW. Once
  *	radar detected usermode notified with this event.
  *
+ * @NL80211_CMD_DFS_ENABLE_TX: Initiate tx after verifying radar clearness on
+ *	dfs channel. The dfs master device should monitor radar channels
+ *	for potential radar interference for a minimum of CAC (channel
+ *	availability check) time, during this period no tx can occur. If no
+ *	radar interference is detected during this period the dfs master may
+ *	initiate the tx. If this command is invoked prior performing a CAC or
+ *	the time passed since the beginning of the CAC is less than
+ *	NL80211_DFS_MIN_CAC_TIME_MS, -EPERM is returned.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -731,6 +740,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_RADAR_DETECT,
 
+	NL80211_CMD_DFS_ENABLE_TX,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 238d0e2..f2d4bde 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1631,6 +1631,8 @@ struct cfg80211_gtk_rekey_data {
  * @stop_p2p_device: Stop the given P2P device.
  *
  * @start_radar_detection: Start radar detection in the driver.
+ *
+ * @dfs_en_tx: Enable tx after radar interference check.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1855,6 +1857,9 @@ struct cfg80211_ops {
 	int	(*start_radar_detection)(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 struct ieee80211_channel *chan);
+
+	int	(*dfs_en_tx)(struct wiphy *wiphy, struct net_device *dev,
+			     struct ieee80211_channel *chan);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4c83c28..be4e160 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4648,6 +4648,35 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct ieee80211_channel *chan;
+	int freq;
+
+	if (!rdev->ops->dfs_en_tx ||
+	    !(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS))
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	else
+		return -EINVAL;
+
+	chan = ieee80211_get_channel(&rdev->wiphy, freq);
+	if (!chan)
+		return -EINVAL;
+
+	if ((((chan->cac_type != NL80211_CHAN_NO_HT) &&
+	      (chan->cac_type != NL80211_CHAN_HT20)) || !chan->cac_started ||
+	     time_is_after_jiffies(chan->radar_detect_timeout)) &&
+	    (chan->flags & IEEE80211_CHAN_RADAR))
+		return -EPERM;
+
+	return rdev->ops->dfs_en_tx(&rdev->wiphy, dev, chan);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7604,6 +7633,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_DFS_ENABLE_TX,
+		.doit = nl80211_dfs_en_tx,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.5.4

