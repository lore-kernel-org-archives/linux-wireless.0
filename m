Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2GCN2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 09:28:33 -0400
Message-ID: <1341322108.20124.3.camel@jlt3.sipsolutions.net> (sfid-20120703_152837_072336_348777E2)
Subject: [PATCH] compat-wireless: fix debugging in iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 Jul 2012 15:28:28 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As compat includes linux/device.h well before iwlwifi, the
definitions from there are used without DEBUG, but iwlwifi
defines DEBUG to get debug output. Use dev_printk instead
of dev_dbg to get debugging back.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/57-iwlwifi-debug-fix.patch |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 patches/57-iwlwifi-debug-fix.patch

diff --git a/patches/57-iwlwifi-debug-fix.patch b/patches/57-iwlwifi-debug-fix.patch
new file mode 100644
index 0000000..4b2dfa9
--- /dev/null
+++ b/patches/57-iwlwifi-debug-fix.patch
@@ -0,0 +1,19 @@
+Due to compat including linux/device.h before we do,
+we don't get a chance to #define DEBUG to get our
+debugging prints. This patch replaces dev_dbg with
+dev_printk to make them show up again.
+
+--- a/drivers/net/wireless/iwlwifi/iwl-debug.c
++++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
+@@ -138,8 +138,9 @@ void __iwl_dbg(struct device *dev,
+ 
+ 		va_copy(args2, args);
+ 		vaf.va = &args2;
+-		dev_dbg(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
+-			function, &vaf);
++		dev_printk(KERN_DEBUG, dev, "%c %s %pV",
++			   in_interrupt() ? 'I' : 'U',
++			   function, &vaf);
+ 		va_end(args2);
+ 	}
+ #endif
-- 
1.7.10



