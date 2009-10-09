Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761352AbZJIUWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/17] iwlwifi: remove duplicated/unused definition
Date: Fri,  9 Oct 2009 13:20:23 -0700
Message-Id: <1255119634-3060-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

"IWL_CMD_QUEUE_NUM" is being defined in multiple places and used by all
the devices. move it to iwl-dev.h file and shared by all the devices.

Remove "IWL_CMD_FIFO_NUM", replaced by "IWL49_CMD_FIFO_NUM" and IWL50_CMD_FIFO_NUM"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |    6 ------
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    3 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    6 ++++++
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 1677278..ccdac69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -71,12 +71,6 @@
 
 #include "iwl-eeprom.h"
 
-/*
- * uCode queue management definitions ...
- * Queue #4 is the command queue for 3945 and 4965.
- */
-#define IWL_CMD_QUEUE_NUM	4
-
 /* Time constants */
 #define SHORT_SLOT_TIME 9
 #define LONG_SLOT_TIME 20
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index b34322a..c606366 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -76,12 +76,9 @@
 
 /*
  * uCode queue management definitions ...
- * Queue #4 is the command queue for 3945 and 4965; map it to Tx FIFO chnl 4.
  * The first queue used for block-ack aggregation is #7 (4965 only).
  * All block-ack aggregation queues should map to Tx DMA/FIFO channel 7.
  */
-#define IWL_CMD_QUEUE_NUM       4
-#define IWL_CMD_FIFO_NUM        4
 #define IWL49_FIRST_AMPDU_QUEUE	7
 
 /* Time constants */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9da0b03..394402a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -323,6 +323,12 @@ struct iwl_channel_info {
  * queue, 2 (unused) HCCA queues, and 4 HT queues (one for each AC) */
 #define IWL_MIN_NUM_QUEUES	10
 
+/*
+ * uCode queue management definitions ...
+ * Queue #4 is the command queue for 3945/4965/5x00/1000/6x00.
+ */
+#define IWL_CMD_QUEUE_NUM	4
+
 /* Power management (not Tx power) structures */
 
 enum iwl_pwr_src {
-- 
1.5.6.3

