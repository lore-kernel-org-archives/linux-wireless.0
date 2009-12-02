Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315AbZLBUwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 15:52:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwl3945: remove duplicated event logging code
Date: Wed,  2 Dec 2009 12:52:59 -0800
Message-Id: <1259787181-21303-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1259787181-21303-1-git-send-email-reinette.chatre@intel.com>
References: <1259787181-21303-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In the process of improving uCode event logging capability, the new
implementation was introduced without removing the existing
implementation. The event log will be dumped to dmesg twice.
Remove the old implementation to only log the event once upon sys
assert or request by user.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0db9b79..a63bd5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1701,15 +1701,6 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log)
 	IWL_ERR(priv, "Start IWL Event Log Dump: display last %d count\n",
 		  size);
 
-	/* if uCode has wrapped back to top of log, start at the oldest entry,
-	 * i.e the next one that uCode would fill. */
-	if (num_wraps)
-		iwl3945_print_event_log(priv, next_entry,
-				    capacity - next_entry, mode);
-
-	/* (then/else) start at top of log */
-	iwl3945_print_event_log(priv, 0, next_entry, mode);
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
 		/* if uCode has wrapped back to top of log,
-- 
1.5.6.3

