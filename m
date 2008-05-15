Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYEOF4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 22/26] iwlwifi: iwl5000 WiFi/WiMax coexistence
Date: Thu, 15 May 2008 13:54:14 +0800
Message-Id: <1210830858-3410-23-git-send-email-yi.zhu@intel.com> (sfid-20080515_081615_330616_27B288B7)
In-Reply-To: <1210830858-3410-22-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-17-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-18-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-19-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-20-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-21-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-22-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds WiFi/WiMax coexistence to iwl5000.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   12 ++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   54 +++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5e818ee..520c7ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -494,6 +494,16 @@ static void iwl5000_tx_queue_set_status(struct iwl_priv *priv,
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
 
+static int iwl5000_send_wimax_coex(struct iwl_priv *priv)
+{
+	struct iwl_wimax_coex_cmd coex_cmd;
+
+	memset(&coex_cmd, 0, sizeof(coex_cmd));
+
+	return iwl_send_cmd_pdu(priv, COEX_PRIORITY_TABLE_CMD,
+				sizeof(coex_cmd), &coex_cmd);
+}
+
 static int iwl5000_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
@@ -568,6 +578,8 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	iwl5000_send_wimax_coex(priv);
+
 	/* Ask for statistics now, the uCode will send notification
 	 * periodically after association */
 	iwl_send_statistics_request(priv, CMD_ASYNC);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index dd84326..5b9e9bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -93,6 +93,11 @@ enum {
 	REPLY_LEDS_CMD = 0x48,
 	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* 4965 only */
 
+	/* WiMAX coexistence */
+	COEX_PRIORITY_TABLE_CMD = 0x5a,	/*5000 only */
+	COEX_MEDIUM_NOTIFICATION = 0x5b,
+	COEX_EVENT_CMD = 0x5c,
+
 	/* 802.11h related */
 	RADAR_NOTIFICATION = 0x70,	/* not used */
 	REPLY_QUIET_CMD = 0x71,		/* not used */
@@ -2797,6 +2802,55 @@ struct iwl4965_led_cmd {
 	u8 reserved;
 } __attribute__ ((packed));
 
+/*
+ * Coexistence WIFI/WIMAX  Command
+ * COEX_PRIORITY_TABLE_CMD = 0x5a
+ *
+ */
+enum {
+	COEX_UNASSOC_IDLE		= 0,
+	COEX_UNASSOC_MANUAL_SCAN	= 1,
+	COEX_UNASSOC_AUTO_SCAN		= 2,
+	COEX_CALIBRATION		= 3,
+	COEX_PERIODIC_CALIBRATION	= 4,
+	COEX_CONNECTION_ESTAB		= 5,
+	COEX_ASSOCIATED_IDLE		= 6,
+	COEX_ASSOC_MANUAL_SCAN		= 7,
+	COEX_ASSOC_AUTO_SCAN		= 8,
+	COEX_ASSOC_ACTIVE_LEVEL		= 9,
+	COEX_RF_ON			= 10,
+	COEX_RF_OFF			= 11,
+	COEX_STAND_ALONE_DEBUG		= 12,
+	COEX_IPAN_ASSOC_LEVEL		= 13,
+	COEX_RSRVD1			= 14,
+	COEX_RSRVD2			= 15,
+	COEX_NUM_OF_EVENTS		= 16
+};
+
+struct iwl_wimax_coex_event_entry {
+	u8 request_prio;
+	u8 win_medium_prio;
+	u8 reserved;
+	u8 flags;
+} __attribute__ ((packed));
+
+/* COEX flag masks */
+
+/* Staion table is valid */
+#define COEX_FLAGS_STA_TABLE_VALID_MSK      (0x1)
+/* UnMask wakeup src at unassociated sleep */
+#define COEX_FLAGS_UNASSOC_WA_UNMASK_MSK    (0x4)
+/* UnMask wakeup src at associated sleep */
+#define COEX_FLAGS_ASSOC_WA_UNMASK_MSK      (0x8)
+/* Enable CoEx feature. */
+#define COEX_FLAGS_COEX_ENABLE_MSK          (0x80)
+
+struct iwl_wimax_coex_cmd {
+	u8 flags;
+	u8 reserved[3];
+	struct iwl_wimax_coex_event_entry sta_prio[COEX_NUM_OF_EVENTS];
+} __attribute__ ((packed));
+
 /******************************************************************************
  * (13)
  * Union of all expected notifications/responses:
-- 
1.5.3.6

