Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36044 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3IYKiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:38:10 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so2154018bkj.33
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2013 03:38:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 25 Sep 2013 12:38:08 +0200
Message-ID: <CA+BoTQnPyZ-c2j62zsUSR+h03dvyxFOkoUME3H6qO0sQTGWqrg@mail.gmail.com> (sfid-20130925_123815_203389_A8470304)
Subject: Re: [PATCH 01/13] ath10k: introduce dynamic WMI structures
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2013 11:37, Bartosz Markowski
<bartosz.markowski@tieto.com> wrote:

> +struct wmi_cmd_map {
> +       u32 wmi_init_cmdid;
> +       u32 wmi_start_scan_cmdid;
> +       u32 wmi_stop_scan_cmdid;
> +       u32 wmi_scan_chan_list_cmdid;
> +       u32 wmi_scan_sch_prio_tbl_cmdid;
> +       u32 wmi_pdev_set_regdomain_cmdid;
> +       u32 wmi_pdev_set_channel_cmdid;
> +       u32 wmi_pdev_set_param_cmdid;
> +       u32 wmi_pdev_pktlog_enable_cmdid;
> +       u32 wmi_pdev_pktlog_disable_cmdid;
> +       u32 wmi_pdev_set_wmm_params_cmdid;
> +       u32 wmi_pdev_set_ht_cap_ie_cmdid;
> +       u32 wmi_pdev_set_vht_cap_ie_cmdid;
> +       u32 wmi_pdev_set_dscp_tid_map_cmdid;
> +       u32 wmi_pdev_set_quiet_mode_cmdid;
> +       u32 wmi_pdev_green_ap_ps_enable_cmdid;
> +       u32 wmi_pdev_get_tpc_config_cmdid;
> +       u32 wmi_pdev_set_base_macaddr_cmdid;
> +       u32 wmi_vdev_create_cmdid;
> +       u32 wmi_vdev_delete_cmdid;
> +       u32 wmi_vdev_start_request_cmdid;
> +       u32 wmi_vdev_restart_request_cmdid;
> +       u32 wmi_vdev_up_cmdid;
> +       u32 wmi_vdev_stop_cmdid;
> +       u32 wmi_vdev_down_cmdid;
> +       u32 wmi_vdev_set_param_cmdid;
> +       u32 wmi_vdev_install_key_cmdid;
> +       u32 wmi_peer_create_cmdid;
> +       u32 wmi_peer_delete_cmdid;
> +       u32 wmi_peer_flush_tids_cmdid;
> +       u32 wmi_peer_set_param_cmdid;
> +       u32 wmi_peer_assoc_cmdid;
> +       u32 wmi_peer_add_wds_entry_cmdid;
> +       u32 wmi_peer_remove_wds_entry_cmdid;
> +       u32 wmi_peer_mcast_group_cmdid;
> +       u32 wmi_bcn_tx_cmdid;
> +       u32 wmi_pdev_send_bcn_cmdid;
> +       u32 wmi_bcn_tmpl_cmdid;
> +       u32 wmi_bcn_filter_rx_cmdid;
> +       u32 wmi_prb_req_filter_rx_cmdid;
> +       u32 wmi_mgmt_tx_cmdid;
> +       u32 wmi_prb_tmpl_cmdid;
> +       u32 wmi_addba_clear_resp_cmdid;
> +       u32 wmi_addba_send_cmdid;
> +       u32 wmi_addba_status_cmdid;
> +       u32 wmi_delba_send_cmdid;
> +       u32 wmi_addba_set_resp_cmdid;
> +       u32 wmi_send_singleamsdu_cmdid;
> +       u32 wmi_sta_powersave_mode_cmdid;
> +       u32 wmi_sta_powersave_param_cmdid;
> +       u32 wmi_sta_mimo_ps_mode_cmdid;
> +       u32 wmi_pdev_dfs_enable_cmdid;
> +       u32 wmi_pdev_dfs_disable_cmdid;
> +       u32 wmi_roam_scan_mode;
> +       u32 wmi_roam_scan_rssi_threshold;
> +       u32 wmi_roam_scan_period;
> +       u32 wmi_roam_scan_rssi_change_threshold;
> +       u32 wmi_roam_ap_profile;
> +       u32 wmi_ofl_scan_add_ap_profile;
> +       u32 wmi_ofl_scan_remove_ap_profile;
> +       u32 wmi_ofl_scan_period;
> +       u32 wmi_p2p_dev_set_device_info;
> +       u32 wmi_p2p_dev_set_discoverability;
> +       u32 wmi_p2p_go_set_beacon_ie;
> +       u32 wmi_p2p_go_set_probe_resp_ie;
> +       u32 wmi_p2p_set_vendor_ie_data_cmdid;
> +       u32 wmi_ap_ps_peer_param_cmdid;
> +       u32 wmi_ap_ps_peer_uapsd_coex_cmdid;
> +       u32 wmi_peer_rate_retry_sched_cmdid;
> +       u32 wmi_wlan_profile_trigger_cmdid;
> +       u32 wmi_wlan_profile_set_hist_intvl_cmdid;
> +       u32 wmi_wlan_profile_get_profile_data_cmdid;
> +       u32 wmi_wlan_profile_enable_profile_id_cmdid;
> +       u32 wmi_wlan_profile_list_profile_id_cmdid;
> +       u32 wmi_pdev_suspend_cmdid;
> +       u32 wmi_pdev_resume_cmdid;
> +       u32 wmi_add_bcn_filter_cmdid;
> +       u32 wmi_rmv_bcn_filter_cmdid;
> +       u32 wmi_wow_add_wake_pattern_cmdid;
> +       u32 wmi_wow_del_wake_pattern_cmdid;
> +       u32 wmi_wow_enable_disable_wake_event_cmdid;
> +       u32 wmi_wow_enable_cmdid;
> +       u32 wmi_wow_hostwakeup_from_sleep_cmdid;
> +       u32 wmi_rtt_measreq_cmdid;
> +       u32 wmi_rtt_tsf_cmdid;
> +       u32 wmi_vdev_spectral_scan_configure_cmdid;
> +       u32 wmi_vdev_spectral_scan_enable_cmdid;
> +       u32 wmi_request_stats_cmdid;
> +       u32 wmi_set_arp_ns_offload_cmdid;
> +       u32 wmi_network_list_offload_config_cmdid;
> +       u32 wmi_gtk_offload_cmdid;
> +       u32 wmi_csa_offload_enable_cmdid;
> +       u32 wmi_csa_offload_chanswitch_cmdid;
> +       u32 wmi_chatter_set_mode_cmdid;
> +       u32 wmi_peer_tid_addba_cmdid;
> +       u32 wmi_peer_tid_delba_cmdid;
> +       u32 wmi_sta_dtim_ps_method_cmdid;
> +       u32 wmi_sta_uapsd_auto_trig_cmdid;
> +       u32 wmi_sta_keepalive_cmd;
> +       u32 wmi_echo_cmdid;
> +       u32 wmi_pdev_utf_cmdid;
> +       u32 wmi_dbglog_cfg_cmdid;
> +       u32 wmi_pdev_qvit_cmdid;
> +       u32 wmi_pdev_ftm_intg_cmdid;
> +       u32 wmi_vdev_set_keepalive_cmdid;
> +       u32 wmi_vdev_get_keepalive_cmdid;
> +       u32 wmi_force_fw_hang_cmdid;
> +       u32 wmi_gpio_config_cmdid;
> +       u32 wmi_gpio_output_cmdid;

I don't think the `wmi_` prefix is necessary here. Structure itself
already provides a prefix.


Michał.
