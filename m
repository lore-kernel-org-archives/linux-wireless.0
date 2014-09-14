Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:33881 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaINJmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:42:46 -0400
Subject: [PATCH 02/10] ath10k: fix checkpatch warnings about parenthesis
 alignment
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:06 +0300
Message-ID: <20140914095006.9063.41102.stgit@x230> (sfid-20140914_114249_657033_FC2B563C)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CHECK: Alignment should match open parenthesis

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.h     |   10 +++++-----
 drivers/net/wireless/ath/ath10k/debug.c  |   15 ++++++++-------
 drivers/net/wireless/ath/ath10k/htc.c    |    2 +-
 drivers/net/wireless/ath/ath10k/htt.c    |    2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   12 ++++++------
 drivers/net/wireless/ath/ath10k/mac.c    |   13 +++++++------
 drivers/net/wireless/ath/ath10k/pci.c    |   14 +++++++-------
 drivers/net/wireless/ath/ath10k/wmi.c    |   30 ++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/wmi.h    |    8 ++++----
 9 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 82d1f23546b9..ad4fa7eb945f 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -189,10 +189,10 @@ int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
  * Pops 1 completed send buffer from Source ring.
  */
 int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
-			   void **per_transfer_contextp,
-			   u32 *bufferp,
-			   unsigned int *nbytesp,
-			   unsigned int *transfer_idp);
+				  void **per_transfer_contextp,
+				  u32 *bufferp,
+				  unsigned int *nbytesp,
+				  unsigned int *transfer_idp);
 
 /*==================CE Engine Initialization=======================*/
 
@@ -202,7 +202,7 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 			void (*recv_cb)(struct ath10k_ce_pipe *));
 void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
-			  const struct ce_attr *attr);
+			 const struct ce_attr *attr);
 void ath10k_ce_free_pipe(struct ath10k *ar, int ce_id);
 
 /*==================CE Engine Shutdown=======================*/
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c1921143a870..2bfd00b29204 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -645,7 +645,8 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		 * firmware variants in order to force a firmware crash.
 		 */
 		ret = ath10k_wmi_vdev_set_param(ar, 0x7fff,
-					ar->wmi.vdev_param->rts_threshold, 0);
+						ar->wmi.vdev_param->rts_threshold,
+						0);
 	} else if (!strcmp(buf, "assert")) {
 		ath10k_info(ar, "simulating firmware assert crash\n");
 		ret = ath10k_debug_fw_assert(ar);
@@ -867,8 +868,8 @@ static void ath10k_debug_htt_stats_dwork(struct work_struct *work)
 }
 
 static ssize_t ath10k_read_htt_stats_mask(struct file *file,
-					    char __user *user_buf,
-					    size_t count, loff_t *ppos)
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
 	char buf[32];
@@ -880,8 +881,8 @@ static ssize_t ath10k_read_htt_stats_mask(struct file *file,
 }
 
 static ssize_t ath10k_write_htt_stats_mask(struct file *file,
-					     const char __user *user_buf,
-					     size_t count, loff_t *ppos)
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
 	unsigned long mask;
@@ -986,8 +987,8 @@ static const struct file_operations fops_htt_max_amsdu_ampdu = {
 };
 
 static ssize_t ath10k_read_fw_dbglog(struct file *file,
-					    char __user *user_buf,
-					    size_t count, loff_t *ppos)
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
 	unsigned int len;
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index fd9a251f0659..b7ee24b19f59 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -569,7 +569,7 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 			ath10k_hif_send_complete_check(htc->ar, i, 1);
 
 		status = wait_for_completion_timeout(&htc->ctl_resp,
-					ATH10K_HTC_WAIT_TIMEOUT_HZ);
+						     ATH10K_HTC_WAIT_TIMEOUT_HZ);
 
 		if (status == 0)
 			status = -ETIMEDOUT;
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 87daae11f116..56cb4aceb383 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -101,7 +101,7 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
 		return status;
 
 	status = wait_for_completion_timeout(&htt->target_version_received,
-						HTT_TARGET_VERSION_TIMEOUT_HZ);
+					     HTT_TARGET_VERSION_TIMEOUT_HZ);
 	if (status <= 0) {
 		ath10k_warn(ar, "htt version request timed out\n");
 		return -ETIMEDOUT;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7313bd16a4b3..a720de3d20c4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -626,7 +626,7 @@ static struct ieee80211_hdr *ath10k_htt_rx_skb_get_hdr(struct sk_buff *skb)
 
 	rxd = (void *)skb->data - sizeof(*rxd);
 	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-			RX_MSDU_START_INFO1_DECAP_FORMAT);
