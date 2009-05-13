Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:44742 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbZEMJRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:17:37 -0400
Received: from spunkymail-a18.g.dreamhost.com (caiajhbdcbef.dreamhost.com [208.97.132.145])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 29F2717A2CC
	for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 02:17:39 -0700 (PDT)
Received: from [192.168.10.51] (81.Red-83-44-145.dynamicIP.rima-tde.net [83.44.145.81])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by spunkymail-a18.g.dreamhost.com (Postfix) with ESMTP id 3C4245B52C
	for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 02:16:23 -0700 (PDT)
Message-ID: <4A0A8FE2.6040003@hiramoto.org>
Date: Wed, 13 May 2009 11:16:18 +0200
From: Karl Hiramoto <karl@hiramoto.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iw/Makefile use pkg-config if passed from environmental var.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes cross compiling easier.


Signed-off-by:  Karl Hiramoto <karl@hiramoto.org>

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


