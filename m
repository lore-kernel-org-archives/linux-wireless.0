Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55380 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbbBLNyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 08:54:25 -0500
Received: by mail-lb0-f180.google.com with SMTP id z12so9611227lbi.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 05:54:23 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix AP/IBSS CSA with template based fw
Date: Thu, 12 Feb 2015 14:53:18 +0100
Message-Id: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com> (sfid-20150212_145436_090401_86A020C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca6174 with wmi-tlv firmware uses offloaded
beaconing scheme (i.e. templates). This requires a
little different approach when implementing CSA.

Add missing code to update CS count and report CSA
completion to mac80211. Without it channel switch
was never finished.

To avoid races during interface teardown data_lock
has been used to protect is_up and is_started so
they can be compared against before scheduling
count down work.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

@Kalle: I'm deferring the chanctx patchset v4
until this gets applied. I'd like to avoid posting
patches without a valid parent id and leaving you
with some weird conflicts and implicit depndencies
in the code to deal with.


 drivers/net/wireless/ath/ath10k/core.h    |  1 +
 drivers/net/wireless/ath/ath10k/mac.c     | 70 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  8 ++++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d60e46f..43fa2ec 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -320,6 +320,7 @@ struct ath10k_vif {
 	int num_legacy_stations;
 	int txpower;
 	struct wmi_wmm_params_all_arg wmm_params;
+	struct work_struct ap_csa_work;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d6d2f0f..631e73b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1055,6 +1055,10 @@ static int ath10k_mac_setup_bcn_tmpl(struct ath10k_vif *arvif)
 	if (!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map))
 		return 0;
 
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+		return 0;
+
 	bcn = ieee80211_beacon_get_template(hw, vif, &offs);
 	if (!bcn) {
 		ath10k_warn(ar, "failed to get beacon template from mac80211\n");
@@ -1100,6 +1104,9 @@ static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
 	if (!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map))
 		return 0;
 
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
+		return 0;
+
 	prb = ieee80211_proberesp_get(hw, vif);
 	if (!prb) {
 		ath10k_warn(ar, "failed to get probe resp template from mac80211\n");
@@ -1129,10 +1136,9 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	if (!info->enable_beacon) {
 		ath10k_vdev_stop(arvif);
 
+		spin_lock_bh(&arvif->ar->data_lock);
 		arvif->is_started = false;
 		arvif->is_up = false;
-
-		spin_lock_bh(&arvif->ar->data_lock);
 		ath10k_mac_vif_beacon_free(arvif);
 		spin_unlock_bh(&arvif->ar->data_lock);
 
@@ -1335,6 +1341,49 @@ static int ath10k_mac_vif_disable_keepalive(struct ath10k_vif *arvif)
 	return 0;
 }
 
+static void ath10k_mac_vif_ap_csa_count_down(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_vif *vif = arvif->vif;
+	int ret;
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
@@ -1852,7 +1901,9 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		return;
 	}
 
+	spin_lock_bh(&arvif->ar->data_lock);
 	arvif->is_up = true;
+	spin_unlock_bh(&arvif->ar->data_lock);
 }
 
 static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
@@ -1874,7 +1925,9 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 
 	arvif->def_wep_key_idx = -1;
 
+	spin_lock_bh(&arvif->ar->data_lock);
 	arvif->is_up = false;
+	spin_unlock_bh(&arvif->ar->data_lock);
 }
 
 static int ath10k_station_assoc(struct ath10k *ar,
@@ -2931,6 +2984,16 @@ static void ath10k_config_chan(struct ath10k *ar)
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
@@ -3091,6 +3154,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->vif = vif;
 
 	INIT_LIST_HEAD(&arvif->list);
+	INIT_WORK(&arvif->ap_csa_work, ath10k_mac_vif_ap_csa_work);
 
 	if (ar->free_vdev_map == 0) {
 		ath10k_warn(ar, "Free vdev map is empty, no more interfaces allowed.\n");
@@ -3308,6 +3372,8 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret;
 
+	cancel_work_sync(&arvif->ap_csa_work);
+
 	mutex_lock(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 71614ba..538a643 100644
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
 
@@ -201,6 +203,12 @@ static int ath10k_wmi_tlv_event_bcn_tx_status(struct ath10k *ar,
 		break;
 	}
 
+	spin_lock_bh(&ar->data_lock);
+	arvif = ath10k_get_arvif(ar, vdev_id);
+	if (arvif && arvif->is_up)
+		ieee80211_queue_work(ar->hw, &arvif->ap_csa_work);
+	spin_unlock_bh(&ar->data_lock);
+
 	kfree(tb);
 	return 0;
 }
-- 
1.8.5.3

