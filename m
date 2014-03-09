Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43355 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCIG5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:57:18 -0500
Subject: [PATCH 2/6] ath6kl: use braces on both arms of if statement
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 08:57:17 +0200
Message-ID: <20140309065717.10793.76274.stgit@x230> (sfid-20140309_075720_994995_A000EE43)
In-Reply-To: <20140309065606.10793.67068.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warning:

CHECK: braces {} should be used on all arms of this statement

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++--
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   11 ++++++-----
 drivers/net/wireless/ath/ath6kl/main.c     |    6 ++++--
 drivers/net/wireless/ath/ath6kl/sdio.c     |   11 ++++++-----
 drivers/net/wireless/ath/ath6kl/txrx.c     |   24 ++++++++++++++++--------
 drivers/net/wireless/ath/ath6kl/wmi.c      |   13 ++++++++-----
 6 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 9e3af81..0928508 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -724,8 +724,9 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 				   "added bss %pM to cfg80211\n", bssid);
 		kfree(ie);
-	} else
+	} else {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss\n");
+	}
 
 	return bss;
 }
@@ -2848,8 +2849,9 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (p.prwise_crypto_type == 0) {
 		p.prwise_crypto_type = NONE_CRYPT;
 		ath6kl_set_cipher(vif, 0, true);
-	} else if (info->crypto.n_ciphers_pairwise == 1)
+	} else if (info->crypto.n_ciphers_pairwise == 1) {
 		ath6kl_set_cipher(vif, info->crypto.ciphers_pairwise[0], true);
+	}
 
 	switch (info->crypto.cipher_group) {
 	case WLAN_CIPHER_SUITE_WEP40:
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 1d713dc..e481f14 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -112,9 +112,9 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 		if (cur_ep_dist->endpoint == ENDPOINT_0)
 			continue;
 
-		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC)
+		if (cur_ep_dist->svc_id == WMI_CONTROL_SVC) {
 			cur_ep_dist->cred_norm = cur_ep_dist->cred_per_msg;
-		else {
+		} else {
 			/*
 			 * For the remaining data endpoints, we assume that
 			 * each cred_per_msg are the same. We use a simple
@@ -1418,9 +1418,9 @@ static int ath6kl_htc_rx_setup(struct htc_target *target,
 				}
 			}
 
-			if (list_empty(&ep->rx_bufq))
+			if (list_empty(&ep->rx_bufq)) {
 				packet = NULL;
-			else {
+			} else {
 				packet = list_first_entry(&ep->rx_bufq,
 						struct htc_packet, list);
 				list_del(&packet->list);
@@ -2813,8 +2813,9 @@ static int ath6kl_htc_reset(struct htc_target *target)
 			packet->buf = packet->buf_start;
 			packet->endpoint = ENDPOINT_0;
 			list_add_tail(&packet->list, &target->free_ctrl_rxbuf);
-		} else
+		} else {
 			list_add_tail(&packet->list, &target->free_ctrl_txbuf);
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index fcaab0f..d565546 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -690,8 +690,9 @@ void ath6kl_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid, bool ismcast)
 		cfg80211_michael_mic_failure(vif->ndev, sta->mac,
 					     NL80211_KEYTYPE_PAIRWISE, keyid,
 					     tsc, GFP_KERNEL);
-	} else
+	} else {
 		ath6kl_cfg80211_tkip_micerr_event(vif, keyid, ismcast);
+	}
 }
 
 static void ath6kl_update_target_stats(struct ath6kl_vif *vif, u8 *ptr, u32 len)
@@ -1090,8 +1091,9 @@ static int ath6kl_open(struct net_device *dev)
 	if (test_bit(CONNECTED, &vif->flags)) {
 		netif_carrier_on(dev);
 		netif_wake_queue(dev);
-	} else
+	} else {
 		netif_carrier_off(dev);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 9c73b62..a3bca39 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -425,8 +425,9 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 			memcpy(tbuf, buf, len);
 
 		bounced = true;
-	} else
+	} else {
 		tbuf = buf;
+	}
 
 	ret = ath6kl_sdio_io(ar_sdio->func, request, addr, tbuf, len);
 	if ((request & HIF_READ) && bounced)
@@ -441,9 +442,9 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 static void __ath6kl_sdio_write_async(struct ath6kl_sdio *ar_sdio,
 				      struct bus_request *req)
 {
-	if (req->scat_req)
+	if (req->scat_req) {
 		ath6kl_sdio_scat_rw(ar_sdio, req);
-	else {
+	} else {
 		void *context;
 		int status;
 
@@ -673,9 +674,9 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 		   "hif-scatter: total len: %d scatter entries: %d\n",
 		   scat_req->len, scat_req->scat_entries);
 
-	if (request & HIF_SYNCHRONOUS)
+	if (request & HIF_SYNCHRONOUS) {
 		status = ath6kl_sdio_scat_rw(ar_sdio, scat_req->busrequest);
-	else {
+	} else {
 		spin_lock_bh(&ar_sdio->wr_async_lock);
 		list_add_tail(&scat_req->busrequest->list, &ar_sdio->wr_asyncq);
 		spin_unlock_bh(&ar_sdio->wr_async_lock);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index cf27a71..e9c28a7 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -125,8 +125,9 @@ static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
 		*flags |= WMI_DATA_HDR_FLAGS_UAPSD;
 		spin_unlock_bh(&conn->psq_lock);
 		return false;
-	} else if (!conn->apsd_info)
+	} else if (!conn->apsd_info) {
 		return false;
+	}
 
 	if (test_bit(WMM_ENABLED, &vif->flags)) {
 		ether_type = be16_to_cpu(datap->h_proto);
@@ -316,8 +317,9 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 		cookie = NULL;
 		ath6kl_err("wmi ctrl ep full, dropping pkt : 0x%p, len:%d\n",
 			   skb, skb->len);
-	} else
+	} else {
 		cookie = ath6kl_alloc_cookie(ar);
+	}
 
 	if (cookie == NULL) {
 		spin_unlock_bh(&ar->lock);
@@ -449,8 +451,9 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			if (ret)
 				goto fail_tx;
 		}
-	} else
+	} else {
 		goto fail_tx;
+	}
 
 	spin_lock_bh(&ar->lock);
 
@@ -1088,8 +1091,9 @@ static void aggr_deque_frms(struct aggr_info_conn *agg_conn, u8 tid,
 			else
 				skb_queue_tail(&rxtid->q, node->skb);
 			node->skb = NULL;
-		} else
+		} else {
 			stats->num_hole++;
+		}
 
 		rxtid->seq_next = ATH6KL_NEXT_SEQ_NO(rxtid->seq_next);
 		idx = AGGR_WIN_IDX(rxtid->seq_next, rxtid->hold_q_sz);
@@ -1604,16 +1608,18 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			if (!conn)
 				return;
 			aggr_conn = conn->aggr_conn;
-		} else
+		} else {
 			aggr_conn = vif->aggr_cntxt->aggr_conn;
+		}
 
 		if (aggr_process_recv_frm(aggr_conn, tid, seq_no,
 					  is_amsdu, skb)) {
 			/* aggregation code will handle the skb */
 			return;
 		}
-	} else if (!is_broadcast_ether_addr(datap->h_dest))
+	} else if (!is_broadcast_ether_addr(datap->h_dest)) {
 		vif->net_stats.multicast++;
+	}
 
 	ath6kl_deliver_frames_to_nw_stack(vif->ndev, skb);
 }
