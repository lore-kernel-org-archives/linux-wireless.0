Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63729 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3I0OgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 10:36:16 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix scheduling while atomic bug
Date: Fri, 27 Sep 2013 16:36:07 +0200
Message-ID: <1380292567-2363-3-git-send-email-michal.kazior@tieto.com> (sfid-20130927_163621_671061_1F2DB5B3)
In-Reply-To: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
References: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent WMI/HTC changes broke WEP with multiple
keys. If WMI had no HTC TX credits to submit
command for default wep index update it would
trigger a bug.

This simply moves the wep key index update to a
worker.

The key update may happen some time after first
frame with a different wep key has been sent (i.e.
some frames will be sent with old key). This was
the case before too as WMI commands were
asynchronous.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    4 ++-
 drivers/net/wireless/ath/ath10k/mac.c  |   53 ++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d5da8a9..ba6fd4d 100644
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
index b55b680..e849121 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1231,7 +1231,7 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	/* FIXME: why don't we print error if wmi call fails? */
 	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
 
-	arvif->def_wep_key_index = 0;
+	arvif->def_wep_key_idx = 0;
 }
 
 static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
@@ -1432,6 +1432,30 @@ static void ath10k_tx_h_qos_workaround(struct ieee80211_hw *hw,
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
@@ -1440,8 +1464,6 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	struct ath10k *ar = arvif->ar;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_key_conf *key = info->control.hw_key;
-	u32 vdev_param;
-	int ret;
 
 	if (!ieee80211_has_protected(hdr->frame_control))
 		return;
@@ -1453,21 +1475,14 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
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
@@ -2003,6 +2018,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->ar = ar;
 	arvif->vif = vif;
 
+	INIT_WORK(&arvif->wep_key_work, ath10k_tx_wep_key_work);
+
 	if ((vif->type == NL80211_IFTYPE_MONITOR) && ar->monitor_present) {
 		ath10k_warn("Only one monitor interface allowed\n");
 		ret = -EBUSY;
@@ -2058,7 +2075,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	vdev_param = ar->wmi.vdev_param->def_keyid;
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
-					arvif->def_wep_key_index);
+					arvif->def_wep_key_idx);
 	if (ret)
 		ath10k_warn("Failed to set default keyid: %d\n", ret);
 
@@ -2126,6 +2143,8 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	cancel_work_sync(&arvif->wep_key_work);
+
 	spin_lock_bh(&ar->data_lock);
 	if (arvif->beacon) {
 		dev_kfree_skb_any(arvif->beacon);
-- 
1.7.9.5

