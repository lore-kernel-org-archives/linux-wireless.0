Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60639 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaAUGHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 01:07:14 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3743347eei.21
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 22:07:13 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] ath10k: AP mode, set UAPSD params correctly
Date: Tue, 21 Jan 2014 07:06:53 +0100
Message-Id: <1390284413-2703-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140121_070719_147639_D237CD23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k handles UAPSD completly in the firmware.
When works in AP mode we have to configure
UAPSD params for each station. Without this
patch we configure UAPSD params before we
send peer assoc command to the FW, which was
wrong. Next FW didn't know what should be trigger
frame, couse UAPSD didn't work correctly in AP mode.
To configure UAPSD params correctly we have to
send them after peer assoc command.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   80 +++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 70fe386..fda146b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1092,27 +1092,20 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 		   arg->peer_num_spatial_streams);
 }
 
-static void ath10k_peer_assoc_h_qos_ap(struct ath10k *ar,
-				       struct ath10k_vif *arvif,
-				       struct ieee80211_sta *sta,
-				       struct ieee80211_bss_conf *bss_conf,
-				       struct wmi_peer_assoc_complete_arg *arg)
+static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
+				    struct ath10k_vif *arvif,
+				    struct ieee80211_sta *sta)
 {
 	u32 uapsd = 0;
 	u32 max_sp = 0;
+	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (sta->wme)
-		arg->peer_flags |= WMI_PEER_QOS;
-
 	if (sta->wme && sta->uapsd_queues) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac uapsd_queues 0x%x max_sp %d\n",
 			   sta->uapsd_queues, sta->max_sp);
 
-		arg->peer_flags |= WMI_PEER_APSD;
-		arg->peer_rate_caps |= WMI_RC_UAPSD_FLAG;
-
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
 			uapsd |= WMI_AP_PS_UAPSD_AC3_DELIVERY_EN |
 				 WMI_AP_PS_UAPSD_AC3_TRIGGER_EN;
@@ -1130,35 +1123,40 @@ static void ath10k_peer_assoc_h_qos_ap(struct ath10k *ar,
 		if (sta->max_sp < MAX_WMI_AP_PS_PEER_PARAM_MAX_SP)
 			max_sp = sta->max_sp;
 
-		ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id,
-					   sta->addr,
-					   WMI_AP_PS_PEER_PARAM_UAPSD,
-					   uapsd);
+		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id,
+						 sta->addr,
+						 WMI_AP_PS_PEER_PARAM_UAPSD,
+						 uapsd);
+		if (ret) {
+			ath10k_warn("failed to set ap ps peer param uapsd: %d\n",
+				    ret);
+			return ret;
+		}
 
-		ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id,
-					   sta->addr,
-					   WMI_AP_PS_PEER_PARAM_MAX_SP,
-					   max_sp);
+		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id,
+						 sta->addr,
+						 WMI_AP_PS_PEER_PARAM_MAX_SP,
+						 max_sp);
+		if (ret) {
+			ath10k_warn("failed to set ap ps peer param max sp: %d\n",
+				    ret);
+			return ret;
+		}
 
 		/* TODO setup this based on STA listen interval and
 		   beacon interval. Currently we don't know
 		   sta->listen_interval - mac80211 patch required.
 		   Currently use 10 seconds */
-		ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id,
-					   sta->addr,
-					   WMI_AP_PS_PEER_PARAM_AGEOUT_TIME,
-					   10);
+		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id, sta->addr,
+					WMI_AP_PS_PEER_PARAM_AGEOUT_TIME, 10);
+		if (ret) {
+			ath10k_warn("failed to set ap ps peer param ageout time: %d\n",
+				    ret);
+			return ret;
+		}
 	}
-}
 
-static void ath10k_peer_assoc_h_qos_sta(struct ath10k *ar,
-					struct ath10k_vif *arvif,
-					struct ieee80211_sta *sta,
-					struct ieee80211_bss_conf *bss_conf,
-					struct wmi_peer_assoc_complete_arg *arg)
-{
-	if (bss_conf->qos)
-		arg->peer_flags |= WMI_PEER_QOS;
+	return 0;
 }
 
 static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
@@ -1211,10 +1209,17 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 {
 	switch (arvif->vdev_type) {
 	case WMI_VDEV_TYPE_AP:
-		ath10k_peer_assoc_h_qos_ap(ar, arvif, sta, bss_conf, arg);
+		if (sta->wme)
+			arg->peer_flags |= WMI_PEER_QOS;
+
+		if (sta->wme && sta->uapsd_queues) {
+			arg->peer_flags |= WMI_PEER_APSD;
+			arg->peer_rate_caps |= WMI_RC_UAPSD_FLAG;
+		}
 		break;
 	case WMI_VDEV_TYPE_STA:
-		ath10k_peer_assoc_h_qos_sta(ar, arvif, sta, bss_conf, arg);
+		if (bss_conf->qos)
+			arg->peer_flags |= WMI_PEER_QOS;
 		break;
 	default:
 		break;
@@ -1412,6 +1417,13 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 		return ret;
 	}
 
+	ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
+	if (ret) {
+		ath10k_warn("could not set qos params for STA %pM, %d\n",
+			    sta->addr, ret);
+		return ret;
+	}
+
 	return ret;
 }
 
-- 
1.7.9.5

