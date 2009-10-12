Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56583 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbZJLVUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:01 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	larry.finger@gmail.com
Subject: [PATCH 1/9] [compat-2.6 and compat-stable] Export round_jiffies_up again.
Date: Mon, 12 Oct 2009 23:19:09 +0200
Message-Id: <1255382358-20760-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 2.6.27 mainline kernel does not export round_jiffies_up. It looks
like the openSuse kernel 2.6.27 does export this symbol. Rename the
compat symbol to not conflict with the openSuse kernel.

CC: larry.finger@gmail.com
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c |    2 --
 compat/compat-2.6.28.h |    5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 613b009..33871a2 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -260,7 +260,6 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
 	return j;
 }
 
-#if 0
 /**
  * round_jiffies_up - function to round jiffies up to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -275,6 +274,5 @@ unsigned long round_jiffies_up(unsigned long j)
 	return round_jiffies_common(j, raw_smp_processor_id(), true);
 }
 EXPORT_SYMBOL_GPL(round_jiffies_up);
-#endif
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
index 4e5a2ef..90d080c 100644
--- a/compat/compat-2.6.28.h
+++ b/compat/compat-2.6.28.h
@@ -195,6 +195,11 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 
 #endif
 
+/* openSuse includes round_jiffies_up in it's kernel 2.6.27.
+ * This is needed to prevent conflicts with the openSuse definition.
+ */
+#define round_jiffies_up backport_round_jiffies_up
+
 unsigned long round_jiffies_up(unsigned long j);
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
-- 
1.6.2.1

