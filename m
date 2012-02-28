Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6942 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2B1BGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:05 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 6/7] compat: avoid unnecessary recursion to include a file
Date: Mon, 27 Feb 2012 17:05:40 -0800
Message-ID: <1330391141-19909-7-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_024218_197790_E8A2288C)
In-Reply-To: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

I added recursion call to the same Makefile after noticing that
GNU Make *will* fail if a file that is being included does not
exist. I also added the option that the file *may* not exist by
prepending the inclusion of the file with "-". It turns out that
GNU Make is smart enough to look for targets for header files that
are included and *will not fail* if it can successfully build that
file and include it. I will note that this target file *does not
need* to be a dependency to any of the final targets, GNU Make
will just assume and add it. It is important to highlight that
GNU Make *will* run make against itself again after it builds the
file it needs to include. If GNU Make runs into this situation,
where it can build the target file it needs to include, it will
not fail but you will see something like this pesky warning:

Makefile:16: /home/mcgrof/compat/.config: No such file or directory

Under new found knowledge of how GNU Make works we simplify the
reading and running of the compat Makefile by ensuring that the
file we need to include is defined as a target but for sanity and
reader's sake (although technically not necessary) we also add the
file as a dependency to the modules target building.

Furthermore the pesky warning can confuse developers / users and
as it turns out we only really need it at build time. We take
advantage of the fact that the kernel will use the same Makefile
later upon building the external module and that we can identify
when this happens in the Makefile [0] and only *require* including
the header file upon module building time.

[0] the part where ifeq ($(KERNELRELEASE),) is false

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 537d759..9e676ed 100644
--- a/Makefile
+++ b/Makefile
@@ -39,15 +39,12 @@ NOSTDINC_FLAGS := -I$(M)/include/ \
 	-DCOMPAT_PROJECT="\"Generic kernel\"" \
 	-DCOMPAT_VERSION="\"$(COMPAT_VERSION)\""
 
+include $(COMPAT_CONFIG)
 endif
 
-# Recursion lets us ensure we get this file included.
-# Trick is to run make -C $(PWD) modules later.
--include $(COMPAT_CONFIG)
-
 obj-y += compat/
 
-all: $(COMPAT_CONFIG)
+all: modules
 
 modules: $(COMPAT_CONFIG) $(COMPAT_AUTOCONF)
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) modules
@@ -63,7 +60,6 @@ $(COMPAT_AUTOCONF): $(COMPAT_CONFIG)
 
 $(COMPAT_CONFIG):
 	+@$(PWD)/scripts/gen-compat-config.sh > $(COMPAT_CONFIG)
-	@$(MAKE) -C $(PWD) modules
 
 install: modules
 
-- 
1.7.4.15.g7811d

