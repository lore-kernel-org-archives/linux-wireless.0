Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45705 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaDQN2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 09:28:09 -0400
Received: by mail-pd0-f180.google.com with SMTP id v10so371494pde.39
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 06:28:08 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 6/6] cfg80211: remove function wiphy_debug()
Date: Thu, 17 Apr 2014 21:27:14 +0800
Message-Id: <916d5b003247958845d5585757a6a51316bc783c.1397741141.git.gamerh2o@gmail.com> (sfid-20140417_152813_100781_56063AEA)
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamic debug function wiphy_dbg() is more convenient for debugging,
and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
normal static debug, just as what wiphy_debug() does.

All the uses of wiphy_debug() are replaced with wiphy_dbg(), so
wiphy_debug() can be removed.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 include/net/cfg80211.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f3539a1..ace298f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4702,10 +4702,6 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
 	dev_notice(&(wiphy)->dev, format, ##args)
 #define wiphy_info(wiphy, format, args...)			\
 	dev_info(&(wiphy)->dev, format, ##args)
-
-#define wiphy_debug(wiphy, format, args...)			\
-	wiphy_printk(KERN_DEBUG, wiphy, format, ##args)
-
 #define wiphy_dbg(wiphy, format, args...)			\
 	dev_dbg(&(wiphy)->dev, format, ##args)
 
-- 
1.9.0

