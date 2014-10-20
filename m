Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:48706 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaJTNK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:10:26 -0400
Received: by mail-la0-f52.google.com with SMTP id hz20so3933243lab.11
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:10:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/7] ath10k: make some wmi functions public
Date: Mon, 20 Oct 2014 14:58:44 +0200
Message-Id: <1413809925-4352-7-git-send-email-michal.kazior@tieto.com> (sfid-20141020_151036_578685_87F40E4A)
In-Reply-To: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
References: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some functions can be shared across different WMI
ABIs. Make them public so different WMI backends
can use them from different source files in the
future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 136 ++++++++++++++--------------------
 drivers/net/wireless/ath/ath10k/wmi.h |  61 +++++++++++++++
 2 files changed, 117 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 32c42b2..670ef66 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -610,9 +610,8 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 };
 
-static void
-ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
-			   const struct wmi_channel_arg *arg)
+void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
+				const struct wmi_channel_arg *arg)
 {
 	u32 flags = 0;
 
@@ -982,7 +981,7 @@ static int ath10k_wmi_op_pull_scan_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
+int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_scan_ev_arg arg = {};
 	enum wmi_scan_event_type event_type;
@@ -1167,7 +1166,7 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
+int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_ev_arg arg = {};
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -1315,7 +1314,7 @@ static int ath10k_wmi_op_pull_ch_info_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_ch_info_ev_arg arg = {};
 	struct survey_info *survey;
@@ -1383,12 +1382,12 @@ exit:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_ECHO_EVENTID\n");
 }
 
-static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
+int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
 		   skb->len);
@@ -1398,8 +1397,8 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
-				       struct ath10k_fw_stats_pdev *dst)
+void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
+				struct ath10k_fw_stats_pdev *dst)
 {
 	const struct wal_dbg_tx_stats *tx = &src->wal.tx;
 	const struct wal_dbg_rx_stats *rx = &src->wal.rx;
@@ -1451,8 +1450,8 @@ static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
 	dst->mpdu_errs = __le32_to_cpu(rx->mpdu_errs);
 }
 
-static void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
-				       struct ath10k_fw_stats_peer *dst)
+void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
+				struct ath10k_fw_stats_peer *dst)
 {
 	ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
 	dst->peer_rssi = __le32_to_cpu(src->peer_rssi);
@@ -1574,8 +1573,7 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
-static void ath10k_wmi_event_update_stats(struct ath10k *ar,
-					  struct sk_buff *skb)
+void ath10k_wmi_event_update_stats(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_UPDATE_STATS_EVENTID\n");
 	ath10k_debug_fw_stats_process(ar, skb);
@@ -1599,8 +1597,7 @@ ath10k_wmi_op_pull_vdev_start_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
-					     struct sk_buff *skb)
+void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_vdev_start_ev_arg arg = {};
 	int ret;
@@ -1619,8 +1616,7 @@ static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
 	complete(&ar->vdev_setup_done);
 }
 
-static void ath10k_wmi_event_vdev_stopped(struct ath10k *ar,
-					  struct sk_buff *skb)
+void ath10k_wmi_event_vdev_stopped(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_STOPPED_EVENTID\n");
 	complete(&ar->vdev_setup_done);
@@ -1641,8 +1637,7 @@ ath10k_wmi_op_pull_peer_kick_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar,
-					      struct sk_buff *skb)
+void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_peer_kick_ev_arg arg = {};
 	struct ieee80211_sta *sta;
@@ -1921,7 +1916,7 @@ static int ath10k_wmi_op_pull_swba_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_swba_ev_arg arg = {};
 	u32 map;
@@ -2040,8 +2035,7 @@ skip:
 	}
 }
 
-static void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar,
-					       struct sk_buff *skb)
+void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TBTTOFFSET_UPDATE_EVENTID\n");
 }
@@ -2162,9 +2156,9 @@ static int ath10k_dfs_fft_report(struct ath10k *ar,
 	return 0;
 }
 
-static void ath10k_wmi_event_dfs(struct ath10k *ar,
-				 const struct wmi_phyerr *phyerr,
-				 u64 tsf)
+void ath10k_wmi_event_dfs(struct ath10k *ar,
+			  const struct wmi_phyerr *phyerr,
+			  u64 tsf)
 {
 	int buf_len, tlv_len, res, i = 0;
 	const struct phyerr_tlv *tlv;
@@ -2227,10 +2221,9 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
 	}
 }
 
