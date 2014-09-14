Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49970 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaINJm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:42:57 -0400
Subject: [PATCH 04/10] ath10k: fix missing a blank line after declarations
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:17 +0300
Message-ID: <20140914095017.9063.87892.stgit@x230> (sfid-20140914_114300_029767_7703E76B)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

WARNING: Missing a blank line after declarations

Please note that some of the cases I fixed by moving the variable declarations
to the beginning of the function, which is the preferred style in ath10k.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   10 +++++++---
 drivers/net/wireless/ath/ath10k/mac.c    |    6 ++----
 drivers/net/wireless/ath/ath10k/wmi.c    |    8 ++++++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1e69db52e465..26196ed947bc 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -222,6 +222,7 @@ static void ath10k_htt_rx_msdu_buff_replenish(struct ath10k_htt *htt)
 static void ath10k_htt_rx_ring_refill_retry(unsigned long arg)
 {
 	struct ath10k_htt *htt = (struct ath10k_htt *)arg;
+
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
@@ -313,7 +314,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 {
 	struct ath10k *ar = htt->ar;
 	int msdu_len, msdu_chaining = 0;
-	struct sk_buff *msdu;
+	struct sk_buff *msdu, *next;
 	struct htt_rx_desc *rx_desc;
 
 	lockdep_assert_held(&htt->rx_ring.lock);
@@ -450,7 +451,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			msdu->next = NULL;
 			break;
 		} else {
-			struct sk_buff *next = ath10k_htt_rx_netbuf_pop(htt);
+			next = ath10k_htt_rx_netbuf_pop(htt);
 			msdu->next = next;
 			msdu = next;
 		}
@@ -479,6 +480,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 static void ath10k_htt_rx_replenish_task(unsigned long ptr)
 {
 	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
+
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
@@ -636,8 +638,10 @@ static struct ieee80211_hdr *ath10k_htt_rx_skb_get_hdr(struct sk_buff *skb)
 /* This function only applies for first msdu in an msdu chain */
 static bool ath10k_htt_rx_hdr_is_amsdu(struct ieee80211_hdr *hdr)
 {
+	u8 *qc;
+
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		u8 *qc = ieee80211_get_qos_ctl(hdr);
+		qc = ieee80211_get_qos_ctl(hdr);
 		if (qc[0] & 0x80)
 			return true;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 75b30adfd367..c1cf6ff319e8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1157,6 +1157,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 {
 	const struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	int i, n;
+	u32 stbc;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -1193,7 +1194,6 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	}
 
 	if (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC) {
-		u32 stbc;
 		stbc = ht_cap->cap & IEEE80211_HT_CAP_RX_STBC;
 		stbc = stbc >> IEEE80211_HT_CAP_RX_STBC_SHIFT;
 		stbc = stbc << WMI_RC_RX_STBC_FLAG_S;
@@ -3011,7 +3011,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret = 0;
-	u32 vdev_param, pdev_param;
+	u32 vdev_param, pdev_param, slottime, preamble;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -3132,7 +3132,6 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		u32 slottime;
 		if (info->use_short_slot)
 			slottime = WMI_VDEV_SLOT_TIME_SHORT; /* 9us */
 
@@ -3151,7 +3150,6 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		u32 preamble;
 		if (info->use_short_preamble)
 			preamble = WMI_VDEV_PREAMBLE_SHORT;
 		else
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ed438edb9763..6b9f38b8b827 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -612,6 +612,7 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
+
 	ret = wait_for_completion_timeout(&ar->wmi.service_ready,
 					  WMI_SERVICE_READY_TIMEOUT_HZ);
 	return ret;
@@ -620,6 +621,7 @@ int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar)
 {
 	int ret;
+
 	ret = wait_for_completion_timeout(&ar->wmi.unified_ready,
 					  WMI_UNIFIED_READY_TIMEOUT_HZ);
 	return ret;
@@ -1384,6 +1386,8 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 	struct ieee80211_tim_ie *tim;
 	u8 *ies, *ie;
 	u8 ie_len, pvm_len;
+	__le32 t;
+	u32 v;
 
 	/* if next SWBA has no tim_changed the tim_bitmap is garbage.
 	 * we must copy the bitmap upon change and reuse it later */
@@ -1394,8 +1398,8 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 			     sizeof(bcn_info->tim_info.tim_bitmap));
 
 		for (i = 0; i < sizeof(arvif->u.ap.tim_bitmap); i++) {
-			__le32 t = bcn_info->tim_info.tim_bitmap[i / 4];
-			u32 v = __le32_to_cpu(t);
+			t = bcn_info->tim_info.tim_bitmap[i / 4];
+			v = __le32_to_cpu(t);
 			arvif->u.ap.tim_bitmap[i] = (v >> ((i % 4) * 8)) & 0xFF;
 		}
 

