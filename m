Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50388 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752721AbcJZJpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 05:45:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: only ask about WDS if EXPERT is selected
Date: Wed, 26 Oct 2016 11:44:50 +0200
Message-Id: <1477475090-747-1-git-send-email-johannes@sipsolutions.net> (sfid-20161026_114546_153382_6656D6BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There won't be any users of this that really need it and
aren't already experts in how the kernel functions, so
require setting EXPERT to reach this setting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index fa9c4fa9477e..8f5a3f4a43f2 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -18,7 +18,7 @@ menuconfig WLAN
 if WLAN
 
 config WIRELESS_WDS
-	bool "mac80211-based legacy WDS support"
+	bool "mac80211-based legacy WDS support" if EXPERT
 	help
 	  This option enables the deprecated WDS support, the newer
 	  mac80211-based 4-addr AP/client support supersedes it with
-- 
2.8.1
