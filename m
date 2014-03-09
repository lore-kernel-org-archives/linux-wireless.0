Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43345 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCIG5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:57:13 -0500
Subject: [PATCH 1/6] ath6kl: fix blank lines before and after braces
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 08:57:11 +0200
Message-ID: <20140309065711.10793.98640.stgit@x230> (sfid-20140309_075718_646855_1A50EF3E)
In-Reply-To: <20140309065606.10793.67068.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

CHECK: Blank lines aren't necessary after an open brace '{'
CHECK: Blank lines aren't necessary before a close brace '}'

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ---
 drivers/net/wireless/ath/ath6kl/debug.c    |    4 ----
 drivers/net/wireless/ath/ath6kl/debug.h    |    2 +-
 drivers/net/wireless/ath/ath6kl/hif.c      |    3 ---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   12 ------------
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   10 +---------
 drivers/net/wireless/ath/ath6kl/init.c     |    1 -
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ----
 drivers/net/wireless/ath/ath6kl/sdio.c     |    4 ----
 drivers/net/wireless/ath/ath6kl/txrx.c     |    3 ---
 drivers/net/wireless/ath/ath6kl/usb.c      |    2 --
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 ------
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 -
 13 files changed, 2 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c2c6f46..9e3af81 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -970,7 +970,6 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 					  ssid_list[i].flag,
 					  ssid_list[i].ssid.ssid_len,
 					  ssid_list[i].ssid.ssid);
-
 	}
 
 	/* Make sure no old entries are left behind */
