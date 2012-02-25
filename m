Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53569 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab2BYBwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 20:52:46 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 5/5] compat-wireless: use compat's CONFIG_COMPAT_KERNEL_* variables
Date: Fri, 24 Feb 2012 17:52:06 -0800
Message-ID: <1330134726-1634-6-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_025249_271737_1C7B54D7)
In-Reply-To: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

compat already deals with defining CONFIG_COMPAT_KERNEL_* variables
for us for both makefiles and C / header files. The C / header file
usage was fixed in the last commit, this removes internal usage we
had for the Makefiles in preference over the same mechanism.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile  |    8 +++++++-
 config.mk |   18 ------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/Makefile b/Makefile
index b5423ee..5393b40 100644
--- a/Makefile
+++ b/Makefile
@@ -76,9 +76,14 @@ export CREL_PRE:=.compat_autoconf_
 export CREL_CHECK:=$(CREL_PRE)$(CREL)
 
 include $(PWD)/$(COMPAT_CONFIG_CW)
+
+# Recursion lets us ensure we get this file included.
+# Trick is to run make -C $(PWD) modules later.
 -include $(PWD)/$(COMPAT_CONFIG)
 
-all: modules
+all: $(CREL_CHECK)
+
+$COMPAT_CONFIG: ;
 
 modules: $(CREL_CHECK)
 	@./scripts/check_config.sh
@@ -100,6 +105,7 @@ $(CREL_CHECK):
 	@./scripts/check_config.sh
 	@touch $@
 	@md5sum $(COMPAT_CONFIG_CW) > $(CONFIG_CHECK)
+	make -C $(PWD) modules
 
 btinstall: btuninstall bt-install-modules
 
diff --git a/config.mk b/config.mk
index 4b47321..4bbbd88 100644
--- a/config.mk
+++ b/config.mk
@@ -16,29 +16,11 @@ endif
 
 ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
 
-COMPAT_LATEST_VERSION = 3
-
 KERNEL_VERSION := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
 
 ifneq ($(KERNEL_VERSION),2)
-KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^3\.\([0-9]\+\).*/\1/p')
 else
-COMPAT_26LATEST_VERSION = 39
 KERNEL_26SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
-COMPAT_26VERSIONS := $(shell I=$(COMPAT_26LATEST_VERSION); while [ "$$I" -gt $(KERNEL_26SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_26VERSIONS),$(eval CONFIG_COMPAT_KERNEL_2_6_$(ver)=y))
-KERNEL_SUBLEVEL := -1
-endif
-
-COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_3_$(ver)=y))
-
-RHEL_MAJOR := $(shell grep ^RHEL_MAJOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
-
-ifneq ($(RHEL_MAJOR),)
-RHEL_MINOR := $(shell grep ^RHEL_MINOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
-COMPAT_RHEL_VERSIONS := $(shell I=$(RHEL_MINOR); while [ "$$I" -ge 0 ]; do echo $$I; I=$$(($$I - 1)); done)
-$(foreach ver,$(COMPAT_RHEL_VERSIONS),$(eval CONFIG_COMPAT_RHEL_$(RHEL_MAJOR)_$(ver)=y))
 endif
 
 ifdef CONFIG_COMPAT_KERNEL_2_6_24
-- 
1.7.4.15.g7811d

