Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59845 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab0H0Sl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/7] compat-wireless: add support for kernel 2.6.24
Date: Fri, 27 Aug 2010 20:40:53 +0200
Message-Id: <1282934453-18093-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                      |    6 +++---
 scripts/gen-compat-autoconf.sh |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/config.mk b/config.mk
index 27e2322..87b637e 100644
--- a/config.mk
+++ b/config.mk
@@ -25,9 +25,9 @@ KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
 $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
 
-ifdef CONFIG_COMPAT_KERNEL_25
-$(error "ERROR: compat-wireless by default supports kernels >= 2.6.25, try enabling only one driver though")
-endif #CONFIG_COMPAT_KERNEL_25
+ifdef CONFIG_COMPAT_KERNEL_24
+$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
+endif #CONFIG_COMPAT_KERNEL_24
 
 ifeq ($(CONFIG_CFG80211),y)
 $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 7b5773c..65232ab 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -11,7 +11,7 @@
 
 # This indicates which is the oldest kernel we support
 # Update this if you are adding support for older kernels.
-OLDEST_KERNEL_SUPPORTED="2.6.25"
+OLDEST_KERNEL_SUPPORTED="2.6.24"
 COMPAT_RELEASE="compat_version"
 KERNEL_RELEASE="compat_base_tree_version"
 MULT_DEP_FILE=".compat_pivot_dep"
-- 
1.7.0.4

