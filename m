Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32985 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbbBCKk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 05:40:27 -0500
Received: by mail-wi0-f182.google.com with SMTP id n3so20721989wiv.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 02:40:26 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [RFC 1/4] ath10k: unify tx mode and dispatch
Date: Tue,  3 Feb 2015 11:41:51 +0100
Message-Id: <1422960114-25137-2-git-send-email-marek.puzyniak@tieto.com> (sfid-20150203_114039_380159_7FB1D1C2)
In-Reply-To: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
References: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

There are a few different tx paths depending on
firmware and frame itself.

Creating a uniform decision will make it possible
to switch between different txmode easier, both
for testing and for future features as well.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |   2 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   8 --
 drivers/net/wireless/ath/ath10k/htt_tx.c |  30 ++++----
 drivers/net/wireless/ath/ath10k/mac.c    | 128 ++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/mac.h    |   8 ++
 5 files changed, 124 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 57c7926..884ec6c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -82,6 +82,8 @@ struct ath10k_skb_cb {
 	dma_addr_t paddr;
 	u8 eid;
 	u8 vdev_id;
+	enum ath10k_hw_txrx_mode txmode;
+	bool is_protected;
 
 	struct {
 		u8 tid;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 08c924c..ad823c9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -609,14 +609,6 @@ static int ath10k_htt_rx_crypto_tail_len(struct ath10k *ar,
 	return 0;
 }
 
-struct rfc1042_hdr {
-	u8 llc_dsap;
-	u8 llc_ssap;
-	u8 llc_ctrl;
-	u8 snap_oui[3];
-	__be16 snap_type;
-} __packed;
-
 struct amsdu_subframe_hdr {
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 92cc6e3..e3a762c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -424,9 +424,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	int res;
 	u8 flags0 = 0;
 	u16 msdu_id, flags1 = 0;
-	dma_addr_t paddr;
-	u32 frags_paddr;
-	bool use_frags;
+	dma_addr_t paddr = 0;
+	u32 frags_paddr = 0;
 
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
@@ -444,12 +443,6 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	prefetch_len = min(htt->prefetch_len, msdu->len);
 	prefetch_len = roundup(prefetch_len, 4);
 
-	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
-	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
-	 * fragment list host driver specifies directly frame pointer. */
-	use_frags = htt->target_version_major < 3 ||
-		    !ieee80211_is_mgmt(hdr->frame_control);
-
 	skb_cb->htt.txbuf = dma_pool_alloc(htt->tx_pool, GFP_ATOMIC,
 					   &paddr);
 	if (!skb_cb->htt.txbuf) {
@@ -470,7 +463,12 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if (res)
 		goto err_free_txbuf;
 
-	if (likely(use_frags)) {
+	switch (skb_cb->txmode) {
+	case ATH10K_HW_TXRX_RAW:
+	case ATH10K_HW_TXRX_NATIVE_WIFI:
+		flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
+		/* pass through */
+	case ATH10K_HW_TXRX_ETHERNET:
 		frags = skb_cb->htt.txbuf->frags;
 
 		frags[0].paddr = __cpu_to_le32(skb_cb->paddr);
@@ -478,15 +476,17 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		frags[1].paddr = 0;
 		frags[1].len = 0;
 
-		flags0 |= SM(ATH10K_HW_TXRX_NATIVE_WIFI,
-			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
+		flags0 |= SM(skb_cb->txmode, HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
 
 		frags_paddr = skb_cb->htt.txbuf_paddr;
-	} else {
+		break;
+	case ATH10K_HW_TXRX_MGMT:
 		flags0 |= SM(ATH10K_HW_TXRX_MGMT,
 			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
+		flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
 
 		frags_paddr = skb_cb->paddr;
+		break;
 	}
 
 	/* Normally all commands go through HTC which manages tx credits for
@@ -512,11 +512,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 			prefetch_len);
 	skb_cb->htt.txbuf->htc_hdr.flags = 0;
 
-	if (!ieee80211_has_protected(hdr->frame_control))
+	if (!skb_cb->is_protected)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 
-	flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
-
 	flags1 |= SM((u16)vdev_id, HTT_DATA_TX_DESC_FLAGS1_VDEV_ID);
 	flags1 |= SM((u16)tid, HTT_DATA_TX_DESC_FLAGS1_EXT_TID);
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7fbb9aa..c5815ce 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2460,6 +2460,43 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar, struct ieee80211_vif *vif)
 	return 0;
 }
 
+static enum ath10k_hw_txrx_mode
+ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
+		       struct sk_buff *skb)
+{
+	const struct ieee80211_hdr *hdr = (void *)skb->data;
+	__le16 fc = hdr->frame_control;
+
+	if (!vif || vif->type == NL80211_IFTYPE_MONITOR)
+		return ATH10K_HW_TXRX_RAW;
+
+	if (ieee80211_is_mgmt(fc))
+		return ATH10K_HW_TXRX_MGMT;
+
+	/* Workaround:
+	 *
+	 * NullFunc frames are mostly used to ping if a client or AP are still
+	 * reachable and responsive. This implies tx status reports must be
+	 * accurate - otherwise either mac80211 or userspace (e.g. hostapd) can
+	 * come to a conclusion that the other end disappeared and tear down
+	 * BSS connection or it can never disconnect from BSS/client (which is
+	 * the case).
+	 *
+	 * Firmware with HTT older than 3.0 delivers incorrect tx status for
+	 * NullFunc frames to driver. However there's a HTT Mgmt Tx command
+	 * which seems to deliver correct tx reports for NullFunc frames. The
+	 * downside of using it is it ignores client powersave state so it can
+	 * end up disconnecting sleeping clients in AP mode. It should fix STA
+	 * mode though because AP don't sleep.
+	 */
+	if (ar->htt.target_version_major < 3 &&
+	    (ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
+	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX, ar->fw_features))
+		return ATH10K_HW_TXRX_MGMT;
+
+	return ATH10K_HW_TXRX_NATIVE_WIFI;
+}
+
 /* HTT Tx uses Native Wifi tx mode which expects 802.11 frames without QoS
  * Control in the header.
  */
@@ -2489,6 +2526,33 @@ static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 }
 
+static void ath10k_tx_h_8023(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	struct rfc1042_hdr *rfc1042;
+	struct ethhdr *eth;
+	size_t hdrlen;
+	u8 da[ETH_ALEN];
+	u8 sa[ETH_ALEN];
+	__be16 type;
+
+	hdr = (void *)skb->data;
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	rfc1042 = (void *)skb->data + hdrlen;
+
+	ether_addr_copy(da, ieee80211_get_DA(hdr));
+	ether_addr_copy(sa, ieee80211_get_SA(hdr));
+	type = rfc1042->snap_type;
+
+	skb_pull(skb, hdrlen + sizeof(*rfc1042));
+	skb_push(skb, sizeof(*eth));
+
+	eth = (void *)skb->data;
+	ether_addr_copy(eth->h_dest, da);
+	ether_addr_copy(eth->h_source, sa);
+	eth->h_proto = type;
+}
+
 static void ath10k_tx_wep_key_work(struct work_struct *work)
 {
 	struct ath10k_vif *arvif = container_of(work, struct ath10k_vif,
@@ -2624,37 +2688,29 @@ unlock:
 	return ret;
 }
 
-static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_mac_tx(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
+	struct ath10k_htt *htt = &ar->htt;
 	int ret = 0;
 
-	if (ar->htt.target_version_major >= 3) {
-		/* Since HTT 3.0 there is no separate mgmt tx command */
-		ret = ath10k_htt_tx(&ar->htt, skb);
-		goto exit;
-	}
-
-	if (ieee80211_is_mgmt(hdr->frame_control)) {
+	switch (cb->txmode) {
+	case ATH10K_HW_TXRX_RAW:
+	case ATH10K_HW_TXRX_NATIVE_WIFI:
+	case ATH10K_HW_TXRX_ETHERNET:
+		ret = ath10k_htt_tx(htt, skb);
+		break;
+	case ATH10K_HW_TXRX_MGMT:
 		if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
-			     ar->fw_features)) {
+			     ar->fw_features))
 			ret = ath10k_mac_tx_wmi_mgmt(ar, skb);
-		} else {
-			ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
-		}
-	} else if (!test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
-			     ar->fw_features) &&
-		   ieee80211_is_nullfunc(hdr->frame_control)) {
-		/* FW does not report tx status properly for NullFunc frames
-		 * unless they are sent through mgmt tx path. mac80211 sends
-		 * those frames when it detects link/beacon loss and depends
-		 * on the tx status to be correct. */
-		ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
-	} else {
-		ret = ath10k_htt_tx(&ar->htt, skb);
+		else if (ar->htt.target_version_major >= 3)
+			ret = ath10k_htt_tx(htt, skb);
+		else
+			ret = ath10k_htt_mgmt_tx(htt, skb);
+		break;
 	}
 
-exit:
 	if (ret) {
 		ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
 			    ret);
@@ -2727,7 +2783,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		ar->offchan_tx_skb = skb;
 		spin_unlock_bh(&ar->data_lock);
 
-		ath10k_tx_htt(ar, skb);
+		ath10k_mac_tx(ar, skb);
 
 		ret = wait_for_completion_timeout(&ar->offchan_tx_completed,
 						  3 * HZ);
@@ -2958,6 +3014,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc = hdr->frame_control;
 
 	/* We should disable CCK RATE due to P2P */
 	if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
@@ -2966,14 +3023,29 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
+	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, skb);
+	ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
 
-	/* it makes no sense to process injected frames like that */
-	if (vif && vif->type != NL80211_IFTYPE_MONITOR) {
+	switch (ATH10K_SKB_CB(skb)->txmode) {
+	case ATH10K_HW_TXRX_MGMT:
+	case ATH10K_HW_TXRX_NATIVE_WIFI:
 		ath10k_tx_h_nwifi(hw, skb);
 		ath10k_tx_h_update_wep_key(vif, key, skb);
 		ath10k_tx_h_add_p2p_noa_ie(ar, vif, skb);
 		ath10k_tx_h_seq_no(vif, skb);
 		ath10k_tx_h_tsf_adjust(vif, skb);
+		break;
+	case ATH10K_HW_TXRX_ETHERNET:
+		ath10k_tx_h_update_wep_key(vif, key, skb);
+		ath10k_tx_h_8023(skb);
+		break;
+	case ATH10K_HW_TXRX_RAW:
+		/* FIXME: Packet injection isn't implemented. It should be
+		 * doable with firmware 10.2 on qca988x.
+		 */
+		WARN_ON_ONCE(1);
+		ieee80211_free_txskb(hw, skb);
+		return;
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
@@ -2995,7 +3067,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		}
 	}
 
-	ath10k_tx_htt(ar, skb);
+	ath10k_mac_tx(ar, skb);
 }
 
 /* Must not be called with conf_mutex held as workers can use that also. */
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index ca120dd..1e96f25 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -28,6 +28,14 @@ struct ath10k_generic_iter {
 	int ret;
 };
 
+struct rfc1042_hdr {
+	u8 llc_dsap;
+	u8 llc_ssap;
+	u8 llc_ctrl;
+	u8 snap_oui[3];
+	__be16 snap_type;
+} __packed;
+
 struct ath10k *ath10k_mac_create(size_t priv_size);
 void ath10k_mac_destroy(struct ath10k *ar);
 int ath10k_mac_register(struct ath10k *ar);
-- 
2.1.4

