Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:33538 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab2B2RTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:00 -0500
Subject: [PATCH 03/12] ath6kl: alignment should match open parenthesis
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:18:55 +0200
Message-ID: <20120229171855.24264.64135.stgit@localhost6.localdomain6> (sfid-20120229_181908_099522_B37DCF57)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the issues which checkpatch found and were easy to fix. Especially
callers of ath6kl_bmi_write() are tricky and that needs to be fixed
separately.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.c      |    6 +--
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   18 ++++----
 drivers/net/wireless/ath/ath6kl/core.c     |    6 +--
 drivers/net/wireless/ath/ath6kl/debug.c    |   48 +++++++++++-----------
 drivers/net/wireless/ath/ath6kl/hif.c      |    6 +--
 drivers/net/wireless/ath/ath6kl/htc.c      |   62 ++++++++++++++--------------
 drivers/net/wireless/ath/ath6kl/init.c     |   20 +++++----
 drivers/net/wireless/ath/ath6kl/main.c     |   18 ++++----
 drivers/net/wireless/ath/ath6kl/sdio.c     |    6 +--
 drivers/net/wireless/ath/ath6kl/txrx.c     |   18 ++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   22 +++++-----
 11 files changed, 115 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index 05d1d89..334dbd8 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -106,7 +106,7 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_BMI, "target info (ver: 0x%x type: 0x%x)\n",
-		targ_info->version, targ_info->type);
+		   targ_info->version, targ_info->type);
 
 	return 0;
 }
@@ -193,7 +193,7 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	memset(ar->bmi.cmd_buf, 0, ar->bmi.max_data_size + header);
 
 	ath6kl_dbg(ATH6KL_DBG_BMI,
-		  "bmi write memory: addr: 0x%x, len: %d\n", addr, len);
+		   "bmi write memory: addr: 0x%x, len: %d\n", addr, len);
 
 	len_remain = len;
 	while (len_remain) {
@@ -435,7 +435,7 @@ int ath6kl_bmi_lz_data(struct ath6kl *ar, u8 *buf, u32 len)
 		memcpy(&(ar->bmi.cmd_buf[offset]), &tx_len, sizeof(tx_len));
 		offset += sizeof(tx_len);
 		memcpy(&(ar->bmi.cmd_buf[offset]), &buf[len - len_remain],
-			tx_len);
+		       tx_len);
 		offset += tx_len;
 
 		ret = ath6kl_hif_bmi_write(ar, ar->bmi.cmd_buf, offset);
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5da0f29..308cc9b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -390,7 +390,7 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
 		return false;
 
 	if (ar->ibss_if_active || ((type == NL80211_IFTYPE_ADHOC) &&
-	    ar->num_vif))
+				   ar->num_vif))
 		return false;
 
 	if (type == NL80211_IFTYPE_STATION ||
@@ -555,7 +555,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (!ar->usr_bss_filter) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
 		if (ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
-		    ALL_BSS_FILTER, 0) != 0) {
+					     ALL_BSS_FILTER, 0) != 0) {
 			ath6kl_err("couldn't set bss filtering\n");
 			up(&ar->sem);
 			return -EIO;
@@ -833,13 +833,13 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 
 	if (vif->sme_state == SME_CONNECTING) {
 		cfg80211_connect_result(vif->ndev,
-				bssid, NULL, 0,
-				NULL, 0,
-				WLAN_STATUS_UNSPECIFIED_FAILURE,
-				GFP_KERNEL);
+					bssid, NULL, 0,
+					NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
 	} else if (vif->sme_state == SME_CONNECTED) {
 		cfg80211_disconnected(vif->ndev, reason,
-				NULL, 0, GFP_KERNEL);
+				      NULL, 0, GFP_KERNEL);
 	}
 
 	vif->sme_state = SME_DISCONNECTED;
