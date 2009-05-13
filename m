Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:46752 "EHLO
	spunkymail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756990AbZEMVIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:08:47 -0400
From: Karl Hiramoto <karl@hiramoto.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Karl Hiramoto <karl@hiramoto.org>
Subject: [PATCH] iw/Makefile use pkg-config if passed from environmental var. Makes cross compiling easier.
Date: Wed, 13 May 2009 23:08:35 +0200
Message-Id: <1242248915-20372-1-git-send-email-karl@hiramoto.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cross-compiling with buildroot, this patch allows iw to be compiled using the buildroot pkg-config, and removes the requirement of pkg-config being installed on the host machine.  You can pass the full path the the pkg-config binary as PKG_CONFIG variable.

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 6d232c5..56a11e6 100644
--- a/Makefile
+++ b/Makefile
@@ -5,6 +5,7 @@ MAKEFLAGS += --no-print-directory
 PREFIX ?= /usr
 BINDIR ?= $(PREFIX)/bin
 MANDIR ?= $(PREFIX)/share/man
+PKG_CONFIG ?= pkg-config
 
 MKDIR ?= mkdir -p
 INSTALL ?= install
@@ -16,8 +17,8 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
 OBJS = iw.o genl.o event.o info.o phy.o interface.o ibss.o station.o util.o mesh.o mpath.o scan.o reg.o version.o reason.o status.o
 ALL = iw
 
-NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
-NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
+NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
+NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
 
 ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1
-- 
1.6.0.6

