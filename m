Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3HFJMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:12:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 1/2] cfg80211: add wdev to testmode cmd
Date: Tue,  6 Aug 2013 11:12:26 +0200
Message-Id: <1375780347-1062-1-git-send-email-johannes@sipsolutions.net> (sfid-20130806_111238_467049_76C71241)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

To allow drivers to implement per-interface testmode operations
more easily, pass a wdev pointer if any identification for one
was given from userspace. Clean up the code a bit while at it.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/testmode.c         |  3 ++-
 drivers/net/wireless/ath/ath6kl/testmode.h         |  7 +++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  4 +++-
 include/net/cfg80211.h                             |  5 +++--
 net/mac80211/cfg.c                                 |  4 +++-
 net/wireless/nl80211.c                             | 23 ++++++++++++++++------
 net/wireless/rdev-ops.h                            |  5 +++--
 net/wireless/trace.h                               |  8 +++++---
 8 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
index acc9aa8..d67170e 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.c
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -66,7 +66,8 @@ nla_put_failure:
 	ath6kl_warn("nla_put failed on testmode rx skb!\n");
 }
 
-int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len)
+int ath6kl_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
+		  void *data, int len)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
 	struct nlattr *tb[ATH6KL_TM_ATTR_MAX + 1];
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.h b/drivers/net/wireless/ath/ath6kl/testmode.h
index fe651d6..9fbcdec3 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.h
+++ b/drivers/net/wireless/ath/ath6kl/testmode.h
@@ -20,7 +20,8 @@
 #ifdef CONFIG_NL80211_TESTMODE
 
 void ath6kl_tm_rx_event(struct ath6kl *ar, void *buf, size_t buf_len);
-int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len);
+int ath6kl_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
+		  void *data, int len);
 
 #else
 
@@ -29,7 +30,9 @@ static inline void ath6kl_tm_rx_event(struct ath6kl *ar, void *buf,
 {
 }
 
-static inline int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len)
+static inline int ath6kl_tm_cmd(struct wiphy *wiphy,
+				struct wireless_dev *wdev,
+				void *data, int len)
 {
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 277b37a..b7d8850 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3152,7 +3152,9 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 }
 
 #ifdef CONFIG_NL80211_TESTMODE
-static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
+static int brcmf_cfg80211_testmode(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   void *data, int len)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = cfg_to_ndev(cfg);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b7495c7..9ab7a06 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2081,7 +2081,7 @@ struct cfg80211_update_ft_ies_params {
  * @mgmt_tx_cancel_wait: Cancel the wait time from transmitting a management
  *	frame on another channel
  *
- * @testmode_cmd: run a test mode command
+ * @testmode_cmd: run a test mode command; @wdev may be %NULL
  * @testmode_dump: Implement a test mode dump. The cb->args[2] and up may be
  *	used by the function, but 0 and 1 must not be touched. Additionally,
  *	return error codes other than -ENOBUFS and -ENOENT will terminate the
@@ -2290,7 +2290,8 @@ struct cfg80211_ops {
 	void	(*rfkill_poll)(struct wiphy *wiphy);
 
 #ifdef CONFIG_NL80211_TESTMODE
-	int	(*testmode_cmd)(struct wiphy *wiphy, void *data, int len);
+	int	(*testmode_cmd)(struct wiphy *wiphy, struct wireless_dev *wdev,
+				void *data, int len);
 	int	(*testmode_dump)(struct wiphy *wiphy, struct sk_buff *skb,
 				 struct netlink_callback *cb,
 				 void *data, int len);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 44449ce..c77916f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2300,7 +2300,9 @@ static void ieee80211_rfkill_poll(struct wiphy *wiphy)
 }
 
 #ifdef CONFIG_NL80211_TESTMODE
-static int ieee80211_testmode_cmd(struct wiphy *wiphy, void *data, int len)
+static int ieee80211_testmode_cmd(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  void *data, int len)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f7cb121..7e2c389 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6591,19 +6591,30 @@ static struct genl_multicast_group nl80211_testmode_mcgrp = {
 static int nl80211_testmode_do(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev =
+		__cfg80211_wdev_from_attrs(genl_info_net(info), info->attrs);
 	int err;
 
+	if (!rdev->ops->testmode_cmd)
+		return -EOPNOTSUPP;
+
+	if (IS_ERR(wdev)) {
+		err = PTR_ERR(wdev);
+		if (err != -EINVAL)
+			return err;
+		wdev = NULL;
+	} else if (wdev->wiphy != &rdev->wiphy) {
+		return -EINVAL;
+	}
+
 	if (!info->attrs[NL80211_ATTR_TESTDATA])
 		return -EINVAL;
 
-	err = -EOPNOTSUPP;
-	if (rdev->ops->testmode_cmd) {
-		rdev->testmode_info = info;
-		err = rdev_testmode_cmd(rdev,
+	rdev->testmode_info = info;
+	err = rdev_testmode_cmd(rdev, wdev,
 				nla_data(info->attrs[NL80211_ATTR_TESTDATA]),
 				nla_len(info->attrs[NL80211_ATTR_TESTDATA]));
-		rdev->testmode_info = NULL;
-	}
+	rdev->testmode_info = NULL;
 
 	return err;
 }
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index de870d4..37ce9fd 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -516,11 +516,12 @@ static inline void rdev_rfkill_poll(struct cfg80211_registered_device *rdev)
 
 #ifdef CONFIG_NL80211_TESTMODE
 static inline int rdev_testmode_cmd(struct cfg80211_registered_device *rdev,
+				    struct wireless_dev *wdev,
 				    void *data, int len)
 {
 	int ret;
-	trace_rdev_testmode_cmd(&rdev->wiphy);
-	ret = rdev->ops->testmode_cmd(&rdev->wiphy, data, len);
+	trace_rdev_testmode_cmd(&rdev->wiphy, wdev);
+	ret = rdev->ops->testmode_cmd(&rdev->wiphy, wdev, data, len);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f0ebdcd..ba5f0d6 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1293,15 +1293,17 @@ TRACE_EVENT(rdev_return_int_int,
 
 #ifdef CONFIG_NL80211_TESTMODE
 TRACE_EVENT(rdev_testmode_cmd,
-	TP_PROTO(struct wiphy *wiphy),
-	TP_ARGS(wiphy),
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
+		WDEV_ENTRY
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
 	),
-	TP_printk(WIPHY_PR_FMT, WIPHY_PR_ARG)
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
 );
 
 TRACE_EVENT(rdev_testmode_dump,
-- 
1.8.0