@@ -926,7 +926,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		force_fg_scan = 1;
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
-		    ar->fw_capabilities)) {
+		     ar->fw_capabilities)) {
 		/*
 		 * If capable of doing P2P mgmt operations using
 		 * station interface, send additional information like
@@ -1361,7 +1361,7 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	}
 
 	if (ath6kl_wmi_powermode_cmd(ar->wmi, vif->fw_vif_idx,
-	     mode.pwr_mode) != 0) {
+				     mode.pwr_mode) != 0) {
 		ath6kl_err("wmi_powermode_cmd failed\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 3968465..3a67a52 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -128,7 +128,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
-			__func__, ndev->name, ndev, ar);
+		   __func__, ndev->name, ndev, ar);
 
 	/* setup access class priority mappings */
 	ar->ac_stream_pri_map[WMM_AC_BK] = 0; /* lowest  */
@@ -145,8 +145,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
 	if (suspend_mode &&
-		suspend_mode >= WLAN_POWER_STATE_CUT_PWR &&
-		suspend_mode <= WLAN_POWER_STATE_WOW)
+	    suspend_mode >= WLAN_POWER_STATE_CUT_PWR &&
+	    suspend_mode <= WLAN_POWER_STATE_WOW)
 		ar->suspend_mode = suspend_mode;
 	else
 		ar->suspend_mode = 0;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index ff4c614..ba07452 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -119,29 +119,29 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 
 	if (irq_proc_reg != NULL) {
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
-			"Host Int status:           0x%x\n",
-			irq_proc_reg->host_int_status);
+			   "Host Int status:           0x%x\n",
+			   irq_proc_reg->host_int_status);
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
 			   "CPU Int status:            0x%x\n",
-			irq_proc_reg->cpu_int_status);
+			   irq_proc_reg->cpu_int_status);
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
 			   "Error Int status:          0x%x\n",
-			irq_proc_reg->error_int_status);
+			   irq_proc_reg->error_int_status);
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
 			   "Counter Int status:        0x%x\n",
-			irq_proc_reg->counter_int_status);
+			   irq_proc_reg->counter_int_status);
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
 			   "Mbox Frame:                0x%x\n",
-			irq_proc_reg->mbox_frame);
+			   irq_proc_reg->mbox_frame);
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
 			   "Rx Lookahead Valid:        0x%x\n",
-			irq_proc_reg->rx_lkahd_valid);
+			   irq_proc_reg->rx_lkahd_valid);
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
 			   "Rx Lookahead 0:            0x%x\n",
-			irq_proc_reg->rx_lkahd[0]);
+			   irq_proc_reg->rx_lkahd[0]);
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
 			   "Rx Lookahead 1:            0x%x\n",
-			irq_proc_reg->rx_lkahd[1]);
+			   irq_proc_reg->rx_lkahd[1]);
 
 		if (dev->ar->mbox_info.gmbox_addr != 0) {
 			/*
@@ -149,27 +149,27 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 			 * additional state.
 			 */
 			ath6kl_dbg(ATH6KL_DBG_IRQ,
-				"GMBOX Host Int status 2:   0x%x\n",
-				irq_proc_reg->host_int_status2);
+				   "GMBOX Host Int status 2:   0x%x\n",
+				   irq_proc_reg->host_int_status2);
 			ath6kl_dbg(ATH6KL_DBG_IRQ,
-				"GMBOX RX Avail:            0x%x\n",
-				irq_proc_reg->gmbox_rx_avail);
+				   "GMBOX RX Avail:            0x%x\n",
+				   irq_proc_reg->gmbox_rx_avail);
 			ath6kl_dbg(ATH6KL_DBG_IRQ,
-				"GMBOX lookahead alias 0:   0x%x\n",
-				irq_proc_reg->rx_gmbox_lkahd_alias[0]);
+				   "GMBOX lookahead alias 0:   0x%x\n",
+				   irq_proc_reg->rx_gmbox_lkahd_alias[0]);
 			ath6kl_dbg(ATH6KL_DBG_IRQ,
-				"GMBOX lookahead alias 1:   0x%x\n",
-				irq_proc_reg->rx_gmbox_lkahd_alias[1]);
+				   "GMBOX lookahead alias 1:   0x%x\n",
+				   irq_proc_reg->rx_gmbox_lkahd_alias[1]);
 		}
 
 	}
 
 	if (irq_enable_reg != NULL) {
 		ath6kl_dbg(ATH6KL_DBG_IRQ,
-			"Int status Enable:         0x%x\n",
-			irq_enable_reg->int_status_en);
+			   "Int status Enable:         0x%x\n",
+			   irq_enable_reg->int_status_en);
 		ath6kl_dbg(ATH6KL_DBG_IRQ, "Counter Int status Enable: 0x%x\n",
-			irq_enable_reg->cntr_int_status_en);
+			   irq_enable_reg->cntr_int_status_en);
 	}
 	ath6kl_dbg(ATH6KL_DBG_IRQ, "<------------------------------->\n");
 }