@@ -1897,7 +1896,6 @@ static int ath6kl_wow_usr(struct ath6kl *ar, struct ath6kl_vif *vif,
 
 	/* Configure the patterns that we received from the user. */
 	for (i = 0; i < wow->n_patterns; i++) {
-
 		/*
 		 * Convert given nl80211 specific mask value to equivalent
 		 * driver specific mask value and send it to the chip along
@@ -2897,7 +2895,6 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (info->inactivity_timeout) {
-
 		inactivity_timeout = info->inactivity_timeout;
 
 		if (ar->hw.flags & ATH6KL_HW_AP_INACTIVITY_MINS)
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index dbfd17d..55c4064 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -172,7 +172,6 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 			   struct ath6kl_irq_proc_registers *irq_proc_reg,
 			   struct ath6kl_irq_enable_reg *irq_enable_reg)
 {
-
 	ath6kl_dbg(ATH6KL_DBG_IRQ, ("<------- Register Table -------->\n"));
 
 	if (irq_proc_reg != NULL) {
@@ -219,7 +218,6 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 				   "GMBOX lookahead alias 1:   0x%x\n",
 				   irq_proc_reg->rx_gmbox_lkahd_alias[1]);
 		}
-
 	}
 
 	if (irq_enable_reg != NULL) {
@@ -1396,7 +1394,6 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 						const char __user *user_buf,
 						size_t count, loff_t *ppos)
 {
-
 	struct ath6kl *ar = file->private_data;
 	struct ath6kl_vif *vif;
 	char buf[200];
@@ -1575,7 +1572,6 @@ static ssize_t ath6kl_delete_qos_write(struct file *file,
 				const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
-
 	struct ath6kl *ar = file->private_data;
 	struct ath6kl_vif *vif;
 	char buf[100];
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index ca9ba00..e194c10d 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -97,8 +97,8 @@ static inline void ath6kl_dump_registers(struct ath6kl_device *dev,
 		struct ath6kl_irq_proc_registers *irq_proc_reg,
 		struct ath6kl_irq_enable_reg *irq_en_reg)
 {
-
 }
+
 static inline void dump_cred_dist_stats(struct htc_target *target)
 {
 }
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index fea7709..18c0708 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -37,7 +37,6 @@ static int ath6kl_hif_cp_scat_dma_buf(struct hif_scatter_req *req,
 	buf = req->virt_dma_buf;
 
 	for (i = 0; i < req->scat_entries; i++) {
-
 		if (from_dma)
 			memcpy(req->scat_list[i].buf, buf,
 			       req->scat_list[i].len);
@@ -116,7 +115,6 @@ static void ath6kl_hif_dump_fw_crash(struct ath6kl *ar)
 			    le32_to_cpu(regdump_val[i + 2]),
 			    le32_to_cpu(regdump_val[i + 3]));
 	}
-
 }
 
 static int ath6kl_hif_proc_dbg_intr(struct ath6kl_device *dev)
@@ -701,5 +699,4 @@ int ath6kl_hif_setup(struct ath6kl_device *dev)
 
 fail_setup:
 	return status;
-
 }
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 65e5b71..1d713dc 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -129,7 +129,6 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 			count = (count * 3) >> 2;
 			count = max(count, cur_ep_dist->cred_per_msg);
 			cur_ep_dist->cred_norm = count;
-
 		}
 
 		ath6kl_dbg(ATH6KL_DBG_CREDIT,
@@ -549,7 +548,6 @@ static int htc_check_credits(struct htc_target *target,
 			     enum htc_endpoint_id eid, unsigned int len,
 			     int *req_cred)
 {
-
 	*req_cred = (len > target->tgt_cred_sz) ?
 		     DIV_ROUND_UP(len, target->tgt_cred_sz) : 1;
 
@@ -608,7 +606,6 @@ static void ath6kl_htc_tx_pkts_get(struct htc_target *target,
 	unsigned int len;
 
 	while (true) {
-
 		flags = 0;
 
 		if (list_empty(&endpoint->txq))
@@ -889,7 +886,6 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 		ac = target->dev->ar->ep2ac_map[endpoint->eid];
 
 	while (true) {
-
 		if (list_empty(&endpoint->txq))
 			break;
 
@@ -1190,7 +1186,6 @@ static void ath6kl_htc_mbox_flush_txep(struct htc_target *target,
 		list_add_tail(&packet->list, &container);
 		htc_tx_complete(endpoint, &container);
 	}
-
 }
 
 static void ath6kl_htc_flush_txep_all(struct htc_target *target)
@@ -1394,7 +1389,6 @@ static int ath6kl_htc_rx_setup(struct htc_target *target,
 
 	ep_cb = ep->ep_cb;
 	for (j = 0; j < n_msg; j++) {
-
 		/*
 		 * Reset flag, any packets allocated using the
 		 * rx_alloc() API cannot be recycled on
@@ -1487,7 +1481,6 @@ static int ath6kl_htc_rx_alloc(struct htc_target *target,
 	spin_lock_bh(&target->rx_lock);
 
 	for (i = 0; i < msg; i++) {
-
 		htc_hdr = (struct htc_frame_hdr *)&lk_ahds[i];
 
 		if (htc_hdr->eid >= ENDPOINT_MAX) {
@@ -1708,7 +1701,6 @@ static int htc_parse_trailer(struct htc_target *target,
 		lk_ahd = (struct htc_lookahead_report *) record_buf;
 		if ((lk_ahd->pre_valid == ((~lk_ahd->post_valid) & 0xFF)) &&
 		    next_lk_ahds) {
-
 			ath6kl_dbg(ATH6KL_DBG_HTC,
 				   "htc rx lk_ahd found pre_valid 0x%x post_valid 0x%x\n",
 				   lk_ahd->pre_valid, lk_ahd->post_valid);
@@ -1755,7 +1747,6 @@ static int htc_parse_trailer(struct htc_target *target,
 	}
 
 	return 0;
-
 }
 
 static int htc_proc_trailer(struct htc_target *target,
@@ -1776,7 +1767,6 @@ static int htc_proc_trailer(struct htc_target *target,
 	status = 0;
 
 	while (len > 0) {
-
 		if (len < sizeof(struct htc_record_hdr)) {
 			status = -ENOMEM;
 			break;
@@ -2098,7 +2088,6 @@ static int ath6kl_htc_rx_fetch(struct htc_target *target,
 		}
 
 		if (!fetched_pkts) {
-
 			packet = list_first_entry(rx_pktq, struct htc_packet,
 						   list);
 
@@ -2173,7 +2162,6 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 	look_aheads[0] = msg_look_ahead;
 
 	while (true) {
-
 		/*
 		 * First lookahead sets the expected endpoint IDs for all
 		 * packets in a bundle.
diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 67aa924..756fe52 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -137,7 +137,6 @@ static void get_htc_packet_credit_based(struct htc_target *target,
 			credits_required = 0;
 
 		} else {
-
 			if (ep->cred_dist.credits < credits_required)
 				break;
 
@@ -169,7 +168,6 @@ static void get_htc_packet_credit_based(struct htc_target *target,
 		/* queue this packet into the caller's queue */
 		list_add_tail(&packet->list, queue);
 	}
-
 }
 
 static void get_htc_packet(struct htc_target *target,
@@ -279,7 +277,6 @@ static int htc_issue_packets(struct htc_target *target,
 			list_add(&packet->list, pkt_queue);
 			break;
 		}
-
 	}
 
 	if (status != 0) {
@@ -385,7 +382,6 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
 			 */
 			list_for_each_entry_safe(packet, tmp_pkt,
 						 txq, list) {
-
 				ath6kl_dbg(ATH6KL_DBG_HTC,
 					   "%s: Indicat overflowed TX pkts: %p\n",
 					   __func__, packet);
@@ -403,7 +399,6 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
 					list_move_tail(&packet->list,
 						       &send_queue);
 				}
-
 			}
 
 			if (list_empty(&send_queue)) {
@@ -454,7 +449,6 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
 	 * enough transmit resources.
 	 */
 	while (true) {
-
 		if (get_queue_depth(&ep->txq) == 0)
 			break;
 
@@ -495,8 +489,8 @@ static enum htc_send_queue_result htc_try_send(struct htc_target *target,
 		}
 
 		spin_lock_bh(&target->tx_lock);
-
 	}
+
 	/* done with this endpoint, we can clear the count */
 	ep->tx_proc_cnt = 0;
 	spin_unlock_bh(&target->tx_lock);
@@ -1106,7 +1100,6 @@ free_skb:
 	dev_kfree_skb(skb);
 
 	return status;
-
 }
 
 static void htc_flush_rx_queue(struct htc_target *target,
@@ -1258,7 +1251,6 @@ static int ath6kl_htc_pipe_conn_service(struct htc_target *target,
 		tx_alloc = 0;
 
 	} else {
-
 		tx_alloc = htc_get_credit_alloc(target, conn_req->svc_id);
 		if (tx_alloc == 0) {
 			status = -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 4f316bd..d5ef211 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1192,7 +1192,6 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 
 	if (board_ext_address &&
 	    ar->fw_board_len == (board_data_size + board_ext_data_size)) {
-
 		/* write extended board data */
 		ath6kl_dbg(ATH6KL_DBG_BOOT,
 			   "writing extended board data to 0x%x (%d B)\n",
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 5839fc2..fcaab0f 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -571,7 +571,6 @@ void ath6kl_scan_complete_evt(struct ath6kl_vif *vif, int status)
 
 static int ath6kl_commit_ch_switch(struct ath6kl_vif *vif, u16 channel)
 {
-
 	struct ath6kl *ar = vif->ar;
 
 	vif->profile.ch = cpu_to_le16(channel);
@@ -600,7 +599,6 @@ static int ath6kl_commit_ch_switch(struct ath6kl_vif *vif, u16 channel)
 
 static void ath6kl_check_ch_switch(struct ath6kl *ar, u16 channel)
 {
-
 	struct ath6kl_vif *vif;
 	int res = 0;
 
@@ -694,7 +692,6 @@ void ath6kl_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid, bool ismcast)
 					     tsc, GFP_KERNEL);
 	} else
 		ath6kl_cfg80211_tkip_micerr_event(vif, keyid, ismcast);
-
 }
 
 static void ath6kl_update_target_stats(struct ath6kl_vif *vif, u8 *ptr, u32 len)
@@ -1146,7 +1143,6 @@ static int ath6kl_set_features(struct net_device *dev,
 			dev->features = features | NETIF_F_RXCSUM;
 			return err;
 		}
-
 	}
 
 	return err;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 7126bdd..9c73b62 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -656,7 +656,6 @@ static void ath6kl_sdio_scatter_req_add(struct ath6kl *ar,
 	list_add_tail(&s_req->list, &ar_sdio->scat_req);
 
 	spin_unlock_bh(&ar_sdio->scat_lock);
-
 }
 
 /* scatter gather read write request */
@@ -856,7 +855,6 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 
 	if (ar->suspend_mode == WLAN_POWER_STATE_WOW ||
 	    (!ar->suspend_mode && wow)) {
-
 		ret = ath6kl_set_sdio_pm_caps(ar);
 		if (ret)
 			goto cut_pwr;
@@ -878,7 +876,6 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 
 	if (ar->suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP ||
 	    !ar->suspend_mode || try_deepsleep) {
-
 		flags = sdio_get_host_pm_caps(func);
 		if (!(flags & MMC_PM_KEEP_POWER))
 			goto cut_pwr;
@@ -1061,7 +1058,6 @@ static int ath6kl_sdio_bmi_credits(struct ath6kl *ar)
 
 	timeout = jiffies + msecs_to_jiffies(BMI_COMMUNICATION_TIMEOUT);
 	while (time_before(jiffies, timeout) && !ar->bmi.cmd_credits) {
-
 		/*
 		 * Hit the credit counter with a 4-byte access, the first byte
 		 * read will hit the counter and cause a decrement, while the
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index ebb2404..cf27a71 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -702,7 +702,6 @@ void ath6kl_tx_complete(struct htc_target *target,
 
 	/* reap completed packets */
 	while (!list_empty(packet_queue)) {
-
 		packet = list_first_entry(packet_queue, struct htc_packet,
 					  list);
 		list_del(&packet->list);
@@ -1265,7 +1264,6 @@ static void ath6kl_uapsd_trigger_frame_rx(struct ath6kl_vif *vif,
 	is_apsdq_empty_at_start = is_apsdq_empty;
 
 	while ((!is_apsdq_empty) && (num_frames_to_deliver)) {
-
 		spin_lock_bh(&conn->psq_lock);
 		skb = skb_dequeue(&conn->apsdq);
 		is_apsdq_empty = skb_queue_empty(&conn->apsdq);
@@ -1766,7 +1764,6 @@ void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info *aggr_info,
 		skb_queue_head_init(&rxtid->q);
 		spin_lock_init(&rxtid->lock);
 	}
-
 }
 
 struct aggr_info *aggr_init(struct ath6kl_vif *vif)
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 56c3fd5..3afc5a4 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -236,7 +236,6 @@ static void ath6kl_usb_free_pipe_resources(struct ath6kl_usb_pipe *pipe)
 			break;
 		kfree(urb_context);
 	}
-
 }
 
 static void ath6kl_usb_cleanup_pipe_resources(struct ath6kl_usb *ar_usb)
@@ -245,7 +244,6 @@ static void ath6kl_usb_cleanup_pipe_resources(struct ath6kl_usb *ar_usb)
 
 	for (i = 0; i < ATH6KL_USB_PIPE_MAX; i++)
 		ath6kl_usb_free_pipe_resources(&ar_usb->pipes[i]);
-
 }
 
 static u8 ath6kl_usb_get_logical_pipe_num(struct ath6kl_usb *ar_usb,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 8b4ce28..34c4954 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -936,7 +936,6 @@ ath6kl_regd_find_country_by_rd(u16 regdmn)
 
 static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 {
-
 	struct ath6kl_wmi_regdomain *ev;
 	struct country_code_to_enum_rd *country = NULL;
 	struct reg_dmn_pair_mapping *regpair = NULL;
@@ -949,7 +948,6 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 	if ((reg_code >> ATH6KL_COUNTRY_RD_SHIFT) & COUNTRY_ERD_FLAG)
 		country = ath6kl_regd_find_country((u16) reg_code);
 	else if (!(((u16) reg_code & WORLD_SKU_MASK) == WORLD_SKU_PREFIX)) {
-
 		regpair = ath6kl_get_regpair((u16) reg_code);
 		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
 		if (regpair)
@@ -1499,7 +1497,6 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
 
 	if ((reply->cac_indication == CAC_INDICATION_ADMISSION_RESP) &&
 	    (reply->status_code != IEEE80211_TSPEC_STATUS_ADMISS_ACCEPTED)) {
-
 		ts = (struct ieee80211_tspec_ie *) &(reply->tspec_suggestion);
 		tsinfo = le16_to_cpu(ts->tsinfo);
 		tsid = (tsinfo >> IEEE80211_WMM_IE_TSPEC_TID_SHIFT) &
@@ -1530,7 +1527,6 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
 	 * for delete qos stream from AP
 	 */
 	else if (reply->cac_indication == CAC_INDICATION_DELETE) {
-
 		ts = (struct ieee80211_tspec_ie *) &(reply->tspec_suggestion);
 		tsinfo = le16_to_cpu(ts->tsinfo);
 		ts_id = ((tsinfo >> IEEE80211_WMM_IE_TSPEC_TID_SHIFT) &
@@ -2479,7 +2475,6 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 		goto free_data_skb;
 
 	for (index = 0; index < num_pri_streams; index++) {
-
 		if (WARN_ON(!data_sync_bufs[index].skb))
 			goto free_data_skb;
 
@@ -2704,7 +2699,6 @@ static void ath6kl_wmi_relinquish_implicit_pstream_credits(struct wmi *wmi)
 
 	for (i = 0; i < WMM_NUM_AC; i++) {
 		if (stream_exist & (1 << i)) {
-
 			/*
 			 * FIXME: Is this lock & unlock inside
 			 * for loop correct? may need rework.
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b5f2265..1f05ecd 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -898,7 +898,6 @@ struct wmi_start_scan_cmd {
  *  flags here
  */
 enum wmi_scan_ctrl_flags_bits {
-
 	/* set if can scan in the connect cmd */
 	CONNECT_SCAN_CTRL_FLAGS = 0x01,
 

