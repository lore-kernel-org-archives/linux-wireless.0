Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37322 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933004AbeFTIpO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:45:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v6 (resend) 1/3] bitfield: fix *_encode_bits()
Date: Wed, 20 Jun 2018 08:58:28 +0200
Message-Id: <20180620065830.6612-2-johannes@sipsolutions.net> (sfid-20180620_105131_758118_F9F4A3E7)
In-Reply-To: <20180620065830.6612-1-johannes@sipsolutions.net>
References: <20180620065830.6612-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a bug in *_encode_bits() in using ~field_multiplier() for
the check whether or not the constant value fits into the field,
this is wrong and clearly ~field_mask() was intended. This was
triggering for me for both constant and non-constant values.

Additionally, make this case actually into an compile error.
Declaring the extern function that will never exist with just a
warning is pointless as then later we'll just get a link error.

While at it, also fix the indentation in those lines I'm touching.

Finally, as suggested by Andy Shevchenko, add some tests and for
that introduce also u8 helpers. The tests don't compile without
the fix, showing that it's necessary.

Fixes: 00b0c9b82663 ("Add primitives for manipulating bitfields both in host- and fixed-endian.")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: replace stray tab by space
v3: u8 helpers, tests
v4: minor cleanup (Andy)
    split into two patches (Andy)
---
 include/linux/bitfield.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index cf2588d81148..147a7bb341dd 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -104,7 +104,7 @@
 		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
 	})
 
-extern void __compiletime_warning("value doesn't fit into mask")
+extern void __compiletime_error("value doesn't fit into mask")
 __field_overflow(void);
 extern void __compiletime_error("bad bitfield mask")
 __bad_mask(void);
@@ -121,8 +121,8 @@ static __always_inline u64 field_mask(u64 field)
 #define ____MAKE_OP(type,base,to,from)					\
 static __always_inline __##type type##_encode_bits(base v, base field)	\
 {									\
-        if (__builtin_constant_p(v) &&	(v & ~field_multiplier(field)))	\
-			    __field_overflow();				\
+	if (__builtin_constant_p(v) && (v & ~field_mask(field)))	\
+		__field_overflow();					\
 	return to((v & field_mask(field)) * field_multiplier(field));	\
 }									\
 static __always_inline __##type type##_replace_bits(__##type old,	\
-- 
2.14.4
