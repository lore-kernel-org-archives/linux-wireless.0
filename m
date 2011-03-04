Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759879Ab1CDQwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 11:52:08 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/3] iwlwifi: avoid too frequent recover from statistics
Date: Fri,  4 Mar 2011 17:51:51 +0100
Message-Id: <1299257511-5241-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
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

Patch change code to do statistic check and possible recovery only
if 99ms elapsed from last check. Forced delay should assure we have
good statistic data to estimate hardware state.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   46 ++++++++++++++++++--------------
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6b6f2d8..19bb567 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3737,6 +3737,8 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->force_reset[IWL_FW_RESET].reset_duration =
 		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
+	priv->rx_statistics_jiffies = jiffies;
+
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 58165c7..6a41deb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1261,8 +1261,8 @@ struct iwl_priv {
 	/* track IBSS manager (last beacon) status */
 	u32 ibss_manager;
 
-	/* storing the jiffies when the plcp error rate is received */
-	unsigned long plcp_jiffies;
+	/* jiffies when last recovery from statistics was performed */
+	unsigned long rx_statistics_jiffies;
 
 	/* force reset */
 	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index a70f1eb..bbc8bda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -449,10 +449,8 @@ static bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt
  * to improve the throughput.
  */
 static bool iwl_good_plcp_health(struct iwl_priv *priv,
-				 struct iwl_rx_packet *pkt)
+				 struct iwl_rx_packet *pkt, unsigned int msecs)
 {
-	unsigned int msecs;
-	unsigned long stamp;
 	int delta;
 	int threshold = priv->cfg->base_params->plcp_delta_threshold;
 
@@ -461,13 +459,6 @@ static bool iwl_good_plcp_health(struct iwl_priv *priv,
 		return true;
 	}
 
-	stamp = jiffies;
-	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
-	priv->plcp_jiffies = stamp;
-
-	if (msecs == 0)
-		return true;
-
 	if (iwl_bt_statistics(priv)) {
 		struct statistics_rx_bt *cur, *old;
 
@@ -508,9 +499,21 @@ static void iwl_recover_from_statistics(struct iwl_priv *priv,
 					struct iwl_rx_packet *pkt)
 {
 	const struct iwl_mod_params *mod_params = priv->cfg->mod_params;
+	unsigned int msecs;
+	unsigned long stamp;
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    !iwl_is_any_associated(priv))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	stamp = jiffies;
+	msecs = jiffies_to_msecs(stamp - priv->rx_statistics_jiffies);
+
+	/* Only gather statistics and update time stamp when not associated */
+	if (!iwl_is_any_associated(priv))
+		goto out;
+
+	/* Do not check/recover when do not have enough statistics data */
+	if (msecs < 99)
 		return;
 
 	if (mod_params->ack_check && !iwl_good_ack_health(priv, pkt)) {
@@ -519,8 +522,18 @@ static void iwl_recover_from_statistics(struct iwl_priv *priv,
 			return;
 	}
 
-	if (mod_params->plcp_check && !iwl_good_plcp_health(priv, pkt))
+	if (mod_params->plcp_check && !iwl_good_plcp_health(priv, pkt, msecs))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
+
+out:
+	if (iwl_bt_statistics(priv))
+		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
+			sizeof(priv->_agn.statistics_bt));
+	else
+		memcpy(&priv->_agn.statistics, &pkt->u.stats,
+			sizeof(priv->_agn.statistics));
+
+	priv->rx_statistics_jiffies = stamp;
 }
 
 /* Calculate noise level, based on measurements during network silence just
@@ -669,13 +682,6 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 
 	iwl_recover_from_statistics(priv, pkt);
 
-	if (iwl_bt_statistics(priv))
-		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
-			sizeof(priv->_agn.statistics_bt));
-	else
-		memcpy(&priv->_agn.statistics, &pkt->u.stats,
-			sizeof(priv->_agn.statistics));
-
 	set_bit(STATUS_STATISTICS, &priv->status);
 
 	/* Reschedule the statistics timer to occur in
-- 
1.7.1

