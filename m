Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38789 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaCCJIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 04:08:36 -0500
Received: by mail-ee0-f42.google.com with SMTP id d17so3910953eek.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2014 01:08:34 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH V2] ath10k: add recalc RTS/CTS protection method
Date: Mon,  3 Mar 2014 10:07:41 +0100
Message-Id: <1393837661-15235-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140303_100841_476791_6C8B7361)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add recalculation of RTS/CTS protection when one or more legacy
stations are connected to ath10k. In this case enable RTS/CTS
protection and set sw retry profile are needed in the FW.
Without this change legacy station is starved and has very low
throughput.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    2 ++
 drivers/net/wireless/ath/ath10k/mac.c  |   57 +++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h  |   13 ++++++++
 3 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0e71979..ad209a6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -260,6 +260,8 @@ struct ath10k_vif {
 	u8 fixed_rate;
 	u8 fixed_nss;
 	u8 force_sgi;
+	bool use_cts_prot;
+	int num_legacy_stations;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9230ad5..2a5c8c2 100644
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
@@ -1534,6 +1554,16 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 		return ret;
 	}
 
+	if (!sta->wme) {
+		arvif->num_legacy_stations++;
+		ret  = ath10k_recalc_rtscts_prot(arvif);
+		if (ret) {
+			ath10k_warn("failed to recalculate rts/cts prot for vdev %d: %d\n",
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
 		ath10k_warn("could not install peer wep keys (%d)\n", ret);
@@ -1557,6 +1587,16 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (!sta->wme) {
+		arvif->num_legacy_stations--;
+		ret = ath10k_recalc_rtscts_prot(arvif);
+		if (ret) {
+			ath10k_warn("failed to recalculate rts/cts prot for vdev %d: %d\n",
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
 		ath10k_warn("could not clear all peer wep keys (%d)\n", ret);
@@ -2840,21 +2880,14 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
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
+			ath10k_warn("failed to recalculate rts/cts prot for vdev %d: %d\n",
+				    arvif->vdev_id, ret);
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
1.7.9.5

