Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:27288 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1AQQUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:06 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 12:49:04 +0100
Subject: [PATCH 5/5] cfg80211: userspace commands/notifications
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161133.88D6E2086@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 include/linux/nl80211.h |   11 +++++
 include/net/cfg80211.h  |   18 ++++++++
 net/mac80211/cfg.c      |    1 +
 net/mac80211/radar.c    |   21 +++++++++
 net/wireless/nl80211.c  |  104 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 ++
 net/wireless/util.c     |   20 +++++++++
 7 files changed, 179 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index acb3c33..fa65287 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -410,6 +410,12 @@
  *	notification. This event is used to indicate that an unprotected
  *	disassociation frame was dropped when MFP is in use.
  *
+ * @NL80211_CMD_RADAR_CAC_START: Request a CAC
+ * @NL80211_CMD_RADAR_CAC_STOP: Stop as CAC earler
+ * @NL80211_CMD_RADAR_CAC_DONE: Notification sent if a CAC has completed.
+ * @NL80211_CMD_RADAR_FLAGS_CHANGED: Notification sent if channel flags
+ *	have changed.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -522,6 +528,11 @@ enum nl80211_commands {
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
+	NL80211_CMD_RADAR_CAC_START,
+	NL80211_CMD_RADAR_CAC_STOP,
+	NL80211_CMD_RADAR_CAC_DONE,
+	NL80211_CMD_RADAR_FLAGS_CHANGED,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1e9a052..4f77662 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1200,6 +1200,8 @@ struct cfg80211_pmksa {
  *	(also see nl80211.h @NL80211_ATTR_WIPHY_ANTENNA_TX).
  *
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
+ *
+ * @radar_cac: Request CAC.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -1367,6 +1369,8 @@ struct cfg80211_ops {
 
 	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
 	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
+
+	int	(*radar_cac)(struct wiphy *wiphy, int enable);
 };
 
 /*
@@ -2720,6 +2724,20 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 				 const u8 *peer, u32 num_packets, gfp_t gfp);
 
+/**
+ * cfg80211_radar_cac_done - notify userspace that a CAC has been done.
+ * @wiphy: the wireless device to give the hint
+ */
+int cfg80211_radar_cac_done(struct wiphy *wiphy);
+
+/**
+ * cfg80211_radar_flags_changed - notify userspace about channel flag changes
+ * @wiphy: the wireless device to give the hint
+ * @channel: the channel on which flag changes occurred
+ */
+int cfg80211_radar_flags_changed(struct wiphy *wiphy,
+				 struct ieee80211_channel *channel);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a6a2c0b..43f657d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1999,4 +1999,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
 	.get_antenna = ieee80211_get_antenna,
+	.radar_cac = ieee80211_radar_cac,
 };
diff --git a/net/mac80211/radar.c b/net/mac80211/radar.c
index afb2ae1..d825e3c 100644
--- a/net/mac80211/radar.c
+++ b/net/mac80211/radar.c
@@ -18,8 +18,10 @@
 static void cac_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
+	struct wiphy *wiphy = local->hw.wiphy;
 	struct ieee80211_radar *radar = &local->radar;
 	struct ieee80211_channel *chan;
+	int changed = 0;
 
 	printk(KERN_INFO "CAC done\n");
 
@@ -27,9 +29,16 @@ static void cac_timer(unsigned long data)
 	mutex_lock(&radar->mtx);
 	if ((chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE) == 0) {
 		chan->flags |= IEEE80211_CHAN_RADAR_CLEAR;
+		changed = 1;
 	}
+	mutex_unlock(&radar->mtx);
+	if (changed)
+		cfg80211_radar_flags_changed(wiphy, chan);
+
+	mutex_lock(&radar->mtx);
 	radar->cac = 0;
 	mutex_unlock(&radar->mtx);
+	cfg80211_radar_cac_done(wiphy);
 }
 
 int ieee80211_radar_cac(struct wiphy *wiphy, int enable)
@@ -52,9 +61,12 @@ int ieee80211_radar_cac(struct wiphy *wiphy, int enable)
 		mutex_lock(&radar->mtx);
 		radar->cac = 0;
 		mutex_unlock(&radar->mtx);
