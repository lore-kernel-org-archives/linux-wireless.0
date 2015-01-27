Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8155 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbbA0OVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:21:49 -0500
Date: Tue, 27 Jan 2015 19:51:29 +0530
From: Senthil Balasubramanian <senthilb@qti.qualcomm.com>
To: <ath10k@lists.infraded.org>
CC: <linux-wireless@vger.kernel.org>, <sjegadee@qti.qualcomm.com>
Subject: [PATCH] ath10k:Prevent setting wrong key idx for station
Message-ID: <20150127142127.GA20822@senthil-lnx> (sfid-20150127_152205_501755_074AD78C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath10k driver sets wrong default key idx that results in
sending unicast frames with multicast key.

The reason for this behavior is that cached broadcast key
is installed for station MAC address on association. After
dot1x completes, unicast key is installed for station
MAC address. Default key idx is set to broadcast key id when
driver tries to send broadcast frame. This causes firmware
to use broadcast key id to transmit unicast frames to stations.

Used TX_USAGE flag to set default key for stations.

Added callback for setting unicast default idx which will be
invoked on every default key idx configuration.

Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 161 +++++++++++++++------------------
 2 files changed, 72 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c568612..f6b8d35 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -271,10 +271,8 @@ struct ath10k_vif {
 	u32 aid;
 	u8 bssid[ETH_ALEN];

-	struct work_struct wep_key_work;
 	struct ieee80211_key_conf *wep_keys[WMI_MAX_KEY_INDEX + 1];
-	u8 def_wep_key_idx;
-	u8 def_wep_key_newidx;
+	s8 def_wep_key_idx;

 	u16 tx_seq_no;

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..b115b69 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -37,7 +37,7 @@
 static int ath10k_send_key(struct ath10k_vif *arvif,
 			   struct ieee80211_key_conf *key,
 			   enum set_key_cmd cmd,
-			   const u8 *macaddr)
+			   const u8 *macaddr, bool def_idx)
 {
 	struct ath10k *ar = arvif->ar;
 	struct wmi_vdev_install_key_arg arg = {
@@ -75,6 +75,9 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		 * Otherwise pairwise key must be set */
 		if (memcmp(macaddr, arvif->vif->addr, ETH_ALEN))
 			arg.key_flags = WMI_KEY_PAIRWISE;
+
+		if (def_idx)
+			arg.key_flags |= WMI_KEY_TX_USAGE;
 		break;
 	default:
 		ath10k_warn(ar, "cipher %d is not supported\n", key->cipher);
@@ -92,7 +95,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 static int ath10k_install_key(struct ath10k_vif *arvif,
 			      struct ieee80211_key_conf *key,
 			      enum set_key_cmd cmd,
-			      const u8 *macaddr)
+			      const u8 *macaddr, bool def_idx)
 {
 	struct ath10k *ar = arvif->ar;
 	int ret;
@@ -101,7 +104,7 @@ static int ath10k_install_key(struct ath10k_vif *arvif,

 	reinit_completion(&ar->install_key_done);

-	ret = ath10k_send_key(arvif, key, cmd, macaddr);
+	ret = ath10k_send_key(arvif, key, cmd, macaddr, def_idx);
 	if (ret)
 		return ret;

@@ -119,6 +122,7 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 	struct ath10k_peer *peer;
 	int ret;
 	int i;
+	bool def_idx;

 	lockdep_assert_held(&ar->conf_mutex);

@@ -132,9 +136,14 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 	for (i = 0; i < ARRAY_SIZE(arvif->wep_keys); i++) {
 		if (arvif->wep_keys[i] == NULL)
 			continue;
+		/* set TX_USAGE flag for default key id */
+		if (arvif->def_wep_key_idx == i)
+			def_idx = true;
+		else
+			def_idx = false;

 		ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
-					 addr);
+					 addr, def_idx);
 		if (ret)
 			return ret;

@@ -168,8 +177,9 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 		if (peer->keys[i] == NULL)
 			continue;

+		/* key flags are not required to delete the key */
 		ret = ath10k_install_key(arvif, peer->keys[i],
-					 DISABLE_KEY, addr);
+					 DISABLE_KEY, addr, false);
 		if (ret && first_errno == 0)
 			first_errno = ret;

@@ -243,8 +253,8 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,

 		if (i == ARRAY_SIZE(peer->keys))
 			break;
-
-		ret = ath10k_install_key(arvif, key, DISABLE_KEY, addr);
+		/* key flags are not required to delete the key */
+		ret = ath10k_install_key(arvif, key, DISABLE_KEY, addr, false);
 		if (ret && first_errno == 0)
 			first_errno = ret;

@@ -1817,7 +1827,8 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 		ath10k_warn(ar, "faield to down vdev %i: %d\n",
 			    arvif->vdev_id, ret);

-	arvif->def_wep_key_idx = 0;
+	arvif->def_wep_key_idx = -1;
+
 	arvif->is_up = false;
 }

@@ -1876,11 +1887,14 @@ static int ath10k_station_assoc(struct ath10k *ar,
 			}
 		}

