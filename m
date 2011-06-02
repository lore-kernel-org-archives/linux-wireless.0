Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60470 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab1FBQff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/9] comapt-wireless: move doku to the correct place in config.mk
Date: Thu,  2 Jun 2011 18:35:17 +0200
Message-Id: <1307032525-18916-2-git-send-email-hauke@hauke-m.de> (sfid-20110602_183547_571444_9ACC92AC)
In-Reply-To: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index 99485a4..9a18441 100644
--- a/config.mk
+++ b/config.mk
@@ -14,11 +14,6 @@ else
 include $(KLIB_BUILD)/.config
 endif
 
-# We will warn when you don't have MQ support or NET_SCHED enabled.
-#
-# We could consider just quiting if MQ and NET_SCHED is disabled
-# as I suspect all users of this package want 802.11e (WME) and
-# 802.11n (HT) support.
 ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
 COMPAT_LATEST_VERSION = 39
 KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
@@ -62,6 +57,11 @@ endif
 
 ifneq ($(KERNELRELEASE),) # This prevents a warning
 
+# We will warn when you don't have MQ support or NET_SCHED enabled.
+#
+# We could consider just quiting if MQ and NET_SCHED is disabled
+# as I suspect all users of this package want 802.11e (WME) and
+# 802.11n (HT) support.
 ifeq ($(CONFIG_NET_SCHED),)
  QOS_REQS_MISSING+=CONFIG_NET_SCHED
 endif
-- 
1.7.4.1