+		cfg80211_radar_cac_done(wiphy);
 		return 0;
 	}
 	if (enable) {
+		int changed = 0;
+
 		if ((chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE))
 			return -EINVAL;
 
@@ -65,7 +77,12 @@ int ieee80211_radar_cac(struct wiphy *wiphy, int enable)
 		if ((chan->flags & IEEE80211_CHAN_RADAR) &&
 		    (chan->flags & IEEE80211_CHAN_RADAR_CLEAR)) {
 			chan->flags &= ~IEEE80211_CHAN_RADAR_CLEAR;
+			changed = 1;
 		}
+		mutex_unlock(&radar->mtx);
+		if (changed)
+			cfg80211_radar_flags_changed(wiphy, chan);
+		mutex_lock(&radar->mtx);
 		radar->cac = 1;
 		mutex_unlock(&radar->mtx);
 		mod_timer(&radar->cac_timer, jiffies +
@@ -78,6 +95,7 @@ int ieee80211_radar_cac(struct wiphy *wiphy, int enable)
 static void nol_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
+	struct wiphy *wiphy = local->hw.wiphy;
 	struct ieee80211_radar *radar = &local->radar;
 	struct ieee80211_radar_nol_list *nol, *tmp;
 
@@ -93,6 +111,7 @@ static void nol_timer(unsigned long data)
 			list_del(&nol->list);
 			mutex_unlock(&radar->mtx);
 			kfree(nol);
+			cfg80211_radar_flags_changed(wiphy, chan);
 		}
 	}
 
@@ -103,6 +122,7 @@ int ieee80211_radar_interference(struct ieee80211_hw *hw,
 				 struct ieee80211_channel *chan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct wiphy *wiphy = local->hw.wiphy;
 	struct ieee80211_radar *radar = &local->radar;
 	struct ieee80211_radar_nol_list *nol, *tmp;
 
@@ -131,6 +151,7 @@ int ieee80211_radar_interference(struct ieee80211_hw *hw,
 	chan->flags |= IEEE80211_CHAN_RADAR_INTERFERENCE;
 	list_add_tail(&nol->list, &radar->nol_list);
 	mutex_unlock(&radar->mtx);
+	cfg80211_radar_flags_changed(wiphy, chan);
 
 	return 0;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0524423..2f43b6e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4729,6 +4729,26 @@ out:
 	return err;
 }
 
+static int nl80211_radar_start_cac(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	if (!rdev->ops->radar_cac)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->radar_cac(&rdev->wiphy, 1);
+}
+
+static int nl80211_radar_stop_cac(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	if (!rdev->ops->radar_cac)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->radar_cac(&rdev->wiphy, 0);
+}
+
 static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -5271,6 +5291,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_RADAR_CAC_START,
+		.doit = nl80211_radar_start_cac,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_RADAR_CAC_STOP,
+		.doit = nl80211_radar_stop_cac,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -6128,6 +6164,74 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_radar_cac_done(struct cfg80211_registered_device *rdev)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_RADAR_CAC_DONE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void nl80211_radar_flags_changed(struct cfg80211_registered_device *rdev,
+				 struct ieee80211_channel *chan)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_RADAR_FLAGS_CHANGED);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ, chan->center_freq);
+	if ((chan->flags & IEEE80211_CHAN_RADAR_CLEAR))
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_CLEAR);
+	if ((chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE))
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e3f7fa8..e7f84d8 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -98,4 +98,8 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp);
 
+void nl80211_radar_cac_done(struct cfg80211_registered_device *rdev);
+void nl80211_radar_flags_changed(struct cfg80211_registered_device *rdev,
+				 struct ieee80211_channel *chan);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7620ae2..3c87c2f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -9,6 +9,7 @@
 #include <net/cfg80211.h>
 #include <net/ip.h>
 #include "core.h"
+#include "nl80211.h"
 
 struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
@@ -885,3 +886,22 @@ u16 cfg80211_calculate_bitrate(struct rate_info *rate)
 	/* do NOT round down here */
 	return (bitrate + 50000) / 100000;
 }
+
+int cfg80211_radar_cac_done(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_radar_cac_done(rdev);
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_radar_cac_done);
+
+int cfg80211_radar_flags_changed(struct wiphy *wiphy,
+				 struct ieee80211_channel *chan)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_radar_flags_changed(rdev, chan);
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_radar_flags_changed);
-- 
1.5.6.5

