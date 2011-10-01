Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37690 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab1JAKdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 06:33:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add skb_tx_timestamp() and skb_defer_rx_timestamp()
Date: Sat,  1 Oct 2011 12:32:54 +0200
Message-Id: <1317465174-2685-1-git-send-email-hauke@hauke-m.de> (sfid-20111001_123319_532661_F2C6BE57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just add an empty implementation of these functions to do the same as
when timestamping is deactivated.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.36.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 7bb2bb8..f4d6f80 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -125,6 +125,15 @@ static inline void tty_unlock(void) __releases(kernel_lock)
 
 static inline void pm_wakeup_event(struct device *dev, unsigned int msec) {}
 
+static inline bool skb_defer_rx_timestamp(struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline void skb_tx_timestamp(struct sk_buff *skb)
+{
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.4.1

