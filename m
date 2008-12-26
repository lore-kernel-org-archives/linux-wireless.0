Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46430 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbYLZWo3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 17:44:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] wireless-regdb: Add install target to Makefile
Date: Fri, 26 Dec 2008 23:42:57 +0100
Cc: linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812262342.57675.mb@bu3sch.de> (sfid-20081226_234431_796191_86A8F3F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds an "install" target to the Makefile.
We intentionally don't make install depend on "all" or another build
target, to avoid an undesired rebuild.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-regdb/Makefile
===================================================================
--- wireless-regdb.orig/Makefile	2008-12-26 23:33:19.000000000 +0100
+++ wireless-regdb/Makefile	2008-12-26 23:38:54.000000000 +0100
@@ -1,4 +1,7 @@
-.PHONY: all clean
+# Install prefix
+PREFIX = /usr
+
+.PHONY: all clean install
 
 all: regulatory.bin key.pub.pem
 
@@ -13,3 +16,6 @@
 
 key.priv.pem:
 	openssl genrsa -out key.priv.pem 2048
+
+install:
+	-install -o 0 -g 0 -m 644 regulatory.bin $(PREFIX)/lib/crda/regulatory.bin

-- 
Greetings, Michael.
