Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55725 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:19:29 -0500
Received: by mail-gy0-f174.google.com with SMTP id 11so65408gyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:19:29 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52131.619464.414079@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:15 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 12/23] ath9k_htc: Maintain individual counters for interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This is required for allowing only one IBSS interface to be
configured.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   28 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   14 ++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 97f7ae0..0088c6e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -206,6 +206,32 @@ struct ath9k_htc_target_stats {
 
 #define ATH9K_HTC_MAX_VIF 2
 
+#define INC_VIF(_priv, _type) do {		\
+		switch (_type) {		\
+		case NL80211_IFTYPE_STATION:	\
+			_priv->num_sta_vif++;	\
+			break;			\
+		case NL80211_IFTYPE_ADHOC:	\
+			_priv->num_ibss_vif++;	\
+			break;			\
+		default:			\
+			break;			\
+		}				\
+	} while (0)
+
+#define DEC_VIF(_priv, _type) do {		\
+		switch (_type) {		\
+		case NL80211_IFTYPE_STATION:	\
+			_priv->num_sta_vif--;	\
+			break;			\
+		case NL80211_IFTYPE_ADHOC:	\
+			_priv->num_ibss_vif--;	\
+			break;			\
+		default:			\
+			break;			\
+		}				\
+	} while (0)
+
 struct ath9k_htc_vif {
 	u8 index;
 	u16 seq_no;
@@ -367,6 +393,8 @@ struct ath9k_htc_priv {
 	u8 mon_vif_idx;
 	u8 sta_slot;
 	u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
+	u8 num_ibss_vif;
+	u8 num_sta_vif;
 
 	u16 op_flags;
 	u16 curtxpow;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 04cb243..39074fc 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1193,9 +1193,15 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
-		ret = -ENOBUFS;
 		mutex_unlock(&priv->mutex);
-		return ret;
+		return -ENOBUFS;
+	}
+
+	if (priv->num_ibss_vif ||
+	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
+		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
+		mutex_unlock(&priv->mutex);
+		return -ENOBUFS;
 	}
 
 	ath9k_htc_ps_wakeup(priv);
@@ -1240,6 +1246,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	priv->nvifs++;
 	priv->vif = vif;
 
+	INC_VIF(priv, vif->type);
+
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
 
@@ -1273,6 +1281,8 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	ath9k_htc_remove_station(priv, vif, NULL);
 	priv->vif = NULL;
 
+	DEC_VIF(priv, vif->type);
+
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
 
 	ath9k_htc_ps_restore(priv);
-- 
1.7.4.1

