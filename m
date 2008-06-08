Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYFHVho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:44 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:43 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/10] rt2x00: Use __builtin_choose_expr() instead of ?:
Date: Sun, 8 Jun 2008 23:45:49 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082345.04002.IvDoorn@gmail.com> <200806082345.25904.IvDoorn@gmail.com>
In-Reply-To: <200806082345.25904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082345.49841.IvDoorn@gmail.com> (sfid-20080608_233749_357864_2D810E30)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To really force the FIELD macros to determine
the first bit of the register field we should
use the __builtin_choose_expr() function.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00reg.h |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index c3f1202..7e88ce5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -145,23 +145,27 @@ struct rt2x00_field32 {
  * compile-time rather then run-time.
  */
 #define compile_ffs2(__x) \
-	( ((__x) & 0x1) ? 0 : 1 )
+	__builtin_choose_expr(((__x) & 0x1), 0, 1)
 
 #define compile_ffs4(__x) \
-	( ((__x) & 0x3) ? \
-	    compile_ffs2(__x) : (compile_ffs2((__x) >> 2) + 2) )
+	__builtin_choose_expr(((__x) & 0x3), \
+			      (compile_ffs2((__x))), \
+			      (compile_ffs2((__x) >> 2) + 2))
 
 #define compile_ffs8(__x) \
-	( ((__x) & 0xf) ? \
-	    compile_ffs4(__x) : (compile_ffs4((__x) >> 4) + 4) )
+	__builtin_choose_expr(((__x) & 0xf), \
+			      (compile_ffs4((__x))), \
+			      (compile_ffs4((__x) >> 4) + 4))
 
 #define compile_ffs16(__x) \
-	( ((__x) & 0xff) ? \
-	    compile_ffs8(__x) : (compile_ffs8((__x) >> 8) + 8) )
+	__builtin_choose_expr(((__x) & 0xff), \
+			      (compile_ffs8((__x))), \
+			      (compile_ffs8((__x) >> 8) + 8))
 
 #define compile_ffs32(__x) \
-	( ((__x) & 0xffff) ? \
-	    compile_ffs16(__x) : (compile_ffs16((__x) >> 16) + 16) )
+	__builtin_choose_expr(((__x) & 0xffff), \
+			      (compile_ffs16((__x))), \
+			      (compile_ffs16((__x) >> 16) + 16))
 
 /*
  * This macro will check the requirements for the FIELD{8,16,32} macros
-- 
1.5.5.3

