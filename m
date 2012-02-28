Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6942 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2B1BF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:05:57 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 2/7] compat: move definition of COMPAT_CONFIG and COMPAT_AUTOCONF
Date: Mon, 27 Feb 2012 17:05:36 -0800
Message-ID: <1330391141-19909-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_020601_268614_0A1C8A51)
In-Reply-To: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

The Makefile for external modules are read twice, once during
the initial make command, and then later to build the modules
target *by the kernel*. This ensures that we define the variables
COMPAT_CONFIG and COMPAT_AUTOCONF are only defined once.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index d11da17..287f35f 100644
--- a/Makefile
+++ b/Makefile
@@ -19,6 +19,11 @@ export COMPAT_BASE_TREE := "linux-next.git"
 export COMPAT_BASE_TREE_VERSION := "next-20100517"
 export COMPAT_VERSION := $(shell git describe)
 
+# to check config and compat autoconf
+export COMPAT_CONFIG=.config
+export COMPAT_AUTOCONF=include/linux/compat_autoconf.h
+export MAKE
+
 else
 # By stuffing this hear we avoid using
 # this hackery on modpost, the 2nd section of module building.
@@ -36,11 +41,6 @@ NOSTDINC_FLAGS := -I$(M)/include/ \
 
 endif
 
-# to check config and compat autoconf
-export COMPAT_CONFIG=.config
-export COMPAT_AUTOCONF=include/linux/compat_autoconf.h
-export MAKE
-
 # Recursion lets us ensure we get this file included.
 # Trick is to run make -C $(PWD) modules later.
 -include $(PWD)/$(COMPAT_CONFIG)
-- 
1.7.4.15.g7811d

