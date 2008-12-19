Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYLSCpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:33 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 32/43] iwlwifi: replace IWL_WARNING with IWL_WARN
Date: Fri, 19 Dec 2008 10:37:32 +0800
Message-Id: <1229654263-21454-33-git-send-email-yi.zhu@intel.com> (sfid-20081219_034620_259267_D3FE87A2)
In-Reply-To: <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

IWL_WARN doesn't use hidden priv pointer.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c           |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |   20 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   34 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    1 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.c         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c             |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c       |   73 +++++++++++----------
 12 files changed, 94 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 522f020..de9bf2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -158,7 +158,7 @@ void iwl3945_disable_events(struct iwl_priv *priv)
 
 	ret = iwl_grab_nic_access(priv);
 	if (ret) {
-		IWL_WARNING("Can not read from adapter at this time.\n");
+		IWL_WARN(priv, "Can not read from adapter at this time.\n");
 		return;
 	}
 
@@ -2096,7 +2096,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl_priv *priv)
 
 		/* sanity check on factory saturation power value */
 		if (group->saturation_power < 40) {
-			IWL_WARNING("Error: saturation power is %d, "
+			IWL_WARN(priv, "Error: saturation power is %d, "
 				    "less than minimum expected 40\n",
 				    group->saturation_power);
 			return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4822362..3de8d64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1485,12 +1485,12 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 
 			/* stay within the table! */
 			if (power_index > 107) {
-				IWL_WARNING("txpower index %d > 107\n",
+				IWL_WARN(priv, "txpower index %d > 107\n",
 					    power_index);
 				power_index = 107;
 			}
 			if (power_index < 0) {
-				IWL_WARNING("txpower index %d < 0\n",
+				IWL_WARN(priv, "txpower index %d < 0\n",
 					    power_index);
 				power_index = 0;
 			}
@@ -1533,7 +1533,7 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 		/* If this gets hit a lot, switch it to a BUG() and catch
 		 * the stack trace to find out who is calling this during
 		 * a scan. */
-		IWL_WARNING("TX Power requested while scanning!\n");
+		IWL_WARN(priv, "TX Power requested while scanning!\n");
 		return -EAGAIN;
 	}
 
@@ -1839,7 +1839,8 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES <= txq_id)) {
-		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+		IWL_WARN(priv,
+			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
 			IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES - 1);
 		return -EINVAL;
@@ -1910,7 +1911,8 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES <= txq_id)) {
-		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+		IWL_WARN(priv,
+			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
 			IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES - 1);
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 338444a..448bdb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -676,7 +676,8 @@ static void iwl5000_init_alive_start(struct iwl_priv *priv)
 	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
-		IWL_WARNING("Could not complete ALIVE transition: %d\n", ret);
+		IWL_WARN(priv,
+			"Could not complete ALIVE transition: %d\n", ret);
 		goto restart;
 	}
 
@@ -1012,7 +1013,8 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
-		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+		IWL_WARN(priv,
+			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL50_FIRST_AMPDU_QUEUE,
 			IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES - 1);
 		return -EINVAL;
@@ -1077,7 +1079,8 @@ static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
-		IWL_WARNING("queue number out of range: %d, must be %d to %d\n",
+		IWL_WARN(priv,
+			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL50_FIRST_AMPDU_QUEUE,
 			IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES - 1);
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
index 392d96d..16e656a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
@@ -51,53 +51,53 @@ int iwl_agn_check_rxon_cmd(struct iwl_priv *priv)
 				(RXON_FLG_TGJ_NARROW_BAND_MSK |
 				 RXON_FLG_RADAR_DETECT_MSK));
 		if (error)
