Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab1A1PsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 10:48:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 8/8] iwlwifi: introduce iwl_bt_statistics
Date: Fri, 28 Jan 2011 16:47:51 +0100
Message-Id: <1296229671-3041-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics
conditional in few places, merge it into one function.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |    9 +++------
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   12 ++++--------
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |   15 +++++----------
 drivers/net/wireless/iwlwifi/iwl-agn.c         |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.h        |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    2 +-
 6 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index d16bb5e..9006293 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -631,8 +631,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		rx_info = &(((struct iwl_bt_notif_statistics *)resp)->
 			      rx.general.common);
 		ofdm = &(((struct iwl_bt_notif_statistics *)resp)->rx.ofdm);
@@ -897,8 +896,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		rx_info = &(((struct iwl_bt_notif_statistics *)stat_resp)->
 			      rx.general.common);
 	} else {
@@ -913,8 +911,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 
 	rxon_band24 = !!(ctx->staging.flags & RXON_FLG_BAND_24G_MSK);
 	rxon_chnum = le16_to_cpu(ctx->staging.channel);
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		stat_band24 = !!(((struct iwl_bt_notif_statistics *)
 				 stat_resp)->flag &
 				 STATISTICS_REPLY_FLG_BAND_24G_MSK);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index a6dbd89..b500aaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -39,8 +39,7 @@ static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
 	int p = 0;
 	u32 flag;
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics)
+	if (iwl_bt_statistics(priv))
 		flag = le32_to_cpu(priv->_agn.statistics_bt.flag);
 	else
 		flag = le32_to_cpu(priv->_agn.statistics.flag);
@@ -89,8 +88,7 @@ ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		ofdm = &priv->_agn.statistics_bt.rx.ofdm;
 		cck = &priv->_agn.statistics_bt.rx.cck;
 		general = &priv->_agn.statistics_bt.rx.general.common;
@@ -536,8 +534,7 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		tx = &priv->_agn.statistics_bt.tx;
 		accum_tx = &priv->_agn.accum_statistics_bt.tx;
 		delta_tx = &priv->_agn.delta_statistics_bt.tx;
@@ -737,8 +734,7 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		general = &priv->_agn.statistics_bt.general.common;
 		dbg = &priv->_agn.statistics_bt.general.common.dbg;
 		div = &priv->_agn.statistics_bt.general.common.div;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index bbd40b7..b192ca8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -73,8 +73,7 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 	int bcn_silence_a, bcn_silence_b, bcn_silence_c;
 	int last_rx_noise;
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics)
+	if (iwl_bt_statistics(priv))
 		rx_info = &(priv->_agn.statistics_bt.rx.general.common);
 	else
 		rx_info = &(priv->_agn.statistics.rx.general);
@@ -125,8 +124,7 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	struct statistics_general_common *general, *accum_general;
 	struct statistics_tx *tx, *accum_tx;
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		prev_stats = (__le32 *)&priv->_agn.statistics_bt;
 		accum_stats = (u32 *)&priv->_agn.accum_statistics_bt;
 		size = sizeof(struct iwl_bt_notif_statistics);
@@ -207,8 +205,7 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 		struct statistics_rx_phy *ofdm;
 		struct statistics_rx_ht_phy *ofdm_ht;
 
-		if (priv->cfg->bt_params &&
-		    priv->cfg->bt_params->bt_statistics) {
+		if (iwl_bt_statistics(priv)) {
 			ofdm = &pkt->u.stats_bt.rx.ofdm;
 			ofdm_ht = &pkt->u.stats_bt.rx.ofdm_ht;
 			combined_plcp_delta =
@@ -265,8 +262,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	int change;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics) {
+	if (iwl_bt_statistics(priv)) {
 		IWL_DEBUG_RX(priv,
 			     "Statistics notification received (%d vs %d).\n",
 			     (int)sizeof(struct iwl_bt_notif_statistics),
@@ -304,8 +300,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 
 	iwl_recover_from_statistics(priv, pkt);
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->bt_statistics)
+	if (iwl_bt_statistics(priv))
 		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
 			sizeof(priv->_agn.statistics_bt));
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 23bf006..9b5c3f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3075,8 +3075,7 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	}
 
 	if (priv->start_calib) {
-		if (priv->cfg->bt_params &&
-		    priv->cfg->bt_params->bt_statistics) {
+		if (iwl_bt_statistics(priv)) {
 			iwl_chain_noise_calibration(priv,
 					(void *)&priv->_agn.statistics_bt);
 			iwl_sensitivity_calibration(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 705711a..c83fcc6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -747,6 +747,11 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 	       priv->cfg->bt_params->advanced_bt_coexist;
 }
 
+static inline bool iwl_bt_statistics(struct iwl_priv *priv)
+{
+	return priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics;
+}
+
 extern bool bt_coex_active;
 extern bool bt_siso_mode;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index bde16ac..bdcb742 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1765,7 +1765,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
 	if (priv->cfg->base_params->ucode_tracing)
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
-	if (priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics)
+	if (iwl_bt_statistics(priv))
 		DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
-- 
1.7.1

