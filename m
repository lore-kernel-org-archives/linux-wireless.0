Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35227 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333AbcFAIk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 04:40:27 -0400
From: maxin.john@gmail.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Maxin B. John" <maxin.john@intel.com>
Subject: [PATCH] iw: support and enable separate build dir
Date: Wed,  1 Jun 2016 11:40:16 +0300
Message-Id: <1464770416-17514-1-git-send-email-maxin.john@gmail.com> (sfid-20160601_104047_570997_0D3EB884)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Maxin B. John" <maxin.john@intel.com>

Support separation of SRCDIR and OBJDIR

Signed-off-by: Christopher Larson <chris_larson@mentor.com>
Signed-off-by: Maxin B. John <maxin.john@intel.com>
---
 Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e61825e..1bc27c1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,7 @@
 MAKEFLAGS += --no-print-directory
-
+SRCDIR ?= $(dir $(lastword $(MAKEFILE_LIST)))
+OBJDIR ?= $(PWD)
+VPATH = $(SRCDIR)
 PREFIX ?= /usr
 SBINDIR ?= $(PREFIX)/sbin
 MANDIR ?= $(PREFIX)/share/man
@@ -96,11 +98,11 @@ VERSION_OBJS := $(filter-out version.o, $(OBJS))
 version.c: version.sh $(patsubst %.o,%.c,$(VERSION_OBJS)) nl80211.h iw.h Makefile \
 		$(wildcard .git/index .git/refs/tags)
 	@$(NQ) ' GEN ' $@
-	$(Q)./version.sh $@
+	$(Q)cd $(SRCDIR) && ./version.sh $(OBJDIR)/$@
 
 %.o: %.c iw.h nl80211.h
 	@$(NQ) ' CC  ' $@
-	$(Q)$(CC) $(CFLAGS) -c -o $@ $<
+	$(Q)$(CC) -I$(SRCDIR) $(CFLAGS) -c -o $@ $<
 
 ifeq ($(IW_ANDROID_BUILD),)
 iw:	$(OBJS)
-- 
2.4.0

