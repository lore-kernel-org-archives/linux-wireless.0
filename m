Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:34859 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbZHMBpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 21:45:45 -0400
Received: from [192.168.10.7] (builder.redfish-solutions.com [192.168.10.7])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.2/8.14.2) with ESMTP id n7D1jcWo011198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 19:45:46 -0600
Message-ID: <4A837042.4000507@redfish-solutions.com>
Date: Wed, 12 Aug 2009 18:45:38 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Minimal cross-compilation fix for CRDA
Content-Type: multipart/mixed;
 boundary="------------020606090000060301060504"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020606090000060301060504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Reposting.

I think I've addresses all of the comments, and this fix is as short as
possible.

I considered passing in all of the variables from outside, but (a) this
doesn't scale well, and (b) things like $(NLLIBNAME) are "scratch"
variables used by the make process when doing discovery about the host
it's running on... they shouldn't be externally visible, much less
overridden by some encompassing make.

Putting the auto-discovery into its own path with a gating variable
seems like the cleanest, most robust, most maintainable approach.



--------------020606090000060301060504
Content-Type: text/plain;
 name="crda-cross-compile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="crda-cross-compile.patch"

Changes:

1. Move invariant definitions to before any cross-compilation conditional sections for clarity (and to avoid having to duplicate them).

2. Bracket any host (native) compilation sections with conditional based on $(CROSS_COMPILE) being empty.

4. Add 'else' section for cross-compilation using openssl and libnl-1 (or libnl-2 if explicitly selected).


--- crda-1.1.0/Makefile	2009-08-10 13:37:36.000000000 -0700
+++ crda-1.1.0/Makefile.new	2009-08-10 17:29:22.000000000 -0700
@@ -22,12 +22,17 @@
 # with make PUBKEY_DIR=/usr/lib/crda/pubkeys
 PUBKEY_DIR?=pubkeys
 
+MKDIR ?= mkdir -p
+INSTALL ?= install
+
 CFLAGS += -Wall -g
 
 all: all_noverify verify
 
 all_noverify: crda intersect regdbdump
 
+ifeq ($(CROSS_COMPILE),)
+
 ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
@@ -41,8 +46,6 @@
 reglib.o: keys-gcrypt.c
 
 endif
-MKDIR ?= mkdir -p
-INSTALL ?= install
 
 NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
@@ -64,6 +67,31 @@
 NLLIBS += `pkg-config --libs $(NLLIBNAME)`
 CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
 
+else
+
+ifeq ($(USE_OPENSSL),1)
+CFLAGS += -DUSE_OPENSSL
+LDLIBS += -lssl
+
+reglib.o: keys-ssl.c
+
+else
+CFLAGS += -DUSE_GCRYPT
+LDLIBS += -lgcrypt
+
+reglib.o: keys-gcrypt.c
+
+endif
+
+ifeq ($(USE_LIBNL20),1)
+CFLAGS += -DCONFIG_LIBNL20
+NLLIBS = -lnl-genl -lnl-2.0
+else
+NLLIBS = -lnl
+endif
+
+endif
+
 ifeq ($(V),1)
 Q=
 NQ=@true

--------------020606090000060301060504--
