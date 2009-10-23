Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZJWUmf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:35 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/18] iwlwifi: update bt co-exit configuration parameter
Date: Fri, 23 Oct 2009 13:42:23 -0700
Message-Id: <1256330556-20997-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding parameter ranges for bt co-exist configuration command.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 +++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 1a7c0d0..0d660a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2218,6 +2218,19 @@ struct iwl_link_quality_cmd {
 	__le32 reserved2;
 } __attribute__ ((packed));
 
+#define BT_COEX_DISABLE (0x0)
+#define BT_COEX_MODE_2W (0x1)
+#define BT_COEX_MODE_3W (0x2)
+#define BT_COEX_MODE_4W (0x3)
+
+#define BT_LEAD_TIME_MIN (0x0)
+#define BT_LEAD_TIME_DEF (0x1E)
+#define BT_LEAD_TIME_MAX (0xFF)
+
+#define BT_MAX_KILL_MIN (0x1)
+#define BT_MAX_KILL_DEF (0x5)
+#define BT_MAX_KILL_MAX (0xFF)
+
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1d7248c..77b9825 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2003,9 +2003,9 @@ EXPORT_SYMBOL(iwl_isr_legacy);
 int iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
-		.flags = 3,
-		.lead_time = 0xAA,
-		.max_kill = 1,
+		.flags = BT_COEX_MODE_4W,
+		.lead_time = BT_LEAD_TIME_DEF,
+		.max_kill = BT_MAX_KILL_DEF,
 		.kill_ack_mask = 0,
 		.kill_cts_mask = 0,
 	};
-- 
1.5.6.3

