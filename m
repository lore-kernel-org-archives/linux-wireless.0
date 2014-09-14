Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:32800 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaINJn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:43:29 -0400
Subject: [PATCH 10/10] ath10k: use ether_addr_copy()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:49 +0300
Message-ID: <20140914095049.9063.17016.stgit@x230> (sfid-20140914_120113_684420_E671807A)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As suggeested by checkpatch:

WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)

In wmi.c I had to change due to sparse warnings copying of struct wmi_mac_addr
from form &cmd->peer_macaddr.addr to cmd->peer_macaddr.addr. In
ath10k_wmi_set_ap_ps_param() I also added the missing ".addr" to the copy
command.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    8 ++++----
 drivers/net/wireless/ath/ath10k/mac.c    |   10 +++++-----
 drivers/net/wireless/ath/ath10k/txrx.c   |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |   22 +++++++++++-----------
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 92b56e43d2d8..60d40a04508b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -954,8 +954,8 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			/* pull decapped header and copy SA & DA */
 			hdr = (struct ieee80211_hdr *)skb->data;
 			hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
-			memcpy(da, ieee80211_get_DA(hdr), ETH_ALEN);
-			memcpy(sa, ieee80211_get_SA(hdr), ETH_ALEN);
+			ether_addr_copy(da, ieee80211_get_DA(hdr));
+			ether_addr_copy(sa, ieee80211_get_SA(hdr));
 			skb_pull(skb, hdr_len);
 
 			/* push original 802.11 header */
@@ -972,8 +972,8 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 			/* original 802.11 header has a different DA and in
 			 * case of 4addr it may also have different SA
 			 */
-			memcpy(ieee80211_get_DA(hdr), da, ETH_ALEN);
-			memcpy(ieee80211_get_SA(hdr), sa, ETH_ALEN);
+			ether_addr_copy(ieee80211_get_DA(hdr), da);
+			ether_addr_copy(ieee80211_get_SA(hdr), sa);
 			break;
 		case RX_MSDU_DECAP_ETHERNET2_DIX:
 			/* strip ethernet header and insert decapped 802.11
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 28e6db1d3846..c708c100e361 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -199,7 +199,7 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 		list_for_each_entry(peer, &ar->peers, list) {
 			for (i = 0; i < ARRAY_SIZE(peer->keys); i++) {
 				if (peer->keys[i] == key) {
-					memcpy(addr, peer->addr, ETH_ALEN);
+					ether_addr_copy(addr, peer->addr);
 					peer->keys[i] = NULL;
 					break;
 				}
@@ -930,7 +930,7 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 		return;
 
 	arvif->aid = 0;
-	memcpy(arvif->bssid, info->bssid, ETH_ALEN);
+	ether_addr_copy(arvif->bssid, info->bssid);
 
 	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 				 arvif->bssid);
@@ -1050,7 +1050,7 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
-	memcpy(arg->addr, sta->addr, ETH_ALEN);
+	ether_addr_copy(arg->addr, sta->addr);
 	arg->vdev_id = arvif->vdev_id;
 	arg->peer_aid = sta->aid;
 	arg->peer_flags |= WMI_PEER_AUTH;
@@ -1524,7 +1524,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
 
 	arvif->aid = bss_conf->aid;
-	memcpy(arvif->bssid, bss_conf->bssid, ETH_ALEN);
+	ether_addr_copy(arvif->bssid, bss_conf->bssid);
 
 	ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, arvif->aid, arvif->bssid);
 	if (ret) {
@@ -3090,7 +3090,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				 * this is never erased as we it for crypto key
 				 * clearing; this is FW requirement
 				 */
-				memcpy(arvif->bssid, info->bssid, ETH_ALEN);
+				ether_addr_copy(arvif->bssid, info->bssid);
 
 				ath10k_dbg(ar, ATH10K_DBG_MAC,
 					   "mac vdev %d start %pM\n",
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 2eeec8a63d5c..a0cbc21d0d4b 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -178,7 +178,7 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
 			goto exit;
 
 		peer->vdev_id = ev->vdev_id;
-		memcpy(peer->addr, ev->addr, ETH_ALEN);
+		ether_addr_copy(peer->addr, ev->addr);
 		list_add(&peer->list, &ar->peers);
 		wake_up(&ar->peer_mapping_wq);
 	}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c71376218ee5..2c42bd504b79 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -794,7 +794,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	cmd->hdr.tx_power = 0;
 	cmd->hdr.buf_len = __cpu_to_le32(buf_len);
 
