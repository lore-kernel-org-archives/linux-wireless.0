Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:48747 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab1IEMDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:03:12 -0400
Received: by ywo32 with SMTP id 32so3573688ywo.41
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 05:03:11 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [RFC 5/5] nl80211/cfg80211: adding intermediate scan result filter.
Date: Mon,  5 Sep 2011 15:02:31 +0300
Message-Id: <1315224151-16552-6-git-send-email-VictorG@ti.com> (sfid-20110905_140315_351796_19A4861E)
In-Reply-To: <1315224151-16552-1-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User might want to be notified with intermediate scan results only
above some minimal RSSI. Adding new NL80211_ATTR_IM_SCAN_RESULT_MIN_RSSI
u32 attribute for the intermediate scan results  RSSI filtering mechanism,
which will significantly reduce unnecessary Kernel-User traffic.
It might be optionally enabled during NL80211_CMD_TRIGGER_SCAN.

Signed-off-by: Victor Goldenshtein <VictorG@ti.com>
---
 include/linux/nl80211.h |    5 +++++
 net/wireless/core.h     |    1 +
 net/wireless/nl80211.c  |   13 +++++++++++--
 net/wireless/scan.c     |    4 ++++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 5a10ec0..44cc394 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1063,6 +1063,10 @@ enum nl80211_commands {
  *	scan result notification event (%NL80211_CMD_IM_SCAN_RESULT)
  *	for the %NL80211_CMD_TRIGGER_SCAN command.
  *	When set: will notify on each new scan result in the cache.
+ * @%NL80211_ATTR_IM_SCAN_RESULT_MIN_RSSI: Intermediate event filtering.
+ *	When set: will notify only those new scan result whose signal
+ *	strength of probe response/beacon (in dBm) is stronger than this
+ *	negative value (usually: -20 dBm > X > -95 dBm).
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1275,6 +1279,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_ASSOC_RESP,
 
 	NL80211_ATTR_IM_SCAN_RESULT,
+	NL80211_ATTR_IM_SCAN_RESULT_MIN_RSSI,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7484255..bacd5b3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -78,6 +78,7 @@ struct cfg80211_registered_device {
 
 	/* intermediate scan result configuration */
 	bool im_scan_result;
+	s32  im_scan_result_min_rssi_mbm;
 
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9e60b48..82c7b40 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -190,6 +190,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IM_SCAN_RESULT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_IM_SCAN_RESULT_MIN_RSSI] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -3558,10 +3559,18 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (info->attrs[NL80211_ATTR_IM_SCAN_RESULT])
+	if (info->attrs[NL80211_ATTR_IM_SCAN_RESULT]) {
 		rdev->im_scan_result = 1;
-	else
+		if (info->attrs[NL80211_ATTR_IM_SCAN_RESULT_MIN_RSSI]) {
+			attr = info->attrs[NL80211_ATTR_IM_SCAN_RESULT_MIN_RSSI];
+			rdev->im_scan_result_min_rssi_mbm =
+				DBM_TO_MBM(nla_get_u32(attr));
+		} else {
+			rdev->im_scan_result_min_rssi_mbm = 0;
+		}
+	} else {
 		rdev->im_scan_result = 0;
+	}
 
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9be42c3..257c70a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -183,6 +183,10 @@ void cfg80211_send_intermediate_result(struct net_device *dev,
 	if ((!rdev->im_scan_result) || (!rdev->scan_req) || (!cbss))
 		return;
 
+	if ((rdev->im_scan_result_min_rssi_mbm) &&
+		(rdev->im_scan_result_min_rssi_mbm > cbss->signal))
+		return;
+
 	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 	if (!ev)
 		return;
-- 
1.7.0.4

