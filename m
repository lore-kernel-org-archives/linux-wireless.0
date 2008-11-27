Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:53931 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYK0PzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 10:55:05 -0500
From: Tony Vroon <tony@linx.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Allow CRDA to be compiled with -Wl,--as-needed
Message-Id: <20081127154658.5154E10096@gold.linx.net> (sfid-20081127_165510_694386_88E8D633)
Date: Thu, 27 Nov 2008 15:46:58 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As libraries are passed in LDFLAGS, it is vital that they be specified after the object 
files. Otherwise, --as-needed will discard the libraries as unused and linking will fail.

Signed-off-by: Tony Vroon <tony@linx.net>

--- crda-0.9.4/Makefile.orig	2008-11-27 14:44:02.000000000 +0000
+++ crda-0.9.4/Makefile	2008-11-27 14:45:59.000000000 +0000
@@ -35,15 +35,15 @@
 
 crda: keys-ssl.c keys-gcrypt.c reglib.o crda.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) `pkg-config --libs libnl-1` -o $@ reglib.o crda.o
+	$(Q)$(CC) $(CFLAGS) `pkg-config --libs libnl-1` -o $@ reglib.o crda.o $(LDFLAGS)
 
 regdbdump: keys-ssl.c keys-gcrypt.c reglib.o regdbdump.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o
+	$(Q)$(CC) $(CFLAGS) -o $@ reglib.o regdbdump.o $(LDFLAGS)
 
 intersect: keys-ssl.c keys-gcrypt.c reglib.o intersect.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o
+	$(Q)$(CC) $(CFLAGS) -o $@ reglib.o intersect.o $(LDFLAGS)
 
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
