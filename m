Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:48430 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab2JLEEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 00:04:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v4 2/5] cfg80211: add scan flag to indicate its priority
Date: Thu, 11 Oct 2012 21:03:32 -0700
Message-Id: <1350014615-14762-3-git-send-email-bzhao@marvell.com> (sfid-20121012_060440_706056_1AC6CC72)
In-Reply-To: <1350014615-14762-1-git-send-email-bzhao@marvell.com>
References: <1350014615-14762-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add NL80211_SCAN_FLAG_LOW_PRIORITY flag support. It tells drivers
that this is a low priority scan request, so that they can take
necessary action.
Drivers need to advertise low priority scan capability during
registration.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v4: "wiphy->features" is used instead of "wiphy->flags" to advertise
    scan features. (Johannes Berg)
v3: Add WIPHY_FLAG_LOW_PRIORITY_SCAN flag so that device can advertise
    low priority scan capability. An error will be returned to the
    application if device doesn't support this feature.
    Flush scan table feature is by default enabled.
    (Johannes Berg)

 include/linux/nl80211.h |    5 +++++
 net/wireless/nl80211.c  |   16 ++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e47eccd..c68e15e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3048,6 +3048,7 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_SAE: This driver supports simultaneous authentication of
  *	equals (SAE) with user space SME (NL80211_CMD_AUTHENTICATE) in station
  *	mode
+ * @NL80211_FEATURE_LOW_PRIORITY_SCAN: This driver supports low priority scan
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3056,6 +3057,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
 	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
 	NL80211_FEATURE_SAE				= 1 << 5,
+	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
 };
 
 /**
@@ -3096,8 +3098,11 @@ enum nl80211_connect_failed_reason {
  * Scan request control flags are used to control the handling
  * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
  * requests.
+ *
+ * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
  */
 enum nl80211_scan_flags {
+	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 };
 
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9a5acab..facaa11 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4368,9 +4368,15 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+		if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+		    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) {
+			err = -EOPNOTSUPP;
+			goto out_free;
+		}
+	}
 
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
@@ -4603,9 +4609,15 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		       request->ie_len);
 	}
 
-	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+		if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+		    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) {
+			err = -EOPNOTSUPP;
+			goto out_free;
+		}
+	}
 
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
-- 
1.7.0.4

