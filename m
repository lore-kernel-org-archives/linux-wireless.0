Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44941 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab0GHVML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 17:12:11 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: fix tracpoint building
Date: Thu,  8 Jul 2010 23:11:58 +0200
Message-Id: <1278623518-18964-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

trace/define_trace.h can be included more often and it have to.

This fixes some errors like this:
WARNING: "__tracepoint_iwlwifi_dev_rx" [/home/hauke/compat-wireless/compat-wireless-git/drivers/net/wireless/iwlwifi/iwlcore.ko] undefined!

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/trace/define_trace.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index a31105a..7d03ccf 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -1,10 +1,5 @@
-#ifndef _COMPAT_TRACE_DEFINE_TRACE_H
-#define _COMPAT_TRACE_DEFINE_TRACE_H 1
-
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
 #include_next <trace/define_trace.h>
 #endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
-
-#endif	/* _COMPAT_TRACE_DEFINE_TRACE_H */
-- 
1.7.0.4

