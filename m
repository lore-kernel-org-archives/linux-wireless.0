Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab0HWOxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/26] iwlagn: wifi/bt coex configuration sequence
Date: Mon, 23 Aug 2010 07:57:05 -0700
Message-Id: <1282575437-23270-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

bt config command need to send before the init calibration command,
driver need to let uCode know that calibrations are being performed now
in order to assure antenna is not being taken to BT use during radio/dsp
reads/writes

Also, bt_coex_priorty_table command need to be send right after the
bt_config_command during init sequence. Followed by bt coex envelope
command to initialize and prepare uCode bt state machine

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   59 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    6 ++-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   59 +++++++++++++++++++-------
 4 files changed, 109 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a4601b5..101630b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -235,11 +235,10 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 	/*
 	 * Configure BT coex mode to "no coexistence" when the
 	 * user disabled BT coexistence, we have no interface
-	 * (might be in monitor mode), or the interface is in
+	 * user disabled BT coexistence, or the interface is in
 	 * IBSS mode (no proper uCode support for coex then).
 	 */
-	if (!bt_coex_active || !priv->vif ||
-	    priv->iw_mode == NL80211_IFTYPE_ADHOC) {
+	if (!bt_coex_active || priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		bt_cmd.flags = 0;
 	} else {
 		bt_cmd.flags = IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION |
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 6f77441..2dc569b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -329,6 +329,51 @@ static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
 				sizeof(coex_cmd), &coex_cmd);
 }
 
