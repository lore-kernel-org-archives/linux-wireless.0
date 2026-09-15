Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BFD3C1D5F
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478532; cv=none; b=D025mgPcn6FQGkAFj0IwKCFjAhxLSgKdXGMXnlSuek+2OfVvMa3HKqXQ2QAQPA6EUqz74d84DX93Cg66csPdiox5YW4SKd1B94WNASf1Yr0RUNeiG6126larP+1d6YOetaGedB73abuKwNd1GMLQF7+mBQW2tr/eRQ5cOQRAExo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478532; c=relaxed/simple;
	bh=s4Vt0k5pFkh5xWp7pcnTF6N3AxfBe+3ekJ6j/SpY4/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2L/3yqoVjLZmBJYaGIRilIfGWEb3InsDfjSXLuOBzhIy7AIHZuED4YEzr3eaHrWaOY4MZ80lSWaXNH7awWBQ3rf00+TRh/giNMvWJN8Uob+UpqJvTX5SAgydGIANdC3lD64XTsxvL2YrBjDiLIFRwd7OiqlS061YOqA5mY97DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=frWYWfsM; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="frWYWfsM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Av7wBlTj2L7cWLC4/0Hi6MzLWEw5Ka3z2fBHgjvDWM4=;
	t=1789478528; x=1790688128; b=frWYWfsM624HOvLtmPYT/IU8W0we0X+okJt63u88VW6kD9c
	pQLFvxrfkccSatlEgBnN5cPzLFk7i8jPqZQ9kUkfstfIPOJQDIToaEIAc88L0FbA5jDKCAUO4LH8S
	DSVjNYBNCb/NikvLtXK3ZsnwvGip/FPW9hF+XVGEZ5vDs3NvqLVv14YXVrMFzSZzhMhwPlaTuWR0N
	1ZijlOVXe/Fr2jLVkIa1F+7fCc6ckayuzsJ1fd6umXaZYkqYJ6Pb8GbYZ1y+jsF18Ssjj2WKb3OAX
	3bKPuZTfqU7RbVNbuFDdntSyKxh9/iR/brcypwDIpna2qzOSJxX5+Rr2zCVtBJpQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x6T6h-0000000H08V-2o9s;
	Tue, 15 Sep 2026 15:21:55 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v4 2/8] wifi: mac80211: change public RX API to use link stations
Date: Tue, 15 Sep 2026 15:19:28 +0200
Message-ID: <20260915151925.06f41565116a.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915131925.1780764-10-benjamin@sipsolutions.net>
References: <20260915131925.1780764-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

If a station is passed then the link ID also needs to be known. As such,
it is a more natural API to simply pass the link station directly rather
than pushing the link information into the RX status.

Furthermore, having the link ID in the RX status is not actually correct
because the link IDs are VIF specific and there may be multiple VIFs. In
the case of a station this relationship is clear, but then one may as
well use the link station.

This patch only changes the API and emulates the old (incorrect)
behaviour for now. The mac80211 RX code will be updated in later
patches.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>

---

v4:
 * Fix link_sta out parameter value of mt76_rx_convert in some cases

v3:
 * Correct error return handling for link ID in ath12k

v2:
 * Remove now unused variable in rtw89

v1:
 * Do not dereference NULL station
---
 drivers/net/wireless/ath/ath11k/dp_rx.c       |  2 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c      |  2 --
 drivers/net/wireless/ath/ath12k/dp_rx.c       | 20 ++++++++++++---
 drivers/net/wireless/ath/ath12k/hw.h          | 20 ++++++++-------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 20 +++++++--------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h | 12 ++++-----
 drivers/net/wireless/ath/ath12k/wifi7/hw.c    |  6 ++---
 drivers/net/wireless/ath/ath12k/wmi.c         |  6 -----
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   |  7 +-----
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  6 ++---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 25 +++++++++++--------
 drivers/net/wireless/realtek/rtw89/core.c     |  7 ------
 .../wireless/virtual/mac80211_hwsim_main.c    |  3 ---
 include/net/mac80211.h                        | 16 +++++++++---
 net/mac80211/rx.c                             | 20 +++++++++++----
 16 files changed, 92 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 33425707c084..fbb3d18f55dd 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2500,7 +2500,7 @@ static void ath11k_dp_rx_deliver_msdu(struct ath11k *ar, struct napi_struct *nap
 	    !(is_mcbc && rx_status->flag & RX_FLAG_DECRYPTED))
 		rx_status->flag |= RX_FLAG_8023;
 
