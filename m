Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42494 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbZJFVQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 17:16:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/4] cfg80211: fix compile error from missing ethtool.h
Date: Tue,  6 Oct 2009 17:07:20 -0400
Message-Id: <1254863240-14780-4-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1254863240-14780-1-git-send-email-linville@tuxdriver.com>
References: <1254863240-14780-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/cfg80211.h |    1 +
 net/wireless/ethtool.h |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6f4862b..14915ea 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -18,6 +18,7 @@
 #include <linux/nl80211.h>
 #include <linux/if_ether.h>
 #include <linux/ieee80211.h>
+#include <linux/ethtool.h>
 #include <net/regulatory.h>
 
 /* remove once we remove the wext stuff */
diff --git a/net/wireless/ethtool.h b/net/wireless/ethtool.h
index 70cbee1..695ecad 100644
--- a/net/wireless/ethtool.h
+++ b/net/wireless/ethtool.h
@@ -1,8 +1,6 @@
 #ifndef __CFG80211_ETHTOOL__
 #define __CFG80211_ETHTOOL__
 
-#include <linux/ethtool.h>
-
 extern const struct ethtool_ops cfg80211_ethtool_ops;
 
 #endif /* __CFG80211_ETHTOOL__ */
-- 
1.6.2.5

