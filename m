Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50911 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2AZSQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 13:16:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] compat: use kconfig.h in compat-2.6.h for 3.1 and later kernels
Date: Thu, 26 Jan 2012 13:00:56 -0500
Message-Id: <1327600856-29635-1-git-send-email-linville@tuxdriver.com> (sfid-20120126_191624_303256_BECA3C93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file was introduced in commit 2a11c8ea20bf850b3a2c60db8c2e7497d28aba99
and included in 3.1 and later kernels.  It includes <generated/autoconf.h>
itself, as well as some other definitions that are used elsewhere.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/compat-2.6.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index c23e94a..3ccd051 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -2,7 +2,9 @@
 #define LINUX_26_COMPAT_H
 
 #include <linux/version.h>
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
+#include <linux/kconfig.h>
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
 #include <generated/autoconf.h>
 #else
 #include <linux/autoconf.h>
-- 
1.7.4.4

