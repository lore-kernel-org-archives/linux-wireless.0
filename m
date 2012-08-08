Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:54097 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757128Ab2HHMA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:27 -0400
Received: by obbwc20 with SMTP id wc20so1277570obb.31
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:26 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 3/7] nl80211/cfg80211: add ability to enable TX on op-channel
Date: Wed,  8 Aug 2012 14:53:39 +0300
Message-Id: <1344426823-1795-4-git-send-email-victorg@ti.com> (sfid-20120808_140057_194118_1D9CABE0)
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
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
 net/wireless/nl80211.c  |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 773ba68..6c2884c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -568,6 +568,15 @@
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
@@ -713,6 +722,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_RADAR_DETECT,
 
+	NL80211_CMD_DFS_ENABLE_TX,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c40a05d..3a56601 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1627,6 +1627,8 @@ struct cfg80211_gtk_rekey_data {
  *	current monitoring channel.
  *
  * @start_radar_detection: Start radar detection in the driver.
+ *
+ * @dfs_en_tx: Enable tx after radar interference check.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1847,6 +1849,9 @@ struct cfg80211_ops {
 	int	(*start_radar_detection)(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 struct ieee80211_channel *chan);
+
+	int	(*dfs_en_tx)(struct wiphy *wiphy, struct net_device *dev,
+			     struct ieee80211_channel *chan);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 74e65d7..869d271 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4616,6 +4616,34 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	return cfg80211_start_radar_detection(rdev, dev, chan);
 }
 
+static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	bool dfs_supported = (rdev->wiphy.features & NL80211_FEATURE_DFS);
+	struct ieee80211_channel *chan;
+	int freq;
+
+	if (!rdev->ops->dfs_en_tx || !dfs_supported)
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
+	if (((chan->cac_type != NL80211_CHAN_HT20) ||
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
@@ -7482,6 +7510,14 @@ static struct genl_ops nl80211_ops[] = {
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
 
-- 
1.7.5.4

