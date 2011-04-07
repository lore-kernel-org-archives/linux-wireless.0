Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52667 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab1DGOj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 10:39:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: add kstrtox
Date: Thu,  7 Apr 2011 16:39:17 +0200
Message-Id: <1302187158-15298-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1302187158-15298-1-git-send-email-hauke@hauke-m.de>
References: <1302187158-15298-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat/kstrtox.c is copied from lib/kstrtox.c in the Linux kernel.
This is needed by some drivers now.
For kernel < 2.6.26 div_u64 needs to be backported.

We should not copy the files like kstrtox.c, kfifo.c and so on to
compat/ by hand, but copy them when creating compat-wireless along with
the wireless drivers.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile               |    5 +-
 compat/kstrtox.c              |  227 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.26.h |   44 ++++++++
 include/linux/compat-2.6.39.h |   61 +++++++++++
 include/linux/math64.h        |   10 ++
 5 files changed, 346 insertions(+), 1 deletions(-)
 create mode 100644 compat/kstrtox.c
 create mode 100644 include/linux/math64.h

diff --git a/compat/Makefile b/compat/Makefile
index f92ac34..ddfd88d 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -30,4 +30,7 @@ compat-$(CONFIG_COMPAT_KERNEL_36) += \
 
 compat-$(CONFIG_COMPAT_KERNEL_37) += compat-2.6.37.o
 compat-$(CONFIG_COMPAT_KERNEL_38) += compat-2.6.38.o
-compat-$(CONFIG_COMPAT_KERNEL_39) += compat-2.6.39.o
+compat-$(CONFIG_COMPAT_KERNEL_39) += \
+	compat-2.6.39.o \
+	kstrtox.o
+
diff --git a/compat/kstrtox.c b/compat/kstrtox.c
new file mode 100644
index 0000000..05672e8
--- /dev/null
+++ b/compat/kstrtox.c
@@ -0,0 +1,227 @@
+/*
+ * Convert integer string representation to an integer.
+ * If an integer doesn't fit into specified type, -E is returned.
+ *
+ * Integer starts with optional sign.
+ * kstrtou*() functions do not accept sign "-".
+ *
+ * Radix 0 means autodetection: leading "0x" implies radix 16,
+ * leading "0" implies radix 8, otherwise radix is 10.
+ * Autodetection hints work after optional sign, but not before.
+ *
+ * If -E is returned, result is not touched.
+ */
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/math64.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+static inline char _tolower(const char c)
+{
+	return c | 0x20;
+}
+
+static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	unsigned long long acc;
+	int ok;
+
+	if (base == 0) {
+		if (s[0] == '0') {
+			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
+				base = 16;
+			else
+				base = 8;
+		} else
+			base = 10;
+	}
+	if (base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
+		s += 2;
+
+	acc = 0;
+	ok = 0;
+	while (*s) {
+		unsigned int val;
+
+		if ('0' <= *s && *s <= '9')
+			val = *s - '0';
+		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
+			val = _tolower(*s) - 'a' + 10;
+		else if (*s == '\n') {
+			if (*(s + 1) == '\0')
+				break;
+			else
+				return -EINVAL;
+		} else
+			return -EINVAL;
+
+		if (val >= base)
+			return -EINVAL;
+		if (acc > div_u64(ULLONG_MAX - val, base))
+			return -ERANGE;
+		acc = acc * base + val;
+		ok = 1;
+
+		s++;
+	}
+	if (!ok)
+		return -EINVAL;
+	*res = acc;
+	return 0;
+}
+
+int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
+{
+	if (s[0] == '+')
+		s++;
+	return _kstrtoull(s, base, res);
+}
+EXPORT_SYMBOL(kstrtoull);
+
+int kstrtoll(const char *s, unsigned int base, long long *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	if (s[0] == '-') {
+		rv = _kstrtoull(s + 1, base, &tmp);
+		if (rv < 0)
+			return rv;
+		if ((long long)(-tmp) >= 0)
+			return -ERANGE;
+		*res = -tmp;
+	} else {
+		rv = kstrtoull(s, base, &tmp);
+		if (rv < 0)
+			return rv;
+		if ((long long)tmp < 0)
+			return -ERANGE;
+		*res = tmp;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(kstrtoll);
+
+/* Internal, do not use. */
+int _kstrtoul(const char *s, unsigned int base, unsigned long *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(unsigned long)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(_kstrtoul);
+
+/* Internal, do not use. */
+int _kstrtol(const char *s, unsigned int base, long *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(long)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(_kstrtol);
+
+int kstrtouint(const char *s, unsigned int base, unsigned int *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(unsigned int)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtouint);
+
+int kstrtoint(const char *s, unsigned int base, int *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(int)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtoint);
+
+int kstrtou16(const char *s, unsigned int base, u16 *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(u16)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtou16);
+
+int kstrtos16(const char *s, unsigned int base, s16 *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(s16)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtos16);
+
+int kstrtou8(const char *s, unsigned int base, u8 *res)
+{
+	unsigned long long tmp;
+	int rv;
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (unsigned long long)(u8)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtou8);
+
+int kstrtos8(const char *s, unsigned int base, s8 *res)
+{
+	long long tmp;
+	int rv;
+
+	rv = kstrtoll(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if (tmp != (long long)(s8)tmp)
+		return -ERANGE;
+	*res = tmp;
+	return 0;
+}
+EXPORT_SYMBOL(kstrtos8);
diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index 30ee46c..9a67e9d 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -16,6 +16,7 @@
 #endif
 #include <linux/fs.h>
 #include <linux/types.h>
+#include <asm/div64.h>
 
 /* These jiffie helpers added as of 2.6.26 */
 
@@ -403,6 +404,49 @@ static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
 }
 /* source: include/linux/pci-aspm.h */
 
+
+#if BITS_PER_LONG == 64
+
+/**
+ * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
+ *
+ * This is commonly provided by 32bit archs to provide an optimized 64bit
+ * divide.
+ */
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+#elif BITS_PER_LONG == 32
+
+#ifndef div_u64_rem
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = do_div(dividend, divisor);
+	return dividend;
+}
+#endif
+
+#endif /* BITS_PER_LONG */
+
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+#ifndef div_u64
+static inline u64 div_u64(u64 dividend, u32 divisor)
+{
+	u32 remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+#endif
+/* source: include/math64.h */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26)) */
 
 #endif /* LINUX_26_26_COMPAT_H */
diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index 104fce0..3a366e2 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -7,6 +7,7 @@
 
 #include <linux/tty.h>
 #include <linux/irq.h>
+#include <linux/kernel.h>
 
 #define tiocmget(tty) tiocmget(tty, NULL)
 #define tiocmset(tty, set, clear) tiocmset(tty, NULL, set, clear)
@@ -93,6 +94,66 @@ static inline struct msi_desc *irq_desc_get_msi_desc(struct irq_desc *desc)
 }
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)) */
 
