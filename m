Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0KJCVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:55 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:55 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 36/44] compat/2.6.26: move unaligned backport to its own header
Date: Tue,  9 Nov 2010 21:20:18 -0500
Message-Id: <1289355626-25373-37-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/asm/unaligned.h |  194 +++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.26.h |  214 +----------------------------------------
 2 files changed, 197 insertions(+), 211 deletions(-)
 create mode 100644 include/linux/asm/unaligned.h

diff --git a/include/linux/asm/unaligned.h b/include/linux/asm/unaligned.h
new file mode 100644
index 0000000..7175e92
--- /dev/null
+++ b/include/linux/asm/unaligned.h
@@ -0,0 +1,194 @@
+#ifndef _COMPAT_ASM_UNALIGNED_H
+#define _COMPAT_ASM_UNALIGNED_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26))
+
+/*
+ * 2.6.26 added its own unaligned API which the
+ * new drivers can use. Lets port it here by including it in older
+ * kernels and also deal with the architecture handling here.
+ */
+
+#ifdef CONFIG_ALPHA
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* alpha */
+
+#ifdef CONFIG_ARM
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* arm */
+
+#ifdef CONFIG_AVR32
+/*
+ * AVR32 can handle some unaligned accesses, depending on the
+ * implementation.  The AVR32 AP implementation can handle unaligned
+ * words, but halfwords must be halfword-aligned, and doublewords must
+ * be word-aligned.
+ *
+ * However, swapped word loads must be word-aligned so we can't
+ * optimize word loads in general.
+ */
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif
+
+#ifdef CONFIG_BLACKFIN
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* blackfin */
+
+#ifdef CONFIG_CRIS
+/*
+ * CRIS can do unaligned accesses itself.
+ */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
+#endif /* cris */
+
+#ifdef CONFIG_FRV
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* frv */
+
+#ifdef CONFIG_H8300
+#include <linux/unaligned/be_memmove.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* h8300 */
+
+#ifdef  CONFIG_IA64
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* ia64 */
+
+#ifdef CONFIG_M32R
+#if defined(__LITTLE_ENDIAN__)
+# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+#else
+# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+#endif
+#endif /* m32r */
+
+#ifdef CONFIG_M68K /* this handles both m68k and m68knommu */
+#ifdef CONFIG_COLDFIRE
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#else
+/*
+ * The m68k can do unaligned accesses itself.
+ */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
+#endif
+#endif /* m68k and m68knommu */
+
+#ifdef CONFIG_MIPS
+#if defined(__MIPSEB__)
+# include <linux/unaligned/be_struct.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned  __get_unaligned_be
+# define put_unaligned  __put_unaligned_be
+#elif defined(__MIPSEL__)
+# include <linux/unaligned/le_struct.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+#endif
+#endif /* mips */
+
+#ifdef CONFIG_MN10300
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
+#endif /* mn10300 */
+
+#ifdef CONFIG_PARISC
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* parisc */
+
+#ifdef CONFIG_PPC
+/*
+ * The PowerPC can do unaligned accesses itself in big endian mode.
+ */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
+#endif /* ppc */
+
+#ifdef CONFIG_S390
+/*
+ * The S390 can do unaligned accesses itself.
+ */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
+#endif /* s390 */
+
+#ifdef CONFIG_SUPERH
+/* SH can't handle unaligned accesses. */
+#ifdef __LITTLE_ENDIAN__
+# include <linux/unaligned/le_struct.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+#else
+# include <linux/unaligned/be_struct.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+#endif
+#endif /* sh - SUPERH */
+
+#ifdef CONFIG_SPARC
+/* sparc and sparc64 */
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif  /* sparc */
+
+#ifdef CONFIG_UML
+#include "asm/arch/unaligned.h"
+#endif /* um - uml */
+
+#ifdef CONFIG_V850
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/generic.h>
+#endif /* v850 */
+
+#ifdef CONFIG_X86
+/*
+ * The x86 can do unaligned accesses itself.
+ */
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
+#endif /* x86 */
+
+#ifdef CONFIG_XTENSA
+#ifdef __XTENSA_EL__
+# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+#elif defined(__XTENSA_EB__)
+# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+#else
+# error processor byte order undefined!
+#endif
+#endif /* xtensa */
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26)) */
+
+#endif /* _COMPAT_ASM_UNALIGNED_H */
diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index 38e1d8d..9178e49 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -181,217 +181,9 @@ struct net *dev_net(const struct net_device *dev)
 #endif
 }
 
