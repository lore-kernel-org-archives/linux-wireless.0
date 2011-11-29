Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53974 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1K2AlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 19:41:05 -0500
Received: by iage36 with SMTP id e36so9710252iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 16:41:04 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: list@devel.open80211s.org, Javier Cardona <javier@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [RFC] ath9k_htc: Add support for NL80211_IFTYPE_MESH_POINT interfaces
Date: Mon, 28 Nov 2011 16:40:58 -0800
Message-Id: <1322527258-31232-1-git-send-email-thomas@cozybit.com> (sfid-20111129_014110_690482_22DB88EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This RFC generated some discussion last time it was submitted:
http://www.mail-archive.com/devel@lists.open80211s.org/msg00806.html. An
outstanding question is whether the ath9k_htc cards support multiple beaconing
vifs or not, the code seems to contradict itself:

htc_drv_main.c:


        if (priv->num_ibss_vif ||
            (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
                ath_err(common, "IBSS coexistence with other modes is not allowed\n");
                mutex_unlock(&priv->mutex);
                return -ENOBUFS;
        }

[...]

        if (((vif->type == NL80211_IFTYPE_AP) ||
             (vif->type == NL80211_IFTYPE_ADHOC) ||
             (vif->type == NL80211_IFTYPE_MESH_POINT)) &&
            ((priv->num_ap_vif + priv->num_ibss_vif + priv->num_mbss_vif) >=
                                                      ATH9K_HTC_MAX_BCN_VIF)) {
                ath_err(common, "Max. number of beaconing interfaces reached\n");
                mutex_unlock(&priv->mutex);
                return -ENOBUFS;
        }

So if we try to add an IBSS vif while another vif is up, don't allow it. Later
we make sure the number of beaconing vifs is not above some max. The latter
seems to indicate some support for mulitple beaconing vifs. Which one is it?

Thomas

---

More specifically, enable AP-style beaconing on mesh ifaces, honor
FIF_OTHER_BSS filter and change the hw capabilities to reflect mesh
support.

Also enable IEEE80211_HW_SUPPORTS_PER_STA_GTK, IEEE80211_HW_MFP_CAPABLE
and WIPHY_FLAG_IBSS_RSN.  Probably these should depend on the
capabilities of the hardware but I don't know which hardware supports
what.  But these are required for secured mesh and work fine on our
TL-WN821N

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    7 +++++++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   15 ++++++++++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    6 +++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   19 +++++++++++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |    2 +-
 5 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index da55967..62a2c9c 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -207,6 +207,9 @@ struct ath9k_htc_target_rx_stats {
 		case NL80211_IFTYPE_AP:		\
 			_priv->num_ap_vif++;	\
 			break;			\
+		case NL80211_IFTYPE_MESH_POINT:	\
+			_priv->num_mbss_vif++;	\
+			break;			\
 		default:			\
 			break;			\
 		}				\
@@ -223,6 +226,9 @@ struct ath9k_htc_target_rx_stats {
 		case NL80211_IFTYPE_AP:		\
 			_priv->num_ap_vif--;	\
 			break;			\
+		case NL80211_IFTYPE_MESH_POINT:	\
+			_priv->num_mbss_vif--;	\
+			break;			\
 		default:			\
 			break;			\
 		}				\
@@ -437,6 +443,7 @@ struct ath9k_htc_priv {
 	u8 sta_slot;
 	u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
 	u8 num_ibss_vif;
+	u8 num_mbss_vif;
 	u8 num_sta_vif;
 	u8 num_sta_assoc_vif;
 	u8 num_ap_vif;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 57fe22b..d0046cc 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -28,7 +28,8 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 
 	ath9k_hw_get_txq_props(ah, priv->beaconq, &qi);
 
-	if (priv->ah->opmode == NL80211_IFTYPE_AP) {
+	if (priv->ah->opmode == NL80211_IFTYPE_AP ||
+	    priv->ah->opmode == NL80211_IFTYPE_MESH_POINT) {
 		qi.tqi_aifs = 1;
 		qi.tqi_cwmin = 0;
 		qi.tqi_cwmax = 0;
@@ -633,6 +634,12 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 	case NL80211_IFTYPE_ADHOC:
 		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* 802.11s defines a different beaconing method for
+		 * mesh points that closely resembles AP-style
+		 * beaconing.  Until that is implemented, just use
+		 * AP-style beaconing for mesh points. */
+		/* Fall through */
 	case NL80211_IFTYPE_AP:
 		ath9k_htc_beacon_config_ap(priv, cur_conf);
 		break;
@@ -655,6 +662,12 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
 	case NL80211_IFTYPE_ADHOC:
 		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* 802.11s defines a different beaconing method for
+		 * mesh points that closely resembles AP-style
+		 * beaconing.  Until that is implemented, just use
+		 * AP-style beaconing for mesh points. */
+		/* Fall through */
 	case NL80211_IFTYPE_AP:
 		ath9k_htc_beacon_config_ap(priv, cur_conf);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 966661c..8617865 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -732,6 +732,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		IEEE80211_HW_SUPPORTS_PER_STA_GTK |
+		IEEE80211_HW_MFP_CAPABLE |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	hw->wiphy->interface_modes =
@@ -739,9 +741,11 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_P2P_GO) |
-		BIT(NL80211_IFTYPE_P2P_CLIENT);
+		BIT(NL80211_IFTYPE_P2P_CLIENT) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
 	hw->queues = 4;
 	hw->channel_change_time = 5000;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0b9a0e8..5b8e322 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -173,6 +173,8 @@ static void ath9k_htc_set_opmode(struct ath9k_htc_priv *priv)
 		priv->ah->opmode = NL80211_IFTYPE_ADHOC;
 	else if (priv->num_ap_vif)
 		priv->ah->opmode = NL80211_IFTYPE_AP;
+	else if (priv->num_mbss_vif)
+		priv->ah->opmode = NL80211_IFTYPE_MESH_POINT;
 	else
 		priv->ah->opmode = NL80211_IFTYPE_STATION;
 
@@ -1054,9 +1056,18 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		return -ENOBUFS;
 	}
 
+	if (priv->num_mbss_vif ||
+	    (priv->nvifs && vif->type == NL80211_IFTYPE_MESH_POINT)) {
+		ath_err(common, "Mesh BSS coexistence with other modes is not allowed\n");
+		mutex_unlock(&priv->mutex);
+		return -ENOBUFS;
+	}
+
 	if (((vif->type == NL80211_IFTYPE_AP) ||
-	     (vif->type == NL80211_IFTYPE_ADHOC)) &&
-	    ((priv->num_ap_vif + priv->num_ibss_vif) >= ATH9K_HTC_MAX_BCN_VIF)) {
+	     (vif->type == NL80211_IFTYPE_ADHOC) ||
+	     (vif->type == NL80211_IFTYPE_MESH_POINT)) &&
+	    ((priv->num_ap_vif + priv->num_ibss_vif + priv->num_mbss_vif) >=
+						      ATH9K_HTC_MAX_BCN_VIF)) {
 		ath_err(common, "Max. number of beaconing interfaces reached\n");
 		mutex_unlock(&priv->mutex);
 		return -ENOBUFS;
@@ -1076,6 +1087,9 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_AP:
 		hvif.opmode = HTC_M_HOSTAP;
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		hvif.opmode = HTC_M_WDS;	/* close enough */
+		break;
 	default:
 		ath_err(common,
 			"Interface type %d not yet supported\n", vif->type);
@@ -1108,6 +1122,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	INC_VIF(priv, vif->type);
 
 	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_MESH_POINT) ||
 	    (vif->type == NL80211_IFTYPE_ADHOC))
 		ath9k_htc_assign_bslot(priv, vif);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2d81c70..f66f2ae 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -889,7 +889,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	if (priv->rxfilter & FIF_PSPOLL)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
-	if (priv->nvifs > 1)
+	if (priv->nvifs > 1 || priv->rxfilter & FIF_OTHER_BSS)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 
 	return rfilt;
-- 
1.7.5.4

