Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXI0Deq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: replacing IPW with IWL in error messages
Date: Thu, 27 Sep 2007 11:27:30 +0800
Message-Id: <11908636662994-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636643693-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch repaces IPW with IWL in error messages.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 44f983b..c271418 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -204,7 +204,7 @@ static void iwl_print_hex_dump(int level, void *p, u32 len)
  * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
  * Tx queue resumed.
  *
- * The IPW operates with six queues, one receive queue in the device's
+ * The IWL operates with six queues, one receive queue in the device's
  * sram, one transmit queue for sending commands to the device firmware,
  * and four transmit queues for data.
  ***************************************************/
@@ -4591,12 +4591,12 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 
 	/* bail out if nothing in log */
 	if (size == 0) {
-		IWL_ERROR("Start IPW Event Log Dump: nothing in log\n");
+		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
 		iwl_release_restricted_access(priv);
 		return;
 	}
 
-	IWL_ERROR("Start IPW Event Log Dump: display count %d, wraps %d\n",
+	IWL_ERROR("Start IWL Event Log Dump: display count %d, wraps %d\n",
 		  size, num_wraps);
 
 	/* if uCode has wrapped back to top of log, start at the oldest entry,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 61500a2..9ad68b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -203,7 +203,7 @@ static void iwl_print_hex_dump(int level, void *p, u32 len)
  * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
  * Tx queue resumed.
  *
- * The IPW operates with six queues, one receive queue in the device's
+ * The IWL operates with six queues, one receive queue in the device's
  * sram, one transmit queue for sending commands to the device firmware,
  * and four transmit queues for data.
  ***************************************************/
@@ -4900,12 +4900,12 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 
 	/* bail out if nothing in log */
 	if (size == 0) {
-		IWL_ERROR("Start IPW Event Log Dump: nothing in log\n");
+		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
 		iwl_release_restricted_access(priv);
 		return;
 	}
 
-	IWL_ERROR("Start IPW Event Log Dump: display count %d, wraps %d\n",
+	IWL_ERROR("Start IWL Event Log Dump: display count %d, wraps %d\n",
 		  size, num_wraps);
 
 	/* if uCode has wrapped back to top of log, start at the oldest entry,
-- 
1.5.1
