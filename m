Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55685 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2FLXAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 19:00:24 -0400
Received: by wibhn6 with SMTP id hn6so4656941wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 16:00:23 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Add SIZE_MAX
Date: Wed, 13 Jun 2012 02:00:16 +0300
Message-Id: <1339542016-22501-1-git-send-email-ozancag@gmail.com> (sfid-20120613_010028_491072_50AA70B6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

  From a3860c1c5dd1137db23d7786d284939c5761d517 Mon Sep 17 00:00:00
  From: Xi Wang <xi.wang@gmail.com>
  Date: Thu, 31 May 2012 16:26:04 -0700
  Subject: [PATCH] introduce SIZE_MAX

This is needed by include/drm/drm_mem_util.h

Trying kernel                     3.4.0-030400-generic  [OK]
Trying kernel                     3.3.7-030307-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.5.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index c9ba6af..3f97a3d 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -8,6 +8,18 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0))
 
+/*
+ * This backports:
+ *
+ *   From a3860c1c5dd1137db23d7786d284939c5761d517 Mon Sep 17 00:00:00 2001
+ *   From: Xi Wang <xi.wang@gmail.com>
+ *   Date: Thu, 31 May 2012 16:26:04 -0700
+ *   Subject: [PATCH] introduce SIZE_MAX
+ */
+
+#define SIZE_MAX    (~(size_t)0)
+
+
 #include <linux/pkt_sched.h>
 
 /*
-- 
1.7.10.2

