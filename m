Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41565 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaK0JXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 04:23:52 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so15074643wib.10
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 01:23:50 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 6/7] ath10k: make some wmi functions public
Date: Thu, 27 Nov 2014 10:11:20 +0100
Message-Id: <1417079481-22255-7-git-send-email-michal.kazior@tieto.com> (sfid-20141127_102413_987035_70B95846)
In-Reply-To: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
References: <1417079481-22255-1-git-send-email-michal.kazior@tieto.com>
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
index 0f3c410..e2dbe39 100644
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
 
@@ -987,7 +986,7 @@ static int ath10k_wmi_op_pull_scan_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
+int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_scan_ev_arg arg = {};
 	enum wmi_scan_event_type event_type;
@@ -1206,7 +1205,7 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
+int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_ev_arg arg = {};
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -1359,7 +1358,7 @@ static int ath10k_wmi_op_pull_ch_info_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_ch_info_ev_arg arg = {};
 	struct survey_info *survey;
@@ -1427,12 +1426,12 @@ exit:
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
@@ -1442,8 +1441,8 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
-				       struct ath10k_fw_stats_pdev *dst)
+void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
+				struct ath10k_fw_stats_pdev *dst)
 {
 	const struct wal_dbg_tx_stats *tx = &src->wal.tx;
 	const struct wal_dbg_rx_stats *rx = &src->wal.rx;
@@ -1495,8 +1494,8 @@ static void ath10k_wmi_pull_pdev_stats(const struct wmi_pdev_stats *src,
 	dst->mpdu_errs = __le32_to_cpu(rx->mpdu_errs);
 }
 
-static void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
-				       struct ath10k_fw_stats_peer *dst)
+void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
+				struct ath10k_fw_stats_peer *dst)
 {
 	ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
 	dst->peer_rssi = __le32_to_cpu(src->peer_rssi);
@@ -1618,8 +1617,7 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
-static void ath10k_wmi_event_update_stats(struct ath10k *ar,
-					  struct sk_buff *skb)
+void ath10k_wmi_event_update_stats(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_UPDATE_STATS_EVENTID\n");
 	ath10k_debug_fw_stats_process(ar, skb);
@@ -1643,8 +1641,7 @@ ath10k_wmi_op_pull_vdev_start_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
-					     struct sk_buff *skb)
+void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_vdev_start_ev_arg arg = {};
 	int ret;
@@ -1663,8 +1660,7 @@ static void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar,
 	complete(&ar->vdev_setup_done);
 }
 
-static void ath10k_wmi_event_vdev_stopped(struct ath10k *ar,
-					  struct sk_buff *skb)
+void ath10k_wmi_event_vdev_stopped(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_STOPPED_EVENTID\n");
 	complete(&ar->vdev_setup_done);
@@ -1685,8 +1681,7 @@ ath10k_wmi_op_pull_peer_kick_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar,
-					      struct sk_buff *skb)
+void ath10k_wmi_event_peer_sta_kickout(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_peer_kick_ev_arg arg = {};
 	struct ieee80211_sta *sta;
@@ -1965,7 +1960,7 @@ static int ath10k_wmi_op_pull_swba_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_swba_ev_arg arg = {};
 	u32 map;
@@ -2086,8 +2081,7 @@ skip:
 	}
 }
 
-static void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar,
-					       struct sk_buff *skb)
+void ath10k_wmi_event_tbttoffset_update(struct ath10k *ar, struct sk_buff *skb)
 {
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_TBTTOFFSET_UPDATE_EVENTID\n");
 }
@@ -2208,9 +2202,9 @@ static int ath10k_dfs_fft_report(struct ath10k *ar,
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
@@ -2273,10 +2267,9 @@ static void ath10k_wmi_event_dfs(struct ath10k *ar,
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
@@ -2345,7 +2338,7 @@ static int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_phyerr_ev_arg arg = {};
 	const struct wmi_phyerr *phyerr;
@@ -2414,19 +2407,17 @@ static void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
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
@@ -2459,103 +2450,90 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
 	ath10k_dbg(ar, ATH10K_DBG_WMI_PRINT, "wmi print '%s'\n", buf);
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
@@ -2664,8 +2642,7 @@ ath10k_wmi_10x_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_event_service_ready(struct ath10k *ar,
-					   struct sk_buff *skb)
+void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_svc_rdy_ev_arg arg = {};
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
@@ -2790,7 +2767,7 @@ static int ath10k_wmi_op_pull_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
+int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_rdy_ev_arg arg = {};
 	int ret;
@@ -3311,8 +3288,8 @@ ath10k_wmi_op_gen_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 	return skb;
 }
 
-static void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
-					   struct wmi_host_mem_chunks *chunks)
+void ath10k_wmi_put_host_mem_chunks(struct ath10k *ar,
+				    struct wmi_host_mem_chunks *chunks)
 {
 	struct host_memory_chunk *chunk;
 	int i;
@@ -3539,7 +3516,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	return buf;
 }
 
-static int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
+int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
 {
 	if (arg->ie_len && !arg->ie)
 		return -EINVAL;
@@ -3590,9 +3567,8 @@ ath10k_wmi_start_scan_tlvs_len(const struct wmi_start_scan_arg *arg)
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
@@ -4470,8 +4446,8 @@ ath10k_wmi_op_gen_beacon_dma(struct ath10k_vif *arvif)
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
index b8308f6..bdb87dd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4644,12 +4644,15 @@ struct wmi_rdy_ev_arg {
 
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
@@ -4658,4 +4661,62 @@ int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
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