-	ieee80211_rx_napi(ar->hw, pubsta, msdu, napi);
+	ieee80211_rx_napi(ar->hw, pubsta ? &pubsta->deflink : NULL, msdu, napi);
 }
 
 static bool ath11k_dp_rx_check_nwifi_hdr_len_valid(struct ath11k_base *ab,
diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 7d5be77b081f..1faf1896d0ab 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -503,8 +503,6 @@ void ath12k_dp_mon_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev,
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_radiotap_he *he = NULL;
 
-	status->link_valid = 0;
-
 	if ((status->encoding == RX_ENC_HE) && !(status->flag & RX_FLAG_RADIOTAP_HE) &&
 	    !(status->flag & RX_FLAG_SKIP_MONITOR)) {
 		he = skb_push(msdu, sizeof(known));
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..41ac0a4072ae 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1375,6 +1375,7 @@ void ath12k_dp_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev, struct napi_struc
 	struct ath12k_dp *dp = dp_pdev->dp;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_sta *pubsta;
+	struct ieee80211_link_sta *link_pubsta = NULL;
 	struct ath12k_dp_peer *peer;
 	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(msdu);
 	struct ieee80211_rx_status *status = rx_info->rx_status;
@@ -1384,9 +1385,19 @@ void ath12k_dp_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev, struct napi_struc
 
 	pubsta = peer ? peer->sta : NULL;
 
-	status->link_valid = 0;
-	if (pubsta && pubsta->valid_links)
-		ath12k_hw_set_rx_link_id(dp->hw_params, peer, rxcb, status);
+	if (pubsta) {
+		if (pubsta->valid_links) {
+			int link_id =
+				ath12k_hw_get_rx_link_id(dp->hw_params, peer,
+							 rxcb, status);
+
+			if (link_id >= 0)
+				link_pubsta =
+					rcu_dereference(pubsta->link[link_id]);
+		} else {
+			link_pubsta = &pubsta->deflink;
+		}
+	}
 
 	ath12k_dbg(dp->ab, ATH12K_DBG_DATA,
 		   "rx skb %p len %u peer %pM %d %s sn %u %s%s%s%s%s%s%s%s%s%s rate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
@@ -1422,7 +1433,8 @@ void ath12k_dp_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev, struct napi_struc
 
 	/* TODO: trace rx packet */
 
-	ieee80211_rx_napi(ath12k_pdev_dp_to_hw(dp_pdev), pubsta, msdu, napi);
+	ieee80211_rx_napi(ath12k_pdev_dp_to_hw(dp_pdev), link_pubsta, msdu,
+			  napi);
 }
 EXPORT_SYMBOL(ath12k_dp_rx_deliver_msdu);
 
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 011bb22e21c7..e790de5737db 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -249,9 +249,9 @@ struct ath12k_hw_ops {
 	bool (*dp_srng_is_tx_comp_ring)(int ring_num);
 	bool (*is_frame_link_agnostic)(struct ath12k_link_vif *arvif,
 				       struct ieee80211_mgmt *mgmt);
-	void (*set_rx_link_id)(struct ath12k_dp_peer *dp_peer,
-			       struct ath12k_skb_rxcb *rxcb,
-			       struct ieee80211_rx_status *status);
+	int (*get_rx_link_id)(struct ath12k_dp_peer *dp_peer,
+			      struct ath12k_skb_rxcb *rxcb,
+			      struct ieee80211_rx_status *status);
 };
 
 static inline
@@ -282,13 +282,15 @@ static inline int ath12k_hw_mac_id_to_srng_id(const struct ath12k_hw_params *hw,
 	return 0;
 }
 
-static inline void ath12k_hw_set_rx_link_id(const struct ath12k_hw_params *hw,
-					    struct ath12k_dp_peer *dp_peer,
-					    struct ath12k_skb_rxcb *rxcb,
-					    struct ieee80211_rx_status *status)
+static inline int ath12k_hw_get_rx_link_id(const struct ath12k_hw_params *hw,
+					   struct ath12k_dp_peer *dp_peer,
+					   struct ath12k_skb_rxcb *rxcb,
+					   struct ieee80211_rx_status *status)
 {
-	if (hw->hw_ops->set_rx_link_id)
-		hw->hw_ops->set_rx_link_id(dp_peer, rxcb, status);
+	if (hw->hw_ops->get_rx_link_id)
+		return hw->hw_ops->get_rx_link_id(dp_peer, rxcb, status);
+
+	return -1;
 }
 
 struct ath12k_fw_ie {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 95d87dd67872..8b722ee0ad8f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -2317,17 +2317,16 @@ ath12k_wifi7_dp_rxdesc_mpdu_valid(struct ath12k_base *ab,
 	return tlv_tag == HAL_RX_MPDU_START;
 }
 
-void
-ath12k_wifi7_dp_rx_set_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
+int
+ath12k_wifi7_dp_rx_get_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
 				       struct ath12k_skb_rxcb *rxcb,
 				       struct ieee80211_rx_status *status)
 {
-	status->link_valid = 1;
-	status->link_id = dp_peer->hw_links[rxcb->hw_link_id];
+	return dp_peer->hw_links[rxcb->hw_link_id];
 }
 
-void
-ath12k_wifi7_dp_rx_set_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
+int
+ath12k_wifi7_dp_rx_get_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
 				       struct ath12k_skb_rxcb *rxcb,
 				       struct ieee80211_rx_status *status)
 {
@@ -2341,10 +2340,9 @@ ath12k_wifi7_dp_rx_set_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
 	links_map = READ_ONCE(dp_peer->link_peers_map);
 	for_each_set_bit(i, &links_map, ATH12K_NUM_MAX_LINKS) {
 		link_peer = rcu_dereference(dp_peer->link_peers[i]);
-		if (link_peer && link_peer->peer_id == rxcb->peer_id) {
-			status->link_valid = 1;
-			status->link_id = link_peer->link_id;
-			return;
-		}
+		if (link_peer && link_peer->peer_id == rxcb->peer_id)
+			return link_peer->link_id;
 	}
+
+	return -1;
 }
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
index 1d3a4788a2dd..d68489ff7b03 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
@@ -57,10 +57,10 @@ ath12k_wifi7_dp_rxdesc_mpdu_valid(struct ath12k_base *ab,
 				  struct hal_rx_desc *rx_desc);
 int ath12k_wifi7_dp_rx_tid_delete_handler(struct ath12k_base *ab,
 					  struct ath12k_dp_rx_tid_rxq *rx_tid);
-void ath12k_wifi7_dp_rx_set_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
-					    struct ath12k_skb_rxcb *rxcb,
-					    struct ieee80211_rx_status *status);
-void ath12k_wifi7_dp_rx_set_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
-					    struct ath12k_skb_rxcb *rxcb,
-					    struct ieee80211_rx_status *status);
+int ath12k_wifi7_dp_rx_get_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
+					   struct ath12k_skb_rxcb *rxcb,
+					   struct ieee80211_rx_status *status);
+int ath12k_wifi7_dp_rx_get_link_id_wcn7850(struct ath12k_dp_peer *dp_peer,
+					   struct ath12k_skb_rxcb *rxcb,
+					   struct ieee80211_rx_status *status);
 #endif
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 7b86f324b2e6..4ded807763b6 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -158,7 +158,7 @@ static const struct ath12k_hw_ops qcn9274_ops = {
 	.get_ring_selector = ath12k_wifi7_hw_get_ring_selector_qcn9274,
 	.dp_srng_is_tx_comp_ring = ath12k_wifi7_dp_srng_is_comp_ring_qcn9274,
 	.is_frame_link_agnostic = ath12k_wifi7_is_frame_link_agnostic_qcn9274,
-	.set_rx_link_id = ath12k_wifi7_dp_rx_set_link_id_qcn9274,
+	.get_rx_link_id = ath12k_wifi7_dp_rx_get_link_id_qcn9274,
 };
 
 static const struct ath12k_hw_ops wcn7850_ops = {
@@ -169,7 +169,7 @@ static const struct ath12k_hw_ops wcn7850_ops = {
 	.get_ring_selector = ath12k_wifi7_hw_get_ring_selector_wcn7850,
 	.dp_srng_is_tx_comp_ring = ath12k_wifi7_dp_srng_is_comp_ring_wcn7850,
 	.is_frame_link_agnostic = ath12k_wifi7_is_frame_link_agnostic_wcn7850,
-	.set_rx_link_id = ath12k_wifi7_dp_rx_set_link_id_wcn7850,
+	.get_rx_link_id = ath12k_wifi7_dp_rx_get_link_id_wcn7850,
 };
 
 static const struct ath12k_hw_ops qcc2072_ops = {
@@ -180,7 +180,7 @@ static const struct ath12k_hw_ops qcc2072_ops = {
 	.get_ring_selector = ath12k_wifi7_hw_get_ring_selector_wcn7850,
 	.dp_srng_is_tx_comp_ring = ath12k_wifi7_dp_srng_is_comp_ring_wcn7850,
 	.is_frame_link_agnostic = ath12k_wifi7_is_frame_link_agnostic_wcn7850,
-	.set_rx_link_id = ath12k_wifi7_dp_rx_set_link_id_wcn7850,
+	.get_rx_link_id = ath12k_wifi7_dp_rx_get_link_id_wcn7850,
 };
 
 #define ATH12K_TX_RING_MASK_0 0x1
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d5160af60e00..7e3655966f02 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -7271,7 +7271,6 @@ static void ath12k_mgmt_rx_event(struct ath12k_base *ab, struct sk_buff *skb)
 	struct ath12k_wmi_mgmt_rx_arg rx_ev = {};
 	struct ath12k *ar;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_sta *pubsta = NULL;
 	struct ath12k_dp_link_peer *peer;
 	struct ieee80211_hdr *hdr;
 	bool is_4addr_null_pkt;
@@ -7373,11 +7372,6 @@ static void ath12k_mgmt_rx_event(struct ath12k_base *ab, struct sk_buff *skb)
 			dev_kfree_skb(skb);
 			goto exit;
 		}
-		pubsta = peer->sta;
-		if (pubsta && pubsta->valid_links) {
-			status->link_valid = 1;
-			status->link_id = peer->link_id;
-		}
 		spin_unlock_bh(&dp->dp_lock);
 		goto send_rx;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 5696a247922b..02bdf6ccbcdc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -130,7 +130,7 @@ void iwl_mld_pass_packet_to_mac80211(struct iwl_mld *mld,
 		return;
 	}
 
-	ieee80211_rx_napi(mld->hw, link_sta->sta, skb, napi);
+	ieee80211_rx_napi(mld->hw, link_sta, skb, napi);
 }
 EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_pass_packet_to_mac80211);
 