@@ -1788,19 +1788,19 @@ int ath6kl_debug_init(struct ath6kl *ar)
 			    ar->debugfs_phy, ar, &fops_disconnect_timeout);
 
 	debugfs_create_file("create_qos", S_IWUSR, ar->debugfs_phy, ar,
-				&fops_create_qos);
+			    &fops_create_qos);
 
 	debugfs_create_file("delete_qos", S_IWUSR, ar->debugfs_phy, ar,
-				&fops_delete_qos);
+			    &fops_delete_qos);
 
 	debugfs_create_file("bgscan_interval", S_IWUSR,
-				ar->debugfs_phy, ar, &fops_bgscan_int);
+			    ar->debugfs_phy, ar, &fops_bgscan_int);
 
 	debugfs_create_file("listen_interval", S_IRUSR | S_IWUSR,
 			    ar->debugfs_phy, ar, &fops_listen_int);
 
 	debugfs_create_file("power_params", S_IWUSR, ar->debugfs_phy, ar,
-						&fops_power_params);
+			    &fops_power_params);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index ef650b6..29f0e85 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -90,7 +90,7 @@ static void ath6kl_hif_dump_fw_crash(struct ath6kl *ar)
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_IRQ, "register dump data address 0x%x\n",
-		regdump_addr);
+		   regdump_addr);
 	regdump_addr = TARG_VTOP(ar->target_type, regdump_addr);
 
 	/* fetch register dump data */
@@ -284,7 +284,7 @@ static int ath6kl_hif_proc_counter_intr(struct ath6kl_device *dev)
 			     dev->irq_en_reg.cntr_int_status_en;
 
 	ath6kl_dbg(ATH6KL_DBG_IRQ,
-		"valid interrupt source(s) in COUNTER_INT_STATUS: 0x%x\n",
+		   "valid interrupt source(s) in COUNTER_INT_STATUS: 0x%x\n",
 		counter_int_status);
 
 	/*
@@ -359,7 +359,7 @@ static int ath6kl_hif_proc_cpu_intr(struct ath6kl_device *dev)
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_IRQ,
-		"valid interrupt source(s) in CPU_INT_STATUS: 0x%x\n",
+		   "valid interrupt source(s) in CPU_INT_STATUS: 0x%x\n",
 		cpu_int_status);
 
 	/* Clear the interrupt */
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index c6f45a7..0204b83 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -185,8 +185,8 @@ static void ath6kl_credit_update(struct ath6kl_htc_credit_info *cred_info,
 			if (cur_dist_list->credits >
 			    cur_dist_list->cred_assngd)
 				ath6kl_credit_reduce(cred_info,
-						cur_dist_list,
-						cur_dist_list->cred_assngd);
+						     cur_dist_list,
+						     cur_dist_list->cred_assngd);
 
 			if (cur_dist_list->credits >
 			    cur_dist_list->cred_norm)
@@ -464,8 +464,8 @@ static void htc_async_tx_scat_complete(struct htc_target *target,
 	INIT_LIST_HEAD(&tx_compq);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		"htc tx scat complete len %d entries %d\n",
-		scat_req->len, scat_req->scat_entries);
+		   "htc tx scat complete len %d entries %d\n",
+		   scat_req->len, scat_req->scat_entries);
 
 	if (scat_req->status)
 		ath6kl_err("send scatter req failed: %d\n", scat_req->status);
@@ -603,8 +603,8 @@ static void ath6kl_htc_tx_pkts_get(struct htc_target *target,
 					  list);
 
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			"htc tx got packet 0x%p queue depth %d\n",
-			packet, get_queue_depth(&endpoint->txq));
+			   "htc tx got packet 0x%p queue depth %d\n",
+			   packet, get_queue_depth(&endpoint->txq));
 
 		len = CALC_TXRX_PADDED_LEN(target,
 					   packet->act_len + HTC_HDR_LENGTH);
@@ -701,8 +701,8 @@ static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
 		scat_req->scat_list[i].packet = packet;
 		/* prepare packet and flag message as part of a send bundle */
 		ath6kl_htc_tx_prep_pkt(packet,
-				packet->info.tx.flags | HTC_FLAGS_SEND_BUNDLE,
-				cred_pad, packet->info.tx.seqno);
+				       packet->info.tx.flags | HTC_FLAGS_SEND_BUNDLE,
+				       cred_pad, packet->info.tx.seqno);
 		/* Make sure the buffer is 4-byte aligned */
 		ath6kl_htc_tx_buf_align(&packet->buf,
 					packet->act_len + HTC_HDR_LENGTH);
@@ -752,7 +752,7 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 	u8 ac = WMM_NUM_AC;
 
 	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) ||
