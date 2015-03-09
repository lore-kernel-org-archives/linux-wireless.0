Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41319 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbbCINjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 09:39:05 -0400
Received: by lbvp9 with SMTP id p9so48059584lbv.8
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 06:39:03 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/2] ath10k: add hw connection monitor support
Date: Mon,  9 Mar 2015 14:36:37 +0100
Message-Id: <1425908197-16118-2-git-send-email-michal.kazior@tieto.com> (sfid-20150309_143909_578942_C5DF72BA)
In-Reply-To: <1425908197-16118-1-git-send-email-michal.kazior@tieto.com>
References: <87fv9hyz2r.fsf@kamboji.qca.qualcomm.com>
 <1425908197-16118-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some firmware revisions (e.g. qca6174 with fw73)
don't deliver beacons to host reliably. This
causes random disconnects even in perfect
conditions. This is most visible with
multi-channel operation.

All available firmware revisions seem to support
beacon miss offloading so there shouldn't be any
problems.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * conflict resolution hint: base of this patchset
       (af695a659c69d347948ceab2c562e208ba48b26e) doesn't
       include `ath10k: fix patching mistake for AP/IBSS CSA`
       yet. Whichever you apply first you'll end up with a
       conflict in ath10k_bss_disassoc(). Eventually the
       data_lock goes away from there.

 drivers/net/wireless/ath/ath10k/core.h |  2 +
 drivers/net/wireless/ath/ath10k/mac.c  | 77 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.h  |  2 +
 drivers/net/wireless/ath/ath10k/wmi.c  |  7 +++-
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9b8f486..c1f43b0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -43,6 +43,7 @@
 #define ATH10K_SCAN_ID 0
 #define WMI_READY_TIMEOUT (5 * HZ)
 #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
+#define ATH10K_CONNECTION_LOSS_HZ (3*HZ)
 #define ATH10K_NUM_CHANS 38
 
 /* Antenna noise floor */
@@ -342,6 +343,7 @@ struct ath10k_vif {
 	int txpower;
 	struct wmi_wmm_params_all_arg wmm_params;
 	struct work_struct ap_csa_work;
+	struct delayed_work connection_loss_work;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1138f4f..d672e05 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1503,6 +1503,75 @@ static void ath10k_mac_vif_ap_csa_work(struct work_struct *work)
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void ath10k_mac_handle_beacon_iter(void *data, u8 *mac,
+					  struct ieee80211_vif *vif)
+{
+	struct sk_buff *skb = data;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (!ether_addr_equal(mgmt->bssid, vif->bss_conf.bssid))
+		return;
+
+	cancel_delayed_work(&arvif->connection_loss_work);
+}
+
+void ath10k_mac_handle_beacon(struct ath10k *ar, struct sk_buff *skb)
+{
+	ieee80211_iterate_active_interfaces_atomic(ar->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath10k_mac_handle_beacon_iter,
+						   skb);
+}
+
+static void ath10k_mac_handle_beacon_miss_iter(void *data, u8 *mac,
+					       struct ieee80211_vif *vif)
+{
+	u32 *vdev_id = data;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_hw *hw = ar->hw;
+
+	if (arvif->vdev_id != *vdev_id)
+		return;
+
+	if (!arvif->is_up)
+		return;
+
+	ieee80211_beacon_loss(vif);
+
+	/* Firmware doesn't report beacon loss events repeatedly. If AP probe
+	 * (done by mac80211) succeeds but beacons do not resume then it
+	 * doesn't make sense to continue operation. Queue connection loss work
+	 * which can be cancelled when beacon is received.
+	 */
+	ieee80211_queue_delayed_work(hw, &arvif->connection_loss_work,
+				     ATH10K_CONNECTION_LOSS_HZ);
+}
+
+void ath10k_mac_handle_beacon_miss(struct ath10k *ar, u32 vdev_id)
+{
+	ieee80211_iterate_active_interfaces_atomic(ar->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath10k_mac_handle_beacon_miss_iter,
+						   &vdev_id);
+}
+
+static void ath10k_mac_vif_sta_connection_loss_work(struct work_struct *work)
+{
+	struct ath10k_vif *arvif = container_of(work, struct ath10k_vif,
+						connection_loss_work.work);
+	struct ieee80211_vif *vif = arvif->vif;
+
+	if (!arvif->is_up)
+		return;
+
+	ieee80211_connection_loss(vif);
+}
+
 /**********************/
 /* Station management */
 /**********************/
@@ -2139,6 +2208,8 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	spin_lock_bh(&arvif->ar->data_lock);
 	arvif->is_up = false;
 	spin_unlock_bh(&arvif->ar->data_lock);
+
+	cancel_delayed_work_sync(&arvif->connection_loss_work);
 }
 
 static int ath10k_station_assoc(struct ath10k *ar,
@@ -3377,6 +3448,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	INIT_LIST_HEAD(&arvif->list);
 	INIT_WORK(&arvif->ap_csa_work, ath10k_mac_vif_ap_csa_work);
+	INIT_DELAYED_WORK(&arvif->connection_loss_work,
+			  ath10k_mac_vif_sta_connection_loss_work);
 
 	if (ar->free_vdev_map == 0) {
 		ath10k_warn(ar, "Free vdev map is empty, no more interfaces allowed.\n");
@@ -3595,6 +3668,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	int ret;
 
 	cancel_work_sync(&arvif->ap_csa_work);
+	cancel_delayed_work_sync(&arvif->connection_loss_work);
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -5726,7 +5800,8 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT |
-			IEEE80211_HW_SW_CRYPTO_CONTROL;
+			IEEE80211_HW_SW_CRYPTO_CONTROL |
+			IEEE80211_HW_CONNECTION_MONITOR;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 6829611..3b64d99 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -45,6 +45,8 @@ void ath10k_mac_vif_beacon_free(struct ath10k_vif *arvif);
 void ath10k_drain_tx(struct ath10k *ar);
 bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
 				    u8 keyidx);
+void ath10k_mac_handle_beacon(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_mac_handle_beacon_miss(struct ath10k *ar, u32 vdev_id);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 58719d8..54430a1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1586,6 +1586,9 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		}
 	}
 
+	if (ieee80211_is_beacon(hdr->frame_control))
+		ath10k_mac_handle_beacon(ar, skb);
+
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx skb %p len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
@@ -2815,8 +2818,10 @@ void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb)
 			    reason, vdev_id);
 
 	switch (reason) {
-	case WMI_ROAM_REASON_BETTER_AP:
 	case WMI_ROAM_REASON_BEACON_MISS:
+		ath10k_mac_handle_beacon_miss(ar, vdev_id);
+		break;
+	case WMI_ROAM_REASON_BETTER_AP:
 	case WMI_ROAM_REASON_LOW_RSSI:
 	case WMI_ROAM_REASON_SUITABLE_AP_FOUND:
 	case WMI_ROAM_REASON_HO_FAILED:
-- 
1.8.5.3