@@ -1765,11 +1765,6 @@ iwl_mld_rx_with_sta(struct iwl_mld *mld, struct ieee80211_hdr *hdr,
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
-	if (link_sta && sta->valid_links) {
-		rx_status->link_valid = true;
-		rx_status->link_id = link_sta->link_id;
-	}
-
 	/* fill checksum */
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    pkt->len_n_flags & cpu_to_le32(FH_RSCSR_RPA_EN)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index ab1eb2eb0c3c..8c197a090c2b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -90,7 +90,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 				fraglen, rxb->truesize);
 	}
 
-	ieee80211_rx_napi(mvm->hw, sta, skb, napi);
+	ieee80211_rx_napi(mvm->hw, sta ? &sta->deflink : NULL, skb, napi);
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7f0b4f5daa21..8c4009d3a00c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -243,7 +243,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 		return;
 	}
 
-	ieee80211_rx_napi(mvm->hw, sta, skb, napi);
+	ieee80211_rx_napi(mvm->hw, sta ? &sta->deflink : NULL, skb, napi);
 }
 
 static bool iwl_mvm_used_average_energy(struct iwl_mvm *mvm,
@@ -2528,7 +2528,7 @@ void iwl_mvm_rx_monitor_no_data(struct iwl_mvm *mvm, struct napi_struct *napi,
 	}
 
 	rcu_read_lock();
-	ieee80211_rx_napi(mvm->hw, sta, skb, napi);
+	ieee80211_rx_napi(mvm->hw, sta ? &sta->deflink : NULL, skb, napi);
 	rcu_read_unlock();
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index abbe65cbcd89..cda5c5d51aab 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1255,11 +1255,12 @@ EXPORT_SYMBOL(mt76_rx_signal);
 static void
 mt76_rx_convert(struct mt76_dev *dev, struct sk_buff *skb,
 		struct ieee80211_hw **hw,
-		struct ieee80211_sta **sta)
+		struct ieee80211_link_sta **link_sta)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = mt76_skb_get_hdr(skb);
 	struct mt76_rx_status mstat;
