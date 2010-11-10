Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KJCVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:24 -0500
Received: by mail-qy0-f181.google.com with SMTP id 31so159944qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:23 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 21/44] compat/2.6.32: add compat macros for sysctl helpers
Date: Tue,  9 Nov 2010 21:20:03 -0500
Message-Id: <1289355626-25373-22-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.32.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 873ae3d..3b9915e 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -99,6 +99,30 @@ struct dev_pm_ops name = { \
 
 #define dev_to_sdio_func(d)	container_of(d, struct sdio_func, dev)
 
+#define proc_dostring(table, write, buff, lenp, ppos) \
+	    ({ proc_dostring(table, write, NULL, buff, lenp, ppos); })
+
+#define proc_dointvec(table, write, buff, lenp, ppos) \
+	    ({ proc_dointvec(table, write, NULL, buff, lenp, ppos); })
+
+#define proc_dointvec_minmax(table, write, buff, lenp, ppos) \
+	    ({ proc_dointvec_minmax(table, write, NULL, buff, lenp, ppos); })
+
+#define proc_dointvec_jiffies(table, write, buff, lenp, ppos) \
+	    ({ proc_dointvec_jiffies(table, write, NULL, buff, lenp, ppos); })
+
+#define proc_dointvec_userhz_jiffies(table, write, buff, lenp, ppos) \
+	    ({ proc_dointvec_userhz_jiffies(table, write, NULL, buff, lenp, ppos); })
+
+#define proc_dointvec_ms_jiffies(table, write, buff, lenp, ppos) \
+	    ({ proc_dointvec_ms_jiffies(table, write, NULL, buff, lenp, ppos); })
+
+#define proc_doulongvec_minmax(table, write, buff, lenp, ppos) \
+	    ({ proc_doulongvec_minmax(table, write, NULL, buff, lenp, ppos); })
+
+#define proc_doulongvec_ms_jiffies_minmax(table, write, buff, lenp, ppos) \
+	    ({ proc_doulongvec_ms_jiffies_minmax(table, write, NULL, buff, lenp, ppos); })
+
 #define lockdep_assert_held(l)			do { } while (0)
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
-- 
1.7.2.30.gc37d7.dirty

