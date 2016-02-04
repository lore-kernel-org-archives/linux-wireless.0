Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36279 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965559AbcBDVBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 16:01:19 -0500
Received: by mail-pa0-f52.google.com with SMTP id yy13so21366336pab.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 13:01:19 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Joe Perches <joe@perches.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>, x86@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] lib: move strtobool to kstrtobool
Date: Thu,  4 Feb 2016 13:00:40 -0800
Message-Id: <1454619643-14444-2-git-send-email-keescook@chromium.org> (sfid-20160204_220213_481451_CD4201B1)
In-Reply-To: <1454619643-14444-1-git-send-email-keescook@chromium.org>
References: <1454619643-14444-1-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create the kstrtobool_from_user helper and moves strtobool logic into
the new kstrtobool (matching all the other kstrto* functions). Provides
an inline wrapper for existing strtobool callers.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/kernel.h |  3 +++
 include/linux/string.h |  6 +++++-
 lib/kstrtox.c          | 35 +++++++++++++++++++++++++++++++++++
 lib/string.c           | 29 -----------------------------
 4 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f31638c6e873..cdc25f47a23f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -357,6 +357,7 @@ int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
 int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
 int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
 int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
+int __must_check kstrtobool(const char *s, unsigned int base, bool *res);
 
 int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
 int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
@@ -368,6 +369,8 @@ int __must_check kstrtou16_from_user(const char __user *s, size_t count, unsigne
 int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
 int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
 int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
+int __must_check kstrtobool_from_user(const char __user *s, size_t count,
+				      unsigned int base, bool *res);
 
 static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
 {
diff --git a/include/linux/string.h b/include/linux/string.h
index 9eebc66d957a..d2fb21b1081d 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -128,7 +128,11 @@ extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
-extern int strtobool(const char *s, bool *res);
+extern int kstrtobool(const char *s, unsigned int base, bool *res);
+static inline int strtobool(const char *s, bool *res)
+{
+	return kstrtobool(s, 0, res);
+}
 
 #ifdef CONFIG_BINARY_PRINTF
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 94be244e8441..e18f088704d7 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -321,6 +321,40 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
 }
 EXPORT_SYMBOL(kstrtos8);
 
+/**
+ * kstrtobool - convert common user inputs into boolean values
+ * @s: input string
+ * @base: ignored
+ * @res: result
+ *
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
+ * Otherwise it will return -EINVAL.  Value pointed to by res is
+ * updated upon finding a match.
+ */
+int kstrtobool(const char *s, unsigned int base, bool *res)
+{
+	if (!s)
+		return -EINVAL;
+
+	switch (s[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		*res = true;
+		return 0;
+	case 'n':
+	case 'N':
+	case '0':
+		*res = false;
+		return 0;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(kstrtobool);
+
 #define kstrto_from_user(f, g, type)					\
 int f(const char __user *s, size_t count, unsigned int base, type *res)	\
 {									\
@@ -345,3 +379,4 @@ kstrto_from_user(kstrtou16_from_user,	kstrtou16,	u16);
 kstrto_from_user(kstrtos16_from_user,	kstrtos16,	s16);
 kstrto_from_user(kstrtou8_from_user,	kstrtou8,	u8);
 kstrto_from_user(kstrtos8_from_user,	kstrtos8,	s8);
+kstrto_from_user(kstrtobool_from_user,	kstrtobool,	bool);
diff --git a/lib/string.c b/lib/string.c
index 0323c0d5629a..1a90db9bc6e1 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -630,35 +630,6 @@ bool sysfs_streq(const char *s1, const char *s2)
 }
 EXPORT_SYMBOL(sysfs_streq);
 
-/**
- * strtobool - convert common user inputs into boolean values
- * @s: input string
- * @res: result
- *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
- * Otherwise it will return -EINVAL.  Value pointed to by res is
- * updated upon finding a match.
- */
-int strtobool(const char *s, bool *res)
-{
-	switch (s[0]) {
-	case 'y':
-	case 'Y':
-	case '1':
-		*res = true;
-		break;
-	case 'n':
-	case 'N':
-	case '0':
-		*res = false;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(strtobool);
-
 #ifndef __HAVE_ARCH_MEMSET
 /**
  * memset - Fill a region of memory with the given value
-- 
2.6.3