-	memcpy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr), ETH_ALEN);
+	ether_addr_copy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr));
 	memcpy(cmd->buf, skb->data, skb->len);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
@@ -2350,7 +2350,7 @@ static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (WARN_ON(skb->len < sizeof(*ev)))
 		return -EINVAL;
 
-	memcpy(ar->mac_addr, ev->mac_addr.addr, ETH_ALEN);
+	ether_addr_copy(ar->mac_addr, ev->mac_addr.addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event ready sw_version %u abi_version %u mac_addr %pM status %d skb->len %i ev-sz %zu\n",
@@ -3496,7 +3496,7 @@ int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
 	cmd->vdev_id      = __cpu_to_le32(vdev_id);
 	cmd->vdev_type    = __cpu_to_le32(type);
 	cmd->vdev_subtype = __cpu_to_le32(subtype);
-	memcpy(cmd->vdev_macaddr.addr, macaddr, ETH_ALEN);
+	ether_addr_copy(cmd->vdev_macaddr.addr, macaddr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "WMI vdev create: id %d type %d subtype %d macaddr %pM\n",
@@ -3643,7 +3643,7 @@ int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
 	cmd = (struct wmi_vdev_up_cmd *)skb->data;
 	cmd->vdev_id       = __cpu_to_le32(vdev_id);
 	cmd->vdev_assoc_id = __cpu_to_le32(aid);
-	memcpy(&cmd->vdev_bssid.addr, bssid, ETH_ALEN);
+	ether_addr_copy(cmd->vdev_bssid.addr, bssid);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi mgmt vdev up id 0x%x assoc id %d bssid %pM\n",
@@ -3724,7 +3724,7 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 	cmd->key_rxmic_len = __cpu_to_le32(arg->key_rxmic_len);
 
 	if (arg->macaddr)
-		memcpy(cmd->peer_macaddr.addr, arg->macaddr, ETH_ALEN);
+		ether_addr_copy(cmd->peer_macaddr.addr, arg->macaddr);
 	if (arg->key_data)
 		memcpy(cmd->key_data, arg->key_data, arg->key_len);
 
@@ -3803,7 +3803,7 @@ int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 
 	cmd = (struct wmi_peer_create_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
-	memcpy(cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
+	ether_addr_copy(cmd->peer_macaddr.addr, peer_addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer create vdev_id %d peer_addr %pM\n",
@@ -3823,7 +3823,7 @@ int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
 
 	cmd = (struct wmi_peer_delete_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
-	memcpy(cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
+	ether_addr_copy(cmd->peer_macaddr.addr, peer_addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer delete vdev_id %d peer_addr %pM\n",
@@ -3844,7 +3844,7 @@ int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
 	cmd = (struct wmi_peer_flush_tids_cmd *)skb->data;
 	cmd->vdev_id         = __cpu_to_le32(vdev_id);
 	cmd->peer_tid_bitmap = __cpu_to_le32(tid_bitmap);
-	memcpy(cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
+	ether_addr_copy(cmd->peer_macaddr.addr, peer_addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer flush vdev_id %d peer_addr %pM tids %08x\n",
@@ -3867,7 +3867,7 @@ int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
 	cmd->vdev_id     = __cpu_to_le32(vdev_id);
 	cmd->param_id    = __cpu_to_le32(param_id);
 	cmd->param_value = __cpu_to_le32(param_value);
-	memcpy(&cmd->peer_macaddr.addr, peer_addr, ETH_ALEN);
+	ether_addr_copy(cmd->peer_macaddr.addr, peer_addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi vdev %d peer 0x%pM set param %d value %d\n",
@@ -3938,7 +3938,7 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 	cmd->param_id = __cpu_to_le32(param_id);
 	cmd->param_value = __cpu_to_le32(value);
-	memcpy(&cmd->peer_macaddr, mac, ETH_ALEN);
+	ether_addr_copy(cmd->peer_macaddr.addr, mac);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi ap ps param vdev_id 0x%X param %d value %d mac_addr %pM\n",
@@ -4022,7 +4022,7 @@ ath10k_wmi_peer_assoc_fill(struct ath10k *ar, void *buf,
 	cmd->peer_vht_caps      = __cpu_to_le32(arg->peer_vht_caps);
 	cmd->peer_phymode       = __cpu_to_le32(arg->peer_phymode);
 
-	memcpy(cmd->peer_macaddr.addr, arg->addr, ETH_ALEN);
+	ether_addr_copy(cmd->peer_macaddr.addr, arg->addr);
 
 	cmd->peer_legacy_rates.num_rates =
 		__cpu_to_le32(arg->peer_legacy_rates.num_rates);

