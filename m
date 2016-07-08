Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1731 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbcGHKdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 06:33:20 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <ganeshk@qti.qualcomm.com>,
	<mkalikot@qca.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<pkushwah@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Allow different beacon interval support on virtual interface.
Date: Fri, 8 Jul 2016 16:02:15 +0530
Message-ID: <1467973935-32308-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160708_123324_430404_DB5D112A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver may support different beacon interval on virtual interfaces.
Allow setting different beacon interval per interface if driver has
such support.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h | 5 +++++
 net/wireless/util.c    | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..2dd9152 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3292,6 +3292,9 @@ struct wiphy_iftype_ext_capab {
  * @bss_select_support: bitmask indicating the BSS selection criteria supported
  *	by the driver in the .connect() callback. The bit position maps to the
  *	attribute indices defined in &enum nl80211_bss_select_attr.
+ * @support_different_beacon_interval: support of different beacon_interval on
+ *	virtual interfaces. This should be set if driver wishes to advertise
+ *	support for different beacon_interval.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3421,6 +3424,8 @@ struct wiphy {
 
 	u32 bss_select_support;
 
+	bool support_different_beacon_interval;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2443ee3..253d303 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1560,6 +1560,9 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	if (!beacon_int)
 		return -EINVAL;
 
+	if (rdev->wiphy.support_different_beacon_interval)
+		return 0;
+
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
-- 
1.9.1

