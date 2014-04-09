Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34873 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIB26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:28:58 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so1756852pdi.30
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:28:58 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/8] cfg80211: remove unnecessary include clauses (cfg80211.h)
Date: Wed,  9 Apr 2014 09:28:10 +0800
Message-Id: <15e55cfd7a1dfa9e65bc2fe3210da5e71d922f34.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032904_286597_4040567D)
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<linux/if_ether.h> is included by <linux/ieee80211.h>;
<linux/skbuff.h> is included by <linux/if_ether.h>;
<linux/bug.h> and <linux/net.h> is included by <linux/skbuff.h>.

So just remove them.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 include/net/cfg80211.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fb8afce..6e32623 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -13,13 +13,9 @@
 #include <linux/netdevice.h>
 #include <linux/debugfs.h>
 #include <linux/list.h>
-#include <linux/bug.h>
 #include <linux/netlink.h>
-#include <linux/skbuff.h>
 #include <linux/nl80211.h>
-#include <linux/if_ether.h>
 #include <linux/ieee80211.h>
-#include <linux/net.h>
 #include <net/regulatory.h>
 
 /**
-- 
1.9.0

