Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:59749 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaB1HSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 02:18:55 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so2434821eak.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 23:18:54 -0800 (PST)
From: bartosz.markowski@tieto.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH] ath10k: add recalc RTS/CTS protection method
Date: Fri, 28 Feb 2014 08:18:28 +0100
Message-Id: <1393571908-23734-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140228_081859_785291_EB094D00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Kwaczynski <marek.kwaczynski@tieto.com>

Add recalculation of RTS/CTS protection when one or more legacy
stations are connected to ath10k. In this case enable RTS/CTS
protection and set sw retry profile are needed in the FW.
Without this change legacy station is starved and has very low
throughput.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    3 ++
 drivers/net/wireless/ath/ath10k/mac.c  |   57 +++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h  |   13 ++++++++
 3 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d1c5e7a..c0e4fae 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -289,6 +289,9 @@ struct ath10k_vif {
 	u8 fixed_rate;
 	u8 fixed_nss;
 	u8 force_sgi;
+
+	bool use_cts_prot;
+	int num_legacy_stations;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 239357f..96b0f59 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -723,6 +723,26 @@ static int ath10k_monitor_destroy(struct ath10k *ar)
 	return ret;
 }
 
+static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	u32 vdev_param, rts_cts = 0;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	vdev_param = ar->wmi.vdev_param->enable_rtscts;
+
+	if (arvif->use_cts_prot || arvif->num_legacy_stations > 0)
+		rts_cts |= SM(WMI_RTSCTS_ENABLED, WMI_RTSCTS_SET);
+
+	if (arvif->num_legacy_stations > 0)
+		rts_cts |= SM(WMI_RTSCTS_ACROSS_SW_RETRIES,
+			      WMI_RTSCTS_PROFILE);
+
+	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+					 rts_cts);
+}
+
 static int ath10k_start_cac(struct ath10k *ar)
 {
 	int ret;
@@ -1532,6 +1552,16 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 		return ret;
 	}
 
+	if (!sta->wme) {
+		arvif->num_legacy_stations++;
+		ret = ath10k_recalc_rtscts_prot(arvif);
+		if (ret) {
+			ath10k_warn("Failed to recalculate RTS/CTS: %d\n",
+				    ret);
+			return ret;
+		}
+	}
+
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
 		ath10k_warn("could not install peer wep keys (%d)\n", ret);
@@ -1555,6 +1585,16 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (!sta->wme) {
+		arvif->num_legacy_stations--;
+		ret = ath10k_recalc_rtscts_prot(arvif);
+		if (ret) {
+			ath10k_warn("failed to recalc RTS/CTS %d\n",
+				    ret);
+			return ret;
+		}
+	}
+
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
 		ath10k_warn("could not clear all peer wep keys (%d)\n", ret);
@@ -2838,21 +2878,14 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ath10k_control_beaconing(arvif, info);
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		u32 cts_prot;
-		if (info->use_cts_prot)
-			cts_prot = 1;
-		else
-			cts_prot = 0;
-
+		arvif->use_cts_prot = info->use_cts_prot;
 		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d cts_prot %d\n",
-			   arvif->vdev_id, cts_prot);
+			   arvif->vdev_id, info->use_cts_prot);
 
-		vdev_param = ar->wmi.vdev_param->enable_rtscts;
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-						cts_prot);
+		ret = ath10k_recalc_rtscts_prot(arvif);
 		if (ret)
-			ath10k_warn("Failed to set CTS prot for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("failed to recalc RTS/CTS prot %d\n",
+				    ret);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4fcc96a..e78a7ad 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2210,6 +2210,19 @@ enum ath10k_protmode {
 	ATH10K_PROT_RTSCTS   = 2,    /* RTS-CTS */
 };
 
+enum wmi_rtscts_profile {
+	WMI_RTSCTS_FOR_NO_RATESERIES = 0,
+	WMI_RTSCTS_FOR_SECOND_RATESERIES,
+	WMI_RTSCTS_ACROSS_SW_RETRIES
+};
+
+#define WMI_RTSCTS_ENABLED		1
+#define WMI_RTSCTS_SET_MASK		0x0f
+#define WMI_RTSCTS_SET_LSB		0
+
+#define WMI_RTSCTS_PROFILE_MASK		0xf0
+#define WMI_RTSCTS_PROFILE_LSB		4
+
 enum wmi_beacon_gen_mode {
 	WMI_BEACON_STAGGERED_MODE = 0,
 	WMI_BEACON_BURST_MODE = 1
-- 
1.7.10

