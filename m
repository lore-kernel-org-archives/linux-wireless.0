Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1DERBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/25] iwlagn: clean up alive handling
Date: Tue,  5 Apr 2011 09:42:04 -0700
Message-Id: <1302021732-21250-18-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Devices newer than 4965 don't actually send
two different versions of the ALIVE command,
so we always had a bug here since before this
patch we copy more data than we got. Remove
the iwl_init_alive_resp struct and don't use
it.

Since we also really don't need to track all
the data received in ALIVE as we only use the
error and log event tables later, we can also
save space by just keeping those and not more
data around in memory.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   16 ++-------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   48 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   10 +++---
 4 files changed, 13 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7ff95ee..f0d88ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -588,10 +588,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 	u32 num_wraps;  /* # times uCode wrapped to top of log */
 	u32 next_entry; /* index of next entry to be written by uCode */
 
-	if (priv->ucode_type == UCODE_INIT)
-		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
-	else
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
+	base = priv->device_pointers.error_event_table;
 	if (priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
 		capacity = iwl_read_targ_mem(priv, base);
 		num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
@@ -1869,12 +1866,11 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	u32 blink1, blink2, ilink1, ilink2;
 	u32 pc, hcmd;
 
+	base = priv->device_pointers.error_event_table;
 	if (priv->ucode_type == UCODE_INIT) {
-		base = le32_to_cpu(priv->card_alive_init.error_event_table_ptr);
 		if (!base)
 			base = priv->_agn.init_errlog_ptr;
 	} else {
-		base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 		if (!base)
 			base = priv->_agn.inst_errlog_ptr;
 	}
@@ -1939,12 +1935,11 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	if (num_events == 0)
 		return pos;
 
+	base = priv->device_pointers.log_event_table;
 	if (priv->ucode_type == UCODE_INIT) {
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
 		if (!base)
 			base = priv->_agn.init_evtlog_ptr;
 	} else {
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 		if (!base)
 			base = priv->_agn.inst_evtlog_ptr;
 	}
@@ -2053,13 +2048,12 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	int pos = 0;
 	size_t bufsz = 0;
 
+	base = priv->device_pointers.log_event_table;
 	if (priv->ucode_type == UCODE_INIT) {
-		base = le32_to_cpu(priv->card_alive_init.log_event_table_ptr);
 		logsize = priv->_agn.init_evtlog_size;
 		if (!base)
 			base = priv->_agn.init_evtlog_ptr;
 	} else {
-		base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 		logsize = priv->_agn.inst_evtlog_size;
 		if (!base)
 			base = priv->_agn.inst_evtlog_ptr;
@@ -2416,8 +2410,6 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_apm_stop(priv);
 
  exit:
-	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
-
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index a2348ee..a1a5c1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -388,54 +388,6 @@ struct iwl_tx_ant_config_cmd {
 #define UCODE_VALID_OK	cpu_to_le32(0x1)
 #define INITIALIZE_SUBTYPE    (9)
 
-/*
- * ("Initialize") REPLY_ALIVE = 0x1 (response only, not a command)
- *
- * uCode issues this "initialize alive" notification once the initialization
- * uCode image has completed its work, and is ready to load the runtime image.
- * This is the *first* "alive" notification that the driver will receive after
- * rebooting uCode; the "initialize" alive is indicated by subtype field == 9.
- *
- * See comments documenting "BSM" (bootstrap state machine).
- *
- * For 4965, this notification contains important calibration data for
- * calculating txpower settings:
- *
- * 1)  Power supply voltage indication.  The voltage sensor outputs higher
- *     values for lower voltage, and vice verse.
- *
- * 2)  Temperature measurement parameters, for each of two channel widths
- *     (20 MHz and 40 MHz) supported by the radios.  Temperature sensing
- *     is done via one of the receiver chains, and channel width influences
- *     the results.
- *
- * 3)  Tx gain compensation to balance 4965's 2 Tx chains for MIMO operation,
- *     for each of 5 frequency ranges.
- */
-struct iwl_init_alive_resp {
-	u8 ucode_minor;
-	u8 ucode_major;
-	__le16 reserved1;
-	u8 sw_rev[8];
-	u8 ver_type;
-	u8 ver_subtype;		/* "9" for initialize alive */
-	__le16 reserved2;
-	__le32 log_event_table_ptr;
-	__le32 error_event_table_ptr;
-	__le32 timestamp;
-	__le32 is_valid;
-
-	/* calibration values from "initialize" uCode */
-	__le32 voltage;		/* signed, higher value is lower voltage */
-	__le32 therm_r1[2];	/* signed, 1st for normal, 2nd for HT40 */
-	__le32 therm_r2[2];	/* signed */
-	__le32 therm_r3[2];	/* signed */
-	__le32 therm_r4[2];	/* signed */
-	__le32 tx_atten[5][2];	/* signed MIMO gain comp, 5 freq groups,
-				 * 2 Tx chains */
-} __packed;
-
-
 /**
  * REPLY_ALIVE = 0x1 (response only, not a command)
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f69b9e6..fe096fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1285,10 +1285,10 @@ struct iwl_priv {
 
 	struct iwl_switch_rxon switch_rxon;
 
-	/* 1st responses from initialize and runtime uCode images.
-	 * _agn's initialize alive response contains some calibration data. */
-	struct iwl_init_alive_resp card_alive_init;
-	struct iwl_alive_resp card_alive;
+	struct {
+		u32 error_event_table;
+		u32 log_event_table;
+	} device_pointers;
 
 	u16 active_rate;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 984a42c..b5124de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -239,16 +239,16 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
+	priv->device_pointers.log_event_table =
+		le32_to_cpu(palive->log_event_table_ptr);
+	priv->device_pointers.error_event_table =
+		le32_to_cpu(palive->error_event_table_ptr);
+
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
 		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
-		memcpy(&priv->card_alive_init,
-		       &pkt->u.alive_frame,
-		       sizeof(struct iwl_init_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
 		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
-		memcpy(&priv->card_alive, &pkt->u.alive_frame,
-		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->alive_start;
 	}
 
-- 
1.7.0.4

