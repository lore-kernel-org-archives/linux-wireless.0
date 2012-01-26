Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:54058 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab2AZMjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:18 -0500
Received: by mail-yw0-f44.google.com with SMTP id n12so205163yhn.31
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:17 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
Date: Thu, 26 Jan 2012 14:37:58 +0200
Message-Id: <1327581484-22047-4-git-send-email-victorg@ti.com> (sfid-20120126_133921_284829_C18EF841)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The dfs master device should monitor radar channels
for potential radar interference for a minimum of
CAC (channel availability check) time, during this
period no tx can occur. If no radar interference
is detected the dfs master may initiate the tx with
new NL80211_CMD_DFS_ENABLE_TX command.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |    9 +++++++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |   22 ++++++++++++++++++++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 5bffba0..b45ceb1 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -544,6 +544,13 @@
  * @NL80211_CMD_DFS_RADAR_DETECTION: Start radar detection in the
  *	driver/HW. Once radar detected usermode notified with this event.
  *
+ * @NL80211_CMD_DFS_ENABLE_TX: Initiate tx after verifying radar clearness on
+ *	current channel. The dfs master device should monitor radar channels
+ *	for potential radar interference for a minimum of CAC (channel
+ *	availability check) time, during this period no tx can occur. If no
+ *	radar interference is detected during this period the dfs master may
+ *	initiate the tx.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -685,6 +692,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_DFS_RADAR_DETECTION,
 
+	NL80211_CMD_DFS_ENABLE_TX,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b47217b..fbd5b7a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1481,6 +1481,8 @@ struct cfg80211_gtk_rekey_data {
  * @probe_client: probe an associated client, must return a cookie that it
  *	later passes to cfg80211_probe_status().
  *
+ * @dfs_en_tx: Enable tx after radar interference check.
+ *
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
  * @dfs_start_radar_detection: Start radar detection in the driver.
@@ -1685,6 +1687,7 @@ struct cfg80211_ops {
 
 	int    (*dfs_start_radar_detection)(struct wiphy *wiphy,
 					    struct net_device *dev);
+	int    (*dfs_en_tx)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e96bfc5..66dfcef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4058,6 +4058,20 @@ static int nl80211_dfs_start_radar_detection(struct sk_buff *skb,
 	return rdev->ops->dfs_start_radar_detection(&rdev->wiphy, dev);
 }
 
+static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	if (!rdev->ops->dfs_en_tx)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->dfs_en_tx(&rdev->wiphy, dev);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -6733,6 +6747,14 @@ static struct genl_ops nl80211_ops[] = {
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

