Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54121 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1AIPcf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:32:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: update patches in enable-older-kernels
Date: Sun,  9 Jan 2011 16:32:20 +0100
Message-Id: <1294587141-11353-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
References: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* enable-2.6.24.patch does not make any sense as we already support kernel 2.6.24
* Update the other patches to apply again.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 enable-older-kernels/enable-2.6.21.patch |   26 +++++++++++++-------------
 enable-older-kernels/enable-2.6.22.patch |   26 +++++++++++++-------------
 enable-older-kernels/enable-2.6.23.patch |   20 +++++++++-----------
 enable-older-kernels/enable-2.6.24.patch |   28 ----------------------------
 4 files changed, 35 insertions(+), 65 deletions(-)
 delete mode 100644 enable-older-kernels/enable-2.6.24.patch

diff --git a/enable-older-kernels/enable-2.6.21.patch b/enable-older-kernels/enable-2.6.21.patch
index bb6e33d..2c16809 100644
--- a/enable-older-kernels/enable-2.6.21.patch
+++ b/enable-older-kernels/enable-2.6.21.patch
@@ -1,26 +1,26 @@
---- a/config.mk	2010-01-11 10:27:53.000000000 -0800
-+++ b/config.mk	2010-01-11 10:32:49.000000000 -0800
-@@ -26,8 +26,8 @@
+--- a/config.mk
++++ b/config.mk
+@@ -25,9 +25,9 @@
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
  $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_25
--$(error "ERROR: compat-wireless by default supports kernels >= 2.6.25, try enabling only one driver though")
-+ifdef CONFIG_COMPAT_WIRELESS_21
-+$(error "ERROR: compat-wireless for selected driver requires a kernel >= 2.6.21")
- endif
+-ifdef CONFIG_COMPAT_KERNEL_24
+-$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
+-endif #CONFIG_COMPAT_KERNEL_24
++ifdef CONFIG_COMPAT_KERNEL_21
++$(error "ERROR: compat-wireless by default supports kernels >= 2.6.21, try enabling only one driver though")
++endif #CONFIG_COMPAT_KERNEL_21
  
  ifeq ($(CONFIG_CFG80211),y)
-diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
-index 6c7cae7..bb2ea6d 100755
+ $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
 --- a/scripts/gen-compat-autoconf.sh
 +++ b/scripts/gen-compat-autoconf.sh
 @@ -11,7 +11,7 @@
  
  # This indicates which is the oldest kernel we support
  # Update this if you are adding support for older kernels.
--OLDEST_KERNEL_SUPPORTED="2.6.25"
+-OLDEST_KERNEL_SUPPORTED="2.6.24"
 +OLDEST_KERNEL_SUPPORTED="2.6.21"
- COMPAT_RELEASE="compat-release"
- KERNEL_RELEASE="git-describe"
+ COMPAT_RELEASE="compat_version"
+ KERNEL_RELEASE="compat_base_tree_version"
  MULT_DEP_FILE=".compat_pivot_dep"
diff --git a/enable-older-kernels/enable-2.6.22.patch b/enable-older-kernels/enable-2.6.22.patch
index 3acfcec..92150e9 100644
--- a/enable-older-kernels/enable-2.6.22.patch
+++ b/enable-older-kernels/enable-2.6.22.patch
@@ -1,26 +1,26 @@
---- a/config.mk	2010-01-11 10:27:53.000000000 -0800
-+++ b/config.mk	2010-01-11 10:32:49.000000000 -0800
-@@ -26,8 +26,8 @@
+--- a/config.mk
++++ b/config.mk
+@@ -25,9 +25,9 @@
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
  $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_25
--$(error "ERROR: compat-wireless by default supports kernels >= 2.6.25, try enabling only one driver though")
-+ifdef CONFIG_COMPAT_WIRELESS_22
-+$(error "ERROR: compat-wireless for selected driver requires a kernel >= 2.6.22")
- endif
+-ifdef CONFIG_COMPAT_KERNEL_24
+-$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
+-endif #CONFIG_COMPAT_KERNEL_24
++ifdef CONFIG_COMPAT_KERNEL_22
++$(error "ERROR: compat-wireless by default supports kernels >= 2.6.22, try enabling only one driver though")
++endif #CONFIG_COMPAT_KERNEL_22
  
  ifeq ($(CONFIG_CFG80211),y)
-diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
-index 6c7cae7..bb2ea6d 100755
+ $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
 --- a/scripts/gen-compat-autoconf.sh
 +++ b/scripts/gen-compat-autoconf.sh
 @@ -11,7 +11,7 @@
  
  # This indicates which is the oldest kernel we support
  # Update this if you are adding support for older kernels.
--OLDEST_KERNEL_SUPPORTED="2.6.25"
+-OLDEST_KERNEL_SUPPORTED="2.6.24"
 +OLDEST_KERNEL_SUPPORTED="2.6.22"
- COMPAT_RELEASE="compat-release"
- KERNEL_RELEASE="git-describe"
+ COMPAT_RELEASE="compat_version"
+ KERNEL_RELEASE="compat_base_tree_version"
  MULT_DEP_FILE=".compat_pivot_dep"
diff --git a/enable-older-kernels/enable-2.6.23.patch b/enable-older-kernels/enable-2.6.23.patch
index 948d249..6266c17 100644
--- a/enable-older-kernels/enable-2.6.23.patch
+++ b/enable-older-kernels/enable-2.6.23.patch
@@ -1,27 +1,25 @@
-diff --git a/config.mk b/config.mk
-index 777ebd3..2ad11fc 100644
 --- a/config.mk
 +++ b/config.mk
-@@ -25,8 +25,8 @@ KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2
+@@ -25,9 +25,9 @@
  COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
  $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
  
--ifdef CONFIG_COMPAT_KERNEL_25
--$(error "ERROR: compat-wireless by default supports kernels >= 2.6.25, try enabling only one driver though")
-+ifdef CONFIG_COMPAT_WIRELESS_23
-+$(error "ERROR: compat-wireless for selected driver requires a kernel >= 2.6.23")
- endif
+-ifdef CONFIG_COMPAT_KERNEL_24
+-$(error "ERROR: compat-wireless by default supports kernels >= 2.6.24, try enabling only one driver though")
+-endif #CONFIG_COMPAT_KERNEL_24
++ifdef CONFIG_COMPAT_KERNEL_23
++$(error "ERROR: compat-wireless by default supports kernels >= 2.6.23, try enabling only one driver though")
++endif #CONFIG_COMPAT_KERNEL_23
  
  ifeq ($(CONFIG_CFG80211),y)
-diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
-index 1e3002e..64dac69 100755
+ $(error "ERROR: your kernel has CONFIG_CFG80211=y, you should have it CONFIG_CFG80211=m if you want to use this thing.")
 --- a/scripts/gen-compat-autoconf.sh
 +++ b/scripts/gen-compat-autoconf.sh
 @@ -11,7 +11,7 @@
  
  # This indicates which is the oldest kernel we support
  # Update this if you are adding support for older kernels.
--OLDEST_KERNEL_SUPPORTED="2.6.25"
+-OLDEST_KERNEL_SUPPORTED="2.6.24"
 +OLDEST_KERNEL_SUPPORTED="2.6.23"
  COMPAT_RELEASE="compat_version"
  KERNEL_RELEASE="compat_base_tree_version"
diff --git a/enable-older-kernels/enable-2.6.24.patch b/enable-older-kernels/enable-2.6.24.patch
deleted file mode 100644
index e1e0cfc..0000000
--- a/enable-older-kernels/enable-2.6.24.patch
+++ /dev/null
@@ -1,28 +0,0 @@
-diff --git a/config.mk b/config.mk
-index 777ebd3..2ad11fc 100644
---- a/config.mk
-+++ b/config.mk
-@@ -25,8 +25,8 @@ KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2
- COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
- $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
- 
--ifdef CONFIG_COMPAT_KERNEL_25
--$(error "ERROR: compat-wireless by default supports kernels >= 2.6.25, try enabling only one driver though")
-+ifdef CONFIG_COMPAT_WIRELESS_24
-+$(error "ERROR: compat-wireless for selected driver requires a kernel >= 2.6.24")
- endif
- 
- ifeq ($(CONFIG_CFG80211),y)
-diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
-index 1e3002e..0f0e415 100755
---- a/scripts/gen-compat-autoconf.sh
-+++ b/scripts/gen-compat-autoconf.sh
-@@ -11,7 +11,7 @@
- 
- # This indicates which is the oldest kernel we support
- # Update this if you are adding support for older kernels.
--OLDEST_KERNEL_SUPPORTED="2.6.25"
-+OLDEST_KERNEL_SUPPORTED="2.6.24"
- COMPAT_RELEASE="compat_version"
- KERNEL_RELEASE="compat_base_tree_version"
- MULT_DEP_FILE=".compat_pivot_dep"
-- 
1.7.1

