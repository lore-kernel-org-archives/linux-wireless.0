Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39223 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbaLZLBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 06:01:35 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBQAxpqb024622
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 03:01:35 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rfdgcppsp-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 03:01:35 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2] cfg80211: check for carrier state only when offchanel CAC supported
Date: Fri, 26 Dec 2014 03:00:13 -0800
Message-ID: <1419591613-3998-1-git-send-email-patila@marvell.com> (sfid-20141226_120143_638518_3418F8E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checking for carrier state during start_radar_detection is needed
only for devices which support offchannel CAC.
This patch provides this additional check of extended feature offchannel
CAC support while checking for carrier state.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 735ab43..61f7daad 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4205,11 +4205,14 @@ enum nl80211_feature_flags {
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
  *
+ * @NL80211_EXT_FEATURE_OFFCHAN_CAC: This device/driver supports
+ *	offchannel Channel Availibility Check(CAC).
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
 
+	NL80211_EXT_FEATURE_OFFCHAN_CAC,
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
 	MAX_NL80211_EXT_FEATURES = NUM_NL80211_EXT_FEATURES - 1
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 39753de..b2abb37 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6138,7 +6138,9 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (netif_carrier_ok(dev))
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_OFFCHAN_CAC) &&
+	    netif_carrier_ok(dev))
 		return -EBUSY;
 
 	if (wdev->cac_started)
-- 
1.8.1.4

