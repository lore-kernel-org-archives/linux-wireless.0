Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36544 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753806AbcHSD7V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 23:59:21 -0400
Received: by mail-wm0-f46.google.com with SMTP id q128so18843393wma.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Aug 2016 20:58:54 -0700 (PDT)
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinan.gunawardena@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [RFC (v7)] add basic register-field manipulation macros
Date: Thu, 18 Aug 2016 18:11:57 +0100
Message-Id: <1471540317-14823-1-git-send-email-jakub.kicinski@netronome.com> (sfid-20160819_055927_563707_B50A27EC)
In-Reply-To: <CA+55aFz_MUXQjWjbQzb7f=+cQLtxQsba1azmbEVZOgy5Y7wfdQ@mail.gmail.com>
References: <CA+55aFz_MUXQjWjbQzb7f=+cQLtxQsba1azmbEVZOgy5Y7wfdQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

This is what I came up with.  Changes:
 - drop the explicit type marking (u32/u64) - depend on the type
   of the mask instead;
 - only allow compilation time constant masks;
 - barf at "type of register too small to ever match mask" on get;
 - rename PUT -> PREP.

I did not put the new marcos in bitops.h (where GENMASK lives)
because of the dependency on bug.h.  If I did there would be
a circular dependency like this:

bitops.h -> linux/bug.h -> asm-generic/bug.h -> kernel.h -> bitops.h

Which makes things really ugly.  I tried to remove the kernel.h
include from bug.h by separating panic-related definitions into
a new header.  There were still cycles coming from the notifier.h
which I had to include for panic notifier...

Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/linux/bitfield.h | 93 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bug.h      |  3 ++
 2 files changed, 96 insertions(+)
 create mode 100644 include/linux/bitfield.h

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
new file mode 100644
index 000000000000..32ca8863e66d
--- /dev/null
+++ b/include/linux/bitfield.h
@@ -0,0 +1,93 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _LINUX_BITFIELD_H
+#define _LINUX_BITFIELD_H
+
+#include <linux/bug.h>
+
+/*
+ * Bitfield access macros
+ *
+ * FIELD_{GET,PREP} macros take as first parameter shifted mask
+ * from which they extract the base mask and shift amount.
+ * Mask must be a compilation time constant.
+ *
+ * Example:
+ *
+ *  #define REG_FIELD_A  GENMASK(6, 0)
+ *  #define REG_FIELD_B  BIT(7)
+ *  #define REG_FIELD_C  GENMASK(15, 8)
+ *  #define REG_FIELD_D  GENMASK(31, 16)
+ *
+ * Get:
+ *  a = FIELD_GET(REG_FIELD_A, reg);
+ *  b = FIELD_GET(REG_FIELD_B, reg);
+ *
+ * Set:
+ *  reg = FIELD_PREP(REG_FIELD_A, 1) |
+ *	  FIELD_PREP(REG_FIELD_B, 0) |
+ *	  FIELD_PREP(REG_FIELD_C, c) |
+ *	  FIELD_PREP(REG_FIELD_D, 0x40);
+ *
+ * Modify:
+ *  reg &= ~REG_FIELD_C;
+ *  reg |= FIELD_PREP(REG_FIELD_C, c);
+ */
+
+#define _bf_shf(x) (__builtin_ffsll(x) - 1)
+
+#define _BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
+	({								\
+		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
+				 _pfx "mask is not constant");		\
+		BUILD_BUG_ON_MSG(!(_mask), _pfx "mask is zero");	\
+		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
+				 ~((_mask) >> _bf_shf(_mask)) & (_val) : 0, \
+				 _pfx "value too large for the field"); \
+		BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,		\
+				 _pfx "type of reg too small for mask"); \
+		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
+					      (1ULL << _bf_shf(_mask))); \
+	})
+
+/**
+ * FIELD_PREP() - prepare a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_val:  value to put in the field
+ *
+ * FIELD_PREP() masks and shifts up the value.  The result should
+ * be combined with other fields of the bitfield using logical OR.
+ */
+#define FIELD_PREP(_mask, _val)						\
+	({								\
+		_BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
+		((typeof(_mask))(_val) << _bf_shf(_mask)) & (_mask);	\
+	})
+
+/**
+ * FIELD_GET() - extract a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_reg:  32bit value of entire bitfield
+ *
+ * FIELD_GET() extracts the field specified by @_mask from the
+ * bitfield passed in as @_reg by masking and shifting it down.
+ */
+#define FIELD_GET(_mask, _reg)						\
+	({								\
+		_BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");	\
+		(typeof(_mask))(((_reg) & (_mask)) >> _bf_shf(_mask));	\
+	})
+
+#endif
diff --git a/include/linux/bug.h b/include/linux/bug.h
index e51b0709e78d..292d6a10b0c2 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -13,6 +13,7 @@ enum bug_trap_type {
 struct pt_regs;
 
 #ifdef __CHECKER__
+#define __BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
@@ -24,6 +25,8 @@ struct pt_regs;
 #else /* __CHECKER__ */
 
 /* Force a compilation error if a constant expression is not a power of 2 */
+#define __BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
+	BUILD_BUG_ON(((n) & ((n) - 1)) != 0)
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
 	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
 
-- 
1.9.1