@@ -1708,8 +1714,9 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid_mux, u16 seq_no,
 		sta = ath6kl_find_sta_by_aid(vif->ar, aid);
 		if (sta)
 			aggr_conn = sta->aggr_conn;
-	} else
+	} else {
 		aggr_conn = vif->aggr_cntxt->aggr_conn;
+	}
 
 	if (!aggr_conn)
 		return;
@@ -1803,8 +1810,9 @@ void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid_mux)
 		sta = ath6kl_find_sta_by_aid(vif->ar, aid);
 		if (sta)
 			aggr_conn = sta->aggr_conn;
-	} else
+	} else {
 		aggr_conn = vif->aggr_cntxt->aggr_conn;
+	}
 
 	if (!aggr_conn)
 		return;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 34c4954..0c0e1e3 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -289,8 +289,9 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, u8 if_idx,
 			   ath6kl_wmi_determine_user_priority(((u8 *) llc_hdr) +
 					sizeof(struct ath6kl_llc_snap_hdr),
 					layer2_priority);
-		} else
+		} else {
 			usr_pri = layer2_priority & 0x7;
+		}
 
 		/*
 		 * Queue the EAPOL frames in the same WMM_AC_VO queue
@@ -359,8 +360,9 @@ int ath6kl_wmi_dot11_hdr_remove(struct wmi *wmi, struct sk_buff *skb)
 		hdr_size = roundup(sizeof(struct ieee80211_qos_hdr),
 				   sizeof(u32));
 		skb_pull(skb, hdr_size);
-	} else if (sub_type == cpu_to_le16(IEEE80211_STYPE_DATA))
+	} else if (sub_type == cpu_to_le16(IEEE80211_STYPE_DATA)) {
 		skb_pull(skb, sizeof(struct ieee80211_hdr_3addr));
+	}
 
 	datap = skb->data;
 	llc_hdr = (struct ath6kl_llc_snap_hdr *)(datap);
@@ -945,9 +947,9 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 	ev = (struct ath6kl_wmi_regdomain *) datap;
 	reg_code = le32_to_cpu(ev->reg_code);
 
-	if ((reg_code >> ATH6KL_COUNTRY_RD_SHIFT) & COUNTRY_ERD_FLAG)
+	if ((reg_code >> ATH6KL_COUNTRY_RD_SHIFT) & COUNTRY_ERD_FLAG) {
 		country = ath6kl_regd_find_country((u16) reg_code);
-	else if (!(((u16) reg_code & WORLD_SKU_MASK) == WORLD_SKU_PREFIX)) {
+	} else if (!(((u16) reg_code & WORLD_SKU_MASK) == WORLD_SKU_PREFIX)) {
 		regpair = ath6kl_get_regpair((u16) reg_code);
 		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
 		if (regpair)
@@ -2864,8 +2866,9 @@ int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
 	if (host_mode == ATH6KL_HOST_MODE_ASLEEP) {
 		ath6kl_wmi_relinquish_implicit_pstream_credits(wmi);
 		cmd->asleep = cpu_to_le32(1);
-	} else
+	} else {
 		cmd->awake = cpu_to_le32(1);
+	}
 
 	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
 				  WMI_SET_HOST_SLEEP_MODE_CMDID,

