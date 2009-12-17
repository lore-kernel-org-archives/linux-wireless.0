Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19494 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbZLQMmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 07:42:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2009 04:42:31 -0800
Date: Thu, 17 Dec 2009 18:12:25 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<mcgrof@bombadil.infradead.org>
CC: Jothikumar Mothilal <Jothikumar.Mothilal@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC]compat-wireless: modules declared as PHONY target in Makefile
Message-ID: <20091217124225.GA3068@atheros-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a particular file alone is modified in compat package, it is not compiled with make.
To compile the modified file compat package needs to be cleaned up and all files need to be compiled.
This is because all files are compiled in modules target, and file by name modules is not generated.
So this target will be considered up-to-date once compiled.

modules target is declared as PHONY target to avoid this problem.

I feel config.mk need not be included when KERNELRELEASE is not NULL as
it degrades the performance and doesn't make any difference.  Please comment.

Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
---
 Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 66790f2..85fb9fe 100644
--- a/Makefile
+++ b/Makefile
@@ -15,8 +15,6 @@ DESTDIR?=
 
 ifneq ($(KERNELRELEASE),)
 
-include $(M)/$(COMPAT_CONFIG)
-
 NOSTDINC_FLAGS := -I$(M)/include/ -include $(M)/include/linux/compat-2.6.h $(CFLAGS)
 
 obj-y := compat/
@@ -295,7 +293,7 @@ wlunload:
 wlload: wlunload
 	@./scripts/wlload.sh
 
-.PHONY: all clean install uninstall unload load btunload btload wlunload wlload
+.PHONY: all clean install uninstall unload load btunload btload wlunload wlload modules
 
 endif
 
-- 
1.6.0.4

