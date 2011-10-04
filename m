Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41106 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1JDLLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 07:11:55 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: add is_unicast_ether_addr
Date: Tue,  4 Oct 2011 13:11:46 +0200
Message-Id: <1317726707-23497-2-git-send-email-hauke@hauke-m.de> (sfid-20111004_131158_411773_89A5A39A)
In-Reply-To: <1317726707-23497-1-git-send-email-hauke@hauke-m.de>
References: <1317726707-23497-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.38.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 1f9ab52..ad04ebc 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -7,6 +7,7 @@
 
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/etherdevice.h>
 
 /* rename member in struct mmc_host in include/linux/mmc/host.h */
 #define max_segs	max_hw_segs
@@ -77,6 +78,17 @@ static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 
 #define ETH_P_LINK_CTL	0x886c		/* HPNA, wlan link local tunnel */
 
+/**
+ * is_unicast_ether_addr - Determine if the Ethernet address is unicast
+ * @addr: Pointer to a six-byte array containing the Ethernet address
+ *
+ * Return true if the address is a unicast address.
+ */
+static inline int is_unicast_ether_addr(const u8 *addr)
+{
+	return !is_multicast_ether_addr(addr);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.4.1

