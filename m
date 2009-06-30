Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:35743 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbZF3VTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:19:36 -0400
Subject: [PATCH 5/5] Unbury Makefile-meta config definitions.
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 16:19:40 -0500
Message-Id: <1246396780.13176.265.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than having them buried in the middle of the Makefile,
relocate the "quiet/not-quiet" options, MKDIR and INSTALL definitions
to the top of the file.

Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>
---
 Makefile |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index b755b67..9f9ae01 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,18 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 PUBKEY_DIR?=pubkeys
 
 
+MKDIR ?= mkdir -p
+INSTALL ?= install
+
+
+ifeq ($(V),1)
+    Q=
+    NQ=@true
+else
+    Q=@
+    NQ=@echo
+endif
+
 #
 # Determine what target and host libraries and executables
 # need to be built as that will determine what libraries will
@@ -236,17 +248,6 @@ verify: $(REG_BIN) host/regdbdump
 	$(Q)./host/regdbdump $(REG_BIN) >/dev/null
 
 
-MKDIR ?= mkdir -p
-INSTALL ?= install
-
-ifeq ($(V),1)
-Q=
-NQ=@true
-else
-Q=@
-NQ=@echo
-endif
-
 $(REG_BIN):
 	$(NQ) '  EXIST ' $(REG_BIN)
 	$(NQ)
-- 
1.6.3.GIT



