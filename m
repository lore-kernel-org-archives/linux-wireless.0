Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab0AHSEp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:04:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/4] iwlwifi: remove obsoleted host command
Date: Fri,  8 Jan 2010 10:04:43 -0800
Message-Id: <1262973884-2551-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
References: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

"RADAR_NOTIFICATION" host command is not used and not supported by uCode,
remove it from driver code.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6bfc63f..3320cce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -120,7 +120,6 @@ enum {
 	CALIBRATION_COMPLETE_NOTIFICATION = 0x67,
 
 	/* 802.11h related */
-	RADAR_NOTIFICATION = 0x70,	/* not used */
 	REPLY_QUIET_CMD = 0x71,		/* not used */
 	REPLY_CHANNEL_SWITCH = 0x72,
 	CHANNEL_SWITCH_NOTIFICATION = 0x73,
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 30e9ea6..87d684e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -58,7 +58,6 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(COEX_PRIORITY_TABLE_CMD);
 		IWL_CMD(COEX_MEDIUM_NOTIFICATION);
 		IWL_CMD(COEX_EVENT_CMD);
-		IWL_CMD(RADAR_NOTIFICATION);
 		IWL_CMD(REPLY_QUIET_CMD);
 		IWL_CMD(REPLY_CHANNEL_SWITCH);
 		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
-- 
1.5.6.3

