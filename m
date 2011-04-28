Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.visionsystems.de ([62.145.30.242]:32951 "EHLO
	mail.visionsystems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1D1IOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 04:14:12 -0400
Message-ID: <4DB91BB9.2080405@visionsystems.de> (sfid-20110428_101418_721537_E8F36F12)
Date: Thu, 28 Apr 2011 09:48:09 +0200
From: Yegor Yefremov <yegor_sub1@visionsystems.de>
Reply-To: yegor_sub1@visionsystems.de
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: add libnl-3.0 support
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend Makefile to find and use libnl-3.0

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Makefile |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -24,6 +24,7 @@
 
 NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
+NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
 
 ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1
@@ -35,6 +36,12 @@
 NLLIBNAME = libnl-2.0
 endif
 
+ifeq ($(NL3FOUND),Y)
+CFLAGS += -DCONFIG_LIBNL20
+LIBS += -lnl-genl
+NLLIBNAME = libnl-3.0
+endif
+
 ifeq ($(NLLIBNAME),)
 $(error Cannot find development files for any supported version of libnl)
 endif
@@ -53,6 +60,8 @@
 all: version_check $(ALL)
 
 version_check:
+ifeq ($(NL3FOUND),Y)
+else
 ifeq ($(NL2FOUND),Y)
 else
 ifeq ($(NL1FOUND),Y)
@@ -60,6 +69,7 @@
 	$(error No libnl found)
 endif
 endif
+endif
 
 
 VERSION_OBJS := $(filter-out version.o, $(OBJS))

