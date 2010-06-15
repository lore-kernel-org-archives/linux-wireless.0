Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40726 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab0FOU5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 16:57:51 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport lockdep_assert_held
Date: Tue, 15 Jun 2010 22:57:44 +0200
Message-Id: <1276635464-27982-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 3a41bd6..321a89a 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -94,6 +94,8 @@ struct dev_pm_ops name = { \
 
 #define dev_to_sdio_func(d)	container_of(d, struct sdio_func, dev)
 
+#define lockdep_assert_held(l)			do { } while (0)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
 
 #endif /* LINUX_26_32_COMPAT_H */
-- 
1.7.0.4