-static void
-ath10k_wmi_event_spectral_scan(struct ath10k *ar,
-			       const struct wmi_phyerr *phyerr,
-			       u64 tsf)
+void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
+				    const struct wmi_phyerr *phyerr,
+				    u64 tsf)
 {
 	int buf_len, tlv_len, res, i = 0;
 	struct phyerr_tlv *tlv;
@@ -2299,7 +2292,7 @@ static int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_phyerr_ev_arg arg = {};
 	const struct wmi_phyerr *phyerr;
@@ -2368,19 +2361,17 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 	}
 }
 
-static void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_ROAM_EVENTID\n");
 }
 
-static void ath10k_wmi_event_profile_match(struct ath10k *ar,
-					   struct sk_buff *skb)
+void ath10k_wmi_event_profile_match(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PROFILE_MATCH\n");
 }
 
-static void ath10k_wmi_event_debug_print(struct ath10k *ar,
-					 struct sk_buff *skb)
+void ath10k_wmi_event_debug_print(struct ath10k *ar, struct sk_buff *skb)
 {
 	char buf[101], c;
 	int i;
@@ -2413,103 +2404,90 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug print '%s'\n", buf);
 }
 
-static void ath10k_wmi_event_pdev_qvit(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_pdev_qvit(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_QVIT_EVENTID\n");
 }
 
-static void ath10k_wmi_event_wlan_profile_data(struct ath10k *ar,
-					       struct sk_buff *skb)
+void ath10k_wmi_event_wlan_profile_data(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_WLAN_PROFILE_DATA_EVENTID\n");
 }
 
-static void ath10k_wmi_event_rtt_measurement_report(struct ath10k *ar,
-						    struct sk_buff *skb)
+void ath10k_wmi_event_rtt_measurement_report(struct ath10k *ar,
+					     struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_RTT_MEASUREMENT_REPORT_EVENTID\n");
 }
 
-static void ath10k_wmi_event_tsf_measurement_report(struct ath10k *ar,
-						    struct sk_buff *skb)
+void ath10k_wmi_event_tsf_measurement_report(struct ath10k *ar,
+					     struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TSF_MEASUREMENT_REPORT_EVENTID\n");
 }
 
-static void ath10k_wmi_event_rtt_error_report(struct ath10k *ar,
-					      struct sk_buff *skb)
+void ath10k_wmi_event_rtt_error_report(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_RTT_ERROR_REPORT_EVENTID\n");
 }
 
-static void ath10k_wmi_event_wow_wakeup_host(struct ath10k *ar,
-					     struct sk_buff *skb)
+void ath10k_wmi_event_wow_wakeup_host(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_WOW_WAKEUP_HOST_EVENTID\n");
 }
 
-static void ath10k_wmi_event_dcs_interference(struct ath10k *ar,
-					      struct sk_buff *skb)
+void ath10k_wmi_event_dcs_interference(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_DCS_INTERFERENCE_EVENTID\n");
 }
 
-static void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar,
-					     struct sk_buff *skb)
+void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_TPC_CONFIG_EVENTID\n");
 }
 
-static void ath10k_wmi_event_pdev_ftm_intg(struct ath10k *ar,
-					   struct sk_buff *skb)
+void ath10k_wmi_event_pdev_ftm_intg(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_FTM_INTG_EVENTID\n");
 }
 
-static void ath10k_wmi_event_gtk_offload_status(struct ath10k *ar,
-						struct sk_buff *skb)
+void ath10k_wmi_event_gtk_offload_status(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_GTK_OFFLOAD_STATUS_EVENTID\n");
 }
 
-static void ath10k_wmi_event_gtk_rekey_fail(struct ath10k *ar,
-					    struct sk_buff *skb)
+void ath10k_wmi_event_gtk_rekey_fail(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_GTK_REKEY_FAIL_EVENTID\n");
 }
 
-static void ath10k_wmi_event_delba_complete(struct ath10k *ar,
-					    struct sk_buff *skb)
+void ath10k_wmi_event_delba_complete(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TX_DELBA_COMPLETE_EVENTID\n");
 }
 
-static void ath10k_wmi_event_addba_complete(struct ath10k *ar,
-					    struct sk_buff *skb)
+void ath10k_wmi_event_addba_complete(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TX_ADDBA_COMPLETE_EVENTID\n");
 }
 
-static void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
-						       struct sk_buff *skb)
+void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
+						struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
 }
 
-static void ath10k_wmi_event_inst_rssi_stats(struct ath10k *ar,
-					     struct sk_buff *skb)
+void ath10k_wmi_event_inst_rssi_stats(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_INST_RSSI_STATS_EVENTID\n");
 }
 
