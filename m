Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17464 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbYA3Akz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 19:40:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: mcgrof@winlab.rutgers.edu
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] compat-2.6: enable install on clean system
Date: Tue, 29 Jan 2008 16:40:53 -0800
Message-Id: <1201653653-1560-1-git-send-email-reinette.chatre@intel.com> (sfid-20080130_004120_939178_64CA370A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"make install" depends on "uninstall". When "make install" is run for the first
time the scripts athenable and b43enable have not yet been placed in their expected
location (/usr/sbin). This causes the build to fail when uninstall tries to use these
scripts.

Change the uninstall rule to only use these scripts if they exist in their expected
location.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 6603ba6..7608199 100644
--- a/Makefile
+++ b/Makefile
@@ -124,6 +124,8 @@ uninstall:
 	@# on the misc directory.
 	@rm -f $(KLIB)/$(KMODDIR)/drivers/misc/eeprom_93cx6.ko
 	@depmod -ae
+	@if [ -x /usr/sbin/athenable ]; then /usr/sbin/athenable madwifi; fi
+	@if [ -x /usr/sbin/b43enable ]; then /usr/sbin/b43enable bcm43xx; fi
 	@/usr/sbin/athenable madwifi
 	@/usr/sbin/b43enable bcm43xx
 	@echo
-- 
1.5.3.4

