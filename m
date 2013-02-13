Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761190Ab3BMXsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:48:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, green@qca.qualcomm.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3/3] nl80211: advertise HT/VHT channel limitations
Date: Thu, 14 Feb 2013 00:47:54 +0100
Message-Id: <1360799274-16088-4-git-send-email-johannes@sipsolutions.net> (sfid-20130214_004808_511448_9EA4FD50)
In-Reply-To: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net>
References: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When drivers or regulatory have limitations on
40, 80 or 160 MHz channels, advertise these to
userspace via nl80211. Also add a new feature
flag to let userspace know this is supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 17 +++++++++++++++++
 net/wireless/core.c          |  3 ++-
 net/wireless/nl80211.c       | 12 ++++++++++++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 90b7af8..3880f6a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2041,6 +2041,16 @@ enum nl80211_band_attr {
  *	(enum nl80211_dfs_state)
  * @NL80211_FREQUENCY_ATTR_DFS_TIME: time in miliseconds for how long
  *	this channel is in this DFS state.
+ * @NL80211_FREQUENCY_ATTR_NO_HT40_MINUS: HT40- isn't possible with this
+ *	channel as the control channel
+ * @NL80211_FREQUENCY_ATTR_NO_HT40_PLUS: HT40+ isn't possible with this
+ *	channel as the control channel
+ * @NL80211_FREQUENCY_ATTR_NO_80MHZ: any 80 MHz channel using this channel
+ *	as the primary or any of the secondary channels isn't possible,
+ *	this includes 80+80 channels
+ * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
+ *	using this channel as the primary or any of the secondary channels
+ *	isn't possible
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2055,6 +2065,10 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 	NL80211_FREQUENCY_ATTR_DFS_STATE,
 	NL80211_FREQUENCY_ATTR_DFS_TIME,
+	NL80211_FREQUENCY_ATTR_NO_HT40_MINUS,
+	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
+	NL80211_FREQUENCY_ATTR_NO_80MHZ,
+	NL80211_FREQUENCY_ATTR_NO_160MHZ,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -3421,6 +3435,8 @@ enum nl80211_ap_sme_features {
  *	Note that even for drivers that support this, the default is to add
  *	stations in authenticated/associated state, so to add unauthenticated
  *	stations the authenticated/associated bits have to be set in the mask.
+ * @NL80211_FEATURE_ADVERTISE_CHAN_LIMITS: cfg80211 advertises channel limits
+ *	(HT40, VHT 80/160 MHz) if this flag is set
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3437,6 +3453,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
+	NL80211_FEATURE_ADVERTISE_CHAN_LIMITS		= 1 << 14,
 };
 
 /**
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9220021..33b75b9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -367,7 +367,8 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.rts_threshold = (u32) -1;
 	rdev->wiphy.coverage_class = 0;
 
-	rdev->wiphy.features = NL80211_FEATURE_SCAN_FLUSH;
+	rdev->wiphy.features = NL80211_FEATURE_SCAN_FLUSH |
+			       NL80211_FEATURE_ADVERTISE_CHAN_LIMITS;
 
 	return &rdev->wiphy;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c1e18cc..7e40b9e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -562,6 +562,18 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_TIME, time))
 			goto nla_put_failure;
 	}
+	if ((chan->flags & IEEE80211_CHAN_NO_HT40MINUS) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_MINUS))
+		goto nla_put_failure;
+	if ((chan->flags & IEEE80211_CHAN_NO_HT40PLUS) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_PLUS))
+		goto nla_put_failure;
+	if ((chan->flags & IEEE80211_CHAN_NO_80MHZ) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_80MHZ))
+		goto nla_put_failure;
+	if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
+		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 			DBM_TO_MBM(chan->max_power)))
-- 
1.8.0

