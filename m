Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbZKMT4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:54 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/16] iwlwifi: add sleep_tx_count ucode station API
Date: Fri, 13 Nov 2009 11:56:36 -0800
Message-Id: <1258142198-3223-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This field was marked as reserved before since we didn't
use it, but is present in all released firmwares afaict.
We're going to need it soon, so add it now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 39e7244..a5f7916 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1818,6 +1818,7 @@ static u16 iwl4965_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 	addsta->add_immediate_ba_tid = cmd->add_immediate_ba_tid;
 	addsta->remove_immediate_ba_tid = cmd->remove_immediate_ba_tid;
 	addsta->add_immediate_ba_ssn = cmd->add_immediate_ba_ssn;
+	addsta->sleep_tx_count = cmd->sleep_tx_count;
 	addsta->reserved1 = cpu_to_le16(0);
 	addsta->reserved2 = cpu_to_le32(0);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 87a7f28..aa4e38c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1107,7 +1107,14 @@ struct iwl4965_addsta_cmd {
 	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
 	__le16 add_immediate_ba_ssn;
 
-	__le32 reserved2;
+	/*
+	 * Number of packets OK to transmit to station even though
+	 * it is asleep -- used to synchronise PS-poll and u-APSD
+	 * responses while ucode keeps track of STA sleep state.
+	 */
+	__le16 sleep_tx_count;
+
+	__le16 reserved2;
 } __attribute__ ((packed));
 
 /* 5000 */
@@ -1138,7 +1145,14 @@ struct iwl_addsta_cmd {
 	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
 	__le16 add_immediate_ba_ssn;
 
-	__le32 reserved2;
+	/*
+	 * Number of packets OK to transmit to station even though
+	 * it is asleep -- used to synchronise PS-poll and u-APSD
+	 * responses while ucode keeps track of STA sleep state.
+	 */
+	__le16 sleep_tx_count;
+
+	__le16 reserved2;
 } __attribute__ ((packed));
 
 
-- 
1.5.6.3

