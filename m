Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:53925 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab2JDEsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 00:48:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 2/5] cfg80211: add scan flag to indicate its priority
Date: Wed,  3 Oct 2012 21:47:43 -0700
Message-Id: <1349326066-28501-3-git-send-email-bzhao@marvell.com> (sfid-20121004_064816_487132_FCF2DDB2)
In-Reply-To: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
References: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
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
v3: Add WIPHY_FLAG_LOW_PRIORITY_SCAN flag so that device can advertise
    low priority scan capability. An error will be returned to the
    application if device doesn't support this feature.
    Flush scan table feature is by default enabled.
    (Johannes Berg)

 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |   12 ++++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index bac473a..a1d5704 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3090,8 +3090,11 @@ enum nl80211_connect_failed_reason {
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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7c70e99..dcad5cd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1915,6 +1915,7 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_LOW_PRIORITY_SCAN: Device handles low priority scan differently.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1938,6 +1939,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_LOW_PRIORITY_SCAN		= BIT(22),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 714e46d..b26b7f7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4363,9 +4363,13 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+		if (!(wiphy->flags & WIPHY_FLAG_LOW_PRIORITY_SCAN) &&
+		    (request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY))
+			return -EOPNOTSUPP;
+	}
 
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
@@ -4598,9 +4602,13 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		       request->ie_len);
 	}
 
-	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+		if (!(wiphy->flags & WIPHY_FLAG_LOW_PRIORITY_SCAN) &&
+		    (request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY))
+			return -EOPNOTSUPP;
+	}
 
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
-- 
1.7.0.4

