Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbYEECY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH 20/25] iwlwifi : Set monitor mode for 4965
Date: Mon,  5 May 2008 10:22:47 +0800
Message-Id: <1209954172-3092-21-git-send-email-yi.zhu@intel.com> (sfid-20080505_044417_821018_3824BECA)
In-Reply-To: <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch leverages mac80211 configure_filter to enable iwl4965
monitor mode.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   11 +++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   36 ++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 77ae7f1..5ce7530 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2617,7 +2617,9 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 		rx_start->byte_count = amsdu->byte_count;
 		rx_end = (__le32 *) (((u8 *) hdr) + len);
 	}
-	if (len > priv->hw_params.max_pkt_size || len < 16) {
+	/* In monitor mode allow 802.11 ACk frames (10 bytes) */
+	if (len > priv->hw_params.max_pkt_size ||
+	    len < ((priv->iw_mode == IEEE80211_IF_TYPE_MNTR) ? 10 : 16)) {
 		IWL_WARNING("byte count out of range [16,4K] : %d\n", len);
 		return;
 	}
@@ -2989,6 +2991,13 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 			      rx_status.ssi, rx_status.noise, rx_status.signal,
 			      (unsigned long long)rx_status.mactime);
 
+
+	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
+		iwl4965_handle_data_packet(priv, 1, include_phy,
+						 rxb, &rx_status);
+		return;
+	}
+
 	network_packet = iwl4965_is_network_packet(priv, header);
 	if (network_packet) {
 		priv->last_rx_rssi = rx_status.ssi;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e730583..25dce14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1163,6 +1163,7 @@ struct iwl_priv {
 	struct work_struct report_work;
 	struct work_struct request_scan;
 	struct work_struct beacon_update;
+	struct work_struct set_monitor;
 
 	struct tasklet_struct irq_tasklet;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d155f75..77de0a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4540,6 +4540,24 @@ static void iwl4965_bg_rf_kill(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+static void iwl4965_bg_set_monitor(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work,
+				struct iwl_priv, set_monitor);
+
+	IWL_DEBUG(IWL_DL_STATE, "setting monitor mode\n");
+
+	mutex_lock(&priv->mutex);
+
+	if (!iwl_is_ready(priv))
+		IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
+	else
+		if (iwl4965_set_mode(priv, IEEE80211_IF_TYPE_MNTR) != 0)
+			IWL_ERROR("iwl4965_set_mode() failed\n");
+
+	mutex_unlock(&priv->mutex);
+}
+
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
 static void iwl4965_bg_scan_check(struct work_struct *data)
@@ -5429,7 +5447,22 @@ static void iwl4965_configure_filter(struct ieee80211_hw *hw,
 	 * XXX: dummy
 	 * see also iwl4965_connection_init_rx_config
 	 */
-	*total_flags = 0;
+	struct iwl_priv *priv = hw->priv;
+	int new_flags = 0;
+	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
+		if (*total_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
+			IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
+					   IEEE80211_IF_TYPE_MNTR,
+					   changed_flags, *total_flags);
+			/* queue work 'cuz mac80211 is holding a lock which
+			 * prevents us from issuing (synchronous) f/w cmds */
+			queue_work(priv->workqueue, &priv->set_monitor);
+			new_flags &= FIF_PROMISC_IN_BSS |
+				     FIF_OTHER_BSS |
+				     FIF_ALLMULTI;
+		}
+	}
+	*total_flags = new_flags;
 }
 
 static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
@@ -6360,6 +6393,7 @@ static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->abort_scan, iwl4965_bg_abort_scan);
 	INIT_WORK(&priv->rf_kill, iwl4965_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl4965_bg_beacon_update);
+	INIT_WORK(&priv->set_monitor, iwl4965_bg_set_monitor);
 	INIT_DELAYED_WORK(&priv->post_associate, iwl4965_bg_post_associate);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl4965_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl4965_bg_alive_start);
-- 
1.5.3.6