+	struct ieee80211_sta *sta;
 
 	mstat = *((struct mt76_rx_status *)skb->cb);
 	memset(status, 0, sizeof(*status));
@@ -1301,12 +1302,14 @@ mt76_rx_convert(struct mt76_dev *dev, struct sk_buff *skb,
 	memcpy(status->chain_signal, mstat.chain_signal,
 	       sizeof(mstat.chain_signal));
 
-	if (mstat.wcid) {
-		status->link_valid = mstat.wcid->link_valid;
-		status->link_id = mstat.wcid->link_id;
-	}
+	sta = wcid_to_sta(mstat.wcid);
+	if (!sta)
+		*link_sta = NULL;
+	else if (mstat.wcid->link_valid)
+		*link_sta = rcu_dereference(sta->link[mstat.wcid->link_id]);
+	else
+		*link_sta = &sta->deflink;
 
-	*sta = wcid_to_sta(mstat.wcid);
 	*hw = mt76_phy_hw(dev, mstat.phy_idx);
 }
 
@@ -1530,7 +1533,7 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 		      struct napi_struct *napi)
 {
-	struct ieee80211_sta *sta;
+	struct ieee80211_link_sta *link_sta;
 	struct ieee80211_hw *hw;
 	struct sk_buff *skb, *tmp;
 	LIST_HEAD(list);
@@ -1541,8 +1544,8 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 
 		mt76_check_ccmp_pn(skb);
 		skb_shinfo(skb)->frag_list = NULL;
-		mt76_rx_convert(dev, skb, &hw, &sta);
-		ieee80211_rx_list(hw, sta, skb, &list);
+		mt76_rx_convert(dev, skb, &hw, &link_sta);
+		ieee80211_rx_list(hw, link_sta, skb, &list);
 
 		/* subsequent amsdu frames */
 		while (nskb) {
@@ -1550,8 +1553,8 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 			nskb = nskb->next;
 			skb->next = NULL;
 
-			mt76_rx_convert(dev, skb, &hw, &sta);
-			ieee80211_rx_list(hw, sta, skb, &list);
+			mt76_rx_convert(dev, skb, &hw, &link_sta);
+			ieee80211_rx_list(hw, link_sta, skb, &list);
 		}
 	}
 	spin_unlock(&dev->rx_lock);
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 397ebbfcac09..454d876aeb88 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3073,10 +3073,8 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 	struct rtw89_vif *rtwvif = vif_to_rtwvif(vif);
 	struct rtw89_rx_desc_info *desc_info = iter_data->desc_info;
 	struct sk_buff *skb = iter_data->skb;