-
-/*
- * 2.6.26 added its own unaligned API which the
- * new drivers can use. Lets port it here by including it in older
- * kernels and also deal with the architecture handling here.
- */
-
-#ifdef CONFIG_ALPHA
-
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* alpha */
-#ifdef CONFIG_ARM
-
-/* arm */
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* arm */
-#ifdef CONFIG_AVR32
-
-/*
- * AVR32 can handle some unaligned accesses, depending on the
- * implementation.  The AVR32 AP implementation can handle unaligned
- * words, but halfwords must be halfword-aligned, and doublewords must
- * be word-aligned.
- *
- * However, swapped word loads must be word-aligned so we can't
- * optimize word loads in general.
- */
-
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif
-#ifdef CONFIG_BLACKFIN
-
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* blackfin */
-#ifdef CONFIG_CRIS
-
-/*
- * CRIS can do unaligned accesses itself.
- */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* cris */
-#ifdef CONFIG_FRV
-
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* frv */
-#ifdef CONFIG_H8300
-
-#include <linux/unaligned/be_memmove.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* h8300 */
-#ifdef  CONFIG_IA64
-
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* ia64 */
-#ifdef CONFIG_M32R
-
-#if defined(__LITTLE_ENDIAN__)
-# include <linux/unaligned/le_memmove.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-#else
-# include <linux/unaligned/be_memmove.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-#endif
-
-#endif /* m32r */
-#ifdef CONFIG_M68K /* this handles both m68k and m68knommu */
-
-#ifdef CONFIG_COLDFIRE
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-#else
-
-/*
- * The m68k can do unaligned accesses itself.
- */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-#endif
-
-#endif /* m68k and m68knommu */
-#ifdef CONFIG_MIPS
-
-#if defined(__MIPSEB__)
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned  __get_unaligned_be
-# define put_unaligned  __put_unaligned_be
-#elif defined(__MIPSEL__)
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-#endif
-
-#endif /* mips */
-#ifdef CONFIG_MN10300
-
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* mn10300 */
-#ifdef CONFIG_PARISC
-
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* parisc */
-#ifdef CONFIG_PPC
-/*
- * The PowerPC can do unaligned accesses itself in big endian mode.
- */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* ppc */
-#ifdef CONFIG_S390
-
-/*
- * The S390 can do unaligned accesses itself.
- */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* s390 */
-#ifdef CONFIG_SUPERH
-
-/* SH can't handle unaligned accesses. */
-#ifdef __LITTLE_ENDIAN__
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-#else
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-#endif
-
-#endif /* sh - SUPERH */
-#ifdef CONFIG_SPARC
-
-/* sparc and sparc64 */
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif  /* sparc */
-#ifdef CONFIG_UML
-
-#include "asm/arch/unaligned.h"
-
-#endif /* um - uml */
-#ifdef CONFIG_V850
-
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* v850 */
-#ifdef CONFIG_X86
-/*
- * The x86 can do unaligned accesses itself.
- */
-#include <linux/unaligned/access_ok.h>
-#include <linux/unaligned/generic.h>
-
-#endif /* x86 */
-#ifdef CONFIG_XTENSA
-
-#ifdef __XTENSA_EL__
-# include <linux/unaligned/le_memmove.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-#elif defined(__XTENSA_EB__)
-# include <linux/unaligned/be_memmove.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-#else
-# error processor byte order undefined!
-#endif
-
-#endif /* xtensa */
-
-#define PCIE_LINK_STATE_L0S	1
-#define PCIE_LINK_STATE_L1	2
-#define PCIE_LINK_STATE_CLKPM	4
+#define PCIE_LINK_STATE_L0S    1
+#define PCIE_LINK_STATE_L1     2
+#define PCIE_LINK_STATE_CLKPM  4
 
 static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
 {
-- 
1.7.2.30.gc37d7.dirty