-		(WMI_CONTROL_SVC != endpoint->svc_id))
+	    (WMI_CONTROL_SVC != endpoint->svc_id))
 		ac = target->dev->ar->ep2ac_map[endpoint->eid];
 
 	while (true) {
@@ -769,7 +769,7 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 		if (!scat_req) {
 			/* no scatter resources  */
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				"htc tx no more scatter resources\n");
+				   "htc tx no more scatter resources\n");
 			break;
 		}
 
@@ -860,7 +860,7 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 	INIT_LIST_HEAD(&txq);
 
 	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) ||
-		(WMI_CONTROL_SVC != endpoint->svc_id))
+	    (WMI_CONTROL_SVC != endpoint->svc_id))
 		ac = target->dev->ar->ep2ac_map[endpoint->eid];
 
 	while (true) {
@@ -918,7 +918,7 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 		 */
 		if (!bundle_sent) {
 			if (!(target->tx_bndl_mask & (1 << ac)) &&
-				(ac < WMM_NUM_AC)) {
+			    (ac < WMM_NUM_AC)) {
 				if (++target->ac_tx_count[ac] >=
 					TX_RESUME_BUNDLE_THRESHOLD) {
 					target->ac_tx_count[ac] = 0;
@@ -1042,8 +1042,8 @@ static int htc_setup_tx_complete(struct htc_target *target)
 		memcpy(&setup_comp_ext->flags, &flags,
 		       sizeof(setup_comp_ext->flags));
 		set_htc_pkt_info(send_pkt, NULL, (u8 *) setup_comp_ext,
-				       sizeof(struct htc_setup_comp_ext_msg),
-				       ENDPOINT_0, HTC_SERVICE_TX_PACKET_TAG);
+				 sizeof(struct htc_setup_comp_ext_msg),
+				 ENDPOINT_0, HTC_SERVICE_TX_PACKET_TAG);
 
 	} else {
 		struct htc_setup_comp_msg *setup_comp;
@@ -1051,8 +1051,8 @@ static int htc_setup_tx_complete(struct htc_target *target)
 		memset(setup_comp, 0, sizeof(struct htc_setup_comp_msg));
 		setup_comp->msg_id = cpu_to_le16(HTC_MSG_SETUP_COMPLETE_ID);
 		set_htc_pkt_info(send_pkt, NULL, (u8 *) setup_comp,
-				       sizeof(struct htc_setup_comp_msg),
-				       ENDPOINT_0, HTC_SERVICE_TX_PACKET_TAG);
+				 sizeof(struct htc_setup_comp_msg),
+				 ENDPOINT_0, HTC_SERVICE_TX_PACKET_TAG);
 	}
 
 	/* we want synchronous operation */
@@ -1151,9 +1151,9 @@ void ath6kl_htc_flush_txep(struct htc_target *target,
 		packet->status = -ECANCELED;
 		list_del(&packet->list);
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			"htc tx flushing pkt 0x%p len %d  ep %d tag 0x%x\n",
-			packet, packet->act_len,
-			packet->endpoint, packet->info.tx.tag);
+			   "htc tx flushing pkt 0x%p len %d  ep %d tag 0x%x\n",
+			   packet, packet->act_len,
+			   packet->endpoint, packet->info.tx.tag);
 
 		INIT_LIST_HEAD(&container);
 		list_add_tail(&packet->list, &container);
@@ -1553,7 +1553,7 @@ static void htc_ctrl_rx(struct htc_target *context, struct htc_packet *packets)
 
 	if (packets->act_len > 0) {
 		ath6kl_err("htc_ctrl_rx, got message with len:%zu\n",
-			packets->act_len + HTC_HDR_LENGTH);
+			   packets->act_len + HTC_HDR_LENGTH);
 
 		ath6kl_dbg_dump(ATH6KL_DBG_HTC,
 				"htc rx unexpected endpoint 0 message", "",
@@ -2101,13 +2101,13 @@ fail_rx:
 	list_for_each_entry_safe(packet, tmp_pkt, rx_pktq, list) {
 		list_del(&packet->list);
 		htc_reclaim_rxbuf(target, packet,
-				&target->endpoint[packet->endpoint]);
+				  &target->endpoint[packet->endpoint]);
 	}
 
 	list_for_each_entry_safe(packet, tmp_pkt, &tmp_rxq, list) {
 		list_del(&packet->list);
 		htc_reclaim_rxbuf(target, packet,
-				&target->endpoint[packet->endpoint]);
+				  &target->endpoint[packet->endpoint]);
 	}
 
 	return status;
