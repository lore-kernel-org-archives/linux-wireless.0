Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40805 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2HKAaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:30:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat: fix mod_delayed_work
Date: Sat, 11 Aug 2012 02:30:06 +0200
Message-Id: <1344645007-26757-4-git-send-email-hauke@hauke-m.de> (sfid-20120811_023026_734859_553343F4)
In-Reply-To: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
References: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add return value to function
 * make EXPORT_SYMBOL_GPL work by including the needed header file

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-3.7.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/compat/compat-3.7.c b/compat/compat-3.7.c
index 8fd07ff..f251788 100644
--- a/compat/compat-3.7.c
+++ b/compat/compat-3.7.c
@@ -9,11 +9,13 @@
  */
 
 #include <linux/workqueue.h>
+#include <linux/export.h>
 
 bool mod_delayed_work(struct workqueue_struct *wq, struct delayed_work *dwork,
 		      unsigned long delay)
 {
 	cancel_delayed_work(dwork);
 	queue_delayed_work(wq, dwork, delay);
+	return false;
 }
 EXPORT_SYMBOL_GPL(mod_delayed_work);
-- 
1.7.9.5

