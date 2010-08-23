Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0HWOxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/26] iwlagn: add additional bt related parameters
Date: Mon, 23 Aug 2010 07:57:11 -0700
Message-Id: <1282575437-23270-21-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add additional bt coex related parameters and initialize at init
time.
Thoese parameters will be used in later implementations.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 +++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7587508..60f9799 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4011,6 +4011,17 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	iwl_init_scan_params(priv);
 
+	/* init bt coex */
+	if (priv->cfg->advanced_bt_coexist) {
+		priv->kill_ack_mask = IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT;
+		priv->kill_cts_mask = IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT;
+		priv->bt_valid = IWL6000G2B_BT_ALL_VALID_MSK;
+		priv->bt_on_thresh = BT_ON_THRESHOLD_DEF;
+		priv->bt_duration = BT_DURATION_LIMIT_DEF;
+		priv->dynamic_frag_thresh = BT_FRAG_THRESHOLD_DEF;
+		priv->dynamic_agg_thresh = BT_AGG_THRESHOLD_DEF;
+	}
+
 	/* Set the tx_power_user_lmt to the lowest power level
 	 * this value will get overwritten by channel max power avg
 	 * from eeprom */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 7369c52..5df22f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2379,6 +2379,22 @@ struct iwl_link_quality_cmd {
 #define BT_MAX_KILL_DEF (0x5)
 #define BT_MAX_KILL_MAX (0xFF)
 
+#define BT_DURATION_LIMIT_DEF	625
+#define BT_DURATION_LIMIT_MAX	1250
+#define BT_DURATION_LIMIT_MIN	625
+
+#define BT_ON_THRESHOLD_DEF	4
+#define BT_ON_THRESHOLD_MAX	1000
+#define BT_ON_THRESHOLD_MIN	1
+
+#define BT_FRAG_THRESHOLD_DEF	0
+#define BT_FRAG_THRESHOLD_MAX	0
+#define BT_FRAG_THRESHOLD_MIN	0
+
+#define BT_AGG_THRESHOLD_DEF	0
+#define BT_AGG_THRESHOLD_MAX	0
+#define BT_AGG_THRESHOLD_MIN	0
+
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e0d524d..836fe27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1366,6 +1366,7 @@ struct iwl_priv {
 #endif
 	};
 
+	/* bt coex */
 	u8 bt_traffic_load, notif_bt_traffic_load;
 	bool bt_sco_active;
 	bool bt_full_concurrent;
@@ -1373,6 +1374,10 @@ struct iwl_priv {
 	__le32 kill_ack_mask;
 	__le32 kill_cts_mask;
 	__le16 bt_valid;
+	u16 bt_on_thresh;
+	u16 bt_duration;
+	u16 dynamic_frag_thresh;
+	u16 dynamic_agg_thresh;
 	u8 bt_ci_compliance;
 	struct work_struct bt_traffic_change_work;
 
-- 
1.7.0.4

