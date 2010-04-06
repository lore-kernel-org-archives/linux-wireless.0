Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46294 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab0DFWlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 18:41:11 -0400
Subject: [PATCH 1/2] compat: add device_create() implementation for Linux
 2.6.26 and older
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 06 Apr 2010 18:41:09 -0400
Message-ID: <20100406224109.2937.65315.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should make 25-device_create.patch in compat-wireless unnecessary.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 include/linux/compat-2.6.27.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index e27115b..d667222 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -228,6 +228,14 @@ static inline void debugfs_remove_recursive(struct dentry *dentry)
 { }
 #endif
 
+#define device_create(cls, parent, devt, drvdata, fmt, ...)		\
+({									\
+	struct device *_dev;						\
+	_dev = (device_create)(cls, parent, devt, fmt, __VA_ARGS__);	\
+	dev_set_drvdata(_dev, drvdata);					\
+	_dev;								\
+})
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
 #endif /* LINUX_26_27_COMPAT_H */
