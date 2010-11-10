Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0KJCVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:04 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:03 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 10/44] compat/2.6.23: add compat inline for notifier_{from,to}_errno()
Date: Tue,  9 Nov 2010 21:19:52 -0500
Message-Id: <1289355626-25373-11-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.23.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.23.h b/include/linux/compat-2.6.23.h
index fbfb470..5dd6301 100644
--- a/include/linux/compat-2.6.23.h
+++ b/include/linux/compat-2.6.23.h
@@ -7,11 +7,25 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
 
 #include <linux/netdevice.h>
+#include <linux/notifier.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/genetlink.h>
 #include <net/sch_generic.h>
 
+/* Encapsulate (negative) errno value (in particular, NOTIFY_BAD <=> EPERM). */
+static inline int notifier_from_errno(int err)
+{
+	return NOTIFY_STOP_MASK | (NOTIFY_OK - err);
+}
+
+/* Restore (negative) errno value from notify return value. */
+static inline int notifier_to_errno(int ret)
+{
+	ret &= ~NOTIFY_STOP_MASK;
+	return ret > NOTIFY_OK ? NOTIFY_OK - ret : 0;
+}
+
 /*
  * Tell gcc if a function is cold. The compiler will assume any path
  * directly leading to the call is unlikely.
-- 
1.7.2.30.gc37d7.dirty

