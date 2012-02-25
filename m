Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49012 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2BYETo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 23:19:44 -0500
Received: by mail-pw0-f46.google.com with SMTP id up15so170446pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 20:19:44 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: hauke@hauke-m.de, nbd@nbd.name, linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 3/4] compat: avoid NOSTDINC_FLAGS during modpost
Date: Fri, 24 Feb 2012 20:19:28 -0800
Message-Id: <1330143569-30296-4-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_051948_041170_5B9F3676)
In-Reply-To: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

modpost, the second part of module building, does not
use NOSTDINC_FLAGS and friends so all the hackery we did
to use it to prefer our header files and include compat-2.6.h
will not work during modpost for older kernels. We don't really
need all that stuff during modpost even for newer kernels so
just avoid it all together.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index fdcff5c..d96d098 100644
--- a/Makefile
+++ b/Makefile
@@ -18,6 +18,22 @@ export COMPAT_BASE_TREE := "linux-next.git"
 # working with.
 export COMPAT_BASE_TREE_VERSION := "next-20100517"
 export COMPAT_VERSION := $(shell git describe)
+
+else
+# By stuffing this hear we avoid using
+# this hackery on modpost, the 2nd section of module building.
+#
+# This hack lets us put our include path first than the kernel's
+# when building our compat modules. Your own makefile would look
+# the same.
+NOSTDINC_FLAGS := -I$(M)/include/ \
+	-include $(M)/include/linux/compat-2.6.h \
+	$(CFLAGS) \
+	-DCOMPAT_BASE_TREE="\"$(COMPAT_BASE_TREE)\"" \
+	-DCOMPAT_BASE_TREE_VERSION="\"$(COMPAT_BASE_TREE_VERSION)\"" \
+	-DCOMPAT_PROJECT="\"Generic kernel\"" \
+	-DCOMPAT_VERSION="\"$(COMPAT_VERSION)\""
+
 endif
 
 # to check config and compat autoconf
@@ -31,17 +47,6 @@ export MAKE
 
 obj-y += compat/
 
-# This hack lets us put our include path first than the kernel's
-# when building our compat modules. Your own makefile would look
-# the same.
-NOSTDINC_FLAGS := -I$(M)/include/ \
-	-include $(M)/include/linux/compat-2.6.h \
-	$(CFLAGS) \
-	-DCOMPAT_BASE_TREE="\"$(COMPAT_BASE_TREE)\"" \
-	-DCOMPAT_BASE_TREE_VERSION="\"$(COMPAT_BASE_TREE_VERSION)\"" \
-	-DCOMPAT_PROJECT="\"Generic kernel\"" \
-	-DCOMPAT_VERSION="\"$(COMPAT_VERSION)\""
-
 all: $(COMPAT_CONFIG)
 
 modules: $(COMPAT_CONFIG) $(COMPAT_AUTOCONF)
-- 
1.7.4.15.g7811d

