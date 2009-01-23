Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40825 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757547AbZAWW5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:57:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 14:57:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wireless-regdb: adds a manpage for regulatory.bin, updates Makefile
Date: Fri, 23 Jan 2009 14:56:27 -0800
Message-ID: <1232751387-22651-1-git-send-email-lrodriguez@atheros.com> (sfid-20090123_235707_668739_E90319D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a man page for the regulatory.bin file and updates
the Makefile to make it the install target flexible for distributions.
As part of the install you also now get the the man page.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Makefile         |   19 +++++++++++++++----
 regulatory.bin.5 |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 4 deletions(-)
 create mode 100644 regulatory.bin.5

diff --git a/Makefile b/Makefile
index 07c3030..0171196 100644
--- a/Makefile
+++ b/Makefile
@@ -2,12 +2,16 @@
 PREFIX = /usr
 CDRA_PATH = $(PREFIX)/lib/crda
 
+SBINDIR ?= /sbin/
+MANDIR ?= $(PREFIX)/share/man/
+
+
 .PHONY: all clean install maintainer-clean
 
 all: regulatory.bin key.pub.pem
 
 clean:
-	rm -f *.pyc
+	rm -f *.pyc *.gz
 
 maintainer-clean: clean
 	rm -f regulatory.bin key.pub.pem
@@ -23,6 +27,13 @@ endif
 key.priv.pem:
 	openssl genrsa -out key.priv.pem 2048
 
-install:
-	install -o 0 -g 0 -m 755 -d $(CDRA_PATH)
-	install -o 0 -g 0 -m 644 regulatory.bin $(CDRA_PATH)/regulatory.bin
+%.gz: %
+	gzip < $< > $@
+
+# Distributions wishing to just use John's database
+# can just call make install.
+install: regulatory.bin.5.gz
+	install -o 0 -g 0 -m 755 -d $(DESTDIR)/$(CDRA_PATH)
+	install -o 0 -g 0 -m 644 regulatory.bin $(DESTDIR)/$(CDRA_PATH)/regulatory.bin
+	mkdir -p $(DESTDIR)/$(MANDIR)/man5/
+	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
diff --git a/regulatory.bin.5 b/regulatory.bin.5
new file mode 100644
index 0000000..d4f80cb
--- /dev/null
+++ b/regulatory.bin.5
@@ -0,0 +1,37 @@
+.TH regulatory.bin 8 "23 January 2009" "regulatory.bin" "Linux"
+.SH NAME
+regulatory.bin \- The Linux wireless regulatory database
+
+.ad l
+.in +8
+.ti -8
+
+.SS
+.SH Description
+.B regulatory.bin
+is the file used by the Linux wireless subsystem to keep its regulatory
+database information. It is read by
+.B crda
+upon the Linux kernel's request for regulatory information for a specific
+ISO / IEC 3166 alpha2 country code. The regulatory database is kept in
+a small binary format for size and code efficiency. The
+.B regulatory.bin
+file can be parsed and read in human format by using the
+.B regdbdump
+command. The
+.B regulatory.bin
+file should be updated upon regulatory changes or corrections.
+
+.SH Upkeeping
+The regulatory database is maintained by the community as such
+you are encouraged to send any corrections or updates to the
+linux-wireless mailing list:
+.B linux-wireless@vger.kernel.org
+
+.SH SEE ALSO
+.BR regdbdump (8)
+.BR crda (8)
+.BR iw (8)
+
+.BR http://wireless.kernel.org/en/developers/Regulatory/
+
-- 
1.6.1.rc3.51.g5832d

