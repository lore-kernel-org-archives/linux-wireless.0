Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33853 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0IKQUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:20:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: backport printk_once
Date: Sat, 11 Sep 2010 18:19:59 +0200
Message-Id: <1284221999-22521-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284221999-22521-1-git-send-email-hauke@hauke-m.de>
References: <1284221999-22521-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by brcm80211.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.30.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.30.h b/include/linux/compat-2.6.30.h
index eface8c..28f3d54 100644
--- a/include/linux/compat-2.6.30.h
+++ b/include/linux/compat-2.6.30.h
@@ -30,6 +30,18 @@ static inline void dev_set_uevent_suppress(struct device *dev, int val)
 	dev->uevent_suppress = val;
 }
 
+/*
+ * Print a one-time message (analogous to WARN_ONCE() et al):
+ */
+#define printk_once(x...) ({			\
+	static bool __print_once;		\
+						\
+	if (!__print_once) {			\
+		__print_once = true;		\
+		printk(x);			\
+	}					\
+})
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)) */
 
 #endif /* LINUX_26_30_COMPAT_H */
-- 
1.7.0.4

