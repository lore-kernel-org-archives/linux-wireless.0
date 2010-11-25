Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53007 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab0KYOtP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:49:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport pr_warn
Date: Thu, 25 Nov 2010 15:49:04 +0100
Message-Id: <1290696544-20483-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.38.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 85eac51..dfc406e 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -54,6 +54,8 @@ static inline unsigned long ewma_read(const struct ewma *avg)
 	return DIV_ROUND_CLOSEST(avg->internal, avg->factor);
 }
 
+#define pr_warn pr_warning
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)) */
 
 #endif /* LINUX_26_38_COMPAT_H */
-- 
1.7.1

