Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:44809 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaGTMcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:32:39 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so6469086wes.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:32:38 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 1/2] cfg80211: add enable_dynack API
Date: Sun, 20 Jul 2014 14:32:34 +0200
Message-Id: <1405859555-31806-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_145108_220079_25FF5CC0)
In-Reply-To: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define enable_dynack API to enable ack timeout estimation algorithm through
nl80211

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       |  7 +++++++
 net/wireless/rdev-ops.h      | 11 +++++++++++
 net/wireless/trace.h         |  5 +++++
 5 files changed, 32 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0a080c4..5a86922 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2313,6 +2313,8 @@ struct cfg80211_qos_map {
  * @set_ap_chanwidth: Set the AP (including P2P GO) mode channel width for the
  *	given interface This is used e.g. for dynamic HT 20/40 MHz channel width
  *	changes during the lifetime of the BSS.
+ *
+ * @enable_dynack: Enable ack timeout estimation algorithm
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2553,6 +2555,8 @@ struct cfg80211_ops {
 
 	int	(*set_ap_chanwidth)(struct wiphy *wiphy, struct net_device *dev,
 				    struct cfg80211_chan_def *chandef);
+
+	int	(*enable_dynack)(struct wiphy *wiphy);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f1db15b..7cc5ecd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1594,6 +1594,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
  *
+ * @NL80211_ATTR_WIPHY_DYNACK: whether dynamic ack timeout estimation algorithm
+ *	is enabled
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1936,6 +1939,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TDLS_INITIATOR,
 
+	NL80211_ATTR_WIPHY_DYNACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 082f5c6..c814b45 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -225,6 +225,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY_FRAG_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_RTS_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_COVERAGE_CLASS] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_DYNACK] = { .type = NLA_FLAG },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -2192,6 +2193,12 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			return result;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_DYNACK]) {
+		result = rdev_enable_dynack(rdev);
+		if (result)
+			return result;
+	}
+
 	changed = 0;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]) {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 56c2240..48df1f5 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -915,4 +915,15 @@ rdev_set_ap_chanwidth(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_enable_dynack(struct cfg80211_registered_device *rdev)
+{
+	int ret;
+
+	trace_rdev_enable_dynack(&rdev->wiphy);
+	ret = rdev->ops->enable_dynack(&rdev->wiphy);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0c524cd..0c222b5 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1896,6 +1896,11 @@ TRACE_EVENT(rdev_set_ap_chanwidth,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
+DEFINE_EVENT(wiphy_only_evt, rdev_enable_dynack,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.9.1

