Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:52539 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab1KKWsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 17:48:09 -0500
From: Gilles Espinasse <g.esp@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] iw : V2 fix compilation against libnl-3.x
Date: Sat, 12 Nov 2011 00:04:38 +0100
Message-Id: <1321052678-23396-1-git-send-email-g.esp@free.fr> (sfid-20111111_234815_290810_DE807291)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add configuration to compile against 3.1 and 3.2 without breaking 3.0
That's a bit of mess with version on .pc file and the part which belong or not to the shared lib name.

libnl-genl-3.1 is broken and can't be used

Starting from 3.2.0, I could have used libnl-genl-3.0.pc file like in patch V1 and not hardcode adding libnl-genl-3 into LIBS
I consider this a matter of tast for now, coded like previous versions that can't use that way to code.

Added an echo to display against which libnl version iw is compiled.
That particulary help me to test with various versions because of the mess on .pc file version as libnl>=3.2.0 has again pc file version with 3.0 number.

Removed the version_check part instead of extending blindly for the new versions.
That was mostly dead code because prior check on NLLIBNAME not empty already care.
The only case where that could matter would be using something stupid like
NLLIBNAME=foo make

Compilation tested to work against
- libnl-2.0
- libnl-3.0
- libnl-3.1
- libnl-3.2.0
- libnl-3.2.2

Tested to fail without a libnl .pc file

Signed-off-by: Gilles Espinasse <g.esp@free.fr>
---
 Makefile |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 8443ee6..c7f6d72 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,8 @@ ALL = iw
 NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
 NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
+NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
+NL3xFOUND := $(shell $(PKG_CONFIG) --atleast-version=3.2 libnl-3.0 && echo Y)
 
 ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1
@@ -42,12 +44,27 @@ LIBS += -lnl-genl
 NLLIBNAME = libnl-3.0
 endif
 
+# nl-3.1 has a broken libnl-gnl-3.1.pc file
+# as show by pkg-config --debug --libs --cflags --exact-version=3.1 libnl-genl-3.1;echo $?
+ifeq ($(NL31FOUND),Y)
+CFLAGS += -DCONFIG_LIBNL30
+LIBS += -lnl-genl
+NLLIBNAME = libnl-3.1
+endif
+
+ifeq ($(NL3xFOUND),Y)
+CFLAGS += -DCONFIG_LIBNL30
+LIBS += -lnl-genl-3
+NLLIBNAME = libnl-3.0
+endif
+
 ifeq ($(NLLIBNAME),)
 $(error Cannot find development files for any supported version of libnl)
 endif
 
 LIBS += $(shell $(PKG_CONFIG) --libs $(NLLIBNAME))
 CFLAGS += $(shell $(PKG_CONFIG) --cflags $(NLLIBNAME))
+NLVERSION :=$(shell $(PKG_CONFIG) --print-provides $(NLLIBNAME))
 
 ifeq ($(V),1)
 Q=
@@ -57,20 +74,8 @@ Q=@
 NQ=echo
 endif
 
-all: version_check $(ALL)
-
-version_check:
-ifeq ($(NL3FOUND),Y)
-else
-ifeq ($(NL2FOUND),Y)
-else
-ifeq ($(NL1FOUND),Y)
-else
-	$(error No libnl found)
-endif
-endif
-endif
-
+all: $(ALL)
+	@echo "Compilation against $(NLVERSION)"
 
 VERSION_OBJS := $(filter-out version.o, $(OBJS))
 
-- 
1.5.6.5