@@ -2239,11 +2239,11 @@ static struct htc_packet *htc_wait_for_ctrl_msg(struct htc_target *target)
 	u32 look_ahead;
 
 	if (ath6kl_hif_poll_mboxmsg_rx(target->dev, &look_ahead,
-			       HTC_TARGET_RESPONSE_TIMEOUT))
+				       HTC_TARGET_RESPONSE_TIMEOUT))
 		return NULL;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		"htc rx wait ctrl look_ahead 0x%X\n", look_ahead);
+		   "htc rx wait ctrl look_ahead 0x%X\n", look_ahead);
 
 	htc_hdr = (struct htc_frame_hdr *)&look_ahead;
 
@@ -2308,7 +2308,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 	depth = get_queue_depth(pkt_queue);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		"htc rx add multiple ep id %d cnt %d len %d\n",
+		   "htc rx add multiple ep id %d cnt %d len %d\n",
 		first_pkt->endpoint, depth, first_pkt->buf_len);
 
 	endpoint = &target->endpoint[first_pkt->endpoint];
@@ -2334,8 +2334,8 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 	if (target->rx_st_flags & HTC_RECV_WAIT_BUFFERS) {
 		if (target->ep_waiting == first_pkt->endpoint) {
 			ath6kl_dbg(ATH6KL_DBG_HTC,
-				"htc rx blocked on ep %d, unblocking\n",
-				target->ep_waiting);
+				   "htc rx blocked on ep %d, unblocking\n",
+				   target->ep_waiting);
 			target->rx_st_flags &= ~HTC_RECV_WAIT_BUFFERS;
 			target->ep_waiting = ENDPOINT_MAX;
 			rx_unblock = true;
@@ -2676,8 +2676,8 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_BOOT, "htc using protocol %s (%d)\n",
-		  (target->htc_tgt_ver == HTC_VERSION_2P0) ? "2.0" : ">= 2.1",
-		  target->htc_tgt_ver);
+		   (target->htc_tgt_ver == HTC_VERSION_2P0) ? "2.0" : ">= 2.1",
+		   target->htc_tgt_ver);
 
 	if (target->msg_per_bndl_max > 0)
 		htc_setup_msg_bndl(target);
@@ -2871,14 +2871,14 @@ void ath6kl_htc_cleanup(struct htc_target *target)
 		ath6kl_hif_cleanup_scatter(target->dev->ar);
 
 	list_for_each_entry_safe(packet, tmp_packet,
-			&target->free_ctrl_txbuf, list) {
+				 &target->free_ctrl_txbuf, list) {
 		list_del(&packet->list);
 		kfree(packet->buf_start);
 		kfree(packet);
 	}
 
 	list_for_each_entry_safe(packet, tmp_packet,
-			&target->free_ctrl_rxbuf, list) {
+				 &target->free_ctrl_rxbuf, list) {
 		list_del(&packet->list);
 		kfree(packet->buf_start);
 		kfree(packet);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index f3b5502..445426f 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -414,13 +414,13 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 		}
 
 	if (ath6kl_wmi_set_keepalive_cmd(ar->wmi, idx,
-			WLAN_CONFIG_KEEP_ALIVE_INTERVAL)) {
+					 WLAN_CONFIG_KEEP_ALIVE_INTERVAL)) {
 		ath6kl_err("unable to set keep alive interval\n");
 		status = -EIO;
 	}
 
 	if (ath6kl_wmi_disctimeout_cmd(ar->wmi, idx,
-			WLAN_CONFIG_DISCONNECT_TIMEOUT)) {
+				       WLAN_CONFIG_DISCONNECT_TIMEOUT)) {
 		ath6kl_err("unable to set disconnect timeout\n");
 		status = -EIO;
 	}
@@ -833,13 +833,13 @@ static int ath6kl_fetch_testscript_file(struct ath6kl *ar)
 		return 0;
 
 	snprintf(filename, sizeof(filename), "%s/%s",
-		ar->hw.fw.dir, ar->hw.fw.testscript);
+		 ar->hw.fw.dir, ar->hw.fw.testscript);
 
 	ret = ath6kl_get_fw(ar, filename, &ar->fw_testscript,
 				&ar->fw_testscript_len);
 	if (ret) {
 		ath6kl_err("Failed to get testscript file %s: %d\n",
-			filename, ret);
+			   filename, ret);
 		return ret;
 	}
 
