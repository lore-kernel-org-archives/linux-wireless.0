Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38701 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbdLVGDR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:03:17 -0500
Received: from mail-io0-f197.google.com ([209.85.223.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSGQO-0002et-2d
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 06:03:16 +0000
Received: by mail-io0-f197.google.com with SMTP id 79so3271469iou.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:03:16 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/6] wireless-regdb: Install regulatory.db and regulatory.db.p7s to /lib/firmware
Date: Fri, 22 Dec 2017 00:03:02 -0600
Message-Id: <20171222060303.14478-6-seth.forshee@canonical.com> (sfid-20171222_070346_304873_FAA91747)
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
References: <20171222060303.14478-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

regulatory.db is being installed to the CRDA path, however the
kernel expects it to be in /lib/firmware. Install it to the
proper location. Also install the detached signature, which is
needed for the kernel to check verify the database authenticity.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 044251f64785..1e8e84c64149 100644
--- a/Makefile
+++ b/Makefile
@@ -2,6 +2,7 @@
 PREFIX ?= /usr
 CRDA_PATH ?= $(PREFIX)/lib/crda
 CRDA_KEY_PATH ?= $(CRDA_PATH)/pubkeys
+FIRMWARE_PATH ?= /lib/firmware
 
 MANDIR ?= $(PREFIX)/share/man/
 
@@ -117,10 +118,12 @@ install-distro-key: maintainer-clean $(DISTRO_PRIVKEY)
 install: regulatory.bin.5.gz regulatory.db.5.gz
 	install -m 755 -d $(DESTDIR)/$(CRDA_PATH)
 	install -m 755 -d $(DESTDIR)/$(CRDA_KEY_PATH)
+	install -m 755 -d $(DESTDIR)/$(FIRMWARE_PATH)
 	if [ -f .custom ]; then \
 		install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(shell cat .custom); \
 	fi
 	install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(REGDB_UPSTREAM_PUBKEY)
-	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin regulatory.db
+	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin
+	install -m 644 -t $(DESTDIR)/$(FIRMWARE_PATH) regulatory.db regulatory.db.p7s
 	install -m 755 -d $(DESTDIR)/$(MANDIR)/man5/
 	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
-- 
2.14.1
