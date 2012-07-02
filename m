Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33578 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2GBOWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 10:22:42 -0400
Received: by mail-ey0-f174.google.com with SMTP id k11so2110016eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 07:22:42 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 5/5] compat: Backport DIV_ROUND_UP_DLL macro
Date: Mon,  2 Jul 2012 17:22:14 +0300
Message-Id: <1341238934-30855-5-git-send-email-ozancag@gmail.com> (sfid-20120702_162249_016100_10A7DF41)
In-Reply-To: <1341238934-30855-1-git-send-email-ozancag@gmail.com>
References: <1341238934-30855-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

commit 36a26c69b4c70396ef569c3452690fba0c1dec08
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Tue Jul 26 00:35:26 2011 -0700

    kernel.h: Add DIV_ROUND_UP_ULL and DIV_ROUND_UP_SECTOR_T macro usage

Trying kernel  3.4.0-030400-generic [OK]
Trying kernel  3.3.7-030307-generic [OK]
Trying kernel  3.2.2-030202-generic [OK]
Trying kernel  3.1.10-030110-generic [OK]
Trying kernel  3.0.18-030018-generic [OK]
Trying kernel  2.6.39-02063904-generic [OK]
Trying kernel  2.6.38-02063808-generic [OK]
Trying kernel  2.6.37-02063706-generic [OK]
Trying kernel  2.6.36-02063604-generic [OK]
Trying kernel  2.6.35-02063512-generic [OK]
Trying kernel  2.6.34-02063410-generic [OK]
Trying kernel  2.6.33-02063305-generic [OK]
Trying kernel  2.6.32-02063255-generic [OK]
Trying kernel  2.6.31-02063113-generic [OK]
Trying kernel  2.6.30-02063010-generic [OK]
Trying kernel  2.6.29-02062906-generic [OK]
Trying kernel  2.6.28-02062810-generic [OK]
Trying kernel  2.6.27-020627-generic [OK]
Trying kernel  2.6.26-020626-generic [OK]
Trying kernel  2.6.25-020625-generic [OK]
Trying kernel  2.6.24-020624-generic [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.1.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index da8e971..788128d 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -9,6 +9,20 @@
 #include <linux/skbuff.h>
 #include <net/ip.h>
 #include <linux/idr.h>
+#include <asm/div64.h>
+
+
+/* This backports:
+ *
+ * commit 36a26c69b4c70396ef569c3452690fba0c1dec08
+ * Author: Nicholas Bellinger <nab@linux-iscsi.org>
+ * Date:   Tue Jul 26 00:35:26 2011 -0700
+ * 	
+ * 	kernel.h: Add DIV_ROUND_UP_ULL and DIV_ROUND_UP_SECTOR_T macro usage
+ */
+
+#define DIV_ROUND_UP_ULL(ll,d) \
+	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
 
 /* Backports 56f8a75c */
 static inline bool ip_is_fragment(const struct iphdr *iph)
-- 
1.7.10.4

