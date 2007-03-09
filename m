Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:21203 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992834AbXCIPLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 10:11:50 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1357061uga
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2007 07:11:48 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3] rt2x00: Fix power of 2 check
Date: Fri, 9 Mar 2007 16:11:33 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <200703082214.52864.IvDoorn@gmail.com> <200703091148.33889.IvDoorn@gmail.com>
In-Reply-To: <200703091148.33889.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703091611.33521.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup code, make gcc happy, make sparse happy. What a happy patch ;)
This cleans up the code used to check the validity of the register fields,
this will also reduce the required memory usage while working with sparse.
This patch was inspired on the codesuggestions from Linus.

This update also includes a check if the first found bit does not exceed the
16bit or 32 bit limit.
 
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

Sorry for all the spamming, this is the correct version of the patch.

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index b64d7ee..cea6bb1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -206,171 +206,10 @@ enum cipher {
 };
 
 /*
- * Macros for determining which is the lowest or highest bit
- * set in a 16 or 32 bit variable.
- */
-#define BIT_SET(__val, __bit)	(__val & (1 << __bit))
-
-#define BIT_OK(__val, __bit, __low, __high) \
-	(__bit < __low ? 1 : \
-	(__bit > __high ? 1 : \
-	BIT_SET(__val, __bit) ? 1 : 0))
-
-#define LOWEST_BIT16(__val) \
-	(BIT_SET(__val, 0) ? 0 : (BIT_SET(__val, 1) ? 1 : \
-	(BIT_SET(__val, 2) ? 2 : (BIT_SET(__val, 3) ? 3 : \
-	(BIT_SET(__val, 4) ? 4 : (BIT_SET(__val, 5) ? 5 : \
-	(BIT_SET(__val, 6) ? 6 : (BIT_SET(__val, 7) ? 7 : \
-	(BIT_SET(__val, 8) ? 8 : (BIT_SET(__val, 9) ? 9 : \
-	(BIT_SET(__val, 10) ? 10 : (BIT_SET(__val, 11) ? 11 : \
-	(BIT_SET(__val, 12) ? 12 : (BIT_SET(__val, 13) ? 13 : \
-	(BIT_SET(__val, 14) ? 14 : (BIT_SET(__val, 15) ? 15 : \
-	-EINVAL))))))))))))))))
-
-#define LOWEST_BIT32(__val) \
-	(BIT_SET(__val, 0) ? 0 : (BIT_SET(__val, 1) ? 1 : \
-	(BIT_SET(__val, 2) ? 2 : (BIT_SET(__val, 3) ? 3 : \
-	(BIT_SET(__val, 4) ? 4 : (BIT_SET(__val, 5) ? 5 : \
-	(BIT_SET(__val, 6) ? 6 : (BIT_SET(__val, 7) ? 7 : \
-	(BIT_SET(__val, 8) ? 8 : (BIT_SET(__val, 9) ? 9 : \
-	(BIT_SET(__val, 10) ? 10 : (BIT_SET(__val, 11) ? 11 : \
-	(BIT_SET(__val, 12) ? 12 : (BIT_SET(__val, 13) ? 13 : \
-	(BIT_SET(__val, 14) ? 14 : (BIT_SET(__val, 15) ? 15 : \
-	(BIT_SET(__val, 16) ? 16 : (BIT_SET(__val, 17) ? 17 : \
-	(BIT_SET(__val, 18) ? 18 : (BIT_SET(__val, 19) ? 19 : \
-	(BIT_SET(__val, 20) ? 20 : (BIT_SET(__val, 21) ? 21 : \
-	(BIT_SET(__val, 22) ? 22 : (BIT_SET(__val, 23) ? 23 : \
-	(BIT_SET(__val, 24) ? 24 : (BIT_SET(__val, 25) ? 25 : \
-	(BIT_SET(__val, 26) ? 27 : (BIT_SET(__val, 27) ? 27 : \
-	(BIT_SET(__val, 28) ? 28 : (BIT_SET(__val, 29) ? 29 : \
-	(BIT_SET(__val, 30) ? 30 : (BIT_SET(__val, 31) ? 31 : \
-	-EINVAL))))))))))))))))))))))))))))))))
-
-#define HIGHEST_BIT16(__val) \
-	(BIT_SET(__val, 15) ? 15 : (BIT_SET(__val, 14) ? 14 : \
-	(BIT_SET(__val, 13) ? 13 : (BIT_SET(__val, 12) ? 12 : \
-	(BIT_SET(__val, 11) ? 11 : (BIT_SET(__val, 10) ? 10 : \
-	(BIT_SET(__val, 9) ? 9 : (BIT_SET(__val, 8) ? 8 : \
-	(BIT_SET(__val, 7) ? 7 : (BIT_SET(__val, 6) ? 6 : \
-	(BIT_SET(__val, 5) ? 5 : (BIT_SET(__val, 4) ? 4 : \
-	(BIT_SET(__val, 3) ? 3 : (BIT_SET(__val, 2) ? 2 : \
-	(BIT_SET(__val, 1) ? 1 : (BIT_SET(__val, 0) ? 0 : \
-	-EINVAL))))))))))))))))
-
-#define HIGHEST_BIT32(__val) \
-	(BIT_SET(__val, 31) ? 31 : (BIT_SET(__val, 30) ? 30 : \
-	(BIT_SET(__val, 29) ? 29 : (BIT_SET(__val, 28) ? 28 : \
-	(BIT_SET(__val, 27) ? 27 : (BIT_SET(__val, 26) ? 26 : \
-	(BIT_SET(__val, 25) ? 25 : (BIT_SET(__val, 24) ? 24 : \
-	(BIT_SET(__val, 23) ? 23 : (BIT_SET(__val, 22) ? 22 : \
-	(BIT_SET(__val, 21) ? 21 : (BIT_SET(__val, 20) ? 20 : \
-	(BIT_SET(__val, 19) ? 19 : (BIT_SET(__val, 18) ? 18 : \
-	(BIT_SET(__val, 17) ? 17 : (BIT_SET(__val, 16) ? 16 : \
-	(BIT_SET(__val, 15) ? 15 : (BIT_SET(__val, 14) ? 14 : \
-	(BIT_SET(__val, 13) ? 13 : (BIT_SET(__val, 12) ? 12 : \
-	(BIT_SET(__val, 11) ? 11 : (BIT_SET(__val, 10) ? 10 : \
-	(BIT_SET(__val, 9) ? 9 : (BIT_SET(__val, 8) ? 8 : \
-	(BIT_SET(__val, 7) ? 7 : (BIT_SET(__val, 6) ? 6 : \
-	(BIT_SET(__val, 5) ? 5 : (BIT_SET(__val, 4) ? 4 : \
-	(BIT_SET(__val, 3) ? 3 : (BIT_SET(__val, 2) ? 2 : \
-	(BIT_SET(__val, 1) ? 1 : (BIT_SET(__val, 0) ? 0 : \
-	-EINVAL))))))))))))))))))))))))))))))))
-
-#define BITRANGE_OK16(__val, __low, __high) \
-	((BIT_OK(__val, 0, __low, __high) && \
-	  BIT_OK(__val, 1, __low, __high) && \
-	  BIT_OK(__val, 2, __low, __high) && \
-	  BIT_OK(__val, 3, __low, __high) && \
-	  BIT_OK(__val, 4, __low, __high) && \
-	  BIT_OK(__val, 5, __low, __high) && \
-	  BIT_OK(__val, 6, __low, __high) && \
-	  BIT_OK(__val, 7, __low, __high) && \
-	  BIT_OK(__val, 8, __low, __high) && \
-	  BIT_OK(__val, 9, __low, __high) && \
-	  BIT_OK(__val, 10, __low, __high) && \
-	  BIT_OK(__val, 11, __low, __high) && \
-	  BIT_OK(__val, 12, __low, __high) && \
-	  BIT_OK(__val, 13, __low, __high) && \
-	  BIT_OK(__val, 14, __low, __high) && \
-	  BIT_OK(__val, 15, __low, __high)) ? \
-	0 : -EINVAL)
-
-#define BITRANGE_OK32(__val, __low, __high) \
-	((BIT_OK(__val, 0, __low, __high) && \
-	  BIT_OK(__val, 1, __low, __high) && \
-	  BIT_OK(__val, 2, __low, __high) && \
-	  BIT_OK(__val, 3, __low, __high) && \
-	  BIT_OK(__val, 4, __low, __high) && \
-	  BIT_OK(__val, 5, __low, __high) && \
-	  BIT_OK(__val, 6, __low, __high) && \
-	  BIT_OK(__val, 7, __low, __high) && \
-	  BIT_OK(__val, 8, __low, __high) && \
-	  BIT_OK(__val, 9, __low, __high) && \
-	  BIT_OK(__val, 10, __low, __high) && \
-	  BIT_OK(__val, 11, __low, __high) && \
-	  BIT_OK(__val, 12, __low, __high) && \
-	  BIT_OK(__val, 13, __low, __high) && \
-	  BIT_OK(__val, 14, __low, __high) && \
-	  BIT_OK(__val, 15, __low, __high) && \
-	  BIT_OK(__val, 16, __low, __high) && \
-	  BIT_OK(__val, 17, __low, __high) && \
-	  BIT_OK(__val, 18, __low, __high) && \
-	  BIT_OK(__val, 19, __low, __high) && \
-	  BIT_OK(__val, 20, __low, __high) && \
-	  BIT_OK(__val, 21, __low, __high) && \
-	  BIT_OK(__val, 22, __low, __high) && \
-	  BIT_OK(__val, 23, __low, __high) && \
-	  BIT_OK(__val, 24, __low, __high) && \
-	  BIT_OK(__val, 25, __low, __high) && \
-	  BIT_OK(__val, 26, __low, __high) && \
-	  BIT_OK(__val, 27, __low, __high) && \
-	  BIT_OK(__val, 28, __low, __high) && \
-	  BIT_OK(__val, 29, __low, __high) && \
-	  BIT_OK(__val, 30, __low, __high) && \
-	  BIT_OK(__val, 31, __low, __high)) ? \
-	0 : -EINVAL)
-
-extern int error_lowest_bit_not_constant;
-extern int error_highest_bit_not_constant;
-extern int error_bitrange_not_constant;
-extern int error_bitrange_bad;
-
-#define BUILD_LOWEST_BIT16(__val) \
-	(!__builtin_constant_p(__val) ? error_lowest_bit_not_constant : \
-	LOWEST_BIT16(__val))
-
-#define BUILD_LOWEST_BIT32(__val) \
-	(!__builtin_constant_p(__val) ? error_lowest_bit_not_constant : \
-	LOWEST_BIT32(__val))
-
-#define BUILD_HIGHEST_BIT16(__val) \
-	(!__builtin_constant_p(__val) ? error_highest_bit_not_constant : \
-	HIGHEST_BIT16(__val))
-
-#define BUILD_HIGHEST_BIT32(__val) \
-	(!__builtin_constant_p(__val) ? error_highest_bit_not_constant : \
-	HIGHEST_BIT32(__val))
-
-#define BUILD_BITRANGE_OK16(__val, __low, __high) \
-	((!__builtin_constant_p(__val) || !__builtin_constant_p(__low) || \
-	  !__builtin_constant_p(__high)) ? error_bitrange_not_constant : \
-	BITRANGE_OK16(__val, __low, __high))
-
-#define BUILD_BITRANGE_OK32(__val, __low, __high) \
-	((!__builtin_constant_p(__val) || !__builtin_constant_p(__low) || \
-	  !__builtin_constant_p(__high)) ? error_bitrange_not_constant : \
-	BITRANGE_OK16(__val, __low, __high))
-
-/*
  * Register handlers.
  * We store the position of a register field inside a field structure,
  * This will simplify the process of setting and reading a certain field
  * inside the register while making sure the process remains byte order safe.
- * Before setting the value into the structure we use macros to determine
- * whether all bits in the field are contineous and valid.
- * These additional checks will be optimized away at compile time,
- * but do have a major impact on compile speed, therefor we only make this
- * check when compiling with debug enabled.
  */
 struct rt2x00_field16 {
 	u16 bit_offset;
@@ -383,39 +222,33 @@ struct rt2x00_field32 {
 };
 
 /*
- * Before intitializing the rt2x00_field# structures,
- * we will check if the bitmask is correct and does
- * not contain any gaps.
- * This check is only done in debug mode, since it severely
- * impacts compilation speed.
+ * Power of two check from Linus Torvalds,
+ * this will check if the mask that has been
+ * given contains and contiguous set of bits.
  */
-#ifdef CONFIG_RT2X00_DEBUG
-#define FIELD16(__mask) \
-	( (struct rt2x00_field16) { \
-		(BUILD_BITRANGE_OK16(__mask, BUILD_LOWEST_BIT16(__mask), \
-			BUILD_HIGHEST_BIT16(__mask)) == 0) ? \
-		BUILD_LOWEST_BIT16(__mask) : error_bitrange_bad, \
-		(__mask) \
-	} )
-
-#define FIELD32(__mask) \
-	( (struct rt2x00_field32) { \
-		(BUILD_BITRANGE_OK32(__mask, BUILD_LOWEST_BIT32(__mask), \
-			BUILD_HIGHEST_BIT32(__mask)) == 0) ? \
-		BUILD_LOWEST_BIT32(__mask) : error_bitrange_bad, \
-		(__mask) \
-	} )
-#else /* CONFIG_RT2X00_DEBUG */
-#define FIELD16(__mask) \
-	( (struct rt2x00_field16) { \
-		BUILD_LOWEST_BIT16(__mask), (__mask) \
-	} )
-
-#define FIELD32(__mask) \
-	( (struct rt2x00_field32) { \
-		BUILD_LOWEST_BIT32(__mask), (__mask) \
-	} )
-#endif /* CONFIG_RT2X00_DEBUG */
+#define is_power_of_two(x)	( !((x) & ((x)-1)) )
+#define low_bit_mask(x)		( ((x)-1) & ~(x) )
+#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
+
+#define FIELD16(__mask)				\
+({						\
+	BUILD_BUG_ON(!(__mask) ||		\
+		     !is_valid_mask(__mask) ||	\
+		     (__ffs((__mask) >= 16)));	\
+	(struct rt2x00_field16) {		\
+		__ffs(__mask), (__mask)		\
+	};					\
+})
+
+#define FIELD32(__mask)				\
+({						\
+	BUILD_BUG_ON(!(__mask) ||		\
+		     !is_valid_mask(__mask) ||	\
+		     (__ffs((__mask) >= 32)));	\
+	(struct rt2x00_field32) {		\
+		__ffs(__mask), (__mask)		\
+	};					\
+})
 
 static inline void rt2x00_set_field32(u32 *reg,
 	const struct rt2x00_field32 field, const u32 value)
