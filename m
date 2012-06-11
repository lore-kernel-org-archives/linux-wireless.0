Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2FKJyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:54:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Brandon Misemer <brandon.misemer@intel.com>
Subject: [PATCH 10/13] iwlwifi: Fix Makefile build order for built-in driver
Date: Mon, 11 Jun 2012 11:53:09 +0200
Message-Id: <1339408392-19425-11-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115424_398673_ABA4D870)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brandon Misemer <brandon.misemer@intel.com>

When the driver is built into the kernel instead of a module
when the system boots it results in a panic. The order things are built in
results in their initialization order when built into the kernel. Wifi
has to be initialized before mvm or dvm.

Reviewed-by: Donald H Fry <donald.h.fry@intel.com>
Tested-by: Donald H Fry <donald.h.fry@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Brandon Misemer <brandon.misemer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index afa9758..170ec33 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,7 +1,3 @@
-obj-$(CONFIG_IWLDVM)	+= dvm/
-
-CFLAGS_iwl-devtrace.o := -I$(src)
-
 # common
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
 iwlwifi-objs		+= iwl-io.o
@@ -16,3 +12,8 @@ iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-test.o
 
 ccflags-y += -D__CHECK_ENDIAN__ -I$(src)
+
+
+obj-$(CONFIG_IWLDVM)	+= dvm/
+
+CFLAGS_iwl-devtrace.o := -I$(src)
-- 
1.7.10

