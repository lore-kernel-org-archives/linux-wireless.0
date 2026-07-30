Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8836D4418D7
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422109; cv=none; b=Lkfes9F96ItlxBibSZQLJkD8JYJ5UWkR7c/v/Us+VuWJuNfV3nHhsHe+vhTA+HRE9uarXvcrzHUqDr12vzrxou1JcymJjh42w0Mumz4tmdJkibbrY5YeRHj3H8gfHYgCO4cwYAGFV72b7EpnasijP5/OsyxsqmJ353q999rR2Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422109; c=relaxed/simple;
	bh=EsnSng3OiSwGpK4uY+bm5+ygmz84+EL9xXGU807f0m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs829iBnveQr8I2RoQFT8AJiXOp8IfOCTqr7lyIHKH5M2emxwyYXo5PfkiXEZ6B/3nx0h3X2xTLKQtLuLsUcWin0gQxOEiNe+9zNn2G6O3UWtb/J61tr0X/0Bb4747AaZsN9x73L06g9oNb/UtAyTrrcyIpu5vMzbyz1xeLH5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=QCLO9cte; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="QCLO9cte"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=4li65BcNpSkuPJvoyH9P8yXhY9efVvAT0OcmyGsRKBI=;
	t=1785422106; x=1786631706; b=QCLO9ctekPrI5aZpEaTqdRKeh64pz+IxQDDLVNL3Ka/P+cG
	b8RtRQJ/P3Jbr1Qk8xNMD7XoLQO+wzQMLgzoy9Ft2sMEe9o9dl8TTcyeoe/0uoXp/sQXv3Q3fGVg5
	AYSD6GgwAOJ3PB9hx3O4lS4r549btdZ8tKDh4fkrGMlgutqukbr9wKtEItplfofan0mvAVu/+oodA
	W4YAbfuIv0ziNgbVC88lRdJl5hGG68c4ksatKhc28ZK3NCO0FnUv0ZtTDhXLlon3h5XejzNg5+0t7
	q3NKFiWkrQBN+qE/DBjXv5E3732kUUXpcoE6rXdBfubl1PjR1vfljp6Vz7F8K/hw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpRqX-00000004mKH-3uBV;
	Thu, 30 Jul 2026 16:34:54 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Jouni Malinen <j@w1.fi>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 1/8] wifi: iwlwifi: use link_sta internally to the driver
Date: Thu, 30 Jul 2026 16:34:17 +0200
Message-ID: <20260730163415.6cf822ae0abd.I41df561f8129fac1327a07729cf4734b8752bcd6@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730143415.1833312-10-benjamin@sipsolutions.net>
References: <20260730143415.1833312-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

Using the link_sta is a natural way to pass both the STA and the link ID
information at the same time. Use that internally to the driver in
preparation to mac80211 changing its API and adopting the same method.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/agg.c  | 17 +++----
 drivers/net/wireless/intel/iwlwifi/mld/agg.h  |  4 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   | 45 ++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mld/rx.h   |  2 +-
 .../wireless/intel/iwlwifi/mld/tests/agg.c    |  7 +--
 5 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
index 96102d2af2cf..c45c47337509 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -7,7 +7,8 @@
 #include "hcmd.h"
 
 static void
