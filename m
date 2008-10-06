Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYJFIMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:12:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/7] iwlwifi: refactor rxon time command
Date: Mon,  6 Oct 2008 16:05:33 +0800
Message-Id: <1223280333-4383-8-git-send-email-yi.zhu@intel.com> (sfid-20081006_101214_410609_8851C05D)
In-Reply-To: <1223280333-4383-7-git-send-email-yi.zhu@intel.com>
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-2-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-4-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-5-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-6-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch refactors rxon time command.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   70 ++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   11 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +-
 3 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 24a1aeb..d6100e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -637,23 +637,22 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 
 #define MAX_UCODE_BEACON_INTERVAL	4096
 
-static __le16 iwl4965_adjust_beacon_interval(u16 beacon_val)
+static u16 iwl_adjust_beacon_interval(u16 beacon_val)
 {
 	u16 new_val = 0;
 	u16 beacon_factor = 0;
 
-	beacon_factor =
-	    (beacon_val + MAX_UCODE_BEACON_INTERVAL)
-		/ MAX_UCODE_BEACON_INTERVAL;
+	beacon_factor = (beacon_val + MAX_UCODE_BEACON_INTERVAL)
+					/ MAX_UCODE_BEACON_INTERVAL;
 	new_val = beacon_val / beacon_factor;
 
-	return cpu_to_le16(new_val);
+	return new_val;
 }
 
-static void iwl4965_setup_rxon_timing(struct iwl_priv *priv)
+static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 {
-	u64 interval_tm_unit;
-	u64 tsf, result;
+	u64 tsf;
+	s32 interval_tm, rem;
 	unsigned long flags;
 	struct ieee80211_conf *conf = NULL;
 	u16 beacon_int = 0;
@@ -661,49 +660,32 @@ static void iwl4965_setup_rxon_timing(struct iwl_priv *priv)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->rxon_timing.timestamp.dw[1] = cpu_to_le32(priv->timestamp >> 32);
-	priv->rxon_timing.timestamp.dw[0] =
-				cpu_to_le32(priv->timestamp & 0xFFFFFFFF);
-
+	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
 	priv->rxon_timing.listen_interval = cpu_to_le16(conf->listen_interval);
 
-	tsf = priv->timestamp;
-
-	beacon_int = priv->beacon_int;
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
-		if (beacon_int == 0) {
-			priv->rxon_timing.beacon_interval = cpu_to_le16(100);
-			priv->rxon_timing.beacon_init_val = cpu_to_le32(102400);
-		} else {
-			priv->rxon_timing.beacon_interval =
-				cpu_to_le16(beacon_int);
-			priv->rxon_timing.beacon_interval =
-			    iwl4965_adjust_beacon_interval(
-				le16_to_cpu(priv->rxon_timing.beacon_interval));
-		}
-
+		beacon_int = iwl_adjust_beacon_interval(priv->beacon_int);
 		priv->rxon_timing.atim_window = 0;
 	} else {
-		priv->rxon_timing.beacon_interval =
-			iwl4965_adjust_beacon_interval(conf->beacon_int);
+		beacon_int = iwl_adjust_beacon_interval(conf->beacon_int);
+
 		/* TODO: we need to get atim_window from upper stack
 		 * for now we set to 0 */
 		priv->rxon_timing.atim_window = 0;
 	}
 
-	interval_tm_unit =
-		(le16_to_cpu(priv->rxon_timing.beacon_interval) * 1024);
-	result = do_div(tsf, interval_tm_unit);
-	priv->rxon_timing.beacon_init_val =
-	    cpu_to_le32((u32) ((u64) interval_tm_unit - result));
+	priv->rxon_timing.beacon_interval = cpu_to_le16(beacon_int);
 
-	IWL_DEBUG_ASSOC
-	    ("beacon interval %d beacon timer %d beacon tim %d\n",
-		le16_to_cpu(priv->rxon_timing.beacon_interval),
-		le32_to_cpu(priv->rxon_timing.beacon_init_val),
-		le16_to_cpu(priv->rxon_timing.atim_window));
+	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
+	interval_tm = beacon_int * 1024;
+	rem = do_div(tsf, interval_tm);
+	priv->rxon_timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+	IWL_DEBUG_ASSOC("beacon interval %d beacon timer %d beacon tim %d\n",
+			le16_to_cpu(priv->rxon_timing.beacon_interval),
+			le32_to_cpu(priv->rxon_timing.beacon_init_val),
+			le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
 static void iwl_set_flags_for_band(struct iwl_priv *priv,
@@ -2494,8 +2476,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl4965_commit_rxon(priv);
 
-	memset(&priv->rxon_timing, 0, sizeof(struct iwl4965_rxon_time_cmd));
-	iwl4965_setup_rxon_timing(priv);
+	iwl_setup_rxon_timing(priv);
 	ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (ret)
@@ -2886,15 +2867,14 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 		return;
 
 	/* The following should be done only at AP bring up */
-	if (!(iwl_is_associated(priv))) {
+	if (!iwl_is_associated(priv)) {
 
 		/* RXON - unassoc (to set timing command) */
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
 
 		/* RXON Timing */
-		memset(&priv->rxon_timing, 0, sizeof(struct iwl4965_rxon_time_cmd));
-		iwl4965_setup_rxon_timing(priv);
+		iwl_setup_rxon_timing(priv);
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				sizeof(priv->rxon_timing), &priv->rxon_timing);
 		if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index fc467c5..ba54613 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -482,11 +482,6 @@ struct iwl_alive_resp {
 } __attribute__ ((packed));
 
 
-union tsf {
-	u8 byte[8];
-	__le16 word[4];
-	__le32 dw[2];
-};
 
 /*
  * REPLY_ERROR = 0x2 (response only, not a command)
@@ -497,7 +492,7 @@ struct iwl_error_resp {
 	u8 reserved1;
 	__le16 bad_cmd_seq_num;
 	__le32 error_info;
-	union tsf timestamp;
+	__le64 timestamp;
 } __attribute__ ((packed));
 
 /******************************************************************************
@@ -684,8 +679,8 @@ struct iwl4965_rxon_assoc_cmd {
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
  */
-struct iwl4965_rxon_time_cmd {
-	union tsf timestamp;
+struct iwl_rxon_time_cmd {
+	__le64 timestamp;
 	__le16 beacon_interval;
 	__le16 atim_window;
 	__le32 beacon_init_val;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2125844..34306b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -275,7 +275,6 @@ struct iwl_cmd {
 		u16 val16;
 		u32 val32;
 		struct iwl4965_bt_cmd bt;
-		struct iwl4965_rxon_time_cmd rxon_time;
 		struct iwl_powertable_cmd powertable;
 		struct iwl_qosparam_cmd qosparam;
 		struct iwl_tx_cmd tx;
@@ -851,7 +850,7 @@ struct iwl_priv {
 	u8 ucode_write_complete;	/* the image write is complete */
 
 
-	struct iwl4965_rxon_time_cmd rxon_timing;
+	struct iwl_rxon_time_cmd rxon_timing;
 
 	/* We declare this const so it can only be
 	 * changed via explicit cast within the
-- 
1.5.3.6

