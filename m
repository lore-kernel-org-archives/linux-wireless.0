Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36249 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbbFIIAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 04:00:09 -0400
Received: by pabqy3 with SMTP id qy3so8543827pab.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 01:00:09 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath9k_htc: add support of channel switch
Date: Tue,  9 Jun 2015 15:59:49 +0800
Message-Id: <1433836789-5505-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150609_100014_516797_10A68268)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the support of channel switching functionality, similar
to ath9k support.

Tested with TP-Link TL-WN722N and TL-WN821N.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |  2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  3 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 17 +++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 5dbc617..16dff4b 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -531,6 +531,7 @@ struct ath9k_htc_priv {
 	struct ath9k_debug debug;
 #endif
 	struct mutex mutex;
+	struct ieee80211_vif *csa_vif;
 };
 
 static inline void ath_read_cachesize(struct ath_common *common, int *csz)
@@ -584,6 +585,7 @@ void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv);
 void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event);
 void ath9k_tx_failed_tasklet(unsigned long data);
 void ath9k_htc_tx_cleanup_timer(unsigned long data);
+bool ath9k_htc_csa_is_finished(struct ath9k_htc_priv *priv);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index e8b6ec3..e6bcb4c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -257,6 +257,8 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	}
 
 	spin_unlock_bh(&priv->beacon_lock);
+
+	ath9k_htc_csa_is_finished(priv);
 }
 
 static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv,
@@ -503,3 +505,20 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
 		return;
 	}
 }
+
+bool ath9k_htc_csa_is_finished(struct ath9k_htc_priv *priv)
+{
+	struct ieee80211_vif *vif;
+
+	vif = priv->csa_vif;
+	if (!vif || !vif->csa_active)
+		return false;
+
+	if (!ieee80211_csa_is_complete(vif))
+		return false;
+
+	ieee80211_csa_finish(vif);
+
+	priv->csa_vif = NULL;
+	return true;
+}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7468562..9569010 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -744,7 +744,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
-			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index b71f307..dab1323 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1134,6 +1134,9 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	priv->nvifs--;
 	priv->vif_slot &= ~(1 << avp->index);
 
+	if (priv->csa_vif == vif)
+		priv->csa_vif = NULL;
+
 	ath9k_htc_remove_station(priv, vif, NULL);
 
 	DEC_VIF(priv, vif->type);
@@ -1841,6 +1844,19 @@ static int ath9k_htc_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
 	return 0;
 }
 
+static void ath9k_htc_channel_switch_beacon(struct ieee80211_hw *hw,
+					    struct ieee80211_vif *vif,
+					    struct cfg80211_chan_def *chandef)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+
+	/* mac80211 does not support CSA in multi-if cases (yet) */
+	if (WARN_ON(priv->csa_vif))
+		return;
+
+	priv->csa_vif = vif;
+}
+
 struct ieee80211_ops ath9k_htc_ops = {
 	.tx                 = ath9k_htc_tx,
 	.start              = ath9k_htc_start,
@@ -1867,6 +1883,7 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.set_bitrate_mask   = ath9k_htc_set_bitrate_mask,
 	.get_stats	    = ath9k_htc_get_stats,
 	.get_antenna	    = ath9k_htc_get_antenna,
+	.channel_switch_beacon	= ath9k_htc_channel_switch_beacon,
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	.get_et_sset_count  = ath9k_htc_get_et_sset_count,
-- 
2.3.0

