Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 51.23-broadband.acttv.in ([106.51.23.138]:51196 "EHLO
	arvind-ThinkPad-Edge-E431" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754265AbcHAR6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 13:58:05 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: zajec5@gmail.com, leoli@freescale.com
Cc: qiang.zhao@freescale.com, scottwood@freescale.com,
	viresh.kumar@linaro.org, akpm@linux-foundation.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux@roeck-us.net, arnd@arndb.de,
	davem@davemloft.net, David.Laight@aculab.com,
	Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [v4] Fix to avoid IS_ERR_VALUE and IS_ERR abuses on 64bit systems.
Date: Sun, 31 Jul 2016 16:48:44 +0530
Message-Id: <1469963924-8800-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20160801_195812_772608_89545B2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IS_ERR_VALUE() assumes that parameter is an unsigned long.
It can not be used to check if 'unsigned int' is passed insted.
Which tends to reflect an error.

In 64bit architectures sizeof (int) == 4 && sizeof (long) == 8.
IS_ERR_VALUE(x) is ((x) >= (unsigned long)-4095).

IS_ERR_VALUE() of 'unsigned int' is always false because the 32bit
value is zero extended to 64 bits.

Value of (unsigned int)-4095 is always less than value of
(unsigned long)-4095.

Now We are taking only first 32 bit for error checking rest of the 32 bit
we ignore such that we get appropriate comparison on 64bit system as well.

First 32bit of Value of (unsigned int)-4095 and (unsigned long)-4095 will
be equal.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 include/linux/err.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index 1e35588..c2a2789 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -18,7 +18,17 @@
 
 #ifndef __ASSEMBLY__
 
-#define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
+#define IS_ERR_VALUE(x) unlikely(is_error_check(x))
+
+static inline int is_error_check(unsigned long error)
+{
+	unsigned int first32bit = (error & 0xFFFFFFFF);
+
+	if (first32bit >= (unsigned int)-MAX_ERRNO)
+		return 1;
+	else
+		return 0;
+}
 
 static inline void * __must_check ERR_PTR(long error)
 {
-- 
1.9.1

