Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50207 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab0HQScs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:32:48 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: fix warning in device_rename
Date: Tue, 17 Aug 2010 20:32:33 +0200
Message-Id: <1282069953-22360-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
References: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.36.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index b14c772..5b48215 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -13,6 +13,8 @@ struct va_format {
 	va_list *va;
 };
 
+#define device_rename(dev, new_name) device_rename(dev, (char *)new_name)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.0.4

