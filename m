Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab1BHIcQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:32:16 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/5] iwlwifi: avoid too frequent recover from statistics
Date: Tue,  8 Feb 2011 09:31:59 +0100
Message-Id: <1297153919-18766-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Usually H/W generate statistics notify once per about 100ms, but
sometimes we can receive notify in shorter time, even 2 ms.

This can be problem for plcp health and ack health checking.

I.e. with 2 plcp errors happens randomly in 2 ms duration, we
exceed plcp delta threshold equal to 100 (2*100/2).

Also checking ack's in short time, can results not necessary false
positive and firmware reset, for example when channel is noised and
we do not receive ACKs frames or when remote device does not send
ACKs at the moment.

Patch change code, to do statistic check and possible recovery only
if 99ms elapsed from last check. Forced delay should assure we have
good statistic data to estimate hardware state.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   24 ++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |   46 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 8 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f371d42..9646cbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -409,11 +409,9 @@ static void iwl3945_accumulative_statistics(struct iwl_priv *priv,
  * to improve the throughput.
  */
 static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
+				struct iwl_rx_packet *pkt, unsigned int msecs)
 {
 	__le32 cur_plcp_err, old_plcp_err;
-	unsigned int msecs;
-	unsigned long stamp;
 	int delta;
 	int threshold = priv->cfg->base_params->plcp_delta_threshold;
 
@@ -422,12 +420,7 @@ static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
 		return true;
 	}
 
-	stamp = jiffies;
-	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
-	priv->plcp_jiffies = stamp;
-
-	if (msecs == 0)
-		return true;
+	BUG_ON(msecs == 0);
 
 	old_plcp_err = priv->_3945.statistics.rx.ofdm.plcp_err;
 	cur_plcp_err = pkt->u.stats_39.rx.ofdm.plcp_err;
@@ -450,6 +443,8 @@ static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
 void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 		struct iwl_rx_mem_buffer *rxb)
 {
+	unsigned long stamp;
+	unsigned int msecs;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
@@ -458,8 +453,17 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl3945_accumulative_statistics(priv, (__le32 *)&pkt->u.raw);
 #endif
-	iwl_recover_from_statistics(priv, pkt);
 
+	stamp = jiffies;
+	msecs = jiffies_to_msecs(stamp - priv->rx_statistics_jiffies);
+
+	/* Do not check/recover when do not have enough statistics data */
+	if (msecs < 99)
+		return;
+
+	priv->rx_statistics_jiffies = stamp;
+
+	iwl_recover_from_statistics(priv, pkt, msecs);
 	memcpy(&priv->_3945.statistics, pkt->u.raw, sizeof(priv->_3945.statistics));
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 5539fcb..245d909 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -175,10 +175,9 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
  * When numbers of the plcp errors is exceeding the thresholds,
  * reset the radio to improve the throughput.
  */
-bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
+bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt,
+			  unsigned int msecs)
 {
-	unsigned int msecs;
-	unsigned long stamp;
 	int delta;
 	int threshold = priv->cfg->base_params->plcp_delta_threshold;
 
@@ -187,12 +186,7 @@ bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
 		return true;
 	}
 
-	stamp = jiffies;
-	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
-	priv->plcp_jiffies = stamp;
-
-	if (msecs == 0)
-		return true;
+	BUG_ON(msecs == 0);
 
 	if (iwl_bt_statistics(priv)) {
 		struct statistics_rx_bt *cur, *old;
@@ -230,6 +224,31 @@ bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
 	return true;
 }
 
+static void iwlagn_check_health(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt)
+{
+	unsigned int msecs;
+	unsigned long stamp;
+
+	stamp = jiffies;
+	msecs = jiffies_to_msecs(stamp - priv->rx_statistics_jiffies);
+
+	/* Do not check/recover when do not have enough statistics data */
+	if (msecs < 99)
+		return;
+
+	priv->rx_statistics_jiffies = stamp;
+
+	iwl_recover_from_statistics(priv, pkt, msecs);
+
+	if (iwl_bt_statistics(priv))
+		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
+		       sizeof(priv->_agn.statistics_bt));
+	else
+		memcpy(&priv->_agn.statistics, &pkt->u.stats,
+		       sizeof(priv->_agn.statistics));
+}
+
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
@@ -272,14 +291,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 
 	}
 
-	iwl_recover_from_statistics(priv, pkt);
-
-	if (iwl_bt_statistics(priv))
-		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
-			sizeof(priv->_agn.statistics_bt));
-	else
-		memcpy(&priv->_agn.statistics, &pkt->u.stats,
-			sizeof(priv->_agn.statistics));
+	iwlagn_check_health(priv, pkt);
 
 	set_bit(STATUS_STATISTICS, &priv->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6dd5001..eb639dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3964,6 +3964,8 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->force_reset[IWL_FW_RESET].reset_duration =
 		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
+	priv->rx_statistics_jiffies = jiffies;
+
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d00e1ea..490c6d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -249,7 +249,7 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 bool iwl_good_plcp_health(struct iwl_priv *priv,
-			  struct iwl_rx_packet *pkt);
+			  struct iwl_rx_packet *pkt, unsigned int msecs);
 void iwl_rx_statistics(struct iwl_priv *priv,
 		       struct iwl_rx_mem_buffer *rxb);
 void iwl_reply_statistics(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e0ec170..6e14a7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -212,7 +212,7 @@ struct iwl_lib_ops {
 	struct iwl_temp_ops temp_ops;
 	/* check for plcp health */
 	bool (*check_plcp_health)(struct iwl_priv *priv,
-					struct iwl_rx_packet *pkt);
+				  struct iwl_rx_packet *pkt, unsigned int msec);
 	/* check for ack health */
 	bool (*check_ack_health)(struct iwl_priv *priv,
 					struct iwl_rx_packet *pkt);
@@ -518,7 +518,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb);
 void iwl_recover_from_statistics(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt);
+				struct iwl_rx_packet *pkt, unsigned int msecs);
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ecfbef4..17b3024 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1256,8 +1256,8 @@ struct iwl_priv {
 	/* track IBSS manager (last beacon) status */
 	u32 ibss_manager;
 
-	/* storing the jiffies when the plcp error rate is received */
-	unsigned long plcp_jiffies;
+	/* jiffies when last recovery from statistics was performed */
+	unsigned long rx_statistics_jiffies;
 
 	/* force reset */
 	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index bc89393..b9c2591 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -232,7 +232,7 @@ void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_rx_spectrum_measure_notif);
 
 void iwl_recover_from_statistics(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
+				struct iwl_rx_packet *pkt, unsigned int msecs)
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    !iwl_is_any_associated(priv))
@@ -246,7 +246,7 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 	}
 
 	if (priv->cfg->ops->lib->check_plcp_health &&
-	    !priv->cfg->ops->lib->check_plcp_health(priv, pkt))
+	    !priv->cfg->ops->lib->check_plcp_health(priv, pkt, msecs))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
 }
 EXPORT_SYMBOL(iwl_recover_from_statistics);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 76fae81..f13cc11 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3863,6 +3863,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->force_reset[IWL_FW_RESET].reset_duration =
 		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
+	priv->rx_statistics_jiffies = jiffies;
 
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
 	priv->tx_power_next = IWL_DEFAULT_TX_POWER;
-- 
1.7.1

