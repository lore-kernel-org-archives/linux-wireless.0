Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:4030 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbcHJSMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:12:21 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/4] cfg80211: rdev-ops: remove checks from rdev_{add,del}_tx_ts()
Date: Wed, 10 Aug 2016 12:33:29 +0200
Message-Id: <1470825209-10054-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160810_201231_028910_82D6D75E)
In-Reply-To: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wrappers check if callback is specified. Just have the checks
in nl80211.c checking the NL80211_FEATURE_SUPPORTS_WMM_ADMISSION
feature flag. If the driver sets this flag the callbacks are being
checked in wiphy_register().

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/core.c     |  4 ++++
 net/wireless/nl80211.c  |  3 +++
 net/wireless/rdev-ops.h | 12 +++++-------
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7645e97..ef83db8 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -579,6 +579,10 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->tdls_cancel_channel_switch)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->features & NL80211_FEATURE_SUPPORTS_WMM_ADMISSION)
+		    && (!rdev->ops->add_tx_ts || !rdev->ops->del_tx_ts)))
+		return -EINVAL;
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8ab63b5..e818cec 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10890,6 +10890,9 @@ static int nl80211_del_tx_ts(struct sk_buff *skb, struct genl_info *info)
 	u8 tsid;
 	int err;
 
+	if (!(rdev->wiphy.features & NL80211_FEATURE_SUPPORTS_WMM_ADMISSION))
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL80211_ATTR_TSID] || !info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 2020606..be89461 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -978,13 +978,12 @@ rdev_add_tx_ts(struct cfg80211_registered_device *rdev,
 	       struct net_device *dev, u8 tsid, const u8 *peer,
 	       u8 user_prio, u16 admitted_time)
 {
-	int ret = -EOPNOTSUPP;
+	int ret;
 
 	trace_rdev_add_tx_ts(&rdev->wiphy, dev, tsid, peer,
 			     user_prio, admitted_time);
-	if (rdev->ops->add_tx_ts)
-		ret = rdev->ops->add_tx_ts(&rdev->wiphy, dev, tsid, peer,
-					   user_prio, admitted_time);
+	ret = rdev->ops->add_tx_ts(&rdev->wiphy, dev, tsid, peer,
+				   user_prio, admitted_time);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 
 	return ret;
@@ -994,11 +993,10 @@ static inline int
 rdev_del_tx_ts(struct cfg80211_registered_device *rdev,
 	       struct net_device *dev, u8 tsid, const u8 *peer)
 {
-	int ret = -EOPNOTSUPP;
+	int ret;
 
 	trace_rdev_del_tx_ts(&rdev->wiphy, dev, tsid, peer);
-	if (rdev->ops->del_tx_ts)
-		ret = rdev->ops->del_tx_ts(&rdev->wiphy, dev, tsid, peer);
+	ret = rdev->ops->del_tx_ts(&rdev->wiphy, dev, tsid, peer);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 
 	return ret;
-- 
1.9.1

