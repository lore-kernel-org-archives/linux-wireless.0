Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59339 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2B1BFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:05:55 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 3/7] compat: explicitly define paths for local configs
Date: Mon, 27 Feb 2012 17:05:37 -0800
Message-ID: <1330391141-19909-4-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_020558_720729_F77BC1C7)
In-Reply-To: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

As noted in the previous commit a Linux kernel module's
Makefile will be read twice, during initial GNU make run,
and later for when the kernel will build the external module.
Variables that require path consideration must address in
which context it needs to be defined and do so by detecting
at which run time case it wants to instantiate variables. In
our case we want to ensure that both COMPAT_CONFIG and
COMPAT_AUTOCONF are defined within the context of the
directory of the external module we are building as otherwise
GNU Make will try to treat it as part of the kernel's build
directory's files.

We already have COMPAT_CONFIG and COMPAT_AUTOCONF defined
under a ifeq ($(KERNELRELEASE),) check, we now just need
to add the directory context and then remove the other
now superfluous uses of the $(PWD).

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 287f35f..423d1ed 100644
--- a/Makefile
+++ b/Makefile
@@ -20,8 +20,8 @@ export COMPAT_BASE_TREE_VERSION := "next-20100517"
 export COMPAT_VERSION := $(shell git describe)
 
 # to check config and compat autoconf
-export COMPAT_CONFIG=.config
-export COMPAT_AUTOCONF=include/linux/compat_autoconf.h
+export COMPAT_CONFIG=$(PWD)/.config
+export COMPAT_AUTOCONF=$(PWD)/include/linux/compat_autoconf.h
 export MAKE
 
 else
@@ -43,7 +43,7 @@ endif
 
 # Recursion lets us ensure we get this file included.
 # Trick is to run make -C $(PWD) modules later.
--include $(PWD)/$(COMPAT_CONFIG)
+-include $(COMPAT_CONFIG)
 
 obj-y += compat/
 
@@ -62,8 +62,8 @@ install: modules
 $(COMPAT_AUTOCONF): ;
 
 $(COMPAT_CONFIG):
-	+@$(PWD)/scripts/gen-compat-config.sh > $(PWD)/$(COMPAT_CONFIG)
-	+@$(PWD)/scripts/gen-compat-autoconf.sh $(COMPAT_CONFIG) > $(PWD)/$(COMPAT_AUTOCONF)
+	+@$(PWD)/scripts/gen-compat-config.sh > $(COMPAT_CONFIG)
+	+@$(PWD)/scripts/gen-compat-autoconf.sh $(COMPAT_CONFIG) > $(COMPAT_AUTOCONF)
 	@$(MAKE) -C $(PWD) modules
 
 install: modules
-- 
1.7.4.15.g7811d

