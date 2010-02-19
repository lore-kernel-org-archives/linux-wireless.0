Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:65133 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab0BSGDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:03:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwl3945: remove STATUS macros from header
Date: Thu, 18 Feb 2010 22:03:02 -0800
Message-Id: <1266559387-19637-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

iwl3945 includes iwl-core.h in which these STATUS flags are already
defined. This also removes a potential confusing definition with iwlcore
using STATUS_MODE_PENDING with value 18 and iwl3945 defining (but not
using) STATUS_CONF_PENDING for value 18.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   18 ------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 3 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 5913418..521584b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -45,8 +45,8 @@
 #include "iwl-sta.h"
 #include "iwl-3945.h"
 #include "iwl-eeprom.h"
-#include "iwl-helpers.h"
 #include "iwl-core.h"
+#include "iwl-helpers.h"
 #include "iwl-led.h"
 #include "iwl-3945-led.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index db4137d..ae94bab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -171,24 +171,6 @@ struct iwl3945_frame {
 
 #define SCAN_INTERVAL 100
 
-#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-#define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
-#define STATUS_INT_ENABLED	2
-#define STATUS_RF_KILL_HW	3
-#define STATUS_INIT		5
-#define STATUS_ALIVE		6
-#define STATUS_READY		7
-#define STATUS_TEMPERATURE	8
-#define STATUS_GEO_CONFIGURED	9
-#define STATUS_EXIT_PENDING	10
-#define STATUS_STATISTICS	12
-#define STATUS_SCANNING		13
-#define STATUS_SCAN_ABORTING	14
-#define STATUS_SCAN_HW		15
-#define STATUS_POWER_PMI	16
-#define STATUS_FW_ERROR		17
-#define STATUS_CONF_PENDING	18
-
 #define MAX_TID_COUNT        9
 
 #define IWL_INVALID_RATE     0xFF
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3df488a..0e5a1ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -53,8 +53,8 @@
 #include "iwl-commands.h"
 #include "iwl-sta.h"
 #include "iwl-3945.h"
-#include "iwl-helpers.h"
 #include "iwl-core.h"
+#include "iwl-helpers.h"
 #include "iwl-dev.h"
 #include "iwl-spectrum.h"
 
-- 
1.6.3.3

