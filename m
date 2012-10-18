Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43501 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab2JRGfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 02:35:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 3/6] cfg80211: add scan flag to indicate its priority
Date: Wed, 17 Oct 2012 23:34:28 -0700
Message-Id: <1350542071-26498-4-git-send-email-bzhao@marvell.com> (sfid-20121018_083556_799044_A0C8DBCB)
In-Reply-To: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
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
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |   15 +++++++++++++++
 net/wireless/nl80211.c       |   16 ++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 751a292..c68e15e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
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
@@ -3090,4 +3092,17 @@ enum nl80211_connect_failed_reason {
 	NL80211_CONN_FAIL_BLOCKED_CLIENT,
 };
 
+/**
+ * enum nl80211_scan_flags -  scan request control flags
+ *
+ * Scan request control flags are used to control the handling
+ * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
+ * requests.
+ *
+ * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
+ */
+enum nl80211_scan_flags {
+	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dc08211..aee252d 100644
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

