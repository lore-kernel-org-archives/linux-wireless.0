Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44980 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab2HBQ2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 12:28:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: fix endless recursion in flush_scheduled_work
Date: Thu,  2 Aug 2012 18:28:01 +0200
Message-Id: <1343924881-31418-2-git-send-email-hauke@hauke-m.de> (sfid-20120802_182813_956328_91A6B364)
In-Reply-To: <1343924881-31418-1-git-send-email-hauke@hauke-m.de>
References: <1343924881-31418-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hader file defines flush_scheduled_work(a)
compat_flush_scheduled_work(a), which causes flush_scheduled_work() and
compat_flush_scheduled_work() to be the same function.

With this patch it calls the actual function in the kernel.

This fixes problems when unloading mac80211 from compat-wireless.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.36.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index 8f25be0..05b41c2 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -133,6 +133,7 @@ int compat_schedule_delayed_work_on(int cpu,
 }
 EXPORT_SYMBOL_GPL(compat_schedule_delayed_work_on);
 
+#undef flush_scheduled_work(a)
 void compat_flush_scheduled_work(void)
 {
 	/*
-- 
1.7.9.5