+		 RX_MSDU_START_INFO1_DECAP_FORMAT);
 
 	if (fmt == RX_MSDU_DECAP_RAW)
 		return (void *)skb->data;
@@ -915,7 +915,7 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
 
 	rxd = (void *)skb->data - sizeof(*rxd);
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
-			RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
 
 	hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
@@ -1030,9 +1030,9 @@ static void ath10k_htt_rx_msdu(struct ath10k_htt *htt,
 
 	rxd = (void *)skb->data - sizeof(*rxd);
 	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-			RX_MSDU_START_INFO1_DECAP_FORMAT);
+		 RX_MSDU_START_INFO1_DECAP_FORMAT);
 	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
-			RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
 	hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
@@ -1333,7 +1333,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 }
 
 static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
-				struct htt_rx_fragment_indication *frag)
+				       struct htt_rx_fragment_indication *frag)
 {
 	struct ath10k *ar = htt->ar;
 	struct sk_buff *msdu_head, *msdu_tail;
@@ -1379,7 +1379,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	tkip_mic_err = !!(attention & RX_ATTENTION_FLAGS_TKIP_MIC_ERR);
 	decrypt_err = !!(attention & RX_ATTENTION_FLAGS_DECRYPT_ERR);
 	fmt = MS(__le32_to_cpu(rxd->msdu_start.info1),
-			RX_MSDU_START_INFO1_DECAP_FORMAT);
+		 RX_MSDU_START_INFO1_DECAP_FORMAT);
 
 	if (fmt != RX_MSDU_DECAP_RAW) {
 		ath10k_warn(ar, "we dont support non-raw fragmented rx yet\n");
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5b35fff8127f..bd852078a413 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -896,7 +896,7 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 }
 
 static void ath10k_control_beaconing(struct ath10k_vif *arvif,
-				struct ieee80211_bss_conf *info)
+				     struct ieee80211_bss_conf *info)
 {
 	struct ath10k *ar = arvif->ar;
 	int ret = 0;
@@ -1106,9 +1106,9 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 		ies = rcu_dereference(bss->ies);
 
 		wpaie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
-				WLAN_OUI_TYPE_MICROSOFT_WPA,
-				ies->data,
-				ies->len);
+						WLAN_OUI_TYPE_MICROSOFT_WPA,
+						ies->data,
+						ies->len);
 		rcu_read_unlock();
 		cfg80211_put_bss(ar->hw->wiphy, bss);
 	}
@@ -1291,7 +1291,8 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 		   sta->listen_interval - mac80211 patch required.
 		   Currently use 10 seconds */
 		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id, sta->addr,
-					WMI_AP_PS_PEER_PARAM_AGEOUT_TIME, 10);
+						 WMI_AP_PS_PEER_PARAM_AGEOUT_TIME,
+						 10);
 		if (ret) {
 			ath10k_warn(ar, "failed to set ap ps peer param ageout time for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
@@ -3568,7 +3569,7 @@ exit:
 }
 
 static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
-				 u16 ac, bool enable)
+				u16 ac, bool enable)
 {
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	u32 value = 0;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index baeb98e78b1f..52f273b92fa3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -527,7 +527,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 						     address);
 
 		ret = ath10k_ce_send(ce_diag, NULL, (u32)address, nbytes, 0,
-				 0);
+				     0);
 		if (ret)
 			goto done;
 
@@ -1106,7 +1106,7 @@ static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 }
 
 static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
-						u8 *ul_pipe, u8 *dl_pipe)
+					    u8 *ul_pipe, u8 *dl_pipe)
 {
 	int ul_is_polled, dl_is_polled;
 
@@ -1476,8 +1476,8 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	}
 
 	ret = ath10k_pci_diag_write_mem(ar, pipe_cfg_targ_addr,
-				 target_ce_config_wlan,
-				 sizeof(target_ce_config_wlan));
+					target_ce_config_wlan,
+					sizeof(target_ce_config_wlan));
 
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to write pipe cfg: %d\n", ret);
@@ -1500,8 +1500,8 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	}
 
 	ret = ath10k_pci_diag_write_mem(ar, svc_to_pipe_map,
-				 target_service_to_ce_map_wlan,
-				 sizeof(target_service_to_ce_map_wlan));
+					target_service_to_ce_map_wlan,
+					sizeof(target_service_to_ce_map_wlan));
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to write svc/pipe map: %d\n", ret);
 		return ret;
