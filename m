Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57911 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYLLVcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 16:32:07 -0500
Message-ID: <4942D853.10105@gmail.com> (sfid-20081212_223213_063429_8C2326A6)
Date: Fri, 12 Dec 2008 21:32:03 +0000
From: Mike Auty <mike.auty@gmail.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: iw Makefile patch to allow compilation using --as-needed
Content-Type: multipart/mixed;
 boundary="------------080208030405080902030808"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080208030405080902030808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hiya,
	I've got a patch for the iw program to allow it to compile properly
with the --as-needed linker flag.  This flag requires that files and
libraries are listed in a particular order, with required libraries
listed after the functions that call them.
	The original Makefile for iw adds the libraries to the LDFLAGS
variable, which is processed before the OBJS are listed (so the
libraries are removed).  This patch adds a LIBS variable and applies it
after the OBJS variable.
	For more information on as-needed, please see
http://www.gentoo.org/proj/en/qa/asneeded.xml.  If you have any problems
or issues with the patch, please let me know, thanks...  5:)
	Mike  5:)

--------------080208030405080902030808
Content-Type: text/plain;
 name="iw-0.9.7-as-needed.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iw-0.9.7-as-needed.patch"

diff --git a/Makefile b/Makefile
index df59b51..8a97bae 100644
--- a/Makefile
+++ b/Makefile
@@ -12,7 +12,7 @@ CC ?= "gcc"
 
 CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration `pkg-config --cflags libnl-1`
 CFLAGS += -O2 -g
-LDFLAGS += `pkg-config --libs libnl-1`
+LIBS += `pkg-config --libs libnl-1`
 NLVERSION = 1.0
 
 OBJS = iw.o info.o phy.o interface.o station.o util.o mpath.o reg.o mesh.o genl.o
@@ -42,7 +42,7 @@ version.h: version.sh
 
 iw:	$(OBJS)
 	@$(NQ) ' CC  ' iw
-	$(Q)$(CC) $(LDFLAGS) $(OBJS) -o iw
+	$(Q)$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o iw
 
 check:
 	$(Q)$(MAKE) all CC="REAL_CC=$(CC) CHECK=\"sparse -Wall\" cgcc"

--------------080208030405080902030808--