-	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rtw89_rx_phy_ppdu *phy_ppdu = iter_data->phy_ppdu;
-	bool is_mld = ieee80211_vif_is_mld(vif);
 	struct ieee80211_bss_conf *bss_conf;
 	struct rtw89_vif_link *rtwvif_link;
 	const u8 *bssid = iter_data->bssid;
@@ -3110,11 +3108,6 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 	if (!ether_addr_equal(target_bssid, bssid))
 		goto out;
 
-	if (is_mld) {
-		rx_status->link_valid = true;
-		rx_status->link_id = rtwvif_link->link_id;
-	}
-
 	bb = rtw89_get_bb_ctx(rtwdev, rtwvif_link->phy_idx);
 	pkt_stat = &bb->cur_pkt_stat;
 
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 9f895ad718e9..1a12261f3e8e 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1883,9 +1883,6 @@ static void mac80211_hwsim_rx(struct mac80211_hwsim_data *data,
 				sp->active_links_rx &= ~BIT(link_id);
 			else
 				sp->active_links_rx |= BIT(link_id);
-
-			rx_status->link_valid = true;
-			rx_status->link_id = link_id;
 		}
 		rcu_read_unlock();
 	}
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7bb4618065b6..cba7cdf61ce8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5389,14 +5389,18 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
  * mixed for a single hardware. Must not run concurrently with
  * ieee80211_tx_status_skb() or ieee80211_tx_status_ni().
  *
