Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:3682 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYLAM1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 07:27:15 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1276727nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 04:27:13 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 3/3] Use Makefile dependency information for linking.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 13:27:11 +0100
Message-ID: <20081201122711.20222.40108.stgit@localhost> (sfid-20081201_132717_776061_76174AAA)
In-Reply-To: <20081201122657.20222.49058.stgit@localhost>
References: <20081201122657.20222.49058.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---

 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 2fb94fc..9651a9b 100644
--- a/Makefile
+++ b/Makefile
@@ -44,15 +44,15 @@ keys-%.c: utils/key2pub.py $(PUBKEY_DIR)/$(wildcard *.pem)
 
 crda: reglib.o crda.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o crda.o `pkg-config --libs libnl-1` $(LDLIBS)
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ `pkg-config --libs libnl-1` $(LDLIBS)
 
 regdbdump: reglib.o regdbdump.o print-regdom.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o print-regdom.o $(LDLIBS)
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 intersect: reglib.o intersect.o print-regdom.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o print-regdom.o $(LDLIBS)
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'

