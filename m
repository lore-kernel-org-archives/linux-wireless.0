Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61864 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab1DYK0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 06:26:40 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 03:26:14 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/5] ath9k_htc: Fix warnings due to -Wunused-but-set-variable
Date: Mon, 25 Apr 2011 15:56:19 +0530
Message-ID: <1303727180-22212-4-git-send-email-rmanoharan@atheros.com> (sfid-20110425_122643_331583_969CA01B)
In-Reply-To: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These warnings are exposed by gcc 4.6.
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function
'ath9k_htc_tx_process':
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:449:35: warning: variable
'sband' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c: In function
'ath9k_htc_beacon_config_sta':
drivers/net/wireless/ath/ath9k/htc_drv_main.c: In function
'ath9k_htc_stop':
drivers/net/wireless/ath/ath9k/htc_drv_main.c:967:6: warning: variable
'ret' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/htc_drv_main.c: In function
'ath9k_htc_remove_interface':
drivers/net/wireless/ath/ath9k/htc_drv_gpio.c: In function
'ath_btcoex_period_work':
drivers/net/wireless/ath/ath9k/htc_drv_gpio.c:67:6: warning: variable
'ret' set but not used [-Wunused-but-set-variable
 ...

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    6 ++++++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |    2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    8 +++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |    2 --
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index a157107..ce6f0b5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -181,6 +181,8 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	imask |= ATH9K_INT_BMISS;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
+	if (ret)
+		ath_err(common, "Failed to enable interrupts %s\n", __func__);
 }
 
 static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
@@ -237,6 +239,8 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 	priv->cur_beacon_conf.bmiss_cnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
+	if (ret)
+		ath_err(common, "Failed to enable interrupts %s\n", __func__);
 }
 
 static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
@@ -284,6 +288,8 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 	priv->cur_beacon_conf.bmiss_cnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
+	if (ret)
+		ath_err(common, "Failed to enable interrupts %s\n", __func__);
 }
 
 void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index dc0b33d..fc669c9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -74,6 +74,8 @@ static void ath_btcoex_period_work(struct work_struct *work)
 	aggr = priv->op_flags & OP_BT_PRIORITY_DETECTED;
 
 	WMI_CMD_BUF(WMI_AGGR_LIMIT_CMD, &aggr);
+	if (ret)
+		ath_err(common, "Failed to set aggregate limit\n");
 
 	ath9k_cmn_btcoex_bt_stomp(common, is_btscan ? ATH_BTCOEX_STOMP_ALL :
 			btcoex->bt_stomp_type);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 4de3864..3aa996e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -332,6 +332,8 @@ static void __ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
 	hvif.index = priv->mon_vif_idx;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
+	if (ret)
+		ath_err(common, "Unable to remove monitor interface\n");
 	priv->nvifs--;
 	priv->vif_slot &= ~(1 << priv->mon_vif_idx);
 }
@@ -1008,7 +1010,9 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	if (priv->ah->is_monitoring)
 		ath9k_htc_remove_monitor_interface(priv);
 
-	ath9k_hw_phy_disable(ah);
+	ret = ath9k_hw_phy_disable(ah);
+	if (ret)
+		ath_err(common, "Unable to disable PHY\n");
 	ath9k_hw_disable(ah);
 	ath9k_htc_ps_restore(priv);
 	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
@@ -1135,6 +1139,8 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
 	hvif.index = avp->index;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
+	if (ret)
+		ath_err(common, "Failed to remove interface %d\n", hvif.index);
 	priv->nvifs--;
 	priv->vif_slot &= ~(1 << avp->index);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 723a3a9..a898dac 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -446,7 +446,6 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rate;
 	struct ieee80211_conf *cur_conf = &priv->hw->conf;
-	struct ieee80211_supported_band *sband;
 	bool txok;
 	int slot;
 
@@ -461,7 +460,6 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	tx_info = IEEE80211_SKB_CB(skb);
 	vif = tx_info->control.vif;
 	rate = &tx_info->status.rates[0];
-	sband = priv->hw->wiphy->bands[cur_conf->channel->band];
 
 	memset(&tx_info->status, 0, sizeof(tx_info->status));
 
-- 
1.7.4.4