@@ -923,7 +923,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 		switch (ie_id) {
 		case ATH6KL_FW_IE_OTP_IMAGE:
 			ath6kl_dbg(ATH6KL_DBG_BOOT, "found otp image ie (%zd B)\n",
-				ie_len);
+				   ie_len);
 
 			ar->fw_otp = kmemdup(data, ie_len, GFP_KERNEL);
 
@@ -936,7 +936,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			break;
 		case ATH6KL_FW_IE_FW_IMAGE:
 			ath6kl_dbg(ATH6KL_DBG_BOOT, "found fw image ie (%zd B)\n",
-				ie_len);
+				   ie_len);
 
 			/* in testmode we already might have a fw file */
 			if (ar->fw != NULL)
@@ -953,7 +953,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			break;
 		case ATH6KL_FW_IE_PATCH_IMAGE:
 			ath6kl_dbg(ATH6KL_DBG_BOOT, "found patch image ie (%zd B)\n",
-				ie_len);
+				   ie_len);
 
 			ar->fw_patch = kmemdup(data, ie_len, GFP_KERNEL);
 
@@ -1313,7 +1313,7 @@ static int ath6kl_upload_testscript(struct ath6kl *ar)
 	address = ar->hw.testscript_addr;
 
 	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing testscript to 0x%x (%zd B)\n",
-		address, ar->fw_testscript_len);
+		   address, ar->fw_testscript_len);
 
 	ret = ath6kl_bmi_write(ar, address, ar->fw_testscript,
 		ar->fw_testscript_len);
@@ -1349,7 +1349,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 	int status = 0;
 
 	if (ar->target_type != TARGET_TYPE_AR6003 &&
-		ar->target_type != TARGET_TYPE_AR6004)
+	    ar->target_type != TARGET_TYPE_AR6004)
 		return -EINVAL;
 
 	/* temporarily disable system sleep */
@@ -1730,7 +1730,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 	 * configure NOT to reset the target during a debug session.
 	 */
 	ath6kl_dbg(ATH6KL_DBG_TRC,
-			"attempting to reset target on instance destroy\n");
+		   "attempting to reset target on instance destroy\n");
 	ath6kl_reset_device(ar, ar->target_type, true, true);
 
 	clear_bit(WLAN_ENABLED, &ar->flag);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0d6e352..18b4e16 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -350,7 +350,7 @@ void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 	__le32 data;
 
 	if (target_type != TARGET_TYPE_AR6003 &&
-		target_type != TARGET_TYPE_AR6004)
+	    target_type != TARGET_TYPE_AR6004)
 		return;
 
 	data = cold_reset ? cpu_to_le32(RESET_CONTROL_COLD_RST) :
@@ -950,8 +950,8 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 	}
 
 	ath6kl_cfg80211_disconnect_event(vif, reason, bssid,
-				       assoc_resp_len, assoc_info,
-				       prot_reason_status);
+					 assoc_resp_len, assoc_info,
+					 prot_reason_status);
 
 	aggr_reset_state(vif->aggr_cntxt->aggr_conn);
 
@@ -971,7 +971,7 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 	} else {
 		set_bit(CONNECT_PEND, &vif->flags);
 		if (((reason == ASSOC_FAILED) &&
-		    (prot_reason_status == 0x11)) ||
+		     (prot_reason_status == 0x11)) ||
 		    ((reason == ASSOC_FAILED) && (prot_reason_status == 0x0)
 		     && (vif->reconnect_flag == 1))) {
 			set_bit(CONNECTED, &vif->flags);
@@ -1107,7 +1107,7 @@ static void ath6kl_set_multicast_list(struct net_device *ndev)
 	if (mc_all_on || mc_all_off) {
 		/* Enable/disable all multicast */
 		ath6kl_dbg(ATH6KL_DBG_TRC, "%s multicast filter\n",
-			  mc_all_on ? "enabling" : "disabling");
+			   mc_all_on ? "enabling" : "disabling");
 		ret = ath6kl_wmi_mcast_filter_cmd(vif->ar->wmi, vif->fw_vif_idx,
 						  mc_all_on);
 		if (ret)
@@ -1120,7 +1120,7 @@ static void ath6kl_set_multicast_list(struct net_device *ndev)
 		found = false;
 		netdev_for_each_mc_addr(ha, ndev) {
 			if (memcmp(ha->addr, mc_filter->hw_addr,
-			    ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE) == 0) {
+				   ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE) == 0) {
 				found = true;
 				break;
 			}
@@ -1139,7 +1139,7 @@ static void ath6kl_set_multicast_list(struct net_device *ndev)
 					false);
 			if (ret) {
 				ath6kl_warn("Failed to remove multicast filter:%pM\n",
-					     mc_filter->hw_addr);
+					    mc_filter->hw_addr);
 				return;
 			}
 
