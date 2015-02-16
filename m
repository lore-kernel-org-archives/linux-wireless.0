Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:54038 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbBPMf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 07:35:59 -0500
Received: by mail-we0-f173.google.com with SMTP id w55so28952294wes.4
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2015 04:35:58 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: fix AP/IBSS CSA with template based fw
Date: Mon, 16 Feb 2015 13:34:54 +0100
Message-Id: <1424090094-28164-1-git-send-email-michal.kazior@tieto.com> (sfid-20150216_133603_400338_C362CD31)
In-Reply-To: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
References: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca6174 with wmi-tlv firmware uses offloaded
beaconing scheme (i.e. templates). This requires a
little different approach when implementing CSA.

Add missing code to update CS count and report CSA
completion to mac80211. Without it channel switch
was never finished.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * rebased
     * remove data_lock usage (it wasn't necessary after all)
     * add lockdep
     * add sanity WARN_ON
     * check for csa_active before queueing ap csa work too

 drivers/net/wireless/ath/ath10k/core.h    |  1 +
 drivers/net/wireless/ath/ath10k/mac.c     | 68 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  6 +++
 3 files changed, 75 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cba781..726c6e5 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -340,6 +340,7 @@ struct ath10k_vif {
 	int num_legacy_stations;
 	int txpower;
 	struct wmi_wmm_params_all_arg wmm_params;
+	struct work_struct ap_csa_work;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f39af7..5440596 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1056,6 +1056,10 @@ static int ath10k_mac_setup_bcn_tmpl(struct ath10k_vif *arvif)
 	if (!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map))
 		return 0;
 
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+		return 0;
+
 	bcn = ieee80211_beacon_get_template(hw, vif, &offs);
 	if (!bcn) {
 		ath10k_warn(ar, "failed to get beacon template from mac80211\n");
@@ -1101,6 +1105,9 @@ static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
 	if (!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map))
 		return 0;
 
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
+		return 0;
+
 	prb = ieee80211_proberesp_get(hw, vif);
 	if (!prb) {
 		ath10k_warn(ar, "failed to get probe resp template from mac80211\n");
@@ -1336,6 +1343,54 @@ static int ath10k_mac_vif_disable_keepalive(struct ath10k_vif *arvif)
 	return 0;
 }
 
+static void ath10k_mac_vif_ap_csa_count_down(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_vif *vif = arvif->vif;
+	int ret;
+
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
+	if (WARN_ON(!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map)))
+		return;
+
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
+		return;
+
+	if (!vif->csa_active)
+		return;
+
+	if (!arvif->is_up)
+		return;
+
+	if (!ieee80211_csa_is_complete(vif)) {
+		ieee80211_csa_update_counter(vif);
+
+		ret = ath10k_mac_setup_bcn_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to update bcn tmpl during csa: %d\n",
+				    ret);
+
+		ret = ath10k_mac_setup_prb_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to update prb tmpl during csa: %d\n",
+				    ret);
+	} else {
+		ieee80211_csa_finish(vif);
+	}
+}
+
+static void ath10k_mac_vif_ap_csa_work(struct work_struct *work)
+{
+	struct ath10k_vif *arvif = container_of(work, struct ath10k_vif,
+						ap_csa_work);
+	struct ath10k *ar = arvif->ar;
+
+	mutex_lock(&ar->conf_mutex);
+	ath10k_mac_vif_ap_csa_count_down(arvif);
+	mutex_unlock(&ar->conf_mutex);
+}
+
 /**********************/
 /* Station management */
 /**********************/
@@ -3022,6 +3077,16 @@ static void ath10k_config_chan(struct ath10k *ar)
 		if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
 			continue;
 
+		ret = ath10k_mac_setup_bcn_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to update bcn tmpl during csa: %d\n",
+				    ret);
+
+		ret = ath10k_mac_setup_prb_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to update prb tmpl during csa: %d\n",
+				    ret);
+
 		ret = ath10k_vdev_restart(arvif);
 		if (ret) {
 			ath10k_warn(ar, "failed to restart vdev %d: %d\n",
@@ -3182,6 +3247,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->vif = vif;
 
 	INIT_LIST_HEAD(&arvif->list);
+	INIT_WORK(&arvif->ap_csa_work, ath10k_mac_vif_ap_csa_work);
 
 	if (ar->free_vdev_map == 0) {
 		ath10k_warn(ar, "Free vdev map is empty, no more interfaces allowed.\n");
@@ -3399,6 +3465,8 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret;
 
+	cancel_work_sync(&arvif->ap_csa_work);
+
 	mutex_lock(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f34baa0..94c4425 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -17,6 +17,7 @@
 #include "core.h"
 #include "debug.h"
 #include "hw.h"
+#include "mac.h"
 #include "wmi.h"
 #include "wmi-ops.h"
 #include "wmi-tlv.h"
@@ -168,6 +169,7 @@ static int ath10k_wmi_tlv_event_bcn_tx_status(struct ath10k *ar,
 {
 	const void **tb;
 	const struct wmi_tlv_bcn_tx_status_ev *ev;
+	struct ath10k_vif *arvif;
 	u32 vdev_id, tx_status;
 	int ret;
 
@@ -201,6 +203,10 @@ static int ath10k_wmi_tlv_event_bcn_tx_status(struct ath10k *ar,
 		break;
 	}
 
+	arvif = ath10k_get_arvif(ar, vdev_id);
+	if (arvif && arvif->is_up && arvif->vif->csa_active)
+		ieee80211_queue_work(ar->hw, &arvif->ap_csa_work);
+
 	kfree(tb);
 	return 0;
 }
-- 
1.8.5.3