+ * For data frames, when hardware has done address translation, a link station
+ * has to be provided and the frequency information may be skipped.
+ *
  * This function must be called with BHs disabled and RCU read lock
  *
  * @hw: the hardware this frame came in on
- * @sta: the station the frame was received from, or %NULL
+ * @link_sta: the link station the data frame was received from, or %NULL
  * @skb: the buffer to receive, owned by mac80211 after this call
  * @list: the destination list
  */
-void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+void ieee80211_rx_list(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_sta,
 		       struct sk_buff *skb, struct list_head *list);
 
 /**
@@ -5414,14 +5418,18 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
  * mixed for a single hardware. Must not run concurrently with
  * ieee80211_tx_status_skb() or ieee80211_tx_status_ni().
  *
+ * For data frames, when hardware has done address translation, a link station
+ * has to be provided and the frequency information may be skipped.
+ *
  * This function must be called with BHs disabled.
  *
  * @hw: the hardware this frame came in on
- * @sta: the station the frame was received from, or %NULL
+ * @link_sta: the link station the data frame was received from, or %NULL
  * @skb: the buffer to receive, owned by mac80211 after this call
  * @napi: the NAPI context
  */
-void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+void ieee80211_rx_napi(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_sta,
 		       struct sk_buff *skb, struct napi_struct *napi);
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 31dc6f83781b..0ddd0b8ea12a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5556,7 +5556,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
  */
-void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
+void ieee80211_rx_list(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_pubsta,
 		       struct sk_buff *skb, struct list_head *list)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -5564,6 +5565,7 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_sta *pubsta;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -5694,8 +5696,15 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 		}
 	}
 
-	if (WARN_ON_ONCE(status->link_id >= IEEE80211_LINK_UNSPECIFIED))
-		goto drop;
+	/* FIXME: Emulate the old driver behaviour for now */
+	if (link_pubsta) {
+		status->link_valid = 1;
+		status->link_id = link_pubsta->link_id;
+		pubsta = link_pubsta->sta;
+	} else {
+		status->link_valid = 0;
+		pubsta = NULL;
+	}
 
 	status->rx_flags = 0;
 
@@ -5727,7 +5736,8 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 }
 EXPORT_SYMBOL(ieee80211_rx_list);
 
-void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
+void ieee80211_rx_napi(struct ieee80211_hw *hw,
+		       struct ieee80211_link_sta *link_pubsta,
 		       struct sk_buff *skb, struct napi_struct *napi)
 {
 	struct sk_buff *tmp;
@@ -5740,7 +5750,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	 * receive processing
 	 */
 	rcu_read_lock();
-	ieee80211_rx_list(hw, pubsta, skb, &list);
+	ieee80211_rx_list(hw, link_pubsta, skb, &list);
 	rcu_read_unlock();
 
 	if (!napi) {
-- 
2.55.0