@@ -1154,7 +1154,7 @@ static void ath6kl_set_multicast_list(struct net_device *ndev)
 		found = false;
 		list_for_each_entry(mc_filter, &vif->mc_filter, list) {
 			if (memcmp(ha->addr, mc_filter->hw_addr,
-			    ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE) == 0) {
+				   ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE) == 0) {
 				found = true;
 				break;
 			}
@@ -1179,7 +1179,7 @@ static void ath6kl_set_multicast_list(struct net_device *ndev)
 					true);
 			if (ret) {
 				ath6kl_warn("Failed to add multicast filter :%pM\n",
-					     mc_filter->hw_addr);
+					    mc_filter->hw_addr);
 				kfree(mc_filter);
 				goto out;
 			}
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index cae446b..da14ca6 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -636,8 +636,8 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 		return -EINVAL;
 
 	ath6kl_dbg(ATH6KL_DBG_SCATTER,
-		"hif-scatter: total len: %d scatter entries: %d\n",
-		scat_req->len, scat_req->scat_entries);
+		   "hif-scatter: total len: %d scatter entries: %d\n",
+		   scat_req->len, scat_req->scat_entries);
 
 	if (request & HIF_SYNCHRONOUS)
 		status = ath6kl_sdio_scat_rw(ar_sdio, scat_req->busrequest);
@@ -984,7 +984,7 @@ static int ath6kl_sdio_diag_read32(struct ath6kl *ar, u32 address, u32 *data)
 				(u8 *)data, sizeof(u32), HIF_RD_SYNC_BYTE_INC);
 	if (status) {
 		ath6kl_err("%s: failed to read from window data addr\n",
-			__func__);
+			   __func__);
 		return status;
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 8022913..67fe599 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -159,8 +159,8 @@ static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
 	 */
 	if (is_apsdq_empty) {
 		ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
-				vif->fw_vif_idx,
-				conn->aid, 1, 0);
+					      vif->fw_vif_idx,
+					      conn->aid, 1, 0);
 	}
 	*flags |= WMI_DATA_HDR_FLAGS_UAPSD;
 
@@ -371,7 +371,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
 		if ((dev->features & NETIF_F_IP_CSUM) &&
-				(csum == CHECKSUM_PARTIAL)) {
+		    (csum == CHECKSUM_PARTIAL)) {
 			csum_start = skb->csum_start -
 					(skb_network_header(skb) - skb->head) +
 					sizeof(struct ath6kl_llc_snap_hdr);
@@ -395,7 +395,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		if ((dev->features & NETIF_F_IP_CSUM) &&
-				(csum == CHECKSUM_PARTIAL)) {
+		    (csum == CHECKSUM_PARTIAL)) {
 			meta_v2.csum_start = csum_start;
 			meta_v2.csum_dest = csum_dest;
 
@@ -420,7 +420,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		if ((vif->nw_type == ADHOC_NETWORK) &&
-		     ar->ibss_ps_enable && test_bit(CONNECTED, &vif->flags))
+		    ar->ibss_ps_enable && test_bit(CONNECTED, &vif->flags))
 			chk_adhoc_ps_mapping = true;
 		else {
 			/* get the stream mapping */
@@ -878,7 +878,7 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 		if (!IS_ALIGNED((unsigned long) skb->data, 4))
 			skb->data = PTR_ALIGN(skb->data - 4, 4);
 		set_htc_rxpkt_info(packet, skb, skb->data,
-				ATH6KL_BUFFER_SIZE, endpoint);
+				   ATH6KL_BUFFER_SIZE, endpoint);
 		list_add_tail(&packet->list, &queue);
 	}
 
@@ -1258,8 +1258,8 @@ static void ath6kl_uapsd_trigger_frame_rx(struct ath6kl_vif *vif,
 			flags = 0;
 
 		ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
-				vif->fw_vif_idx,
-				conn->aid, 0, flags);
+					      vif->fw_vif_idx,
+					      conn->aid, 0, flags);
 	}
 
 	return;
