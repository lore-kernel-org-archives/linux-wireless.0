Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47331 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab0CKVdA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:33:00 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: update bitops.h
Date: Thu, 11 Mar 2010 22:32:41 +0100
Message-Id: <1268343167-2961-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Copy header from recent linux-next

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/bitops.h |   33 ++++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 8469d35..b62de8c 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -18,16 +18,18 @@
  */
 #include <asm/bitops.h>
 
-#define for_each_bit(bit, addr, size) \
+#define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size)); \
 	     (bit) < (size); \
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
+/* Temporary */
+#define for_each_bit(bit, addr, size) for_each_set_bit(bit, addr, size)
 
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
-	
+
 	order = fls(count);
 	return order;	/* We could be slightly more clever with -1 here... */
 }
@@ -35,7 +37,7 @@ static __inline__ int get_bitmask_order(unsigned int count)
 static __inline__ int get_count_order(unsigned int count)
 {
 	int order;
-	
+
 	order = fls(count) - 1;
 	if (count & (count - 1))
 		order++;
@@ -47,6 +49,31 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
+/*
+ * Clearly slow versions of the hweightN() functions, their benefit is
+ * of course compile time evaluation of constant arguments.
+ */
+#define HWEIGHT8(w)					\
+      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
+	(!!((w) & (1ULL << 0))) +			\
+	(!!((w) & (1ULL << 1))) +			\
+	(!!((w) & (1ULL << 2))) +			\
+	(!!((w) & (1ULL << 3))) +			\
+	(!!((w) & (1ULL << 4))) +			\
+	(!!((w) & (1ULL << 5))) +			\
+	(!!((w) & (1ULL << 6))) +			\
+	(!!((w) & (1ULL << 7)))	)
+
+#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
+#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
+#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
+
+/*
+ * Type invariant version that simply casts things to the
+ * largest type.
+ */
+#define HWEIGHT(w)   HWEIGHT64((u64)(w))
+
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
-- 
1.6.3.3