-		ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
-		if (ret) {
-			ath10k_warn(ar, "failed to install peer wep keys for vdev %i: %d\n",
-				    arvif->vdev_id, ret);
-			return ret;
+		/* Plumb cached keys only for static WEP */
+		if (arvif->def_wep_key_idx != -1) {
+			ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
+			if (ret) {
+				ath10k_warn(ar, "failed to install peer wep keys for vdev %i: %d\n",
+					    arvif->vdev_id, ret);
+				return ret;
+			}
 		}
 	}

@@ -2151,69 +2165,6 @@ static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 }

-static void ath10k_tx_wep_key_work(struct work_struct *work)
-{
-	struct ath10k_vif *arvif = container_of(work, struct ath10k_vif,
-						wep_key_work);
-	struct ath10k *ar = arvif->ar;
-	int ret, keyidx = arvif->def_wep_key_newidx;
-
-	mutex_lock(&arvif->ar->conf_mutex);
-
-	if (arvif->ar->state != ATH10K_STATE_ON)
-		goto unlock;
-
-	if (arvif->def_wep_key_idx == keyidx)
-		goto unlock;
-
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d set keyidx %d\n",
-		   arvif->vdev_id, keyidx);
-
-	ret = ath10k_wmi_vdev_set_param(arvif->ar,
-					arvif->vdev_id,
-					arvif->ar->wmi.vdev_param->def_keyid,
-					keyidx);
-	if (ret) {
-		ath10k_warn(ar, "failed to update wep key index for vdev %d: %d\n",
-			    arvif->vdev_id,
-			    ret);
-		goto unlock;
-	}
-
-	arvif->def_wep_key_idx = keyidx;
-
-unlock:
-	mutex_unlock(&arvif->ar->conf_mutex);
-}
-
-static void ath10k_tx_h_update_wep_key(struct ieee80211_vif *vif,
-				       struct ieee80211_key_conf *key,
-				       struct sk_buff *skb)
-{
-	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
-	struct ath10k *ar = arvif->ar;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-
-	if (!ieee80211_has_protected(hdr->frame_control))
-		return;
-
-	if (!key)
-		return;
-
-	if (key->cipher != WLAN_CIPHER_SUITE_WEP40 &&
-	    key->cipher != WLAN_CIPHER_SUITE_WEP104)
-		return;
-
-	if (key->keyidx == arvif->def_wep_key_idx)
-		return;
-
-	/* FIXME: Most likely a few frames will be TXed with an old key. Simply
-	 * queueing frames until key index is updated is not an option because
-	 * sk_buff may need more processing to be done, e.g. offchannel */
-	arvif->def_wep_key_newidx = key->keyidx;
-	ieee80211_queue_work(ar->hw, &arvif->wep_key_work);
-}
-
 static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 				       struct ieee80211_vif *vif,
 				       struct sk_buff *skb)
@@ -2574,7 +2525,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
-	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;

 	/* We should disable CCK RATE due to P2P */
