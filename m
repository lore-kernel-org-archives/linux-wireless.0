Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47310 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AUDBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:01:52 -0500
Received: by iyj18 with SMTP id 18so1246469iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:01:52 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63219.25077.245547@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:31:07 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 13/33] ath9k_htc: Allow AP interface to be created
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    8 ++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   11 +++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index f650439..378aba3 100644
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
index f5333dc9..0694f2e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1202,6 +1202,14 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
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
@@ -1213,6 +1221,9 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
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
1.7.3.5