-			IWL_WARNING("check 24G fields %d | %d\n",
+			IWL_WARN(priv, "check 24G fields %d | %d\n",
 				    counter++, error);
 	} else {
 		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
 				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
 		if (error)
-			IWL_WARNING("check 52 fields %d | %d\n",
+			IWL_WARN(priv, "check 52 fields %d | %d\n",
 				    counter++, error);
 		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
 		if (error)
-			IWL_WARNING("check 52 CCK %d | %d\n",
+			IWL_WARN(priv, "check 52 CCK %d | %d\n",
 				    counter++, error);
 	}
 	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
 	if (error)
-		IWL_WARNING("check mac addr %d | %d\n", counter++, error);
+		IWL_WARN(priv, "check mac addr %d | %d\n", counter++, error);
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
 	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
 		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
 	if (error)
-		IWL_WARNING("check basic rate %d | %d\n", counter++, error);
+		IWL_WARN(priv, "check basic rate %d | %d\n", counter++, error);
 
 	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
 	if (error)
-		IWL_WARNING("check assoc id %d | %d\n", counter++, error);
+		IWL_WARN(priv, "check assoc id %d | %d\n", counter++, error);
 
 	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
 	if (error)
-		IWL_WARNING("check CCK and short slot %d | %d\n",
+		IWL_WARN(priv, "check CCK and short slot %d | %d\n",
 			    counter++, error);
 
 	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
 	if (error)
-		IWL_WARNING("check CCK & auto detect %d | %d\n",
+		IWL_WARN(priv, "check CCK & auto detect %d | %d\n",
 			    counter++, error);
 
 	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
 			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
 	if (error)
-		IWL_WARNING("check TGG and auto detect %d | %d\n",
+		IWL_WARN(priv, "check TGG and auto detect %d | %d\n",
 			    counter++, error);
 
 	if (error)
-		IWL_WARNING("Tuning to channel %d\n",
+		IWL_WARN(priv, "Tuning to channel %d\n",
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2b64394..78c9950 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -338,7 +338,7 @@ static void iwl_clear_free_frames(struct iwl_priv *priv)
 	}
 
 	if (priv->frames_count) {
-		IWL_WARNING("%d frames still in use.  Did we lose one?\n",
+		IWL_WARN(priv, "%d frames still in use.  Did we lose one?\n",
 			    priv->frames_count);
 		priv->frames_count = 0;
 	}
@@ -746,7 +746,7 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 
 	cancel_delayed_work(&priv->scan_check);
 	if (iwl_scan_cancel_timeout(priv, 100)) {
-		IWL_WARNING("Aborted scan still in progress after 100ms\n");
+		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
 		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 		return -EAGAIN;
 	}
@@ -842,7 +842,7 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 		queue_delayed_work(priv->workqueue, pwork,
 				   msecs_to_jiffies(5));
 	else
-		IWL_WARNING("uCode did not respond OK.\n");
+		IWL_WARN(priv, "uCode did not respond OK.\n");
 }
 
 static void iwl_rx_reply_error(struct iwl_priv *priv,
@@ -1194,7 +1194,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			if (rxb && rxb->skb)
 				iwl_tx_cmd_complete(priv, rxb);
 			else
-				IWL_WARNING("Claim null rxb?\n");
+				IWL_WARN(priv, "Claim null rxb?\n");
 		}
 
 		/* For now we just don't re-use anything.  We can tweak this
@@ -1461,9 +1461,9 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		IWL_ERROR("Unhandled INTA bits 0x%08x\n", inta & ~handled);
 
 	if (inta & ~CSR_INI_SET_MASK) {
-		IWL_WARNING("Disabled INTA bits 0x%08x were pending\n",
+		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
 			 inta & ~CSR_INI_SET_MASK);
-		IWL_WARNING("   with FH_INT = 0x%08x\n", inta_fh);
+		IWL_WARN(priv, "   with FH_INT = 0x%08x\n", inta_fh);
 	}
 
 	/* Re-enable all interrupts */
@@ -1515,7 +1515,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
-		IWL_WARNING("HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
 		goto unplugged;
 	}
 
@@ -1837,8 +1837,8 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
-		IWL_WARNING("Could not complete ALIVE transition [ntf]: %d\n",
-			    ret);
+		IWL_WARN(priv,
+			"Could not complete ALIVE transition [ntf]: %d\n", ret);
 		goto restart;
 	}
 
@@ -2024,7 +2024,7 @@ static int __iwl_up(struct iwl_priv *priv)
 	int ret;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_WARNING("Exit pending; will not bring the NIC up\n");
+		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
 
@@ -2041,7 +2041,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	if (iwl_is_rfkill(priv)) {
 		iwl_enable_interrupts(priv);
-		IWL_WARNING("Radio disabled by %s RF Kill switch\n",
+		IWL_WARN(priv, "Radio disabled by %s RF Kill switch\n",
 		    test_bit(STATUS_RF_KILL_HW, &priv->status) ? "HW" : "SW");
 		return 0;
 	}
@@ -2167,7 +2167,7 @@ static void iwl_bg_rf_kill(struct work_struct *work)
 			IWL_DEBUG_RF_KILL("Can not turn radio back on - "
 					  "disabled by SW switch\n");
 		else
-			IWL_WARNING("Radio Frequency Kill Switch is On:\n"
+			IWL_WARN(priv, "Radio Frequency Kill Switch is On:\n"
 				    "Kill switch must be turned off for "
 				    "wireless networking to work.\n");
 	}
@@ -2273,7 +2273,7 @@ static void iwl_post_associate(struct iwl_priv *priv)
 	ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (ret)
-		IWL_WARNING("REPLY_RXON_TIMING failed - "
+		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
@@ -2675,7 +2675,7 @@ static void iwl_config_ap(struct iwl_priv *priv)
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				sizeof(priv->rxon_timing), &priv->rxon_timing);
 		if (ret)
-			IWL_WARNING("REPLY_RXON_TIMING failed - "
+			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
 		iwl_set_rxon_chain(priv);
@@ -2783,7 +2783,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 		/* If there is currently a HW scan going on in the background
 		 * then we need to cancel it else the RXON below will fail. */
 		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARNING("Aborted scan still in progress "
+			IWL_WARN(priv, "Aborted scan still in progress "
 				    "after 100ms\n");
 			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 			mutex_unlock(&priv->mutex);
@@ -3478,7 +3478,7 @@ static ssize_t store_flags(struct device *d,
 	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
 		if (iwl_scan_cancel_timeout(priv, 100))
-			IWL_WARNING("Could not cancel scan.\n");
+			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Commit rxon.flags = 0x%04X\n", flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
@@ -3517,7 +3517,7 @@ static ssize_t store_filter_flags(struct device *d,
 	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
 		if (iwl_scan_cancel_timeout(priv, 100))
-			IWL_WARNING("Could not cancel scan.\n");
+			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c889e3a..fcfb4ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -926,13 +926,13 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret = 0;
 	if (tx_power < IWL_TX_POWER_TARGET_POWER_MIN) {
-		IWL_WARNING("Requested user TXPOWER %d below limit.\n",
+		IWL_WARN(priv, "Requested user TXPOWER %d below limit.\n",
 			    priv->tx_power_user_lmt);
 		return -EINVAL;
 	}
 
 	if (tx_power > IWL_TX_POWER_TARGET_POWER_MAX) {
-		IWL_WARNING("Requested user TXPOWER %d above limit.\n",
+		IWL_WARN(priv, "Requested user TXPOWER %d above limit.\n",
 			    priv->tx_power_user_lmt);
 		return -EINVAL;
 	}
@@ -1195,7 +1195,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 
 	ret = iwl_grab_nic_access(priv);
 	if (ret) {
-		IWL_WARNING("Can not read from adapter at this time.\n");
+		IWL_WARN(priv, "Can not read from adapter at this time.\n");
 		return;
 	}
 
@@ -1299,7 +1299,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 
 	ret = iwl_grab_nic_access(priv);
 	if (ret) {
-		IWL_WARNING("Can not read from adapter at this time.\n");
+		IWL_WARN(priv, "Can not read from adapter at this time.\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 9ed5c3a..4774c98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -32,7 +32,6 @@
 struct iwl_priv;
 
 #define IWL_ERROR(f, a...) dev_err(&(priv->pci_dev->dev), f, ## a)
-#define IWL_WARNING(f, a...) dev_warn(&(priv->pci_dev->dev), f, ## a)
 #define IWL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
 #define IWL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
 #define IWL_INFO(p, f, a...) dev_info(&((p)->pci_dev->dev), f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 4b69da3..cece1c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -62,7 +62,8 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 		iwl_radio_kill_sw_disable_radio(priv);
 		break;
 	default:
-		IWL_WARNING("we received unexpected RFKILL state %d\n", state);
+		IWL_WARN(priv, "we received unexpected RFKILL state %d\n",
+			state);
 		break;
 	}
 out_unlock:
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 3c803f6..de55d3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -650,7 +650,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 
 	if (!iwl_is_ready(priv)) {
-		IWL_WARNING("request scan called when driver not ready.\n");
+		IWL_WARN(priv, "request scan called when driver not ready.\n");
 		goto done;
 	}
 
@@ -773,7 +773,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
 			rx_chain = 0x6;
 	} else {
-		IWL_WARNING("Invalid scan band count\n");
+		IWL_WARN(priv, "Invalid scan band count\n");
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 91a1376..d7d0387 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -170,7 +170,7 @@ static int iwl_send_add_sta(struct iwl_priv *priv,
 			break;
 		default:
 			ret = -EIO;
-			IWL_WARNING("REPLY_ADD_STA failed\n");
+			IWL_WARN(priv, "REPLY_ADD_STA failed\n");
 			break;
 		}
 	}
@@ -206,7 +206,7 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	case WLAN_HT_CAP_SM_PS_DISABLED:
 		break;
 	default:
-		IWL_WARNING("Invalid MIMO PS mode %d\n", mimo_ps_mode);
+		IWL_WARN(priv, "Invalid MIMO PS mode %d\n", mimo_ps_mode);
 		break;
 	}
 
@@ -822,7 +822,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	}
 
 	if (priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
-		IWL_WARNING("Removing wrong key %d 0x%x\n",
+		IWL_WARN(priv, "Removing wrong key %d 0x%x\n",
 			    keyconf->keyidx, key_flags);
 		spin_unlock_irqrestore(&priv->sta_lock, flags);
 		return 0;
@@ -1080,7 +1080,8 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		return priv->hw_params.bcast_sta_id;
 
 	default:
-		IWL_WARNING("Unknown mode of operation: %d\n", priv->iw_mode);
+		IWL_WARN(priv, "Unknown mode of operation: %d\n",
+			priv->iw_mode);
 		return priv->hw_params.bcast_sta_id;
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index dd41531..2671a7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1311,7 +1311,7 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 	else
 		return -EINVAL;
 
-	IWL_WARNING("%s on ra = %s tid = %d\n",
+	IWL_WARN(priv, "%s on ra = %s tid = %d\n",
 			__func__, print_mac(mac, ra), tid);
 
 	sta_id = iwl_find_station(priv, ra);
@@ -1375,7 +1375,7 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 		return -ENXIO;
 
 	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
-		IWL_WARNING("Stopping AGG while state not IWL_AGG_ON\n");
+		IWL_WARN(priv, "Stopping AGG while state not IWL_AGG_ON\n");
 
 	tid_data = &priv->stations[sta_id].tid[tid];
 	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7ee42fd..c255c04 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -782,59 +782,59 @@ static int iwl3945_check_rxon_cmd(struct iwl_priv *priv)
 				(RXON_FLG_TGJ_NARROW_BAND_MSK |
 				 RXON_FLG_RADAR_DETECT_MSK));
 		if (error)
-			IWL_WARNING("check 24G fields %d | %d\n",
+			IWL_WARN(priv, "check 24G fields %d | %d\n",
 				    counter++, error);
 	} else {
 		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
 				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
 		if (error)
-			IWL_WARNING("check 52 fields %d | %d\n",
+			IWL_WARN(priv, "check 52 fields %d | %d\n",
 				    counter++, error);
 		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
 		if (error)
-			IWL_WARNING("check 52 CCK %d | %d\n",
+			IWL_WARN(priv, "check 52 CCK %d | %d\n",
 				    counter++, error);
 	}
 	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
 	if (error)
-		IWL_WARNING("check mac addr %d | %d\n", counter++, error);
+		IWL_WARN(priv, "check mac addr %d | %d\n", counter++, error);
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
 	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
 		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
 	if (error)
-		IWL_WARNING("check basic rate %d | %d\n", counter++, error);
+		IWL_WARN(priv, "check basic rate %d | %d\n", counter++, error);
 
 	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
 	if (error)
-		IWL_WARNING("check assoc id %d | %d\n", counter++, error);
+		IWL_WARN(priv, "check assoc id %d | %d\n", counter++, error);
 
 	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
 	if (error)
-		IWL_WARNING("check CCK and short slot %d | %d\n",
+		IWL_WARN(priv, "check CCK and short slot %d | %d\n",
 			    counter++, error);
 
 	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
 	if (error)
-		IWL_WARNING("check CCK & auto detect %d | %d\n",
+		IWL_WARN(priv, "check CCK & auto detect %d | %d\n",
 			    counter++, error);
 
 	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
 			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
 	if (error)
-		IWL_WARNING("check TGG and auto detect %d | %d\n",
+		IWL_WARN(priv, "check TGG and auto detect %d | %d\n",
 			    counter++, error);
 
 	if ((rxon->flags & RXON_FLG_DIS_DIV_MSK))
 		error |= ((rxon->flags & (RXON_FLG_ANT_B_MSK |
 				RXON_FLG_ANT_A_MSK)) == 0);
 	if (error)
-		IWL_WARNING("check antenna %d %d\n", counter++, error);
+		IWL_WARN(priv, "check antenna %d %d\n", counter++, error);
 
 	if (error)
-		IWL_WARNING("Tuning to channel %d\n",
+		IWL_WARN(priv, "Tuning to channel %d\n",
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
@@ -1209,7 +1209,7 @@ int iwl3945_send_add_station(struct iwl_priv *priv,
 			break;
 		default:
 			rc = -EIO;
-			IWL_WARNING("REPLY_ADD_STA failed\n");
+			IWL_WARN(priv, "REPLY_ADD_STA failed\n");
 			break;
 		}
 	}
@@ -1291,7 +1291,7 @@ static void iwl3945_clear_free_frames(struct iwl_priv *priv)
 	}
 
 	if (priv->frames_count) {
-		IWL_WARNING("%d frames still in use.  Did we lose one?\n",
+		IWL_WARN(priv, "%d frames still in use.  Did we lose one?\n",
 			    priv->frames_count);
 		priv->frames_count = 0;
 	}
@@ -2189,7 +2189,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 
 	cancel_delayed_work(&priv->scan_check);
 	if (iwl3945_scan_cancel_timeout(priv, 100)) {
-		IWL_WARNING("Aborted scan still in progress after 100ms\n");
+		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
 		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 		return -EAGAIN;
 	}
@@ -2367,7 +2367,8 @@ static int iwl3945_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		return priv->hw_params.bcast_sta_id;
 
 	default:
-		IWL_WARNING("Unknown mode of operation: %d\n", priv->iw_mode);
+		IWL_WARN(priv, "Unknown mode of operation: %d\n",
+			priv->iw_mode);
 		return priv->hw_params.bcast_sta_id;
 	}
 }
@@ -2901,7 +2902,7 @@ static void iwl3945_rx_reply_alive(struct iwl_priv *priv,
 		queue_delayed_work(priv->workqueue, pwork,
 				   msecs_to_jiffies(5));
 	else
-		IWL_WARNING("uCode did not respond OK.\n");
+		IWL_WARN(priv, "uCode did not respond OK.\n");
 }
 
 static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
@@ -3795,7 +3796,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			if (rxb && rxb->skb)
 				iwl3945_tx_cmd_complete(priv, rxb);
 			else
-				IWL_WARNING("Claim null rxb?\n");
+				IWL_WARN(priv, "Claim null rxb?\n");
 		}
 
 		/* For now we just don't re-use anything.  We can tweak this
@@ -3970,7 +3971,7 @@ static void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 
 	rc = iwl_grab_nic_access(priv);
 	if (rc) {
-		IWL_WARNING("Can not read from adapter at this time.\n");
+		IWL_WARN(priv, "Can not read from adapter at this time.\n");
 		return;
 	}
 
@@ -4073,7 +4074,7 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 
 	rc = iwl_grab_nic_access(priv);
 	if (rc) {
-		IWL_WARNING("Can not read from adapter at this time.\n");
+		IWL_WARN(priv, "Can not read from adapter at this time.\n");
 		return;
 	}
 
@@ -4280,9 +4281,9 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		IWL_ERROR("Unhandled INTA bits 0x%08x\n", inta & ~handled);
 
 	if (inta & ~CSR_INI_SET_MASK) {
-		IWL_WARNING("Disabled INTA bits 0x%08x were pending\n",
+		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
 			 inta & ~CSR_INI_SET_MASK);
-		IWL_WARNING("   with FH_INT = 0x%08x\n", inta_fh);
+		IWL_WARN(priv, "   with FH_INT = 0x%08x\n", inta_fh);
 	}
 
 	/* Re-enable all interrupts */
@@ -4333,7 +4334,7 @@ static irqreturn_t iwl3945_isr(int irq, void *data)
 
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared */
-		IWL_WARNING("HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
 		goto unplugged;
 	}
 
@@ -4500,7 +4501,7 @@ static int iwl3945_init_channel_map(struct iwl_priv *priv)
 	}
 
 	if (priv->eeprom39.version < 0x2f) {
-		IWL_WARNING("Unsupported EEPROM version: 0x%04X\n",
+		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
 			    priv->eeprom39.version);
 		return -EINVAL;
 	}
@@ -5593,7 +5594,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	rc = iwl_grab_nic_access(priv);
 	if (rc) {
-		IWL_WARNING("Can not read RFKILL status from adapter\n");
+		IWL_WARN(priv, "Can not read RFKILL status from adapter\n");
 		return;
 	}
 
@@ -5793,12 +5794,12 @@ static int __iwl3945_up(struct iwl_priv *priv)
 	int rc, i;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_WARNING("Exit pending; will not bring the NIC up\n");
+		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
 		return -EIO;
 	}
 
 	if (test_bit(STATUS_RF_KILL_SW, &priv->status)) {
-		IWL_WARNING("Radio disabled by SW RF kill (module "
+		IWL_WARN(priv, "Radio disabled by SW RF kill (module "
 			    "parameter)\n");
 		return -ENODEV;
 	}
@@ -5815,7 +5816,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 	else {
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
-			IWL_WARNING("Radio disabled by HW RF Kill switch\n");
+			IWL_WARN(priv, "Radio disabled by HW RF Kill switch\n");
 			return -ENODEV;
 		}
 	}
@@ -5939,7 +5940,7 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 			IWL_DEBUG_RF_KILL("Can not turn radio back on - "
 					  "disabled by SW switch\n");
 		else
-			IWL_WARNING("Radio Frequency Kill Switch is On:\n"
+			IWL_WARN(priv, "Radio Frequency Kill Switch is On:\n"
 				    "Kill switch must be turned off for "
 				    "wireless networking to work.\n");
 	}
@@ -5992,7 +5993,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 
 	if (!iwl3945_is_ready(priv)) {
-		IWL_WARNING("request scan called when driver not ready.\n");
+		IWL_WARN(priv, "request scan called when driver not ready.\n");
 		goto done;
 	}
 
@@ -6117,7 +6118,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
 		band = IEEE80211_BAND_5GHZ;
 	} else {
-		IWL_WARNING("Invalid scan band count\n");
+		IWL_WARN(priv, "Invalid scan band count\n");
 		goto done;
 	}
 
@@ -6240,7 +6241,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (rc)
-		IWL_WARNING("REPLY_RXON_TIMING failed - "
+		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
 	priv->staging39_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
@@ -6621,7 +6622,7 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 		rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				sizeof(priv->rxon_timing), &priv->rxon_timing);
 		if (rc)
-			IWL_WARNING("REPLY_RXON_TIMING failed - "
+			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
 		/* FIXME: what should be the assoc_id for AP? */
@@ -6724,7 +6725,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		/* If there is currently a HW scan going on in the background
 		 * then we need to cancel it else the RXON below will fail. */
 		if (iwl3945_scan_cancel_timeout(priv, 100)) {
-			IWL_WARNING("Aborted scan still in progress "
+			IWL_WARN(priv, "Aborted scan still in progress "
 				    "after 100ms\n");
 			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 			mutex_unlock(&priv->mutex);
@@ -7277,7 +7278,7 @@ static ssize_t store_flags(struct device *d,
 	if (le32_to_cpu(priv->staging39_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
 		if (iwl3945_scan_cancel_timeout(priv, 100))
-			IWL_WARNING("Could not cancel scan.\n");
+			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
 				       flags);
@@ -7312,7 +7313,7 @@ static ssize_t store_filter_flags(struct device *d,
 	if (le32_to_cpu(priv->staging39_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
 		if (iwl3945_scan_cancel_timeout(priv, 100))
-			IWL_WARNING("Could not cancel scan.\n");
+			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
@@ -8122,7 +8123,7 @@ static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 		iwl3945_radio_kill_sw(priv, 1);
 		break;
 	default:
-		IWL_WARNING("we received unexpected RFKILL state %d\n", state);
+		IWL_WARN(priv, "received unexpected RFKILL state %d\n", state);
 		break;
 	}
 out_unlock:
-- 
1.5.3.6

