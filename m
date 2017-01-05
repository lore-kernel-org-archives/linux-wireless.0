Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49494 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032002AbdAEMi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 07:38:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mwifiex: don't include mac80211.h
Date: Thu,  5 Jan 2017 13:38:35 +0100
Message-Id: <20170105123835.20995-1-johannes@sipsolutions.net> (sfid-20170105_133909_916401_BEA64E4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This driver doesn't use mac80211, so it shouldn't include mac80211.h,
include only the necessary cfg80211.h instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This depends on the patch moving IEEE80211_NUM_ACS.
---
 drivers/net/wireless/marvell/mwifiex/decl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/decl.h b/drivers/net/wireless/marvell/mwifiex/decl.h
index bec300b9c2ea..188e4c370836 100644
--- a/drivers/net/wireless/marvell/mwifiex/decl.h
+++ b/drivers/net/wireless/marvell/mwifiex/decl.h
@@ -27,7 +27,7 @@
 #include <linux/timer.h>
 #include <linux/ieee80211.h>
 #include <uapi/linux/if_arp.h>
-#include <net/mac80211.h>
+#include <net/cfg80211.h>
 
 #define MWIFIEX_BSS_COEX_COUNT	     2
 #define MWIFIEX_MAX_BSS_NUM         (3)
-- 
2.9.3
