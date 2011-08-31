Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45253 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab1HaWU3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 18:20:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: add kstrtou8_from_user
Date: Thu,  1 Sep 2011 00:20:12 +0200
Message-Id: <1314829212-27365-3-git-send-email-hauke@hauke-m.de> (sfid-20110901_002035_037690_910EBF51)
In-Reply-To: <1314829212-27365-1-git-send-email-hauke@hauke-m.de>
References: <1314829212-27365-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-3.0.c        |   25 +++++++++++++++++++++++++
 include/linux/compat-3.0.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/compat/compat-3.0.c b/compat/compat-3.0.c
index 312eea0..f517e9f 100644
--- a/compat/compat-3.0.c
+++ b/compat/compat-3.0.c
@@ -35,3 +35,28 @@ int mac_pton(const char *s, u8 *mac)
 	return 1;
 }
 EXPORT_SYMBOL(mac_pton);
+
+#define kstrto_from_user(f, g, type)					\
+int f(const char __user *s, size_t count, unsigned int base, type *res)	\
+{									\
+	/* sign, base 2 representation, newline, terminator */		\
+	char buf[1 + sizeof(type) * 8 + 1 + 1];				\
+									\
+	count = min(count, sizeof(buf) - 1);				\
+	if (copy_from_user(buf, s, count))				\
+		return -EFAULT;						\
+	buf[count] = '\0';						\
+	return g(buf, base, res);					\
+}									\
+EXPORT_SYMBOL(f)
+
+kstrto_from_user(kstrtoull_from_user,	kstrtoull,	unsigned long long);
+kstrto_from_user(kstrtoll_from_user,	kstrtoll,	long long);
+kstrto_from_user(kstrtoul_from_user,	kstrtoul,	unsigned long);
+kstrto_from_user(kstrtol_from_user,	kstrtol,	long);
+kstrto_from_user(kstrtouint_from_user,	kstrtouint,	unsigned int);
+kstrto_from_user(kstrtoint_from_user,	kstrtoint,	int);
+kstrto_from_user(kstrtou16_from_user,	kstrtou16,	u16);
+kstrto_from_user(kstrtos16_from_user,	kstrtos16,	s16);
+kstrto_from_user(kstrtou8_from_user,	kstrtou8,	u8);
+kstrto_from_user(kstrtos8_from_user,	kstrtos8,	s8);
diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
index 7954ddb..8c8720e 100644
--- a/include/linux/compat-3.0.h
+++ b/include/linux/compat-3.0.h
@@ -48,6 +48,37 @@ struct bcma_device_id {
 
 int mac_pton(const char *s, u8 *mac);
 
+int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
+int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
+int __must_check kstrtoul_from_user(const char __user *s, size_t count, unsigned int base, unsigned long *res);
+int __must_check kstrtol_from_user(const char __user *s, size_t count, unsigned int base, long *res);
+int __must_check kstrtouint_from_user(const char __user *s, size_t count, unsigned int base, unsigned int *res);
+int __must_check kstrtoint_from_user(const char __user *s, size_t count, unsigned int base, int *res);
+int __must_check kstrtou16_from_user(const char __user *s, size_t count, unsigned int base, u16 *res);
+int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
+int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
+int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
+
+static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
+{
+	return kstrtoull_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos64_from_user(const char __user *s, size_t count, unsigned int base, s64 *res)
+{
+	return kstrtoll_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtou32_from_user(const char __user *s, size_t count, unsigned int base, u32 *res)
+{
+	return kstrtouint_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos32_from_user(const char __user *s, size_t count, unsigned int base, s32 *res)
+{
+	return kstrtoint_from_user(s, count, base, res);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)) */
 
 #endif /* LINUX_3_0_COMPAT_H */
-- 
1.7.4.1

