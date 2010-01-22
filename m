Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab0AVWXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/17] iwlwifi: bit field description for BT Config command
Date: Fri, 22 Jan 2010 14:22:50 -0800
Message-Id: <1264198978-5915-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Give better bit filed define and description for flag parameter
in REPLY_BT_CONFIG command:

flags:
 bit 0 - 1: BT channel announcement enabled
         0: disable
 bit 1 - 1: priority of BT device enabled
         0: disable
 bit 2 - 1: BT 2 wire support enabled
         0: disable

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   15 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8823d18..ce53894 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2247,10 +2247,19 @@ struct iwl_link_quality_cmd {
 	__le32 reserved2;
 } __attribute__ ((packed));
 
+/*
+ * BT configuration enable flags:
+ *   bit 0 - 1: BT channel announcement enabled
+ *           0: disable
+ *   bit 1 - 1: priority of BT device enabled
+ *           0: disable
+ *   bit 2 - 1: BT 2 wire support enabled
+ *           0: disable
+ */
 #define BT_COEX_DISABLE (0x0)
-#define BT_COEX_MODE_2W (0x1)
-#define BT_COEX_MODE_3W (0x2)
-#define BT_COEX_MODE_4W (0x3)
+#define BT_ENABLE_CHANNEL_ANNOUNCE BIT(0)
+#define BT_ENABLE_PRIORITY	   BIT(1)
+#define BT_ENABLE_2_WIRE	   BIT(2)
 
 #define BT_LEAD_TIME_MIN (0x0)
 #define BT_LEAD_TIME_DEF (0x1E)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 645bc13..d625aa8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1977,7 +1977,7 @@ EXPORT_SYMBOL(iwl_isr_legacy);
 int iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
-		.flags = BT_COEX_MODE_4W,
+		.flags = BT_ENABLE_CHANNEL_ANNOUNCE | BT_ENABLE_PRIORITY,
 		.lead_time = BT_LEAD_TIME_DEF,
 		.max_kill = BT_MAX_KILL_DEF,
 		.kill_ack_mask = 0,
-- 
1.6.3.3

