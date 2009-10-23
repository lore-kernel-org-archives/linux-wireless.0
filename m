Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZJWUmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/18] iwlwifi: add missing commands to syslog messages
Date: Fri, 23 Oct 2009 13:42:19 -0700
Message-Id: <1256330556-20997-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

Two commands missing from list of commands such that when debug is
enabled, these commands are shown as UNKNOWN.

Missing commands are TX_ANT_CONFIGURATION_CMD and
TEMPERATURE_NOTIFICATION.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 7d4f131..1a7c0d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -114,6 +114,7 @@ enum {
 	COEX_EVENT_CMD = 0x5c,
 
 	/* Calibration */
+	TEMPERATURE_NOTIFICATION = 0x62,
 	CALIBRATION_CFG_CMD = 0x65,
 	CALIBRATION_RES_NOTIFICATION = 0x66,
 	CALIBRATION_COMPLETE_NOTIFICATION = 0x67,
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 22a21a1..f2a60dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -92,6 +92,8 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(CALIBRATION_RES_NOTIFICATION);
 		IWL_CMD(CALIBRATION_COMPLETE_NOTIFICATION);
 		IWL_CMD(REPLY_TX_POWER_DBM_CMD);
+		IWL_CMD(TEMPERATURE_NOTIFICATION);
+		IWL_CMD(TX_ANT_CONFIGURATION_CMD);
 	default:
 		return "UNKNOWN";
 
-- 
1.5.6.3

