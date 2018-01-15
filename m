Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33704 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbeAOIkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 03:40:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: validate number of different channels
Date: Mon, 15 Jan 2018 09:40:05 +0100
Message-Id: <20180115084005.31865-1-johannes@sipsolutions.net> (sfid-20180115_094013_688746_7CF056C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When creating a new radio on the fly, hwsim allows this
to be done with an arbitrary number of channels, but
cfg80211 only supports a limited number of simultaneous
channels, leading to a warning.

Fix this by validating the number - this requires moving
the define for the maximum out to a visible header file.

Reported-by: syzbot+8dd9051ff19940290931@syzkaller.appspotmail.com
Fixes: b59ec8dd4394 ("mac80211_hwsim: fix number of channels in interface combinations")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 include/net/cfg80211.h                | 2 ++
 net/wireless/core.h                   | 2 --
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ccd573e53c92..f6d4a50f1bdb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3121,6 +3121,11 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		param.channels = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (param.channels > CFG80211_MAX_NUM_DIFFERENT_CHANNELS) {
+		GENL_SET_ERR_MSG(info, "too many channels specified");
+		return -EINVAL;
+	}
+
 	if (info->attrs[HWSIM_ATTR_NO_VIF])
 		param.no_vif = true;
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cb4d92b79cd9..fb94a8bd8ab5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -815,6 +815,8 @@ struct cfg80211_csa_settings {
 	u8 count;
 };
 
+#define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
+
 /**
  * struct iface_combination_params - input parameters for interface combinations
  *
diff --git a/net/wireless/core.h b/net/wireless/core.h
index d2f7e8b8a097..eaff636169c2 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -507,8 +507,6 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 		       struct wireless_dev *wdev);
 
-#define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
-
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
-- 
2.15.1
