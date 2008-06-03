Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:22040 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946AbYFCT5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 15:57:45 -0400
Received: by nf-out-0910.google.com with SMTP id d3so661442nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 12:57:43 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/11 v2] rt2x00: Calculate register offset during compile time
Date: Tue, 3 Jun 2008 22:05:16 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032029.35662.IvDoorn@gmail.com>
In-Reply-To: <200806032029.35662.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806032205.17071.IvDoorn@gmail.com> (sfid-20080603_215801_894462_AB9F039C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00: Calculate register offset during compile time

By using __ffs() the register offsets were always calculated
at run-time which all FIELD32/FIELD16 definitions were builtin
constants. This means we can heavily optimize the register handling
by allowing GCC to do all the work during compilation.

Add some compile_ffs() macros to perform the calculation at
compile time. After this each rt2x00 module size is reduced
by ~2500 bytes. And the stack size of several functions is reduced
as well which further limits the number of rt2x00 results in
'make checkstack'.

v2: Merge GertJan's bugfix of patch [1/11] directly into this patch
      instead of providing it as seperate patch.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---
John, this patch is a combination of patch [1/11] and [2/11] so please
either apply those 2 patches or just this single patch to get the correct result :)
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 3f255df..7999d54 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -130,40 +130,71 @@ struct rt2x00_field32 {
 
 /*
  * Power of two check, this will check
- * if the mask that has been given contains
- * and contiguous set of bits.
+ * if the mask that has been given contains and contiguous set of bits.
+ * Note that we cannot use the is_power_of_2() function since this
+ * check must be done at compile-time.
  */
 #define is_power_of_two(x)	( !((x) & ((x)-1)) )
 #define low_bit_mask(x)		( ((x)-1) & ~(x) )
 #define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
 
+/*
+ * Macro's to find first set bit in a variable.
+ * These macro's behaves the same as the __ffs() function with
+ * the most important difference that this is done during
+ * compile-time rather then run-time.
+ */
+#define compile_ffs2(__x) \
+	( ((__x) & 0x1) ? 0 : 1 )
+
+#define compile_ffs4(__x) \
+	( ((__x) & 0x3) ? \
+	    compile_ffs2(__x) : (compile_ffs2(__x >> 2) + 2) )
+
+#define compile_ffs8(__x) \
+	( ((__x) & 0xf) ? \
+	    compile_ffs4(__x) : (compile_ffs4(__x >> 4) + 4) )
+
+#define compile_ffs16(__x) \
+	( ((__x) & 0xff) ? \
+	    compile_ffs8(__x) : (compile_ffs8(__x >> 8) + 8) )
+
+#define compile_ffs32(__x) \
+	( ((__x) & 0xffff) ? \
+	    compile_ffs16(__x) : (compile_ffs16(__x >> 16) + 16) )
+
+/*
+ * This macro will check the requirements for the FIELD{8,16,32} macros
+ * The mask should be a constant non-zero contiguous set of bits which
+ * does not exceed the given typelimit.
+ */
+#define FIELD_CHECK(__mask, __type)			\
+	BUILD_BUG_ON(!__builtin_constant_p(__mask) ||	\
+		     !(__mask) ||			\
+		     !is_valid_mask(__mask) ||		\
+		     (__mask) != (__type)(__mask))	\
+
 #define FIELD8(__mask)				\
 ({						\
-	BUILD_BUG_ON(!(__mask) ||		\
-		     !is_valid_mask(__mask) ||	\
-		     (__mask) != (u8)(__mask));	\
+	FIELD_CHECK(__mask, u8);		\
 	(struct rt2x00_field8) {		\
-		__ffs(__mask), (__mask)		\
+		compile_ffs8(__mask), (__mask)	\
 	};					\
 })
 
 #define FIELD16(__mask)				\
 ({						\
-	BUILD_BUG_ON(!(__mask) ||		\
-		     !is_valid_mask(__mask) ||	\
-		     (__mask) != (u16)(__mask));\
+	FIELD_CHECK(__mask, u16);		\
 	(struct rt2x00_field16) {		\
-		__ffs(__mask), (__mask)		\
+		compile_ffs16(__mask), (__mask)	\
 	};					\
 })
 
 #define FIELD32(__mask)				\
 ({						\
-	BUILD_BUG_ON(!(__mask) ||		\
-		     !is_valid_mask(__mask) ||	\
-		     (__mask) != (u32)(__mask));\
+	FIELD_CHECK(__mask, u32);		\
 	(struct rt2x00_field32) {		\
-		__ffs(__mask), (__mask)		\
+		compile_ffs32(__mask), (__mask)	\
 	};					\
 })
 