@@ -1568,7 +1568,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			aggr_conn = vif->aggr_cntxt->aggr_conn;
 
 		if (aggr_process_recv_frm(aggr_conn, tid, seq_no,
-		    is_amsdu, skb)) {
+					  is_amsdu, skb)) {
 			/* aggregation code will handle the skb */
 			return;
 		}
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index fce29f7..1269f6a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -127,7 +127,7 @@ int ath6kl_wmi_dix_2_dot3(struct wmi *wmi, struct sk_buff *skb)
 
 	if (!is_ethertype(be16_to_cpu(type))) {
 		ath6kl_dbg(ATH6KL_DBG_WMI,
-			"%s: pkt is already in 802.3 format\n", __func__);
+			   "%s: pkt is already in 802.3 format\n", __func__);
 		return 0;
 	}
 
@@ -911,7 +911,7 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 		regpair = ath6kl_get_regpair((u16) reg_code);
 		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
 		ath6kl_dbg(ATH6KL_DBG_WMI, "Regpair used: 0x%0x\n",
-				regpair->regDmnEnum);
+			   regpair->regDmnEnum);
 	}
 
 	if (country) {
@@ -921,7 +921,7 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 		regulatory_hint(wmi->parent_dev->wiphy, alpha2);
 
 		ath6kl_dbg(ATH6KL_DBG_WMI, "Country alpha2 being used: %c%c\n",
-				alpha2[0], alpha2[1]);
+			   alpha2[0], alpha2[1]);
 	}
 }
 
@@ -1365,8 +1365,8 @@ static int ath6kl_wmi_rssi_threshold_event_rx(struct wmi *wmi, u8 *datap,
 		/* Upper threshold breached */
 		if (rssi < sq_thresh->upper_threshold[0]) {
 			ath6kl_dbg(ATH6KL_DBG_WMI,
-				"spurious upper rssi threshold event: %d\n",
-				rssi);
+				   "spurious upper rssi threshold event: %d\n",
+				   rssi);
 		} else if ((rssi < sq_thresh->upper_threshold[1]) &&
 			   (rssi >= sq_thresh->upper_threshold[0])) {
 			new_threshold = WMI_RSSI_THRESHOLD1_ABOVE;
@@ -1389,7 +1389,7 @@ static int ath6kl_wmi_rssi_threshold_event_rx(struct wmi *wmi, u8 *datap,
 		/* Lower threshold breached */
 		if (rssi > sq_thresh->lower_threshold[0]) {
 			ath6kl_dbg(ATH6KL_DBG_WMI,
-				"spurious lower rssi threshold event: %d %d\n",
+				   "spurious lower rssi threshold event: %d %d\n",
 				rssi, sq_thresh->lower_threshold[0]);
 		} else if ((rssi > sq_thresh->lower_threshold[1]) &&
 			   (rssi <= sq_thresh->lower_threshold[0])) {
@@ -1550,8 +1550,8 @@ static int ath6kl_wmi_snr_threshold_event_rx(struct wmi *wmi, u8 *datap,
 		/* Upper threshold breached */
 		if (snr < sq_thresh->upper_threshold[0]) {
 			ath6kl_dbg(ATH6KL_DBG_WMI,
-				"spurious upper snr threshold event: %d\n",
-				snr);
+				   "spurious upper snr threshold event: %d\n",
+				   snr);
 		} else if ((snr < sq_thresh->upper_threshold[1]) &&
 			   (snr >= sq_thresh->upper_threshold[0])) {
 			new_threshold = WMI_SNR_THRESHOLD1_ABOVE;
@@ -1568,8 +1568,8 @@ static int ath6kl_wmi_snr_threshold_event_rx(struct wmi *wmi, u8 *datap,
 		/* Lower threshold breached */
 		if (snr > sq_thresh->lower_threshold[0]) {
 			ath6kl_dbg(ATH6KL_DBG_WMI,
-				"spurious lower snr threshold event: %d\n",
-				sq_thresh->lower_threshold[0]);
+				   "spurious lower snr threshold event: %d\n",
+				   sq_thresh->lower_threshold[0]);
 		} else if ((snr > sq_thresh->lower_threshold[1]) &&
 			   (snr <= sq_thresh->lower_threshold[0])) {
 			new_threshold = WMI_SNR_THRESHOLD4_BELOW;
@@ -2612,7 +2612,7 @@ int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
 	int ret;
 
 	if ((wow_mode != ATH6KL_WOW_MODE_ENABLE) &&
-	     wow_mode != ATH6KL_WOW_MODE_DISABLE) {
+	    wow_mode != ATH6KL_WOW_MODE_DISABLE) {
 		ath6kl_err("invalid wow mode: %d\n", wow_mode);
 		return -EINVAL;
 	}

