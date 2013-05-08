Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:33742 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3EHRSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 13:18:53 -0400
Received: by mail-da0-f47.google.com with SMTP id k13so1098631dae.20
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 10:18:53 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath9k <ath9k-devel@lists.ath9k.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/3] ath9k_htc: Add support for mesh interfaces
Date: Wed,  8 May 2013 10:16:46 -0700
Message-Id: <1368033408-3994-1-git-send-email-thomas@cozybit.com> (sfid-20130508_191857_542947_5935F1F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

More specifically, enable AP-style beaconing on mesh
ifaces and change the hw capabilities to reflect mesh
support.

Coexistence with a virtual STA interface was tested as
working fine.

Signed-off-by: Javier Cardona <javier@cozybit.com>
[rebase, add iface combinations]
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    7 ++++++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    5 +++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    6 +++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   29 ++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |    2 +-
 5 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index d3b099d..0085e64 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -208,6 +208,9 @@ struct ath9k_htc_target_rx_stats {
 		case NL80211_IFTYPE_AP:		\
 			_priv->num_ap_vif++;	\
 			break;			\
+		case NL80211_IFTYPE_MESH_POINT:	\
+			_priv->num_mbss_vif++;	\
+			break;			\
 		default:			\
 			break;			\
 		}				\
@@ -224,6 +227,9 @@ struct ath9k_htc_target_rx_stats {
 		case NL80211_IFTYPE_AP:		\
 			_priv->num_ap_vif--;	\
 			break;			\
+		case NL80211_IFTYPE_MESH_POINT:	\
+			_priv->num_mbss_vif--;	\
+			break;			\
 		default:			\
 			break;			\
 		}				\
@@ -450,6 +456,7 @@ struct ath9k_htc_priv {
 	u8 sta_slot;
 	u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
 	u8 num_ibss_vif;
+	u8 num_mbss_vif;
 	u8 num_sta_vif;
 	u8 num_sta_assoc_vif;
 	u8 num_ap_vif;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index f13f458..e0c03bd 100644
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
@@ -628,6 +629,7 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 	case NL80211_IFTYPE_ADHOC:
 		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		ath9k_htc_beacon_config_ap(priv, cur_conf);
 		break;
@@ -649,6 +651,7 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
 	case NL80211_IFTYPE_ADHOC:
 		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		ath9k_htc_beacon_config_ap(priv, cur_conf);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a47f5e0..6eb4199 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -698,7 +698,8 @@ static const struct ieee80211_iface_limit if_limits[] = {
 	{ .max = 2,	.types = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) },
 	{ .max = 2,	.types = BIT(NL80211_IFTYPE_AP) |
-				 BIT(NL80211_IFTYPE_P2P_GO) },
+				 BIT(NL80211_IFTYPE_P2P_GO) |
+				 BIT(NL80211_IFTYPE_MESH_POINT) },
 };
 
 static const struct ieee80211_iface_combination if_comb = {
@@ -728,7 +729,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_P2P_GO) |
-		BIT(NL80211_IFTYPE_P2P_CLIENT);
+		BIT(NL80211_IFTYPE_P2P_CLIENT) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
 
 	hw->wiphy->iface_combinations = &if_comb;
 	hw->wiphy->n_iface_combinations = 1;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0743a47..2a67b57 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -113,7 +113,9 @@ static void ath9k_htc_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath9k_htc_priv *priv = data;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
-	if ((vif->type == NL80211_IFTYPE_AP) && bss_conf->enable_beacon)
+	if ((vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    bss_conf->enable_beacon)
 		priv->reconfig_beacon = true;
 
 	if (bss_conf->assoc) {
@@ -180,6 +182,8 @@ static void ath9k_htc_set_opmode(struct ath9k_htc_priv *priv)
 		priv->ah->opmode = NL80211_IFTYPE_ADHOC;
 	else if (priv->num_ap_vif)
 		priv->ah->opmode = NL80211_IFTYPE_AP;
+	else if (priv->num_mbss_vif)
+		priv->ah->opmode = NL80211_IFTYPE_MESH_POINT;
 	else
 		priv->ah->opmode = NL80211_IFTYPE_STATION;
 
@@ -1052,6 +1056,9 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_AP:
 		hvif.opmode = HTC_M_HOSTAP;
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		hvif.opmode = HTC_M_WDS;	/* close enough */
+		break;
 	default:
 		ath_err(common,
 			"Interface type %d not yet supported\n", vif->type);
@@ -1084,6 +1091,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	INC_VIF(priv, vif->type);
 
 	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_MESH_POINT) ||
 	    (vif->type == NL80211_IFTYPE_ADHOC))
 		ath9k_htc_assign_bslot(priv, vif);
 
@@ -1134,6 +1142,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	DEC_VIF(priv, vif->type);
 
 	if ((vif->type == NL80211_IFTYPE_AP) ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT ||
 	    (vif->type == NL80211_IFTYPE_ADHOC))
 		ath9k_htc_remove_bslot(priv, vif);
 
@@ -1525,9 +1534,10 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) && !bss_conf->enable_beacon) {
 		/*
 		 * Disable SWBA interrupt only if there are no
-		 * AP/IBSS interfaces.
+		 * concurrent AP/mesh or IBSS interfaces.
 		 */
-		if ((priv->num_ap_vif <= 1) || priv->num_ibss_vif) {
+		if ((priv->num_ap_vif + priv->num_mbss_vif <= 1) ||
+		     priv->num_ibss_vif) {
 			ath_dbg(common, CONFIG,
 				"Beacon disabled for BSS: %pM\n",
 				bss_conf->bssid);
@@ -1538,12 +1548,15 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/*
-		 * Reset the HW TSF for the first AP interface.
+		 * Reset the HW TSF for the first AP or mesh interface.
 		 */
-		if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
-		    (priv->nvifs == 1) &&
-		    (priv->num_ap_vif == 1) &&
-		    (vif->type == NL80211_IFTYPE_AP)) {
+		if (priv->nvifs == 1 &&
+		    ((priv->ah->opmode == NL80211_IFTYPE_AP &&
+		      vif->type == NL80211_IFTYPE_AP &&
+		      priv->num_ap_vif == 1) ||
+		    (priv->ah->opmode == NL80211_IFTYPE_MESH_POINT &&
+		      vif->type == NL80211_IFTYPE_MESH_POINT &&
+		      priv->num_mbss_vif == 1))) {
 			set_bit(OP_TSF_RESET, &priv->op_flags);
 		}
 		ath_dbg(common, CONFIG,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 6bd0e92..e602c95 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -887,7 +887,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	if (priv->rxfilter & FIF_PSPOLL)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
-	if (priv->nvifs > 1)
+	if (priv->nvifs > 1 || priv->rxfilter & FIF_OTHER_BSS)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 
 	return rfilt;
-- 
1.7.10.4