+/* Internal, do not use. */
+int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
+int __must_check _kstrtol(const char *s, unsigned int base, long *res);
+
+int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res);
+int __must_check kstrtoll(const char *s, unsigned int base, long long *res);
+static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
+{
+	/*
+	 * We want to shortcut function call, but
+	 * __builtin_types_compatible_p(unsigned long, unsigned long long) = 0.
+	 */
+	if (sizeof(unsigned long) == sizeof(unsigned long long) &&
+	    __alignof__(unsigned long) == __alignof__(unsigned long long))
+		return kstrtoull(s, base, (unsigned long long *)res);
+	else
+		return _kstrtoul(s, base, res);
+}
+
+static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
+{
+	/*
+	 * We want to shortcut function call, but
+	 * __builtin_types_compatible_p(long, long long) = 0.
+	 */
+	if (sizeof(long) == sizeof(long long) &&
+	    __alignof__(long) == __alignof__(long long))
+		return kstrtoll(s, base, (long long *)res);
+	else
+		return _kstrtol(s, base, res);
+}
+
+int __must_check kstrtouint(const char *s, unsigned int base, unsigned int *res);
+int __must_check kstrtoint(const char *s, unsigned int base, int *res);
+
+static inline int __must_check kstrtou64(const char *s, unsigned int base, u64 *res)
+{
+	return kstrtoull(s, base, res);
+}
+
+static inline int __must_check kstrtos64(const char *s, unsigned int base, s64 *res)
+{
+	return kstrtoll(s, base, res);
+}
+
+static inline int __must_check kstrtou32(const char *s, unsigned int base, u32 *res)
+{
+	return kstrtouint(s, base, res);
+}
+
+static inline int __must_check kstrtos32(const char *s, unsigned int base, s32 *res)
+{
+	return kstrtoint(s, base, res);
+}
+
+int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
+int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
+int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
+int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
 
 #endif /* LINUX_26_39_COMPAT_H */
diff --git a/include/linux/math64.h b/include/linux/math64.h
new file mode 100644
index 0000000..eb9e8e1
--- /dev/null
+++ b/include/linux/math64.h
@@ -0,0 +1,10 @@
+#ifndef _COMPAT_LINUX_MATH64_H
+#define _COMPAT_LINUX_MATH64_H 1
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25))
+#include_next <linux/math64.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25)) */
+
+#endif	/* _COMPAT_LINUX_MATH64_H */
-- 
1.7.1