+static const u8 iwlagn_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
+	((BT_COEX_PRIO_TBL_PRIO_BYPASS << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(0 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_BYPASS << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(1 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_LOW << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(0 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_LOW << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(1 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_HIGH << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(0 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_HIGH << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(1 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_BYPASS << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(0 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_COEX_OFF << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(0 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	((BT_COEX_PRIO_TBL_PRIO_COEX_ON << IWL_BT_COEX_PRIO_TBL_PRIO_POS) |
+		(0 << IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS)),
+	0, 0, 0, 0, 0, 0, 0
+};
+
+static void iwlagn_send_prio_tbl(struct iwl_priv *priv)
+{
+	struct iwl_bt_coex_prio_table_cmd prio_tbl_cmd;
+
+	memcpy(prio_tbl_cmd.prio_tbl, iwlagn_bt_prio_tbl,
+		sizeof(iwlagn_bt_prio_tbl));
+	if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_PRIO_TABLE,
+				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
+		IWL_ERR(priv, "failed to send BT prio tbl command\n");
+}
+
+static void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
+{
+	struct iwl_bt_coex_prot_env_cmd env_cmd;
+
+	env_cmd.action = action;
+	env_cmd.type = type;
+	if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_PROT_ENV,
+			     sizeof(env_cmd), &env_cmd))
+		IWL_ERR(priv, "failed to send BT env command\n");
+}
+
+
 int iwlagn_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
@@ -416,6 +461,20 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	if (priv->cfg->advanced_bt_coexist) {
+		/* Configure Bluetooth device coexistence support */
+		/* need to perform this before any calibration */
+		priv->cfg->ops->hcmd->send_bt_config(priv);
+		if (bt_coex_active && priv->iw_mode != NL80211_IFTYPE_ADHOC) {
+			iwlagn_send_prio_tbl(priv);
+			iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
+				BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+			iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
+				BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+		}
+
+	}
+
 	iwlagn_send_wimax_coex(priv);
 
 	iwlagn_set_Xtal_calib(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 087f6c6..3686164 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2754,8 +2754,10 @@ static void iwl_alive_start(struct iwl_priv *priv)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv);
 	}
 
-	/* Configure Bluetooth device coexistence support */
-	priv->cfg->ops->hcmd->send_bt_config(priv);
+	if (!priv->cfg->advanced_bt_coexist) {
+		/* Configure Bluetooth device coexistence support */
+		priv->cfg->ops->hcmd->send_bt_config(priv);
+	}
 
 	iwl_reset_run_time_calib(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 67eaeb6..b45882a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -4078,34 +4078,63 @@ struct iwl_bt_coex_profile_notif {
 	u8 reserved;
 } __attribute__((packed));
 
-#define IWL_BT_COEX_PRIO_SHARED_ANTENNA		0x1
-#define IWL_BT_COEX_PRIO_PRIO_MASK		0xe
-#define IWL_BT_COEX_PRIO_PRIO_SHIFT		1
+#define IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_POS	0
+#define IWL_BT_COEX_PRIO_TBL_SHARED_ANTENNA_MSK	0x1
+#define IWL_BT_COEX_PRIO_TBL_PRIO_POS		1
+#define IWL_BT_COEX_PRIO_TBL_PRIO_MASK		0x0e
+#define IWL_BT_COEX_PRIO_TBL_RESERVED_POS	4
+#define IWL_BT_COEX_PRIO_TBL_RESERVED_MASK	0xf0
+#define IWL_BT_COEX_PRIO_TBL_PRIO_SHIFT		1
 
 /*
  * BT Coexistence Priority table
  * REPLY_BT_COEX_PRIO_TABLE = 0xcc
  */
+enum bt_coex_prio_table_events {
+	BT_COEX_PRIO_TBL_EVT_INIT_CALIB1 = 0,
+	BT_COEX_PRIO_TBL_EVT_INIT_CALIB2 = 1,
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW1 = 2,
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW2 = 3, /* DC calib */
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH1 = 4,
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH2 = 5,
+	BT_COEX_PRIO_TBL_EVT_DTIM = 6,
+	BT_COEX_PRIO_TBL_EVT_SCAN52 = 7,
+	BT_COEX_PRIO_TBL_EVT_SCAN24 = 8,
+	BT_COEX_PRIO_TBL_EVT_RESERVED0 = 9,
+	BT_COEX_PRIO_TBL_EVT_RESERVED1 = 10,
+	BT_COEX_PRIO_TBL_EVT_RESERVED2 = 11,
+	BT_COEX_PRIO_TBL_EVT_RESERVED3 = 12,
+	BT_COEX_PRIO_TBL_EVT_RESERVED4 = 13,
+	BT_COEX_PRIO_TBL_EVT_RESERVED5 = 14,
+	BT_COEX_PRIO_TBL_EVT_RESERVED6 = 15,
+	/* BT_COEX_PRIO_TBL_EVT_MAX should always be last */
+	BT_COEX_PRIO_TBL_EVT_MAX,
+};
+
+enum bt_coex_prio_table_priorities {
+	BT_COEX_PRIO_TBL_DISABLED = 0,
+	BT_COEX_PRIO_TBL_PRIO_LOW = 1,
+	BT_COEX_PRIO_TBL_PRIO_HIGH = 2,
+	BT_COEX_PRIO_TBL_PRIO_BYPASS = 3,
+	BT_COEX_PRIO_TBL_PRIO_COEX_OFF = 4,
+	BT_COEX_PRIO_TBL_PRIO_COEX_ON = 5,
+	BT_COEX_PRIO_TBL_PRIO_RSRVD1 = 6,
+	BT_COEX_PRIO_TBL_PRIO_RSRVD2 = 7,
+	BT_COEX_PRIO_TBL_MAX,
+};
+
 struct iwl_bt_coex_prio_table_cmd {
-	u8 init_calib_protection_cfg1,
-	   init_calib_protection_cfg2,
-	   init_calib_protection_lowprio_cfg1,
-	   init_calib_protection_lowprio_cfg2,
-	   init_calib_protection_highprio_cfg1,
-	   init_calib_protection_highprio_cfg2,
-	   dtim_protection_prio_cfg,
-	   scan_52_protection_cfg,
-	   scan_24_protection_cfg,
-	   bc_mc_protection_cfg;
-	u8 reserved[6];
+	u8 prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX];
 } __attribute__((packed));
 
+#define IWL_BT_COEX_ENV_CLOSE	0
+#define IWL_BT_COEX_ENV_OPEN	1
 /*
  * BT Protection Envelope
  * REPLY_BT_COEX_PROT_ENV = 0xcd
  */
 struct iwl_bt_coex_prot_env_cmd {
-	u8 open; /* 0 = closed, 1 = open */
+	u8 action; /* 0 = closed, 1 = open */
 	u8 type; /* 0 .. 15 */
 	u8 reserved[2];
 } __attribute__((packed));
-- 
1.7.0.4

