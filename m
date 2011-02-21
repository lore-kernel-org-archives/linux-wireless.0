Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36069 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1BUCZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:25:26 -0500
Received: by yxs7 with SMTP id 7so124332yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:25:25 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52139.112702.619421@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:23 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 13/23] ath9k_htc: Allow AP interface to be created
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    8 ++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   11 +++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0088c6e..b219428 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -205,6 +205,7 @@ struct ath9k_htc_target_stats {
 } __packed;
 
 #define ATH9K_HTC_MAX_VIF 2
+#define ATH9K_HTC_MAX_BCN_VIF 2
 
 #define INC_VIF(_priv, _type) do {		\
 		switch (_type) {		\
@@ -214,6 +215,9 @@ struct ath9k_htc_target_stats {
 		case NL80211_IFTYPE_ADHOC:	\
 			_priv->num_ibss_vif++;	\
 			break;			\
+		case NL80211_IFTYPE_AP:		\
+			_priv->num_ap_vif++;	\
+			break;			\
 		default:			\
 			break;			\
 		}				\
@@ -227,6 +231,9 @@ struct ath9k_htc_target_stats {
 		case NL80211_IFTYPE_ADHOC:	\
 			_priv->num_ibss_vif--;	\
 			break;			\
+		case NL80211_IFTYPE_AP:		\
+			_priv->num_ap_vif--;	\
+			break;			\
 		default:			\
 			break;			\
 		}				\
@@ -395,6 +402,7 @@ struct ath9k_htc_priv {
 	u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
 	u8 num_ibss_vif;
 	u8 num_sta_vif;
+	u8 num_ap_vif;
 
 	u16 op_flags;
 	u16 curtxpow;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 39074fc..51a8c51 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1204,6 +1204,14 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		return -ENOBUFS;
 	}
 
+	if (((vif->type == NL80211_IFTYPE_AP) ||
+	     (vif->type == NL80211_IFTYPE_ADHOC)) &&
+	    ((priv->num_ap_vif + priv->num_ibss_vif) >= ATH9K_HTC_MAX_BCN_VIF)) {
+		ath_err(common, "Max. number of beaconing interfaces reached\n");
+		mutex_unlock(&priv->mutex);
+		return -ENOBUFS;
+	}
+
 	ath9k_htc_ps_wakeup(priv);
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
 	memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
@@ -1215,6 +1223,9 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_ADHOC:
 		hvif.opmode = cpu_to_be32(HTC_M_IBSS);
 		break;
+	case NL80211_IFTYPE_AP:
+		hvif.opmode = cpu_to_be32(HTC_M_HOSTAP);
+		break;
 	default:
 		ath_err(common,
 			"Interface type %d not yet supported\n", vif->type);
-- 
1.7.4.1

