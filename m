Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab2HJU6f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 16:58:35 -0400
From: Andy Gospodreak <andy@greyhouse.net>
To: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] compat: fixup error in no_printk definition
Date: Fri, 10 Aug 2012 16:57:16 -0400
Message-Id: <1344632236-516-1-git-send-email-andy@greyhouse.net> (sfid-20120810_225839_418971_0028C2DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What initially looked like a valid definition for the #define for
no_printk was not.  This corrects the problem and the change that was
thought to correct it.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
---
 include/linux/compat-2.6.36.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index b6757c3..cd5e37c 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -99,9 +99,9 @@ struct pm_qos_request_list {
  * gcc's format and side-effect checking.
  */
 /* mask no_printk as RHEL6 backports this */
-#define no_printk(...) compat_no_printk(...)
+#define no_printk(a, ...) compat_no_printk(a, ##__VA_ARGS__)
 static inline __attribute__ ((format (printf, 1, 2)))
-int compat_no_printk(const char *s, ...) { return 0; }
+int no_printk(const char *s, ...) { return 0; }
 
 #ifndef alloc_workqueue
 #define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active, 0)
-- 
1.7.1

