Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:49237 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbZHFIIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 04:08:32 -0400
Received: from [192.168.10.7] (tosh.redfish-solutions.com [63.224.43.239])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.2/8.14.2) with ESMTP id n7688UwT021240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2009 02:08:32 -0600
Message-ID: <4A7A8F7E.6020503@redfish-solutions.com>
Date: Thu, 06 Aug 2009 01:08:30 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: CRDA and cross-compilation
Content-Type: multipart/mixed;
 boundary="------------040007070709080100010706"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040007070709080100010706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Who currently owns CRDA?

I started to stare at cross-compiling issues, but realized that we need
two versions of reglib.o and print-regdom.o...

One to link with regdumpdb (compiled with HOSTCC) and one to link with
everything else (compiled with TARGET_CC)...

No easy way to do this without a lot of changes.

Here's what I have so far.


--------------040007070709080100010706
Content-Type: text/plain;
 name="crda-cross-compile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="crda-cross-compile.patch"

--- crda-1.1.0/Makefile.orig	2009-04-17 14:49:45.000000000 -0700
+++ crda-1.1.0/Makefile	2009-08-06 00:53:47.000000000 -0700
@@ -1,6 +1,6 @@
 # Modify as you see fit, note this is built into crda,
 # so if you change it here you will have to change crda.c
-REG_BIN?=/usr/lib/crda/regulatory.bin
+REG_BIN?=$(DESTDIR)/usr/lib/crda/regulatory.bin
 REG_GIT?=git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
 
 PREFIX ?= /usr/
@@ -22,46 +22,74 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 # with make PUBKEY_DIR=/usr/lib/crda/pubkeys
 PUBKEY_DIR?=pubkeys
 
+MKDIR ?= mkdir -p
+INSTALL ?= install
+
 CFLAGS += -Wall -g
 
 all: $(REG_BIN) crda intersect verify
 
-ifeq ($(USE_OPENSSL),1)
+ifeq ($(CROSS_COMPILE),)
+
+ ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
 
 reglib.o: keys-ssl.c
 
-else
+ else
 CFLAGS += -DUSE_GCRYPT
 LDLIBS += -lgcrypt
 
 reglib.o: keys-gcrypt.c
 
-endif
-MKDIR ?= mkdir -p
-INSTALL ?= install
+ endif
 
 NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
 
-ifeq ($(NL1FOUND),Y)
+ ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1
-endif
+ endif
 
-ifeq ($(NL2FOUND),Y)
+ ifeq ($(NL2FOUND),Y)
 CFLAGS += -DCONFIG_LIBNL20
 NLLIBS += -lnl-genl
 NLLIBNAME = libnl-2.0
-endif
+ endif
 
-ifeq ($(NLLIBNAME),)
+ ifeq ($(NLLIBNAME),)
 $(error Cannot find development files for any supported version of libnl)
-endif
+ endif
 
 NLLIBS += `pkg-config --libs $(NLLIBNAME)`
 CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
 
+else
+
+ ifeq ($(USE_OPENSSL),1)
+CFLAGS += -DUSE_OPENSSL
+LDLIBS += -lssl
+
+reglib.o: keys-ssl.c
+
+ else
+CFLAGS += -DUSE_GCRYPT
+LDLIBS += -lgcrypt
+
+reglib.o: keys-gcrypt.c
+
+ endif
+
+ ifeq ($(USE_LIBNL20),1)
+CFLAGS += DCONFIG_LIBNL20
+NLLIBS = -lnl-genl -lnl-2.0
+ else
+NLLIBS = -lnl
+ endif
+
+endif
+
 ifeq ($(V),1)
 Q=
 NQ=@true
@@ -111,6 +139,10 @@ verify: $(REG_BIN) regdbdump
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
+install-reg:
+	git clone $(REG_GIT) wireless-regdb
+	$(INSTALL) -m 0444 -D wireless-regdb/regulatory.bin $(REG_BIN)
+
 install: crda crda.8.gz regdbdump.8.gz
 	$(NQ) '  INSTALL  crda'
 	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)

--------------040007070709080100010706--
