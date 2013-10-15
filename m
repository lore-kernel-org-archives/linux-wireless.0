Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:60123 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab3JOSqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 14:46:47 -0400
Subject: [PATCH 1/7] ath10k: use workqueue to set WEP TX key
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:46:44 +0300
Message-ID: <20131015184644.14123.424.stgit@localhost6.localdomain6> (sfid-20131015_204650_278083_54FE5FEB)
In-Reply-To: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Recent WMI/HTC changes made it possible for WMI
commands to sleep (if there's not enough HTC TX
credits to submit a command). TX path is in an
atomic context so calling WMI commands in it is
wrong.

This simply moves WEP key index update to a worker
and fixes the 'scheduling while atomic' bug.

This still leaves multiple WEP key handling laggy,
i.e. some frames may be TXed with an old/different
key (although recipient should still be able to RX
them).

kvalo: changed the title

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    4 ++
 drivers/net/wireless/ath/ath10k/mac.c  |   53 ++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ce36daa..cef5455 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -215,8 +215,10 @@ struct ath10k_vif {
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
 
+	struct work_struct wep_key_work;
 	struct ieee80211_key_conf *wep_keys[WMI_MAX_KEY_INDEX + 1];
-	u8 def_wep_key_index;
+	u8 def_wep_key_idx;
+	u8 def_wep_key_newidx;
 
 	u16 tx_seq_no;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97d7111..bc0e17b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1239,7 +1239,7 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	/* FIXME: why don't we print error if wmi call fails? */
 	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
 
-	arvif->def_wep_key_index = 0;
+	arvif->def_wep_key_idx = 0;
 }
 
 static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
@@ -1467,6 +1467,30 @@ static void ath10k_tx_h_qos_workaround(struct ieee80211_hw *hw,
 	skb_pull(skb, IEEE80211_QOS_CTL_LEN);
 }
 
+static void ath10k_tx_wep_key_work(struct work_struct *work)
+{
+	struct ath10k_vif *arvif = container_of(work, struct ath10k_vif,
+						wep_key_work);
+	int ret, keyidx = arvif->def_wep_key_newidx;
+
+	if (arvif->def_wep_key_idx == keyidx)
+		return;
+
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d set keyidx %d\n",
+		   arvif->vdev_id, keyidx);
+
+	ret = ath10k_wmi_vdev_set_param(arvif->ar,
+					arvif->vdev_id,
+					arvif->ar->wmi.vdev_param->def_keyid,
+					keyidx);
+	if (ret) {
+		ath10k_warn("could not update wep keyidx (%d)\n", ret);
+		return;
+	}
+
+	arvif->def_wep_key_idx = keyidx;
+}
+
 static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1475,8 +1499,6 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	struct ath10k *ar = arvif->ar;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_key_conf *key = info->control.hw_key;
-	u32 vdev_param;
-	int ret;
 
 	if (!ieee80211_has_protected(hdr->frame_control))
 		return;
@@ -1488,21 +1510,14 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	    key->cipher != WLAN_CIPHER_SUITE_WEP104)
 		return;
 
-	if (key->keyidx == arvif->def_wep_key_index)
-		return;
-
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d keyidx %d\n",
-		   arvif->vdev_id, key->keyidx);
-
-	vdev_param = ar->wmi.vdev_param->def_keyid;
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-					key->keyidx);
-	if (ret) {
-		ath10k_warn("could not update wep keyidx (%d)\n", ret);
+	if (key->keyidx == arvif->def_wep_key_idx)
 		return;
-	}
 
-	arvif->def_wep_key_index = key->keyidx;
+	/* FIXME: Most likely a few frames will be TXed with an old key. Simply
+	 * queueing frames until key index is updated is not an option because
+	 * sk_buff may need more processing to be done, e.g. offchannel */
+	arvif->def_wep_key_newidx = key->keyidx;
+	ieee80211_queue_work(ar->hw, &arvif->wep_key_work);
 }
 
 static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar, struct sk_buff *skb)
@@ -2023,6 +2038,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->ar = ar;
 	arvif->vif = vif;
 
+	INIT_WORK(&arvif->wep_key_work, ath10k_tx_wep_key_work);
+
 	if ((vif->type == NL80211_IFTYPE_MONITOR) && ar->monitor_present) {
 		ath10k_warn("Only one monitor interface allowed\n");
 		ret = -EBUSY;
@@ -2078,7 +2095,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	vdev_param = ar->wmi.vdev_param->def_keyid;
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
-					arvif->def_wep_key_index);
+					arvif->def_wep_key_idx);
 	if (ret)
 		ath10k_warn("Failed to set default keyid: %d\n", ret);
 
@@ -2147,6 +2164,8 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	cancel_work_sync(&arvif->wep_key_work);
+
 	spin_lock_bh(&ar->data_lock);
 	if (arvif->beacon) {
 		dev_kfree_skb_any(arvif->beacon);

