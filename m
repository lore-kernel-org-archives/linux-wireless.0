Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43685 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZJGPBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 11:01:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] net/wireless/ethtool.h: drop unnecessary include of linux/ethtool.h
Date: Wed,  7 Oct 2009 10:52:13 -0400
Message-Id: <1254927133-24445-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Everything including this header includes net/cfg80211.h, which
includes linux/netdevice.h, which includes linux/ethtool.h already.  Why
slow-down the build, even a little bit?

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/ethtool.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

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

