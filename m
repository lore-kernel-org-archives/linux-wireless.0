Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09781C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE10D2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE10D2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbeJLQwu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:52:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46068 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbeJLQwt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:52:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAtdF-0008Dj-Si; Fri, 12 Oct 2018 11:21:18 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] bitfield: use BUILD_BUG_ON_ZERO()
Date:   Fri, 12 Oct 2018 11:21:04 +0200
Message-Id: <20181012092104.2361-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

John Garry requested to be able to use FIELD_PREP() and friends
in constant initializers, so the thing we can do is switch all
the compile-time assertions to use BUILD_BUG_ON_ZERO() instead
of regular BUILD_BUG_ON().

The only downside is that we lose all the error messages, but
it doesn't seem worthwhile to duplicate all of this into e.g.
CONST_FIELD_PREP() (for constants) just for that.

Requested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/bitfield.h | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 3f1ef4450a7c..1840dae6448a 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -49,19 +49,15 @@
 
 #define __bf_shf(x) (__builtin_ffsll(x) - 1)
 
-#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
-	({								\
-		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
-				 _pfx "mask is not constant");		\
-		BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");	\
-		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
-				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
-				 _pfx "value too large for the field"); \
-		BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,		\
-				 _pfx "type of reg too small for mask"); \
-		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
-					      (1ULL << __bf_shf(_mask))); \
-	})
+#define __BF_CHECK_POW2(n)	BUILD_BUG_ON_ZERO(((n) & ((n) - 1)) != 0)
+
+#define __BF_FIELD_CHECK(_mask, _reg, _val)				\
+	BUILD_BUG_ON_ZERO(!__builtin_constant_p(_mask)) +		\
+	BUILD_BUG_ON_ZERO((_mask) == 0) +				\
+	BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?			\
+				~((_mask) >> __bf_shf(_mask)) & (_val) : 0) + \
+	BUILD_BUG_ON_ZERO((_mask) > (typeof(_reg))~0ull) +		\
+	__BF_CHECK_POW2((_mask) + (1ULL << __bf_shf(_mask)))
 
 /**
  * FIELD_FIT() - check if value fits in the field
@@ -71,10 +67,8 @@
  * Return: true if @_val can fit inside @_mask, false if @_val is too big.
  */
 #define FIELD_FIT(_mask, _val)						\
-	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");	\
-		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
-	})
+	(__BF_FIELD_CHECK(_mask, 0ULL, _val) +				\
+	 !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)))
 
 /**
  * FIELD_PREP() - prepare a bitfield element
@@ -85,10 +79,8 @@
  * be combined with other fields of the bitfield using logical OR.
  */
 #define FIELD_PREP(_mask, _val)						\
-	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
-		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
-	})
+	(__BF_FIELD_CHECK(_mask, 0ULL, _val) +				\
+	 (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask)))
 
 /**
  * FIELD_GET() - extract a bitfield element
@@ -99,10 +91,8 @@
  * bitfield passed in as @_reg by masking and shifting it down.
  */
 #define FIELD_GET(_mask, _reg)						\
-	({								\
-		__BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");	\
-		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
-	})
+	(__BF_FIELD_CHECK(_mask, _reg, 0U) +				\
+	 ((typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask))))
 
 extern void __compiletime_error("value doesn't fit into mask")
 __field_overflow(void);
-- 
2.14.4

