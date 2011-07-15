Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab1GOPvS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 11:51:18 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] compat: add pr_<level>_once macros
Date: Fri, 15 Jul 2011 17:50:25 +0200
Message-Id: <1310745026-2282-1-git-send-email-sgruszka@redhat.com> (sfid-20110715_175129_310920_6883C38B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add functions from 2.6.38 kernel commit:

commit 16cb839f13324978bd58082e69de81a711802b11
Author: Joe Perches <joe@perches.com>
Date:   Wed Jan 12 16:59:46 2011 -0800

    include/linux/printk.h: add pr_<level>_once macros

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/linux/compat-2.6.38.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 2dd1910..dfe1250 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -46,6 +46,31 @@ static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 	return skb->csum_start - skb_headroom(skb);
 }
 
+/* from include/linux/printk.h */ 
+#define pr_emerg_once(fmt, ...)					\
+	printk_once(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_once(fmt, ...)					\
+	printk_once(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_once(fmt, ...)					\
+	printk_once(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_once(fmt, ...)					\
+	printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn_once(fmt, ...)					\
+	printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_once(fmt, ...)				\
+	printk_once(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_once(fmt, ...)					\
+	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont_once(fmt, ...)					\
+	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
+#if defined(DEBUG)
+#define pr_debug_once(fmt, ...)					\
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_once(fmt, ...)					\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.1

