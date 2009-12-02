Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbZLBUw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 15:52:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: driver version track kernel version
Date: Wed,  2 Dec 2009 12:53:01 -0800
Message-Id: <1259787181-21303-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1259787181-21303-1-git-send-email-reinette.chatre@intel.com>
References: <1259787181-21303-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The driver version number is a remnant from when there was an out-of-tree
iwlwifi driver. Now that the driver forms part of kernel source we do not
need a separate driver version. Instead, we now use the kernel version as
driver version. We maintain the previous tags used to indicate which
components the driver has been compiled with.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7cd8b7d..22a20c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -63,6 +63,8 @@
 #ifndef __iwl_core_h__
 #define __iwl_core_h__
 
+#include <linux/utsrelease.h>
+
 /************************
  * forward declarations *
  ************************/
@@ -70,7 +72,7 @@ struct iwl_host_cmd;
 struct iwl_cmd;
 
 
-#define IWLWIFI_VERSION "1.3.27k"
+#define IWLWIFI_VERSION UTS_RELEASE "-k"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a63bd5e..2a28a1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -76,11 +76,9 @@
 #define VS
 #endif
 
-#define IWL39_VERSION "1.2.26k" VD VS
+#define DRV_VERSION  IWLWIFI_VERSION VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
-#define DRV_VERSION     IWL39_VERSION
-
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
-- 
1.5.6.3

