Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24004 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbcBVLuA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 06:50:00 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] codel: cast the output of MS2TIME to codel_time_t
Date: Mon, 22 Feb 2016 13:49:47 +0200
Message-Id: <1456141787-18143-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160222_125013_235994_6B6F9EA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow to pass the typecheck in the comparators:
codel_time_{after,before}

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/codel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/codel.h b/include/net/codel.h
index 267e702..0d92e39 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -62,7 +62,7 @@
 typedef u32 codel_time_t;
 typedef s32 codel_tdiff_t;
 #define CODEL_SHIFT 10
-#define MS2TIME(a) ((a * NSEC_PER_MSEC) >> CODEL_SHIFT)
+#define MS2TIME(a) ((codel_time_t)((a * NSEC_PER_MSEC) >> CODEL_SHIFT))
 
 static inline codel_time_t codel_get_time(void)
 {
-- 
2.5.0

