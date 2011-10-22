Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46128 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1JVNNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:13:41 -0400
Received: by eye27 with SMTP id 27so4522662eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 06:13:40 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: Get the probe response offloading support from the driver
Date: Sat, 22 Oct 2011 15:11:50 +0200
Message-Id: <1319289112-21896-2-git-send-email-guy@wizery.com> (sfid-20111022_151345_958435_EC927E6E)
In-Reply-To: <1319289112-21896-1-git-send-email-guy@wizery.com>
References: <1319289112-21896-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Query the driver for probe response offloading support
in order to notify the userspace on the protocols supported
by the driver for offloading.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 include/net/mac80211.h    |    3 +++
 net/mac80211/cfg.c        |    9 +++++++++
 net/mac80211/driver-ops.h |   11 +++++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cd108df..1c58fd7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2080,6 +2080,7 @@ enum ieee80211_frame_release_type {
  *	The @tids parameter is a bitmap and tells the driver which TIDs the
  *	frames will be on; it will at most have two bits set.
  *	This callback must be atomic.
+ * @get_probe_resp_offload: Get probe response offload support from driver.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2206,6 +2207,8 @@ struct ieee80211_ops {
 					u16 tids, int num_frames,
 					enum ieee80211_frame_release_type reason,
 					bool more_data);
+	int (*get_probe_resp_offload) (struct ieee80211_hw *hw,
+				u32 *supp_protocols);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1309bb9..3cdb4a9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2470,6 +2470,14 @@ static int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_get_probe_resp_offload(struct wiphy *wiphy,
+				    u32 *supp_protocols)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_get_probe_resp_offload(local, supp_protocols);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2535,4 +2543,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.set_rekey_data = ieee80211_set_rekey_data,
 	.tdls_oper = ieee80211_tdls_oper,
 	.tdls_mgmt = ieee80211_tdls_mgmt,
+	.get_probe_resp_offload = ieee80211_get_probe_resp_offload,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5f165d7..cd8da74 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -701,4 +701,15 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 						  more_data);
 	trace_drv_return_void(local);
 }
+static inline int drv_get_probe_resp_offload(struct ieee80211_local *local,
+				       u32 *supp_protocols)
+{
+	int ret = -EOPNOTSUPP;
+	might_sleep();
+	if (local->ops->get_probe_resp_offload)
+		ret = local->ops->get_probe_resp_offload(&local->hw,
+							  supp_protocols);
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
-- 
1.7.4.1

