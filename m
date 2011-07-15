Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab1GOPvR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 11:51:17 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] compat: add alloc_netdev_mqs
Date: Fri, 15 Jul 2011 17:50:26 +0200
Message-Id: <1310745026-2282-2-git-send-email-sgruszka@redhat.com> (sfid-20110715_175128_766934_B21F5CB3)
In-Reply-To: <1310745026-2282-1-git-send-email-sgruszka@redhat.com>
References: <1310745026-2282-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function was added in 2.6.38 kernel commit:

commit 36909ea43814cba34f7c921e99cba33d770a54e1
Author: Tom Herbert <therbert@google.com>
Date:   Sun Jan 9 19:36:31 2011 +0000

    net: Add alloc_netdev_mqs function

Emulate it using alloc_netdev_mq(), newer kernels use
opposite emulation method :-)

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/linux/compat-2.6.38.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index dfe1250..937976b 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -71,6 +71,10 @@ static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+/* include/linux/netdevice.h */
+#define alloc_netdev_mqs(sizeof_priv, name, setup, txqs, rxqs) \
+	alloc_netdev_mq(sizeof_priv, name, setup, max(txqs, rxqs))
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.1

