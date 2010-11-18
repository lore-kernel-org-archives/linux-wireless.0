Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760134Ab0KRUGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:06:36 -0500
Subject: [PATCH] iwlwifi: fix modular 3945 only build
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 12:08:10 -0800
Message-ID: <1290110890.3801.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If only 3945 is selected, and is a module, build
fails because iwl-legacy.c won't be compiled. Fix
this by adding it to the build correctly.

This doesn't happen for 4965 because it is a bool
option, not tristate, since it's built into the
AGN module.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/Makefile	2010-11-18 12:04:47.000000000 -0800
+++ wireless-testing/drivers/net/wireless/iwlwifi/Makefile	2010-11-18 12:05:27.000000000 -0800
@@ -7,6 +7,10 @@ iwlcore-$(CONFIG_IWL4965) += iwl-legacy.
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
+# If 3945 is selected only, iwl-legacy.o will be added
+# to iwlcore-m above, but it needs to be built in.
+iwlcore-objs += $(iwlcore-m)
+
 CFLAGS_iwl-devtrace.o := -I$(src)
 
 # AGN


