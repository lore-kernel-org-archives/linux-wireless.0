Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59761 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965246Ab2CBXFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 18:05:31 -0500
Received: by dajr28 with SMTP id r28so2500808daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 15:05:31 -0800 (PST)
MIME-Version: 1.0
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 2/3] cfg80211: expose cfg80211_calculate_bitrate()
Date: Fri,  2 Mar 2012 15:05:23 -0800
Message-Id: <1330729524-1010-2-git-send-email-thomas@cozybit.com> (sfid-20120303_000541_727353_7418B381)
In-Reply-To: <1330729524-1010-1-git-send-email-thomas@cozybit.com>
References: <1330729524-1010-1-git-send-email-thomas@cozybit.com>
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

