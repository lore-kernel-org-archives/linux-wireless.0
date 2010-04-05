Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52566 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab0DEVCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 17:02:47 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: Backport clamp
Date: Mon,  5 Apr 2010 23:02:38 +0200
Message-Id: <1270501358-3888-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by the ath5k driver.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.26.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index 2bee30e..8251177 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -48,6 +48,24 @@ extern int dev_set_name(struct device *dev, const char *name, ...)
 			__attribute__((format(printf, 2, 3)));
 
 /**
+ * clamp - return a value clamped to a given range with strict typechecking
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does strict typechecking of min/max to make sure they are of the
+ * same type as val.  See the unnecessary pointer comparisons.
+ */
+#define clamp(val, min, max) ({			\
+	typeof(val) __val = (val);		\
+	typeof(min) __min = (min);		\
+	typeof(max) __max = (max);		\
+	(void) (&__val == &__min);		\
+	(void) (&__val == &__max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
+
+/**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use
  * @val: current value
-- 
1.6.3.3

