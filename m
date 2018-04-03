Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53856 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932081AbeDCMdz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 08:33:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: limit wiphy names to 128 bytes
Date: Tue,  3 Apr 2018 14:33:49 +0200
Message-Id: <20180403123349.21482-1-johannes@sipsolutions.net> (sfid-20180403_143401_863537_0B5C9DE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's currently no limit on wiphy names, other than netlink
message size and memory limitations, but that causes issues when,
for example, the wiphy name is used in a uevent, e.g. in rfkill
where we use the same name for the rfkill instance, and then the
buffer there is "only" 2k for the environment variables.

This was reported by syzkaller, which used a 4k name.

Limit the name to something reasonable, I randomly picked 128.

Reported-by: syzbot+230d9e642a85d3fec29c@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 net/wireless/core.c          | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c587a61c32bf..2e08c6f3ac3e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2618,6 +2618,8 @@ enum nl80211_attrs {
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
 #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
 
+#define NL80211_WIPHY_NAME_MAXLEN		128
+
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
 #define NL80211_MAX_SUPP_REG_RULES		64
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a6f3cac8c640..c0fd8a85e7f7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -95,6 +95,9 @@ static int cfg80211_dev_check_name(struct cfg80211_registered_device *rdev,
 
 	ASSERT_RTNL();
 
+	if (strlen(newname) > NL80211_WIPHY_NAME_MAXLEN)
+		return -EINVAL;
+
 	/* prohibit calling the thing phy%d when %d is not its number */
 	sscanf(newname, PHY_NAME "%d%n", &wiphy_idx, &taken);
 	if (taken == strlen(newname) && wiphy_idx != rdev->wiphy_idx) {
-- 
2.14.3
