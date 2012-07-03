Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40316 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GCUDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 16:03:48 -0400
Received: by eaak11 with SMTP id k11so2653456eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 13:03:47 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Backport cpufreq_quick_get_max()
Date: Tue,  3 Jul 2012 23:03:38 +0300
Message-Id: <1341345818-24924-1-git-send-email-ozancag@gmail.com> (sfid-20120703_220353_583852_1DFED365)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

commit 3d73710880afa3d61cf57b5d4eb192e812eb7e4f
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Jun 28 10:59:12 2011 -0700

  cpufreq: expose a cpufreq_quick_get_max routine

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
 compat/compat-3.1.c        |   24 ++++++++++++++++++++++++
 include/linux/compat-3.1.h |    1 +
 2 files changed, 25 insertions(+)

diff --git a/compat/compat-3.1.c b/compat/compat-3.1.c
index d427dd3..e81a3e7 100644
--- a/compat/compat-3.1.c
+++ b/compat/compat-3.1.c
@@ -9,6 +9,30 @@
  */
 
 #include <linux/idr.h>
+#include <linux/cpufreq.h>
+
+/* This backports:
+ * commit 3d73710880afa3d61cf57b5d4eb192e812eb7e4f
+ * Author: Jesse Barnes <jbarnes@virtuousgeek.org>
+ * Date:   Tue Jun 28 10:59:12 2011 -0700
+ *
+ * 	cpufreq: expose a cpufreq_quick_get_max routine
+ */
+
+unsigned int cpufreq_quick_get_max(unsigned int cpu)
+{
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	unsigned int ret_freq = 0;
+
+	if (policy) {
+		ret_freq = policy->max;
+		cpufreq_cpu_put(policy);
+	}
+
+	return ret_freq;
+}
+EXPORT_SYMBOL(cpufreq_quick_get_max);
+
 
 static DEFINE_SPINLOCK(simple_ida_lock);
 
diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index 5998bb1..bf8a4ef 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -102,6 +102,7 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 		   gfp_t gfp_mask);
 void ida_simple_remove(struct ida *ida, unsigned int id);
 
+unsigned int cpufreq_quick_get_max(unsigned int cpu);
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
 #endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.10.4

