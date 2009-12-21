Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:44849 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbZLUVu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 16:50:57 -0500
From: =?UTF-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH v3 1/5] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Mon, 21 Dec 2009 22:50:47 +0100
Message-Id: <1261432252-1855-2-git-send-email-8an@praha12.net>
In-Reply-To: <1261432252-1855-1-git-send-email-8an@praha12.net>
References: <1261432252-1855-1-git-send-email-8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new attribute NL80211_ATTR_WIPHY_COVERAGE_CLASS sets IEEE 802.11
Coverage Class, which depends on maximum distance of nodes in a
wireless network. It's required for long distance links (more than a few
hundred meters).

The attribute is now ignored by two non-mac80211 drivers, rndis and
iwmc3200wifi, together with WIPHY_PARAM_RETRY_SHORT and
WIPHY_PARAM_RETRY_LONG. If it turns out to be a problem, we could split
set_wiphy_params callback or add new capability bits.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/core.c     |    1 +
 net/wireless/nl80211.c  |   15 +++++++++++++++
 4 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index da8ea2e..e241ed1 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -402,6 +402,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_WIPHY_RTS_THRESHOLD: RTS threshold (TX frames with length
  *	larger than or equal to this use RTS/CTS handshake); allowed range:
  *	0..65536, disable with (u32)-1; dot11RTSThreshold; u32
+ * @NL80211_ATTR_WIPHY_COVERAGE_CLASS: Coverage Class as defined by IEEE 802.11
+ *	section 7.3.2.9; dot11CoverageClass; u8
  *
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
@@ -743,6 +745,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKID,
 	NL80211_ATTR_MAX_NUM_PMKIDS,
 
+	NL80211_ATTR_WIPHY_COVERAGE_CLASS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0884b9a..fe50c71 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -837,6 +837,7 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_LONG		= 1 << 1,
 	WIPHY_PARAM_FRAG_THRESHOLD	= 1 << 2,
 	WIPHY_PARAM_RTS_THRESHOLD	= 1 << 3,
+	WIPHY_PARAM_COVERAGE_CLASS	= 1 << 4,
 };
 
 /**
@@ -1217,6 +1218,7 @@ struct wiphy {
 	u8 retry_long;
 	u32 frag_threshold;
 	u32 rts_threshold;
+	u8 coverage_class;
 
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 	u32 hw_version;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index c2a2c56..0a545bb 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -402,6 +402,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.retry_long = 4;
 	rdev->wiphy.frag_threshold = (u32) -1;
 	rdev->wiphy.rts_threshold = (u32) -1;
+	rdev->wiphy.coverage_class = 0;
 
 	return &rdev->wiphy;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7cb0d64..ea86c28 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -69,6 +69,7 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_WIPHY_RETRY_LONG] = { .type = NLA_U8 },
 	[NL80211_ATTR_WIPHY_FRAG_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_RTS_THRESHOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_COVERAGE_CLASS] = { .type = NLA_U8 },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -442,6 +443,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		    dev->wiphy.frag_threshold);
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
 		    dev->wiphy.rts_threshold);
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
+		    dev->wiphy.coverage_class);
 
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 		   dev->wiphy.max_scan_ssids);
@@ -681,6 +684,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	u32 changed;
 	u8 retry_short = 0, retry_long = 0;
 	u32 frag_threshold = 0, rts_threshold = 0;
+	u8 coverage_class = 0;
 
 	rtnl_lock();
 
@@ -803,9 +807,16 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		changed |= WIPHY_PARAM_RTS_THRESHOLD;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
+		coverage_class = nla_get_u8(
+			info->attrs[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
+		changed |= WIPHY_PARAM_COVERAGE_CLASS;
+	}
+
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
 		u32 old_frag_threshold, old_rts_threshold;
+		u8 old_coverage_class;
 
 		if (!rdev->ops->set_wiphy_params) {
 			result = -EOPNOTSUPP;
@@ -816,6 +827,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		old_retry_long = rdev->wiphy.retry_long;
 		old_frag_threshold = rdev->wiphy.frag_threshold;
 		old_rts_threshold = rdev->wiphy.rts_threshold;
+		old_coverage_class = rdev->wiphy.coverage_class;
 
 		if (changed & WIPHY_PARAM_RETRY_SHORT)
 			rdev->wiphy.retry_short = retry_short;
@@ -825,6 +837,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.frag_threshold = frag_threshold;
 		if (changed & WIPHY_PARAM_RTS_THRESHOLD)
 			rdev->wiphy.rts_threshold = rts_threshold;
+		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
+			rdev->wiphy.coverage_class = coverage_class;
 
 		result = rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
 		if (result) {
@@ -832,6 +846,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.retry_long = old_retry_long;
 			rdev->wiphy.frag_threshold = old_frag_threshold;
 			rdev->wiphy.rts_threshold = old_rts_threshold;
+			rdev->wiphy.coverage_class = old_coverage_class;
 		}
 	}
 
-- 
1.6.4.4

