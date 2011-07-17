Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43517 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab1GQU6X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 16:58:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: backport: alloc_netdev_mqs
Date: Sun, 17 Jul 2011 22:58:11 +0200
Message-Id: <1310936291-10275-3-git-send-email-hauke@hauke-m.de> (sfid-20110717_225826_222484_D5483B75)
In-Reply-To: <1310936291-10275-1-git-send-email-hauke@hauke-m.de>
References: <1310936291-10275-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.38.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 84310eb..2fe9adc 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -65,6 +65,9 @@ static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 
 #define ETH_P_LINK_CTL	0x886c		/* HPNA, wlan link local tunnel */
 
+#define alloc_netdev_mqs(sizeof_priv, name, setup, txqs, rxqs) \
+	alloc_netdev_mq(sizeof_priv, name, setup, max(txqs, rxqs))
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.4.1

