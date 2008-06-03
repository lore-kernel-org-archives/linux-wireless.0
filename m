Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYFCS0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:05 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644244nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:04 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/11] rt2x00: Fix compile-time ffs calculation macros.
Date: Tue, 3 Jun 2008 20:29:39 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032025.45029.IvDoorn@gmail.com>
In-Reply-To: <200806032025.45029.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032029.40085.IvDoorn@gmail.com> (sfid-20080603_202609_676907_F946F45C)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The compile_ffsx macros were missing a set of parentheses, which resulted in
wrong bit offset calculations.

This fixes rt61pci detection failures, whereby the rf chipset wasn't detected
properly due to improper bit shifting.

This patch is based on GertJan's report + patch to fix the parentheses problem

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00reg.h |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 03e846f..7999d54 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -145,19 +145,23 @@ struct rt2x00_field32 {
  * compile-time rather then run-time.
  */
 #define compile_ffs2(__x) \
-	((__x) & 0x1) ? 0 : 1
+	( ((__x) & 0x1) ? 0 : 1 )
 
 #define compile_ffs4(__x) \
-	((__x) & 0x3) ? compile_ffs2(__x) : compile_ffs2(__x >> 2) + 2
+	( ((__x) & 0x3) ? \
+	    compile_ffs2(__x) : (compile_ffs2(__x >> 2) + 2) )
 
 #define compile_ffs8(__x) \
-	((__x) & 0xf) ? compile_ffs4(__x) : compile_ffs4(__x >> 4) + 4
+	( ((__x) & 0xf) ? \
+	    compile_ffs4(__x) : (compile_ffs4(__x >> 4) + 4) )
 
 #define compile_ffs16(__x) \
-	((__x) & 0xff) ? compile_ffs8(__x) : compile_ffs8(__x >> 8) + 8
+	( ((__x) & 0xff) ? \
+	    compile_ffs8(__x) : (compile_ffs8(__x >> 8) + 8) )
 
 #define compile_ffs32(__x) \
-	((__x) & 0xffff) ? compile_ffs16(__x) : compile_ffs16(__x >> 16) + 16
+	( ((__x) & 0xffff) ? \
+	    compile_ffs16(__x) : (compile_ffs16(__x >> 16) + 16) )
 
 /*
  * This macro will check the requirements for the FIELD{8,16,32} macros
-- 
1.5.5.3