-iwl_mld_reorder_release_frames(struct iwl_mld *mld, struct ieee80211_sta *sta,
+iwl_mld_reorder_release_frames(struct iwl_mld *mld,
+			       struct ieee80211_link_sta *link_sta,
 			       struct napi_struct *napi,
 			       struct iwl_mld_baid_data *baid_data,
 			       struct iwl_mld_reorder_buffer *reorder_buf,
@@ -32,7 +33,7 @@ iwl_mld_reorder_release_frames(struct iwl_mld *mld, struct ieee80211_sta *sta,
 		while ((skb = __skb_dequeue(skb_list))) {
 			iwl_mld_pass_packet_to_mac80211(mld, napi, skb,
 							reorder_buf->queue,
-							sta);
+							link_sta);
 			reorder_buf->num_stored--;
 		}
 	}
@@ -74,7 +75,7 @@ static void iwl_mld_release_frames_from_notif(struct iwl_mld *mld,
 
 	reorder_buf = &ba_data->reorder_buf[queue];
 
-	iwl_mld_reorder_release_frames(mld, link_sta->sta, napi, ba_data,
+	iwl_mld_reorder_release_frames(mld, link_sta, napi, ba_data,
 				       reorder_buf, nssn);
 out_unlock:
 	rcu_read_unlock();
@@ -180,7 +181,7 @@ void iwl_mld_del_ba(struct iwl_mld *mld, int queue,
 	reorder_buf = &ba_data->reorder_buf[queue];
 
 	/* release all frames that are in the reorder buffer to the stack */
-	iwl_mld_reorder_release_frames(mld, link_sta->sta, NULL,
+	iwl_mld_reorder_release_frames(mld, link_sta, NULL,
 				       ba_data, reorder_buf,
 				       ieee80211_sn_add(reorder_buf->head_sn,
 							ba_data->buf_size));
@@ -193,7 +194,7 @@ void iwl_mld_del_ba(struct iwl_mld *mld, int queue,
  */
 enum iwl_mld_reorder_result
 iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
-		int queue, struct ieee80211_sta *sta,
+		int queue, struct ieee80211_link_sta *link_sta,
 		struct sk_buff *skb, struct iwl_rx_mpdu_desc *desc)
 {
 	struct ieee80211_hdr *hdr = (void *)skb_mac_header(skb);
@@ -228,12 +229,12 @@ iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
 		return IWL_MLD_PASS_SKB;
 
 	/* no sta yet */
-	if (IWL_FW_CHECK(mld, !sta,
+	if (IWL_FW_CHECK(mld, !link_sta,
 			 "Got valid BAID without a valid station assigned - %d\n",
 			 baid))
 		return IWL_MLD_PASS_SKB;
 
-	mld_sta = iwl_mld_sta_from_mac80211(sta);
+	mld_sta = iwl_mld_sta_from_mac80211(link_sta->sta);
 
 	/* not a data packet */
 	if (!ieee80211_is_data_qos(hdr->frame_control) ||
@@ -324,7 +325,7 @@ iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
 	 * will be released when the frame release notification arrives.
 	 */
 	if (!amsdu || last_subframe)
-		iwl_mld_reorder_release_frames(mld, sta, napi, baid_data,
+		iwl_mld_reorder_release_frames(mld, link_sta, napi, baid_data,
 					       buffer, nssn);
 	else if (buffer->num_stored == 1)
 		buffer->head_sn = nssn;
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.h b/drivers/net/wireless/intel/iwlwifi/mld/agg.h
index 651c80d1c7cd..c6cd5fa219be 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024, 2026 Intel Corporation
  */
 #ifndef __iwl_agg_h__
 #define __iwl_agg_h__
@@ -106,7 +106,7 @@ int iwl_mld_ampdu_rx_stop(struct iwl_mld *mld, struct ieee80211_sta *sta,
 
 enum iwl_mld_reorder_result
 iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
-		int queue, struct ieee80211_sta *sta,
+		int queue, struct ieee80211_link_sta *link_sta,
 		struct sk_buff *skb, struct iwl_rx_mpdu_desc *desc);
 
 void iwl_mld_handle_frame_release_notif(struct iwl_mld *mld,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 269439d789f4..5696a247922b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -47,7 +47,8 @@ iwl_mld_fill_phy_data_from_mpdu(struct iwl_mld *mld,
 }
 
 static inline int iwl_mld_check_pn(struct iwl_mld *mld, struct sk_buff *skb,
-				   int queue, struct ieee80211_sta *sta)
+				   int queue,
+				   struct ieee80211_link_sta *link_sta)
 {
 	struct ieee80211_hdr *hdr = (void *)skb_mac_header(skb);
 	struct ieee80211_rx_status *stats = IEEE80211_SKB_RXCB(skb);
@@ -71,13 +72,13 @@ static inline int iwl_mld_check_pn(struct iwl_mld *mld, struct sk_buff *skb,
 		return 0;
 
 	/* if we are here - this for sure is either CCMP or GCMP */
-	if (!sta) {
+	if (!link_sta) {
 		IWL_DEBUG_DROP(mld,
 			       "expected hw-decrypted unicast frame for station\n");
 		return -1;
 	}
 
-	mld_sta = iwl_mld_sta_from_mac80211(sta);
+	mld_sta = iwl_mld_sta_from_mac80211(link_sta->sta);
 
 	extiv = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
 	keyidx = extiv[3] >> 6;
@@ -119,17 +120,17 @@ static inline int iwl_mld_check_pn(struct iwl_mld *mld, struct sk_buff *skb,
 void iwl_mld_pass_packet_to_mac80211(struct iwl_mld *mld,
 				     struct napi_struct *napi,
 				     struct sk_buff *skb, int queue,
-				     struct ieee80211_sta *sta)
+				     struct ieee80211_link_sta *link_sta)
 {
 	KUNIT_STATIC_STUB_REDIRECT(iwl_mld_pass_packet_to_mac80211,
-				   mld, napi, skb, queue, sta);
+				   mld, napi, skb, queue, link_sta);
 
-	if (unlikely(iwl_mld_check_pn(mld, skb, queue, sta))) {
+	if (unlikely(iwl_mld_check_pn(mld, skb, queue, link_sta))) {
 		kfree_skb(skb);
 		return;
 	}
 
-	ieee80211_rx_napi(mld->hw, sta, skb, napi);
+	ieee80211_rx_napi(mld->hw, link_sta->sta, skb, napi);
 }
 EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_pass_packet_to_mac80211);
 
@@ -1728,7 +1729,7 @@ static void iwl_mld_update_last_rx_timestamp(struct iwl_mld *mld, u8 baid)
  * Sets *drop to true if the packet should be dropped.
  * Returns the station if found, or NULL otherwise.
  */
-static struct ieee80211_sta *
+static struct ieee80211_link_sta *
 iwl_mld_rx_with_sta(struct iwl_mld *mld, struct ieee80211_hdr *hdr,
 		    struct sk_buff *skb,
 		    const struct iwl_rx_mpdu_desc *mpdu_desc,
@@ -1803,10 +1804,10 @@ iwl_mld_rx_with_sta(struct iwl_mld *mld, struct ieee80211_hdr *hdr,
 							    queue);
 	}
 
-	return sta;
+	return link_sta;
 }
 
-static int iwl_mld_rx_mgmt_prot(struct ieee80211_sta *sta,
+static int iwl_mld_rx_mgmt_prot(struct ieee80211_link_sta *link_sta,
 				struct ieee80211_hdr *hdr,
 				struct ieee80211_rx_status *rx_status,
 				u32 mpdu_status,
@@ -1820,7 +1821,6 @@ static int iwl_mld_rx_mgmt_prot(struct ieee80211_sta *sta,
 	struct ieee80211_key_conf *key;
 	const u8 *frame = (void *)hdr;
 	const u8 *mmie;
-	u8 link_id;
 
 	if ((mpdu_status & IWL_RX_MPDU_STATUS_SEC_MASK) ==
 	     IWL_RX_MPDU_STATUS_SEC_NONE)
@@ -1836,10 +1836,10 @@ static int iwl_mld_rx_mgmt_prot(struct ieee80211_sta *sta,
 	if (!ieee80211_is_beacon(hdr->frame_control))
 		return 0;
 
-	if (!sta)
+	if (!link_sta)
 		return -1;
 
-	mld_sta = iwl_mld_sta_from_mac80211(sta);
+	mld_sta = iwl_mld_sta_from_mac80211(link_sta->sta);
 	mld_vif = iwl_mld_vif_from_mac80211(mld_sta->vif);
 
 	/* key mismatch - will also report !MIC_OK but we shouldn't count it */
@@ -1853,8 +1853,7 @@ static int iwl_mld_rx_mgmt_prot(struct ieee80211_sta *sta,
 		return 0;
 	}
 
-	link_id = rx_status->link_valid ? rx_status->link_id : 0;
-	link = rcu_dereference(mld_vif->link[link_id]);
+	link = rcu_dereference(mld_vif->link[link_sta->link_id]);
 	if (WARN_ON_ONCE(!link))
 		return -1;
 
@@ -1905,7 +1904,7 @@ static int iwl_mld_rx_mgmt_prot(struct ieee80211_sta *sta,
 }
 
 static int iwl_mld_rx_crypto(struct iwl_mld *mld,
-			     struct ieee80211_sta *sta,
+			     struct ieee80211_link_sta *link_sta,
 			     struct ieee80211_hdr *hdr,
 			     struct ieee80211_rx_status *rx_status,
 			     struct iwl_rx_mpdu_desc *desc, int queue,
@@ -1915,7 +1914,7 @@ static int iwl_mld_rx_crypto(struct iwl_mld *mld,
 
 	if (unlikely(ieee80211_is_mgmt(hdr->frame_control) &&
 		     !ieee80211_has_protected(hdr->frame_control)))
-		return iwl_mld_rx_mgmt_prot(sta, hdr, rx_status, status,
+		return iwl_mld_rx_mgmt_prot(link_sta, hdr, rx_status, status,
 					    le16_to_cpu(desc->mpdu_len));
 
 	if (!ieee80211_has_protected(hdr->frame_control) ||
@@ -2023,7 +2022,7 @@ void iwl_mld_rx_mpdu(struct iwl_mld *mld, struct napi_struct *napi,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mld_rx_phy_data phy_data = {};
 	struct iwl_rx_mpdu_desc *mpdu_desc = (void *)pkt->data;
-	struct ieee80211_sta *sta;
+	struct ieee80211_link_sta *link_sta;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	size_t mpdu_desc_size = sizeof(*mpdu_desc);
@@ -2086,7 +2085,8 @@ void iwl_mld_rx_mpdu(struct iwl_mld *mld, struct napi_struct *napi,
 
 	rcu_read_lock();
 
-	sta = iwl_mld_rx_with_sta(mld, hdr, skb, mpdu_desc, pkt, queue, &drop);
+	link_sta = iwl_mld_rx_with_sta(mld, hdr, skb, mpdu_desc, pkt, queue,
+				       &drop);
 	if (drop)
 		goto drop;
 
@@ -2127,7 +2127,7 @@ void iwl_mld_rx_mpdu(struct iwl_mld *mld, struct napi_struct *napi,
 
 	iwl_mld_rx_fill_status(mld, link_id, hdr, skb, &phy_data);
 
-	if (iwl_mld_rx_crypto(mld, sta, hdr, rx_status, mpdu_desc, queue,
+	if (iwl_mld_rx_crypto(mld, link_sta, hdr, rx_status, mpdu_desc, queue,
 			      le32_to_cpu(pkt->len_n_flags), &crypto_len))
 		goto drop;
 
@@ -2140,7 +2140,8 @@ void iwl_mld_rx_mpdu(struct iwl_mld *mld, struct napi_struct *napi,
 	if (iwl_mld_time_sync_frame(mld, skb, hdr->addr2))
 		goto out;
 
-	reorder_res = iwl_mld_reorder(mld, napi, queue, sta, skb, mpdu_desc);
+	reorder_res = iwl_mld_reorder(mld, napi, queue, link_sta, skb,
+				      mpdu_desc);
 	switch (reorder_res) {
 	case IWL_MLD_PASS_SKB:
 		break;
@@ -2153,7 +2154,7 @@ void iwl_mld_rx_mpdu(struct iwl_mld *mld, struct napi_struct *napi,
 		goto drop;
 	}
 
-	iwl_mld_pass_packet_to_mac80211(mld, napi, skb, queue, sta);
+	iwl_mld_pass_packet_to_mac80211(mld, napi, skb, queue, link_sta);
 
 	goto out;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.h b/drivers/net/wireless/intel/iwlwifi/mld/rx.h
index 573b89c3c9c6..b08c5ade3db8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.h
@@ -69,7 +69,7 @@ void iwl_mld_handle_rsc_notif(struct iwl_mld *mld,
 void iwl_mld_pass_packet_to_mac80211(struct iwl_mld *mld,
 				     struct napi_struct *napi,
 				     struct sk_buff *skb, int queue,
-				     struct ieee80211_sta *sta);
+				     struct ieee80211_link_sta *link_sta);
 
 void iwl_mld_handle_phy_air_sniffer_notif(struct iwl_mld *mld,
 					  struct napi_struct *napi,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tests/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/tests/agg.c
index 29b0248cec3d..e9efe2996f07 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tests/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tests/agg.c
@@ -2,7 +2,7 @@
 /*
  * KUnit tests for channel helper functions
  *
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #include <kunit/test.h>
 #include <kunit/static_stub.h>
@@ -441,7 +441,7 @@ static void
 fake_iwl_mld_pass_packet_to_mac80211(struct iwl_mld *mld,
 				     struct napi_struct *napi,
 				     struct sk_buff *skb, int queue,
-				     struct ieee80211_sta *sta)
+				     struct ieee80211_link_sta *link_sta)
 {
 	__skb_queue_tail(&g_released_skbs, skb);
 	g_num_released_skbs++;
@@ -630,7 +630,8 @@ static void test_reorder_buffer(struct kunit *test)
 	mpdu_desc = setup_mpdu_desc();
 
 	rcu_read_lock();
-	reorder_res = iwl_mld_reorder(mld, NULL, QUEUE, sta, skb, mpdu_desc);
+	reorder_res = iwl_mld_reorder(mld, NULL, QUEUE, &sta->deflink, skb,
+				      mpdu_desc);
 	rcu_read_unlock();
 
 	KUNIT_ASSERT_EQ(test, reorder_res, param->expected.reorder_res);
-- 
2.55.0

