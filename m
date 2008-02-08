Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33340 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751488AbYBHFdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 00:33:40 -0500
Date: Fri, 8 Feb 2008 06:31:39 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH 3/4] b43legacy: fix B43legacy_WARN_ON macro
Message-ID: <20080208063139.60b8d733@morte> (sfid-20080208_053344_931437_045359BF)
In-Reply-To: <20080208051650.372197299@polimi.it>
References: <20080208051650.372197299@polimi.it>>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the B43legacy_WARN_ON macro so that it will evaluate expressions.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
@@ -326,15 +326,7 @@ enum {
 # undef assert
 #endif
 #ifdef CONFIG_B43LEGACY_DEBUG
-# define B43legacy_WARN_ON(expr)					\
-	do {								\
-		if (unlikely((expr))) {					\
-			printk(KERN_INFO PFX "Test (%s) failed at:"	\
-					      " %s:%d:%s()\n",		\
-					      #expr, __FILE__,		\
-					      __LINE__, __FUNCTION__);	\
-		}							\
-	} while (0)
+# define B43legacy_WARN_ON(x)	WARN_ON(x)
 # define B43legacy_BUG_ON(expr)						\
 	do {								\
 		if (unlikely((expr))) {					\
@@ -345,7 +337,9 @@ enum {
 	} while (0)
 # define B43legacy_DEBUG	1
 #else
-# define B43legacy_WARN_ON(x)	do { /* nothing */ } while (0)
+/* This will evaluate the argument even if debugging is disabled. */
+static inline bool __b43legacy_warn_on_dummy(bool x) { return x; }
+# define B43_WARN_ON(x)	__b43legacy_warn_on_dummy(unlikely(!!(x)))
 # define B43legacy_BUG_ON(x)	do { /* nothing */ } while (0)
 # define B43legacy_DEBUG	0
 #endif
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1066,10 +1066,8 @@ static const u8 *b43legacy_generate_prob
 	B43legacy_WARN_ON(ie_start != offsetof(struct ieee80211_mgmt,
 					       u.beacon.variable));

-	if (src_size < ie_start) {
-		B43legacy_WARN_ON(1);
+	if (B43legacy_WARN_ON(src_size < ie_start))
 		return NULL;
-	}

 	dest_data = kmalloc(src_size, GFP_ATOMIC);
 	if (unlikely(!dest_data))

-- 
Ciao
Stefano
