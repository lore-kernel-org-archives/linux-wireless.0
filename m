Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57424 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab1GQVBI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 17:01:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: backport: pr_FOO_once()
Date: Sun, 17 Jul 2011 23:00:57 +0200
Message-Id: <1310936457-10640-1-git-send-email-hauke@hauke-m.de> (sfid-20110717_230112_399817_594FB811)
In-Reply-To: <1310936291-10275-1-git-send-email-hauke@hauke-m.de>
References: <1310936291-10275-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

The other email did not make it through the spam filter.
 include/linux/compat-2.6.38.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 2dd1910..73f2aa4 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -46,6 +46,23 @@ static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 	return skb->csum_start - skb_headroom(skb);
 }
 
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
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.4.1

