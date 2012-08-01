Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43318 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab2HAXFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 19:05:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: add sk_entry
Date: Thu,  2 Aug 2012 01:05:23 +0200
Message-Id: <1343862324-26057-2-git-send-email-hauke@hauke-m.de> (sfid-20120802_010542_719800_8081C27F)
In-Reply-To: <1343862324-26057-1-git-send-email-hauke@hauke-m.de>
References: <1343862324-26057-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is copied from the kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 39bc13b..b8b48c0 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -8,6 +8,7 @@
 #include <linux/netdevice.h>
 #include <linux/usb.h>
 #include <linux/mmc/sdio_func.h>
+#include <net/sock.h>
 
 /*
  * Backports da68c4eb25
@@ -325,6 +326,11 @@ extern struct hlist_node *seq_hlist_start_head(struct hlist_head *head,
 extern struct hlist_node *seq_hlist_next(void *v, struct hlist_head *head,
 					 loff_t *ppos);
 
+static inline struct sock *sk_entry(const struct hlist_node *node)
+{
+	return hlist_entry(node, struct sock, sk_node);
+}
+
 #else /* Kernels >= 2.6.34 */
 
 static inline void init_compat_mmc_pm_flags(void)
-- 
1.7.9.5

