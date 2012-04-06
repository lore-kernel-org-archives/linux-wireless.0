Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab2DFVAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 17:00:37 -0400
Message-ID: <1333746034.5577.10.camel@jlt3.sipsolutions.net> (sfid-20120406_230040_490682_81867536)
Subject: [PATCH] compat: backport netif_wake_subqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Date: Fri, 06 Apr 2012 23:00:34 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Kernels 2.6.23 - 2.6.27 had some multiqueue support,
but called netif_wake_subqueue netif_start_subqueue.
So to backport, just add a define.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/compat-2.6.27.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index 22fadcd..1e2af80 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -256,6 +256,8 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  */
 #define lower_32_bits(n) ((u32)(n))
 
+#define netif_wake_subqueue netif_start_subqueue
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
 #endif /* LINUX_26_27_COMPAT_H */
-- 
1.7.9.1