-static void ath10k_wmi_event_vdev_standby_req(struct ath10k *ar,
-					      struct sk_buff *skb)
+void ath10k_wmi_event_vdev_standby_req(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_STANDBY_REQ_EVENTID\n");
 }
 
-static void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar,
-					     struct sk_buff *skb)
+void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_RESUME_REQ_EVENTID\n");
 }
@@ -2618,8 +2596,7 @@ ath10k_wmi_10x_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_service_ready(struct ath10k *ar,
-					   struct sk_buff *skb)
+void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_svc_rdy_ev_arg arg = {};
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
@@ -2744,7 +2721,7 @@ static int ath10k_wmi_op_pull_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
+int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_rdy_ev_arg arg = {};
 	int ret;
@@ -3265,8 +3242,8 @@ ath10k_wmi_op_gen_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 	return skb;
 }
 
-static void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
-					   struct wmi_host_mem_chunks *chunks)
+void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
+				    struct wmi_host_mem_chunks *chunks)
 {
 	struct host_memory_chunk *chunk;
 	int i;
@@ -3493,7 +3470,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	return buf;
 }
 
-static int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
+int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
 {
 	if (arg->ie_len && !arg->ie)
 		return -EINVAL;
@@ -3544,9 +3521,8 @@ ath10k_wmi_start_scan_tlvs_len(const struct wmi_start_scan_arg *arg)
 	return len;
 }
 
-static void
-ath10k_wmi_put_start_scan_common(struct wmi_start_scan_common *cmn,
-				 const struct wmi_start_scan_arg *arg)
+void ath10k_wmi_put_start_scan_common(struct wmi_start_scan_common *cmn,
+				      const struct wmi_start_scan_arg *arg)
 {
 	u32 scan_id;
 	u32 scan_req_id;
@@ -4424,8 +4400,8 @@ ath10k_wmi_op_gen_beacon_dma(struct ath10k_vif *arvif)
 	return skb;
 }
 
-static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
-					  const struct wmi_wmm_params_arg *arg)
+void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
+				   const struct wmi_wmm_params_arg *arg)
 {
 	params->cwmin  = __cpu_to_le32(arg->cwmin);
 	params->cwmax  = __cpu_to_le32(arg->cwmax);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 8483f53..9c2d0d0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4639,12 +4639,15 @@ struct wmi_rdy_ev_arg {
 
 struct ath10k;
 struct ath10k_vif;
+struct ath10k_fw_stats_pdev;
+struct ath10k_fw_stats_peer;
 
 int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar);
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
 
+struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len);
 int ath10k_wmi_connect(struct ath10k *ar);
 
 struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len);
@@ -4653,4 +4656,62 @@ int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
 			       u32 cmd_id);
 void ath10k_wmi_start_scan_init(struct ath10k *ar, struct wmi_start_scan_arg *);
 
+void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
+				struct ath10k_fw_stats_pdev *dst);
+void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
+				struct ath10k_fw_stats_peer *dst);
+void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
+				    struct wmi_host_mem_chunks *chunks);
+void ath10k_wmi_put_start_scan_common(struct wmi_start_scan_common *cmn,
+				      const struct wmi_start_scan_arg *arg);
+void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
+				   const struct wmi_wmm_params_arg *arg);
+void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
+				const struct wmi_channel_arg *arg);
+int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg);
+
+int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_update_stats(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_vdev_stopped(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_dfs(struct ath10k *ar,
+			  const struct wmi_phyerr *phyerr, u64 tsf);
+void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
+				    const struct wmi_phyerr *phyerr,
+				    u64 tsf);
+void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_profile_match(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_debug_print(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_pdev_qvit(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_wlan_profile_data(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_rtt_measurement_report(struct ath10k *ar,
+					     struct sk_buff *skb);
+void ath10k_wmi_event_tsf_measurement_report(struct ath10k *ar,
+					     struct sk_buff *skb);
+void ath10k_wmi_event_rtt_error_report(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_wow_wakeup_host(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_dcs_interference(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_pdev_ftm_intg(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_gtk_offload_status(struct ath10k *ar,
+					 struct sk_buff *skb);
+void ath10k_wmi_event_gtk_rekey_fail(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_delba_complete(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_addba_complete(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
+						struct sk_buff *skb);
+void ath10k_wmi_event_inst_rssi_stats(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_vdev_standby_req(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb);
+
 #endif /* _WMI_H_ */
-- 
1.8.5.3

