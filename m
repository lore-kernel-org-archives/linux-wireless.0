Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:33156 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab2GMIio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 04:38:44 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: mcgrof@kernel.org
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] compat: fix system crash on 2.6.35 when flushing work
Date: Fri, 13 Jul 2012 10:38:34 +0200
Message-Id: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120713_103854_514868_C772FD19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ubuntu 10.10 stock kernel (2.6.35-22-generic) crashes in
compat_flush_scheduled_work(), that is called e.g. when
mac80211 module is unloaded.

The problem was introduced with 80bf8a83
compat: backport system work queues system_wq and system_long_wq

The crash happens in compat_flush_scheduled_work() where both
flush_workqueue() and flush_scheduled_work() are called successively.
Removing one of them resolves the issue.

All compat-wireless tarballs after 2012-03-18 are affected.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 compat/compat-2.6.36.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index 9190ecd..8f25be0 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -140,7 +140,6 @@ void compat_flush_scheduled_work(void)
 	 * go with the old kernel's one first for now (keventd_wq) and
 	 * if think its reasonable later we can flip this around.
 	 */
-	flush_workqueue(system_wq);
 	flush_scheduled_work();
 }
 EXPORT_SYMBOL_GPL(compat_flush_scheduled_work);
-- 
1.7.4.1

