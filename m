Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D90C71122
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 19:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47BB320865
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 19:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47BB320865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeJMDUQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:20:16 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53914 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbeJMDUQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 23:20:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gB3Nz-0001Dn-68; Fri, 12 Oct 2018 21:46:11 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>,
        nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] bitfield: add constant field preparation macros
Date:   Fri, 12 Oct 2018 21:45:56 +0200
Message-Id: <20181012194556.31004-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

John Garry requested to be able to use FIELD_PREP() and friends
in constant initializers, but we cannot completely switch all of
the current assertions to BUILD_BUG_ON_ZERO().

So instead of this, add __FIELD_PREP() which is suitable in such
contexts, and also add __{u,le,be}{16,32,64}encode_bits() like
the existing versions without underscores, but again suitable in
constant contexts.

Requested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/bitfield.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 3f1ef4450a7c..245dfb47d201 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -63,6 +63,14 @@
 					      (1ULL << __bf_shf(_mask))); \
 	})
 
+#define __BF_CHECK_POW2(n)	BUILD_BUG_ON_ZERO(((n) & ((n) - 1)) != 0)
+
+#define __BF_FIELD_CHECK_CONST(_mask, _reg, _val)			\
+	(BUILD_BUG_ON_ZERO((_mask) == 0) +				\
+	 BUILD_BUG_ON_ZERO(~((_mask) >> __bf_shf(_mask)) & (_val)) +	\
+	 BUILD_BUG_ON_ZERO((_mask) > (typeof(_reg))~0ull) +		\
+	 __BF_CHECK_POW2((_mask) + (1ULL << __bf_shf(_mask))))
+
 /**
  * FIELD_FIT() - check if value fits in the field
  * @_mask: shifted mask defining the field's length and position
@@ -90,6 +98,21 @@
 		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
 	})
 
+/**
+ * __FIELD_PREP() - prepare a constant bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_val:  value to put in the field
+ *
+ * __FIELD_PREP() masks and shifts up the value.  The result should
+ * be combined with other fields of the bitfield using local OR.
+ *
+ * This version is suitable for use in a pure constant context, e.g.
+ * a constant initializer.
+ */
+#define __FIELD_PREP(_mask, _val)					\
+	((typeof(_mask))__BF_FIELD_CHECK_CONST(_mask, 0ULL, _val) +	\
+	 (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask)))
+
 /**
  * FIELD_GET() - extract a bitfield element
  * @_mask: shifted mask defining the field's length and position
@@ -150,4 +173,15 @@ __MAKE_OP(64)
 #undef __MAKE_OP
 #undef ____MAKE_OP
 
+#define __encode_bits(w, v, field)	__FIELD_PREP((u##w)(field), v)
+#define __u16_encode_bits(v, field)	__encode_bits(16, v, field)
+#define __le16_encode_bits(v, field)	cpu_to_le16(__encode_bits(16, v, field))
+#define __be16_encode_bits(v, field)	cpu_to_be16(__encode_bits(16, v, field))
+#define __u32_encode_bits(v, field)	__encode_bits(32, v, field)
+#define __le32_encode_bits(v, field)	cpu_to_le32(__encode_bits(32, v, field))
+#define __be32_encode_bits(v, field)	cpu_to_be32(__encode_bits(32, v, field))
+#define __u64_encode_bits(v, field)	__encode_bits(64, v, field)
+#define __le64_encode_bits(v, field)	cpu_to_le64(__encode_bits(64, v, field))
+#define __be64_encode_bits(v, field)	cpu_to_be64(__encode_bits(64, v, field))
+
 #endif
-- 
2.17.2

