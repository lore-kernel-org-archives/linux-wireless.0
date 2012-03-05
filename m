Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34620 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2CEVRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 16:17:09 -0500
Received: by dadp12 with SMTP id p12so5622317dad.11
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 13:17:08 -0800 (PST)
MIME-Version: 1.0
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH v3 1/2] cfg80211: expose cfg80211_calculate_bitrate()
Date: Mon,  5 Mar 2012 13:17:02 -0800
Message-Id: <1330982223-8379-1-git-send-email-thomas@cozybit.com> (sfid-20120305_221722_350661_696F33E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/cfg80211.h |    8 ++++++++
 net/wireless/util.c    |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0178c74..64f6181 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3334,6 +3334,14 @@ int cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type);
 
+/*
+ * cfg80211_calculate_bitrate - calculate actual bitrate (in 100Kbps units)
+ * @rate: given rate_info to calculate bitrate from
+ *
+ * return 0 if MCS index >= 32
+ */
+u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9aa9db6..1b7a08d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -904,6 +904,7 @@ u16 cfg80211_calculate_bitrate(struct rate_info *rate)
 	/* do NOT round down here */
 	return (bitrate + 50000) / 100000;
 }
+EXPORT_SYMBOL(cfg80211_calculate_bitrate);
 
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int)
-- 
1.7.5.4