@@ -2160,7 +2160,7 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 	if (ath10k_pci_irq_mode == ATH10K_PCI_IRQ_AUTO) {
 		ar_pci->num_msi_intrs = MSI_NUM_REQUEST;
 		ret = pci_enable_msi_range(ar_pci->pdev, ar_pci->num_msi_intrs,
-							 ar_pci->num_msi_intrs);
+					   ar_pci->num_msi_intrs);
 		if (ret > 0)
 			return 0;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 3e2213409074..3b5749d8b081 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1859,9 +1859,10 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 	}
 }
 
-static void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
-				struct wmi_single_phyerr_rx_event *event,
-				u64 tsf)
+static void
+ath10k_wmi_event_spectral_scan(struct ath10k *ar,
+			       struct wmi_single_phyerr_rx_event *event,
+			       u64 tsf)
 {
 	int buf_len, tlv_len, res, i = 0;
 	struct phyerr_tlv *tlv;
@@ -1989,7 +1990,7 @@ static void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb)
 }
 
 static void ath10k_wmi_event_profile_match(struct ath10k *ar,
-				    struct sk_buff *skb)
+					   struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PROFILE_MATCH\n");
 }
@@ -2040,13 +2041,13 @@ static void ath10k_wmi_event_wlan_profile_data(struct ath10k *ar,
 }
 
 static void ath10k_wmi_event_rtt_measurement_report(struct ath10k *ar,
-					     struct sk_buff *skb)
+						    struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_RTT_MEASUREMENT_REPORT_EVENTID\n");
 }
 
 static void ath10k_wmi_event_tsf_measurement_report(struct ath10k *ar,
-					     struct sk_buff *skb)
+						    struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TSF_MEASUREMENT_REPORT_EVENTID\n");
 }
@@ -2082,7 +2083,7 @@ static void ath10k_wmi_event_pdev_ftm_intg(struct ath10k *ar,
 }
 
 static void ath10k_wmi_event_gtk_offload_status(struct ath10k *ar,
-					 struct sk_buff *skb)
+						struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_GTK_OFFLOAD_STATUS_EVENTID\n");
 }
@@ -2106,7 +2107,7 @@ static void ath10k_wmi_event_addba_complete(struct ath10k *ar,
 }
 
 static void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
-						struct sk_buff *skb)
+						       struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
 }
@@ -2130,7 +2131,7 @@ static void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar,
 }
 
 static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
-				      u32 num_units, u32 unit_len)
+				     u32 num_units, u32 unit_len)
 {
 	dma_addr_t paddr;
 	u32 pool_size;
@@ -3520,9 +3521,10 @@ int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_delete_cmdid);
 }
 
-static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
-				const struct wmi_vdev_start_request_arg *arg,
-				u32 cmd_id)
+static int
+ath10k_wmi_vdev_start_restart(struct ath10k *ar,
+			      const struct wmi_vdev_start_request_arg *arg,
+			      u32 cmd_id)
 {
 	struct wmi_vdev_start_request_cmd *cmd;
 	struct sk_buff *skb;
@@ -3603,7 +3605,7 @@ int ath10k_wmi_vdev_start(struct ath10k *ar,
 }
 
 int ath10k_wmi_vdev_restart(struct ath10k *ar,
-		     const struct wmi_vdev_start_request_arg *arg)
+			    const struct wmi_vdev_start_request_arg *arg)
 {
 	u32 cmd_id = ar->wmi.cmd->vdev_restart_request_cmdid;
 
@@ -4172,7 +4174,7 @@ static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
 }
 
 int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
-			const struct wmi_pdev_set_wmm_params_arg *arg)
+				   const struct wmi_pdev_set_wmm_params_arg *arg)
 {
 	struct wmi_pdev_set_wmm_params *cmd;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index f8c1afbdb442..1cc594e18a07 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4776,11 +4776,11 @@ int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
 int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
 				    u32 enable);
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
-		    const u8 peer_addr[ETH_ALEN]);
+			   const u8 peer_addr[ETH_ALEN]);
 int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
-		    const u8 peer_addr[ETH_ALEN]);
+			   const u8 peer_addr[ETH_ALEN]);
 int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
-		   const u8 peer_addr[ETH_ALEN], u32 tid_bitmap);
+			  const u8 peer_addr[ETH_ALEN], u32 tid_bitmap);
 int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
 			      const u8 *peer_addr,
 			      enum wmi_peer_param param_id, u32 param_value);
@@ -4797,7 +4797,7 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 			      const struct wmi_scan_chan_list_arg *arg);
 int ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif);
 int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
-			const struct wmi_pdev_set_wmm_params_arg *arg);
+				   const struct wmi_pdev_set_wmm_params_arg *arg);
 int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
 int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 			     enum wmi_force_fw_hang_type type, u32 delay_ms);