@@ -2588,7 +2538,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	/* it makes no sense to process injected frames like that */
 	if (vif && vif->type != NL80211_IFTYPE_MONITOR) {
 		ath10k_tx_h_nwifi(hw, skb);
-		ath10k_tx_h_update_wep_key(vif, key, skb);
 		ath10k_tx_h_add_p2p_noa_ie(ar, vif, skb);
 		ath10k_tx_h_seq_no(vif, skb);
 	}
@@ -3093,7 +3042,6 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->ar = ar;
 	arvif->vif = vif;

-	INIT_WORK(&arvif->wep_key_work, ath10k_tx_wep_key_work);
 	INIT_LIST_HEAD(&arvif->list);

 	if (ar->free_vdev_map == 0) {
@@ -3182,14 +3130,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	ar->free_vdev_map &= ~(1LL << arvif->vdev_id);
 	list_add(&arvif->list, &ar->arvifs);

-	vdev_param = ar->wmi.vdev_param->def_keyid;
-	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
-					arvif->def_wep_key_idx);
-	if (ret) {
-		ath10k_warn(ar, "failed to set vdev %i default key id: %d\n",
-			    arvif->vdev_id, ret);
-		goto err_vdev_delete;
-	}
+	arvif->def_wep_key_idx = -1;

 	vdev_param = ar->wmi.vdev_param->tx_encap_type;
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
@@ -3309,8 +3250,6 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret;

-	cancel_work_sync(&arvif->wep_key_work);
-
 	mutex_lock(&ar->conf_mutex);

 	spin_lock_bh(&ar->data_lock);
@@ -3682,6 +3621,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	const u8 *peer_addr;
 	bool is_wep = key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 		      key->cipher == WLAN_CIPHER_SUITE_WEP104;
+	bool def_idx = false;
 	int ret = 0;

 	if (key->keyidx > WMI_MAX_KEY_INDEX)
@@ -3727,7 +3667,14 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			ath10k_clear_vdev_key(arvif, key);
 	}

-	ret = ath10k_install_key(arvif, key, cmd, peer_addr);
+	/* set TX_USAGE flag for all the keys incase of dot1x-WEP. For
+	 * static WEP, do not set this flag for the keys whose key id
+	 * is  greater than default key id.
+	 */
+	if (arvif->def_wep_key_idx == -1)
+		def_idx = true;
+
+	ret = ath10k_install_key(arvif, key, cmd, peer_addr, def_idx);
 	if (ret) {
 		ath10k_warn(ar, "failed to install key for vdev %i peer %pM: %d\n",
 			    arvif->vdev_id, peer_addr, ret);
@@ -3752,6 +3699,39 @@ exit:
 	return ret;
 }

+static void ath10k_set_default_unicast_key(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif,
+					   int keyidx)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	int ret;
+
+	mutex_lock(&arvif->ar->conf_mutex);
+
+	if (arvif->ar->state != ATH10K_STATE_ON)
+		goto unlock;
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d set keyidx %d\n",
+		   arvif->vdev_id, keyidx);
+
+	ret = ath10k_wmi_vdev_set_param(arvif->ar,
+					arvif->vdev_id,
+					arvif->ar->wmi.vdev_param->def_keyid,
+					keyidx);
+
+	if (ret) {
+		ath10k_warn(ar, "failed to update wep key index for vdev %d: %d\n",
+			    arvif->vdev_id,
+			    ret);
+		goto unlock;
+	}
+
+	arvif->def_wep_key_idx = keyidx;
+unlock:
+	mutex_unlock(&arvif->ar->conf_mutex);
+}
+
 static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 {
 	struct ath10k *ar;
@@ -4871,6 +4851,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.hw_scan			= ath10k_hw_scan,
 	.cancel_hw_scan			= ath10k_cancel_hw_scan,
 	.set_key			= ath10k_set_key,
+	.set_default_unicast_key        = ath10k_set_default_unicast_key,
 	.sta_state			= ath10k_sta_state,
 	.conf_tx			= ath10k_conf_tx,
 	.remain_on_channel		= ath10k_remain_on_channel,
--
1.9.1

