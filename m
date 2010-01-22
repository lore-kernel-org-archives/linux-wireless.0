Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0AVWXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/17] iwlwifi: module parameter to enable/disable bt co-exist
Date: Fri, 22 Jan 2010 14:22:51 -0800
Message-Id: <1264198978-5915-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding "bt_coex_active" module parameter for iwlcore to enable/disable
BT coexist; if bt_coex_active is true (default), uCode will do kill/defer
every time the priority line is asserted (BT is sending signals on the
priority line in the PCIx). By disable the bt_coex_active, uCode will
ignore the BT activity and perform the normal operation.

Users might experience transmit issue on some platform due to this
WiFi/BT co-exist problem. The possible symptoms are: NetworkManager and
other similar programs can scan and find all the available APs, but will
timeout and unable to associate with any of the APs; no out-going frames
can be found with wireless sniffer tools.

On those platforms, WiFi communication can be restored by set "bt_coex_active"
module parameter to "false"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   29 ++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index ce53894..c2f31eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2261,6 +2261,9 @@ struct iwl_link_quality_cmd {
 #define BT_ENABLE_PRIORITY	   BIT(1)
 #define BT_ENABLE_2_WIRE	   BIT(2)
 
+#define BT_COEX_DISABLE (0x0)
+#define BT_COEX_ENABLE  (BT_ENABLE_CHANNEL_ANNOUNCE | BT_ENABLE_PRIORITY)
+
 #define BT_LEAD_TIME_MIN (0x0)
 #define BT_LEAD_TIME_DEF (0x1E)
 #define BT_LEAD_TIME_MAX (0xFF)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d625aa8..1cfabd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -47,6 +47,26 @@ MODULE_VERSION(IWLWIFI_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
+/*
+ * set bt_coex_active to true, uCode will do kill/defer
+ * every time the priority line is asserted (BT is sending signals on the
+ * priority line in the PCIx).
+ * set bt_coex_active to false, uCode will ignore the BT activity and
+ * perform the normal operation
+ *
+ * User might experience transmit issue on some platform due to WiFi/BT
+ * co-exist problem. The possible behaviors are:
+ *   Able to scan and finding all the available AP
+ *   Not able to associate with any AP
+ * On those platforms, WiFi communication can be restored by set
+ * "bt_coex_active" module parameter to "false"
+ *
+ * default: bt_coex_active = true (BT_COEX_ENABLE)
+ */
+static bool bt_coex_active = true;
+module_param(bt_coex_active, bool, S_IRUGO);
+MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist\n");
+
 static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
 	 0, COEX_UNASSOC_IDLE_FLAGS},
@@ -1977,13 +1997,20 @@ EXPORT_SYMBOL(iwl_isr_legacy);
 int iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
-		.flags = BT_ENABLE_CHANNEL_ANNOUNCE | BT_ENABLE_PRIORITY,
 		.lead_time = BT_LEAD_TIME_DEF,
 		.max_kill = BT_MAX_KILL_DEF,
 		.kill_ack_mask = 0,
 		.kill_cts_mask = 0,
 	};
 
+	if (!bt_coex_active)
+		bt_cmd.flags = BT_COEX_DISABLE;
+	else
+		bt_cmd.flags = BT_COEX_ENABLE;
+
+	IWL_DEBUG_INFO(priv, "BT coex %s\n",
+		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
+
 	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 				sizeof(struct iwl_bt_cmd), &bt_cmd);
 }
-- 
1.6.3.3

