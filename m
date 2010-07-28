Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35811 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0G1X2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 19:28:52 -0400
Received: by bwz1 with SMTP id 1so15046bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 16:28:51 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: fix dev <-> wiphy typo
Date: Thu, 29 Jul 2010 01:28:46 +0200
Cc: Joe Perches <joe@perches.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007290128.46773.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ae80f8f..2fd06c6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2451,7 +2451,7 @@ int wiphy_debug(const struct wiphy *wiphy, const char *format, ...)
 	wiphy_printk(KERN_DEBUG, wiphy, format, ##args)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
 #define wiphy_dbg(wiphy, format, args...)			\
-	dynamic_pr_debug("%s: " format,	wiphy_name(dev), ##args)
+	dynamic_pr_debug("%s: " format,	wiphy_name(wiphy), ##args)
 #else
 #define wiphy_dbg(wiphy, format, args...)				\
 ({									\
