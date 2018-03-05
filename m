Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36697 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbeCEOtW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:49:22 -0500
Received: by mail-pg0-f67.google.com with SMTP id i14so6905221pgv.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:49:22 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 09/10] rsi: tx improvements
Date: Mon,  5 Mar 2018 20:06:59 +0530
Message-Id: <1520260620-4694-10-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154947_468258_F3560690)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Changes done to improve TX path:
1. Max number of frames to aggregate is increased to 8
2. Bootup parameters updated.
3. registering 5g band is done only when device supports
4. Vif is properly taken to enable power save.
5. When coex mode exist, power save on by default is set

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     |  4 +++-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 36 +++++++++++++++++++++--------
 drivers/net/wireless/rsi/rsi_boot_params.h  |  3 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  2 ++
 4 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 3ca468b9..1f1b972 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -432,7 +432,9 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 		}
 	} else {
 		if (ieee80211_is_data_qos(wh->frame_control)) {
-			tid = (skb->data[24] & IEEE80211_QOS_TID);
+			u8 *qos = ieee80211_get_qos_ctl(wh);
+
+			tid = *qos & IEEE80211_QOS_CTL_TID_MASK;
 			skb->priority = TID_TO_WME_AC(tid);
 		} else {
 			tid = IEEE80211_NONQOS_TID;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 63d43fc..70b2d61 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -240,6 +240,9 @@ static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
 
 	rsi_dbg(INFO_ZONE, "***** Hardware scan start *****\n");
 
+	if (common->iface_down)
+		return -ENETDOWN;
+
 	if (common->fsm_state != FSM_MAC_INIT_DONE)
 		return -ENODEV;
 
@@ -697,7 +700,7 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 
 	/* Power save parameters */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		struct ieee80211_vif *vif;
+		struct ieee80211_vif *vif, *sta_vif = NULL;
 		unsigned long flags;
 		int i, set_ps = 1;
 
@@ -711,13 +714,20 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 				set_ps = 0;
 				break;
 			}
+			if (vif->type == NL80211_IFTYPE_STATION ||
+			    vif->type == NL80211_IFTYPE_P2P_CLIENT) {
+				if (!sta_vif)
+					sta_vif = vif;
+				else if (vif->bss_conf.assoc)
+					sta_vif = vif;
+			}
 		}
-		if (set_ps) {
+		if (set_ps && sta_vif) {
 			spin_lock_irqsave(&adapter->ps_lock, flags);
 			if (conf->flags & IEEE80211_CONF_PS)
-				rsi_enable_ps(adapter, vif);
+				rsi_enable_ps(adapter, sta_vif);
 			else
-				rsi_disable_ps(adapter, vif);
+				rsi_disable_ps(adapter, sta_vif);
 			spin_unlock_irqrestore(&adapter->ps_lock, flags);
 		}
 	}
@@ -2051,9 +2061,16 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	hw->uapsd_queues = RSI_IEEE80211_UAPSD_QUEUES;
 	hw->uapsd_max_sp_len = IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL;
 
-	hw->max_tx_aggregation_subframes = 6;
+	hw->max_tx_aggregation_subframes = RSI_MAX_TX_AGGR_FRMS;
+	hw->max_rx_aggregation_subframes = RSI_MAX_RX_AGGR_FRMS;
 	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
-	rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
+	wiphy->bands[NL80211_BAND_2GHZ] =
+		&adapter->sbands[NL80211_BAND_2GHZ];
+	if (common->num_supp_bands > 1) {
+		rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
+		wiphy->bands[NL80211_BAND_5GHZ] =
+			&adapter->sbands[NL80211_BAND_5GHZ];
+	}
 	hw->rate_control_algorithm = "AARF";
 
 	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
@@ -2074,10 +2091,6 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	wiphy->available_antennas_rx = 1;
 	wiphy->available_antennas_tx = 1;
-	wiphy->bands[NL80211_BAND_2GHZ] =
-		&adapter->sbands[NL80211_BAND_2GHZ];
-	wiphy->bands[NL80211_BAND_5GHZ] =
-		&adapter->sbands[NL80211_BAND_5GHZ];
 
 	/* AP Parameters */
 	wiphy->max_ap_assoc_sta = rsi_max_ap_stas[common->oper_mode - 1];
@@ -2106,6 +2119,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->iface_combinations = rsi_iface_combinations;
 	wiphy->n_iface_combinations = ARRAY_SIZE(rsi_iface_combinations);
 
+	if (common->coex_mode > 1)
+		wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
+
 	status = ieee80211_register_hw(hw);
 	if (status)
 		return status;
diff --git a/drivers/net/wireless/rsi/rsi_boot_params.h b/drivers/net/wireless/rsi/rsi_boot_params.h
index 238ee96..ad903b22 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -46,7 +46,8 @@
 	(((TA_PLL_M_VAL_20 + 1) * 40) / \
 	 ((TA_PLL_N_VAL_20 + 1) * (TA_PLL_P_VAL_20 + 1)))
 #define VALID_20 \
-	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS)
+	(WIFI_TAPLL_CONFIGS | WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | \
+	 WIFI_SWITCH_CLK_CONFIGS | BOOTUP_MODE_INFO | CRYSTAL_GOOD_TIME)
 #define UMAC_CLK_40BW   \
 	(((TA_PLL_M_VAL_40 + 1) * 40) / \
 	 ((TA_PLL_N_VAL_40 + 1) * (TA_PLL_P_VAL_40 + 1)))
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 65ae037..ae7dff3 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -231,6 +231,8 @@
 #define RSI_CHAN_SET_TIME		50
 #define RSI_PROBE_CFM_TIME		50
 #define DOT11_ASSOC_CAP_SECURITY	BIT(4)
+#define RSI_MAX_TX_AGGR_FRMS		8
+#define RSI_MAX_RX_AGGR_FRMS		8
 
 enum opmode {
 	RSI_OPMODE_UNSUPPORTED = -1,
-- 
2.7.4
