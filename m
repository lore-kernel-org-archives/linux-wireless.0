Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFIpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 04:45:32 -0400
Subject: [PATCH] compat: fix warning in alloc_netdev_mqs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 10:45:26 +0200
Message-ID: <1317890726.3945.0.camel@jlt3.sipsolutions.net> (sfid-20111006_104536_245695_B061E061)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on the arguments to alloc_netdev_mqs(),
it may give a warning due to the use of max().
Fix the warning with max_t().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/compat-2.6.38.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 1f9ab52..06bbd9d 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -73,7 +73,8 @@ static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 
 /* include/linux/netdevice.h */
 #define alloc_netdev_mqs(sizeof_priv, name, setup, txqs, rxqs) \
-	alloc_netdev_mq(sizeof_priv, name, setup, max(txqs, rxqs))
+	alloc_netdev_mq(sizeof_priv, name, setup, \
+			max_t(unsigned int, txqs, rxqs))
 
 #define ETH_P_LINK_CTL	0x886c		/* HPNA, wlan link local tunnel */
 
-- 
1.7.6.3



