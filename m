Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38705 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752626AbdLVGDS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:03:18 -0500
Received: from mail-it0-f70.google.com ([209.85.214.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSGQP-0002fB-Q0
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 06:03:17 +0000
Received: by mail-it0-f70.google.com with SMTP id c33so9795764itf.8
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:03:17 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 6/6] wireless-regdb: Document regulatory.db in the manual page
Date: Fri, 22 Dec 2017 00:03:03 -0600
Message-Id: <20171222060303.14478-7-seth.forshee@canonical.com> (sfid-20171222_070346_912112_6902797F)
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
References: <20171222060303.14478-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add information about regulatory.db to the regulatory.bin man
page, and alias the regulatory.db man page to refer to the page
for regulatory.bin.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile         |  2 +-
 regulatory.bin.5 | 32 ++++++++++++++++++++++----------
 regulatory.db.5  |  1 +
 3 files changed, 24 insertions(+), 11 deletions(-)
 create mode 100644 regulatory.db.5

diff --git a/Makefile b/Makefile
index 1e8e84c64149..2f1ed93e0e15 100644
--- a/Makefile
+++ b/Makefile
@@ -126,4 +126,4 @@ install: regulatory.bin.5.gz regulatory.db.5.gz
 	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin
 	install -m 644 -t $(DESTDIR)/$(FIRMWARE_PATH) regulatory.db regulatory.db.p7s
 	install -m 755 -d $(DESTDIR)/$(MANDIR)/man5/
-	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
+	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz regulatory.db.5.gz
diff --git a/regulatory.bin.5 b/regulatory.bin.5
index 430c65c9ce6d..b1862cd1756d 100644
--- a/regulatory.bin.5
+++ b/regulatory.bin.5
@@ -1,6 +1,6 @@
-.TH regulatory.bin 5 "23 January 2009" "regulatory.bin" "Linux"
+.TH regulatory.bin 5 "21 December 2017" "regulatory.bin" "Linux"
 .SH NAME
-regulatory.bin \- The Linux wireless regulatory database
+regulatory.bin, regulatory.db \- The Linux wireless regulatory database
 
 .ad l
 .in +8
@@ -9,24 +9,36 @@ regulatory.bin \- The Linux wireless regulatory database
 .SS
 .SH Description
 .B regulatory.bin
-is the file used by the Linux wireless subsystem to keep its regulatory
-database information. It is read by
+and
+.B regulatory.db
+are the files used by the Linux wireless subsystem to keep its regulatory
+database information.
+.PP
+.B regulatory.bin
+is read by
 .B crda
 upon the Linux kernel's request for regulatory information for a specific
-ISO / IEC 3166 alpha2 country code. The regulatory database is kept in
-a small binary format for size and code efficiency. The
+ISO / IEC 3166 alpha2 country code.
+.PP
+.B regulatory.db
+is a newer, extensible database format which (since Linux 4.15) is read
+by the kernel directly as a firmware file.
+
+The regulatory database is kept in a small binary format for size and code
+efficiency. The
 .B regulatory.bin
 file can be parsed and read in human format by using the
 .B regdbdump
-command. The
-.B regulatory.bin
-file should be updated upon regulatory changes or corrections.
+command. The regulatory database files should be updated upon regulatory
+changes or corrections.
 
 .SH Upkeeping
 The regulatory database is maintained by the community as such
 you are encouraged to send any corrections or updates to the
-linux-wireless mailing list:
+linux-wireless and wireless-regdb mailing lists:
 .B linux-wireless@vger.kernel.org
+and
+.B wireless-regdb@lists.infradead.org
 
 .SH SEE ALSO
 .BR regdbdump (8)
diff --git a/regulatory.db.5 b/regulatory.db.5
new file mode 100644
index 000000000000..6c8aae374621
--- /dev/null
+++ b/regulatory.db.5
@@ -0,0 +1 @@
+.so man5/regulatory.bin.5.gz
-- 
2.14.1
